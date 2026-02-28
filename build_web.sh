#!/bin/bash
set -e

echo "==> Installing Flutter SDK..."
if [ ! -d "/tmp/flutter" ]; then
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable /tmp/flutter
fi
export PATH="/tmp/flutter/bin:/tmp/flutter/bin/cache/dart-sdk/bin:$PATH"

echo "==> Running Flutter doctor..."
flutter doctor -v

echo "==> Getting dependencies..."
flutter pub get

echo "==> Building Flutter web (release)..."
flutter build web --release --base-href "/"

echo "==> Build complete! Output in build/web"
ls -la build/web/
