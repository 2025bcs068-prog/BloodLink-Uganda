<?php
/*
 * Home page (public landing page)
 * It shows how many units of each blood type are in storage right now.
 */
require_once 'includes/auth.php';
require 'config/database.php';

// For every blood type, count the units that are "In Storage".
// LEFT JOIN keeps a blood type in the list even if it has 0 units.
$sql = "SELECT bt.type_code, COUNT(bu.unit_id) AS units
        FROM blood_type bt
        LEFT JOIN blood_unit bu
               ON bu.blood_type_id = bt.blood_type_id AND bu.status = 'In Storage'
        GROUP BY bt.blood_type_id, bt.type_code
        ORDER BY bt.blood_type_id";
$stock = $pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC);

$pageTitle  = 'Home';
$activePage = 'home';
require 'includes/header.php';
?>

<section class="hero">
    <div class="container hero-grid">
        <div class="hero-text">
            <h1>Every donor counts. Every unit is tracked.</h1>
            <p>Register donors, watch blood stock and answer hospital requests, all in one place.</p>
            <div class="hero-buttons">
                <?php if (is_logged_in()) { ?>
                    <a class="btn btn-red" href="dashboard.php">Open dashboard</a>
                <?php } else { ?>
                    <a class="btn btn-red" href="login.php">Staff sign in</a>
                <?php } ?>
                <button type="button" class="btn btn-gold-outline" data-open-panel>About BloodLink</button>
            </div>
        </div>

        <div class="hero-stock">
            <h2 class="stock-title">Blood in storage now</h2>
            <div class="tiles">
                <?php foreach ($stock as $i => $row) { ?>
                    <div class="tile" style="--i: <?php echo $i; ?>">
                        <span class="tile-type"><?php echo e($row['type_code']); ?></span>
                        <span class="tile-units"><?php echo (int)$row['units']; ?> units</span>
                    </div>
                <?php } ?>
            </div>
        </div>
    </div>
</section>

<section class="section">
    <div class="container cards">
        <article class="card card-black">
            <h3>Register donors</h3>
            <p>Record a donor once, with blood type, region and eligibility.</p>
        </article>
        <article class="card card-gold">
            <h3>Track blood stock</h3>
            <p>Follow every unit from collection to expiry.</p>
        </article>
        <article class="card card-red">
            <h3>Answer requests</h3>
            <p>See emergency requests from hospitals first.</p>
        </article>
    </div>
</section>

<?php require 'includes/footer.php'; ?>
