#!/usr/bin/env bash
# ==============================================================================
# Installer Script for 'screenshot-to-code' AI Agent Skill
# Repository: https://github.com/tavanhvannala677-beep/skills-screenshot-to-code-tawan
# Description: Installs or updates the Universal Screenshot-to-Code skill into
#              the target AI agent directory (Global or Local Project).
# ==============================================================================

set -euo pipefail

# --- Configuration Constants ---
readonly SCRIPT_VERSION="1.2.0"
readonly REPO="tavanhvannala677-beep/skills-screenshot-to-code-tawan"
readonly BRANCH="main"
readonly RAW_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/SKILL.md"
readonly SKILL_NAME="screenshot-to-code"

# --- ANSI Color Helpers ---
# Check if stdout is a terminal to enable colors
if [[ -t 1 ]]; then
    readonly C_RESET=$'\033[0m'
    readonly C_BOLD=$'\033[1m'
    readonly C_GREEN=$'\033[32m'
    readonly C_BLUE=$'\033[34m'
    readonly C_YELLOW=$'\033[33m'
    readonly C_RED=$'\033[31m'
    readonly C_CYAN=$'\033[36m'
else
    readonly C_RESET=''
    readonly C_BOLD=''
    readonly C_GREEN=''
    readonly C_BLUE=''
    readonly C_YELLOW=''
    readonly C_RED=''
    readonly C_CYAN=''
fi

# --- Logging Helper Functions ---
log_info() {
    printf "%bℹ %s%b\n" "${C_BLUE}" "$1" "${C_RESET}"
}

log_success() {
    printf "%b✔ %s%b\n" "${C_GREEN}" "$1" "${C_RESET}"
}

log_warn() {
    printf "%b⚠ %s%b\n" "${C_YELLOW}" "$1" "${C_RESET}"
}

log_error() {
    printf "%b✖ %s%b\n" "${C_RED}" "$1" "${C_RESET}" >&2
}

# --- Usage / Help Menu ---
show_help() {
    cat << EOF
${C_BOLD}Usage:${C_RESET}
  install.sh [OPTIONS]

${C_BOLD}Options:${C_RESET}
  -g, --global     Install globally to ~/.agents/skills (Default, works for all projects)
  -l, --local      Install locally to the current project (.agents/skills)
  -c, --check      Check existing skill installation status and verify files
  -v, --version    Display installer version
  -h, --help       Show this help message

${C_BOLD}Examples:${C_RESET}
  curl -fsSL https://raw.githubusercontent.com/${REPO}/${BRANCH}/install.sh | bash
  ./install.sh --local
  ./install.sh --check
EOF
}

# --- Status Checker Helper ---
check_status() {
    local global_path="$HOME/.agents/skills/${SKILL_NAME}/SKILL.md"
    local local_path="./.agents/skills/${SKILL_NAME}/SKILL.md"

    printf "%bChecking skill installation status...%b\n" "${C_BOLD}" "${C_RESET}"

    local found=0
    if [[ -f "${global_path}" ]]; then
        log_success "Global skill found: ${global_path}"
        found=1
    fi

    if [[ -f "${local_path}" ]]; then
        log_success "Local project skill found: ${local_path}"
        found=1
    fi

    if [[ ${found} -eq 0 ]]; then
        log_warn "Skill is not currently installed in Global or Local path."
    fi
}

# --- Main Installer Logic ---
main() {
    local mode="global"

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -g|--global)
                mode="global"
                shift
                ;;
            -l|--local)
                mode="local"
                shift
                ;;
            -c|--check)
                check_status
                exit 0
                ;;
            -v|--version)
                echo "screenshot-to-code installer v${SCRIPT_VERSION}"
                exit 0
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # Determine target directory
    local target_dir
    local scope_desc
    if [[ "${mode}" == "local" ]]; then
        target_dir=".agents/skills/${SKILL_NAME}"
        scope_desc="Local Project (${PWD})"
    else
        target_dir="$HOME/.agents/skills/${SKILL_NAME}"
        scope_desc="Global (${HOME}/.agents/skills)"
    fi

    printf "%b==============================================%b\n" "${C_CYAN}${C_BOLD}" "${C_RESET}"
    printf "%b🚀 Installing '%s' (Universal AI Skill v%s)%b\n" "${C_CYAN}" "${SKILL_NAME}" "${SCRIPT_VERSION}" "${C_RESET}"
    printf "%b📍 Scope: %s%b\n" "${C_CYAN}" "${scope_desc}" "${C_RESET}"
    printf "%b==============================================%b\n" "${C_CYAN}${C_BOLD}" "${C_RESET}"

    # Ensure target directory exists
    mkdir -p "${target_dir}"

    local dest_file="${target_dir}/SKILL.md"
    local temp_file
    temp_file="$(mktemp "${TMPDIR:-/tmp}/skill_download.XXXXXX")"
    trap 'rm -f "${temp_file}"' EXIT

    log_info "Downloading latest SKILL.md from GitHub..."

    # Prefer curl, fallback to wget
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "${RAW_URL}" -o "${temp_file}"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "${temp_file}" "${RAW_URL}"
    else
        log_error "Neither curl nor wget was found. Please install either tool to continue."
        exit 1
    fi

    # Verify download is non-empty
    if [[ ! -s "${temp_file}" ]]; then
        log_error "Downloaded skill file is empty or invalid."
        exit 1
    fi

    # Atomically move temporary file into destination
    mv "${temp_file}" "${dest_file}"
    chmod 644 "${dest_file}"

    log_success "Skill installed successfully!"
    log_info "Destination: ${dest_file}"
    echo ""
    printf "%b✨ How to use in Codex / Claude Code / Cursor / Windsurf / Antigravity:%b\n" "${C_BOLD}" "${C_RESET}"
    printf "   Type %b\$screenshot-to-code%b and attach your screenshot or Figma reference!\n" "${C_GREEN}" "${C_RESET}"
}

main "$@"
