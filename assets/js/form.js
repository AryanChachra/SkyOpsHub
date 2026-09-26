/* SkyOpsHub — early-access form. Posts to the Google Apps Script webhook in scripts/google_apps_script/. */
(function () {
  'use strict';
  // Deployed Apps Script web-app URL (see scripts/google_apps_script/README.md to redeploy).
  var WEBHOOK = 'https://script.google.com/macros/s/AKfycbzTe3F0JHax72WBZqznkp-Wiq79b6l69u54xf_ATJmKnD77qXBMV4g_7glB8GKugo6v/exec';
  var FALLBACK_EMAIL = 'admin@skyopshub.in';
  var EMAIL_RE = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;

  document.querySelectorAll('[data-access-form]').forEach(function (form) {
    var msg = form.querySelector('[data-form-msg]');
    var btn = form.querySelector('[data-submit]');

    function fieldOf(name) { return form.querySelector('[name="' + name + '"]'); }
    function setError(name, text) {
      var input = fieldOf(name); if (!input) return;
      var wrap = input.closest('.field');
      var err = wrap.querySelector('.field__err');
      if (text) {
        wrap.classList.add('is-bad');
        input.setAttribute('aria-invalid', 'true');
        if (!err) { err = document.createElement('span'); err.className = 'field__err'; err.id = name + '-err'; wrap.appendChild(err); }
        input.setAttribute('aria-describedby', err.id);
        err.textContent = text;
      } else {
        wrap.classList.remove('is-bad');
        input.removeAttribute('aria-invalid');
        if (err) err.remove();
      }
    }
    function validate() {
      var ok = true, first = null;
      var name = fieldOf('name').value.trim();
      var email = fieldOf('workEmail').value.trim();
      var company = fieldOf('companyName').value.trim();
      if (!name) { setError('name', 'Tell us your name.'); ok = false; first = first || 'name'; } else setError('name');
      if (!email) { setError('workEmail', 'We need an email to reply to.'); ok = false; first = first || 'workEmail'; }
      else if (!EMAIL_RE.test(email)) { setError('workEmail', 'That email doesn’t look right.'); ok = false; first = first || 'workEmail'; }
      else setError('workEmail');
      if (!company) { setError('companyName', 'Which airline or company?'); ok = false; first = first || 'companyName'; } else setError('companyName');
      if (first) fieldOf(first).focus();
      return ok;
    }
    ['name', 'workEmail', 'companyName'].forEach(function (n) {
      var el = fieldOf(n);
      if (el) el.addEventListener('input', function () { if (el.closest('.field').classList.contains('is-bad')) validate(); });
    });

    form.addEventListener('submit', function (e) {
      e.preventDefault();
      msg.textContent = ''; msg.className = 'form__msg mono';
      if (!validate()) return;
      var hp = fieldOf('website');
      var role = (fieldOf('role') || {}).value || '';
      var text = (fieldOf('message') || {}).value || '';
      var body = new URLSearchParams();
      body.set('name', fieldOf('name').value.trim());
      body.set('workEmail', fieldOf('workEmail').value.trim());
      body.set('companyName', fieldOf('companyName').value.trim());
      body.set('message', (role ? 'Team: ' + role + '\n\n' : '') + text.trim() + '\n\n[source: skyopshub.in early access]');

      function done() {
        form.classList.add('is-sent');
        btn.classList.remove('is-loading');
        btn.firstChild.textContent = 'Request sent ';
        msg.className = 'form__msg mono ok';
        msg.textContent = 'Thanks. We’ll reply within 24–48 hours.';
      }
      function fail(reason) {
        btn.classList.remove('is-loading');
        btn.disabled = false;
        msg.className = 'form__msg mono';
        msg.innerHTML = (reason || 'We couldn’t send that just now.') + ' Email <a class="link" href="mailto:' + FALLBACK_EMAIL + '?subject=SkyOpsHub%20early%20access">' + FALLBACK_EMAIL + '</a> instead.';
      }
      if (hp && hp.value) { done(); return; } // bot trap
      if (window.SKY_PREVIEW) {
        msg.className = 'form__msg mono ok';
        msg.textContent = 'Preview copy: nothing was sent. On the live site this goes to the early-access inbox.';
        return;
      }

      btn.classList.add('is-loading'); btn.disabled = true;
      msg.textContent = 'Sending…';
      fetch(WEBHOOK, { method: 'POST', body: body })
        .then(function (r) {
          if (!r.ok) throw new Error('status ' + r.status);
          return r.text().then(function (t) {
            try { var j = JSON.parse(t); if (j && j.ok === false) { fail(j.message ? j.message + '.' : null); return; } } catch (_) { /* non-JSON is fine */ }
            done();
          });
        })
        .catch(function () {
          // Apps Script sometimes answers through a redirect the browser won't expose; retry opaquely.
          fetch(WEBHOOK, { method: 'POST', body: body, mode: 'no-cors' }).then(done).catch(function () { fail(); });
        });
    });
  });
})();
