package com.warehouse.dao;

import com.warehouse.model.Product;
import com.warehouse.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) for Inventory Products
 * Demonstrates standard JDBC PreparedStatements
 */
public class ProductDAO {

    // 1. Fetch all products from MySQL
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY quantity_in_stock ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product(
                    rs.getInt("product_id"),
                    rs.getString("sku_code"),
                    rs.getString("product_name"),
                    rs.getInt("category_id"),
                    rs.getInt("location_id"),
                    rs.getInt("supplier_id"),
                    rs.getDouble("unit_price"),
                    rs.getInt("quantity_in_stock"),
                    rs.getInt("min_reorder_level"),
                    rs.getString("unit_of_measure")
                );
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Fetch only low stock items (Quantity <= Min Reorder Level)
    public List<Product> getLowStockAlerts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE quantity_in_stock <= min_reorder_level";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product(
                    rs.getInt("product_id"),
                    rs.getString("sku_code"),
                    rs.getString("product_name"),
                    rs.getInt("category_id"),
                    rs.getInt("location_id"),
                    rs.getInt("supplier_id"),
                    rs.getDouble("unit_price"),
                    rs.getInt("quantity_in_stock"),
                    rs.getInt("min_reorder_level"),
                    rs.getString("unit_of_measure")
                );
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Insert a new product into MySQL
    public boolean addProduct(Product p) {
        String sql = "INSERT INTO products (sku_code, product_name, category_id, location_id, supplier_id, unit_price, quantity_in_stock, min_reorder_level, unit_of_measure) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getSkuCode());
            ps.setString(2, p.getProductName());
            ps.setInt(3, p.getCategoryId());
            ps.setInt(4, p.getLocationId());
            ps.setInt(5, p.getSupplierId());
            ps.setDouble(6, p.getUnitPrice());
            ps.setInt(7, p.getQuantityInStock());
            ps.setInt(8, p.getMinReorderLevel());
            ps.setString(9, p.getUnitOfMeasure());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
