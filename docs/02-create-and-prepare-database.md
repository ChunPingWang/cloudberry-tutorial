# 課程 2：建立與準備資料庫

本課程將學習如何建立資料庫、設定 Schema 及管理使用者權限。

## 建立資料庫

### 方式一：使用 createdb 工具

```bash
# 先確認資料庫不存在
dropdb tutorial 2>/dev/null

# 建立資料庫
createdb tutorial

# 驗證建立結果
psql -l
```

### 方式二：使用 SQL 命令

```sql
-- 連線到 postgres 資料庫
psql -d postgres

-- 建立新資料庫
CREATE DATABASE tutorial;

-- 查看所有資料庫
\l
```

## 設定存取認證

在 `pg_hba.conf` 中為新資料庫新增認證規則：

```bash
echo "local    tutorial    lily    md5" >> \
  /data0/database/master/gpseg-1/pg_hba.conf

# 重新載入設定
gpstop -u
```

## 授予使用者權限

```sql
-- 以 gpadmin 連線到 tutorial 資料庫
psql -d tutorial

-- 授予 lily 完整權限
GRANT ALL PRIVILEGES ON DATABASE tutorial TO lily;
```

## 建立 Schema

Schema 是資料庫物件的命名空間容器，用於組織和隔離資料表、視圖等物件。

```sql
-- 以 lily 連線到 tutorial 資料庫
psql -U lily -d tutorial

-- 建立 faa schema（航空資料範例）
CREATE SCHEMA faa;
```

## 設定搜尋路徑

搜尋路徑決定了物件解析的順序和預設建立位置：

```sql
-- 設定當前 Session 的搜尋路徑
SET SEARCH_PATH TO faa, public, pg_catalog, gp_toolkit;

-- 持久化設定（綁定到角色，跨 Session 生效）
ALTER ROLE lily SET search_path TO faa, public, pg_catalog, gp_toolkit;
```

### 搜尋路徑說明

| Schema | 說明 |
|--------|------|
| `faa` | 使用者自訂 Schema，用於存放教程資料表 |
| `public` | 預設公共 Schema |
| `pg_catalog` | 系統目錄表 |
| `gp_toolkit` | Cloudberry 管理工具表和視圖 |

## 驗證設定

```sql
-- 查看當前搜尋路徑
SHOW search_path;

-- 查看當前使用者
SELECT current_user;

-- 查看當前資料庫
SELECT current_database();

-- 列出所有 Schema
\dn
```

## 下一步

資料庫準備完成後，請繼續 [課程 3：建立資料表](03-create-tables.md)。
