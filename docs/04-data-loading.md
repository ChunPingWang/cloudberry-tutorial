# 課程 4：資料載入

本課程將介紹三種在 Apache Cloudberry 中載入資料的方式，從簡單的 INSERT 到高效能的並行載入。

## 方式一：INSERT 語句

最簡單的資料載入方式，適合小量資料。

```sql
-- 插入取消原因代碼
INSERT INTO faa.d_cancellation_codes
VALUES
    ('A', 'Carrier'),
    ('B', 'Weather'),
    ('C', 'NAS'),
    ('D', 'Security'),
    ('', 'none');

-- 驗證
SELECT * FROM faa.d_cancellation_codes;
```

```
 cancel_code | cancel_desc
-------------+-------------
 A           | Carrier
 B           | Weather
 C           | NAS
 D           | Security
             | none
(5 rows)
```

> **注意**：INSERT 不適合大量資料載入，因為載入效率較低，且不是並行操作。

## 方式二：COPY 命令

比 INSERT 更快的批次載入方式，從文字檔（CSV/TSV）讀取資料。

> **注意**：以下 COPY 範例需要在 [Cloudberry Bootcamp Sandbox](https://github.com/apache/cloudberry-bootcamp) 環境中執行，該環境已預先準備好 `/tmp/faa/` 目錄下的 CSV 資料檔案。如果您使用自行建構的環境，可以先跳過此節，閱讀語法說明即可。

### 基本語法

```sql
-- 從 CSV 檔案載入
COPY faa.d_airlines
FROM '/tmp/faa/L_AIRLINE_ID.csv'
WITH (FORMAT csv, HEADER true);

-- 從 TSV 檔案載入（Tab 分隔）
COPY faa.d_airports
FROM '/tmp/faa/L_AIRPORT_ID.csv'
WITH (FORMAT csv, HEADER true, DELIMITER E'\t');
```

### 使用腳本批次載入

```sql
-- 在 psql 中執行 SQL 腳本（僅限 Bootcamp Sandbox 環境）
\i /tmp/faa/copy_into_airlines.sql
\i /tmp/faa/copy_into_airports.sql
\i /tmp/faa/copy_into_delay_groups.sql
\i /tmp/faa/copy_into_distance_groups.sql
\i /tmp/faa/copy_into_wac.sql
```

預期輸出：

```
COPY 1514
COPY 1697
COPY 15
COPY 11
COPY 342
```

### 匯出資料

不需要外部檔案，可用已載入的資料練習匯出：

```sql
-- 匯出到 CSV
COPY faa.d_airports
TO '/tmp/airports_export.csv'
WITH (FORMAT csv, HEADER true);

-- 驗證匯出結果
COPY faa.d_airports FROM '/tmp/airports_export.csv'
WITH (FORMAT csv, HEADER true);
```

> **限制**：COPY 要求外部檔案可被 Coordinator 節點存取，且不是並行操作。

## 方式三：gpfdist 並行載入（推薦大量資料）

`gpfdist` 是 Cloudberry 的檔案伺服器工具，可實現跨所有 Segment 的並行資料載入，效能最佳。

> **注意**：以下 gpfdist 範例需要在 [Cloudberry Bootcamp Sandbox](https://github.com/apache/cloudberry-bootcamp) 環境中執行，該環境已預先準備好 `/tmp/faa/otp*.gz` 資料檔案。如果您使用自行建構的環境，建議先閱讀了解原理，再使用自己的資料練習。

### 步驟 1：啟動 gpfdist

```bash
# 在資料檔案所在目錄啟動 gpfdist
gpfdist -d /tmp/faa -p 8081 > /tmp/gpfdist.log 2>&1 &

# 驗證是否成功啟動
ps -ef | grep gpfdist
```

### 步驟 2：建立外部表

```sql
-- 建立可讀外部表（指向 gpfdist）
CREATE EXTERNAL TABLE faa.ext_load_otp (
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
) LOCATION ('gpfdist://cdw:8081/otp*.gz')
FORMAT 'CSV' (HEADER)
LOG ERRORS SEGMENT REJECT LIMIT 50000 ROWS;
```

### 步驟 3：從外部表載入資料

```sql
-- 建立載入暫存表
CREATE TABLE faa.faa_otp_load (LIKE faa.ext_load_otp)
DISTRIBUTED BY (UniqueCarrier, FlightNum);

-- 從外部表並行載入
INSERT INTO faa.faa_otp_load SELECT * FROM faa.ext_load_otp;
```

### 步驟 4：載入到事實表

```sql
-- 載入到行式事實表
INSERT INTO faa.otp_r SELECT * FROM faa.faa_otp_load;

-- 載入到列式事實表
INSERT INTO faa.otp_c SELECT * FROM faa.faa_otp_load;
```

## 使用 gpload（YAML 配置）

`gpload` 是 `gpfdist` 的封裝工具，使用 YAML 檔案定義載入任務。

### 建立 gpload.yaml

```yaml
---
VERSION: 1.0.0.1
DATABASE: tutorial
USER: lily
HOST: cdw
PORT: 5432
GPLOAD:
  INPUT:
    - SOURCE:
        LOCAL_HOSTNAME:
          - cdw
        PORT: 8081
        FILE:
          - /tmp/faa/otp*.gz
    - FORMAT: csv
    - HEADER: true
    - ERROR_LIMIT: 50000
  OUTPUT:
    - TABLE: faa.faa_otp_load
    - MODE: INSERT
```

### 執行 gpload

```bash
gpload -f gpload.yaml -l gpload.log
```

## 三種載入方式比較

| 特性 | INSERT | COPY | gpfdist/gpload |
|------|--------|------|----------------|
| 並行度 | 無 | 無 | 所有 Segment 並行 |
| 適用資料量 | 少量（< 1萬行） | 中等（< 100萬行） | 大量（百萬行以上） |
| 使用難度 | 簡單 | 中等 | 較複雜 |
| 壓縮支援 | 無 | 無 | 支援（gzip） |
| 錯誤處理 | 逐行失敗 | 整批失敗 | 可設定容錯限制 |

## 驗證載入結果

```sql
-- 檢查各表的資料量
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
```

使用本教程的 INSERT 腳本，預期結果：

```
     table_name     | row_count
--------------------+-----------
 airports           |        10
 airlines           |        10
 cancellation_codes |         5
 delay_groups       |        13
 distance_groups    |        11
 otp_r (flights)    |       185
 otp_c (flights)    |       185
```

如果您額外使用了 COPY 或 gpfdist 載入 Bootcamp 的完整資料集，`otp_r` 和 `otp_c` 的數量會更多。

## 下一步

資料載入完成後，請繼續 [課程 5：查詢與效能調優](05-queries-and-performance.md)。
