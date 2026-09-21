# Warehouse Inventory Management System (WIMS)
## Formative Assessment Project Plan & Architecture Guide
**Academic Level:** Second Year Engineering (Semester 3/4)  
**Subject:** Internet Programming (IP) Lab — Java Backend Track  
**Submission Requirement:** Frontend Screenshots + MySQL Database Screenshots (Design & Initial State)

---

## 1. Project Overview & Scope

### Problem Statement
Modern warehouses face inventory inaccuracies, misplaced items across storage racks, and stockouts of critical materials. A **Warehouse Inventory Management System (WIMS)** provides real-time visibility into:
- Stock levels across different warehouse zones and racks.
- Automated threshold alerts when items drop below minimum reorder levels.
- Comprehensive audit trails for inward receipts (purchases) and outward dispatches (sales/internal issues).
- Supplier directory linked directly to stocked items.

### Scope for Formative Assessment (FA-1)
Because you are **two sessions into your IP lab**, college professors expect a solid architectural foundation rather than a complex full-scale enterprise app:
1. **Interactive Frontend:** A clean dashboard and data-entry views demonstrating user workflows.
2. **Normalized MySQL Schema:** Real tables, primary/foreign key relationships, and representative warehouse dummy data.
3. **Screenshots Package:** Clear, well-labeled visual evidence of the working interface and database queries for the assessment report.

---

## 2. Recommended Tech Stack

Tailored specifically to match standard 2nd-year IP lab curriculums (Mumbai University, SPPU, VTU, AKTU, etc.):

| Layer | Recommended Technology | Why This Fits Your 2nd-Year Level |
| :--- | :--- | :--- |
| **Frontend** | **HTML5 + CSS3 + Vanilla JavaScript** (Self-contained, responsive layout) | Zero build steps or npm complexity. Easy to customize, opens instantly in any browser, and produces crisp screenshots. |
| **Database** | **MySQL 8.0 / MariaDB** (via MySQL Workbench / phpMyAdmin / CLI) | The universal standard required by your syllabus; supports foreign keys, triggers, and relational integrity. |
| **Backend** | **Java (JDBC + Servlets / JSP) OR Spring Boot Starter** | - **Option A (Classic Syllabus):** Servlets + JDBC + Tomcat (what most IP labs teach in weeks 3–6).<br>- **Option B (Modern Syllabus):** Spring Boot (Spring Web + Spring Data JPA). |
| **Architecture** | **MVC (Model-View-Controller)** | Clear separation of concerns that examiners check during assessments and viva. |

---

## 3. Database Schema Design (MySQL)

The database `warehouse_db` consists of **5 relational tables** designed in 3rd Normal Form (3NF):

```
       +-------------------+             +--------------------+
       |    categories     |             |     locations      |
       +-------------------+             +--------------------+
       | category_id (PK)  |             | location_id (PK)   |
       | category_name     |             | warehouse_name     |
       | description       |             | zone_code, rack_no |
       +---------+---------+             +---------+----------+
                 | 1                               | 1
                 |                                 |
                 | N                             N |
       +---------v---------------------------------v----------+
       |                       products                       |
       +------------------------------------------------------+
       | product_id (PK)                                      |
       | sku_code (UNIQUE)                                    |
       | product_name, unit_price, quantity_in_stock          |
       | min_reorder_level, unit_of_measure                   |
       | category_id (FK), location_id (FK), supplier_id (FK) |
       +---------+--------------------------------------------+
                 | 1                               ^ 1
                 |                                 |
                 | N                             N |
       +---------v------------+          +---------+----------+
       |  stock_transactions  |          |     suppliers      |
       +----------------------+          +--------------------+
       | transaction_id (PK)  |          | supplier_id (PK)   |
       | product_id (FK)      |          | supplier_name      |
       | transaction_type     |          | email, phone, city |
       | quantity, ref_no     |          +--------------------+
       | handler_name, date   |
       +----------------------+
```

### Table Breakdown
1. **`categories`**: Classifies inventory into Industrial Tools, Packaging, Sensors/Electronics, PPE, and Raw Materials.
2. **`locations`**: Tracks physical storage (e.g., Main Hub, Zone A, Rack A-01, Max Capacity).
3. **`suppliers`**: Stores vendor contact information for restocking orders.
4. **`products`**: Central inventory table storing SKUs, names, unit prices, real-time quantities, and reorder trigger levels.
5. **`stock_transactions`**: Audit log recording every `INWARD_RECEIPT` (+) or `OUTWARD_DISPATCH` (-) movement with reference PO numbers and handler names.

