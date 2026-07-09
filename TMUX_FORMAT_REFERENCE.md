# Tmux Format Variables & Conditionals Reference

A comprehensive guide to tmux format strings used in status lines, window naming, and configuration.

## Table of Contents

1. [Quick Start](#quick-start)
2. [Single-Character Aliases](#single-character-aliases)
3. [Client Variables](#client-variables)
4. [Session Variables](#session-variables)
5. [Window Variables](#window-variables)
6. [Pane Variables](#pane-variables)
7. [Conditionals](#conditionals)
8. [Comparison Operators](#comparison-operators)
9. [String Modifiers](#string-modifiers)
10. [Practical Examples](#practical-examples)
11. [Testing & Debugging](#testing--debugging)

---

## Quick Start

Tmux format strings use `#{}` syntax to embed dynamic information:

```bash
# Basic variable
#{session_name}              # Current session name

# Conditional (ternary operator)
#{?condition,true_value,false_value}

# Example: Show "ZOOMED" if window is zoomed, empty otherwise
#{?window_zoomed_flag, ZOOMED,}
```

**Key Points:**
- Format variables must be enclosed in `#{}`
- Single-character aliases (like `#S`, `#I`) are shortcuts but don't support modifiers
- Unknown or missing variables are replaced with empty string
- Escape literal `#` with `##`

---

## Single-Character Aliases

Quick shortcuts for commonly used variables (but limited—don't work with modifiers):

| Alias | Full Variable | Meaning |
|-------|---------------|---------|
| `#S` | `session_name` | Current session name |
| `#W` | `window_name` | Current window name/title |
| `#I` | `window_index` | Current window index (1, 2, 3...) |
| `#P` | `pane_index` | Pane index in current window |
| `#T` | `pane_title` | Pane title (set by terminal app) |
| `#D` | `pane_id` | Pane ID (e.g., `%0`, `%1`) |
| `#F` | `window_flags` | Window flags (e.g., `*` for active, `-` for last, `Z` for zoomed) |
| `#H` | `host` | Full hostname |
| `#h` | `host_short` | Short hostname (first part before `.`) |

**Example:**
```bash
# In status-left: Show session name and window index
set -g status-left "#[bg=blue] #S #[default] #I:"

# Output: " myapp 1:"
```

---

## Client Variables

Information about the **connected client** (the user/terminal):

| Variable | Type | Meaning |
|----------|------|---------|
| `#{client_name}` | string | Name of the client connection |
| `#{client_pid}` | number | Process ID of client |
| `#{client_session}` | string | Name of client's current session |
| `#{client_last_session}` | string | Name of client's last session |
| `#{client_width}` | number | Terminal width in columns |
| `#{client_height}` | number | Terminal height in rows |
| `#{client_prefix}` | flag | `1` if prefix key (Ctrl-b) was just pressed, `0` otherwise |
| `#{client_readonly}` | flag | `1` if client is read-only |
| `#{client_activity}` | timestamp | Last activity time (use `#{t:client_activity}` for human-readable) |
| `#{client_key_table}` | string | Current key table name |
| `#{client_mode}` | string | Client mode (if any) |

**Example:**
```bash
# Show "PREFIX" indicator when prefix key is pressed
"#{?client_prefix,#[bg=red] ⌨  PREFIX #[default],}"

# Show terminal dimensions
"#{client_width}x#{client_height}"
```

---

## Session Variables

Information about the **tmux session**:

| Variable | Type | Meaning |
|----------|------|---------|
| `#{session_name}` | string | Session name |
| `#{session_id}` | string | Session ID (e.g., `$0`, `$1`) |
| `#{session_width}` | number | Session width (widest client) |
| `#{session_height}` | number | Session height (shortest client) |
| `#{session_windows}` | number | Total windows in session |
| `#{session_created}` | timestamp | Creation time |
| `#{session_activity}` | timestamp | Last activity time |
| `#{session_path}` | path | Session starting path |
| `#{session_attached}` | number | Number of attached clients |

**Example:**
```bash
# Display session info
"Session: #{session_name} (#{session_windows} windows)"

# Show when session was created
"Created: #{t:session_created}"
```

---

## Window Variables

Information about **windows** in the session:

| Variable | Type | Meaning |
|----------|------|---------|
| `#{window_name}` | string | Window name/title |
| `#{window_index}` | number | Window number (usually 0-9) |
| `#{window_id}` | string | Window ID (e.g., `@0`, `@1`) |
| `#{window_width}` | number | Window width in columns |
| `#{window_height}` | number | Window height in rows |
| `#{window_panes}` | number | Number of panes in window |
| `#{window_active}` | flag | `1` if this window is currently active/focused |
| `#{window_bell_flag}` | flag | `1` if window has unread bell notification |
| `#{window_activity_flag}` | flag | `1` if window has activity (shows `#` in status) |
| `#{window_flags}` | string | Window flags with special formatting (`*`, `-`, `Z`, etc.) |
| `#{window_zoomed_flag}` | flag | `1` if window is zoomed (pane maximized) |
| `#{window_layout}` | string | Current pane layout name (e.g., `even-horizontal`) |
| `#{window_active_pane}` | string | ID of the active pane |
| `#{window_silence_flag}` | flag | `1` if window is silent (no activity) |

**Example:**
```bash
# Window status with activity indicators
"#[bg=blue] #I #W #[default]#{?window_bell_flag, 🔔,}#{?window_activity_flag, ⚡,}#{?window_zoomed_flag, Z,}"

# Show if window is zoomed
"#{?window_zoomed_flag,#[fg=red] ZOOMED #[default],}"
```

---

## Pane Variables

Information about **panes** (subdivisions of windows):

| Variable | Type | Meaning |
|----------|------|---------|
| `#{pane_title}` | string | Pane title (can be set by terminal app) |
| `#{pane_id}` | string | Pane ID (e.g., `%0`, `%1`) |
| `#{pane_index}` | number | Pane index in current window |
| `#{pane_width}` | number | Pane width in columns |
| `#{pane_height}` | number | Pane height in rows |
| `#{pane_left}` | number | Left position within window |
| `#{pane_top}` | number | Top position within window |
| `#{pane_right}` | number | Right position within window |
| `#{pane_bottom}` | number | Bottom position within window |
| `#{pane_current_path}` | path | Current working directory of pane |
| `#{pane_current_command}` | string | Command currently running in pane |
| `#{pane_start_command}` | string | Command pane was started with |
| `#{pane_mode}` | string | Current mode (e.g., `copy-mode`, `view-mode`) |
| `#{pane_in_mode}` | flag | `1` if pane is in a mode |
| `#{pane_marked}` | flag | `1` if this pane is marked |
| `#{pane_marked_set}` | flag | `1` if any pane is marked in session |
| `#{pane_pipe}` | flag | `1` if pane output is piped |
| `#{pane_synchronized}` | flag | `1` if pane is synchronized with others |
| `#{pane_last}` | flag | `1` if this is the last (previously active) pane |
| `#{pane_tty}` | string | Pseudo terminal device (e.g., `/dev/pts/1`) |

**Example:**
```bash
# Show pane mode indicator in status
"#{?pane_in_mode,#[bg=yellow] #{pane_mode} #[default],}"

# Show current directory
"📁 #{b:pane_current_path}"

# Show running command
"Command: #{pane_current_command}"
```

---

## Conditionals

### Ternary Operator (Most Common)

```bash
#{?condition,true_value,false_value}
```

The condition is evaluated:
- **True** if: non-empty AND not just `0`
- **False** if: empty OR is `0`

**Examples:**

```bash
# Show "ZOOMED" if window is zoomed
#{?window_zoomed_flag, [Z],}

# Show "PREFIX" with red background if prefix key pressed
#{?client_prefix,#[bg=red] PREFIX ,}

# Show window active status
#{?window_active,*,-}

# Show pane mode if in a mode
#{?pane_in_mode, #{pane_mode} ,}

# Show session name or "no session"
#{?session_name,Session: #{session_name},No Session}
```

### Nested Conditionals

```bash
# Multiple conditions with nested ternaries
#{?window_bell_flag,#[fg=red]🔔#[default],#{?window_activity_flag,⚡,}}

# Which means:
# - If bell: show red bell
# - Else if activity: show lightning
# - Else: nothing
```

### Inside Conditionals: Escape Commas

To include a literal comma in conditional output, escape it as `#,`:

```bash
#{?window_zoomed_flag,Zoomed#,Zoomed,Not Zoomed}
# Output: "Zoomed,Zoomed" or "Not Zoomed"
```

---

## Comparison Operators

Compare two format strings:

| Operator | Syntax | Meaning |
|----------|--------|---------|
| `==` | `#{==:val1,val2}` | Equal |
| `!=` | `#{!=:val1,val2}` | Not equal |
| `<` | `#{<:val1,val2}` | Less than (string compare) |
| `>` | `#{>:val1,val2}` | Greater than (string compare) |
| `<=` | `#{<=:val1,val2}` | Less than or equal |
| `>=` | `#{>=:val1,val2}` | Greater than or equal |
| `\|\|` | `#{||:val1,val2}` | OR (true if either truthy) |
| `&&` | `#{&&:val1,val2}` | AND (true if both truthy) |

**Examples:**

```bash
# Check if window index is 1
#{?#{==:#{window_index},1},Active,}

# Check if NOT in copy-mode
#{?#{!=:#{pane_mode},copy-mode},Ready,Copying}

# Check if width > 80
#{?#{>:#{client_width},80},Wide,Narrow}

# Check if window is active OR has bell
#{?#{||:#{window_active},#{window_bell_flag}},Important,}

# Combine with conditional for display
#{?#{&&:#{window_active},#{window_zoomed_flag}},#[bg=red]ACTIVE+ZOOM#[default],}
```

---

## String Modifiers

Transform variable values:

| Modifier | Syntax | Meaning |
|----------|--------|---------|
| `t:` | `#{t:variable}` | Convert timestamp to human-readable (e.g., `Mon Dec  2 12:51:29`) |
| `b:` | `#{b:variable}` | Get basename (filename only from path) |
| `d:` | `#{d:variable}` | Get dirname (directory part of path) |
| `=N:` | `#{=10:variable}` | Trim to N characters (left trim if longer) |
| `=-N:` | `#{=-10:variable}` | Trim to N characters (right trim if longer) |
| `pN:` | `#{p10:variable}` | Pad to N characters (right pad with spaces) |
| `p-N:` | `#{p-10:variable}` | Pad to N characters (left pad with spaces) |
| `=\|N\|STR:` | `#{=\|10\|...:variable}` | Trim to N with marker string if trimmed |
| `s/pattern/repl/:` | `#{s/foo/bar/:variable}` | Substitute (sed-style) |
| `m:pattern,` | `#{m:*foo*,variable}` | Match glob pattern (use in conditionals) |
| `E:` | `#{E:variable}` | Expand variable content (nested expansion) |
| `l:` | `#{l:text}` | Literal—don't expand (escape special chars) |
| `q:` | `#{q:variable}` | Quote special characters |

**Examples:**

```bash
# Convert activity time to readable format
"Last activity: #{t:window_activity}"

# Show just filename from path
"File: #{b:pane_current_path}"

# Show just directory from path
"Dir: #{d:pane_current_path}"

# Trim window name to 10 chars with ellipsis
"#{=|10|...:window_name}"

# Truncate and pad window index to 3 chars
"#{p3:window_index}"

# Substitute "foo" with "BAR" in pane command
"Running: #{s/foo/BAR/:pane_current_command}"

# Match pattern (use in conditional)
"#{?#{m:*python*,pane_current_command},🐍,}"

# Quote for shell safety
"safe_path=#{q:pane_current_path}"
```

---

## Practical Examples

### Example 1: Status Line with Indicators

```bash
# ~/.tmux.conf
set -g status-right "\
#{?client_prefix,#[bg=red] PREFIX #[default] ,}\
#{?window_bell_flag,#[fg=red]🔔 #[default],}\
#{?window_activity_flag,#[fg=yellow]⚡ #[default],}\
#{?window_zoomed_flag,#[bg=blue] ZOOM #[default] ,}\
#[bg=cyan] #{client_width}x#{client_height} #[default]"
```

### Example 2: Window Status Format

```bash
# Inactive windows
set -g window-status-format "\
#[bg=colour0,fg=colour8]  #I \
#[fg=colour7]#{b:pane_current_path} "

# Active window with decorations
set -g window-status-current-format "\
#[bg=colour4,fg=colour0] #I \
#[fg=colour0,bg=colour4,bold]#{window_name}\
#[nobold]#{?window_zoomed_flag, [Z],} #[default]"
```

### Example 3: Session Display

```bash
# Show session info with pane count
tmux display-p "Session: #{session_name} | Windows: #{session_windows} | Panes: #{window_panes}"

# List windows with their pane counts
tmux lsw -F "#{window_index}: #{window_name} (#{window_panes} panes)"
```

### Example 4: Complex Activity Indicator

```bash
# Show activity/bell/zoom in one field
set -g window-status-current-format "\
#[bg=blue]#{window_index} #{window_name}\
#{?or:#{window_bell_flag},#{window_activity_flag},#{window_zoomed_flag}, \
  #[fg=red]●#[default] ,}"
```

### Example 5: Pane Mode Indicator

```bash
# Show what mode current pane is in
set -g status-left "\
#[bg=blue] #S #[default] \
#{?pane_in_mode,#[bg=yellow] #{pane_mode} #[default],}"
```

---

## Testing & Debugging

### List All Available Variables

```bash
# Show all format variables tmux knows about
tmux display -a

# Search for specific variables
tmux display -a | grep window

# Search for variables about activity
tmux display -a | grep activity
```

### Test a Format String

```bash
# Simple test
tmux display-p "#{window_index}"

# Verbose output (shows expansion steps)
tmux display -vp "#{?window_zoomed_flag,ZOOMED,normal}"

# Example verbose output:
# expanding format: #{?window_zoomed_flag,ZOOMED,normal}
# found #{?window_zoomed_flag,ZOOMED,normal}
# result is: ZOOMED
```

### Common Debugging Tips

```bash
# Check if a variable exists and has a value
tmux display-p "DEBUG: pane_mode = '#{pane_mode}'"

# Check boolean/flag values (1 or 0 or empty)
tmux display-p "Is zoomed? #{window_zoomed_flag}"
tmux display-p "Has bell? #{window_bell_flag}"

# Test conditionals
tmux display-p "#{?window_zoomed_flag,YES,NO}"

# Test nested conditionals
tmux display-p "#{?#{==:#{window_index},1},First window,Other}"

# View your actual status-right expansion
tmux display-p "#{status_right}"
```

### Reload Configuration

After editing your `.tmux.conf`, reload without restarting:

```bash
tmux source-file ~/.tmux.conf

# Or use the binding (default is Prefix + r)
tmux bind-key r source-file ~/.tmux.conf \; display-message "Config reloaded!"
```

---

## Common Use Cases

### Activity Alerts

```bash
# Bell: window received a bell character
#{?window_bell_flag,🔔,}

# Activity: window had output while not focused
#{?window_activity_flag,⚡,}

# Combined: show either bell or activity
#{?or:#{window_bell_flag},#{window_activity_flag},🔴,}
```

### Prefix Key Indicator

```bash
# Show PREFIX when Ctrl-b (or your prefix) is pressed
#{?client_prefix,#[bg=red] ⌨ PREFIX #[default],}
```

### Zoom Indicator

```bash
# Maximized pane indicator
#{?window_zoomed_flag,#[bg=blue] ZOOM #[default],}
```

### Mode Indicator (Copy Mode, etc.)

```bash
# Show when in copy-mode, search-mode, view-mode, etc.
#{?pane_in_mode,#[bg=yellow] #{pane_mode} #[default],}
```

### Path Display

```bash
# Full current path
#{pane_current_path}

# Just the folder name (basename)
#{b:pane_current_path}

# Full directory path (dirname)
#{d:pane_current_path}
```

### Time Information

```bash
# Human-readable session activity time
#{t:session_activity}

# Human-readable window creation time
#{t:window_created}

# Human-readable pane activity time
#{t:pane_activity}
```

---

## References

- [tmux Format System Wiki](https://github.com/tmux/tmux/wiki/Formats)
- [tmux Manual (man tmux)](https://man.archlinux.org/man/extra/tmux/tmux.1.en)
- [DeepWiki - Tmux Format System](https://deepwiki.com/tmux/tmux/5.1-format-system)

---

## Notes

- **Not all variables available everywhere**: Some variables only make sense in certain contexts (e.g., `pane_mode` in pane context, not session context)
- **Performance**: Shell command expansion `#(command)` can be expensive; use sparingly and set `status-interval` appropriately
- **Escaping**: Double `#` to get literal `#`: `##` → `#`
- **Modifiers limitation**: Single-character aliases (like `#I`, `#W`) don't support modifiers; use full names like `#{window_index}` for modifications
