#!/bin/bash


load() {
    # Create a directory named "Gold" if it doesn't exist
    mkdir -p $GOLD_DIR

    # Move the transformed file to the Gold directory
    mv $TRANSFORM_DIR/2023_year_finance.csv $GOLD_DIR/

    # Confirm that the file has been saved into the Gold directory
    if [ -f "$GOLD_DIR/2023_year_finance.csv" ]; then
        echo "File successfully loaded into $GOLD_DIR directory"
    else
        echo "Failed to load file into $GOLD_DIR directory"
    fi
}
