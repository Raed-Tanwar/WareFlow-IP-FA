-- ===============================================================
-- WAREHOUSE INVENTORY MANAGEMENT SYSTEM (WIMS)
-- Database: MySQL
-- Academic Level: Second Year Engineering (IP Lab - Java Backend)
-- ===============================================================

-- 1. Create and select Database
CREATE DATABASE IF NOT EXISTS warehouse_db;
USE warehouse_db;

-- Drop tables if they already exist to allow clean re-runs
DROP TABLE IF EXISTS stock_transactions;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS categories;

-- ===============================================================
-- TABLE 1: categories (Item categorisation)
-- ===============================================================
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(60) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- ===============================================================
-- TABLE 2: locations (Warehouse zones and shelf racks)
-- ===============================================================
CREATE TABLE locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    zone_code VARCHAR(20) NOT NULL,
    rack_number VARCHAR(20) NOT NULL,
    max_capacity_units INT DEFAULT 2000
);

-- ===============================================================
-- TABLE 3: suppliers (Vendor details)
-- ===============================================================
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(120) NOT NULL,
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(25),
    city VARCHAR(80)
);

-- ===============================================================
-- TABLE 4: products (Main inventory master table)
-- ===============================================================
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    sku_code VARCHAR(30) NOT NULL UNIQUE,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    location_id INT NOT NULL,
    supplier_id INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    min_reorder_level INT NOT NULL DEFAULT 15,
    unit_of_measure VARCHAR(20) DEFAULT 'Units',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_prod_category FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE,
    CONSTRAINT fk_prod_location FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE,
    CONSTRAINT fk_prod_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE CASCADE
);

-- ===============================================================
-- TABLE 5: stock_transactions (Inward and outward stock movements)
-- ===============================================================
CREATE TABLE stock_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    transaction_type ENUM('INWARD_RECEIPT', 'OUTWARD_DISPATCH', 'RETURN') NOT NULL,
    quantity INT NOT NULL,
    reference_no VARCHAR(60) NOT NULL,
    handler_name VARCHAR(100) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    notes VARCHAR(255),
    CONSTRAINT fk_trans_product FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ===============================================================
-- SAMPLE DATA INSERTIONS (For realistic presentation & screenshots)
-- ===============================================================

-- Insert Categories
INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Industrial Tools', 'Hand tools, pneumatic equipment, and power drills'),
(2, 'Packaging Materials', 'Cardboard boxes, bubble wraps, and packaging tapes'),
(3, 'Electronics & Sensors', 'Barcode scanners, temperature sensors, and RFID tags'),
(4, 'Safety & PPE', 'Hard hats, high-vis vests, protective gloves, and masks'),
(5, 'Raw Materials', 'Metal sheets, fasteners, bolts, and nylon ropes');

-- Insert Warehouse Locations
INSERT INTO locations (location_id, warehouse_name, zone_code, rack_number, max_capacity_units) VALUES
(1, 'Main Central Hub', 'Zone-A (Fast Moving)', 'A-Rack-01', 3500),
(2, 'Main Central Hub', 'Zone-A (Fast Moving)', 'A-Rack-02', 3500),
(3, 'Main Central Hub', 'Zone-B (Heavy Bulk)',   'B-Rack-05', 1500),
(4, 'Main Central Hub', 'Zone-C (Safety/PPE)',   'C-Rack-03', 2000),
(5, 'North Annex Depot', 'Zone-D (Electronics)',  'D-Rack-08', 1200);

-- Insert Suppliers
INSERT INTO suppliers (supplier_id, supplier_name, contact_person, email, phone, city) VALUES
(1, 'Apex Industrial Supply Co.', 'Vikram Sharma', 'vikram@apexsupply.in', '+91-98201-11223', 'Mumbai'),
(2, 'PackTech Solutions Ltd.', 'Ananya Deshmukh', 'ananya@packtech.com', '+91-98765-43210', 'Pune'),
(3, 'Delta Logistics & Sensors', 'Rohan Patel', 'rohan@deltasensors.in', '+91-91234-56789', 'Ahmedabad'),
(4, 'Suraksha Safety Equipments', 'Pooja Mehta', 'pmehta@surakshasafety.com', '+91-98980-76543', 'Thane');

