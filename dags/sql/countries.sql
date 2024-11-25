CREATE TABLE IF NOT EXISTS countries (
    country_name TEXT NOT NULL,
    independent TEXT NOT NULL,
    unmember TEXT NOT NULL,
    startOfWeek TEXT NOT NULL,
    official_country_name TEXT NOT NULL,
    common_native_name TEXT NOT NULL,
    currency_codes TEXT NOT NULL,
    currency_names TEXT NOT NULL,
    currency_symbols TEXT NOT NULL,
    country_code TEXT NOT NULL,
    capital TEXT,
    region TEXT NOT NULL,
    subregion TEXT,
    area TEXT NOT NULL,
    population INTEGER NOT NULL,
    continent TEXT NOT NULL
);
