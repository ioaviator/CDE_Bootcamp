
with

source as (

    select * from {{ source('fufu_republic','customer') }}

),

customer as (

    select
        customer_id,
        first_name,
        last_name,
        email

    from source

)

select * from customer