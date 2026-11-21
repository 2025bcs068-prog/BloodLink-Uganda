<?php
/*
 * Donors list with search and filters (staff only)
 */
require_once 'includes/auth.php';
require_login();
require 'config/database.php';

$types   = $pdo->query('SELECT blood_type_id, type_code FROM blood_type ORDER BY blood_type_id')->fetchAll(PDO::FETCH_ASSOC);
$regions = $pdo->query('SELECT region_id, region_name FROM region ORDER BY region_name')->fetchAll(PDO::FETCH_ASSOC);

// What the staff member typed in the filter form (it arrives in the address bar, method GET)
$q      = trim($_GET['q'] ?? '');
$type   = $_GET['type'] ?? '';
$region = $_GET['region'] ?? '';

// Build the WHERE part only from the filters that were used
$where = [];
$params = [];
if ($q !== '') {
    $where[] = '(d.full_name LIKE ? OR d.national_id LIKE ? OR d.phone LIKE ?)';
    $like = '%' . $q . '%';
    array_push($params, $like, $like, $like);
}
if ($type !== '')   { $where[] = 'd.blood_type_id = ?'; $params[] = $type; }
if ($region !== '') { $where[] = 'd.region_id = ?';     $params[] = $region; }

$sql = 'SELECT d.donor_id, d.full_name, d.national_id, d.phone, bt.type_code, r.region_name,
               el.status AS eligibility, el.next_eligible_date
        FROM donor d
        JOIN blood_type bt ON bt.blood_type_id = d.blood_type_id
        JOIN region r      ON r.region_id = d.region_id
        LEFT JOIN donor_eligibility el ON el.donor_id = d.donor_id '
     . (count($where) ? 'WHERE ' . implode(' AND ', $where) : '')
     . ' ORDER BY d.donor_id DESC LIMIT 100';
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$donors = $stmt->fetchAll(PDO::FETCH_ASSOC);

$pageTitle  = 'Donors';
$activePage = 'donors';
require 'includes/header.php';
?>
<section class="section">
    <div class="container">
        <div class="page-head">
            <h1>Donors</h1>
            <a class="btn btn-red" href="donor_register.php">Register donor</a>
        </div>

        <?php if (isset($_GET['added'])) { ?>
            <p class="alert alert-success">Donor registered successfully.</p>
        <?php } ?>

        <form class="filters" method="get" action="donors.php">
            <div>
                <label for="q">Search</label>
                <input type="search" id="q" name="q" placeholder="Name, ID or phone" value="<?php echo e($q); ?>">
            </div>
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
                <label for="region">Region</label>
                <select id="region" name="region">
                    <option value="">All</option>
                    <?php foreach ($regions as $r) { ?>
                        <option value="<?php echo (int)$r['region_id']; ?>" <?php echo $region == $r['region_id'] ? 'selected' : ''; ?>><?php echo e($r['region_name']); ?></option>
                    <?php } ?>
                </select>
            </div>
            <button type="submit" class="btn btn-dark">Search</button>
        </form>

        <div class="box">
            <?php if (count($donors) === 0) { ?>
                <p class="empty">No donors found. Register the first donor with the red button.</p>
            <?php } else { ?>
                <div class="table-scroll">
                <table class="table">
                    <thead><tr><th>Name</th><th>National ID</th><th>Phone</th><th>Type</th><th>Region</th><th>Status</th><th>Can donate from</th></tr></thead>
                    <tbody>
                    <?php foreach ($donors as $d) { ?>
                        <tr>
                            <td><?php echo e($d['full_name']); ?></td>
                            <td><?php echo e($d['national_id']); ?></td>
                            <td><?php echo e($d['phone']); ?></td>
                            <td><?php echo e($d['type_code']); ?></td>
                            <td><?php echo e($d['region_name']); ?></td>
                            <td><span class="badge badge-<?php echo strtolower((string)$d['eligibility']); ?>"><?php echo e($d['eligibility'] ?? 'Unknown'); ?></span></td>
                            <td><?php echo e($d['next_eligible_date'] ?? '-'); ?></td>
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
