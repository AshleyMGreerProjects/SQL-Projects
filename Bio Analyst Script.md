# Bio Analyst Script

## Author: Ashley M. Greer, Jr

### Overview

This SQL script is designed for processing and analyzing complex biological datasets at scale, optimized for use in Databricks environments. By leveraging Delta Lake, this script ensures efficient storage, transactional integrity, and high-performance data processing. The script utilizes advanced SQL techniques, including intricate subqueries, complex joins, and robust triggers, to maintain data integrity and facilitate in-depth analysis.

### Key Features

- **Delta Lake Integration**: The script uses Delta Lake to ensure efficient storage, ACID transactions, and scalable data processing, making it suitable for Big Data environments.
- **Sophisticated Querying**: Employs advanced subqueries and joins to provide deep insights into biological data, such as gene expression levels across different species.
- **Automated Data Integrity**: Triggers are implemented to enforce data integrity, ensuring that all relational data remains consistent and accurate across operations.
- **Performance Optimization**: Specific commands such as ZORDER and VACUUM are used to enhance query performance and manage data efficiently in a Databricks environment.

### Tables and Data Structures

- **Organism**: Stores information about biological organisms, ensuring no duplicate entries with unique constraints on species, genus, and family names.
- **Sample**: Contains data about samples collected, linked to the Organism table with foreign keys to ensure referential integrity.
- **Gene**: Holds details about genes, including the gene name and chromosome information, with a foreign key relationship to the Organism table.
- **Experiment**: Records experimental data, such as gene expression levels, linked to both the Sample and Gene tables to maintain data consistency.

### Key SQL Components

- **Common Table Expressions (CTEs)**: Used to calculate the average expression levels of genes across species and identify the top genes based on expression levels.
- **Advanced Queries**: The script generates comprehensive reports detailing the top gene expressions and associated sample data, categorizing gene expressions into high, moderate, and low levels.
- **Triggers**:
  - **`trg_check_organism_exists`**: Ensures that a sample is associated with an existing organism before insertion.
  - **`trg_update_experiment_modified`**: Automatically updates the experiment date when the expression level is changed.
  - **`trg_prevent_gene_deletion`**: Prevents the deletion of a gene if it is associated with any existing experiment, preserving data integrity.

### Delta Lake Optimization

- **ZORDER**: The script includes an `OPTIMIZE` command with ZORDER indexing, which improves query performance by optimizing the physical layout of the data based on `GeneID` and `ExperimentDate`.
- **VACUUM**: A `VACUUM` command is used to clean up stale data files, ensuring that only the necessary history is retained, thereby improving storage efficiency.

### Usage

To use this script in a Databricks environment:
1. Load the script into your Databricks workspace.
2. Execute the script to create the necessary tables and triggers.
3. Use the advanced queries to analyze your biological data and generate detailed reports.
4. Optimize and manage your data using Delta Lake commands integrated into the script.