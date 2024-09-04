#!/bin/bash

# Function to download the CSV file and save it in the 'raw' folder
extract() {
    OUTPUT_FILE=annual-enterprise-survey-2023-fin-yr-provisional.csv
    
    FILE_URL=https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv

    DIR_PATH=raw
        
    mkdir -p $DIR_PATH  # Create the 'raw' folder if it doesn't exist


    # Download the file and save it in the 'raw' folder
    curl -o raw/$OUTPUT_FILE $FILE_URL

    echo "File saved in the $DIR_PATH folder as $OUTPUT_FILE"
    
}

# Call the function
extract
