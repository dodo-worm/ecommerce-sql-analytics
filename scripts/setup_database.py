#!/usr/bin/env python3
"""
E-Commerce Analytics - Database Setup Script
This script sets up the SQLite database with schema and sample data.
"""

import sqlite3
import os
from pathlib import Path

def setup_database():
    """Set up the SQLite database with schema and sample data."""

    # Create data directory
    data_dir = Path(__file__).parent.parent / 'data' / 'sql'
    data_dir.mkdir(parents=True, exist_ok=True)

    db_path = data_dir / 'ecommerce.db'

    # Connect to database
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    print("Setting up E-Commerce Analytics Database...")
    print(f"Database path: {db_path}")

    # Read and execute schema file
    schema_path = Path(__file__).parent.parent / 'sql' / 'schema' / '01_create_tables.sql'

    if schema_path.exists():
        print(f"\nExecuting schema: {schema_path}")
        with open(schema_path, 'r') as f:
            schema_sql = f.read()

        # Split by semicolon and execute each statement
        statements = [s.strip() for s in schema_sql.split(';') if s.strip()]

        for i, statement in enumerate(statements, 1):
            try:
                # Skip DELIMITER commands (MySQL specific)
                if statement.upper().startswith('DELIMITER'):
                    continue
                cursor.execute(statement)
            except Exception as e:
                print(f"Warning executing statement {i}: {e}")

        conn.commit()
        print("Schema created successfully!")
    else:
        print(f"Warning: Schema file not found at {schema_path}")

    # Read and execute sample data file
    data_path = Path(__file__).parent.parent / 'sql' / 'schema' / '02_insert_sample_data.sql'

    if data_path.exists():
        print(f"\nExecuting sample data: {data_path}")
        with open(data_path, 'r') as f:
            data_sql = f.read()

        # Split by semicolon and execute each statement
        statements = [s.strip() for s in data_sql.split(';') if s.strip()]

        for i, statement in enumerate(statements, 1):
            try:
                # Skip DELIMITER and CALL commands (MySQL specific)
                if statement.upper().startswith(('DELIMITER', 'CALL')):
                    continue
                cursor.execute(statement)
            except Exception as e:
                print(f"Warning executing statement {i}: {e}")

        conn.commit()
        print("Sample data inserted successfully!")
    else:
        print(f"Warning: Sample data file not found at {data_path}")

    # Verify tables
    print("\nVerifying database tables...")
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()

    if tables:
        print(f"Found {len(tables)} tables:")
        for table in tables:
            table_name = table[0]
            cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
            count = cursor.fetchone()[0]
            print(f"  - {table_name}: {count} rows")
    else:
        print("No tables found in database")

    # Close connection
    conn.close()

    print("\n" + "="*60)
    print("DATABASE SETUP COMPLETE!")
    print("="*60)
    print(f"\nDatabase location: {db_path}")
    print("\nYou can now run the analysis notebooks!")

if __name__ == "__main__":
    setup_database()
