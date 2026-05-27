# Database Population Scripts

This directory contains Oracle SQL scripts used to populate the Sales Operations schema with randomized transactional test data for reporting, analytics, and dashboard development.

The scripts generate a realistic e-commerce / sales operations dataset directly inside Oracle Database using scalable SQL techniques and dependency-aware execution sequencing.

---

# Populated Tables

- `customers`
- `products`
- `sales_orders`
- `order_items`
- `inventory`

---

# Data Generation Techniques

The implementation uses Oracle-specific features such as:

- `CONNECT BY LEVEL`
- `DBMS_RANDOM`
- hierarchical row generation
- randomized transactional value creation
- relational dependency-aware inserts

The generated records simulate:
- customer master data
- product catalog information
- transactional order activity
- order line items
- inventory stock information

---

# Dataset Size

| Table | Rows |
|---|---|
| customers | 1,000 |
| products | 100 |
| sales_orders | 5,000 |
| order_items | 20,000 |

---

# Order Lifecycle Simulation

Sales orders are generated with multiple operational states:

- `PENDING`
- `SHIPPED`
- `COMPLETED`
- `CANCELLED`

Randomized values are also generated for:
- order dates
- pricing
- quantities
- customer locations
- inventory quantities

This dataset supports:
- KPI reporting
- revenue analysis
- order trend visualization
- customer-level analytics
- BI-style dashboards

---

# Script Execution Order

To maintain referential integrity, the scripts should be executed in the following sequence:

```text
1. customers
2. products
3. sales_orders
4. order_items
5. inventory
```

This ensures all parent records exist before inserting dependent transactional records.

---

# Referential Relationships

```text
sales_orders.customer_id
→ customers.customer_id

order_items.order_id
→ sales_orders.order_id

order_items.product_id
→ products.product_id

inventory.product_id
→ products.product_id
```

---

# Validation Queries

```sql
SELECT COUNT(*) FROM customers;

SELECT COUNT(*) FROM products;

SELECT COUNT(*) FROM sales_orders;

SELECT COUNT(*) FROM order_items;
```

Expected results:

```text
CUSTOMERS     → 1000
PRODUCTS      → 100
SALES_ORDERS  → 5000
ORDER_ITEMS   → 20000
```

---

# Oracle Concepts Demonstrated

- bulk data generation
- hierarchical queries
- OLTP-style schema population
- parent-child dependency handling
- randomized transaction simulation
- analytics-ready dataset preparation

---

# Usage

These scripts were created to support:
- Oracle SQL analytics
- PL/SQL reporting procedures
- Java-based reporting applications
- BI dashboard visualizations
- trend and revenue analysis
- operational reporting scenarios
