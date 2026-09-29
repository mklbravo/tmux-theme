# tmux-theme

A clean tmux theme built around the terminal's ANSI color palette. It provides a compact status bar with window, prefix, user, host, directory, and session information.

## Features

- Active and inactive window styling
- Prefix key indicator
- Current user and host
- Current pane directory
- Session name
- Active pane border highlighting
- Copy mode, clock, and message styling
- ANSI colors that follow your terminal color scheme

## Requirements

- tmux 2.0 or newer
- A [Nerd Font](https://www.nerdfonts.com/) for the icons and Powerline separators
- Bash

## Installation

### TPM

Add the plugin to `~/.tmux.conf`:

```tmux
set -g @plugin 'mklbravo/tmux-theme'
```

Make sure TPM is initialized at the bottom of the file:

```tmux
run-shell '~/.tmux/plugins/tpm/tpm'
```

Reload the tmux configuration and press `prefix + I` to install the plugin:

```sh
tmux source-file ~/.tmux.conf
```

### Manual installation

Clone the repository:

```sh
git clone https://github.com/mklbravo/tmux-theme.git ~/.tmux/plugins/tmux-theme
```

Load the theme from `~/.tmux.conf`:

```tmux
run-shell '~/.tmux/plugins/tmux-theme/theme.tmux'
```

Then reload the configuration:

```sh
tmux source-file ~/.tmux.conf
```

## Color palette

The theme uses semantic names mapped to the terminal's standard ANSI palette:

| Role | ANSI color |
| --- | --- |
| Background | `colour0` |
| Error | `colour1` |
| Success | `colour2` |
| Tertiary | `colour3` |
| Accent | `colour4` |
| Highlight | `colour5` |
| Secondary | `colour6` |
| Foreground | `colour7` |
| Muted | `colour8` |

The final appearance therefore follows the color scheme configured in your terminal emulator.

## Updating

With TPM, press `prefix + U` and select `tmux-theme`.

For a manual installation:

```sh
git -C ~/.tmux/plugins/tmux-theme pull
```
