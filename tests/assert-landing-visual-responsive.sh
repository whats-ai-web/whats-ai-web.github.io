#!/usr/bin/env bash
set -euo pipefail

FILE="official/index.html"

required_tokens=(
  "<script src=\"https://cdn.tailwindcss.com\"></script>"
  "--brand-orange"
  "--brand-cyan"
  "sm:grid-cols-2"
  "lg:grid-cols-[1.2fr_0.8fr]"
  "lg:grid-cols-3"
  "md:text-6xl"
  "rounded-3xl"
  "id=\"hero-contact\""
  "id=\"hero-contact-qr\""
  "id=\"hero-downloads\""
  "sm:grid-cols-4"
  "whitespace-nowrap"
  "max-w-[220px]"
  "id=\"free-trial-banner\""
  "0门槛免费试用"
  "免费试用"
)

for token in "${required_tokens[@]}"; do
  if ! grep -Fq -- "$token" "$FILE"; then
    echo "FAIL: missing visual/responsive token -> $token"
    exit 1
  fi
done

if grep -Fq -- "sm:max-w-sm" "$FILE"; then
  echo "FAIL: hero top card should not have max width limit"
  exit 1
fi

if grep -Fq -- "href=\"#contact\"" "$FILE"; then
  echo "FAIL: hero top card should not use #contact anchor"
  exit 1
fi

download_url='href="https://pan.baidu.com/s/19Crs1jG_nvueiPgZQB9qDQ?pwd=3m37"'
url_count=$( (grep -o "$download_url" "$FILE" || true) | wc -l | tr -d ' ' )
if [[ "$url_count" -lt 8 ]]; then
  echo "FAIL: expected at least 8 Baidu download links, got $url_count"
  exit 1
fi

target_count=$( (grep -o 'target="_blank"' "$FILE" || true) | wc -l | tr -d ' ' )
if [[ "$target_count" -lt 8 ]]; then
  echo "FAIL: expected at least 8 links opening in new tab, got $target_count"
  exit 1
fi

echo "PASS: visual/responsive contract satisfied"
