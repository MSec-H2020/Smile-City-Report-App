#!/bin/sh
BLUE='\033[0;34m'
NC='\033[0m'

echo "${BLUE}==>1. Extract to arb${NC}"
flutter packages pub run intl_translation:extract_to_arb \
    --locale=messages \
    --output-dir=lib/l10n \
    lib/l10n/l10n.dart

echo "${BLUE}==>2. Generate dart file${NC}"
flutter packages pub run intl_translation:generate_from_arb \
    --output-dir=lib/l10n --no-use-deferred-loading \
    lib/l10n/l10n.dart lib/l10n/intl_*.arb
