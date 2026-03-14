#!/usr/bin/env bash
set -euo pipefail

FILE="official/index.html"

required_tokens=(
  "<html lang=\"zh-CN\""
  "name=\"viewport\""
  "name=\"description\""
  "name=\"theme-color\""
  "href=\"favicon.ico\""
  "href=\"favicon.png\""
  "alt=\"主界面截图\""
  "id=\"download\""
)

for token in "${required_tokens[@]}"; do
  if ! grep -Fq -- "$token" "$FILE"; then
    echo "FAIL: missing SEO/A11y token -> $token"
    exit 1
  fi
done

if grep -Fq -- "assets/qrcode.png" "$FILE"; then
  echo "FAIL: demo qrcode asset should stay removed"
  exit 1
fi

echo "PASS: SEO/A11y contract satisfied"
