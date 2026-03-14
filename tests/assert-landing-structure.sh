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
  "id=\"trust\""
  "id=\"scenarios\""
  "id=\"onboarding\""
  "id=\"languages\""
  "id=\"pricing\""
  "id=\"security\""
  "id=\"agency\""
  "id=\"screenshots\""
  "id=\"download\""
  "id=\"faq\""
  "id=\"footer\""
  "WhatsApp 翻译助手"
  "信任背书"
  "核心使用场景"
  "3步快速上手"
  "免费试用与定价方案"
  "安全与合规"
  "常见问题"
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

trust_line=$(grep -n 'id="trust"' "$FILE" | head -n1 | cut -d: -f1)
onboarding_line=$(grep -n 'id="onboarding"' "$FILE" | head -n1 | cut -d: -f1)
languages_line=$(grep -n 'id="languages"' "$FILE" | head -n1 | cut -d: -f1)
if [[ -z "$trust_line" || -z "$onboarding_line" || -z "$languages_line" || "$trust_line" -ge "$onboarding_line" || "$onboarding_line" -ge "$languages_line" ]]; then
  echo "FAIL: expected section order #trust -> #onboarding -> #languages"
  exit 1
fi

faq_line=$(grep -n 'id="faq"' "$FILE" | head -n1 | cut -d: -f1)
footer_line=$(grep -n 'id="footer"' "$FILE" | head -n1 | cut -d: -f1)
if [[ -z "$faq_line" || -z "$footer_line" || "$faq_line" -ge "$footer_line" ]]; then
  echo "FAIL: #faq section must be before #footer"
  exit 1
fi

if grep -Fq -- ">立即体验<" "$FILE"; then
  echo "FAIL: button text '立即体验' should be removed"
  exit 1
fi

echo "PASS: structure contract satisfied"
