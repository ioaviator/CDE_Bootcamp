transform() {

		# Create the Transformed directory if it doesn't exist
    TRANSFORM_DIR=Transformed
		mkdir -p $TRANSFORM_DIR

    # Use awk with an FS that handles quoted commas
    awk '
    BEGIN {
        FS = ","                      # Set the field separator to comma
        OFS = ","                     # Set the output field separator to comma
    }
    # NR==1 First row of the dataset
    NR == 1 {
        # Convert header names to lowercase and identify the index of each column
        for (i=1; i<=NF; i++) {
            gsub(/"/, "", $i)         # Remove quotes from header names
            header = tolower($i)
            if (header == "year") year_idx = i
            else if (header == "value") value_idx = i
            else if (header == "units") units_idx = i
            else if (header == "variable_code") variable_code_idx = i
        }
        # Print the new header with selected columns
        print "year", "value", "units", "variable_code"
    }

    #NR > 1 Second row, where the record values begins
    NR > 1 {
        # Reconstruct the line correctly handling quoted fields
        line = $0
        gsub(/,/, "|", line)         # Replace commas with pipes temporarily
        gsub(/\|"/, ",", line)       # Replace commas back within quotes
        split(line, fields, "|")     # Split fields by pipes

        # Extract fields by using their respective indices
        year = fields[year_idx]
        value = fields[value_idx]
        units = fields[units_idx]
        variable_code = fields[variable_code_idx]


        # Print the selected columns, ensuring they remain properly separated
        print year, value, units, variable_code
    }
    ' raw/annual-enterprise-survey-2023-fin-yr-provisional.csv > Transformed/2023_year_finance.csv

    # Confirm the file is created
    if [ -f $TRANSFORM_DIR/2023_year_finance.csv ]; then
        echo "File successfully created in $TRANSFORM_DIR/2023_year_finance.csv"
    else
        echo "Error: File was not created."
    fi
}
