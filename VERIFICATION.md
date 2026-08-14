# 教程驗證報告（Podman 實測）

驗證日期：2026-08-14
驗證環境：macOS (Apple Silicon) + Podman，使用社群映像 `woblerr/cloudberry:2.1.0-incubating`
（Apache Cloudberry 2.1.0-incubating，PostgreSQL 14.4 核心，aarch64，單機雙 Segment）

## 驗證方式

1. 以 Podman 啟動單機 Cloudberry 叢集（見 `scripts/verify-podman.sh`）
2. 將 `scripts/` 複製進容器，以 `gpadmin` 執行 `run-all.sh`（`ON_ERROR_STOP=1`）
3. 額外實測六份 docs 中「未納入 scripts」的所有 SQL 片段
4. 檢查 README / docs 的外部連結與內部相對連結

## 結果總覽

| 項目 | 結果 |
|------|------|
| `run-all.sh` 五個腳本一次跑通 | ✅ 全部成功，無錯誤 |
| 資料筆數符合 docs/04 宣稱（185/185/10/10/5/13/11） | ✅ 完全一致 |
| 分區裁剪示範（17 個分區只掃 1 個） | ✅ 正確（GPORCA Dynamic Seq Scan） |
| docs 中 doc-only SQL 片段（索引、zstd 壓縮表、gp_dist_random、傾斜檢查等） | ✅ 全部可執行 |
| 外部連結（6 個） | ✅ 全部 HTTP 200 |
| 內部課程間連結（00→01→…→05） | ✅ 檔案齊全、連結正確 |
| `run-all.sh` 重複執行（冪等性） | ⚠️ 第二次執行在 `CREATE USER lily` 失敗 |

## 發現的問題

### 1. `run-all.sh` 不可重複執行（中）

`01-create-users.sql` 的 `CREATE USER lily`、`CREATE ROLE users` 與
`02-create-database.sql` 的 `CREATE DATABASE tutorial` 沒有存在性防護，
第二次執行即在第一步失敗（`ERROR: role "lily" already exists`）。

建議：改用 `DROP ... IF EXISTS` 前置清理，或在 psql 中用 `\gexec` 條件式建立。

### 2. docs/04 的 COPY「驗證匯出結果」會使資料翻倍（中）

```sql
COPY faa.d_airports TO '/tmp/airports_export.csv' ...;
COPY faa.d_airports FROM '/tmp/airports_export.csv' ...;  -- 直接匯回同一張表
```

實測後 `d_airports` 從 10 筆變成 20 筆，與同章節後面「預期結果 airports = 10」矛盾。
建議：匯回到一張暫存表驗證，或加上 `TRUNCATE` / 事後清理說明。

### 3. docs/05「查看表的大小」對分區表回傳 0 bytes（小）

`SELECT pg_size_pretty(pg_total_relation_size('faa.otp_r'))` 實測回傳 `0 bytes`——
Cloudberry 2.x 的分區表根表（relkind `p`)本身不佔儲存。
建議改為對分區加總，例如：

```sql
SELECT pg_size_pretty(SUM(pg_total_relation_size(inhrelid)))
FROM pg_inherits WHERE inhparent = 'faa.otp_r'::regclass;
```

### 4. docs/05 EXPLAIN 範例輸出與實際預設優化器不符（小）

文件範例顯示 `Optimizer: Postgres query optimizer` 與 `Append + Seq Scan on otp_r_1_prt_N`；
實測 Cloudberry 2.1.0 預設為 GPORCA，輸出為：

```
 Aggregate
   ->  Gather Motion 2:1  (slice1; segments: 2)
         ->  Dynamic Seq Scan on otp_r
               Number of partitions to scan: 1 (out of 17)
 Optimizer: GPORCA
```

分區裁剪結論不變（17 選 1 正確），但建議範例輸出改為 GPORCA 版本，或註明
`SET optimizer = off;` 才會出現 Postgres optimizer 的計畫。

### 5. docs/03「查看各表的儲存方式」查詢的小缺陷（小）

- `c.relkind = 'r'` 會排除分區表根表（relkind `p`），清單只列出葉分區
- `pg_tables t JOIN pg_class c ON t.tablename = c.relname` 未比對 schema，
  若其他 schema 有同名表會出現重複列

實測可執行且結果大致正確（heap vs `ao_column`），屬示範品質問題。

## 未驗證項目（環境限制）

- Bootcamp Sandbox 專屬內容：`/tmp/faa/` CSV 資料、gpfdist/gpload 實際載入
  （docs/04 已明確標註需 Bootcamp 環境，語法經人工比對官方文件無誤）
- `createuser --interactive`（互動式，無法自動化）
- pg_hba.conf 路徑宣稱（`/data0/database/master/gpseg-1/...` 為 Bootcamp 慣例路徑）

## 重現方式

```bash
bash scripts/verify-podman.sh
```
