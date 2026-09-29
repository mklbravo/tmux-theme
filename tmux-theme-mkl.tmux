#!/usr/bin/env bash
# ── Palette (16 ANSI colors) ────────────────────────────────────
# These map to your terminal's color scheme
default="default"
accent="colour4"     # Primary interactive elements
background="colour0" # Terminal's actual background color
error="colour1"      # Error states
foreground="colour7" # Default text
highlight="colour5"  # Active/focused elements
muted="colour8"      # Low-contrast text
secondary="colour6"  # Secondary info
success="colour2"    # Success states
tertiary="colour3"   # Tertiary info

colorize() {
  local bg_name="${1:-background}"
  local fg_name="${2:-foreground}"
  local style="${3}" # bold, nobold, or empty

  local result="#[bg=${!bg_name},fg=${!fg_name}"

  if [[ -n "${style}" ]]; then
    result="${result},${style}"
  fi

  echo "${result}]"
}

# ── Window Formats ────────────────────────────────────────────────────────────
window_status_format() {
  echo "$(colorize default accent)$(colorize accent background) #I $(colorize default accent)◤$(colorize background foreground) #W $(colorize default background)◤"
}
window_status_current_format() {
  echo "$(colorize default highlight)$(colorize highlight background bold) #I #[nobold]#{?window_zoomed_flag, ,}/ #W $(colorize default highlight)◤"
}

# ── Status Blocks────────────────────────────────────────────────────────────
prefix_block() {
  local background_color prefix_style
  background_color="#{?client_prefix,${tertiary},${foreground}}"

  prefix_style="#[bg=${background_color},fg=${background}]"

  echo "${prefix_style} #{?client_prefix,,󰮭} "
}

session_block() {
  echo "$(colorize accent muted)$(colorize accent background)  #{session_name} "
}

directory_block() {
  echo "$(colorize secondary background)  #{b:pane_current_path} $(colorize muted secondary)"
}

host_block() {
  echo "$(colorize background foreground)󰍹 #h "
}

user_block() {
  echo "$(colorize default background)$(colorize background foreground)  #{USER} $(colorize background tertiary) "
}

main() {
  # ── Window Status ────────────────────────────────────────────────────────────
  tmux set-window-option -gq window-status-separator " "
  tmux set-window-option -gq window-status-current-format "$(window_status_current_format)"
  tmux set-window-option -gq window-status-format "$(window_status_format)"
  # ── Right Status Bar ────────────────────────────────────────────────────────────
  tmux set-option -gq status "on"
  tmux set-option -gq status-style "bg=${background},fg=${foreground}"
  # tmux set-option -gq status-left-length 200
  # tmux set-option -gq status-right-length 300
  tmux set-option -gq status-left "$(prefix_block)"

  configure_window_list

  # ── Status right: session | user@host | directory ─────────────────────────
  tmux set-option -gq status-right "$(user_block)$(host_block)$(directory_block)$(session_block)"

  # ── Pane borders ──────────────────────────────────────────────────────────
  tmux set-option -gq pane-border-style "fg=${muted}"
  tmux set-option -gq pane-active-border-style "fg=${accent}"

  # ── Messages ──────────────────────────────────────────────────────────────
  tmux set-option -gq message-style "bg=${accent},fg=${background},bold"
  tmux set-option -gq message-command-style "bg=${muted},fg=${foreground}"

  # ── Misc ──────────────────────────────────────────────────────────────────
  tmux set-window-option -gq clock-mode-colour "${accent}"
  tmux set-window-option -gq mode-style "bg=${accent},fg=${background}"
}

main "$@"
