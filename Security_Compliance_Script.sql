
-- Creating foundational tables
CREATE TABLE IF NOT EXISTS Organism (
    OrganismID INT PRIMARY KEY,
    SpeciesName VARCHAR(255) NOT NULL,
    GenusName VARCHAR(255) NOT NULL,
    FamilyName VARCHAR(255) NOT NULL,
    UNIQUE(SpeciesName, GenusName, FamilyName)
);

CREATE TABLE IF NOT EXISTS Sample (
    SampleID INT PRIMARY KEY,
    CollectionDate DATE NOT NULL,
    OrganismID INT NOT NULL,
    Location VARCHAR(255) NOT NULL,
    FOREIGN KEY (OrganismID) REFERENCES Organism(OrganismID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Gene (
    GeneID INT PRIMARY KEY,
    GeneName VARCHAR(255) NOT NULL,
    Chromosome VARCHAR(50) NOT NULL,
    OrganismID INT NOT NULL,
    FOREIGN KEY (OrganismID) REFERENCES Organism(OrganismID)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Security Roles and Permissions
CREATE ROLE SecurityAdmin;
CREATE ROLE ComplianceAdmin;
CREATE ROLE DataAnalyst;

GRANT SELECT, INSERT, UPDATE ON Organism TO DataAnalyst;
GRANT SELECT, INSERT, UPDATE, DELETE ON Organism TO ComplianceAdmin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO SecurityAdmin;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT ON TABLES TO DataAnalyst;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO SecurityAdmin;

-- Identity and Access Management (IAM)
CREATE USER bio_analyst WITH PASSWORD 'SecurePassword1';
CREATE USER compliance_officer WITH PASSWORD 'SecurePassword2';
CREATE USER security_admin WITH PASSWORD 'SecurePassword3';

GRANT DataAnalyst TO bio_analyst;
GRANT ComplianceAdmin TO compliance_officer;
GRANT SecurityAdmin TO security_admin;

-- Audit Table for Compliance
CREATE TABLE IF NOT EXISTS AuditLog (
    AuditID INT PRIMARY KEY AUTO_INCREMENT,
    TableName VARCHAR(255),
    Operation VARCHAR(50),
    ModifiedBy VARCHAR(255),
    ModifiedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    OldValue TEXT,
    NewValue TEXT
);

-- Trigger for Auditing Changes in Organism Table
CREATE TRIGGER Organism_Audit_Trigger
AFTER UPDATE OR DELETE ON Organism
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (TableName, Operation, ModifiedBy, OldValue, NewValue)
    VALUES (
        'Organism',
        CASE
            WHEN TG_OP = 'UPDATE' THEN 'UPDATE'
            WHEN TG_OP = 'DELETE' THEN 'DELETE'
        END,
        SESSION_USER,
        ROW(OLD.OrganismID, OLD.SpeciesName, OLD.GenusName, OLD.FamilyName)::TEXT,
        ROW(NEW.OrganismID, NEW.SpeciesName, NEW.GenusName, NEW.FamilyName)::TEXT
    );
END;

-- Password Policy Enforcement
ALTER SYSTEM SET password_min_length = 12;
ALTER SYSTEM SET password_encryption = 'scram-sha-256';
ALTER SYSTEM SET idle_in_transaction_session_timeout = '5min';

-- Restricting Access to Sensitive Tables
REVOKE ALL PRIVILEGES ON TABLE Sample FROM PUBLIC;
GRANT SELECT ON Sample TO DataAnalyst;
GRANT ALL PRIVILEGES ON Sample TO ComplianceAdmin;

-- Row-Level Security Implementation
ALTER TABLE Organism ENABLE ROW LEVEL SECURITY;

CREATE POLICY analyst_policy
    ON Organism
    USING (current_user = 'bio_analyst');

ALTER TABLE Organism FORCE ROW LEVEL SECURITY;

-- Encrypting Sensitive Data
ALTER TABLE Organism
ADD COLUMN Encrypted_SpeciesName BYTEA;

UPDATE Organism
SET Encrypted_SpeciesName = pgp_sym_encrypt(SpeciesName, 'encryption_key');

-- Data Masking for Sensitive Information
CREATE FUNCTION mask_sensitive_data(input TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN '***' || RIGHT(input, 4);  -- Masking all but the last 4 characters
END;
$$ LANGUAGE plpgsql;

CREATE VIEW Masked_Organism AS
SELECT 
    OrganismID,
    mask_sensitive_data(SpeciesName) AS SpeciesName,
    GenusName,
    FamilyName
FROM Organism;

-- Fine-Grained Access Control for Specific Columns
CREATE POLICY selective_access_policy
    ON Organism
    USING (current_user IN ('bio_analyst', 'compliance_officer'))
    WITH CHECK (current_user = 'bio_analyst' AND mask_sensitive_data(SpeciesName) IS NOT NULL);

-- Implementing Database Encryption (Transparent Data Encryption)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Encrypting entire tablespace
CREATE TABLESPACE encrypted_space LOCATION '/path/to/encrypted/location' ENCRYPTION KEY 'your_encryption_key';

ALTER DATABASE your_database SET default_tablespace = encrypted_space;

-- Encryption at Rest for Specific Columns
ALTER TABLE Sample
ADD COLUMN Encrypted_Location BYTEA;

UPDATE Sample
SET Encrypted_Location = pgp_sym_encrypt(Location, 'encryption_key');

-- Monitoring and Logging for Security Events
CREATE OR REPLACE FUNCTION log_login_attempts()
RETURNS event_trigger AS $$
BEGIN
    INSERT INTO LoginAuditLog (username, login_time)
    VALUES (current_user, current_timestamp);
END;
$$ LANGUAGE plpgsql;

CREATE EVENT TRIGGER log_attempt
ON login_attempt
EXECUTE PROCEDURE log_login_attempts();

-- Secure Database Configuration
ALTER SYSTEM SET log_connections = 'on';
ALTER SYSTEM SET log_disconnections = 'on';
ALTER SYSTEM SET log_min_duration_statement = 1000;  -- Log queries that run longer than 1 second

-- Configuring Role-Based Access Control (RBAC) for High-Value Data
CREATE POLICY high_value_data_access
    ON Gene
    USING (current_user IN ('security_admin', 'compliance_officer'));

-- Implementing Database Firewall Rules (Example: Blocking Certain IP Addresses)
CREATE OR REPLACE FUNCTION block_ip()
RETURNS trigger AS $$
BEGIN
    IF inet_client_addr() = '192.168.1.100' THEN
        RAISE EXCEPTION 'Access denied from this IP address';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ip_block_trigger
BEFORE INSERT OR UPDATE ON Gene
FOR EACH ROW
EXECUTE FUNCTION block_ip();
