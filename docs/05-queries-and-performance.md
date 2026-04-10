# 課程 5：查詢與效能調優

本課程將學習如何在 Apache Cloudberry 中執行查詢，並使用 EXPLAIN、索引和儲存優化來提升效能。

## 基礎準備

在開始查詢前，先收集統計資訊以幫助查詢優化器制定最佳執行計畫：

```sql
-- 收集各表的統計資訊
ANALYZE faa.d_airports;
ANALYZE faa.d_airlines;
ANALYZE faa.otp_r;
ANALYZE faa.otp_c;

-- 開啟查詢計時
\timing on
```

### 關於 VACUUM 和 ANALYZE

- **VACUUM**：清除已刪除行的舊版本，釋放可重用的空間
- **ANALYZE**：產生資料分佈的統計資訊（柱狀圖），供查詢優化器使用

```sql
-- 清理並分析
VACUUM ANALYZE faa.otp_r;
```

## 基本查詢範例

### 聚合查詢

```sql
-- 統計總航班數
SELECT COUNT(*) FROM faa.otp_r;

-- 按航空公司統計航班數
SELECT UniqueCarrier, COUNT(*) AS flight_count
FROM faa.otp_r
GROUP BY UniqueCarrier
ORDER BY flight_count DESC
LIMIT 10;

-- 統計延遲航班
SELECT COUNT(*) AS delayed_flights
FROM faa.otp_r
WHERE ArrDelay > 0;
```

### 關聯查詢

```sql
-- 查詢各航空公司的平均延遲時間
SELECT a.AirlineName, AVG(o.ArrDelay) AS avg_delay
FROM faa.otp_r o
JOIN faa.d_airlines a ON o.UniqueCarrier = a.UniqueCarrier
GROUP BY a.AirlineName
ORDER BY avg_delay DESC
LIMIT 10;

-- 查詢各機場的航班數
SELECT ap.Name AS airport_name, 
       ap.City,
       COUNT(*) AS departures
FROM faa.otp_r o
JOIN faa.d_airports ap ON o.Origin = ap.airport_code
GROUP BY ap.Name, ap.City
ORDER BY departures DESC
LIMIT 10;
```

### 日期範圍查詢（利用分區裁剪）

```sql
-- 查詢特定月份的航班
SELECT COUNT(*), AVG(ArrDelay) AS avg_delay
FROM faa.otp_r
WHERE FlightDate BETWEEN '2009-06-01' AND '2009-06-30';

-- 按月統計取消率
SELECT DATE_TRUNC('month', FlightDate) AS month,
       COUNT(*) AS total_flights,
       SUM(CASE WHEN Cancelled THEN 1 ELSE 0 END) AS cancelled,
       ROUND(100.0 * SUM(CASE WHEN Cancelled THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancel_rate
FROM faa.otp_r
GROUP BY month
ORDER BY month;
```

## 使用 EXPLAIN 分析查詢

`EXPLAIN` 顯示查詢優化器選擇的執行計畫，幫助理解查詢如何執行。

### 基本 EXPLAIN

```sql
EXPLAIN
SELECT COUNT(*) FROM faa.otp_r WHERE ArrDelay > 60;
```

輸出範例（分區表會顯示每個分區的掃描計畫）：

```
                                      QUERY PLAN
--------------------------------------------------------------------------------------
 Aggregate  (cost=968.25..968.26 rows=1 width=8)
   ->  Append  (cost=0.00..954.21 rows=5617 width=0)
         ->  Seq Scan on otp_r_1_prt_1 otp_r_1  (cost=0.00..70.12 rows=124 width=0)
               Filter: (arrdelay > 60)
         ->  Seq Scan on otp_r_1_prt_2 otp_r_2  (cost=0.00..70.12 rows=77 width=0)
               Filter: (arrdelay > 60)
         ...（其餘分區省略）
 Optimizer: Postgres query optimizer
```

重點觀察：
- `Append`：表示掃描多個分區後合併結果
- `Seq Scan on otp_r_1_prt_N`：對各月份分區進行順序掃描
- `Filter`：在每個分區上套用篩選條件

### EXPLAIN ANALYZE（實際執行）

```sql
EXPLAIN ANALYZE
SELECT COUNT(*) FROM faa.otp_r WHERE ArrDelay > 60;
```

`EXPLAIN ANALYZE` 會實際執行查詢，顯示真實的時間和行數（`actual time`、`rows`），而非僅估計值。還會顯示 `Rows Removed by Filter`，幫助判斷篩選條件的選擇性。

### 關鍵執行計畫節點

| 節點類型 | 說明 |
|----------|------|
| `Seq Scan` | 順序掃描整個表 |
| `Index Scan` | 使用索引掃描 |
| `Hash Join` | 雜湊關聯 |
| `Merge Join` | 合併關聯 |
| `Gather Motion` | 將 Segment 結果收集到 Coordinator |
| `Redistribute Motion` | 在 Segment 之間重新分佈資料 |
| `Broadcast Motion` | 將資料廣播到所有 Segment |
| `Partition Selector` | 分區裁剪 |

