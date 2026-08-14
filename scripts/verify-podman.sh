#!/bin/bash
# ============================================
# 使用 Podman 驗證本教程的所有 SQL 腳本
# 需求：podman（machine 已啟動）
# 用法：bash scripts/verify-podman.sh
# ============================================

set -euo pipefail

IMAGE="docker.io/woblerr/cloudberry:2.1.0-incubating"
NAME="cbdb-verify"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[1/4] 啟動 Cloudberry 容器（${IMAGE}）..."
podman rm -f "${NAME}" >/dev/null 2>&1 || true
podman run -d --name "${NAME}" -h cdw \
    --shm-size=1gb \
    --cap-add=NET_RAW \
    -e CLOUDBERRY_PASSWORD=gparray \
    "${IMAGE}" >/dev/null

echo "[2/4] 等待資料庫初始化（首次約 1-2 分鐘）..."
for _ in $(seq 1 60); do
    if podman exec "${NAME}" su - gpadmin -c \
        "psql -d postgres -tAc 'SELECT 1'" 2>/dev/null | grep -q 1; then
        break
    fi
    sleep 5
done
podman exec "${NAME}" su - gpadmin -c \
    "psql -d postgres -tAc 'SELECT version()'"

echo "[3/4] 複製教程腳本進容器..."
podman cp "${SCRIPT_DIR}" "${NAME}:/home/gpadmin/scripts"
podman exec "${NAME}" chown -R gpadmin:gpadmin /home/gpadmin/scripts

echo "[4/4] 執行 run-all.sh..."
podman exec "${NAME}" su - gpadmin -c "bash /home/gpadmin/scripts/run-all.sh"

echo ""
echo "驗證完成。容器保留供檢查，清理請執行：podman rm -f ${NAME}"
