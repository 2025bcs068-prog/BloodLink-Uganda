<?php
/*
 * Login helpers - loaded by every page.
 * A "session" is how the server remembers who you are between pages.
 */
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Is a staff member signed in?
function is_logged_in() {
    return isset($_SESSION['staff_id']);
}

// Put this at the top of any page that only staff may see.
// If nobody is signed in, send the visitor to the sign-in page.
function require_login() {
    if (!is_logged_in()) {
        header('Location: login.php');
        exit;
    }
}

// Makes text safe before we print it on a page (short name: e)
function e($text) {
    return htmlspecialchars((string)$text, ENT_QUOTES, 'UTF-8');
}
