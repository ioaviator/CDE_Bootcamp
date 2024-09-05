#!/bin/bash

# Function to download the CSV file and save it in the 'raw' folder
extract() {
        
    mkdir -p $RAW_DIR_PATH  # Create the 'raw' folder if it doesn't exist

    if [ -f "$RAW_DIR_PATH/$OUTPUT_FILE" ]; then
        echo "Expected file $OUTPUT_FILE already exists in $RAW_DIR_PATH directory"
    else
        curl -o $RAW_DIR_PATH/$OUTPUT_FILE $FILE_URL
        # Check if the directory is not empty and contains the specific file
        if [ "$(ls -A "$RAW_DIR_PATH")" ] && [ -f "$RAW_DIR_PATH/$OUTPUT_FILE" ]; then
            echo "$OUTPUT_FILE saved successfully to $RAW_DIR_PATH directory" 
        else
            echo "Error downloading file...."
        fi
    fi 
}

