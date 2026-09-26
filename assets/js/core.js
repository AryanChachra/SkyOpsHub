/* SkyOpsHub — core interactions (nav, reveals, scroll progress, menu). No dependencies. */
(function () {
  'use strict';
  var doc = document.documentElement;
  doc.classList.remove('no-js');
  var reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  window.SKY = window.SKY || {};
  window.SKY.reduce = reduce;

  /* ---- Split display headings into words for a staggered rise ---- */
  document.querySelectorAll('[data-split]').forEach(function (el) {
    var words = el.textContent.trim().split(/\s+/);
    el.setAttribute('aria-label', el.textContent.trim());
    el.innerHTML = words.map(function (w, i) {
      return '<span class="w" aria-hidden="true"><span style="--i:' + i + '">' + w + '</span></span>';
    }).join(' ');
  });

  /* ---- Reveal on scroll ---- */
  var revealEls = document.querySelectorAll('.reveal');
  if ('IntersectionObserver' in window && !reduce) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) {
          e.target.classList.add('in');
          io.unobserve(e.target);
        }
      });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.08 });
    // stagger siblings that share a parent
    revealEls.forEach(function (el) {
      var sibs = Array.prototype.filter.call(el.parentNode.children, function (c) { return c.classList.contains('reveal'); });
      var i = sibs.indexOf(el);
      if (!el.style.getPropertyValue('--d') && i > 0) el.style.setProperty('--d', Math.min(i * 0.07, 0.42) + 's');
      io.observe(el);
    });
  } else {
    revealEls.forEach(function (el) { el.classList.add('in'); });
  }

  /* ---- Nav: stuck state, flight progress, active section ---- */
  var nav = document.querySelector('[data-nav]');
  var fill = document.querySelector('[data-flight-fill]');
  var plane = document.querySelector('[data-flight-plane]');
  var links = Array.prototype.slice.call(document.querySelectorAll('.nav__links a'));
  var targets = links.map(function (a) { return document.querySelector(a.getAttribute('href')); });
  var ticking = false;

  function onScroll() {
    ticking = false;
    var y = window.scrollY || window.pageYOffset;
    if (nav) nav.classList.toggle('is-stuck', y > 24);
    var max = doc.scrollHeight - window.innerHeight;
    var p = max > 0 ? Math.min(1, Math.max(0, y / max)) : 0;
    if (fill) fill.style.width = (p * 100) + '%';
    if (plane) plane.style.left = (p * 100) + '%';

    var mark = y + window.innerHeight * 0.35;
    var active = -1;
    targets.forEach(function (t, i) { if (t && t.offsetTop <= mark) active = i; });
    links.forEach(function (a, i) { a.classList.toggle('is-active', i === active); });
  }
  window.addEventListener('scroll', function () {
    if (!ticking) { ticking = true; requestAnimationFrame(onScroll); }
  }, { passive: true });
  window.addEventListener('resize', onScroll);
  onScroll();

  /* ---- Mobile menu ---- */
  var burger = document.querySelector('[data-burger]');
  var menu = document.querySelector('[data-menu]');
  function setMenu(open) {
    if (!burger || !menu) return;
    burger.setAttribute('aria-expanded', String(open));
    burger.setAttribute('aria-label', open ? 'Close menu' : 'Open menu');
    menu.hidden = !open;
    document.body.style.overflow = open ? 'hidden' : '';
    if (open && nav) nav.classList.add('is-stuck');
  }
  if (burger) burger.addEventListener('click', function () { setMenu(burger.getAttribute('aria-expanded') !== 'true'); });
  if (menu) menu.addEventListener('click', function (e) { if (e.target.closest('a')) setMenu(false); });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') setMenu(false); });
  window.addEventListener('resize', function () { if (window.innerWidth > 1080) setMenu(false); });

  /* ---- Ticker: duplicate content for a seamless loop ---- */
  document.querySelectorAll('[data-ticker]').forEach(function (t) {
    t.innerHTML += t.innerHTML.replace(/<li>/g, '<li aria-hidden="true">');
  });

  /* ---- Count-up numbers ---- */
  var counters = document.querySelectorAll('[data-count]');
  function runCount(el) {
    var end = parseFloat(el.getAttribute('data-count'));
    var dec = (el.getAttribute('data-count').split('.')[1] || '').length;
    var fmt = function (v) { return v.toLocaleString('en-IN', { minimumFractionDigits: dec, maximumFractionDigits: dec }); };
    if (reduce) { el.textContent = fmt(end); return; }
    var t0 = null, dur = 1400;
    function step(ts) {
      if (!t0) t0 = ts;
      var k = Math.min(1, (ts - t0) / dur);
      var e = 1 - Math.pow(1 - k, 4);
      el.textContent = fmt(end * e);
      if (k < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }
  if ('IntersectionObserver' in window) {
    var cio = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) { if (e.isIntersecting) { runCount(e.target); cio.unobserve(e.target); } });
    }, { threshold: 0.6 });
    counters.forEach(function (c) { cio.observe(c); });
  } else {
    counters.forEach(runCount);
  }

  /* ---- Scroll-scrubbed pull quote: words light up as you read ---- */
  document.querySelectorAll('[data-scrub]').forEach(function (q) {
    if (reduce) return;
    var walker = document.createTreeWalker(q, NodeFilter.SHOW_TEXT);
    var nodes = [], n;
    while ((n = walker.nextNode())) nodes.push(n);
    nodes.forEach(function (t) {
      var frag = document.createDocumentFragment();
      t.textContent.split(/(\s+)/).forEach(function (part) {
        if (!part) return;
        if (/^\s+$/.test(part)) { frag.appendChild(document.createTextNode(part)); return; }
        var sp = document.createElement('span'); sp.className = 'sw'; sp.textContent = part; frag.appendChild(sp);
      });
      t.parentNode.replaceChild(frag, t);
    });
    var words = q.querySelectorAll('.sw');
    function scrub() {
      var r = q.getBoundingClientRect(), vh = window.innerHeight;
      var p = (vh * 0.85 - r.top) / (vh * 0.45 + r.height);
      p = Math.max(0, Math.min(1, p));
      var k = Math.round(p * words.length);
      words.forEach(function (w, i) { w.classList.toggle('on', i < k); });
    }
    window.addEventListener('scroll', function () { requestAnimationFrame(scrub); }, { passive: true });
    scrub();
  });

  /* ---- Current year ---- */
  document.querySelectorAll('[data-year]').forEach(function (el) { el.textContent = new Date().getFullYear(); });

  /* ---- Helper for other scripts: run fn when element is on screen ---- */
  window.SKY.onVisible = function (el, fn, opts) {
    if (!el) return;
    if (!('IntersectionObserver' in window)) { fn(true); return; }
    var o = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) { fn(e.isIntersecting, e); });
    }, opts || { threshold: 0.2 });
    o.observe(el);
    return o;
  };
})();