## 索引優化

索引可大幅提升特定查詢的效能，特別是高選擇性的單行查詢。

### 建立索引

```sql
-- 建立 B-tree 索引
CREATE INDEX idx_otp_r_origin ON faa.otp_r(Origin);
CREATE INDEX idx_otp_r_flightdate ON faa.otp_r(FlightDate);
```

### 索引效能比較

```sql
-- 無索引時的查詢（Seq Scan）
EXPLAIN ANALYZE
SELECT * FROM faa.otp_r WHERE Origin = 'LAX' AND FlightDate = '2009-07-01';

-- 建立複合索引
CREATE INDEX idx_otp_r_origin_date ON faa.otp_r(Origin, FlightDate);

-- 有索引後的查詢（Index Scan）
EXPLAIN ANALYZE
SELECT * FROM faa.otp_r WHERE Origin = 'LAX' AND FlightDate = '2009-07-01';
```

### 索引使用建議

- 適用於高選擇性查詢（返回少量行的查詢）
- 索引會佔用大量空間，並在資料載入時消耗 CPU
- 不適合全表掃描或返回大量行的查詢
- 建立索引後執行 `ANALYZE` 更新統計資訊

## 行式 vs 列式儲存效能比較

```sql
-- 行式表查詢
\timing on
SELECT UniqueCarrier, AVG(ArrDelay) AS avg_delay
FROM faa.otp_r
GROUP BY UniqueCarrier
ORDER BY avg_delay DESC;

-- 列式表相同查詢
SELECT UniqueCarrier, AVG(ArrDelay) AS avg_delay
FROM faa.otp_c
GROUP BY UniqueCarrier
ORDER BY avg_delay DESC;
```

列式儲存通常在以下場景更快：
- 只需要讀取少數幾個欄位
- 聚合查詢（SUM、AVG、COUNT）
- 資料有大量重複值（壓縮效果好）

## 效能調優技巧

### 1. 選擇正確的分佈鍵

```sql
-- 查看資料分佈是否均勻
SELECT gp_segment_id, COUNT(*)
FROM faa.otp_r
GROUP BY gp_segment_id
ORDER BY gp_segment_id;
```

好的分佈鍵應該：
- 資料值分佈均勻
- 經常出現在 JOIN 條件中
- 不常更新

### 2. 利用分區裁剪

```sql
-- 帶分區條件的查詢（只掃描相關分區）
EXPLAIN
SELECT COUNT(*) FROM faa.otp_r
WHERE FlightDate = '2009-07-15';
```

輸出：

```
                                QUERY PLAN
--------------------------------------------------------------------------
 Aggregate  (cost=70.13..70.14 rows=1 width=8)
   ->  Seq Scan on otp_r_1_prt_2 otp_r  (cost=0.00..70.12 rows=1 width=0)
         Filter: (flightdate = '2009-07-15'::date)
 Optimizer: Postgres query optimizer
```

注意：查詢優化器只掃描了 `otp_r_1_prt_2`（7 月分區），而非所有 17 個分區。這就是分區裁剪的效果 — 大幅減少不必要的 I/O。

### 3. 適當使用壓縮

```sql
-- 建立帶壓縮的列式表
CREATE TABLE faa.otp_compressed (LIKE faa.otp_r)
WITH (
    appendonly=true,
    orientation=column,
    compresstype=zstd,
    compresslevel=5
)
DISTRIBUTED BY (UniqueCarrier, FlightNum);
```

### 4. 避免資料傾斜

```sql
-- 檢查資料傾斜
SELECT gp_segment_id,
       COUNT(*) AS row_count,
       pg_size_pretty(SUM(pg_column_size(otp_r.*))) AS segment_size
FROM faa.otp_r
GROUP BY gp_segment_id
ORDER BY row_count DESC;
```

## 常用效能診斷查詢

```sql
-- 查看正在執行的查詢
SELECT pid, usename, query, state, query_start
FROM pg_stat_activity
WHERE state = 'active';

-- 查看表的大小
SELECT pg_size_pretty(pg_total_relation_size('faa.otp_r')) AS table_size;

-- 查看各 Segment 的資料大小分佈
SELECT gp_segment_id, pg_size_pretty(SUM(pg_relation_size(oid))) AS segment_size
FROM gp_dist_random('pg_class')
WHERE relnamespace = 'faa'::regnamespace
GROUP BY gp_segment_id
ORDER BY gp_segment_id;
```

## 總結

透過本教程，您已學會：
1. 搭建 Apache Cloudberry 環境
2. 管理使用者和角色
3. 建立和準備資料庫
4. 設計資料表和分佈策略
5. 使用多種方式載入資料
6. 執行查詢並進行效能調優

更多進階主題請參考 [Apache Cloudberry 官方文件](https://cloudberry.apache.org/docs/)。
