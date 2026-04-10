#!/bin/bash
# ============================================
# Apache Cloudberry Tutorial - 一鍵執行所有腳本
# 用法: bash run-all.sh [-p PORT] [-h HOST]
# 範例: bash run-all.sh
#       bash run-all.sh -p 7000
#       bash run-all.sh -p 5432 -h localhost
# ============================================

set -e

PORT="${PGPORT:-5432}"
HOST="${PGHOST:-localhost}"

while getopts "p:h:" opt; do
    case "${opt}" in
        p) PORT=${OPTARG} ;;
        h) HOST=${OPTARG} ;;
        *) echo "Usage: $0 [-p PORT] [-h HOST]"; exit 1 ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PSQL="psql -h ${HOST} -p ${PORT} -v ON_ERROR_STOP=1"

echo "=========================================="
echo " Apache Cloudberry Tutorial"
echo " Host: ${HOST}  Port: ${PORT}"
echo "=========================================="

echo ""
echo "[1/5] 建立使用者與角色..."
${PSQL} -d postgres -f "${SCRIPT_DIR}/01-create-users.sql"
echo "      Done."

echo ""
echo "[2/5] 建立與準備資料庫..."
${PSQL} -d postgres -f "${SCRIPT_DIR}/02-create-database.sql"
echo "      Done."

echo ""
echo "[3/5] 建立資料表..."
${PSQL} -d postgres -f "${SCRIPT_DIR}/03-create-tables.sql"
echo "      Done."

echo ""
echo "[4/5] 載入範例資料..."
${PSQL} -d postgres -f "${SCRIPT_DIR}/04-load-sample-data.sql"
echo "      Done."

echo ""
echo "[5/5] 執行範例查詢..."
${PSQL} -d postgres -f "${SCRIPT_DIR}/05-sample-queries.sql"
echo "      Done."

echo ""
echo "=========================================="
echo " 所有腳本執行完成！"
echo " 連線方式: psql -h ${HOST} -p ${PORT} -d tutorial"
echo "=========================================="
