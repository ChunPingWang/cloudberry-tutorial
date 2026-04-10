-- ============================================
-- Apache Cloudberry Tutorial
-- Script 2: 建立與準備資料庫
-- ============================================

-- 建立教程資料庫
CREATE DATABASE tutorial;

-- 授予權限
GRANT ALL PRIVILEGES ON DATABASE tutorial TO lily;

-- 切換到 tutorial 資料庫
\c tutorial

-- 建立 Schema
CREATE SCHEMA faa;

-- 設定搜尋路徑
ALTER ROLE lily SET search_path TO faa, public, pg_catalog, gp_toolkit;
