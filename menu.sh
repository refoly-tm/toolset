#!/usr/bin/env bash

# =========================
# Configuration
# =========================
SRC_DIR="core"

# =========================
# UI Helpers
# =========================
sep() {
	echo "─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─"
}

header() {
	echo "┌──── [ $1 ] ───────────────────────────┐"
}

footer() {
	echo "└────────────────────────────────────────┘"
}

ok()    { echo " ✓ $1"; }
warn()  { echo " ⚠ $1"; }
err()   { echo " ✗ $1"; }
info()  { echo " • $1"; }

# =========================
# Help Menu
# =========================
show_help() {
	header "SCRIPT COMMANDS"
	echo "│ § SHOW        Display this help menu     │"
	echo "│ ≡ LIST        List files in '$SRC_DIR'   │"
	echo "│ ▶ <name>      Run executable <name>      │"
	echo "│ ⌧ EXIT        Exit the script             │"
	footer
	sep
}

# =========================
# File Listing
# =========================
list_files() {
	header "FILES IN '$SRC_DIR'"

	if [[ ! -d "$SRC_DIR" ]]; then
		err "Directory '$SRC_DIR' not found."
		footer
		return
	fi

	shopt -s nullglob
	files=("$SRC_DIR"/*)
	shopt -u nullglob

	if [[ ${#files[@]} -eq 0 ]]; then
		info "No files found."
	else
		for file in "${files[@]}"; do
			echo " │ ─ $(basename "$file")"
		done
	fi

	footer
}

# =========================
# Run Executable
# =========================
run_executable() {
	local name="$1"
	local path="$SRC_DIR/$name"

	if [[ ! -f "$path" ]]; then
		err "File '$name' not found in '$SRC_DIR'."
		return
	fi

	if [[ ! -x "$path" ]]; then
		if ! chmod +x "$path" 2>/dev/null; then
			err "Cannot make '$name' executable (permission denied)."
			return
		fi
	fi

	ok "Running '$name'..."
	"$path" || err "Execution failed."
}

# =========================
# Startup
# =========================
list_files
echo
show_help

# =========================
# Main Loop
# =========================
while true; do
	read -rp "[ CMD | 'show' for help ] » " input
	cmd="${input,,}"   # lowercase

	case "$cmd" in
		show) show_help ;;
		list) list_files ;;
		exit)
			info "Exiting script. Goodbye."
			exit 0
			;;
		"") ;;
		*) run_executable "$input" ;;
	esac

	echo
done

