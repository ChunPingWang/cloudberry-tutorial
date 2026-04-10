# 課程 1：建立使用者與角色

本課程將學習如何在 Apache Cloudberry 中管理資料庫存取權限。

## 角色概念

在 Cloudberry 中，角色（Role）是存取控制的基礎：

- 一個角色可以是**使用者**或**群組**
- 擁有 `LOGIN` 屬性的角色可以連線到資料庫（即「使用者」）
- 角色可以成為群組的成員，繼承群組的權限
- 系統初始只有一個超級使用者角色 `gpadmin`

## 建立使用者的三種方式

### 方式一：CREATE USER 命令

以 `gpadmin` 身份連線後執行：

```sql
-- CREATE USER 預設帶有 LOGIN 屬性
CREATE USER lily WITH PASSWORD 'changeme';
```

### 方式二：createuser 工具

從 Shell 命令列執行：

```bash
createuser --interactive lucy
# 系統會提示是否設為超級使用者，輸入 y 或 n
```

### 方式三：CREATE ROLE 命令

```sql
-- CREATE ROLE 預設「沒有」 LOGIN 屬性，適合建立群組
CREATE ROLE users;

-- 如果需要登入能力，明確指定
CREATE ROLE analyst WITH LOGIN PASSWORD 'changeme';
```

## 查看所有角色

```sql
-- 在 psql 中使用 \du 命令
\du
```

輸出範例：

```
                             List of roles
 Role name |                   Attributes                   | Member of
-----------+------------------------------------------------+-----------
 gpadmin   | Superuser, Create role, Create DB, ...         | {}
 lily      |                                                | {}
 lucy      | Superuser                                      | {}
```

## 管理群組成員

```sql
-- 將使用者加入群組
GRANT users TO lily, lucy;

-- 從群組移除使用者
REVOKE users FROM lucy;
```

## 設定存取認證

建立使用者後，需要修改 Coordinator 節點上的 `pg_hba.conf` 設定檔。

### 找到 pg_hba.conf 的位置

`pg_hba.conf` 位於 Coordinator 的資料目錄中，不同安裝方式路徑不同：

```sql
-- 在 psql 中查詢實際路徑
SHOW hba_file;
```

或者透過資料目錄推算：

```sql
-- 查看 Coordinator 的資料目錄
SHOW data_directory;
-- pg_hba.conf 就在該目錄下
```

常見路徑：
- Bootcamp Sandbox：`/data0/database/master/gpseg-1/pg_hba.conf`
- 原始碼 Demo 叢集：`~/cloudberry/gpAux/gpdemo/datadirs/qddir/demoDataDir-1/pg_hba.conf`

### 新增認證規則

```bash
# 取得 pg_hba.conf 路徑（替換為你的實際路徑）
HBA_FILE=$(psql -d postgres -t -c "SHOW hba_file;" | xargs)

# 新增認證規則
echo "local    gpadmin    lily    md5" >> "${HBA_FILE}"
echo "local    gpadmin    lucy    trust" >> "${HBA_FILE}"
```

### 認證方式說明

| 方式 | 說明 |
|------|------|
| `md5` | 需要輸入密碼（密碼以 MD5 雜湊傳輸） |
| `trust` | 無需密碼即可登入 |
| `reject` | 拒絕連線 |
| `scram-sha-256` | 更安全的密碼認證方式 |

### 重新載入設定

```bash
# 不需要重啟資料庫
gpstop -u
```

## 驗證登入

```bash
# 以 lily 身份登入（需要密碼）
psql -U lily -d postgres

# 以 lucy 身份登入（不需要密碼）
psql -U lucy -d postgres
```

## 常用角色管理命令

```sql
-- 修改密碼
ALTER USER lily WITH PASSWORD 'newpassword';

-- 授予建立資料庫權限
ALTER ROLE lily CREATEDB;

-- 撤銷超級使用者權限
ALTER ROLE lucy NOSUPERUSER;

-- 刪除角色
DROP ROLE IF EXISTS analyst;
```

## 下一步

使用者建立完成後，請繼續 [課程 2：建立與準備資料庫](02-create-and-prepare-database.md)。
