-- ============================================
-- Apache Cloudberry Tutorial
-- Script 1: 建立使用者與角色
-- ============================================

-- 建立使用者（帶 LOGIN 屬性）
CREATE USER lily WITH PASSWORD 'changeme';

-- 建立群組角色（不帶 LOGIN 屬性）
CREATE ROLE users;

-- 將使用者加入群組
GRANT users TO lily;

-- 驗證
\du
