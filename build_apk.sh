#!/usr/bin/env bash
# Genera el APK de release de Android con el token de Mapbox
# embebido en tiempo de compilación (mapbox.env está en .gitignore).
set -euo pipefail

if [[ ! -f mapbox.env ]]; then
  echo "ERROR: no existe mapbox.env (usa mapbox.env.example como plantilla)." >&2
  exit 1
fi

flutter build apk --release --dart-define-from-file=mapbox.env "$@"