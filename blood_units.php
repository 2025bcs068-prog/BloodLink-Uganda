<?php
/*
 * Blood units list: stock, status and expiry dates (staff only)
 */
require_once 'includes/auth.php';
require_login();
require 'config/database.php';

$types    = $pdo->query('SELECT blood_type_id, type_code FROM blood_type ORDER BY blood_type_id')->fetchAll(PDO::FETCH_ASSOC);
$statuses = ['In Storage', 'Reserved', 'Issued', 'Expired', 'Discarded'];

$type   = $_GET['type'] ?? '';
$status = $_GET['status'] ?? '';

$where = [];
$params = [];
if ($type !== '')   { $where[] = 'u.blood_type_id = ?'; $params[] = $type; }
if ($status !== '') { $where[] = 'u.status = ?';        $params[] = $status; }

$sql = 'SELECT u.unit_id, bt.type_code, bb.bank_name, u.collection_date, u.expiry_date, u.volume_ml, u.status,
               DATEDIFF(u.expiry_date, CURDATE()) AS days_left
        FROM blood_unit u
        JOIN blood_type bt ON bt.blood_type_id = u.blood_type_id
        JOIN blood_bank bb ON bb.blood_bank_id = u.blood_bank_id '
     . (count($where) ? 'WHERE ' . implode(' AND ', $where) : '')
     . ' ORDER BY u.expiry_date LIMIT 100';
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$units = $stmt->fetchAll(PDO::FETCH_ASSOC);

$pageTitle  = 'Blood units';
$activePage = 'units';
require 'includes/header.php';
?>
<section class="section">
    <div class="container">
        <h1 class="page-title">Blood units</h1>

        <form class="filters" method="get" action="blood_units.php">
            <div>
                <label for="type">Blood type</label>
                <select id="type" name="type">
                    <option value="">All</option>
                    <?php foreach ($types as $t) { ?>
                        <option value="<?php echo (int)$t['blood_type_id']; ?>" <?php echo $type == $t['blood_type_id'] ? 'selected' : ''; ?>><?php echo e($t['type_code']); ?></option>
                    <?php } ?>
                </select>
            </div>
            <div>
                <label for="status">Status</label>
                <select id="status" name="status">
                    <option value="">All</option>
                    <?php foreach ($statuses as $s) { ?>
                        <option value="<?php echo e($s); ?>" <?php echo $status === $s ? 'selected' : ''; ?>><?php echo e($s); ?></option>
                    <?php } ?>
                </select>
            </div>
            <button type="submit" class="btn btn-dark">Filter</button>
        </form>

        <div class="box">
            <?php if (count($units) === 0) { ?>
                <p class="empty">No blood units found.</p>
            <?php } else { ?>
                <div class="table-scroll">
                <table class="table">
                    <thead><tr><th>Unit</th><th>Type</th><th>Blood bank</th><th>Collected</th><th>Expires</th><th>Volume</th><th>Status</th></tr></thead>
                    <tbody>
                    <?php foreach ($units as $u) { ?>
                        <tr>
                            <td>#<?php echo (int)$u['unit_id']; ?></td>
                            <td><?php echo e($u['type_code']); ?></td>
                            <td><?php echo e($u['bank_name']); ?></td>
                            <td><?php echo e($u['collection_date']); ?></td>
                            <td>
                                <?php echo e($u['expiry_date']); ?>
                                <?php if ($u['status'] === 'In Storage' && $u['days_left'] >= 0 && $u['days_left'] <= 7) { ?>
                                    <span class="badge badge-urgent"><?php echo (int)$u['days_left']; ?> days left</span>
                                <?php } ?>
                            </td>
                            <td><?php echo (int)$u['volume_ml']; ?> ml</td>
                            <td><span class="badge badge-<?php echo strtolower(str_replace(' ', '', $u['status'])); ?>"><?php echo e($u['status']); ?></span></td>
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
