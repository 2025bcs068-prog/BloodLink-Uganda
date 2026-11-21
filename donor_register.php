<?php
/*
 * Register a new donor (staff only)
 * It saves TWO rows: one in `donor` and one in `donor_eligibility`.
 * We use a transaction so that either both are saved or neither is.
 */
require_once 'includes/auth.php';
require_login();
require 'config/database.php';

$types   = $pdo->query('SELECT blood_type_id, type_code FROM blood_type ORDER BY blood_type_id')->fetchAll(PDO::FETCH_ASSOC);
$regions = $pdo->query('SELECT region_id, region_name FROM region ORDER BY region_name')->fetchAll(PDO::FETCH_ASSOC);

$errors = [];
$old = ['national_id'=>'','full_name'=>'','gender'=>'','date_of_birth'=>'','phone'=>'','blood_type_id'=>'','region_id'=>'','weight_kg'=>''];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    foreach ($old as $field => $x) {
        $old[$field] = trim($_POST[$field] ?? '');
    }

    // ---- Check the data before saving ----
    if ($old['national_id'] === '' || $old['full_name'] === '' || $old['phone'] === '') {
        $errors[] = 'National ID, full name and phone are required.';
    }
    if (!in_array($old['gender'], ['M', 'F'], true)) {
        $errors[] = 'Please choose a gender.';
    }
    $dob = DateTime::createFromFormat('Y-m-d', $old['date_of_birth']);
    if (!$dob) {
        $errors[] = 'Please enter a valid date of birth.';
    } else {
        $age = $dob->diff(new DateTime('today'))->y;
        if ($age < 17 || $age > 65) {
            $errors[] = 'A donor must be between 17 and 65 years old.';
        }
    }
    if (!is_numeric($old['weight_kg']) || $old['weight_kg'] < 50) {
        $errors[] = 'A donor must weigh at least 50 kg.';
    }
    if ($old['blood_type_id'] === '' || $old['region_id'] === '') {
        $errors[] = 'Please choose a blood type and a region.';
    }

    // ---- The same national ID must not be registered twice ----
    if (!$errors) {
        $check = $pdo->prepare('SELECT COUNT(*) FROM donor WHERE national_id = ?');
        $check->execute([$old['national_id']]);
        if ($check->fetchColumn() > 0) {
            $errors[] = 'A donor with this national ID is already registered.';
        }
    }

    // ---- Save ----
    if (!$errors) {
        $pdo->beginTransaction();
        $ins = $pdo->prepare('INSERT INTO donor (national_id, full_name, gender, date_of_birth, phone, blood_type_id, region_id, weight_kg)
                              VALUES (?, ?, ?, ?, ?, ?, ?, ?)');
        $ins->execute([$old['national_id'], $old['full_name'], $old['gender'], $old['date_of_birth'],
                       $old['phone'], $old['blood_type_id'], $old['region_id'], $old['weight_kg']]);
        $donorId = $pdo->lastInsertId();        // the new donor's id

        $el = $pdo->prepare("INSERT INTO donor_eligibility (donor_id, status, next_eligible_date)
                             VALUES (?, 'Eligible', CURDATE())");
        $el->execute([$donorId]);
        $pdo->commit();

        header('Location: donors.php?added=1');
        exit;
    }
}

$pageTitle  = 'Register donor';
$activePage = 'donors';
require 'includes/header.php';
?>
<section class="section">
    <div class="container">
        <h1 class="page-title">Register donor</h1>

        <form class="form-box" method="post" action="donor_register.php">
            <?php foreach ($errors as $msg) { ?>
                <p class="alert alert-error" role="alert"><?php echo e($msg); ?></p>
            <?php } ?>

            <div class="form-grid">
                <div class="full">
                    <label for="full_name">Full name</label>
                    <input type="text" id="full_name" name="full_name" required value="<?php echo e($old['full_name']); ?>">
                </div>
                <div>
                    <label for="national_id">National ID</label>
                    <input type="text" id="national_id" name="national_id" required value="<?php echo e($old['national_id']); ?>">
                </div>
                <div>
                    <label for="phone">Phone</label>
                    <input type="text" id="phone" name="phone" required value="<?php echo e($old['phone']); ?>">
                </div>
                <div>
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender" required>
                        <option value="">Choose...</option>
                        <option value="M" <?php echo $old['gender'] === 'M' ? 'selected' : ''; ?>>Male</option>
                        <option value="F" <?php echo $old['gender'] === 'F' ? 'selected' : ''; ?>>Female</option>
                    </select>
                </div>
                <div>
                    <label for="date_of_birth">Date of birth</label>
                    <input type="date" id="date_of_birth" name="date_of_birth" required value="<?php echo e($old['date_of_birth']); ?>">
                </div>
                <div>
                    <label for="blood_type_id">Blood type</label>
                    <select id="blood_type_id" name="blood_type_id" required>
                        <option value="">Choose...</option>
                        <?php foreach ($types as $t) { ?>
                            <option value="<?php echo (int)$t['blood_type_id']; ?>"
                                <?php echo $old['blood_type_id'] == $t['blood_type_id'] ? 'selected' : ''; ?>><?php echo e($t['type_code']); ?></option>
                        <?php } ?>
                    </select>
                </div>
                <div>
                    <label for="region_id">Region</label>
                    <select id="region_id" name="region_id" required>
                        <option value="">Choose...</option>
                        <?php foreach ($regions as $r) { ?>
                            <option value="<?php echo (int)$r['region_id']; ?>"
                                <?php echo $old['region_id'] == $r['region_id'] ? 'selected' : ''; ?>><?php echo e($r['region_name']); ?></option>
                        <?php } ?>
                    </select>
                </div>
                <div>
                    <label for="weight_kg">Weight (kg)</label>
                    <input type="number" id="weight_kg" name="weight_kg" step="0.1" min="30" max="200" required value="<?php echo e($old['weight_kg']); ?>">
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-red">Save donor</button>
                <a class="btn btn-dark" href="donors.php">Cancel</a>
            </div>
        </form>
    </div>
</section>
<?php require 'includes/footer.php'; ?>
