load() {
    # Create a directory named "Gold" if it doesn't exist
    mkdir -p Gold

    # Move the transformed file to the Gold directory
    mv transformed/2023_year_finance.csv Gold/

    # Confirm that the file has been saved into the Gold directory
    if [ -f "Gold/2023_year_finance.csv" ]; then
        echo "File successfully loaded into 'Gold' directory."
    else
        echo "Failed to load the file into 'Gold' directory."
    fi
}

load