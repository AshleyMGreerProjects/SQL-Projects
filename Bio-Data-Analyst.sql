/*
    Author: Ashley M. Greer, Jr
*/

-- Creating foundational tables optimized for Big Data processing
CREATE TABLE IF NOT EXISTS Organism (
    OrganismID INT PRIMARY KEY,
    SpeciesName VARCHAR(255) NOT NULL,
    GenusName VARCHAR(255) NOT NULL,
    FamilyName VARCHAR(255) NOT NULL,
    UNIQUE(SpeciesName, GenusName, FamilyName) -- Prevents duplicate entries in the biological classification
) USING DELTA -- Delta Lake ensures efficient storage and transactional integrity.

CREATE TABLE IF NOT EXISTS Sample (
    SampleID INT PRIMARY KEY,
    CollectionDate DATE NOT NULL,
    OrganismID INT NOT NULL,
    Location VARCHAR(255) NOT NULL,
    FOREIGN KEY (OrganismID) REFERENCES Organism(OrganismID)
    ON DELETE CASCADE ON UPDATE CASCADE -- Maintains referential integrity during updates or deletions.
) USING DELTA;

CREATE TABLE IF NOT EXISTS Gene (
    GeneID INT PRIMARY KEY,
    GeneName VARCHAR(255) NOT NULL,
    Chromosome VARCHAR(50) NOT NULL,
    OrganismID INT NOT NULL,
    FOREIGN KEY (OrganismID) REFERENCES Organism(OrganismID)
    ON DELETE CASCADE ON UPDATE CASCADE -- Ensures data consistency with organism records.
) USING DELTA;

CREATE TABLE IF NOT EXISTS Experiment (
    ExperimentID INT PRIMARY KEY,
    ExperimentDate DATE NOT NULL,
    SampleID INT NOT NULL,
    GeneID INT NOT NULL,
    ExpressionLevel FLOAT CHECK(ExpressionLevel >= 0), -- Ensures non-negative expression levels.
    FOREIGN KEY (SampleID) REFERENCES Sample(SampleID)
    ON DELETE CASCADE ON UPDATE CASCADE, -- Maintains linkage integrity.
    FOREIGN KEY (GeneID) REFERENCES Gene(GeneID)
    ON DELETE CASCADE ON UPDATE CASCADE -- Ensures referential integrity across related entities.
) USING DELTA;

-- Advanced subqueries and intricate joins for in-depth biological data analysis
WITH GeneExpressionAvg AS (
    SELECT
        g.GeneID,
        g.GeneName,
        o.SpeciesName,
        AVG(e.ExpressionLevel) AS AvgExpression
    FROM
        Experiment e
    JOIN Gene g ON e.GeneID = g.GeneID
    JOIN Organism o ON g.OrganismID = o.OrganismID
    GROUP BY
        g.GeneID, g.GeneName, o.SpeciesName
),

TopGenes AS (
    SELECT
        GeneID,
        GeneName,
        SpeciesName,
        AvgExpression
    FROM
        GeneExpressionAvg
    WHERE AvgExpression IS NOT NULL -- Excludes genes without recorded expression levels.
    ORDER BY
        AvgExpression DESC
    LIMIT 10
)

-- Generating detailed reports on top gene expressions and associated sample data
SELECT
    tg.GeneID,
    tg.GeneName,
    tg.SpeciesName,
    tg.AvgExpression,
    s.SampleID,
    s.CollectionDate,
    s.Location,
    CASE
        WHEN tg.AvgExpression > 100 THEN 'High Expression'
        WHEN tg.AvgExpression BETWEEN 50 AND 100 THEN 'Moderate Expression'
        ELSE 'Low Expression'
    END AS ExpressionCategory -- Categorizes genes based on average expression levels.
FROM
    TopGenes tg
JOIN Experiment e ON tg.GeneID = e.GeneID
JOIN Sample s ON e.SampleID = s.SampleID
ORDER BY
    tg.AvgExpression DESC;

-- Triggers to enforce data integrity and automate process management
CREATE OR REPLACE TRIGGER trg_check_organism_exists
BEFORE INSERT ON Sample
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Organism WHERE OrganismID = NEW.OrganismID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Associated OrganismID does not exist. Insertion aborted.';
    END IF;
END;

CREATE OR REPLACE TRIGGER trg_update_experiment_modified
BEFORE UPDATE ON Experiment
FOR EACH ROW
BEGIN
    IF OLD.ExpressionLevel <> NEW.ExpressionLevel THEN
        SET NEW.ExperimentDate = CURRENT_TIMESTAMP;
    END IF;
END;

CREATE OR REPLACE TRIGGER trg_prevent_gene_deletion
BEFORE DELETE ON Gene
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Experiment WHERE GeneID = OLD.GeneID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete Gene as it is associated with an existing experiment.';
    END IF;
END;

-- Additional query demonstrating complex joins and aggregations, optimized for Databricks
SELECT 
    o.SpeciesName,
    g.GeneName,
    COUNT(e.ExperimentID) AS ExperimentCount,
    MAX(e.ExpressionLevel) AS MaxExpressionLevel,
    MIN(e.ExpressionLevel) AS MinExpressionLevel,
    AVG(e.ExpressionLevel) AS AvgExpressionLevel
FROM 
    Organism o
JOIN 
    Gene g ON o.OrganismID = g.OrganismID
JOIN 
    Experiment e ON g.GeneID = e.GeneID
GROUP BY 
    o.SpeciesName, g.GeneName
HAVING 
    COUNT(e.ExperimentID) > 1 -- Includes only genes with multiple experiments.
ORDER BY 
    AvgExpressionLevel DESC;

-- Delta Lake optimization commands specific to Databricks
OPTIMIZE Experiment ZORDER BY (GeneID, ExperimentDate); -- Enhances query performance by optimizing data layout.
VACUUM Sample RETAIN 168 HOURS; -- Cleans up stale data files, retaining history for 7 days.
