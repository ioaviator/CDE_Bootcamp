#!/bin/bash

# Database credentials
DB_NAME="posey"
DB_USER="postgres"
# DB_PASSWORD="1234"
DB_HOST="127.0.0.1"
DB_PORT="5432"

# Directory containing the CSV files
CSV_DIR="$(pwd)/posey"

# Function to infer the data type of a column
infer_data_type() {
    local column_data="$1"
    if [[ $column_data =~ ^[0-9]+$ ]]; then
        echo "INT"
    elif [[ $column_data =~ ^[0-9]+\.[0-9]+$ ]]; then
        echo "FLOAT"
    else
        echo "TEXT"
    fi
}

# Function to create a table dynamically based on CSV headers and sample data
create_table() {
    local csv_file="$1"
    local table_name="$2"

    # Extract the header from the CSV file
    header=$(head -n 1 "$csv_file")

    # Split the header into column names
    IFS=',' read -r -a columns <<< "$header"

    # Start creating the SQL statement for table creation
    create_table_sql="CREATE TABLE IF NOT EXISTS $table_name ("

    # Infer data types using the first non-empty row of data
    data_row=$(awk 'NR>1 && NF{print; exit}' "$csv_file")
    IFS=',' read -r -a data <<< "$data_row"

    # Dynamically add columns with inferred data types
    for i in "${!columns[@]}"; do
        clean_column=$(echo "${columns[$i]}" | tr -d '"' | tr ' ' '_' | tr -cd '[:alnum:]_')
        data_type=$(infer_data_type "${data[$i]}")
        create_table_sql+="$clean_column $data_type,"
    done

    # Remove the last comma and close the SQL statement
    create_table_sql=${create_table_sql%,}
    create_table_sql+=");"

    # Execute the SQL statement to create the table
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "$create_table_sql"

}

# Iterate over all CSV files in the directory
for csv_file in "$CSV_DIR"/*.csv; do
    # Get the filename without the extension
    table_name=$(basename "$csv_file" .csv)

    echo "Processing $csv_file..."

    # Create the table based on the CSV structure
    create_table "$csv_file" "$table_name"

    # Import the CSV data into the table
    psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "
    COPY $table_name FROM '$(realpath "$csv_file")' DELIMITER ',' CSV HEADER;"

    echo "$csv_file imported successfully."
done
