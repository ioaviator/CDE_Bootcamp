
with

source as (

    select * from {{ source('fufu_republic','customer') }}

),

customer as (

    select
        cust_id as customer_id,
        first_name,
        last_name,
        email

    from source

)

select * from customer