# Apache Cloudberry 教程

本教程將帶您從零開始學習 [Apache Cloudberry (Incubating)](https://cloudberry.apache.org/) —— 一個先進且成熟的開源 MPP（大規模並行處理）資料庫，適用於資料倉儲、大規模分析和 AI/ML 工作負載。

## 什麼是 Apache Cloudberry?

Apache Cloudberry 源自 Greenplum Database 的開源版本，由 Greenplum 原始開發者創建，採用更新的 PostgreSQL 14 核心，並具備更先進的企業級功能。它是 Greenplum Database 的開源替代方案。

### 核心特性

- **MPP 架構**：透過多個 Segment 節點並行處理查詢，實現水平擴展
- **完整 SQL 支援**：100% ANSI SQL 相容（SQL-92、SQL-99、SQL-2003 及 OLAP 擴展）
- **PostgreSQL 相容**：基於 PostgreSQL 14.4 核心，相容大部分 PostgreSQL 元件和擴展
- **高效能資料載入**：支援 gpfdist 並行載入，每分鐘可處理數千萬筆資料
- **PAX 儲存格式**：結合行式和列式儲存的優點，適合 OLAP 工作負載
- **PostGIS 支援**：增強的地理空間資料處理能力
- **PXF 外部資料存取**：透過外部表實現對多種資料源的高效並行存取

## 架構概覽

```
                    ┌─────────────────────┐
                    │   Coordinator Node  │
                    │  (Query Dispatcher) │
                    └─────────┬───────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
    ┌─────────▼─────┐ ┌──────▼────────┐ ┌────▼───────────┐
    │  Segment 1    │ │  Segment 2    │ │  Segment N     │
    │ (Query        │ │ (Query        │ │ (Query         │
    │  Executor)    │ │  Executor)    │ │  Executor)     │
    └───────────────┘ └───────────────┘ └────────────────┘
```

- **Coordinator Node（協調節點）**：接收客戶端連線、解析和優化查詢、分派執行計畫到各 Segment
- **Segment Node（資料節點）**：執行分派的查詢計畫、儲存和管理本地資料分區
- **Interconnect（互連層）**：Segment 之間的高速資料傳輸層

## 教程目錄

| 課程 | 主題 | 說明 |
|------|------|------|
| [課程 0](docs/00-environment-setup.md) | 環境準備 | 使用 Docker Sandbox 快速搭建環境 |
| [課程 1](docs/01-create-users-and-roles.md) | 建立使用者與角色 | 角色管理與存取控制 |
| [課程 2](docs/02-create-and-prepare-database.md) | 建立與準備資料庫 | 資料庫建立、Schema 管理、權限設定 |
| [課程 3](docs/03-create-tables.md) | 建立資料表 | 資料表設計與分佈策略 |
| [課程 4](docs/04-data-loading.md) | 資料載入 | INSERT、COPY、gpfdist 三種載入方式 |
| [課程 5](docs/05-queries-and-performance.md) | 查詢與效能調優 | SQL 查詢、EXPLAIN 分析、索引與優化 |

## 快速開始

```bash
# 1. 安裝 Docker（如果尚未安裝）
# 請參考 https://docs.docker.com/get-docker/

# 2. 克隆 Cloudberry Bootcamp
git clone https://github.com/apache/cloudberry-bootcamp.git
cd cloudberry-bootcamp

# 3. 啟動 Docker Sandbox
./run.sh

# 4. 連線到資料庫
docker exec -it $(docker ps -q) /bin/bash
su - gpadmin
psql -d postgres
```

## 參考資源

- [Apache Cloudberry 官方網站](https://cloudberry.apache.org/)
- [Apache Cloudberry 官方文件](https://cloudberry.apache.org/docs/)
- [Apache Cloudberry GitHub](https://github.com/apache/cloudberry)
- [Cloudberry Bootcamp](https://github.com/apache/cloudberry-bootcamp)
- [Docker Hub 映像](https://hub.docker.com/r/apache/incubator-cloudberry)
