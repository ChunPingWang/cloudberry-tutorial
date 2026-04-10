-- ============================================
-- Apache Cloudberry Tutorial
-- Script 5: 範例查詢與效能分析
-- 前置條件：已執行 Script 4
-- ============================================

-- 連線到 tutorial 資料庫
\c tutorial

\timing on

-- 查看所有機場
SELECT airport_code, Name, City, Country
FROM faa.d_airports
ORDER BY airport_code;

-- 查看所有航空公司
SELECT * FROM faa.d_airlines ORDER BY AirlineName;

-- 查看取消原因代碼
SELECT * FROM faa.d_cancellation_codes;

-- 查看延遲分組
SELECT * FROM faa.d_delay_groups ORDER BY delay_group;

-- 查看距離分組
SELECT * FROM faa.d_distance_groups ORDER BY distance_group;

-- 查看各 Segment 的資料分佈（檢查是否均勻）
SELECT gp_segment_id, COUNT(*)
FROM faa.d_airports
GROUP BY gp_segment_id
ORDER BY gp_segment_id;

-- EXPLAIN 範例：查看查詢執行計畫
EXPLAIN
SELECT ap.Name, ap.City, ap.Country
FROM faa.d_airports ap
WHERE ap.airport_code = 'LAX';

-- EXPLAIN ANALYZE 範例：實際執行並顯示統計
EXPLAIN ANALYZE
SELECT COUNT(*) FROM faa.d_airports;

-- 地理位置查詢範例
SELECT Name, City, Latitude, Longitude
FROM faa.d_airports
WHERE Latitude BETWEEN 30 AND 45
  AND Longitude BETWEEN -120 AND -70
ORDER BY City;

-- 建立索引範例
CREATE INDEX idx_airports_code ON faa.d_airports(airport_code);
ANALYZE faa.d_airports;

-- 使用索引後的查詢
EXPLAIN ANALYZE
SELECT * FROM faa.d_airports WHERE airport_code = 'LAX';

-- ============================================
-- 事實表查詢範例
-- ============================================

-- 收集統計資訊
ANALYZE faa.otp_r;
ANALYZE faa.otp_c;

-- 統計總航班數
SELECT COUNT(*) AS total_flights FROM faa.otp_r;

-- 按航空公司統計航班數
SELECT a.AirlineName, COUNT(*) AS flight_count
FROM faa.otp_r o
JOIN faa.d_airlines a ON o.UniqueCarrier = a.UniqueCarrier
GROUP BY a.AirlineName
ORDER BY flight_count DESC;

-- 各航空公司的平均延遲時間
SELECT a.AirlineName,
       ROUND(AVG(o.ArrDelay)::NUMERIC, 1) AS avg_delay,
       COUNT(*) AS flights
FROM faa.otp_r o
JOIN faa.d_airlines a ON o.UniqueCarrier = a.UniqueCarrier
WHERE o.Cancelled = false
GROUP BY a.AirlineName
ORDER BY avg_delay DESC;

-- 各機場出發航班數
SELECT ap.Name AS airport_name,
       ap.City,
       COUNT(*) AS departures
FROM faa.otp_r o
JOIN faa.d_airports ap ON o.Origin = ap.airport_code
GROUP BY ap.Name, ap.City
ORDER BY departures DESC;

-- 按月統計取消率
SELECT DATE_TRUNC('month', FlightDate) AS month,
       COUNT(*) AS total,
       SUM(CASE WHEN Cancelled THEN 1 ELSE 0 END) AS cancelled,
       ROUND(100.0 * SUM(CASE WHEN Cancelled THEN 1 ELSE 0 END) / COUNT(*), 1) AS cancel_pct
FROM faa.otp_r
GROUP BY month
ORDER BY month;

-- 分區裁剪示範：只掃描 7 月分區
EXPLAIN
SELECT COUNT(*) FROM faa.otp_r
WHERE FlightDate = '2009-07-15';
