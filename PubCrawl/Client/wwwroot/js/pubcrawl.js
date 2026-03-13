// Lucky 13 Pub Crawl — pubcrawl.js

// ── Scroll reveal ────────────────────────────────────────────
(function () {
    const observer = new IntersectionObserver(
        (entries) => {
            entries.forEach(e => {
                if (e.isIntersecting) {
                    e.target.classList.add('revealed');
                    observer.unobserve(e.target);
                }
            });
        },
        { threshold: 0.12 }
    );

    function attachObserver() {
        document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', attachObserver);
    } else {
        attachObserver();
    }

    // Re-attach when Blazor navigates
    window.attachRevealObserver = attachObserver;
})();

// ── QR Code generation ───────────────────────────────────────
window.generateQrCode = function (elementId, url, size) {
    const el = document.getElementById(elementId);
    if (!el) return;
    el.innerHTML = '';

    if (typeof QRCode === 'undefined') {
        // Fallback: load qrcode.js dynamically then retry
        const script = document.createElement('script');
        script.src = 'https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js';
        script.onload = () => createQr(el, url, size);
        document.head.appendChild(script);
    } else {
        createQr(el, url, size);
    }
};

function createQr(el, url, size) {
    new QRCode(el, {
        text: url,
        width: size || 180,
        height: size || 180,
        colorDark: '#080c08',
        colorLight: '#fdfaf5',
        correctLevel: QRCode.CorrectLevel.H
    });
}
