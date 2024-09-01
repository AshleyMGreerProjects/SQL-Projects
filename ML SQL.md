# Machine Learning Operations SQL Script

### Author: Ashley M. Greer, Jr

## Overview
This repository contains an advanced SQL script designed for executing complex data science and machine learning operations across a large-scale relational database. The script utilizes sophisticated SQL techniques, including vector and matrix calculations, and is optimized for efficient data handling in Databricks environments.

## Key Features
- **Comprehensive User and Product Data Analysis**: Manages and analyzes user demographics, purchase history, product interactions, and social connections.
- **Machine Learning Integration**: Implements vector-based recommendations and user clustering through advanced mathematical operations.
- **Data Integrity and Automation**: Ensures data consistency through triggers and relational constraints while automating key processes.
- **Optimized for Databricks**: Leverages Delta Lake for transactional integrity and includes commands for optimizing data storage and performance in Databricks.

## Core Tables
- **UserProfile**: Stores essential user demographic data for personalized analytics and clustering.
- **PurchaseHistory**: Tracks user purchases, linking them to products for detailed analysis.
- **ProductCatalog**: Maintains product information, including categories and pricing.
- **UserClusters**: Defines user segments for targeted marketing and analysis.
- **FeatureVectors & ProductVectors**: Stores feature vectors for users and products, crucial for machine learning operations.

## Key Operations
- **Cosine Similarity Calculation**: Computes similarity between user and product vectors to generate personalized recommendations.
- **Matrix Multiplication for Clustering**: Assigns users to clusters based on vector similarity scores using linear algebra techniques.
- **Data Integrity Triggers**: Automated checks to maintain the accuracy and consistency of user and purchase data.
- **Optimization Commands**: Enhances query performance and manages data retention within Databricks environments.

## Documentation
Each table and operation in the script is thoroughly documented to ensure clarity and understanding of the processes and logic involved.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
