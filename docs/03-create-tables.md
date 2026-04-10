# 課程 3：建立資料表

本課程將學習如何在 Apache Cloudberry 中建立資料表，重點介紹 MPP 架構下的資料分佈策略。

## 資料分佈策略

在 MPP 架構中，資料分佈策略決定了資料如何分配到各個 Segment 節點。理想情況下，每個 Segment 擁有均等的資料量，執行查詢時承擔均等的工作量。

### 雜湊分佈（Hash Distribution）

```sql
-- 依照指定欄位的雜湊值分佈資料
CREATE TABLE faa.d_airports (
    AirportID    INTEGER,
    Name         TEXT,
    City         TEXT,
    Country      TEXT,
    airport_code TEXT,
    ICOA_code    TEXT,
    Latitude     FLOAT8,
    Longitude    FLOAT8,
    Altitude     FLOAT8,
    TimeZoneOffset FLOAT,
    DST_Flag     TEXT,
    TZ           TEXT
) DISTRIBUTED BY (airport_code);
```

**特點**：
- 雜湊函數根據分佈鍵決定每一行儲存在哪個 Segment
- 相同分佈鍵值的行存儲在同一個 Segment
- 如果分佈鍵是唯一的，資料會均勻分佈

### 隨機分佈（Random Distribution）

```sql
CREATE TABLE faa.log_table (
    log_time  TIMESTAMP,
    message   TEXT
) DISTRIBUTED RANDOMLY;
```

**特點**：
- 以輪詢（Round-Robin）方式將行分佈到各 Segment
- 不保證相同資料在同一 Segment
- 適用於沒有明確分佈鍵的場景

## 建立教程範例資料表

以下是航空資料教程所使用的完整資料表定義：

### 維度表（Dimension Tables）

```sql
-- 先清除已存在的表
DROP TABLE IF EXISTS faa.d_airports CASCADE;
DROP TABLE IF EXISTS faa.d_airlines CASCADE;
DROP TABLE IF EXISTS faa.d_wac CASCADE;
DROP TABLE IF EXISTS faa.d_cancellation_codes CASCADE;
DROP TABLE IF EXISTS faa.d_delay_groups CASCADE;
DROP TABLE IF EXISTS faa.d_distance_groups CASCADE;

-- 機場資訊表
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

-- 航空公司資訊表
CREATE TABLE faa.d_airlines (
    AirlineID     INTEGER,
    AirlineName   TEXT,
    UniqueCarrier TEXT
) DISTRIBUTED BY (AirlineID);

-- 世界區域代碼表
CREATE TABLE faa.d_wac (
    wac         SMALLINT,
    wac_name    TEXT
) DISTRIBUTED BY (wac);

-- 取消原因代碼表
CREATE TABLE faa.d_cancellation_codes (
    cancel_code TEXT,
    cancel_desc TEXT
) DISTRIBUTED BY (cancel_code);

-- 延遲分組表
CREATE TABLE faa.d_delay_groups (
    delay_group SMALLINT,
    delay_range TEXT
) DISTRIBUTED BY (delay_group);

-- 距離分組表
CREATE TABLE faa.d_distance_groups (
    distance_group SMALLINT,
    distance_range TEXT
) DISTRIBUTED BY (distance_group);
```

### 事實表（Fact Tables）

```sql
-- 行式儲存事實表
CREATE TABLE faa.otp_r (
    FlightDate      DATE,
    UniqueCarrier   TEXT,
    FlightNum       INTEGER,
    Origin          TEXT,
    Dest            TEXT,
    DepTime         SMALLINT,
    ArrTime         SMALLINT,
    ArrDelay        SMALLINT,
    DepDelay        SMALLINT,
    Cancelled       BOOLEAN,
    CancellationCode TEXT,
    Diverted        BOOLEAN,
    CarrierDelay    SMALLINT,
    WeatherDelay    SMALLINT,
    NASDelay        SMALLINT,
    SecurityDelay   SMALLINT,
    LateAircraftDelay SMALLINT
) DISTRIBUTED BY (UniqueCarrier, FlightNum)
PARTITION BY RANGE(FlightDate)
(
    START ('2009-06-01'::DATE) END ('2010-10-31'::DATE)
    EVERY (INTERVAL '1 month')
);

-- 列式儲存事實表（適合 OLAP 查詢）
CREATE TABLE faa.otp_c (LIKE faa.otp_r)
WITH (appendonly=true, orientation=column)
DISTRIBUTED BY (UniqueCarrier, FlightNum)
PARTITION BY RANGE(FlightDate)
(
    START ('2009-06-01'::DATE) END ('2010-10-31'::DATE)
    EVERY (INTERVAL '1 month')
);
```

## 儲存選項比較

| 選項 | 行式儲存（Heap） | 列式儲存（Column） | Append-Only |
|------|------------------|-------------------|-------------|
| 適用場景 | OLTP、頻繁更新 | OLAP、聚合查詢 | 大量寫入、少量更新 |
| 壓縮 | 不支援 | 支援 | 支援 |
| 更新/刪除 | 高效 | 較慢 | 不支援直接更新 |
| 查詢效能 | 適合寬表 | 適合少數欄位查詢 | 取決於方向 |

## 分區表（Partitioned Tables）

分區表將大型表分割為多個較小的子表，以提升查詢效能：

```sql
-- 按日期範圍分區
PARTITION BY RANGE(FlightDate)
(
    START ('2009-06-01'::DATE) END ('2010-10-31'::DATE)
    EVERY (INTERVAL '1 month')
);
```

**優點**：
- 查詢時只掃描相關分區（分區裁剪）
- 便於資料管理（如按月刪除歷史資料）
- 可為不同分區設定不同的儲存策略

## 驗證建立結果

```sql
-- 列出 faa schema 下的所有表
\dt faa.*

-- 查看特定表的結構（包含分佈策略）
\d faa.d_airports

-- 查看各表的儲存方式
SELECT tablename, CASE
    WHEN amname IS NULL THEN 'heap'
    ELSE amname
  END AS storage
FROM pg_tables t
LEFT JOIN pg_class c ON t.tablename = c.relname
LEFT JOIN pg_am a ON c.relam = a.oid
WHERE t.schemaname = 'faa' AND c.relkind = 'r'
ORDER BY tablename;
```

## 下一步

資料表建立完成後，請繼續 [課程 4：資料載入](04-data-loading.md)。
