#!/usr/bin/env bash
# ==============================================================================
# Validation Helper Script for screenshot-to-code Skill
# Repository: https://github.com/tavanhvannala677-beep/skills-screenshot-to-code-tawan
# Description: Verifies that SKILL.md adheres to structural guidelines,
#              frontmatter conventions, guardrails, and file synchronization.
# ==============================================================================

set -euo pipefail

# --- Color Formatting ---
if [[ -t 1 ]]; then
    readonly C_RESET=$'\033[0m'
    readonly C_BOLD=$'\033[1m'
    readonly C_GREEN=$'\033[32m'
    readonly C_RED=$'\033[31m'
    readonly C_YELLOW=$'\033[33m'
    readonly C_CYAN=$'\033[36m'
else
    readonly C_RESET=''
    readonly C_BOLD=''
    readonly C_GREEN=''
    readonly C_RED=''
    readonly C_YELLOW=''
    readonly C_CYAN=''
fi

# --- Counters & Flags ---
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

# --- Helper Assertions ---
assert_check() {
    local description="$1"
    local command_status="$2"

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if [[ "${command_status}" -eq 0 ]]; then
        printf "%b✔%b %s\n" "${C_GREEN}" "${C_RESET}" "${description}"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        printf "%b✖%b %s\n" "${C_RED}" "${C_RESET}" "${description}"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
    fi
}

# --- Main Validator Execution ---
main() {
    local base_dir
    base_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local root_skill="${base_dir}/SKILL.md"
    local agent_skill="${base_dir}/.agents/skills/screenshot-to-code/SKILL.md"

    printf "%b==============================================%b\n" "${C_CYAN}${C_BOLD}" "${C_RESET}"
    printf "%b🔍 Running Skill Validation Suite%b\n" "${C_CYAN}${C_BOLD}" "${C_RESET}"
    printf "%bDirectory: %s%b\n" "${C_CYAN}" "${base_dir}" "${C_RESET}"
    printf "%b==============================================%b\n\n" "${C_CYAN}${C_BOLD}" "${C_RESET}"

    # 1. Check root SKILL.md existence
    if [[ -f "${root_skill}" ]]; then
        assert_check "Root SKILL.md exists" 0
    else
        assert_check "Root SKILL.md exists" 1
    fi

    # 2. Check YAML frontmatter opening & closing
    local delimiter_count
    delimiter_count=$(grep -c "^---" "${root_skill}" || true)
    if [[ "${delimiter_count}" -ge 2 ]]; then
        assert_check "YAML frontmatter delimiters (---) present" 0
    else
        assert_check "YAML frontmatter delimiters (---) present" 1
    fi

    # 3. Check frontmatter name and description
    if grep -q "^name: screenshot-to-code" "${root_skill}" && grep -q "^description:" "${root_skill}"; then
        assert_check "Frontmatter contains valid name and description metadata" 0
    else
        assert_check "Frontmatter contains valid name and description metadata" 1
    fi

    # 4. Check Non-Negotiable Guardrails
    if grep -q "Zero Unauthorized Dependencies" "${root_skill}" && \
       grep -q "Design Token" "${root_skill}" && \
       grep -q "Anti-Hype" "${root_skill}"; then
        assert_check "Mandatory guardrails (Dependencies, Tokens, Anti-Hype) verified" 0
    else
        assert_check "Mandatory guardrails (Dependencies, Tokens, Anti-Hype) verified" 1
    fi

    # 5. Check Platform Touch Targets (Android 48dp, iOS 44pt, HarmonyOS 48vp)
    if grep -q "48x48 dp" "${root_skill}" && \
       grep -q "44x44 pt" "${root_skill}" && \
       grep -q "48x48 vp" "${root_skill}"; then
        assert_check "Platform-accurate touch targets (48dp / 44pt / 48vp) defined" 0
    else
        assert_check "Platform-accurate touch targets (48dp / 44pt / 48vp) defined" 1
    fi

    # 6. Check Feature Contract / Parity Record requirements
    if grep -q "Parity Record" "${root_skill}" && grep -q "Feature Contract" "${root_skill}"; then
        assert_check "Multi-platform Feature Contract and Parity Records enforced" 0
    else
        assert_check "Multi-platform Feature Contract and Parity Records enforced" 1
    fi

    # 7. Check 6-Phase Execution Workflow
    if grep -q "Phase 1: Stack & Parity Reconnaissance" "${root_skill}" && \
       grep -q "Phase 6: Final Verification Report" "${root_skill}"; then
        assert_check "Complete 6-Phase Execution Workflow structure present" 0
    else
        assert_check "Complete 6-Phase Execution Workflow structure present" 1
    fi

    # 8. Check synchronization with .agents/skills copy
    if [[ -f "${agent_skill}" ]]; then
        if cmp -s "${root_skill}" "${agent_skill}"; then
            assert_check "Agent skill copy (.agents/skills) is in sync with root SKILL.md" 0
        else
            assert_check "Agent skill copy (.agents/skills) is in sync with root SKILL.md" 1
        fi
    else
        assert_check "Agent skill copy (.agents/skills) exists" 1
    fi

    # 9. Check executable permissions on shell scripts
    if [[ -x "${base_dir}/install.sh" ]]; then
        assert_check "install.sh has executable permissions" 0
    else
        assert_check "install.sh has executable permissions" 1
    fi

    # --- Summary ---
    echo ""
    printf "%bSummary: %d/%d checks passed%b\n" "${C_BOLD}" "${PASSED_CHECKS}" "${TOTAL_CHECKS}" "${C_RESET}"

    if [[ "${FAILED_CHECKS}" -eq 0 ]]; then
        printf "%b🎉 All skill validation checks passed successfully!%b\n" "${C_GREEN}${C_BOLD}" "${C_RESET}"
        return 0
    else
        printf "%b❌ %d check(s) failed. Please review the output above.%b\n" "${C_RED}${C_BOLD}" "${FAILED_CHECKS}" "${C_RESET}"
        return 1
    fi
}

main "$@"
