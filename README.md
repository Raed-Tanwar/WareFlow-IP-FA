# 📦 WareFlow — Warehouse Inventory Management System (WIMS)

An enterprise-ready, lightweight **Warehouse Inventory Management System (WIMS)** designed for real-time tracking of physical stock, warehouse storage zones, automated reorder threshold monitoring, and complete inward/outward material movement auditing.

---

## 📑 Table of Contents
1. [Overview & Problem Statement](#-overview--problem-statement)
2. [Key Objectives & Capabilities](#-key-objectives--capabilities)
3. [System Architecture](#-system-architecture)
4. [Functional Modules](#-functional-modules)
5. [Database Schema & ER Design](#-database-schema--er-design)
6. [Core Business Logic & Workflows](#-core-business-logic--workflows)
7. [Technology Stack](#-technology-stack)
8. [Project Structure](#-project-structure)
9. [Quick Installation & Setup](#-quick-installation--setup)
10. [System Interface & Feature Tour](#-system-interface--feature-tour)
11. [Future Roadmap](#-future-roadmap)

---

## 📌 Overview & Problem Statement

### The Industry Challenge
In contemporary logistics, distribution centers, and manufacturing supply chains, managing inventory through static spreadsheets or legacy ledger entries leads to systemic vulnerabilities:
- **Discrepancy Drift:** Physical stock diverging from digital records due to unrecorded or miscategorized material transfers.
- **Costly Stockouts:** Unanticipated shortages of high-priority tools, components, or packaging materials halting operations.
- **Inefficient Storage Utilization:** Warehouse personnel expending labor hours searching for misplaced items across unmapped bays and racks.
- **Audit Deficits:** Inability to track which supervisor or handler authorized a material dispatch or confirmed a vendor delivery.

### The Solution: WareFlow
**WareFlow (WIMS)** provides a centralized, relational database-backed solution that bridges storage operations with real-time analytics. It enforces strict referential integrity across product lines, tracks stock inward and outward movements with reference numbers, and provides immediate visual warnings when inventory drops below predefined safety thresholds.

---

## 🎯 Key Objectives & Capabilities

1. **Real-Time Inventory Auditing:** Centralized oversight across multiple item categories (Industrial Tools, Packaging Materials, Electronics & Sensors, Safety & PPE, Raw Materials).
2. **Automated Safety Stock Alerts:** Dynamic classification of items as `OPTIMAL`, `LOW STOCK`, or `CRITICAL LOW` using real-time threshold comparison logic.
3. **Traceable Material Movements:** Permanent audit logging of every inward shipment receipt (`INWARD_RECEIPT`) and outward dispatch (`OUTWARD_DISPATCH`).
4. **Physical Storage Topology:** Granular mapping of products to specific warehouse facilities, designated zones (e.g., Fast Moving, Heavy Bulk, Controlled Cold/Electronics), and shelf racks.
5. **Vendor & Supplier Directory:** Integrated vendor profiles tied directly to product SKUs to streamline replenishment procurement.

---

## 🏗️ System Architecture

WareFlow follows a clean **Three-Tier Architecture** enforcing separation of concerns between presentation, business rules, and data persistence:

```text
+-------------------------------------------------------------------------+
|                         PRESENTATION TIER                               |
|   - Responsive Web Dashboard (HTML5, Custom CSS Design System)          |
|   - Client-side State, Search & Filter Engine (Vanilla JavaScript ES6+) |
|   - Interactive Modals for Product Entry & Stock Movement Logging       |
+------------------------------------+------------------------------------+
                                     |
                                     | Data Exchange Protocol
                                     v
+-------------------------------------------------------------------------+
|                      APPLICATION & DATA ACCESS TIER                     |
|   - Domain Models / Data Encapsulation (Product.java)                   |
|   - Data Access Object Layer (ProductDAO.java) via PreparedStatements  |
|   - JDBC Connection Pooling Manager (DBConnection.java)                 |
|   - Core Application Test Suite (Main.java)                             |
+------------------------------------+------------------------------------+
                                     |
                                     | JDBC Protocol (Port 3306)
                                     v
+-------------------------------------------------------------------------+
|                            DATA STORAGE TIER                            |
|   - MySQL 8.0 Relational Engine (`warehouse_db`)                        |
|   - 5 Relational Tables Normalized in 3rd Normal Form (3NF)             |
|   - Cascading Constraints, Foreign Keys & Unique Identifiers            |
+-------------------------------------------------------------------------+
```

---

## ⚙️ Functional Modules

### 1. Central Executive Dashboard
- **Total SKUs Tracked:** Live tally of active unique catalog items.
- **Physical Storage Volume:** Aggregate summation of all units held across warehouse facilities.
- **Low Stock Reorder Alerts:** Critical counter of items breaching minimum safety thresholds.
- **Inventory Asset Valuation:** Financial calculation derived from:
  $$\text{Total Valuation} = \sum (\text{Quantity in Stock} \times \text{Unit Price})$$

### 2. Inventory Master Catalog
- Standardized product management:
  - **SKU Code:** Unique standard identifier (e.g., `SKU-TOOL-101`, `SKU-ELEC-301`).
  - **Product Name & Category:** Categorized by industrial equipment classification.
  - **Warehouse Rack Location:** Precise coordinates (e.g., `Zone-A (Rack-01)`).
  - **Unit Pricing & Real-Time Stock:** Volume tracking with instant visual status indicators.
- **Instant Search & Multi-Filter Engine:** Client-side real-time filtering by SKU code, name, equipment category, or stock severity.

### 3. Material Movement & Audit Log
- Immutable tracking of all inventory adjustments:
  - **Inward Receipt (`INWARD_RECEIPT`):** Logs goods arriving from suppliers, increments stock, and records vendor purchase orders (PO).
  - **Outward Dispatch (`OUTWARD_DISPATCH`):** Logs materials issued to production or dispatched to clients, validates stock sufficiency, and decrements inventory balance.
  - **Handler Identification:** Records the specific warehouse supervisor or operator who authorized the transaction.

### 4. Storage Facility & Rack Management
- Manages warehouse zoning:
  - **Zone A:** High-velocity fast-moving goods (packaging materials, high-turnover hand tools).
  - **Zone B:** Heavy bulk and raw metal materials.
  - **Zone C:** Safety PPE and regulated protective gear.
  - **Zone D:** High-value industrial electronics, scanners, and RFID tags.
  - Monitors rack occupancy against maximum permissible capacity.

### 5. Vendor & Supplier Directory
- Maintains supplier profiles (company name, contact representative, corporate email, phone, operating city) linked via relational foreign keys.

---

## 🗄️ Database Schema & ER Design

The database `warehouse_db` consists of **5 relational tables (3NF)** with strict referential integrity:

```text
       +-----------------------+              +------------------------+
       |      categories       |              |       locations        |
       +-----------------------+              +------------------------+
       | category_id (PK, INT) |              | location_id (PK, INT)  |
       | category_name (VARCHAR|              | warehouse_name (VARCHAR|
       | description (VARCHAR) |              | zone_code (VARCHAR)    |
       +-----------+-----------+              | rack_number (VARCHAR)  |
                   | 1                        | max_capacity_units(INT)|
                   |                          +-----------+------------+
                   |                                      | 1
                   | N                                  N |
       +-----------v--------------------------------------v------------+
       |                           products                            |
       +---------------------------------------------------------------+
       | product_id (PK, INT AUTO_INCREMENT)                           |
       | sku_code (VARCHAR UNIQUE)                                     |
       | product_name (VARCHAR NOT NULL)                               |
       | category_id (FK -> categories.category_id)                    |
       | location_id (FK -> locations.location_id)                     |
       | supplier_id (FK -> suppliers.supplier_id)                     |
       | unit_price (DECIMAL(10,2))                                    |
       | quantity_in_stock (INT NOT NULL)                              |
       | min_reorder_level (INT NOT NULL)                              |
       | unit_of_measure (VARCHAR)                                     |
       +-----------+---------------------------------------+-----------+
                   | 1                                     ^ 1
                   |                                       |
                   | N                                   N |
       +-----------v---------------+          +------------+-----------+
       |    stock_transactions     |          |       suppliers        |
       +---------------------------+          +------------------------+
       | transaction_id (PK, INT)  |          | supplier_id (PK, INT)  |
       | product_id (FK -> prod)   |          | supplier_name (VARCHAR)|
       | transaction_type (ENUM)   |          | contact_person (VARCHAR|
       | quantity (INT)            |          | email (VARCHAR)        |
       | reference_no (VARCHAR)    |          | phone (VARCHAR)        |
       | handler_name (VARCHAR)    |          | city (VARCHAR)         |
       | transaction_date(DATETIME)|          +------------------------+
       | notes (VARCHAR)           |
       +---------------------------+
```

---

## 💡 Core Business Logic & Workflows

### 1. Automated Stock Status Algorithm
The system computes the inventory status for every item dynamically:
$$\text{Status} = \begin{cases} 
\text{"OUT OF STOCK"}, & \text{if } \text{Quantity} = 0 \\ 
\text{"CRITICAL LOW"}, & \text{if } 0 < \text{Quantity} \le \frac{\text{Reorder Level}}{2} \\ 
\text{"LOW STOCK"}, & \text{if } \frac{\text{Reorder Level}}{2} < \text{Quantity} \le \text{Reorder Level} \\ 
\text{"OPTIMAL"}, & \text{if } \text{Quantity} > \text{Reorder Level} 
\end{cases}$$

### 2. Inward Receipt Workflow
1. Inbound shipment arrives at warehouse dock with a Purchase Order (PO) reference.
2. Operator opens **"Record Stock In/Out"** modal, selects item, quantity, and inputs reference number.
3. Stock balance is incremented: `quantity_in_stock = quantity_in_stock + inward_quantity`.
4. Transaction is appended to the `stock_transactions` audit table.

### 3. Outward Dispatch Workflow
1. Manufacturing assembly or dispatch order requests material issue.
2. System validates: `IF (requested_quantity > quantity_in_stock) THEN ABORT ("Insufficient Stock")`.
3. If validated, stock is decremented: `quantity_in_stock = quantity_in_stock - outward_quantity`.
4. Transaction is committed with handler signature and audit notes.

---

## 🛠️ Technology Stack

| Layer | Technology | Description |
| :--- | :--- | :--- |
| **Frontend UI** | **HTML5 & CSS3** | Self-contained, responsive design system with zero external CDN dependencies |
| **Frontend Logic** | **Vanilla JavaScript (ES6+)** | Dynamic search, filtering, modal management, and client-side state handling |
| **Database** | **MySQL 8.0** | Relational storage engine with 3NF schema, indexes, and referential constraints |
| **Backend Architecture**| **Java (JDK 11+) & JDBC** | Modular architecture with `DriverManager`, `PreparedStatement`, and DAO pattern |

---

## 📁 Project Structure

```text
warehouse-inventory-system/
│
├── index.html                   # Complete Frontend Dashboard UI (Self-contained)
├── warehouse_inventory_db.sql   # Relational MySQL Schema DDL, Constraints & Seed Data
├── README.md                    # Project Architecture & Documentation
├── Project_Plan.md              # Technical Specification Document
├── setup_database.py            # Automated Cross-Platform Database Import Utility
├── setup_database.bat           # Automated Windows Batch Database Importer
├── .gitignore                   # Standard Git Ignore Configuration
│
└── backend_src/                 # Java Backend Architecture (Core JDBC)
    ├── DBConnection.java        # JDBC Connection Manager (DriverManager)
    ├── Product.java             # Product Domain Model / POJO
    ├── ProductDAO.java          # Data Access Object executing PreparedStatements
    └── Main.java                # Runnable Console Test Suite & Report Generator
```

---

## 🚀 Quick Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/<your-username>/warehouse-inventory-system.git
cd warehouse-inventory-system
```

### 2. Import the Database into MySQL (One Command)
Run this single command in your terminal from the project folder:
```bash
mysql -u root -p -e "source warehouse_inventory_db.sql"
```
*Enter your MySQL root password when prompted.*

#### Verify the Database Setup:
```bash
mysql -u root -p -e "USE warehouse_db; SHOW TABLES; SELECT * FROM products;"
```

### 3. Launch the Web Interface
Simply double-click **`index.html`** to open it directly in any browser (Chrome, Edge, Firefox), or launch it from your terminal:
- **Windows (PowerShell):** `start index.html`
- **Mac:** `open index.html`

### 4. (Optional) Run the Java Backend Console Suite
```bash
# Compile
javac -d bin backend_src/*.java

# Run (requires mysql-connector-j.jar in your folder)
java -cp "bin;mysql-connector-j.jar" com.warehouse.Main
```

---

## 🖥️ System Interface & Feature Tour

| Feature View | Description |
| :--- | :--- |
| **Executive Dashboard** | Real-time KPI summary cards (Total SKUs, Total Units, Reorder Alerts, Total Valuation) and main inventory catalog. |
| **Automated Threshold Filter** | Instant filter showing items reaching or breaching minimum safety thresholds. |
| **Product Entry Modal** | Dialog for registering new SKUs, assigning rack coordinates, categories, and safety buffers. |
| **Stock Movement Logger** | Dialog for logging inward intake shipments and outward dispatches with reference IDs. |
| **Audit Movement Trail** | Chronological log of recent material dispatches and inward deliveries with handler signatures. |
| **Storage Zones & Capacity** | Granular layout of warehouse rack occupancy across storage zones. |

---

## 🔮 Future Roadmap
- [ ] **RESTful API Services:** Expose Spring Boot REST endpoints for headless mobile and web integration.
- [ ] **Hardware Barcode & RFID Integration:** Direct barcode scanning via WebRTC device camera.
- [ ] **Role-Based Access Control (RBAC):** Distinct permission levels for Floor Operators, Supervisors, and Procurement Officers.
- [ ] **Automated PO Generation:** Automated PDF generation for replenishment purchase orders when stock reaches critical thresholds.
