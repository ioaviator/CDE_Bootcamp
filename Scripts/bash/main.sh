#!/bin/bash

# Import the extract, transform, and load functions from separate script files
source ./ETL/extract.sh
source ./ETL/transform.sh
source ./ETL/load.sh

# Run the functions in sequence
extract
transform
load
