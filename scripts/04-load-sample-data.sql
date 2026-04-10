-- ============================================
-- Apache Cloudberry Tutorial
-- Script 4: 載入範例資料
-- 前置條件：已執行 Script 3
-- ============================================

-- 連線到 tutorial 資料庫
\c tutorial

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
    (19393, 'Southwest Airlines Co.', 'WN'),
    (19690, 'Hawaiian Airlines Inc.', 'HA'),
    (19790, 'Delta Air Lines Inc.', 'DL'),
    (19805, 'American Airlines Inc.', 'AA'),
    (19930, 'United Air Lines Inc.', 'UA'),
    (19977, 'US Airways Inc.', 'US'),
    (20304, 'Frontier Airlines Inc.', 'F9'),
    (20366, 'JetBlue Airways', 'B6'),
    (20409, 'Alaska Airlines Inc.', 'AS'),
    (20416, 'Spirit Air Lines', 'NK');

-- ============================================
-- 載入事實表範例資料（航班記錄）
-- 涵蓋 2009-06 至 2010-03 共 10 個月份
-- ============================================

-- 2009 年 6 月航班
INSERT INTO faa.otp_r VALUES
    ('2009-06-01', 'AA', 100, 'DFW', 'LAX', 800, 945, -5, -2, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-01', 'AA', 200, 'LAX', 'JFK', 1030, 1845, 15, 10, false, '', false, 15, 0, 0, 0, 0),
    ('2009-06-01', 'DL', 300, 'ATL', 'ORD', 700, 830, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-01', 'DL', 301, 'ORD', 'ATL', 1200, 1430, 30, 25, false, '', false, 10, 0, 20, 0, 0),
    ('2009-06-01', 'UA', 500, 'SFO', 'DEN', 900, 1230, 0, 5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-01', 'WN', 700, 'LAS', 'LAX', 1400, 1520, -8, -3, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-02', 'AA', 100, 'DFW', 'LAX', 805, 1010, 20, 25, false, '', false, 20, 0, 0, 0, 0),
    ('2009-06-02', 'DL', 300, 'ATL', 'ORD', 710, 835, -5, 10, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-02', 'UA', 501, 'DEN', 'SFO', 1100, 1230, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-06-02', 'WN', 701, 'LAX', 'LAS', 1500, 1615, -2, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-03', 'AA', 201, 'JFK', 'LAX', 800, 1130, 45, 40, false, '', false, 20, 0, 10, 0, 15),
    ('2009-06-03', 'DL', 302, 'ATL', 'MIA', 600, 800, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-03', 'B6', 600, 'JFK', 'SFO', 700, 1030, 10, 5, false, '', false, 10, 0, 0, 0, 0),
    ('2009-06-03', 'UA', 500, 'SFO', 'DEN', 905, 1240, 10, 10, false, '', false, 0, 0, 10, 0, 0),
    ('2009-06-04', 'AA', 100, 'DFW', 'LAX', 800, 940, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-04', 'WN', 702, 'DEN', 'LAS', 1300, 1400, -15, -10, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-04', 'DL', 300, 'ATL', 'ORD', 700, 900, 60, 55, false, '', false, 30, 0, 20, 0, 10),
    ('2009-06-04', 'AS', 800, 'SEA', 'LAX', 800, 1045, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-06-05', 'AA', 200, 'LAX', 'JFK', 1035, 1900, 30, 35, false, '', false, 10, 0, 0, 0, 20),
    ('2009-06-05', 'UA', 502, 'ORD', 'SFO', 1400, 1615, -5, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-05', 'DL', 303, 'MIA', 'ATL', 900, 1100, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-05', 'B6', 601, 'SFO', 'JFK', 1100, 1930, 25, 20, false, '', false, 10, 0, 15, 0, 0),
    ('2009-06-05', 'WN', 700, 'LAS', 'LAX', 1400, 1530, 2, 5, false, '', false, 2, 0, 0, 0, 0),
    ('2009-06-06', 'AA', 100, 'DFW', 'LAX', 815, 1000, 10, 15, false, '', false, 10, 0, 0, 0, 0),
    ('2009-06-06', 'DL', 300, 'ATL', 'ORD', 700, 830, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-06', 'NK', 900, 'DFW', 'ATL', 600, 900, 0, 5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-07', 'UA', 500, 'SFO', 'DEN', 900, 1235, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-06-07', 'AA', 201, 'JFK', 'LAX', 805, 1140, 55, 50, false, '', false, 25, 10, 10, 0, 10),
    ('2009-06-07', 'F9', 950, 'DEN', 'ORD', 1000, 1330, 20, 15, false, '', false, 0, 0, 20, 0, 0),
    ('2009-06-07', 'HA', 10, 'LAX', 'SEA', 1400, 1640, -5, 0, false, '', false, NULL, NULL, NULL, NULL, NULL);

-- 2009 年 6 月：取消與轉降
INSERT INTO faa.otp_r VALUES
    ('2009-06-08', 'AA', 100, 'DFW', 'LAX', NULL, NULL, NULL, NULL, true, 'A', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-08', 'DL', 300, 'ATL', 'ORD', NULL, NULL, NULL, NULL, true, 'B', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-08', 'UA', 500, 'SFO', 'DEN', 900, 1400, 90, 85, false, '', true, 30, 30, 20, 0, 10),
    ('2009-06-09', 'WN', 700, 'LAS', 'LAX', NULL, NULL, NULL, NULL, true, 'C', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-06-09', 'DL', 301, 'ORD', 'ATL', 1205, 1500, 60, 55, false, '', false, 20, 15, 15, 0, 10),
    ('2009-06-09', 'AA', 200, 'LAX', 'JFK', 1045, 1855, 25, 30, false, '', false, 10, 0, 0, 0, 15),
    ('2009-06-10', 'B6', 600, 'JFK', 'SFO', 700, 1035, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-06-10', 'AS', 801, 'LAX', 'SEA', 900, 1130, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL);

-- 2009 年 7 月航班
INSERT INTO faa.otp_r VALUES
    ('2009-07-01', 'AA', 100, 'DFW', 'LAX', 800, 940, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-07-01', 'DL', 300, 'ATL', 'ORD', 700, 835, -5, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-07-01', 'UA', 500, 'SFO', 'DEN', 905, 1240, 10, 15, false, '', false, 0, 0, 10, 0, 0),
    ('2009-07-01', 'WN', 700, 'LAS', 'LAX', 1400, 1515, -13, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-07-01', 'B6', 600, 'JFK', 'SFO', 705, 1045, 15, 10, false, '', false, 15, 0, 0, 0, 0),
    ('2009-07-02', 'AA', 200, 'LAX', 'JFK', 1030, 1850, 20, 15, false, '', false, 10, 0, 0, 0, 10),
    ('2009-07-02', 'DL', 301, 'ORD', 'ATL', 1200, 1425, -5, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-07-02', 'UA', 501, 'DEN', 'SFO', 1100, 1225, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-07-02', 'WN', 701, 'LAX', 'LAS', 1500, 1620, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-07-02', 'AS', 800, 'SEA', 'LAX', 800, 1050, 10, 5, false, '', false, 5, 0, 5, 0, 0),
    ('2009-07-03', 'AA', 100, 'DFW', 'LAX', 810, 1000, 10, 10, false, '', false, 10, 0, 0, 0, 0),
    ('2009-07-03', 'DL', 302, 'ATL', 'MIA', 600, 755, -5, -10, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-07-03', 'NK', 900, 'DFW', 'ATL', 600, 905, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-07-03', 'F9', 950, 'DEN', 'ORD', 1000, 1325, 15, 10, false, '', false, 0, 0, 15, 0, 0),
    ('2009-07-03', 'HA', 10, 'LAX', 'SEA', 1400, 1635, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-07-04', 'AA', 201, 'JFK', 'LAX', 800, 1200, 75, 70, false, '', false, 30, 15, 20, 0, 10),
    ('2009-07-04', 'DL', 300, 'ATL', 'ORD', 720, 910, 40, 35, false, '', false, 15, 10, 15, 0, 0),
    ('2009-07-04', 'UA', 500, 'SFO', 'DEN', 900, 1300, 30, 25, false, '', false, 10, 0, 15, 0, 5),
    ('2009-07-04', 'WN', 700, 'LAS', 'LAX', 1405, 1530, 2, 5, false, '', false, 2, 0, 0, 0, 0),
    ('2009-07-04', 'B6', 601, 'SFO', 'JFK', 1100, 1945, 40, 35, false, '', false, 15, 10, 0, 0, 15),
    ('2009-07-05', 'AA', 100, 'DFW', 'LAX', NULL, NULL, NULL, NULL, true, 'B', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-07-05', 'DL', 303, 'MIA', 'ATL', 900, 1055, -5, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-07-05', 'UA', 502, 'ORD', 'SFO', 1400, 1620, 0, 5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-07-05', 'WN', 702, 'DEN', 'LAS', 1300, 1355, -20, -15, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-07-05', 'AS', 801, 'LAX', 'SEA', 900, 1125, -5, 0, false, '', false, NULL, NULL, NULL, NULL, NULL);

-- 2009 年 8 月航班
INSERT INTO faa.otp_r VALUES
    ('2009-08-01', 'AA', 100, 'DFW', 'LAX', 800, 950, 0, 5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-08-01', 'DL', 300, 'ATL', 'ORD', 705, 840, 0, 5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-08-01', 'UA', 500, 'SFO', 'DEN', 910, 1250, 20, 15, false, '', false, 10, 0, 10, 0, 0),
    ('2009-08-01', 'WN', 700, 'LAS', 'LAX', 1400, 1510, -18, -10, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-08-02', 'AA', 200, 'LAX', 'JFK', 1035, 1910, 40, 35, false, '', false, 20, 0, 10, 0, 10),
    ('2009-08-02', 'DL', 301, 'ORD', 'ATL', 1200, 1440, 10, 5, false, '', false, 10, 0, 0, 0, 0),
    ('2009-08-02', 'B6', 600, 'JFK', 'SFO', 700, 1025, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-08-02', 'WN', 701, 'LAX', 'LAS', 1510, 1635, 20, 25, false, '', false, 10, 0, 10, 0, 0),
    ('2009-08-03', 'AA', 100, 'DFW', 'LAX', 800, 945, -5, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-08-03', 'UA', 501, 'DEN', 'SFO', 1100, 1230, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-08-03', 'DL', 302, 'ATL', 'MIA', 600, 800, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-08-03', 'NK', 900, 'DFW', 'ATL', 605, 910, 10, 5, false, '', false, 0, 0, 10, 0, 0),
    ('2009-08-04', 'AS', 800, 'SEA', 'LAX', 800, 1100, 20, 15, false, '', false, 10, 0, 5, 0, 5),
    ('2009-08-04', 'F9', 950, 'DEN', 'ORD', 1005, 1340, 30, 25, false, '', false, 10, 5, 15, 0, 0),
    ('2009-08-04', 'HA', 10, 'LAX', 'SEA', 1400, 1650, 5, 10, false, '', false, 5, 0, 0, 0, 0),
    ('2009-08-04', 'DL', 300, 'ATL', 'ORD', NULL, NULL, NULL, NULL, true, 'B', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-08-05', 'AA', 201, 'JFK', 'LAX', 800, 1145, 60, 55, false, '', false, 25, 15, 10, 0, 10),
    ('2009-08-05', 'WN', 700, 'LAS', 'LAX', 1400, 1525, -3, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-08-05', 'UA', 500, 'SFO', 'DEN', 900, 1235, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-08-05', 'B6', 601, 'SFO', 'JFK', 1105, 1940, 35, 30, false, '', false, 15, 5, 0, 0, 15);

-- 2009 年 9 月航班
INSERT INTO faa.otp_r VALUES
    ('2009-09-01', 'AA', 100, 'DFW', 'LAX', 800, 935, -15, -10, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-01', 'DL', 300, 'ATL', 'ORD', 700, 825, -15, -10, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-01', 'UA', 500, 'SFO', 'DEN', 900, 1230, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-01', 'WN', 700, 'LAS', 'LAX', 1400, 1510, -18, -10, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-02', 'AA', 200, 'LAX', 'JFK', 1030, 1840, 10, 5, false, '', false, 10, 0, 0, 0, 0),
    ('2009-09-02', 'DL', 301, 'ORD', 'ATL', 1200, 1430, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-02', 'B6', 600, 'JFK', 'SFO', 700, 1030, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-02', 'AS', 800, 'SEA', 'LAX', 800, 1040, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-03', 'AA', 100, 'DFW', 'LAX', 800, 945, -5, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-03', 'UA', 501, 'DEN', 'SFO', 1100, 1225, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-03', 'WN', 701, 'LAX', 'LAS', 1500, 1610, -5, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-03', 'DL', 302, 'ATL', 'MIA', 600, 755, -5, -10, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-03', 'NK', 900, 'DFW', 'ATL', 600, 900, 0, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-04', 'F9', 950, 'DEN', 'ORD', 1000, 1320, 10, 5, false, '', false, 0, 0, 10, 0, 0),
    ('2009-09-04', 'HA', 10, 'LAX', 'SEA', 1400, 1630, -15, -10, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-09-04', 'AA', 201, 'JFK', 'LAX', 800, 1125, 40, 35, false, '', false, 15, 10, 5, 0, 10);

-- 2009 年 10 月航班
INSERT INTO faa.otp_r VALUES
    ('2009-10-01', 'AA', 100, 'DFW', 'LAX', 800, 940, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-10-01', 'DL', 300, 'ATL', 'ORD', 700, 830, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-10-01', 'UA', 500, 'SFO', 'DEN', 900, 1235, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-10-01', 'WN', 700, 'LAS', 'LAX', 1400, 1520, -8, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-10-02', 'AA', 200, 'LAX', 'JFK', 1030, 1900, 30, 25, false, '', false, 15, 0, 5, 0, 10),
    ('2009-10-02', 'DL', 301, 'ORD', 'ATL', 1200, 1445, 15, 10, false, '', false, 15, 0, 0, 0, 0),
    ('2009-10-02', 'B6', 600, 'JFK', 'SFO', 700, 1040, 10, 5, false, '', false, 10, 0, 0, 0, 0),
    ('2009-10-02', 'WN', 701, 'LAX', 'LAS', 1500, 1620, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-10-03', 'AS', 800, 'SEA', 'LAX', 800, 1040, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-10-03', 'UA', 501, 'DEN', 'SFO', 1100, 1230, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-10-03', 'DL', 300, 'ATL', 'ORD', 700, 855, 15, 10, false, '', false, 0, 0, 15, 0, 0),
    ('2009-10-03', 'AA', 100, 'DFW', 'LAX', NULL, NULL, NULL, NULL, true, 'A', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-10-04', 'NK', 900, 'DFW', 'ATL', 600, 910, 10, 5, false, '', false, 0, 0, 10, 0, 0),
    ('2009-10-04', 'F9', 950, 'DEN', 'ORD', 1000, 1340, 30, 20, false, '', false, 10, 5, 15, 0, 0),
    ('2009-10-04', 'HA', 10, 'LAX', 'SEA', 1400, 1645, 0, 5, false, '', false, NULL, NULL, NULL, NULL, NULL);

-- 2009 年 11 月航班
INSERT INTO faa.otp_r VALUES
    ('2009-11-01', 'AA', 100, 'DFW', 'LAX', 800, 935, -15, -10, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-11-01', 'DL', 300, 'ATL', 'ORD', 700, 830, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-11-01', 'UA', 500, 'SFO', 'DEN', 900, 1230, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-11-02', 'WN', 700, 'LAS', 'LAX', 1400, 1525, -3, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-11-02', 'AA', 200, 'LAX', 'JFK', 1030, 1855, 25, 20, false, '', false, 10, 0, 5, 0, 10),
    ('2009-11-02', 'DL', 301, 'ORD', 'ATL', 1200, 1430, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-11-03', 'B6', 600, 'JFK', 'SFO', 700, 1030, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-11-03', 'UA', 501, 'DEN', 'SFO', 1100, 1225, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-11-03', 'AS', 800, 'SEA', 'LAX', 800, 1040, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-11-04', 'AA', 201, 'JFK', 'LAX', 800, 1130, 45, 40, false, '', false, 20, 10, 5, 0, 10),
    ('2009-11-04', 'DL', 302, 'ATL', 'MIA', 600, 800, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-11-04', 'WN', 701, 'LAX', 'LAS', 1500, 1615, 0, 5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-11-25', 'AA', 100, 'DFW', 'LAX', 820, 1030, 40, 35, false, '', false, 15, 10, 10, 0, 5),
    ('2009-11-25', 'DL', 300, 'ATL', 'ORD', 730, 930, 60, 50, false, '', false, 20, 15, 15, 0, 10),
    ('2009-11-25', 'UA', 500, 'SFO', 'DEN', 920, 1310, 40, 35, false, '', false, 15, 10, 10, 0, 5),
    ('2009-11-25', 'WN', 700, 'LAS', 'LAX', 1420, 1600, 32, 25, false, '', false, 10, 10, 12, 0, 0),
    ('2009-11-26', 'AA', 200, 'LAX', 'JFK', NULL, NULL, NULL, NULL, true, 'B', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-11-26', 'DL', 301, 'ORD', 'ATL', NULL, NULL, NULL, NULL, true, 'B', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-11-26', 'B6', 600, 'JFK', 'SFO', 730, 1120, 50, 45, false, '', false, 20, 15, 0, 0, 15);

-- 2009 年 12 月航班
INSERT INTO faa.otp_r VALUES
    ('2009-12-01', 'AA', 100, 'DFW', 'LAX', 800, 940, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-12-01', 'DL', 300, 'ATL', 'ORD', 700, 830, -10, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-12-01', 'UA', 500, 'SFO', 'DEN', 900, 1230, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-12-01', 'WN', 700, 'LAS', 'LAX', 1400, 1515, -13, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-12-02', 'AA', 200, 'LAX', 'JFK', 1030, 1845, 15, 10, false, '', false, 15, 0, 0, 0, 0),
    ('2009-12-02', 'DL', 301, 'ORD', 'ATL', 1200, 1435, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-12-02', 'B6', 600, 'JFK', 'SFO', 700, 1035, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2009-12-02', 'AS', 800, 'SEA', 'LAX', 800, 1050, 10, 5, false, '', false, 5, 0, 5, 0, 0),
    ('2009-12-20', 'AA', 100, 'DFW', 'LAX', 830, 1050, 60, 55, false, '', false, 25, 15, 10, 0, 10),
    ('2009-12-20', 'DL', 300, 'ATL', 'ORD', 740, 1000, 90, 80, false, '', false, 30, 30, 20, 0, 10),
    ('2009-12-20', 'UA', 500, 'SFO', 'DEN', 930, 1350, 80, 70, false, '', false, 25, 25, 20, 0, 10),
    ('2009-12-20', 'WN', 700, 'LAS', 'LAX', 1430, 1610, 42, 35, false, '', false, 15, 15, 12, 0, 0),
    ('2009-12-21', 'AA', 200, 'LAX', 'JFK', NULL, NULL, NULL, NULL, true, 'B', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-12-21', 'DL', 301, 'ORD', 'ATL', NULL, NULL, NULL, NULL, true, 'B', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-12-21', 'UA', 501, 'DEN', 'SFO', NULL, NULL, NULL, NULL, true, 'B', false, NULL, NULL, NULL, NULL, NULL),
    ('2009-12-22', 'B6', 601, 'SFO', 'JFK', 1120, 1955, 50, 45, false, '', false, 20, 15, 0, 0, 15);

-- 2010 年 1 月航班
INSERT INTO faa.otp_r VALUES
    ('2010-01-05', 'AA', 100, 'DFW', 'LAX', 800, 940, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-01-05', 'DL', 300, 'ATL', 'ORD', 700, 830, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-01-05', 'UA', 500, 'SFO', 'DEN', 900, 1230, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-01-05', 'WN', 700, 'LAS', 'LAX', 1400, 1510, -18, -10, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-01-06', 'AA', 200, 'LAX', 'JFK', 1030, 1845, 15, 10, false, '', false, 15, 0, 0, 0, 0),
    ('2010-01-06', 'DL', 301, 'ORD', 'ATL', 1200, 1430, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-01-06', 'B6', 600, 'JFK', 'SFO', 700, 1030, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-01-06', 'AS', 800, 'SEA', 'LAX', 800, 1040, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-01-07', 'UA', 501, 'DEN', 'SFO', 1100, 1225, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-01-07', 'WN', 701, 'LAX', 'LAS', 1500, 1610, -5, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-01-07', 'NK', 900, 'DFW', 'ATL', 600, 900, 0, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-01-07', 'F9', 950, 'DEN', 'ORD', 1000, 1325, 15, 10, false, '', false, 0, 0, 15, 0, 0);

-- 2010 年 2 月航班
INSERT INTO faa.otp_r VALUES
    ('2010-02-01', 'AA', 100, 'DFW', 'LAX', 800, 945, -5, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-02-01', 'DL', 300, 'ATL', 'ORD', 700, 840, 0, 5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-02-01', 'UA', 500, 'SFO', 'DEN', 905, 1245, 15, 10, false, '', false, 5, 0, 10, 0, 0),
    ('2010-02-01', 'WN', 700, 'LAS', 'LAX', 1400, 1520, -8, 0, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-02-02', 'AA', 200, 'LAX', 'JFK', 1035, 1900, 30, 25, false, '', false, 15, 0, 5, 0, 10),
    ('2010-02-02', 'DL', 301, 'ORD', 'ATL', 1200, 1450, 20, 15, false, '', false, 10, 0, 10, 0, 0),
    ('2010-02-02', 'B6', 600, 'JFK', 'SFO', 700, 1040, 10, 5, false, '', false, 10, 0, 0, 0, 0),
    ('2010-02-05', 'AA', 100, 'DFW', 'LAX', NULL, NULL, NULL, NULL, true, 'B', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-02-05', 'DL', 300, 'ATL', 'ORD', NULL, NULL, NULL, NULL, true, 'B', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-02-05', 'UA', 500, 'SFO', 'DEN', 940, 1400, 90, 85, false, '', false, 30, 30, 20, 0, 10),
    ('2010-02-06', 'WN', 700, 'LAS', 'LAX', 1400, 1540, 12, 10, false, '', false, 12, 0, 0, 0, 0),
    ('2010-02-06', 'AS', 800, 'SEA', 'LAX', 800, 1055, 15, 10, false, '', false, 5, 0, 10, 0, 0);

-- 2010 年 3 月航班
INSERT INTO faa.otp_r VALUES
    ('2010-03-01', 'AA', 100, 'DFW', 'LAX', 800, 940, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-03-01', 'DL', 300, 'ATL', 'ORD', 700, 830, -10, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-03-01', 'UA', 500, 'SFO', 'DEN', 900, 1235, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2010-03-01', 'WN', 700, 'LAS', 'LAX', 1400, 1515, -13, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-03-02', 'AA', 200, 'LAX', 'JFK', 1030, 1850, 20, 15, false, '', false, 10, 0, 0, 0, 10),
    ('2010-03-02', 'DL', 301, 'ORD', 'ATL', 1200, 1430, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-03-02', 'B6', 600, 'JFK', 'SFO', 700, 1035, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2010-03-02', 'AS', 800, 'SEA', 'LAX', 800, 1045, 5, 0, false, '', false, 5, 0, 0, 0, 0),
    ('2010-03-03', 'UA', 501, 'DEN', 'SFO', 1100, 1225, 0, -5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-03-03', 'WN', 701, 'LAX', 'LAS', 1500, 1615, 0, 5, false, '', false, NULL, NULL, NULL, NULL, NULL),
    ('2010-03-03', 'F9', 950, 'DEN', 'ORD', 1000, 1330, 20, 15, false, '', false, 0, 0, 20, 0, 0),
    ('2010-03-03', 'NK', 900, 'DFW', 'ATL', 600, 905, 5, 0, false, '', false, 5, 0, 0, 0, 0);

-- 將範例資料同步到列式事實表
INSERT INTO faa.otp_c SELECT * FROM faa.otp_r;

-- 驗證載入結果
SELECT 'airports' AS table_name, COUNT(*) AS row_count FROM faa.d_airports
UNION ALL
SELECT 'airlines', COUNT(*) FROM faa.d_airlines
UNION ALL
SELECT 'cancellation_codes', COUNT(*) FROM faa.d_cancellation_codes
UNION ALL
SELECT 'delay_groups', COUNT(*) FROM faa.d_delay_groups
UNION ALL
SELECT 'distance_groups', COUNT(*) FROM faa.d_distance_groups
UNION ALL
SELECT 'otp_r (flights)', COUNT(*) FROM faa.otp_r
UNION ALL
SELECT 'otp_c (flights)', COUNT(*) FROM faa.otp_c;
