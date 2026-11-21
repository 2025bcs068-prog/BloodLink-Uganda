<?php
/*
 * Header - the top of every page.
 * The page sets $pageTitle and $activePage BEFORE loading this file.
 */
require_once __DIR__ . '/auth.php';

$menu = [
    'dashboard' => ['dashboard.php',   'Home'],
    'donors'    => ['donors.php',      'Donors'],
    'units'     => ['blood_units.php', 'Blood units'],
    'requests'  => ['requests.php',    'Requests'],
    'hospitals' => ['hospitals.php',   'Hospitals'],
];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?php echo e($pageTitle); ?> | BloodLink Uganda</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <div class="flag-stripe"></div>
    <header class="site-header">
        <div class="container header-row">
            <a class="brand" href="index.php">
                <span class="drop" aria-hidden="true"></span>
                <span class="brand-name">BloodLink <span class="brand-light">Uganda</span></span>
            </a>

            <?php if (is_logged_in()) { ?>
                <nav class="main-nav" aria-label="Main menu">
                    <ul>
                        <?php foreach ($menu as $key => $item) { ?>
                            <li><a href="<?php echo $item[0]; ?>"
                                   class="<?php echo ($key === $activePage) ? 'active' : ''; ?>"><?php echo $item[1]; ?></a></li>
                        <?php } ?>
                    </ul>
                </nav>
            <?php } ?>

            <div class="header-actions">
                <button type="button" class="link-btn" data-open-panel>About</button>
                <?php if (is_logged_in()) { ?>
                    <span class="who"><?php echo e($_SESSION['full_name']); ?></span>
                    <a class="btn btn-small btn-dark" href="logout.php">Sign out</a>
                <?php } else { ?>
                    <a class="btn btn-small btn-red" href="login.php">Staff sign in</a>
                <?php } ?>
            </div>
        </div>
    </header>
    <main>
