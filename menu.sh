#!/usr/bin/env bash

SRC_DIR="bin"

# -------------------------
# UI helpers
# -------------------------
line()   { echo "----------------------------------------"; }
title()  { echo "[ $1 ]"; line; }

msg() {
	case "$1" in
		ok)   echo "[OK]   $2" ;;
		warn) echo "[WARN] $2" ;;
		err)  echo "[ERR]  $2" ;;
		info) echo "[INFO] $2" ;;
	esac
}

# -------------------------
# Help
# -------------------------
show_help() {
	title "SCRIPT COMMANDS"
	echo "show        - Display this help menu"
	echo "list        - List files in '$SRC_DIR'"
	echo "<name>      - Run executable <name>"
	echo "exit        - Exit the script"
	line
}

# -------------------------
# List files
# -------------------------
list_files() {
	title "FILES IN '$SRC_DIR'"

	if [[ ! -d "$SRC_DIR" ]]; then
		msg err "Directory not found."
		return
	fi

	files=("$SRC_DIR"/*)

	if [[ ${#files[@]} -eq 0 ]]; then
		msg info "No files found."
	else
		for f in "${files[@]}"; do
			echo " - ${f##*/}"
		done
	fi

	line
}

# -------------------------
# Run executable
# -------------------------
run_executable() {
	local path="$SRC_DIR/$1"

	if [[ ! -f "$path" ]]; then
		msg err "File not found."
		return
	fi

	if [[ ! -x "$path" ]] && ! chmod +x "$path" 2>/dev/null; then
		msg err "Permission denied."
		return
	fi

	msg ok "Running '$1'..."
	"$path" || msg err "Execution failed."
}

# -------------------------
# Startup
# -------------------------
list_files
echo
show_help

# -------------------------
# Main loop
# -------------------------
while true; do
	read -rp "[cmd | 'show' for help] > " input
	cmd="${input,,}"

	case "$cmd" in
		show) show_help ;;
		list) list_files ;;
		exit)
			msg info "exited..."
			exit 0
			;;
		"") ;;
		*) run_executable "$input" ;;
	esac

	echo
done
