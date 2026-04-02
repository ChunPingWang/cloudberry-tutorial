-- ============================================
-- Apache Cloudberry Tutorial
-- Script 4: 載入範例資料
-- ============================================

-- 使用 INSERT 載入取消原因代碼
INSERT INTO faa.d_cancellation_codes VALUES
    ('A', 'Carrier'),
    ('B', 'Weather'),
    ('C', 'NAS'),
    ('D', 'Security'),
    ('', 'none');

-- 使用 INSERT 載入延遲分組
INSERT INTO faa.d_delay_groups VALUES
    (0, '0-15 minutes'),
    (1, '15-30 minutes'),
    (2, '30-45 minutes'),
    (3, '45-60 minutes'),
    (4, '60-75 minutes'),
    (5, '75-90 minutes'),
    (6, '90-105 minutes'),
    (7, '105-120 minutes'),
    (8, '120-135 minutes'),
    (9, '135-150 minutes'),
    (10, '150-165 minutes'),
    (11, '165-180 minutes'),
    (12, '180+ minutes');

-- 使用 INSERT 載入距離分組
INSERT INTO faa.d_distance_groups VALUES
    (1, '0-250 miles'),
    (2, '250-500 miles'),
    (3, '500-750 miles'),
    (4, '750-1000 miles'),
    (5, '1000-1250 miles'),
    (6, '1250-1500 miles'),
    (7, '1500-1750 miles'),
    (8, '1750-2000 miles'),
    (9, '2000-2250 miles'),
    (10, '2250-2500 miles'),
    (11, '2500+ miles');

-- 載入範例機場資料
INSERT INTO faa.d_airports VALUES
    (10397, 'Hartsfield-Jackson Atlanta International', 'Atlanta', 'United States', 'ATL', 'KATL', 33.6367, -84.4281, 1026, -5, 'A', 'America/New_York'),
    (11292, 'Denver International', 'Denver', 'United States', 'DEN', 'KDEN', 39.8561, -104.6737, 5431, -7, 'A', 'America/Denver'),
    (11298, 'Dallas/Fort Worth International', 'Dallas-Fort Worth', 'United States', 'DFW', 'KDFW', 32.8968, -97.038, 607, -6, 'A', 'America/Chicago'),
    (13930, 'Chicago O''Hare International', 'Chicago', 'United States', 'ORD', 'KORD', 41.9786, -87.9048, 672, -6, 'A', 'America/Chicago'),
    (12892, 'Los Angeles International', 'Los Angeles', 'United States', 'LAX', 'KLAX', 33.9425, -118.408, 126, -8, 'A', 'America/Los_Angeles'),
    (12478, 'John F. Kennedy International', 'New York', 'United States', 'JFK', 'KJFK', 40.6398, -73.7789, 13, -5, 'A', 'America/New_York'),
    (14771, 'San Francisco International', 'San Francisco', 'United States', 'SFO', 'KSFO', 37.619, -122.375, 13, -8, 'A', 'America/Los_Angeles'),
    (14747, 'Seattle-Tacoma International', 'Seattle', 'United States', 'SEA', 'KSEA', 47.449, -122.309, 433, -8, 'A', 'America/Los_Angeles'),
    (12266, 'McCarran International', 'Las Vegas', 'United States', 'LAS', 'KLAS', 36.08, -115.152, 2181, -8, 'A', 'America/Los_Angeles'),
    (13204, 'Miami International', 'Miami', 'United States', 'MIA', 'KMIA', 25.7932, -80.2906, 8, -5, 'A', 'America/New_York');

-- 載入範例航空公司資料
INSERT INTO faa.d_airlines VALUES
    (19393, 'Southwest Airlines Co.'),
    (19690, 'Hawaiian Airlines Inc.'),
    (19790, 'Delta Air Lines Inc.'),
    (19805, 'American Airlines Inc.'),
    (19930, 'United Air Lines Inc.'),
    (19977, 'US Airways Inc.'),
    (20304, 'Frontier Airlines Inc.'),
    (20366, 'JetBlue Airways'),
    (20409, 'Alaska Airlines Inc.'),
    (20416, 'Spirit Air Lines');

-- 驗證載入結果
SELECT 'airports' AS table_name, COUNT(*) AS row_count FROM faa.d_airports
UNION ALL
SELECT 'airlines', COUNT(*) FROM faa.d_airlines
UNION ALL
SELECT 'cancellation_codes', COUNT(*) FROM faa.d_cancellation_codes
UNION ALL
SELECT 'delay_groups', COUNT(*) FROM faa.d_delay_groups
UNION ALL
SELECT 'distance_groups', COUNT(*) FROM faa.d_distance_groups;
