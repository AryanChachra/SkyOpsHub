/* SkyOpsHub — hero ops console: live route network + streaming job log. */
(function () {
  'use strict';
  var SVGNS = 'http://www.w3.org/2000/svg';
  var reduce = (window.SKY && window.SKY.reduce) || false;

  /* ------------------------------------------------------------------
     Network
     ------------------------------------------------------------------ */
  var svg = document.querySelector('[data-netmap]');
  var tip = document.querySelector('[data-net-tip]');
  if (!svg) return;

  var W = 520, H = 540, K = 15.6, CX = 262, CY = 262, LAT0 = 21.5, LON0 = 82.5, COS = Math.cos(22 * Math.PI / 180);
  function proj(lat, lon) { return [CX + (lon - LON0) * COS * K, CY - (lat - LAT0) * K]; }

  var AIRPORTS = [
    ['DEL', 'Delhi · Indira Gandhi Intl', 28.5562, 77.1000, 1, [-30, -8]],
    ['BOM', 'Mumbai · Chhatrapati Shivaji Maharaj Intl', 19.0896, 72.8656, 1, [-30, 4]],
    ['BLR', 'Bengaluru · Kempegowda Intl', 13.1986, 77.7066, 1, [8, 4]],
    ['HYD', 'Hyderabad · Rajiv Gandhi Intl', 17.2403, 78.4294, 0, [8, -4]],
    ['MAA', 'Chennai Intl', 12.9941, 80.1709, 0, [8, 8]],
    ['CCU', 'Kolkata · Netaji Subhas Chandra Bose Intl', 22.6547, 88.4467, 1, [8, -4]],
    ['GOI', 'Goa · Dabolim', 15.3808, 73.8314, 0, [-28, 4]],
    ['AMD', 'Ahmedabad · Sardar Vallabhbhai Patel Intl', 23.0772, 72.6347, 0, [-30, -2]],
    ['PNQ', 'Pune', 18.5793, 73.9197, 0, [8, 10]],
    ['COK', 'Kochi Intl', 10.1520, 76.4019, 0, [-30, 4]],
    ['IXL', 'Leh · Kushok Bakula Rimpochee', 34.1359, 77.5465, 0, [8, -2]],
    ['GAU', 'Guwahati · Lokpriya Gopinath Bordoloi Intl', 26.1061, 91.5859, 0, [-4, -10]],
    ['LKO', 'Lucknow · Chaudhary Charan Singh Intl', 26.7606, 80.8893, 0, [8, -2]],
    ['JAI', 'Jaipur Intl', 26.8242, 75.8122, 0, [-28, 8]],
    ['BBI', 'Bhubaneswar · Biju Patnaik Intl', 20.2444, 85.8178, 0, [8, 8]],
    ['TRV', 'Thiruvananthapuram Intl', 8.4821, 76.9201, 0, [8, 6]],
    ['SXR', 'Srinagar', 33.9871, 74.7742, 0, [-30, 2]],
    ['PAT', 'Patna · Jay Prakash Narayan', 25.5913, 85.0880, 0, [6, -6]]
  ];
  var ROUTES = [
    ['DEL', 'BOM'], ['DEL', 'BLR'], ['BOM', 'BLR'], ['DEL', 'HYD'], ['BOM', 'GOI'], ['BLR', 'COK'],
    ['DEL', 'CCU'], ['BOM', 'HYD'], ['DEL', 'IXL'], ['CCU', 'GAU'], ['BOM', 'AMD'], ['HYD', 'MAA'],
    ['DEL', 'PNQ'], ['MAA', 'CCU']
  ];

  var apt = {};
  AIRPORTS.forEach(function (a) {
    var p = proj(a[2], a[3]);
    apt[a[0]] = { code: a[0], name: a[1], lat: a[2], lon: a[3], hub: !!a[4], lab: a[5], x: p[0], y: p[1], routes: [] };
  });

  function el(name, attrs, parent) {
    var n = document.createElementNS(SVGNS, name);
    for (var k in attrs) n.setAttribute(k, attrs[k]);
    if (parent) parent.appendChild(n);
    return n;
  }

  // fit the viewBox tightly around the airports (portrait) and draw a graticule across it
  var xs = [], ys = [];
  Object.keys(apt).forEach(function (c) { xs.push(apt[c].x); ys.push(apt[c].y); });
  var minX = Math.min.apply(null, xs) - 44, maxX = Math.max.apply(null, xs) + 40;
  var minY = Math.min.apply(null, ys) - 40, maxY = Math.max.apply(null, ys) + 46;
  W = maxX - minX; H = maxY - minY;
  svg.setAttribute('viewBox', minX.toFixed(1) + ' ' + minY.toFixed(1) + ' ' + W.toFixed(1) + ' ' + H.toFixed(1));
  svg.setAttribute('preserveAspectRatio', 'xMidYMid meet');
  var VB = { x: minX, y: minY };
  // The whole network, and the part of it on screen (zoomed on an airport).
  var BASE = { x: minX, y: minY, w: W, h: H };
  var view = { x: minX, y: minY, w: W, h: H };
  var curZ = 1;
  var g = el('g', { 'aria-hidden': 'true' }, svg);
  [10, 15, 20, 25, 30].forEach(function (lat) {
    var y = proj(lat, 0)[1];
    el('line', { x1: minX, x2: maxX, y1: y, y2: y, class: 'grat' }, g);
    var t = el('text', { x: maxX - 4, y: y - 4, 'text-anchor': 'end', class: 'grat-l' }, g); t.textContent = lat + '°N';
  });
  [75, 80, 85, 90].forEach(function (lon) {
    var x = proj(0, lon)[0];
    el('line', { x1: x, x2: x, y1: minY, y2: maxY, class: 'grat' }, g);
    var t = el('text', { x: x + 4, y: minY + 12, class: 'grat-l' }, g); t.textContent = lon + '°E';
  });

  // arcs
  var gArcs = el('g', {}, svg);
  var gTrails = el('g', {}, svg);
  var arcs = ROUTES.map(function (r, i) {
    var a = apt[r[0]], b = apt[r[1]];
    var mx = (a.x + b.x) / 2, my = (a.y + b.y) / 2;
    var dx = b.x - a.x, dy = b.y - a.y, len = Math.sqrt(dx * dx + dy * dy);
    var bend = 0.2 * (i % 2 ? 1 : -1);
    var cx = mx - dy * bend, cy = my + dx * bend;
    var d = 'M' + a.x.toFixed(1) + ' ' + a.y.toFixed(1) + ' Q' + cx.toFixed(1) + ' ' + cy.toFixed(1) + ' ' + b.x.toFixed(1) + ' ' + b.y.toFixed(1);
    var path = el('path', { d: d, class: 'arc' }, gArcs);
    var total = path.getTotalLength();
    a.routes.push(i); b.routes.push(i);
    return { a: a, b: b, path: path, len: total || len };
  });

  // airports
  var gApt = el('g', {}, svg);
  var lastTouch = 0, touchTimer = 0;
  Object.keys(apt).forEach(function (code) {
    var a = apt[code];
    var grp = el('g', { class: 'apt ' + (a.hub ? 'hub' : a.routes.length ? '' : 'minor'), transform: 'translate(' + a.x.toFixed(1) + ' ' + a.y.toFixed(1) + ')', tabindex: '0', role: 'button', 'aria-label': a.code + ', ' + a.name + ', ' + a.routes.length + ' routes in this run' }, gApt);
    el('circle', { r: 12, class: 'hit' }, grp);
    el('circle', { r: 3, class: 'halo' }, grp);
    el('circle', { r: a.hub ? 3.4 : a.routes.length ? 2.4 : 1.6, class: 'core' }, grp);
    var t = el('text', { x: a.lab[0], y: a.lab[1] + 3 }, grp); t.textContent = a.code;
    a.node = grp;
    var show = function () { focusApt(a); };
    var hide = function () { focusApt(null); };
    a.at = 'translate(' + a.x.toFixed(1) + ' ' + a.y.toFixed(1) + ')';
    grp.addEventListener('mouseenter', show); grp.addEventListener('focus', show);
    // A tap also sends emulated mouse events, some of them a leave; the timer
    // decides when a tapped airport lets go.
    grp.addEventListener('mouseleave', function () { if (Date.now() - lastTouch > 800) hide(); });
    grp.addEventListener('blur', function () { if (Date.now() - lastTouch > 800) hide(); });
    grp.addEventListener('touchstart', function () {
      lastTouch = Date.now(); show();
      clearTimeout(touchTimer); touchTimer = setTimeout(hide, 3600);
    }, { passive: true });
  });

  /* Zoom on the airport under the pointer. The airport stays where it is on
     screen (so it stays under the cursor) and the view closes in on it far
     enough to keep every airport it's routed to inside the map. Dots, labels
     and planes keep their size; lines keep their width. */
  function zoomFor(a) {
    if (!a.routes.length) return null;
    var fx = (a.x - view.x) / view.w, fy = (a.y - view.y) / view.h;
    var z = 3, mx = 30, my = 22;
    a.routes.forEach(function (i) {
      var p = arcs[i].a === a ? arcs[i].b : arcs[i].a;
      if (p.x < a.x) z = Math.min(z, fx * BASE.w / (a.x - p.x + mx));
      if (p.x > a.x) z = Math.min(z, (1 - fx) * BASE.w / (p.x - a.x + mx));
      if (p.y < a.y) z = Math.min(z, fy * BASE.h / (a.y - p.y + my));
      if (p.y > a.y) z = Math.min(z, (1 - fy) * BASE.h / (p.y - a.y + my));
    });
    if (z < 1.25) return null;
    var w = BASE.w / z, h = BASE.h / z;
    return { x: a.x - fx * w, y: a.y - fy * h, w: w, h: h };
  }
  function applyView(r) {
    view = r;
    curZ = BASE.w / r.w;
    svg.setAttribute('viewBox', r.x.toFixed(2) + ' ' + r.y.toFixed(2) + ' ' + r.w.toFixed(2) + ' ' + r.h.toFixed(2));
    var k = curZ > 1.001 ? ' scale(' + (1 / curZ).toFixed(4) + ')' : '';
    Object.keys(apt).forEach(function (c) { apt[c].node.setAttribute('transform', apt[c].at + k); });
    svg.classList.toggle('is-zoomed', curZ > 1.05);
    if (!running) planes.forEach(place);
  }
  var zoomAnim = 0, zoomOutTimer = 0;
  function zoomTo(target) {
    cancelAnimationFrame(zoomAnim);
    var from = { x: view.x, y: view.y, w: view.w, h: view.h };
    if (reduce) { applyView(target); return; }
    var t0 = 0, dur = 480;
    var step = function (ts) {
      if (!t0) t0 = ts;
      var t = Math.min(1, (ts - t0) / dur), e = 1 - Math.pow(1 - t, 3);
      applyView({ x: from.x + (target.x - from.x) * e, y: from.y + (target.y - from.y) * e, w: from.w + (target.w - from.w) * e, h: from.h + (target.h - from.h) * e });
      if (t < 1) zoomAnim = requestAnimationFrame(step);
    };
    zoomAnim = requestAnimationFrame(step);
  }

  function focusApt(a) {
    clearTimeout(zoomOutTimer);
    if (a) {
      var target = zoomFor(a);
      if (target) zoomTo(target);
    } else {
      // A short grace period, so moving between airports doesn't bounce.
      zoomOutTimer = setTimeout(function () { zoomTo(BASE); }, 260);
    }
    svg.classList.toggle('is-focus', !!a);
    Object.keys(apt).forEach(function (c) { apt[c].node.classList.remove('is-hot'); });
    arcs.forEach(function (r) { r.path.classList.remove('is-hot'); });
    if (!a) { if (tip) tip.hidden = true; return; }
    a.node.classList.add('is-hot');
    a.routes.forEach(function (i) { arcs[i].path.classList.add('is-hot'); arcs[i].a.node.classList.add('is-hot'); arcs[i].b.node.classList.add('is-hot'); });
    if (tip) {
      var box = svg.getBoundingClientRect();
      // The airport keeps its place on screen while the view zooms, so the
      // current view says where it is.
      var sc = Math.min(box.width / view.w, box.height / view.h);
      var ox = (box.width - view.w * sc) / 2, oy = (box.height - view.h * sc) / 2;
      var ns = a.lat.toFixed(2) + '°N  ' + a.lon.toFixed(2) + '°E';
      var peers = a.routes.map(function (i) { return arcs[i].a === a ? arcs[i].b.code : arcs[i].a.code; });
      tip.innerHTML = '<b>' + a.code + '</b>' + a.name + '<br>' + ns + '<br>' + (peers.length ? 'Routes in run: ' + peers.join(' · ') : 'Not in this run');
      var px = ox + (a.x - view.x) * sc, py = oy + (a.y - view.y) * sc;
      // Measure, then keep the whole card inside the map: above the airport
      // when there's room, otherwise below it, and clamped at the sides.
      tip.hidden = false;
      var host = tip.offsetParent || svg.parentNode;
      var hb = host.getBoundingClientRect();
      var sx = box.left - hb.left, sy = box.top - hb.top;
      var tw = tip.offsetWidth, th = tip.offsetHeight, pad = 8, gap = 14;
      var x = Math.max(pad, Math.min(hb.width - tw - pad, sx + px - tw / 2));
      var above = sy + py - th - gap, below = sy + py + gap;
      var y = above >= pad ? above : Math.max(pad, Math.min(hb.height - th - pad, below));
      tip.style.left = x + 'px';
      tip.style.top = y + 'px';
    }
  }

  // planes
  var gPlanes = el('g', {}, svg);
  var PLANE = 'M7 0 2.2-1.1-1-6h-1.5l1.3 4.9h-3.6L-6.3-3.4h-1l.8 3.4-.8 3.4h1l1.5-2.3h3.6L-2.5 6H-1l3.2-4.9z';
  var planes = [];
  var N = window.innerWidth < 700 ? 5 : 8;
  function spawn(p, initial) {
    var ri = Math.floor(Math.random() * arcs.length);
    p.r = arcs[ri];
    p.dir = Math.random() < 0.5 ? 1 : -1;
    p.t = initial ? Math.random() : 0;
    p.speed = (0.00007 + Math.random() * 0.00005) * (260 / Math.max(120, p.r.len)) * 60;
    p.trail.setAttribute('d', p.r.path.getAttribute('d'));
  }
  for (var i = 0; i < N; i++) {
    var trail = el('path', { class: 'trail' }, gTrails);
    trail.style.stroke = 'rgba(31,182,255,.85)';
    var pg = el('g', {}, gPlanes);
    el('path', { d: PLANE, class: 'plane' }, pg);
    var p = { g: pg, trail: trail };
    spawn(p, true);
    planes.push(p);
  }

  function place(p) {
    var L = p.r.len;
    var s = (p.dir > 0 ? p.t : 1 - p.t) * L;
    var pt = p.r.path.getPointAtLength(s);
    var ahead = p.r.path.getPointAtLength(Math.max(0, Math.min(L, s + p.dir * 1.5)));
    var ang = Math.atan2(ahead.y - pt.y, ahead.x - pt.x) * 180 / Math.PI;
    p.g.setAttribute('transform', 'translate(' + pt.x.toFixed(1) + ' ' + pt.y.toFixed(1) + ') rotate(' + ang.toFixed(1) + ') scale(' + (0.9 / curZ).toFixed(4) + ')');
    var seg = Math.min(46 / curZ, L * 0.45);
    p.trail.setAttribute('stroke-dasharray', seg + ' ' + (L + seg));
    p.trail.setAttribute('stroke-dashoffset', p.dir > 0 ? (seg - s) : (-s));
    var fade = Math.min(1, p.t * 8, (1 - p.t) * 8);
    p.g.style.opacity = fade; p.trail.style.opacity = fade * 0.9;
  }

  function pulse(a) {
    var h = a.node.querySelector('.halo');
    if (!h || reduce) return;
    h.style.animation = 'none';
    // force reflow to restart
    void h.getBoundingClientRect();
    h.style.animation = 'halo 1.6s cubic-bezier(.16,1,.3,1) 1';
  }

  var running = false, last = 0;
  function frame(ts) {
    if (!running) return;
    var dt = last ? Math.min(64, ts - last) : 16; last = ts;
    planes.forEach(function (p) {
      p.t += p.speed * dt / 16;
      if (p.t >= 1) { pulse(p.dir > 0 ? p.r.b : p.r.a); spawn(p, false); }
      place(p);
    });
    requestAnimationFrame(frame);
  }
  planes.forEach(place);
  if (!reduce && window.SKY && window.SKY.onVisible) {
    window.SKY.onVisible(svg, function (vis) {
      if (vis && !running) { running = true; last = 0; requestAnimationFrame(frame); }
      else if (!vis) running = false;
    }, { threshold: 0 });
  }

  /* ------------------------------------------------------------------
     Job log
     ------------------------------------------------------------------ */
  var logEl = document.querySelector('[data-log]');
  var phaseEls = document.querySelectorAll('[data-phases] li');
  var stateEl = document.querySelector('[data-job-state]');
  var idEl = document.querySelector('[data-job-id]');
  if (!logEl) return;

  // [phase, key, message, verdict, verdictClass]
  // [phase, key, message, verdict, verdictClass, statUpdates]
  var RUN = [
    [0, 'queued', 'Job persisted before dispatch · worker picked up'],
    [0, 'scope', 'Agent choosing aircraft and crew for 14 routes'],
    [0, 'scope', '9 aircraft chosen · route approvals checked', '', '', { aircraft: 9 }],
    [0, 'scope', 'A320 captains: 11 chosen, coverage floor 12', 'RETURNED', 'x', { crew: 31 }],
    [0, 'scope', 'Agent holds at 11 · shortfall logged', 'WARN', 'w', { warnings: 1 }],
    [1, 'readiness', '0 blockers · 6 of 14 routes sampled'],
    [1, 'readiness', '1 licence expires inside the window', 'WARN', 'w', { warnings: 2 }],
    [2, 'chains', 'VT-SKB held out · A-check due 03 Oct 14:20', 'EXCLUDED', 'x', { aircraft: 8 }],
    [2, 'chains', '42 route windows → aircraft rotations', '', '', { windows: 42 }],
    [2, 'chains', 'Crew pairings · rest and continuity checked'],
    [3, 'solve', 'OR-Tools · 42 / 42 route windows covered', 'OK', 'ok'],
    [4, 'validate', 'Rest ≥ 12 h before every pilot duty', 'PASS', 'ok'],
    [4, 'validate', 'Licences valid on each duty date', 'PASS', 'ok'],
    [4, 'validate', 'Tail and crew continuity · no gaps', 'PASS', 'ok'],
    [5, 'persist', 'Schedule saved · 196 flights · 2 warnings', 'DONE', 'ok', { flights: 196 }]
  ];
  var statEls = {};
  document.querySelectorAll('[data-stat]').forEach(function (d) { statEls[d.getAttribute('data-stat')] = d; });
  function setStats(obj) {
    if (!obj) return;
    Object.keys(obj).forEach(function (k) {
      var d = statEls[k]; if (!d) return;
      var to = obj[k], from = parseInt(d.textContent, 10);
      if (isNaN(from) || reduce) from = 0;
      d.classList.add('is-bump');
      setTimeout(function () { d.classList.remove('is-bump'); }, 900);
      if (reduce) { d.textContent = to; return; }
      var t0 = null;
      (function tick(ts) {
        if (!t0) t0 = ts;
        var k2 = Math.min(1, (ts - t0) / 700);
        d.textContent = Math.round(from + (to - from) * (1 - Math.pow(1 - k2, 3)));
        if (k2 < 1) requestAnimationFrame(tick);
      })(performance.now());
    });
  }
  function resetStats() {
    ['aircraft', 'crew', 'windows', 'flights'].forEach(function (k) { if (statEls[k]) statEls[k].textContent = '—'; });
    if (statEls.warnings) statEls.warnings.textContent = '0';
  }
  var MAX_LINES = 7;
  var clock = 0, idx = 0, timer = null, active = false;

  function fmtClock(s) { var m = Math.floor(s / 60), r = s % 60; return (m < 10 ? '0' : '') + m + ':' + (r < 10 ? '0' : '') + r; }
  function setPhase(n, done) {
    phaseEls.forEach(function (li, i) {
      li.classList.toggle('is-done', i < n || (done && i <= n));
      li.classList.toggle('is-now', i === n && !done);
    });
  }
  function randId() { return Math.random().toString(16).slice(2, 6).toUpperCase(); }

  function addLine(row, cb) {
    var line = document.createElement('div');
    line.className = 'logline' + (row[4] === 'x' ? ' is-bad' : row[4] === 'ok' ? ' is-ok' : row[4] === 'w' ? ' is-warn' : '');
    line.innerHTML = '<span class="t">' + fmtClock(clock) + '</span><span class="k">' + row[1] + '</span><span class="m"></span>' + (row[3] ? '<span class="v ' + row[4] + '"></span>' : '');
    logEl.appendChild(line);
    while (logEl.children.length > MAX_LINES) logEl.removeChild(logEl.firstChild);
    var m = line.querySelector('.m');
    var text = row[2];
    if (reduce) { m.textContent = text; if (row[3]) line.querySelector('.v').textContent = row[3]; cb(); return; }
    var i = 0;
    var caret = document.createElement('span'); caret.className = 'caret';
    m.appendChild(caret);
    (function type() {
      if (!active) { m.textContent = text; cb(); return; }
      i += 2;
      m.textContent = text.slice(0, i);
      m.appendChild(caret);
      if (i < text.length) timer = setTimeout(type, 14);
      else { caret.remove(); if (row[3]) line.querySelector('.v').textContent = row[3]; cb(); }
    })();
  }

  function next() {
    if (!active) return;
    if (idx >= RUN.length) {
      setPhase(5, true);
      if (stateEl) { stateEl.textContent = 'COMPLETED'; stateEl.className = 'chip chip--done mono'; }
      timer = setTimeout(restart, 4200);
      return;
    }
    var row = RUN[idx++];
    setPhase(row[0], false);
    setStats(row[5]);
    addLine(row, function () {
      clock += 12 + Math.floor(Math.random() * 30);
      timer = setTimeout(next, 650 + Math.random() * 650);
    });
  }
  function restart() {
    logEl.innerHTML = '';
    idx = 0; clock = 0;
    resetStats();
    if (idEl) idEl.textContent = randId();
    if (stateEl) { stateEl.textContent = 'RUNNING'; stateEl.className = 'chip chip--live mono'; }
    setPhase(0, false);
    next();
  }

  if (reduce) {
    RUN.slice(-MAX_LINES).forEach(function (r) { addLine(r, function () {}); });
    RUN.forEach(function (r) { setStats(r[5]); });
    setPhase(5, true);
    if (stateEl) { stateEl.textContent = 'COMPLETED'; stateEl.className = 'chip chip--done mono'; }
    return;
  }
  var started = false;
  if (window.SKY && window.SKY.onVisible) {
    window.SKY.onVisible(logEl, function (vis) {
      if (vis && !active) {
        active = true;
        if (!started) { started = true; timer = setTimeout(restart, 900); }
        else { clearTimeout(timer); next(); }
      } else if (!vis && active) {
        active = false; clearTimeout(timer);
      }
    }, { threshold: 0 });
  }
})();
