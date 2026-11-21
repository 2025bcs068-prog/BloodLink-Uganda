# BloodLink Uganda

A web-based Blood Donor Database Management System built with **PHP, MySQL, HTML and CSS**.

The project shows how a web application connects to a database through PHP: a staff member uses a web page, PHP runs on the server, and PHP reads from and writes to a MySQL database.

Author: Elijah Biyimbwa Simwogerere

---

## 1. The problem

Uganda needs about 500,000 units of blood each year but collects about 439,000. Part of this gap is a data problem. Donor records are kept on paper and in spreadsheets, so blood banks cannot quickly:

- find donors who are eligible to give blood again,
- bring donors back for repeat donations,
- track stored blood units before they expire,
- see which hospitals have urgent requests.

## 2. The solution

BloodLink is one central database with a web application on top of it. It answers three questions:

| Question | How BloodLink answers it |
|---|---|
| Who can donate now? | Every donor has an eligibility record with a "next eligible date" |
| Where is the blood I need? | Staff search donors by blood type and region, and see live stock per blood type |
| Is stored blood about to expire? | Every blood unit has an expiry date, and units close to expiry are flagged |

## 3. Features

- Public home page with live blood stock per blood type (read from the database)
- Staff sign-in with hashed passwords and sessions
- Dashboard with live numbers, open blood requests (emergencies first) and units expiring soon
- Register a donor (with validation) and see the donor list with search and filters
- Blood units list with status filter and expiry warning
- Create hospital blood requests for a patient, and list all requests
- Hospitals list with the linked blood bank
- Pages hidden from visitors who are not signed in

## 4. Technology

| Part | Tool |
|---|---|
| Operating system | Fedora Linux |
| Web server | Apache (httpd) |
| Language | PHP 8 with the PDO database extension |
| Database | MySQL 8.4 |
| Front end | HTML, CSS, a small amount of JavaScript |

## 5. How it works (architecture)

```
Browser  ->  Apache  ->  PHP  ->  PDO  ->  MySQL
 (asks)     (receives)  (runs     (the      (stores
                         code)    driver)    data)
Browser  <-  a finished HTML page  <-  rows of data
```

1. The browser asks for a page, for example `donors.php`.
2. Apache gives the file to PHP.
3. PHP loads `config/database.php`, which logs in to MySQL and creates the connection `$pdo`.
4. PHP sends an SQL query through `$pdo`. MySQL returns rows.
5. PHP puts the rows inside HTML. Only this finished HTML goes back to the browser. The PHP code and the database password are never sent to the browser.

## 6. Project structure

```
BloodLink-Uganda/
  config/
    database.example.php   Template for the database login (copy to database.php)
  includes/
    auth.php               Sessions, sign-in check, safe-text helper e()
    header.php             Top of every page: logo and menu
    footer.php             Bottom of every page and the About panel
  assets/
    css/style.css          All colours and layout
    js/app.js              Opens and closes the About panel
  database/
    bloodlink.sql          Database structure and starting data
    sample_data.sql        Sample donors, units, patients and requests
  index.php                Public home page
  login.php  logout.php    Sign in and sign out
  dashboard.php            Staff home
  donors.php               Donor list, search and filters
  donor_register.php       Register a donor
  blood_units.php          Blood stock and expiry
  requests.php             Create and list blood requests
  hospitals.php            Hospitals and linked blood banks
  test_connection.php      Checks that PHP can reach the database
```

## 7. The database

Database name: `bloodlink_uganda`, with 15 tables.

Tables used by the web application now: `donor`, `donor_eligibility`, `blood_type`, `region`, `blood_unit`, `blood_bank`, `blood_request`, `patient`, `hospital`, `staff`.

Tables designed for later pages: `donation`, `donation_drive`, `medical_screening`, `reminder_notification`, `request_fulfillment`.

Tables hold ids (for example `region_id = 6`) and not repeated text. The web pages use `JOIN` to turn ids back into names such as "Gulu".

## 8. Installation (Fedora Linux)

### 1. Install the software
```
sudo dnf install httpd php php-mysqlnd php-fpm
sudo systemctl enable --now httpd php-fpm
sudo setsebool -P httpd_can_network_connect_db 1
```
The last line lets Apache talk to MySQL on Fedora (SELinux rule).

### 2. Create the database
```
mysql -u root -p -e "CREATE DATABASE bloodlink_uganda;"
mysql -u root -p bloodlink_uganda < database/bloodlink.sql
mysql -u root -p < database/sample_data.sql
```

### 3. Create a database user for the website
```
mysql -u root -p
CREATE USER 'bloodlink_app'@'localhost' IDENTIFIED BY 'choose_a_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON bloodlink_uganda.* TO 'bloodlink_app'@'localhost';
FLUSH PRIVILEGES;
```
The website does not use `root`. It uses a user that can only read and write this one database.

### 4. Copy the project into the web folder
```
sudo mkdir -p /var/www/html/bloodlink
sudo cp -r . /var/www/html/bloodlink/
sudo chown -R $USER:apache /var/www/html/bloodlink
sudo restorecon -R /var/www/html/bloodlink
```

