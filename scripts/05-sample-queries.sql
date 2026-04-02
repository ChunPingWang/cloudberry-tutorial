-- ============================================
-- Apache Cloudberry Tutorial
-- Script 5: 範例查詢與效能分析
-- ============================================

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
