
with

source as (

    select * from {{ source('fufu_republic','branch') }}

),

branch as (

    select
        branch_id,
        location

    from source

)

select * from branch