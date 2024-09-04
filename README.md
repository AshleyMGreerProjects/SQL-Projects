# SQL-Projects

## Machine Learning Operations SQL Script

### Author: Ashley M. Greer, Jr

## Overview
This repository contains an advanced SQL script designed to execute complex data science and machine learning operations on large-scale relational databases. Optimized for **Databricks environments**, the script utilizes sophisticated SQL techniques, including vector and matrix calculations, to enhance efficiency and scalability.

## Key Features
- **Comprehensive Data Analysis**: Manages and analyzes user demographics, purchase histories, product interactions, and social networks.
- **Machine Learning Integration**: Implements vector-based recommendations and user clustering through advanced mathematical operations, leveraging SQL for scalability.
- **Data Integrity and Automation**: Ensures data consistency and reliability using triggers and relational constraints, automating key processes.
- **Optimized for Databricks**: Leverages **Delta Lake** for transactional integrity, optimized storage, and enhanced query performance within Databricks environments.

## Core Tables
- **UserProfile**: Stores demographic data for personalized analytics and user clustering.
- **PurchaseHistory**: Tracks user purchases linked to product information for detailed analysis.
- **ProductCatalog**: Maintains product categories, details, and pricing.
- **UserClusters**: Defines user segments for targeted marketing and analytics.
- **FeatureVectors & ProductVectors**: Stores feature vectors essential for machine learning operations.

## Key Operations
- **Cosine Similarity Calculation**: Computes similarity between user and product vectors to generate personalized recommendations.
- **Matrix Multiplication for Clustering**: Clusters users based on vector similarity scores using linear algebra techniques.
- **Data Integrity Triggers**: Automates checks to maintain data accuracy and consistency across tables.
- **Optimization Commands**: Implements commands like ZORDER and VACUUM to optimize query performance and manage data efficiently within Databricks.

---

## Bio Analyst SQL Script

### Author: Ashley M. Greer, Jr

## Overview
This SQL script is optimized for processing and analyzing large-scale biological datasets in **Databricks environments**. By leveraging **Delta Lake**, the script ensures efficient storage, ACID transaction handling, and high-performance data processing. It also includes advanced SQL techniques, such as complex subqueries and robust triggers, to facilitate in-depth analysis while maintaining data integrity.

## Key Features
- **Delta Lake Integration**: Ensures efficient storage, ACID-compliant transactions, and scalable data processing for large datasets.
- **Advanced Querying**: Utilizes complex subqueries and joins to analyze gene expression levels across multiple species.
- **Automated Data Integrity**: Employs triggers to enforce data consistency across all operations, ensuring referential integrity.
- **Performance Optimization**: Uses Databricks-specific commands like **ZORDER** and **VACUUM** to improve query execution and manage data efficiently.

## Core Tables
- **Organism**: Stores biological organism data with unique constraints for species, genus, and family.
- **Sample**: Records data on biological samples, linked to the Organism table via foreign keys.
- **Gene**: Holds gene details, including gene names and chromosome information, linked to organisms.
- **Experiment**: Tracks gene expression data linked to both the Sample and Gene tables for comprehensive analysis.

## Key SQL Components
- **CTEs & Advanced Queries**: Provides reports on gene expression, categorizing results into high, moderate, and low expression levels.
- **Triggers**: 
    - **`trg_check_organism_exists`**: Ensures samples are associated with valid organisms.
    - **`trg_update_experiment_modified`**: Automatically updates the experiment date when gene expression data is modified.
    - **`trg_prevent_gene_deletion`**: Prevents gene deletion if it is associated with an existing experiment, maintaining data integrity.
- **Optimization**: Implements **ZORDER** for faster query execution and **VACUUM** for efficient data management.

---

## SQL Security and Compliance Script

### Author: Ashley M. Greer, Jr

## Overview
This SQL script creates a secure and compliant environment for handling sensitive biological data. It focuses on building foundational tables, enforcing security roles, integrating with identity and access management (IAM), and ensuring compliance through audit logging and encryption. The script is designed to provide multi-layered security and meet compliance standards in a database environment.

## Key Features
- **Security Roles & Permissions**: Defines roles such as `SecurityAdmin`, `ComplianceAdmin`, and `DataAnalyst` with clear access control policies to ensure separation of duties.
- **IAM Integration**: Integrates with IAM systems to manage user creation, secure passwords, and role assignments.
- **Compliance Auditing**: Implements an **AuditLog** table and triggers to track changes to sensitive data, ensuring compliance with regulatory requirements.
- **Password & Access Control**: Enforces strong password policies, session timeouts, and role-based access control to enhance security.
- **Data Encryption & Masking**: Uses **pgcrypto** for encrypting sensitive data in the **Organism** and **Sample** tables, and implements data masking to minimize data exposure.
- **Monitoring & Logging**: Tracks login attempts, unauthorized access, and logs system activities, such as long-running queries and connections.
- **Database Encryption & Firewall**: Implements tablespace encryption and an IP blocking trigger to ensure data security and prevent unauthorized access.

---

## License
This project is licensed under the MIT License. See the LICENSE file for more details.
