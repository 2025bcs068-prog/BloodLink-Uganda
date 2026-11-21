<?php
/*
 * BloodLink Uganda - Connection test page
 * Open in the browser: http://localhost/bloodlink/test_connection.php
 */

// Load the connection file (this creates $pdo)
require 'config/database.php';

// Ask MySQL: "which tables exist in this database?"
$tables = $pdo->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Connection Test - BloodLink Uganda</title>
</head>
<body>
    <h2>Connected to the BloodLink database</h2>
    <p>Tables found: <?php echo count($tables); ?></p>
    <ul>
        <?php foreach ($tables as $table) { ?>
            <li><?php echo htmlspecialchars($table); ?></li>
        <?php } ?>
    </ul>
</body>
</html>
