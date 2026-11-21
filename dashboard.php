<?php
/*
 * Dashboard - the staff home page (sign in required)
 */
require_once 'includes/auth.php';
require_login();                 // visitors who are not signed in are sent to login.php
require 'config/database.php';

// ---- Four numbers for the top cards ----
$donors   = $pdo->query('SELECT COUNT(*) FROM donor WHERE is_active = 1')->fetchColumn();
$stored   = $pdo->query("SELECT COUNT(*) FROM blood_unit WHERE status = 'In Storage'")->fetchColumn();
$pending  = $pdo->query("SELECT COUNT(*) FROM blood_request
                         WHERE status IN ('Pending','Partially Fulfilled')")->fetchColumn();
$expiring = $pdo->query("SELECT COUNT(*) FROM blood_unit
                         WHERE status = 'In Storage'
                           AND expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)")->fetchColumn();

// ---- Open requests: emergencies first ----
$requests = $pdo->query("SELECT r.request_id, h.hospital_name, bt.type_code,
                                r.units_needed, r.urgency, r.status
                         FROM blood_request r
                         JOIN hospital h    ON h.hospital_id = r.hospital_id
                         JOIN blood_type bt ON bt.blood_type_id = r.blood_type_id
                         WHERE r.status IN ('Pending','Partially Fulfilled')
                         ORDER BY FIELD(r.urgency,'Emergency','Urgent','Routine'), r.request_date
                         LIMIT 5")->fetchAll(PDO::FETCH_ASSOC);

// ---- Units that expire in the next 14 days ----
$units = $pdo->query("SELECT u.unit_id, bt.type_code, bb.bank_name, u.expiry_date
                      FROM blood_unit u
                      JOIN blood_type bt ON bt.blood_type_id = u.blood_type_id
                      JOIN blood_bank bb ON bb.blood_bank_id = u.blood_bank_id
                      WHERE u.status = 'In Storage'
                        AND u.expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 14 DAY)
                      ORDER BY u.expiry_date
                      LIMIT 5")->fetchAll(PDO::FETCH_ASSOC);

$firstName  = explode(' ', trim($_SESSION['full_name']))[0];
$pageTitle  = 'Home';
$activePage = 'dashboard';
require 'includes/header.php';
?>

<section class="section">
    <div class="container">
        <div class="page-head">
            <div>
                <h1>Welcome, <?php echo e($firstName); ?></h1>
                <p class="muted"><?php echo e($_SESSION['staff_role']); ?></p>
            </div>
            <div class="quick-actions">
                <a class="btn btn-red" href="donor_register.php">Register donor</a>
                <a class="btn btn-dark" href="requests.php">New blood request</a>
            </div>
        </div>

        <div class="stat-cards">
            <div class="stat-card stat-black">
                <span class="stat-number"><?php echo number_format($donors); ?></span>
                <span class="stat-label">Active donors</span>
            </div>
            <div class="stat-card stat-gold">
                <span class="stat-number"><?php echo number_format($stored); ?></span>
                <span class="stat-label">Units in storage</span>
            </div>
            <div class="stat-card stat-red">
                <span class="stat-number"><?php echo number_format($pending); ?></span>
                <span class="stat-label">Open requests</span>
            </div>
            <div class="stat-card stat-black">
                <span class="stat-number"><?php echo number_format($expiring); ?></span>
                <span class="stat-label">Units expiring in 7 days</span>
            </div>
        </div>

        <div class="two-col">
            <div class="box">
                <h2>Open blood requests</h2>
                <?php if (count($requests) === 0) { ?>
                    <p class="empty">No open requests right now.</p>
                <?php } else { ?>
                    <div class="table-scroll">
                    <table class="table">
                        <thead><tr><th>Hospital</th><th>Type</th><th>Units</th><th>Urgency</th></tr></thead>
                        <tbody>
                        <?php foreach ($requests as $r) { ?>
                            <tr>
                                <td><?php echo e($r['hospital_name']); ?></td>
                                <td><?php echo e($r['type_code']); ?></td>
                                <td><?php echo (int)$r['units_needed']; ?></td>
                                <td><span class="badge badge-<?php echo strtolower($r['urgency']); ?>"><?php echo e($r['urgency']); ?></span></td>
                            </tr>
                        <?php } ?>
                        </tbody>
                    </table>
                    </div>
                <?php } ?>
            </div>

            <div class="box">
                <h2>Units expiring soon</h2>
                <?php if (count($units) === 0) { ?>
                    <p class="empty">No units expire in the next 14 days.</p>
                <?php } else { ?>
                    <div class="table-scroll">
                    <table class="table">
                        <thead><tr><th>Unit</th><th>Type</th><th>Blood bank</th><th>Expires</th></tr></thead>
                        <tbody>
                        <?php foreach ($units as $u) { ?>
                            <tr>
                                <td>#<?php echo (int)$u['unit_id']; ?></td>
                                <td><?php echo e($u['type_code']); ?></td>
                                <td><?php echo e($u['bank_name']); ?></td>
                                <td><?php echo e($u['expiry_date']); ?></td>
                            </tr>
                        <?php } ?>
                        </tbody>
                    </table>
                    </div>
                <?php } ?>
            </div>
        </div>
    </div>
</section>

<?php require 'includes/footer.php'; ?>
