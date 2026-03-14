#!/usr/bin/env bash
set -euo pipefail

FILE="official/index.html"

if [[ ! -f "$FILE" ]]; then
  echo "FAIL: missing $FILE"
  exit 1
fi

required_tokens=(
  "<title>WhatsApp 翻译助手"
  "id=\"hero\""
  "id=\"highlights\""
  "id=\"languages\""
  "id=\"screenshots\""
  "id=\"download\""
  "id=\"footer\""
  "WhatsApp 翻译助手"
  "支持 33 种语言"
  "中文"
  "英语"
  "阿拉伯语"
  "Windows 下载"
  "macOS 下载"
  "Android 下载"
  "iOS 下载"
)

for token in "${required_tokens[@]}"; do
  if ! grep -Fq "$token" "$FILE"; then
    echo "FAIL: missing token -> $token"
    exit 1
  fi
done

if grep -Fq -- ">立即体验<" "$FILE"; then
  echo "FAIL: button text '立即体验' should be removed"
  exit 1
fi

echo "PASS: structure contract satisfied"
