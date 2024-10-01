### Shell Scripting with Bash

### Project Description:
The aim of this project is to demostrate the use of shell scripting in developing and automating data engineering tasks

### Requirements
Understanding of shell scripting (Bash)
Understanding of SQL Queries

### Project Components:
Data Acquisition: Connecting to online data source using bash scripts 

Data Transformation: Utilizing bash scripts to extract specific columns

Data Integration: Loading data into PostgreSQL database for structured querying and analysis. 
Moving data from one directory to another

## Move Data From Source To Destination
![mv_src_to_dest](./Scripts/_img/src_2_dest.gif)

### Usage
- Fork the repository
- Clone the repository to your local environment.  `git clone https://repo-url`
- Open the cloned folder with your terminal
- Checkout to the linux branch `git checkout linux`
- Navigate into the Scripts/bash directory `cd Scripts/bash`
- Create a config.env and error.log file
- Inside config.env, create these .env variables

```
# example config variables

# Define the source and destination directories

source_dir=json_csv_raw
destination_dir=json_and_csv

# Define the log file for error messages
ERROR_LOG=error.log
```
- Grant permission to the scripts 

```
chmod +x move_files.sh
```
- Run the file
```
./move_files.sh
```
## CAVEATS
Because of the differences in environment between windows and linux, you might encounter some errors when executing this program in a linux based environment. 
The reason is because of the LF (Line Feed) and CRLF (Carriage Return Line Feed) differences between Linux and Windows

```
./config.env: line 2: $'\r': command not found
./config.env: line 4: $'\r': command not found
```

To fix this, simply convert the scripts to LF when running the scripts in linux environment

```
dos2unix ./config.env
dos2unix move_files.sh
```
Convert for the entire files in directory
```
dos2unix * ETL/*
```

Rerun 
```
./move_files.sh
```
<br>

## Extract Data From Local Storage to PostgreSQL 

![csv_to_postgres](./Scripts/_img/bash_pipeline.gif)


## Usage
- Navigate into the Scripts/bash directory `cd Scripts/bash`
- Inside config.env, create these .env variables

```
# Database credentials

DB_NAME=posey
DB_USER=postgres
DB_HOST=127.0.0.1
DB_PORT=5432
```

- Grant permission to the scripts 

```
chmod +x csv_to_database.sh
```
- Run the file
```
./csv_to_database.sh
```


### Running SQL Scripts
- Navigate to sql directory
- The directory contains a .sql file which contains SQL queries
- Manually import the .sql file into your postgreSQL software

### Analytical Queries

- Find a list of order IDs where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.
```
SELECT id FROM orders 
WHERE gloss_qty > 4000 OR poster_qty > 4000
```
<br >

- Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000

```
SELECT * FROM orders 
WHERE standard_qty = 0 AND (gloss_qty > 100 OR poster_qty > 100)
```
<br>

- Find all the company names that start with a 'C' or 'W', and where the primary contact contains 'ana' or 'Ana', but does not contain 'eana'
```
SELECT name
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
  AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
  AND primary_poc NOT LIKE '%eana%'
```

- Provide a table that shows the region for each sales rep along with their associated accounts.  Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) by account name
 
```
SELECT s_rep.name AS sales_rep, rgn.name AS region, acct.name AS account_name 
FROM sales_reps AS s_rep
LEFT JOIN region AS rgn 
	ON s_rep.region_id = rgn.id
RIGHT JOIN accounts AS acct 
	ON acct.sales_rep_id = s_rep.id
ORDER BY account_name
```
