/* SkyOpsHub — section demos: stepper, shortfall loop, roster validator, import review, jobs, roles, status board. */
(function () {
  'use strict';
  var reduce = (window.SKY && window.SKY.reduce) || false;
  var onVisible = (window.SKY && window.SKY.onVisible) || function (el, fn) { fn(true); };

  function tabs(root, tabSel, panelSel, opts) {
    var tabsEls = Array.prototype.slice.call(root.querySelectorAll(tabSel));
    var panels = Array.prototype.slice.call(root.querySelectorAll(panelSel));
    function select(i, focus) {
      tabsEls.forEach(function (t, k) {
        var on = k === i;
        t.setAttribute('aria-selected', String(on));
        t.tabIndex = on ? 0 : -1;
        if (on && focus) t.focus();
      });
      panels.forEach(function (p, k) {
        var on = k === i;
        p.hidden = !on;
        p.classList.toggle('is-active', on);
      });
      if (opts && opts.onSelect) opts.onSelect(i);
    }
    tabsEls.forEach(function (t, i) {
      t.addEventListener('click', function () { select(i); if (opts && opts.onUser) opts.onUser(i); });
      t.addEventListener('keydown', function (e) {
        var n = tabsEls.length, j = null;
        if (e.key === 'ArrowDown' || e.key === 'ArrowRight') j = (i + 1) % n;
        if (e.key === 'ArrowUp' || e.key === 'ArrowLeft') j = (i - 1 + n) % n;
        if (e.key === 'Home') j = 0;
        if (e.key === 'End') j = n - 1;
        if (j !== null) { e.preventDefault(); select(j, true); if (opts && opts.onUser) opts.onUser(j); }
      });
    });
    return { select: select, count: tabsEls.length, current: function () { return tabsEls.findIndex(function (t) { return t.getAttribute('aria-selected') === 'true'; }); } };
  }

  /* ---------------- How it works: auto-advancing stepper ---------------- */
  var stepper = document.querySelector('[data-stepper]');
  if (stepper) {
    var stageTitle = stepper.querySelector('[data-stage-title]');
    var panelsEls = stepper.querySelectorAll('.panel');
    var ctl = tabs(stepper, '.step', '.panel', {
      onSelect: function (i) { if (stageTitle) stageTitle.textContent = panelsEls[i].getAttribute('data-title') || ''; }
    });
    ctl.select(0);
    if (!reduce) {
      stepper.addEventListener('animationend', function (e) {
        if (e.animationName !== 'stepfill') return;
        ctl.select((ctl.current() + 1) % ctl.count);
      });
      var hovering = false, visible = false;
      function setPause() { stepper.classList.toggle('is-paused', hovering || !visible); }
      stepper.addEventListener('mouseenter', function () { hovering = true; setPause(); });
      stepper.addEventListener('mouseleave', function () { hovering = false; setPause(); });
      stepper.addEventListener('focusin', function () { hovering = true; setPause(); });
      stepper.addEventListener('focusout', function () { hovering = false; setPause(); });
      onVisible(stepper, function (v) { visible = v; setPause(); }, { threshold: 0, rootMargin: '-25% 0px -25% 0px' });
    } else {
      stepper.classList.add('is-paused');
    }
  }

  /* ---------------- Shortfall conversation ---------------- */
  var loop = document.querySelector('[data-loop]');
  if (loop) {
    var msgs = Array.prototype.slice.call(loop.querySelectorAll('.msg'));
    var timers = [];
    var played = false;
    function play() {
      timers.forEach(clearTimeout); timers = [];
      msgs.forEach(function (m) { m.classList.remove('show', 'typing'); });
      if (reduce) { msgs.forEach(function (m) { m.classList.add('show'); }); return; }
      var t = 200;
      msgs.forEach(function (m) {
        timers.push(setTimeout(function () { m.classList.add('show', 'typing'); }, t));
        t += 900;
        timers.push(setTimeout(function () { m.classList.remove('typing'); }, t));
        t += 900;
      });
    }
    onVisible(loop, function (v) { if (v && !played) { played = true; play(); } }, { threshold: 0, rootMargin: '0px 0px -30% 0px' });
    var rp = loop.querySelector('[data-loop-replay]');
    if (rp) rp.addEventListener('click', play);
  }

  /* ---------------- Roster validator ---------------- */
  var roster = document.querySelector('[data-roster]');
  if (roster) {
    // times: minutes from Wed 07 Oct 00:00
    var FLIGHTS = [
      { id: 'SKY 101', o: 'DEL', d: 'BOM', dep: 435, arr: 565 },
      { id: 'SKY 214', o: 'BOM', d: 'BLR', dep: 640, arr: 745 },
      { id: 'SKY 377', o: 'BLR', d: 'DEL', dep: 845, arr: 1010 },
      { id: 'SKY 590', o: 'DEL', d: 'GOI', dep: 1390, arr: 1545 }
    ];
    var CREW = [
      { id: 'mehra', name: 'A. Mehra', at: 'DEL', rating: 'A320', ratingLabel: 'A320', lastOff: -5, nights: 0, medical: 99999, note: 'Off 23:55 last night' },
      { id: 'iyer', name: 'R. Iyer', at: 'BLR', rating: 'B738', ratingLabel: '737‑800', lastOff: -600, nights: 0, medical: 99999, note: 'Rested' },
      { id: 'khan', name: 'S. Khan', at: 'BOM', rating: 'A320', ratingLabel: 'A320', lastOff: -540, nights: 0, medical: 99999, note: 'Based Mumbai' },
      { id: 'das', name: 'N. Das', at: 'DEL', rating: 'A320', ratingLabel: 'A320', lastOff: -1220, nights: 2, medical: 99999, note: 'Nights 05, 06 Oct' },
      { id: 'nair', name: 'P. Nair', at: 'DEL', rating: 'A320', ratingLabel: 'A320', lastOff: -900, nights: 0, medical: 1439, note: 'Medical to 07 Oct' }
    ];
    var MIN_REST = 720, TURN = 30, SAME_DUTY_GAP = 240;
    var FDP = { 1: 780, 2: 780, 3: 750, 4: 720, 5: 690, 6: 660 }, NIGHT_FDP = 600, NIGHT_LANDINGS = 2, MAX_NIGHTS = 2;
    var assign = [null, null, null, null];

    function hhmm(m) {
      var day = Math.floor(m / 1440), r = ((m % 1440) + 1440) % 1440;
      var s = String(Math.floor(r / 60)).padStart(2, '0') + ':' + String(r % 60).padStart(2, '0');
      return s + (day > 0 ? ' +1' : day < 0 ? ' −1' : '');
    }
    function dateStamp(m) {
      var day = Math.floor(m / 1440), r = ((m % 1440) + 1440) % 1440;
      return String(7 + day).padStart(2, '0') + ' Oct ' + String(Math.floor(r / 60)).padStart(2, '0') + ':' + String(r % 60).padStart(2, '0');
    }
    function dur(m) { var h = Math.floor(m / 60), r = m % 60; return h + ' h' + (r ? ' ' + String(r).padStart(2, '0') + ' m' : ''); }
    function isNight(rep, end) {
      // encroaches 00:00–06:00 on either day in the duty span
      for (var day = -1; day <= 1; day++) {
        var a = day * 1440, b = day * 1440 + 360;
        if (rep < b && end > a) return true;
      }
      return false;
    }

    function evaluate() {
      var verdicts = [null, null, null, null];
      CREW.forEach(function (c) {
        var mine = [];
        assign.forEach(function (cid, fi) { if (cid === c.id) mine.push(fi); });
        mine.sort(function (a, b) { return FLIGHTS[a].dep - FLIGHTS[b].dep; });
        // group into duties
        var duties = [];
        mine.forEach(function (fi) {
          var f = FLIGHTS[fi], last = duties[duties.length - 1];
          if (last && f.dep - FLIGHTS[last[last.length - 1]].arr <= SAME_DUTY_GAP) last.push(fi);
          else duties.push([fi]);
        });
        var loc = c.at, prevEnd = c.lastOff, nights = c.nights;
        duties.forEach(function (duty) {
          var first = FLIGHTS[duty[0]], lastF = FLIGHTS[duty[duty.length - 1]];
          var rep = first.dep - 60, end = lastF.arr + 30, fdp = end - rep, night = isNight(rep, end);
          var rest = rep - prevEnd;
          duty.forEach(function (fi, k) {
            var f = FLIGHTS[fi], fails = [], okBits = [];
            if (c.rating !== 'A320') fails.push({ r: 'rating', t: 'Rated on ' + c.ratingLabel + '. ' + f.id + ' is an A320 sector.' });
            if (loc !== f.o) fails.push({ r: 'loc', t: 'At ' + loc + ' when ' + f.id + ' departs ' + f.o + ', and no positioning sector is planned.' });
            if (k > 0) {
              var prev = FLIGHTS[duty[k - 1]];
              if (f.dep - prev.arr < TURN) fails.push({ r: 'loc', t: 'Lands ' + prev.id + ' at ' + hhmm(prev.arr) + ', too late to turn for ' + f.id + '.' });
            }
            if (k === 0 && rest < MIN_REST) fails.push({ r: 'rest', t: 'Rest before this duty would be ' + dur(rest) + ' (off duty ' + dateStamp(prevEnd) + '). Minimum is 12 h.' });
            var cap = night ? NIGHT_FDP : (FDP[duty.length] || 660);
            if (fdp > cap) fails.push({ r: 'fdp', t: 'Duty would run ' + dur(fdp) + '. Limit for ' + duty.length + ' landing' + (duty.length > 1 ? 's' : '') + (night ? ' at night' : '') + ' is ' + dur(cap) + '.' });
            if (night && duty.length > NIGHT_LANDINGS) fails.push({ r: 'night', t: 'Night duty with ' + duty.length + ' landings. Maximum is 2.' });
            if (night && nights + 1 > MAX_NIGHTS) fails.push({ r: 'night', t: 'Would be a 3rd night duty in a row (05 and 06 Oct already flown). Maximum is 2.' });
            if (c.medical < end) fails.push({ r: 'med', t: 'Medical valid to ' + dateStamp(c.medical) + ', but this duty ends ' + dateStamp(end) + '. Checked against the duty, not today.' });
            if (!fails.length) {
              okBits.push('A320 rated', 'at ' + f.o);
              if (k === 0) okBits.push(dur(rest) + ' rest'); else okBits.push('continues duty from ' + FLIGHTS[duty[k - 1]].id);
              okBits.push('duty ' + dur(fdp) + ' of ' + dur(cap));
            }
            verdicts[fi] = { crew: c, ok: !fails.length, fails: fails, okBits: okBits };
            loc = f.d;
          });
          prevEnd = end;
          if (night) nights += 1; else nights = 0;
        });
      });
      return verdicts;
    }

    var table = roster.querySelector('[data-roster-table]');
    var out = roster.querySelector('[data-roster-out]');
    var score = roster.querySelector('[data-roster-score]');
    var html = '<div class="rgrid"><div class="rh">Flight · Wed 07 Oct</div>';
    CREW.forEach(function (c) { html += '<div class="rh"><b>' + c.name + '</b>' + c.at + ' · ' + c.ratingLabel + '<span class="rh__note"><br>' + c.note + '</span></div>'; });
    html += '</div><div class="roster__legend">' + CREW.map(function (c) { return '<span><b>' + c.name + '</b> · ' + c.at + ' · ' + c.ratingLabel + ' · ' + c.note + '</span>'; }).join('') + '</div>';
    table.innerHTML = html;
    var grid = table.querySelector('.rgrid');
    grid.style.setProperty('--cols', CREW.length);
    var cells = [];
    FLIGHTS.forEach(function (f, fi) {
      var night = isNight(f.dep - 60, f.arr + 30);
      var fc = document.createElement('div');
      fc.className = 'rf';
      fc.innerHTML = '<b>' + f.id + '</b><span>' + f.o + '→' + f.d + '</span><span' + (night ? ' class="night"' : '') + '>' + hhmm(f.dep) + '–' + hhmm(f.arr) + (night ? ' · night' : '') + '</span>';
      grid.appendChild(fc);
      cells[fi] = [];
      CREW.forEach(function (c) {
        var b = document.createElement('button');
        b.type = 'button'; b.className = 'rc';
        b.setAttribute('aria-pressed', 'false');
        b.setAttribute('aria-label', 'Assign ' + c.name + ' to ' + f.id);
        b.innerHTML = '<span class="cn" aria-hidden="true">' + c.name.split(' ').pop() + '</span><span class="dot" aria-hidden="true"></span><span class="vl" aria-hidden="true"></span>';
        b.addEventListener('click', function () {
          assign[fi] = assign[fi] === c.id ? null : c.id;
          render(fi);
        });
        grid.appendChild(b);
        cells[fi].push(b);
      });
    });

    function render(changed) {
      var v = evaluate(), legal = 0, lines = [];
      FLIGHTS.forEach(function (f, fi) {
        CREW.forEach(function (c, ci) {
          var b = cells[fi][ci], on = assign[fi] === c.id;
          b.setAttribute('aria-pressed', String(on));
          b.removeAttribute('data-v');
          b.querySelector('.vl').textContent = '';
          if (on && v[fi]) {
            b.setAttribute('data-v', v[fi].ok ? 'ok' : 'bad');
            b.querySelector('.vl').textContent = v[fi].ok ? 'LEGAL' : 'REJECT';
          }
        });
        if (v[fi]) {
          if (v[fi].ok) legal++;
          var who = 'Capt. ' + v[fi].crew.name;
          if (v[fi].ok) lines.push('<div class="vline ok' + (fi === changed ? ' is-new' : '') + '"><span class="tag">LEGAL</span><span class="msgt">' + f.id + ' · ' + who + ' <em>— ' + v[fi].okBits.join(' · ') + '</em></span></div>');
          else lines.push('<div class="vline bad' + (fi === changed ? ' is-new' : '') + '"><span class="tag">REJECTED</span><span class="msgt">' + f.id + ' · ' + who + ' <em>— ' + v[fi].fails.slice(0, 2).map(function (x) { return x.t; }).join(' ') + '</em></span></div>');
        }
      });
      var hit = {}, any = lines.length > 0;
      v.forEach(function (x) { if (x && !x.ok) x.fails.forEach(function (f) { hit[f.r] = true; }); });
      roster.querySelectorAll('[data-rules] li').forEach(function (li) {
        var r = li.getAttribute('data-r');
        li.classList.toggle('hit', !!hit[r]);
        li.classList.toggle('pass', any && !hit[r]);
      });
      out.innerHTML = lines.length ? lines.join('') : '<p class="roster__hint">Select a captain for any flight to see the verdict.</p>';
      score.textContent = legal + ' of 4 sectors legally crewed' + (legal === 4 && lines.length === 4 ? ' · schedule valid' : '');
      score.classList.toggle('is-full', legal === 4);
    }

    var solving = [];
    roster.querySelector('[data-roster-reset]').addEventListener('click', function () {
      solving.forEach(clearTimeout); solving = [];
      assign = [null, null, null, null]; render(-1);
    });
    roster.querySelector('[data-roster-solve]').addEventListener('click', function () {
      solving.forEach(clearTimeout); solving = [];
      assign = [null, null, null, null]; render(-1);
      var plan = ['das', 'khan', 'khan', 'mehra'];
      plan.forEach(function (cid, fi) {
        solving.push(setTimeout(function () { assign[fi] = cid; render(fi); }, reduce ? 0 : 420 * (fi + 1)));
      });
    });
    render(-1);
  }

  /* ---------------- Import review animation ---------------- */
  var sheet = document.querySelector('[data-sheet]');
  if (sheet) {
    var rows = Array.prototype.slice.call(sheet.querySelectorAll('.sheet__row:not(.sheet__row--head)'));
    var statusEl = sheet.querySelector('[data-sheet-status]');
    var drawer = sheet.querySelector('[data-sheet-drawer]');
    var rowNo = sheet.querySelector('[data-sheet-row]');
    var rawEl = sheet.querySelector('[data-sheet-raw]');
    var pick = sheet.querySelector('[data-sheet-pick]');
    var audit = sheet.querySelector('[data-sheet-audit]');
    var orig = rows.map(function (r) { return { state: r.getAttribute('data-state'), raw: r.children[4].textContent, st: r.querySelector('.st').textContent }; });
    var q = [], live = false, runningSheet = false;
    function wait(ms) { return new Promise(function (res) { q.push(setTimeout(res, reduce ? 0 : ms)); }); }
    function reset() {
      rows.forEach(function (r, i) {
        r.setAttribute('data-state', orig[i].state);
        r.children[4].textContent = orig[i].raw;
        r.children[4].classList.toggle('raw', orig[i].state === 'review');
        r.querySelector('.st').textContent = orig[i].st;
        r.classList.add('is-pending'); r.classList.remove('is-focus');
      });
      drawer.classList.add('is-idle');
      audit.innerHTML = '&nbsp;';
    }
    var REASONS = { 'Boeing 737 MAX 8': 'type-rating card says 737 MAX 8' };
    async function runSheet() {
      if (runningSheet) return; runningSheet = true;
      while (live) {
        reset();
        var reviewed = 0;
        for (var i = 0; i < rows.length && live; i++) {
          var r = rows[i];
          statusEl.textContent = 'Importing · row ' + (i + 1) + ' of 6';
          await wait(380);
          r.classList.remove('is-pending');
          if (r.getAttribute('data-state') === 'review') {
            var fix = r.getAttribute('data-fix');
            r.classList.add('is-focus');
            drawer.classList.remove('is-idle');
            rowNo.textContent = i + 1;
            rawEl.textContent = r.children[4].textContent;
            pick.textContent = 'Use ' + fix;
            statusEl.textContent = 'Paused · needs a decision';
            await wait(1700);
            pick.classList.add('is-press');
            await wait(260);
            pick.classList.remove('is-press');
            r.setAttribute('data-state', 'fixed');
            r.children[4].textContent = fix;
            r.children[4].classList.remove('raw');
            r.querySelector('.st').textContent = 'Reviewed';
            r.classList.remove('is-focus');
            reviewed++;
            audit.textContent = 'ops.admin · ' + rawEl.textContent + ' → ' + fix + ' · reason: ' + (REASONS[fix] || 'confirmed') + ' · stored for audit';
            drawer.classList.add('is-idle');
            await wait(900);
          }
        }
        if (!live) break;
        statusEl.textContent = '212 rows · ' + reviewed + ' reviewed · 0 rejected';
        await wait(5200);
      }
      runningSheet = false;
    }
    reset();
    if (reduce) {
      rows.forEach(function (r) { r.classList.remove('is-pending'); });
      statusEl.textContent = '212 rows · 2 need review';
      drawer.classList.remove('is-idle');
    } else {
      onVisible(sheet, function (v) {
        live = v;
        if (!v) { q.forEach(clearTimeout); q = []; runningSheet = false; }
        else runSheet();
      }, { threshold: 0, rootMargin: '0px 0px -20% 0px' });
    }
  }

  /* ---------------- Jobs detail ---------------- */
  var jobs = document.querySelector('[data-jobs]');
  var detail = document.querySelector('[data-job-detail]');
  if (jobs && detail) {
    var JOBS = {
      run: { id: '7F3A', st: '<em class="st st--run mono">Running</em>', title: 'Building crew pairings', reason: '24 of 42 route windows done. Started by ops.admin, 04:12 elapsed. Close the tab and it keeps going.', feed: [['04:10', 'Aircraft rotations complete · 8 tails'], ['03:52', 'VT-SKB held out: A-check due 03 Oct 14:20'], ['01:05', 'Readiness: 0 blockers, 2 warnings'], ['00:00', 'Persisted · queued on schedule_generation']], act: 'Cancel job' },
      fail: { id: 'B398', st: '<em class="st st--fail mono">Failed</em>', title: 'No flights generated', reason: 'Every aircraft in scope was past its A-check due date inside the window, so none could be dispatched. Saved as failed with that diagnosis, not as an empty “successful” schedule.', feed: [['25:14', 'Validation: 0 flights · not operationally usable'], ['03:40', '13 of 13 aircraft past A-check due date'], ['00:58', 'Readiness: no hard blockers'], ['00:00', 'Persisted · queued']], act: 'Retry after fixing data' },
      partial: { id: '2C11', st: '<em class="st st--part mono">Partial</em>', title: '38 of 42 route windows covered', reason: 'Four late-evening windows had no crew left with enough rest to fly them legally. The schedule is saved as partial, with those windows listed rather than hidden.', feed: [['11:02', 'Saved as partial · 4 windows unassigned'], ['10:47', 'No legal crew for 4 windows: rest below minimum'], ['06:30', 'OR-Tools solve · 38 / 42 covered'], ['00:00', 'Persisted · queued']], act: 'Retry with more crew' },
      done: { id: '91D0', st: '<em class="st st--done mono">Completed</em>', title: '168 flights, no warnings', reason: 'All windows covered. Rest, duty, maintenance, approvals and continuity checks passed. The schedule is ready to review and export.', feed: [['09:18', 'Schedule saved · 168 flights'], ['09:02', 'Validation passed · 0 warnings'], ['05:41', 'OR-Tools solve · 36 / 36 covered'], ['00:00', 'Persisted · queued']], act: 'Open schedule' },
      cancel: { id: '5E7B', st: '<em class="st st--cancel mono">Cancelled</em>', title: 'Stopped by the user', reason: 'Cancelled during the solve phase. The worker task was revoked rather than left running in the background. Retry it from here with the same inputs.', feed: [['03:12', 'Worker task revoked'], ['03:11', 'Cancel requested by planning'], ['02:40', 'Solve started'], ['00:00', 'Persisted · queued']], act: 'Retry' }
    };
    function show(key) {
      var j = JOBS[key]; if (!j) return;
      detail.innerHTML = '<div class="jd__top"><span class="jd__id mono">JOB ' + j.id + '</span>' + j.st + '</div>' +
        '<p class="jd__title">' + j.title + '</p><p class="jd__reason">' + j.reason + '</p>' +
        '<ul class="jd__feed">' + j.feed.map(function (l) { return '<li><span>' + l[0] + '</span>' + l[1] + '</li>'; }).join('') + '</ul>' +
        '<div class="ui-actions"><span class="ui-btn">' + j.act + '</span></div>';
      jobs.querySelectorAll('[data-job]').forEach(function (b) { var on = b.getAttribute('data-job') === key; b.classList.toggle('is-open', on); b.setAttribute('aria-pressed', String(on)); });
    }
    jobs.querySelectorAll('[data-job]').forEach(function (b) {
      b.addEventListener('click', function () { show(b.getAttribute('data-job')); });
    });
    show('run');
  }

  /* ---------------- Roles tabs ---------------- */
  var roles = document.querySelector('[data-roles]');
  if (roles) tabs(roles, '[role="tab"]', '[role="tabpanel"]');

  /* ---------------- Split-flap status board ---------------- */
  var board = document.querySelector('[data-board]');
  if (board) {
    var flaps = Array.prototype.slice.call(board.querySelectorAll('[data-flap]'));
    var CH = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    flaps.forEach(function (f) {
      var word = f.getAttribute('data-flap');
      f.setAttribute('aria-label', word);
      f.innerHTML = word.split('').map(function (ch) { return '<span class="fl' + (ch === ' ' ? ' sp' : '') + '" aria-hidden="true">' + (reduce ? ch : ' ') + '</span>'; }).join('');
    });
    var flipped = false;
    function flip() {
      flaps.forEach(function (f, row) {
        var word = f.getAttribute('data-flap');
        var cellsF = f.querySelectorAll('.fl');
        cellsF.forEach(function (c, i) {
          var target = word[i];
          if (target === ' ') return;
          var steps = 6 + Math.floor(Math.random() * 8) + i, n = 0;
          setTimeout(function tick() {
            n++;
            c.textContent = n >= steps ? target : CH[Math.floor(Math.random() * CH.length)];
            if (n < steps) setTimeout(tick, 45);
          }, row * 90);
        });
      });
    }
    if (!reduce) onVisible(board, function (v) { if (v && !flipped) { flipped = true; flip(); } }, { threshold: 0, rootMargin: '0px 0px -20% 0px' });
  }
})();
