#!/bin/bash

# Function to download the CSV file and save it in the 'raw' folder
extract() {
    OUTPUT_FILE=annual-enterprise-survey-2023-fin-yr-provisional.csv
    
    FILE_URL=https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv

    DIR_PATH=raw
        
    mkdir -p $DIR_PATH  # Create the 'raw' folder if it doesn't exist

    if [ -f "$DIR_PATH/$OUTPUT_FILE" ]; then
        echo "Expected file $OUTPUT_FILE already exists in $DIR_PATH directory"
    else
        curl -o $DIR_PATH/$OUTPUT_FILE $FILE_URL
        # Check if the directory is not empty and contains the specific file
        if [ "$(ls -A "$DIR_PATH")" ] && [ -f "$DIR_PATH/$OUTPUT_FILE" ]; then
            echo "$OUTPUT_FILE saved successfully to $DIR_PATH directory" 
        else
            echo "Error downloading file...."
        fi
    fi 
}

# Call the function
extract
