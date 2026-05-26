# 🏢 Enterprise Oracle Sales Operations Platform

## Overview

This repository contains an Oracle-based sales operations platform built with SQL, PL/SQL, and database automation. It is designed to simulate a retail transaction processing environment with schema design, business logic, analytics, and performance tuning.

The project is organized for easy deployment, exploration, and optimization in a Dockerized Oracle XE environment.

## What’s Included

- Oracle schema and data model for customers, products, orders, inventory, and sales
- PL/SQL packages, procedures, and triggers for business logic and data consistency
- Exported DDL for tables, views, packages, procedures, triggers, and materialized views
- Analytics queries for revenue, customer, product, and inventory insights
- Performance tutorials and examples for indexing, partitioning, and execution plans
- Setup scripts for database deployment

## Repository Layout

- `export/` — DDL exports for tables, views, procedures, packages, and triggers
- `analytics/` — Business reporting and analysis SQL queries
- `optimization/` — Performance tuning examples and demonstrations
- `performance analysis/` — Additional SQL performance exploration scripts
- `setup/` — Database deployment and schema setup scripts
- `docs/` — Architecture notes and ER diagrams

## Prerequisites

- Docker installed on Linux or macOS
- Basic knowledge of Oracle SQL and PL/SQL
- Optional: SQL*Plus, SQL Developer, or another Oracle client

## Quick Start

1. Start the Oracle XE container

```bash
docker run -d \
  --name oracle-xe \
  -p 1521:1521 \
  -e ORACLE_PASSWORD=Oracle123 \
  gvenzl/oracle-xe:latest
```

2. Connect to the running container

```bash
docker exec -it oracle-xe sqlplus system/Oracle123@XEPDB1
```

3. Run the setup script inside SQL*Plus

```sql
@setup/setup_project.sql
```

4. Verify the objects and sample data

```sql
SELECT owner, object_name, object_type FROM user_objects ORDER BY object_type, object_name;
```

## Key Features

- Strong relational design for sales operations
- Transaction processing for customers, orders, and inventory
- PL/SQL automation with packages and scheduler jobs
- Data consistency enforced with triggers and constraints
- Reporting-ready materialized views
- Performance tuning using indexes, partitioning, and query analysis

## Analytics & Reporting

See `analytics/business_analysis.sql` for business-focused queries, including:

- Monthly revenue and trend analysis
- Top customers by spend
- Best-selling products
- Inventory stock and turnover analysis
- Order status distribution

## Performance Optimization

Performance examples are available in `optimization/performance_demo.sql` and `performance analysis/`. The repository demonstrates:

- Index design and composite indexing
- Partition-aware queries
- EXPLAIN PLAN usage and execution plan review
- Aggregation and query rewrite techniques
- Materialized views for efficient reporting

## Notes

- The project is intended as a learning and demonstration platform, not a production application.
- Modify `setup/setup_project.sql` or the Docker command as needed for different passwords, ports, or environments.
- Use `export/` scripts as a reference for Oracle DDL and schema generation.

## Author

Nivetha Shourab
Oracle SQL & PL/SQL Developer | Data & BI Analyst

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
