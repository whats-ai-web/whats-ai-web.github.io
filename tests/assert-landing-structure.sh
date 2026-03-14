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
  "id=\"agency\""
  "id=\"screenshots\""
  "id=\"download\""
  "id=\"footer\""
  "WhatsApp 翻译助手"
  "支持 33 种语言"
  "代理分销计划"
  "最高 40% 返佣"
  "加微信咨询代理"
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

agency_line=$(grep -n 'id="agency"' "$FILE" | head -n1 | cut -d: -f1)
screenshots_line=$(grep -n 'id="screenshots"' "$FILE" | head -n1 | cut -d: -f1)
if [[ -z "$agency_line" || -z "$screenshots_line" || "$agency_line" -ge "$screenshots_line" ]]; then
  echo "FAIL: #agency section must be before #screenshots"
  exit 1
fi

if grep -Fq -- ">立即体验<" "$FILE"; then
  echo "FAIL: button text '立即体验' should be removed"
  exit 1
fi

echo "PASS: structure contract satisfied"
