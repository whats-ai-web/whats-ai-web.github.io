#!/usr/bin/env bash
set -euo pipefail

FILE="official/index.html"

required_assets=(
  "assets/page01.png"
  "assets/page02.jpg"
  "assets/page03.jpg"
  "assets/login.png"
  "assets/add_account.png"
  "assets/setting.png"
  "assets/wechat_qrcode.png"
)

for asset in "${required_assets[@]}"; do
  if ! grep -Fq -- "$asset" "$FILE"; then
    echo "FAIL: missing asset reference -> $asset"
    exit 1
  fi
done

required_tokens=(
  "演示流程截图"
  "id=\"screenshots\""
  "id=\"contact\""
  "添加联系方式"
  "id=\"lightbox-modal\""
  "id=\"lightbox-image\""
  "id=\"lightbox-close\""
  "data-lightbox"
)

for token in "${required_tokens[@]}"; do
  if ! grep -Fq -- "$token" "$FILE"; then
    echo "FAIL: missing screenshot token -> $token"
    exit 1
  fi
done

if grep -Fq -- "assets/qrcode.png" "$FILE"; then
  echo "FAIL: demo qrcode asset should stay removed"
  exit 1
fi

echo "PASS: screenshot asset contract satisfied"
