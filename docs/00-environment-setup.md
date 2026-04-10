# 課程 0：環境準備

本課程將指導您使用 Docker Sandbox 快速搭建 Apache Cloudberry 環境。

> **注意**：Docker Sandbox 僅適用於測試和開發，請勿用於生產環境。

## 前置需求

- 已安裝 Docker（參考 [Get Started with Docker](https://docs.docker.com/get-docker/)）
- Git
- SSH
- 至少 10 GB 可用磁碟空間
- 穩定的網路連線

## 方式一：Docker Sandbox（推薦新手使用）

Docker Sandbox 基於 Rocky Linux 9.4，Coordinator 和 Segment 均運行在單一容器中。

### 步驟 1：克隆 Bootcamp 儲存庫

```bash
git clone https://github.com/apache/cloudberry-bootcamp.git
cd cloudberry-bootcamp
```

### 步驟 2：啟動 Docker 容器

```bash
# 可能需要 sudo 權限
./run.sh
```

此腳本會自動下載映像、建立容器，並啟動 Cloudberry 資料庫。

### 步驟 3：連線到資料庫

```bash
# 進入 Docker 容器
docker exec -it $(docker ps -q) /bin/bash

# 切換到 gpadmin 使用者
su - gpadmin

# 使用 psql 連線
psql -d postgres
```

### 常用管理命令

```bash
# 啟動資料庫（容器重新啟動後需要手動執行）
gpstart -a

# 停止資料庫
gpstop -a

# 重新載入設定檔（不需要停止資料庫）
gpstop -u

# 查看叢集狀態
gpstate
```

## 方式二：使用開發映像從原始碼建構

適合需要修改原始碼或深入了解系統內部的開發者。

### 步驟 1：啟動開發容器

可選擇的基礎映像：

```bash
# Rocky Linux 9（推薦）
docker run --name cbdb-dev -it --rm -h cdw \
  --shm-size=2gb \
  apache/incubator-cloudberry:cbdb-build-rocky9-latest

# Rocky Linux 8
docker run --name cbdb-dev -it --rm -h cdw \
  --shm-size=2gb \
  apache/incubator-cloudberry:cbdb-build-rocky8-latest

# Ubuntu 22.04
docker run --name cbdb-dev -it --rm -h cdw \
  --shm-size=2gb \
  apache/incubator-cloudberry:cbdb-build-ubuntu22.04-latest
```

開發容器已預先配置：
- `gpadmin` 使用者及所需權限
- 環境變數和路徑
- 系統資源限制
- 所有建構依賴

### 步驟 2：克隆並建構

```bash
# 在容器內以 gpadmin 身份執行
su - gpadmin

# 克隆原始碼
git clone --recurse-submodules --branch REL_2_STABLE \
  https://github.com/apache/cloudberry.git

cd cloudberry

# 配置與建構
./configure --with-perl --with-python --with-libxml \
  --with-gssapi --prefix=/usr/local/cloudberry-db
make -j$(nproc)
make install

# 建立並啟動 Demo 叢集
source /usr/local/cloudberry-db/cloudberry-env.sh
make create-demo-cluster

# 連線到資料庫
psql -p 7000 postgres
```

## 驗證安裝

連線到資料庫後，執行以下命令驗證安裝是否成功：

```sql
-- 查看版本資訊
SELECT version();

-- 查看 Segment 配置
SELECT * FROM gp_segment_configuration;

-- 簡單測試
SELECT 1 AS test;
```

預期輸出應顯示 Cloudberry 的版本資訊以及 Segment 節點的配置。

## 下一步

環境搭建完成後，請繼續 [課程 1：建立使用者與角色](01-create-users-and-roles.md)。
