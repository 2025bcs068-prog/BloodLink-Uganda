# BloodLink Uganda: Understanding and Presentation Notes

Read this once slowly, then practise saying each part out loud WITHOUT reading. The goal is that you explain in your own words.

---

## 1. The project in 60 seconds (memorise the shape, not the words)

1. **Problem:** Uganda needs about 500,000 units of blood a year and collects about 439,000. Part of the gap is a data problem: records are on paper and spreadsheets.
2. **Solution:** one central database, with a web application on top, so staff can find eligible donors, track blood units and expiry, and record hospital requests.
3. **What this project is really about:** how a web application connects to a database through PHP.

---

## 2. The ideas you must understand

### 2.1 What is a web application?
A program you use through a browser. The program does not run on your screen. It runs on a **server**. The browser only shows the result.

### 2.2 Client and server
- **Client** = the browser. It asks.
- **Server** = Apache + PHP + MySQL on the computer. It answers.
- They talk using **HTTP**: the browser sends a *request* ("give me donors.php"), the server sends back a *response* (an HTML page).

### 2.3 The three layers
| Layer | Job | In my project |
|---|---|---|
| Presentation | What the user sees | HTML and CSS in the browser |
| Application (logic) | Decisions and rules | PHP files, run by Apache |
| Data | Stores the information | MySQL database `bloodlink_uganda` |

PHP sits in the middle. It is the only layer that talks to both sides.

### 2.4 What does "database connectivity" mean?
It means PHP can log in to MySQL and exchange data with it. Four things make it work:
1. **A driver** (`php-mysqlnd`): the translator between PHP and MySQL.
2. **PDO**: the PHP tool that uses the driver.
3. **Credentials**: host, database name, username, password (in `config/database.php`).
4. **SQL**: the language PHP uses to ask MySQL for things.

### 2.5 The life of one connection
1. A page loads `database.php` with `require`.
2. `new PDO(...)` logs in. MySQL checks the user, the password and the database.
3. If all is correct, PHP gets `$pdo`, an open line to the database.
4. The page sends SQL through `$pdo`, and gets rows back.
5. When the page finishes, PHP closes the connection by itself.

### 2.6 GET and POST
- **GET:** data travels in the address bar (`donors.php?q=Ruth`). Used for searching and filtering. Safe to repeat.
- **POST:** data travels hidden inside the request. Used for sign-in and registration, because it changes things or contains secrets.

### 2.7 Sessions
HTTP forgets you after every page. A **session** fixes that: after sign-in, PHP gives your browser a secret ticket (a cookie) and remembers on the server who you are. Each staff page checks the ticket with `require_login()`.

### 2.8 CRUD
The four things any database application does:
- **Create** = `INSERT` (register donor, new request)
- **Read** = `SELECT` (every list and number)
- **Update** = `UPDATE` (password upgrade at sign-in)
- **Delete** = `DELETE` (permitted for the website user, ready for later)

---

## 3. Three flows, step by step (practise these)

### Flow A: A visitor opens the home page (READ)
1. Browser asks for `http://localhost/bloodlink/`.
2. Apache finds `index.php` and gives it to PHP.
3. `index.php` loads `database.php`, so `$pdo` exists.
4. PHP runs one query: count the units "In Storage" for each blood type, using `LEFT JOIN` so all 8 types appear.
5. PHP loops over the 8 rows with `foreach` and prints one tile each.
6. The finished HTML goes back to the browser.

### Flow B: A staff member signs in (READ, then maybe UPDATE)
1. The sign-in form is sent with **POST**.
2. `login.php` runs `SELECT ... FROM staff WHERE username = ?` as a **prepared statement**.
3. It checks the password with `password_verify()` against the stored **hash**. (If an old plain-text password is found, it is checked and then replaced by a hash with an `UPDATE`.)
4. On success, PHP saves the staff id and name in `$_SESSION` and redirects to the dashboard.
5. Every staff page now starts with `require_login()`.

### Flow C: A staff member registers a donor (CREATE)
1. The form is sent with POST.
2. PHP validates: required fields, age 17 to 65, weight at least 50 kg.
3. PHP checks the national ID is not already in the `donor` table.
4. A **transaction** starts: `INSERT` into `donor`, take the new id with `lastInsertId()`, `INSERT` into `donor_eligibility`, then `commit`. Both rows are saved or neither is.
5. PHP redirects to the donor list, which now shows the new donor.

