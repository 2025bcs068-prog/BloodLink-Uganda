<?php
/*
 * BloodLink Uganda - Database connection file
 * Every page that needs the database will load this file.
 * It creates one variable, $pdo, which we use to talk to MySQL.
 */

// 1. The four things PHP needs to log in to MySQL
$host     = 'localhost';          // MySQL runs on this same computer
$dbname   = 'bloodlink_uganda';   // our database name
$username = 'bloodlink_app';      // the user we created with CREATE USER
$password = 'CHANGE_ME';   // copy this file to database.php and put your real password here

// While we are learning, show the real error. Set to false when the site is finished.
$debug = false;

// 2. Try to connect
try {
    $pdo = new PDO(
        "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
        $username,
        $password,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]  // show SQL errors clearly
    );
} catch (PDOException $e) {
    // 3. If it fails, show a message (the password is never shown)
    if ($debug) {
        die('Database connection failed. Real reason: ' . $e->getMessage());
    }
    die('Database connection failed. Please contact the administrator.');
}