-- Insert Products
INSERT INTO products (product_id, sku_code, product_name, category_id, location_id, supplier_id, unit_price, quantity_in_stock, min_reorder_level, unit_of_measure) VALUES
(1,  'SKU-TOOL-101', 'Heavy Duty Cordless Impact Drill', 1, 1, 1, 4850.00, 42,  15, 'Pieces'),
(2,  'SKU-TOOL-102', 'Adjustable Torque Wrench 40-200Nm', 1, 1, 1, 2350.00,  8,  10, 'Pieces'), -- Low stock
(3,  'SKU-PACK-201', 'Double-Walled Corrugated Box (12x12x12)', 2, 2, 2, 45.00, 520, 100, 'Bundles'),
(4,  'SKU-PACK-202', 'Heavy Duty Bubble Cushion Roll 100m', 2, 2, 2, 890.00, 65,  20, 'Rolls'),
(5,  'SKU-PACK-203', 'Self-Adhesive Reinforced Packing Tape', 2, 2, 2, 85.00,  12,  50, 'Rolls'), -- Critical low stock
(6,  'SKU-ELEC-301', 'Handheld 2D Industrial Barcode Scanner', 3, 5, 3, 3400.00, 28,  10, 'Units'),
(7,  'SKU-ELEC-302', 'Passive UHF RFID Asset Tags (Pack of 500)', 3, 5, 3, 1600.00, 35, 15, 'Packs'),
(8,  'SKU-SAFE-401', 'Industrial ISI Certified Safety Helmet', 4, 4, 4, 380.00, 110, 30, 'Pieces'),
(9,  'SKU-SAFE-402', 'Cut-Resistant Nitrile Coated Gloves', 4, 4, 4, 120.00, 340, 50, 'Pairs'),
(10, 'SKU-SAFE-403', 'High-Visibility Reflective Vest (Class 2)', 4, 4, 4, 210.00, 18, 25, 'Pieces'), -- Low stock
(11, 'SKU-RAW-501',  'M10 Stainless Steel Hex Bolts (Box of 200)', 5, 3, 1, 450.00, 75, 20, 'Boxes'),
(12, 'SKU-RAW-502',  'Heavy Duty Nylon Pallet Strapping Belt 50m', 5, 3, 2, 620.00,  6, 15, 'Rolls'); -- Critical low stock

-- Insert Sample Stock Transactions (Recent Movements)
INSERT INTO stock_transactions (transaction_id, product_id, transaction_type, quantity, reference_no, handler_name, transaction_date, notes) VALUES
(1, 1, 'INWARD_RECEIPT',  50, 'PO-2026-0811', 'Rajesh K. (Inward Mgr)', '2026-09-15 10:30:00', 'Initial bulk stock arrival from Apex Supply'),
(2, 1, 'OUTWARD_DISPATCH', 8, 'SO-DISP-1044', 'Amit S. (Warehouse Staff)', '2026-09-17 14:15:00', 'Dispatched to Assembly Line B'),
(3, 3, 'INWARD_RECEIPT', 600, 'PO-2026-0822', 'Rajesh K. (Inward Mgr)', '2026-09-18 09:00:00', 'Packaging monthly replenishment batch'),
(4, 3, 'OUTWARD_DISPATCH', 80, 'SO-DISP-1051', 'Sneha P. (Packing Team)', '2026-09-19 11:45:00', 'Issued for export shipment packaging'),
(5, 5, 'OUTWARD_DISPATCH', 38, 'SO-DISP-1059', 'Sneha P. (Packing Team)', '2026-09-20 16:20:00', 'Issued to shipping bays (tape inventory low)'),
(6, 6, 'INWARD_RECEIPT',  30, 'PO-2026-0840', 'Rajesh K. (Inward Mgr)', '2026-09-20 17:00:00', 'Received new scanners from Delta Sensors'),
(7, 6, 'OUTWARD_DISPATCH', 2, 'SO-DISP-1065', 'Amit S. (Warehouse Staff)', '2026-09-21 11:10:00', 'Issued to Zone-A scanning terminal 3');

-- ===============================================================
-- USEFUL QUERIES TO RUN FOR SUBMISSION SCREENSHOTS:
-- ===============================================================

-- 1. View all tables
-- SHOW TABLES;

-- 2. View Product Table Schema
-- DESCRIBE products;

-- 3. Complete Inventory Report with Joined Category & Warehouse Rack
SELECT 
    p.sku_code AS 'SKU',
    p.product_name AS 'Item Name',
    c.category_name AS 'Category',
    CONCAT(l.warehouse_name, ' (', l.rack_number, ')') AS 'Warehouse Rack',
    p.quantity_in_stock AS 'Current Stock',
    p.min_reorder_level AS 'Min Threshold',
    CONCAT('₹', FORMAT(p.unit_price, 2)) AS 'Unit Price',
    CONCAT('₹', FORMAT(p.quantity_in_stock * p.unit_price, 2)) AS 'Total Stock Value',
    CASE 
        WHEN p.quantity_in_stock = 0 THEN 'OUT OF STOCK'
        WHEN p.quantity_in_stock <= p.min_reorder_level THEN 'REORDER REQUIRED'
        ELSE 'OPTIMAL STOCK'
    END AS 'Stock Status'
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN locations l ON p.location_id = l.location_id
ORDER BY p.quantity_in_stock ASC;

-- 4. Low Stock Alert Query (Crucial for inventory managers)
SELECT 
    p.sku_code,
    p.product_name,
    c.category_name,
    p.quantity_in_stock,
    p.min_reorder_level,
    s.supplier_name,
    s.phone AS 'Supplier Contact'
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.quantity_in_stock <= p.min_reorder_level;

-- 5. Audit Log of Stock Transactions (Inward & Outward)
SELECT 
    t.transaction_id AS 'Txn ID',
    t.reference_no AS 'Ref #',
    t.transaction_date AS 'Date & Time',
    t.transaction_type AS 'Type',
    p.product_name AS 'Product',
    t.quantity AS 'Qty Moved',
    t.handler_name AS 'Executed By',
    t.notes AS 'Remarks'
FROM stock_transactions t
JOIN products p ON t.product_id = p.product_id
ORDER BY t.transaction_date DESC;
