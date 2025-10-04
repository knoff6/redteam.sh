#!/usr/bin/env bash
# install_redteam_tools.sh
# Installs: nmap, gobuster, openvpn, stegseek, seclists, exiftool, john (John the Ripper)

set -euo pipefail

need_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "[!] Please run as root (use: sudo $0)"
    exit 1
  fi
}

have_cmd() { command -v "$1" >/dev/null 2>&1; }

main() {
  need_root

  export DEBIAN_FRONTEND=noninteractive

  echo "[*] Ensuring 'universe' repo is enabled (safe to run multiple times)…"
  add-apt-repository -y universe >/dev/null 2>&1 || true

  echo "[*] Updating package lists…"
  apt-get update -y

  # Package names in Ubuntu repos (note: exiftool’s package name is libimage-exiftool-perl; John is 'john')
  PKGS=(
    nmap
    gobuster
    openvpn
    stegseek
    seclists
    libimage-exiftool-perl
    john
    john-data
  )

  echo "[*] Installing packages: ${PKGS[*]}"
  apt-get install -y "${PKGS[@]}"

  echo
  echo "[*] Verifying installs…"
  # tool -> version/check command
  declare -A CHECKS=(
    [nmap]="nmap --version | head -n1"
    [gobuster]="gobuster version || gobuster -h | head -n1"
    [openvpn]="openvpn --version | head -n1"
    [stegseek]="stegseek --version || stegseek -h | head -n1"
    [exiftool]="exiftool -ver"
    [john]="john --version | head -n1"
    [seclists]="ls -d /usr/share/seclists >/dev/null && echo 'seclists -> /usr/share/seclists'"
  )

  for key in "${!CHECKS[@]}"; do
    echo -n "  - ${key}: "
    bash -c "${CHECKS[$key]}" 2>/dev/null || echo "not found (check PATH or package)"
  done

  echo
  echo "[✓] Done."
  echo "    - seclists location: /usr/share/seclists (e.g., /usr/share/seclists/Discovery/DNS/)"
  echo "    - rockyou.txt (if present) is usually at /usr/share/wordlists/rockyou.txt (may be in rockyou.txt.gz)"
}

main "$@"