### 5. Add the database login
```
cd /var/www/html/bloodlink/config
cp database.example.php database.php
nano database.php          # put your real password in $password
```

### 6. Run it
Open `http://localhost/bloodlink/test_connection.php`. It should say "Tables found: 15".
Then open `http://localhost/bloodlink/`.

Staff accounts are in the `staff` table (`SELECT username, staff_role FROM staff;`). On first sign-in a plain-text password is replaced by a hash.

## 9. How the code came together

1. **Design the database first.** Tables, keys and relationships for donors, eligibility, donations, blood units, hospitals, requests and staff.
2. **Set up the server.** Install Apache, PHP and the MySQL driver, and test with a one-line PHP file.
3. **Connect PHP to MySQL.** One file, `config/database.php`, creates `$pdo`. Every page loads it with `require`.
4. **Share the page layout.** `header.php` and `footer.php` hold the menu and footer, so a change is made once.
5. **Build read pages.** Home and dashboard use `SELECT` queries with `COUNT` and `JOIN`.
6. **Add sign-in.** Sessions remember the staff member. Prepared statements protect the login query. Passwords are hashed.
7. **Add write pages.** Donor registration and blood requests use `INSERT`, with validation and a transaction.
8. **Add search and filters.** The donor and blood unit lists build their SQL from the filters that were used.
9. **Add sample data and test every page.**

## 10. The SQL queries (what each one asks and why)

| File | Query | Purpose |
|---|---|---|
| index.php | `SELECT bt.type_code, COUNT(bu.unit_id) ... FROM blood_type bt LEFT JOIN blood_unit bu ... GROUP BY bt.blood_type_id` | Units in storage for each blood type. LEFT JOIN keeps types with zero units. |
| dashboard.php | `SELECT COUNT(*) FROM donor WHERE is_active = 1` | Number of active donors |
| dashboard.php | `SELECT COUNT(*) FROM blood_unit WHERE status = 'In Storage'` | Units in storage |
| dashboard.php | `SELECT COUNT(*) FROM blood_request WHERE status IN ('Pending','Partially Fulfilled')` | Open requests |
| dashboard.php | `... WHERE expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)` | Units expiring within 7 days |
| dashboard.php | `SELECT ... FROM blood_request r JOIN hospital h ... JOIN blood_type bt ... ORDER BY FIELD(r.urgency,'Emergency','Urgent','Routine')` | Open requests, emergencies first |
| login.php | `SELECT staff_id, full_name, staff_role, password FROM staff WHERE username = ?` | Find the staff member (the ? is a safe placeholder) |
| login.php | `UPDATE staff SET password = ? WHERE staff_id = ?` | Replace a plain-text password with a hash |
| donor_register.php | `SELECT COUNT(*) FROM donor WHERE national_id = ?` | Stop duplicate donors |
| donor_register.php | `INSERT INTO donor (...) VALUES (?, ?, ...)` | Save the donor |
| donor_register.php | `INSERT INTO donor_eligibility (donor_id, status, next_eligible_date) VALUES (?, 'Eligible', CURDATE())` | Save the eligibility record (same transaction) |
| donors.php | `SELECT ... FROM donor d JOIN blood_type ... JOIN region ... LEFT JOIN donor_eligibility ... WHERE ... LIKE ?` | Donor list with search and filters |
| blood_units.php | `SELECT ..., DATEDIFF(u.expiry_date, CURDATE()) AS days_left FROM blood_unit u JOIN ...` | Stock list with days left before expiry |
| requests.php | `SELECT hospital_id, blood_type_id FROM patient WHERE patient_id = ?` | Copy hospital and blood type from the patient |
| requests.php | `INSERT INTO blood_request (...) VALUES (?, ?, ?, ?, ?, ?)` | Save the request |
| requests.php | `SELECT ... FROM blood_request r JOIN patient ... JOIN hospital ... JOIN staff ...` | List all requests with who requested them |
| hospitals.php | `SELECT ... FROM hospital h JOIN region r ... LEFT JOIN blood_bank bb ...` | Hospitals with their linked blood bank |

The four basic database actions all appear: Create (`INSERT`), Read (`SELECT`), Update (`UPDATE`) and Delete (the website user is allowed `DELETE`, ready for later pages).

## 11. Security

- **Prepared statements** (`?` placeholders) stop SQL injection.
- **`htmlspecialchars`** (the `e()` helper) stops script injection (XSS) when data is shown on a page.
- **Hashed passwords** (`password_hash`, `password_verify`) mean real passwords cannot be read from the database.
- **Sessions** and `require_login()` keep visitors out of staff pages.
- **Least privilege:** the website uses its own MySQL user, not `root`.
- **Server-side validation:** age 17 to 65, weight at least 50 kg, no duplicate national ID.
- **The real database password is not in this repository.** `config/database.php` is listed in `.gitignore`.

## 12. Limits and future work

- Pages for donations, medical screening, donation drives, reminders and request fulfilment are designed in the database but not built in the web application yet.
- The system stores contact details and shows when a donor can give blood again, so staff can contact them. It does not send messages by itself yet.
- There is no page for an Admin to add or edit staff accounts.
