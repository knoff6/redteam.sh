#!/usr/bin/env bash
# install_redteam_tools.sh
# Installs: nmap, gobuster, openvpn, stegseek, seclists, exiftool, john

set -euo pipefail

need_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "[!] Please run as root (e.g., sudo $0)"; exit 1
  fi
}

have_cmd() { command -v "$1" >/dev/null 2>&1; }

install_apt_pkgs() {
  echo "[*] Enabling 'universe' and updating…"
  add-apt-repository -y universe >/dev/null 2>&1 || true
  apt-get update -y

  # exiftool is libimage-exiftool-perl; John is 'john' + 'john-data'
  local PKGS=(nmap gobuster openvpn libimage-exiftool-perl john john-data)
  echo "[*] Installing APT packages: ${PKGS[*]}"
  apt-get install -y "${PKGS[@]}"
}

install_stegseek_deb() {
  if have_cmd stegseek; then
    echo "[=] stegseek already present: $(stegseek --version 2>/dev/null || echo ok)"
    return
  fi

  echo "[*] Installing stegseek from .deb release…"
  tmpd="$(mktemp -d)"
  pushd "$tmpd" >/dev/null

  # Known good asset name; adjust if upstream changes.
  DEB_URL="https://github.com/RickdeJager/stegseek/releases/latest/download/stegseek_0.6-1.deb"
  curl -fsSL "$DEB_URL" -o stegseek.deb
  apt-get install -y ./stegseek.deb

  popd >/dev/null
  rm -rf "$tmpd"
}

install_seclists_git() {
  local TARGET="/opt/SecLists"
  local LINK="/usr/share/seclists"

  if [[ -d "$LINK" || -d "$TARGET" ]]; then
    echo "[=] SecLists already present at $LINK or $TARGET"
    return
  fi

  echo "[*] Installing SecLists by git clone to $TARGET and symlinking to $LINK…"
  apt-get install -y git
  git clone --depth=1 https://github.com/danielmiessler/SecLists.git "$TARGET"
  ln -s "$TARGET" "$LINK"
}

verify_tools() {
  echo
  echo "[*] Verifying installs…"
  declare -A CHECKS=(
    [nmap]="nmap --version | head -n1"
    [gobuster]="gobuster version || gobuster -h | head -n1"
    [openvpn]="openvpn --version | head -n1"
    [stegseek]="stegseek --version || stegseek -h | head -n1"
    [exiftool]="exiftool -ver"
    [john]="john --version | head -n1"
    [seclists]="test -d /usr/share/seclists && echo '/usr/share/seclists present'"
  )
  for k in "${!CHECKS[@]}"; do
    echo -n "  - $k: "; bash -c "${CHECKS[$k]}" 2>/dev/null || echo "not found"
  done

  echo
  echo "[✓] Done."
  echo "    SecLists path: /usr/share/seclists  (symlink to /opt/SecLists)"
  echo "    rockyou.txt (if present): /usr/share/wordlists/rockyou.txt{,.gz}"
}

main() {
  need_root
  install_apt_pkgs
  install_stegseek_deb
  install_seclists_git
  verify_tools
}
main "$@"
