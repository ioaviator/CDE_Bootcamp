WITH stg_countries AS(
    SELECT
        country_name,
        independent,
        unmember AS united_nation_members,
        startofweek AS start_of_week,
        common_native_name ,
        currency_codes,
        currency_names,
        currency_symbols,
        country_code,
        capital,
        region,
        subregion,
        area,
        population,
        continent
    from {{ source('raw', 'countries') }}
)

SELECT
    *
FROM stg_countries