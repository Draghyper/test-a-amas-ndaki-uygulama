#!/usr/bin/env bash
set -euo pipefail

if [[ $(uname -m) != x86_64 ]]; then
  printf 'Bu başlatıcı x86-64 Linux içindir. ARM için ek emülasyon gerekir.\n' >&2
  exit 1
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
exe="$script_dir/VR-PC-Baglanti.exe"
if [[ ! -f "$exe" ]]; then
  printf 'VR-PC-Baglanti.exe dosyasını bu betikle aynı klasöre koy.\n' >&2
  exit 1
fi

if command -v wine >/dev/null 2>&1; then
  wine_bin=wine
elif command -v wine64 >/dev/null 2>&1; then
  wine_bin=wine64
else
  printf 'Wine bulunamadı. Ubuntu/Debian: sudo apt install wine\nFedora: sudo dnf install wine\n' >&2
  exit 127
fi

export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/vr-pc-baglanti/wine"
mkdir -p -- "$WINEPREFIX"
cd -- "$script_dir"
printf 'VR-PC-Baglanti başlatılıyor. Yalnızca güvendiğin yerel ağda kullan.\n' >&2
exec "$wine_bin" "$exe" "$@"
