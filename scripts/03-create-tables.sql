-- ============================================
-- Apache Cloudberry Tutorial
-- Script 3: 建立資料表
-- ============================================

-- 維度表
DROP TABLE IF EXISTS faa.d_airports CASCADE;
CREATE TABLE faa.d_airports (
    AirportID      INTEGER,
    Name           TEXT,
    City           TEXT,
    Country        TEXT,
    airport_code   TEXT,
    ICOA_code      TEXT,
    Latitude       FLOAT8,
    Longitude      FLOAT8,
    Altitude       FLOAT8,
    TimeZoneOffset FLOAT,
    DST_Flag       TEXT,
    TZ             TEXT
) DISTRIBUTED BY (airport_code);

DROP TABLE IF EXISTS faa.d_airlines CASCADE;
CREATE TABLE faa.d_airlines (
    AirlineID   INTEGER,
    AirlineName TEXT
) DISTRIBUTED BY (AirlineID);

DROP TABLE IF EXISTS faa.d_wac CASCADE;
CREATE TABLE faa.d_wac (
    wac       SMALLINT,
    wac_name  TEXT
) DISTRIBUTED BY (wac);

DROP TABLE IF EXISTS faa.d_cancellation_codes CASCADE;
CREATE TABLE faa.d_cancellation_codes (
    cancel_code TEXT,
    cancel_desc TEXT
) DISTRIBUTED BY (cancel_code);

DROP TABLE IF EXISTS faa.d_delay_groups CASCADE;
CREATE TABLE faa.d_delay_groups (
    delay_group SMALLINT,
    delay_range TEXT
) DISTRIBUTED BY (delay_group);

DROP TABLE IF EXISTS faa.d_distance_groups CASCADE;
CREATE TABLE faa.d_distance_groups (
    distance_group SMALLINT,
    distance_range TEXT
) DISTRIBUTED BY (distance_group);

-- 行式事實表（含分區）
DROP TABLE IF EXISTS faa.otp_r CASCADE;
CREATE TABLE faa.otp_r (
    FlightDate        DATE,
    UniqueCarrier     TEXT,
    FlightNum         INTEGER,
    Origin            TEXT,
    Dest              TEXT,
    DepTime           SMALLINT,
    ArrTime           SMALLINT,
    ArrDelay          SMALLINT,
    DepDelay          SMALLINT,
    Cancelled         BOOLEAN,
    CancellationCode  TEXT,
    Diverted          BOOLEAN,
    CarrierDelay      SMALLINT,
    WeatherDelay      SMALLINT,
    NASDelay          SMALLINT,
    SecurityDelay     SMALLINT,
    LateAircraftDelay SMALLINT
) DISTRIBUTED BY (UniqueCarrier, FlightNum)
PARTITION BY RANGE(FlightDate)
(
    START ('2009-06-01'::DATE) END ('2010-10-31'::DATE)
    EVERY (INTERVAL '1 month')
);

-- 列式事實表
DROP TABLE IF EXISTS faa.otp_c CASCADE;
CREATE TABLE faa.otp_c (LIKE faa.otp_r)
WITH (appendonly=true, orientation=column)
DISTRIBUTED BY (UniqueCarrier, FlightNum)
PARTITION BY RANGE(FlightDate)
(
    START ('2009-06-01'::DATE) END ('2010-10-31'::DATE)
    EVERY (INTERVAL '1 month')
);
