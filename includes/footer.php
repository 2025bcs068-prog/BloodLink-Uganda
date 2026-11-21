    </main>
    <footer class="site-footer">
        <div class="container">
            <span>&copy; <?php echo date('Y'); ?> BloodLink Uganda</span>
        </div>
    </footer>

    <!-- About panel: slides in from the right when "About" is pressed -->
    <div class="panel-overlay" id="panel-overlay" data-close-panel></div>
    <aside class="panel" id="about-panel" aria-hidden="true" aria-labelledby="panel-title">
        <div class="panel-head">
            <h2 id="panel-title">About BloodLink Uganda</h2>
            <button type="button" class="panel-close" data-close-panel aria-label="Close panel">&times;</button>
        </div>
        <div class="panel-body">
            <h3>The problem</h3>
            <p>Uganda needs about 500,000 units of blood each year but collects about 439,000.
               Part of this gap is a data problem. Donor records are kept on paper and in
               spreadsheets, so blood banks cannot quickly find eligible donors, remind them
               to return, or track blood units before they expire.</p>

            <h3>The solution</h3>
            <p>BloodLink is one central database system. Staff can find compatible donors by
               blood type and region, see who is due to donate again, and follow every unit of
               blood from collection until it is issued or expires.</p>

            <h3>What it covers</h3>
            <ul>
                <li>Donor registration and eligibility</li>
                <li>Donations and medical screening</li>
                <li>Blood unit storage and expiry dates</li>
                <li>Hospital requests and fulfilment</li>
                <li>Donor reminders and donation drives</li>
            </ul>
        </div>
    </aside>

    <script src="assets/js/app.js"></script>
</body>
</html>
