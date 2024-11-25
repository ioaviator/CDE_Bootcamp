WITH stg_language AS(
    SELECT
        country_name AS country_name,
        language_name
    from {{ source('raw', 'language')  }}
)

SELECT * FROM stg_language