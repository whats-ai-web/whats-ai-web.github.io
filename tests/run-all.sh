#!/usr/bin/env bash
set -euo pipefail

bash official/tests/assert-landing-structure.sh
bash official/tests/assert-landing-visual-responsive.sh
bash official/tests/assert-landing-assets.sh
bash official/tests/assert-landing-seo-a11y.sh

echo "PASS: all landing checks passed"
