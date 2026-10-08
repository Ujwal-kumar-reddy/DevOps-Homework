#!/bin/bash
set -e

echo "================================="
echo "Starting Application Build"
echo "================================="

rm -rf build
mkdir -p build

cp app/calculator.py build/

cat > build/build-info.txt <<EOF
Application: Session 16 Calculator
Build Status: SUCCESS
Build Date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
Environment: Production
EOF

echo ""
echo "Build files created:"
ls -la build

echo ""
echo "Build completed successfully."
