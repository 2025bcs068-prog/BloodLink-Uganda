<?php
/*
 * Hospitals and the blood bank each one is linked to (staff only)
 */
require_once 'includes/auth.php';
require_login();
require 'config/database.php';

$hospitals = $pdo->query('SELECT h.hospital_name, r.region_name, h.address, h.phone, bb.bank_name
                          FROM hospital h
                          JOIN region r ON r.region_id = h.region_id
                          LEFT JOIN blood_bank bb ON bb.blood_bank_id = h.linked_blood_bank_id
                          ORDER BY h.hospital_name')->fetchAll(PDO::FETCH_ASSOC);

$pageTitle  = 'Hospitals';
$activePage = 'hospitals';
require 'includes/header.php';
?>
<section class="section">
    <div class="container">
        <h1 class="page-title">Hospitals</h1>
        <div class="box">
            <?php if (count($hospitals) === 0) { ?>
                <p class="empty">No hospitals recorded.</p>
            <?php } else { ?>
                <div class="table-scroll">
                <table class="table">
                    <thead><tr><th>Hospital</th><th>Region</th><th>Address</th><th>Phone</th><th>Linked blood bank</th></tr></thead>
                    <tbody>
                    <?php foreach ($hospitals as $h) { ?>
                        <tr>
                            <td><?php echo e($h['hospital_name']); ?></td>
                            <td><?php echo e($h['region_name']); ?></td>
                            <td><?php echo e($h['address'] ?? '-'); ?></td>
                            <td><?php echo e($h['phone'] ?? '-'); ?></td>
                            <td><?php echo e($h['bank_name'] ?? '-'); ?></td>
                        </tr>
                    <?php } ?>
                    </tbody>
                </table>
                </div>
            <?php } ?>
        </div>
    </div>
</section>
<?php require 'includes/footer.php'; ?>
