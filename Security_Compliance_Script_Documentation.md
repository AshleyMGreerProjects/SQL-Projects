
# SQL Security and Compliance Script Documentation

## Overview
This SQL script is designed to create a secure and compliant database environment for handling sensitive biological data. It includes the creation of foundational tables, security roles, IAM integration, compliance auditing, and advanced security measures.

## Table Creation
- **Organism, Sample, Gene Tables**: These tables store data about organisms, samples, and genes with enforced referential integrity through foreign key constraints.

## Security Roles and Permissions
- **Roles**: `SecurityAdmin`, `ComplianceAdmin`, and `DataAnalyst` roles are created with different levels of access.
- **Permissions**: Appropriate permissions are granted to each role, ensuring separation of duties.

## Identity and Access Management (IAM)
- **User Creation**: Users `bio_analyst`, `compliance_officer`, and `security_admin` are created with secure passwords and assigned roles.
- **Role Assignment**: Each user is granted a role that defines their access level.

## Compliance Auditing
- **AuditLog Table**: A table is created to log changes to the `Organism` table, capturing operations like UPDATE and DELETE.
- **Trigger**: A trigger is set up to automatically log these changes.

## Password Policy Enforcement
- **System Settings**: Enforced strong password policies and session timeouts to enhance security.

## Access Control and Encryption
- **Row-Level Security**: Implemented for the `Organism` table to restrict data access based on user roles.
- **Data Encryption**: Sensitive data in the `Organism` and `Sample` tables is encrypted using `pgcrypto`.
- **Data Masking**: Masking sensitive data in the `Organism` table to limit exposure.

## Monitoring and Logging
- **Login Auditing**: Set up event triggers to log login attempts for monitoring unauthorized access.
- **System Logging**: Configured the system to log connections, disconnections, and long-running queries.

## Fine-Grained Access Control
- **Column-Level Policies**: Implemented policies that control access to specific columns based on roles.

## Database Encryption
- **Tablespace Encryption**: Configured encryption for entire tablespaces to protect data at rest.

## Database Firewall
- **IP Blocking**: Created a trigger to block specific IP addresses from performing database operations.

## Conclusion
This script provides a robust framework for managing security and compliance in a database environment. It addresses multiple layers of security, from basic access control to advanced encryption and monitoring, ensuring that sensitive data is well-protected.