---

## 4. How I wrote the files (say this when asked "how did you build it")

1. I designed the database first (15 tables), because the web pages depend on it.
2. I installed Apache, PHP and the MySQL driver, and tested with a one-line PHP file.
3. I wrote `database.php` once, so every page connects the same way.
4. I wrote `header.php` and `footer.php` so the menu is written once and reused.
5. I built read pages first (home, dashboard), because reading is the simplest use of the database.
6. I added sign-in, sessions and password hashing to protect staff pages.
7. I added write pages (register donor, new request) with validation and a transaction.
8. I added search and filters.
9. I loaded sample data and tested every page, then checked the new rows in MySQL.

---

## 5. Slide outline (the slides follow this order)

| # | Slide | What to say (in your own words) |
|---|---|---|
| 1 | The problem | Numbers, and that part of the gap is a data problem |
| 2 | The solution | One central database; who can donate, where is blood, what is expiring |
| 3 | How a web app uses a database | Browser, Apache, PHP, MySQL; PHP is the middle |
| 4 | The database | 15 tables, ids and JOIN; which tables the web app uses now |
| 5 | Connecting PHP to MySQL | `database.php`, PDO, `$pdo`, `require` |
| 6 | Reading and writing data | CRUD with real queries from my project |
| 7 | Security and conclusion | Prepared statements, hashing, sessions, least privilege; what is next |

---

## 6. Live demo (about 5 minutes)

1. Show the three servers are running: `systemctl is-active httpd php-fpm mysqld`.
2. Open `test_connection.php`: "PHP logged in to MySQL and listed 15 tables."
3. Open the home page: "These tiles are counted from MySQL when the page loads."
4. Press About, then sign in as staff.
5. Dashboard: open requests (emergencies first) and expiring units.
6. Donors: search by name, filter by blood type.
7. Register donor: first weight 40 (error), then a valid donor.
8. In the terminal, show the new row:
   `mysql -u bloodlink_app -p bloodlink_uganda -e "SELECT donor_id, full_name FROM donor ORDER BY donor_id DESC LIMIT 3;"`
   Say: "I typed this in the browser, PHP saved it, and here it is in the database."

---

## 7. Questions the teacher may ask

- **What is the role of Apache?** It receives the browser's request and gives PHP files to PHP. It does not talk to the database.
- **What is the role of PHP?** It runs the logic, talks to MySQL, and builds the HTML page.
- **Why PDO and not mysqli?** PDO is safer to use with prepared statements, and the same code style works with other databases.
- **What is a prepared statement?** SQL with `?` placeholders. The typed values are sent separately, so they cannot change the query. It stops SQL injection.
- **What is SQL injection?** Typing SQL code into a form so that the database runs it. Prepared statements prevent it.
- **What is XSS and how do you stop it?** Putting script code in a text field so it runs in other people's browsers. I use `htmlspecialchars` through the `e()` helper.
- **Why hash passwords?** If the database leaks, real passwords cannot be read. A hash cannot be turned back into the password.
- **Why not use root for the website?** Least privilege. The website user can only read and write one database, so an attack does less damage.
- **What is a transaction and where do you use it?** A group of changes that succeed or fail together. I use it when registering a donor, so no donor exists without an eligibility record.
- **Why JOIN?** Tables store ids to avoid repeating data. JOIN brings the names back for display.
- **Why LEFT JOIN on the home page?** To keep blood types that have zero units.
- **What is the staff table?** The people at blood banks and hospitals who operate the system. It controls sign-in and records who did each job (collected, screened, requested, issued).
- **Why no public sign-up?** Anyone could create an account and see private donor data. In a real system an Admin creates staff accounts.
- **What is a session?** The server's memory of who you are between pages, linked to a cookie in your browser.
- **How do you keep the database password out of GitHub?** `config/database.php` is in `.gitignore`. The repository has only `database.example.php`.
- **Will it solve the shortage?** No. It reduces the gap by making donors and blood easier to find and by reducing waste. It supports donation drives and does not replace them.

### Be honest about the limits
- The tables for donations, screening, drives, reminders and fulfilment exist in the database but do not have web pages yet.
- The system shows when a donor can give again, so staff can contact them. It does not send messages by itself.
- There is no Admin page to add staff yet.

Saying this clearly makes you sound confident, because you know exactly what your system does.
