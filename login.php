<?php
/*
 * Sign-in page for staff
 * Steps: 1) show the form  2) when it is sent, look the user up
 *        3) check the password  4) remember the user in the session
 */
require_once 'includes/auth.php';
require 'config/database.php';

if (is_logged_in()) {
    header('Location: dashboard.php');
    exit;
}

$error = '';

// The form is sent with method POST, so we only check when the request is a POST.
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';

    // The ? is a safe placeholder. Never put user text straight inside SQL
    // (that is how "SQL injection" attacks work).
    $stmt = $pdo->prepare('SELECT staff_id, full_name, staff_role, password
                           FROM staff WHERE username = ?');
    $stmt->execute([$username]);
    $staff = $stmt->fetch(PDO::FETCH_ASSOC);

    $ok = false;
    if ($staff) {
        $stored = $staff['password'];
        if (strpos($stored, '$2y$') === 0) {
            // Password is already stored as a safe hash
            $ok = password_verify($password, $stored);
        } else {
            // Old plain-text password: compare, then upgrade it to a hash
            $ok = hash_equals($stored, $password);
            if ($ok) {
                $upgrade = $pdo->prepare('UPDATE staff SET password = ? WHERE staff_id = ?');
                $upgrade->execute([password_hash($password, PASSWORD_DEFAULT), $staff['staff_id']]);
            }
        }
    }

    if ($ok) {
        session_regenerate_id(true);
        $_SESSION['staff_id']   = $staff['staff_id'];
        $_SESSION['full_name']  = $staff['full_name'];
        $_SESSION['staff_role'] = $staff['staff_role'];
        header('Location: dashboard.php');
        exit;
    }
    $error = 'Wrong username or password. Please try again.';
}

$pageTitle  = 'Sign in';
$activePage = 'login';
require 'includes/header.php';
?>

<section class="auth-wrap">
    <form class="auth-card" method="post" action="login.php">
        <h1>Staff sign in</h1>

        <?php if ($error !== '') { ?>
            <p class="alert alert-error" role="alert"><?php echo e($error); ?></p>
        <?php } ?>

        <label for="username">Username</label>
        <input type="text" id="username" name="username" required autofocus
               value="<?php echo e($_POST['username'] ?? ''); ?>">

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>

        <button type="submit" class="btn btn-red btn-block">Sign in</button>
    </form>
</section>

<?php require 'includes/footer.php'; ?>
