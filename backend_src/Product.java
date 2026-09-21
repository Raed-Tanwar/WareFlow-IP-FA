package com.warehouse.model;

/**
 * Product Model (POJO / Java Bean)
 * Represents an item in the warehouse inventory
 */
public class Product {
    private int productId;
    private String skuCode;
    private String productName;
    private int categoryId;
    private int locationId;
    private int supplierId;
    private double unitPrice;
    private int quantityInStock;
    private int minReorderLevel;
    private String unitOfMeasure;

    public Product() {}

    public Product(int productId, String skuCode, String productName, int categoryId, 
                   int locationId, int supplierId, double unitPrice, int quantityInStock, 
                   int minReorderLevel, String unitOfMeasure) {
        this.productId = productId;
        this.skuCode = skuCode;
        this.productName = productName;
        this.categoryId = categoryId;
        this.locationId = locationId;
        this.supplierId = supplierId;
        this.unitPrice = unitPrice;
        this.quantityInStock = quantityInStock;
        this.minReorderLevel = minReorderLevel;
        this.unitOfMeasure = unitOfMeasure;
    }

    // Getters and Setters
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getSkuCode() { return skuCode; }
    public void setSkuCode(String skuCode) { this.skuCode = skuCode; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public int getLocationId() { return locationId; }
    public void setLocationId(int locationId) { this.locationId = locationId; }

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public int getQuantityInStock() { return quantityInStock; }
    public void setQuantityInStock(int quantityInStock) { this.quantityInStock = quantityInStock; }

    public int getMinReorderLevel() { return minReorderLevel; }
    public void setMinReorderLevel(int minReorderLevel) { this.minReorderLevel = minReorderLevel; }

    public String getUnitOfMeasure() { return unitOfMeasure; }
    public void setUnitOfMeasure(String unitOfMeasure) { this.unitOfMeasure = unitOfMeasure; }

    public boolean isLowStock() {
        return this.quantityInStock <= this.minReorderLevel;
    }
}
