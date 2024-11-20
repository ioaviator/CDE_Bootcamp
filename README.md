## Please allow till sunday, Many things went wrong with cloud service authentication

## Backgroud Story

A travel Agency whose business model involves recommending tourist location to their customers based on different data pointsreached out to Core Data Engineers CEO.
They want one of their graduates to build a Data Platform that will process the data from the [Country rest API](https://restcountries.com/v3.1/all) into their cloud based Database/Data Warehouse for predictive analytics which will be used by their Data Science team

## Project Setup

This guide gives instructions on how to setup the project environment and provision necessary configurations

## Requirements
- Python 3.10 + higher
- Azure Cloud [Storage Account, PostgreSQL, Container Registry, Data Factory]
- Astronomer Airflow
- Terraform
- Docker Desktop
- Microsoft Power BI
- Github Actions

## Usage

## Clone the repository

```bash
# clone the project repository
git clone <project-url>

# Navigate to the cloned repository
cd <project-url>
```

## Create secret credentials
```bash
# In the root directory, create a .env file and load these variables

ACCOUNT_KEY="key-to-azure-cloud-storage-account"
URL="url-to-parquet-file-stored-in-cloud-storage"
```

# Provision Cloud Infrastructure with Terraform
```bash
    # Login into Azure
    az login
```

```bash
    # Provision all services needed for project

    cd terraform

    # initiliaze 
    terraform init

    # plan
    terraform plan

    # apply
    terraform apply --auto-approve
```

# Start the apache airflow services
```bash
    # in the root of the project directory
    astro dev start
    # This command boots up the services needed to start up the project
```

![Data Architecture](./_img/cde_project.gif)

## Work in progress, please allow till sunday