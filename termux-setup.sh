#!/usr/bin/env bash
# Termux Advanced Setup – Hardened & Idempotent
# Author: Carter (Coding Coach)
# Target: Termux on Android (arm64/aarch64)
set -euo pipefail

LOG="$HOME/.termux-setup.log"
PREFIX="/data/data/com.termux/files/usr"
FAIL2BAN_JAIL="$PREFIX/etc/fail2ban/jail.local"
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
CRON_SERVICE_NAME="crond"
FAIL2BAN_SERVICE_NAME="fail2ban"
KEEP_LOG_LINES=5000

timestamp(){ date -u +"%Y-%m-%dT%H:%M:%SZ"; }
log(){ echo "$(timestamp) - $*" | tee -a "$LOG"; }

arch=$(uname -m || echo "unknown")
log "Starting Termux advanced setup (arch=${arch})"
touch "$LOG"

UTIL_PKGS=(termux-tools proot-distro tldr man htop neofetch fish git termux-api)
DEV_PKGS=(python nodejs golang clang make neovim build-essential)
NETSEC_PKGS=(openssh net-tools dnsutils nmap tcpdump termux-services cronie fail2ban)

ensure_pkg(){
  local critical=false
  if [ "${1:-}" = "--critical" ]; then
    critical=true
    shift
  fi
  for pkg in "$@"; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
      log "Installing: $pkg"
      if ! pkg install -y "$pkg"; then
        log "ERROR: Failed to install $pkg"
        $critical && { log "Aborting due to critical package failure: $pkg"; exit 1; }
      fi
    else
      log "Already present: $pkg"
    fi
  done
}

ensure_sv_up(){
  local svc="$1"
  if command -v sv >/dev/null 2>&1; then
    sv up "$svc" 2>/dev/null || log "WARN: sv up $svc failed"
    if ! sv status "$svc" 2>/dev/null | grep -q 'run:'; then
      log "WARN: Service $svc not running after sv up"
    else
      log "Service $svc running"
    fi
  else
    log "WARN: 'sv' command not found. Install termux-services to manage services."
  fi
}

append_cron_if_missing(){
  local job_line="$1"
  if (crontab -l 2>/dev/null || true) | grep -Fq -- "$job_line"; then
    log "Cron job already present."
  else
    (crontab -l 2>/dev/null || true; echo "$job_line") | crontab -
    log "Cron job installed: $job_line"
  fi
}

log_cleanup(){
  if [ -f "$LOG" ]; then
    tail -n "$KEEP_LOG_LINES" "$LOG" > "${LOG}.tmp" && mv "${LOG}.tmp" "$LOG"
  fi
}

log "Installing package groups..."
ensure_pkg "${UTIL_PKGS[@]}"
ensure_pkg "${DEV_PKGS[@]}"
ensure_pkg --critical "${NETSEC_PKGS[@]}"

setup_ssh_key(){
  log "Ensuring .ssh directory and permissions..."
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh" || true

  if [ ! -f "$SSH_KEY_PATH" ]; then
    log "Generating Ed25519 SSH key at $SSH_KEY_PATH (no passphrase)."
    ssh-keygen -t ed25519 -C "$(hostname)-termux" -f "$SSH_KEY_PATH" -N "" -q
    chmod 600 "$SSH_KEY_PATH"
    chmod 644 "${SSH_KEY_PATH}.pub"
    log "SSH key created: ${SSH_KEY_PATH}.pub"
  else
    log "SSH key already exists at $SSH_KEY_PATH"
  fi
}
setup_ssh_key

setup_fail2ban(){
  log "Configuring fail2ban for Termux."
  mkdir -p "$PREFIX/etc/fail2ban"

  if [ ! -f "$FAIL2BAN_JAIL" ]; then
    cat > "$FAIL2BAN_JAIL" <<EOJ
[DEFAULT]
bantime = 24h
findtime = 10m
maxretry = 3
banaction = iptables-multiport

[sshd]
enabled = true
port    = ssh
filter  = sshd
logpath = $PREFIX/var/log/auth.log
maxretry = 3
bantime = 24h
EOJ
    log "jail.local created."
  else
    log "jail.local already exists; leaving in place."
  fi

  mkdir -p "$PREFIX/etc/logrotate.d"
  cat > "$PREFIX/etc/logrotate.d/termux-auth" <<EOJ
$PREFIX/var/log/auth.log {
    weekly
    rotate 4
    compress
    missingok
    notifempty
}
EOJ
  log "Added logrotate config for auth.log"

  if command -v sv >/dev/null 2>&1; then
    sv down "$FAIL2BAN_SERVICE_NAME" 2>/dev/null || true
    sv up "$FAIL2BAN_SERVICE_NAME" 2>/dev/null || log "WARN: Could not sv up $FAIL2BAN_SERVICE_NAME"
    if sv status "$FAIL2BAN_SERVICE_NAME" 2>/dev/null | grep -q 'run:'; then
      log "Fail2ban running"
    else
      log "WARN: Fail2ban not running after sv up"
    fi
  else
    log "WARN: 'sv' not available; start fail2ban manually or install termux-services"
  fi
}
setup_fail2ban

setup_weekly_update_cron(){
  log "Setting a weekly package update cron job."
  ensure_sv_up "$CRON_SERVICE_NAME"
  local cron_job="0 4 * * 0 $PREFIX/bin/pkg update -y && $PREFIX/bin/pkg upgrade -y >/dev/null 2>&1"
  append_cron_if_missing "$cron_job"
}
setup_weekly_update_cron

log "Setup complete. Summary:"
log " - SSH public key: ${SSH_KEY_PATH}.pub"
log " - Fail2ban jail: $FAIL2BAN_JAIL"
log " - Cron job: weekly pkg update (Sunday 04:00)"
log "Check $LOG for details."

log_cleanup
