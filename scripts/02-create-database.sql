-- ============================================
-- Apache Cloudberry Tutorial
-- Script 2: 建立與準備資料庫
-- ============================================

-- 建立教程資料庫
CREATE DATABASE tutorial;

-- 授予權限
GRANT ALL PRIVILEGES ON DATABASE tutorial TO lily;

-- 以下命令需要連線到 tutorial 資料庫後執行：
-- psql -U lily -d tutorial

-- 建立 Schema
CREATE SCHEMA faa;

-- 設定搜尋路徑
ALTER ROLE lily SET search_path TO faa, public, pg_catalog, gp_toolkit;
