/* BloodLink - small script that opens and closes the About panel */
document.addEventListener('DOMContentLoaded', function () {
    var panel   = document.getElementById('about-panel');
    var overlay = document.getElementById('panel-overlay');
    var lastButton = null;

    function openPanel(button) {
        lastButton = button;
        panel.classList.add('open');
        overlay.classList.add('open');
        panel.setAttribute('aria-hidden', 'false');
        panel.querySelector('.panel-close').focus();
    }

    function closePanel() {
        panel.classList.remove('open');
        overlay.classList.remove('open');
        panel.setAttribute('aria-hidden', 'true');
        if (lastButton) { lastButton.focus(); }
    }

    document.querySelectorAll('[data-open-panel]').forEach(function (b) {
        b.addEventListener('click', function () { openPanel(b); });
    });
    document.querySelectorAll('[data-close-panel]').forEach(function (b) {
        b.addEventListener('click', closePanel);
    });
    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape' && panel.classList.contains('open')) { closePanel(); }
    });
});
