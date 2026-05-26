# 🏢 Enterprise Oracle Sales Operations Platform (SQL + PL/SQL + Automation)

## 📌 Project Overview

This project is a complete Oracle-based Sales Operations system designed to simulate a real-world retail transaction processing environment. It demonstrates strong SQL, PL/SQL, and database engineering skills including schema design, business logic implementation, automation, and performance optimization.

The system is containerized using Docker (Oracle XE) and includes full schema export, business analytics, and deployment automation scripts.

---

## 🧱 Key Features

- Relational schema design for sales operations
- Transactional processing (customers, orders, products, inventory)
- PL/SQL packages for business logic automation
- Triggers for data consistency and audit handling
- Materialized views for reporting optimization
- Scheduler jobs for automated processing
- Partitioning and indexing for performance tuning

---

## ⚙ Technologies Used

- Oracle Database XE
- SQL & PL/SQL
- DBMS_METADATA
- Oracle Scheduler (DBMS_SCHEDULER)
- Docker (Containerized database environment)
- Linux (Ubuntu)

---

## 📁 Project Structure

oracle-sales-ops/
│
├── export/ # DDL exports (tables, views, procedures, etc.)
├── analytics/ # Business reporting queries
├── optimization/ # Performance tuning examples
├── setup/ # Deployment scripts
├── docs/ # Architecture & documentation
└── README.md

---

## 🚀 How to Run the Project

### 1. Start Oracle Container

```bash
docker run -d \
  --name oracle-xe \
  -p 1521:1521 \
  -e ORACLE_PASSWORD=Oracle123 \
  gvenzl/oracle-xe:latest
```

### 2. Connect to Database

```bash
docker exec -it oracle-xe sqlplus system/Oracle123@XEPDB1
```

### 3. Deploy Schema

Inside SQL*Plus:

```sql
@setup/setup_project.sql
```
---

## 📊 Business Analytics

The project includes analytical SQL queries for:

* Monthly revenue trends
* Top customers by spending
* Best-selling products
* Inventory stock analysis
* Order status distribution

Refer: analytics/business_analysis.sql

---

## ⚡ Performance Optimization

Key Oracle performance concepts demonstrated:

* Composite indexing strategies
* Partition-aware query design
* Execution plan analysis (EXPLAIN PLAN)
* Aggregation optimization
* Materialized views for reporting efficiency

Refer: optimization/performance_demo.sql

---

## 🧠 Key Learnings

* Enterprise-level schema design
* PL/SQL procedural programming
* Database automation using scheduler jobs
* Query optimization techniques
* Docker-based database environment setup
* Metadata-driven schema export using DBMS_METADATA

---

## 🎯 Project Goal

To simulate a real-world sales operations backend system and demonstrate Oracle database engineering capabilities including design, automation, optimization, and reporting.

---

## ⭐ Project Highlights

* Built a full Oracle-based transactional sales system from scratch
* Implemented PL/SQL packages for business logic automation
* Designed and optimized schema using indexing and partitioning
* Created scheduler-based automation for backend processing
* Built analytical SQL layer for business reporting
* Simulated real-world retail operations with relational integrity

---

## 👨‍💻 Author

Nivetha Shourab
Oracle SQL & PL/SQL Developer | Beginner Data & BI Analyst
Based in Germany

---