---

## 4. Frontend Views Implemented (For Screenshots)

You have a live working frontend ready in `index.html`. You can capture screenshots of these views:

1. **Dashboard Overview View:**
   - 4 Top Metric Cards (Total Products: 12, Storage Units: 1,216, Low Stock Alerts: 4, Total Valuation: ₹5,41,640).
   - Real-time stock status table with color-coded badges (Green = Optimal, Orange = Low Stock, Red = Critical/Out of Stock).
2. **Product Filtering & Search:**
   - Demonstrating instant client-side search by item name/SKU and filtering by category or low-stock status.
3. **Modal Form: "Add New Product":**
   - Inputs for SKU, Product Name, Category dropdown, Rack Location dropdown, Price, Initial Stock, and Min Threshold.
4. **Modal Form: "Record Stock Movement":**
   - Inward Receipt vs. Outward Dispatch toggle, Product picker, Quantity, Reference PO number, and Handler sign-off.
5. **Stock Movement Log View:**
   - Tab showing recent shipment entries and dispatch records with timestamps and positive/negative quantity changes.
6. **Warehouse Racks & Capacity View:**
   - Tab displaying designated storage zones, rack codes, and available capacities.

---

## 5. Guide: Taking Your Submission Screenshots

### A. Frontend Screenshots Checklist
1. **SS-FE-01: Main Dashboard:** Open the running app, ensure all 4 metric cards and top rows of inventory are visible.
2. **SS-FE-02: Low-Stock Filter Active:** Select "Low & Critical Stock Only" in the dropdown so the table highlights items needing reorder (e.g., Torque Wrench, Packing Tape, Safety Vests).
3. **SS-FE-03: Add Product Modal:** Click **"Add New Product"** and capture the open modal form filled with sample details.
4. **SS-FE-04: Stock Movement Audit Log:** Click the **"Stock In / Out Logs"** tab on the left sidebar to capture the transaction history table.

### B. Database (MySQL) Screenshots Checklist
Run the provided `warehouse_inventory_db.sql` in **MySQL Workbench**, **phpMyAdmin**, or **MySQL Command Line**, and take screenshots of:

1. **SS-DB-01: Table Creation & Verification:**
   ```sql
   USE warehouse_db;
   SHOW TABLES;
   ```
2. **SS-DB-02: Table Schema (Structure):**
   ```sql
   DESCRIBE products;
   ```
3. **SS-DB-03: Inventory Master Query Output:**
   ```sql
   SELECT sku_code, product_name, quantity_in_stock, min_reorder_level, unit_price 
   FROM products;
   ```
4. **SS-DB-04: Low-Stock Trigger Query (Crucial for professors):**
   ```sql
   SELECT p.sku_code, p.product_name, p.quantity_in_stock, p.min_reorder_level, s.supplier_name
   FROM products p
   JOIN suppliers s ON p.supplier_id = s.supplier_id
   WHERE p.quantity_in_stock <= p.min_reorder_level;
   ```
5. **SS-DB-05: Transaction Audit Log:**
   ```sql
   SELECT transaction_id, reference_no, transaction_type, quantity, handler_name, transaction_date 
   FROM stock_transactions 
   ORDER BY transaction_date DESC;
   ```

---

## 6. Project Roadmap: Step-by-Step

### Phase 1: Current Assessment (Formative Assessment 1) — *Done*
- [x] Defined requirements and realistic scope for 2nd-year level.
- [x] Built relational MySQL schema with 5 tables and realistic Indian warehouse data.
- [x] Developed clean, responsive frontend dashboard ready for immediate screenshots.
- [x] Formatted SQL queries specifically for assessment evaluation.

### Phase 2: Java Backend Connectivity (Sessions 3 & 4)
- Create `DBConnection.java` using `java.sql.DriverManager` and `Connection`.
- Configure `mysql-connector-j` JDBC driver.
- Write simple DAO classes (`ProductDAO.java`, `TransactionDAO.java`) executing `PreparedStatement` queries.

### Phase 3: Servlet / Controller Integration (Sessions 5 & 6)
- Build `ProductServlet.java` to handle GET (fetch products) and POST (add product / update stock).
- Handle JSON response or forward data to JSP using `request.setAttribute()`.

### Phase 4: Final Demonstration & Viva Preparation (End of Semester)
- Prepare for viva questions on JDBC lifecycle, SQL normalization, SQL injections prevention via `PreparedStatement`, and HTTP methods (GET vs. POST).
