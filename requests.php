<?php
/*
 * Blood requests: list all requests and create a new one (staff only)
 * A request is made for a PATIENT. The hospital and blood type
 * are copied from the patient's record, so staff cannot mix them up.
 */
require_once 'includes/auth.php';
require_login();
require 'config/database.php';

$errors = [];
$urgencies = ['Routine', 'Urgent', 'Emergency'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $patientId = $_POST['patient_id'] ?? '';
    $units     = (int)($_POST['units_needed'] ?? 0);
    $urgency   = $_POST['urgency'] ?? '';

    if ($units < 1 || $units > 20)             { $errors[] = 'Units needed must be between 1 and 20.'; }
    if (!in_array($urgency, $urgencies, true)) { $errors[] = 'Please choose an urgency.'; }

    $p = $pdo->prepare('SELECT hospital_id, blood_type_id FROM patient WHERE patient_id = ?');
    $p->execute([$patientId]);
    $patient = $p->fetch(PDO::FETCH_ASSOC);
    if (!$patient) { $errors[] = 'Please choose a patient.'; }

    if (!$errors) {
        $ins = $pdo->prepare('INSERT INTO blood_request (patient_id, hospital_id, blood_type_id, units_needed, urgency, requested_by)
                              VALUES (?, ?, ?, ?, ?, ?)');
        $ins->execute([$patientId, $patient['hospital_id'], $patient['blood_type_id'], $units, $urgency, $_SESSION['staff_id']]);
        header('Location: requests.php?added=1');
        exit;
    }
}

$patients = $pdo->query('SELECT p.patient_id, p.full_name, bt.type_code, h.hospital_name
                         FROM patient p
                         JOIN blood_type bt ON bt.blood_type_id = p.blood_type_id
                         JOIN hospital h ON h.hospital_id = p.hospital_id
                         ORDER BY p.full_name')->fetchAll(PDO::FETCH_ASSOC);

$requests = $pdo->query("SELECT r.request_date, p.full_name AS patient, h.hospital_name, bt.type_code,
                                r.units_needed, r.urgency, r.status, s.full_name AS requester
                         FROM blood_request r
                         JOIN patient p     ON p.patient_id = r.patient_id
                         JOIN hospital h    ON h.hospital_id = r.hospital_id
                         JOIN blood_type bt ON bt.blood_type_id = r.blood_type_id
                         JOIN staff s       ON s.staff_id = r.requested_by
                         ORDER BY r.request_date DESC LIMIT 100")->fetchAll(PDO::FETCH_ASSOC);

$pageTitle  = 'Requests';
$activePage = 'requests';
require 'includes/header.php';
?>
<section class="section">
    <div class="container">
        <h1 class="page-title">Blood requests</h1>

        <?php if (isset($_GET['added'])) { ?>
            <p class="alert alert-success">Blood request saved.</p>
        <?php } ?>

        <form class="form-box" method="post" action="requests.php">
            <h2>New request</h2>
            <?php foreach ($errors as $msg) { ?>
                <p class="alert alert-error" role="alert"><?php echo e($msg); ?></p>
            <?php } ?>
            <?php if (count($patients) === 0) { ?>
                <p class="empty">There are no patients yet, so a request cannot be made.</p>
            <?php } else { ?>
                <div class="form-grid">
                    <div class="full">
                        <label for="patient_id">Patient</label>
                        <select id="patient_id" name="patient_id" required>
                            <option value="">Choose...</option>
                            <?php foreach ($patients as $p) { ?>
                                <option value="<?php echo (int)$p['patient_id']; ?>"><?php echo e($p['full_name'] . ' (' . $p['type_code'] . ', ' . $p['hospital_name'] . ')'); ?></option>
                            <?php } ?>
                        </select>
                    </div>
                    <div>
                        <label for="units_needed">Units needed</label>
                        <input type="number" id="units_needed" name="units_needed" min="1" max="20" value="1" required>
                    </div>
                    <div>
                        <label for="urgency">Urgency</label>
                        <select id="urgency" name="urgency" required>
                            <?php foreach ($urgencies as $u) { ?>
                                <option value="<?php echo e($u); ?>"><?php echo e($u); ?></option>
                            <?php } ?>
                        </select>
                    </div>
                </div>
                <div class="form-actions"><button type="submit" class="btn btn-red">Save request</button></div>
            <?php } ?>
        </form>

        <div class="box" style="margin-top:1.5rem">
            <h2>All requests</h2>
            <?php if (count($requests) === 0) { ?>
                <p class="empty">No requests yet.</p>
            <?php } else { ?>
                <div class="table-scroll">
                <table class="table">
                    <thead><tr><th>Date</th><th>Patient</th><th>Hospital</th><th>Type</th><th>Units</th><th>Urgency</th><th>Status</th><th>Requested by</th></tr></thead>
                    <tbody>
                    <?php foreach ($requests as $r) { ?>
                        <tr>
                            <td><?php echo e(substr($r['request_date'], 0, 10)); ?></td>
                            <td><?php echo e($r['patient']); ?></td>
                            <td><?php echo e($r['hospital_name']); ?></td>
                            <td><?php echo e($r['type_code']); ?></td>
                            <td><?php echo (int)$r['units_needed']; ?></td>
                            <td><span class="badge badge-<?php echo strtolower($r['urgency']); ?>"><?php echo e($r['urgency']); ?></span></td>
                            <td><span class="badge badge-<?php echo strtolower(str_replace(' ', '', $r['status'])); ?>"><?php echo e($r['status']); ?></span></td>
                            <td><?php echo e($r['requester']); ?></td>
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
