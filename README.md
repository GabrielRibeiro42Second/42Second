# TermOS

A workspace framework for tmux. Not a config — a system.

## What is TermOS?

TermOS turns tmux into a workspace manager. Press a key, pick a project, and get a fully configured workspace with the right layout, tools, and context automatically.

## Features

- **Smart workspace launcher** — fzf popup to browse and open projects
- **Auto-detection** — recognizes Java, Python, Node, Rust, Go, Docker, and more
- **Layout engine** — each project type gets a tailored pane layout
- **Plugin system** — Git, Docker, README, Tasks auto-open in separate windows
- **CLI tool** — `termos open`, `termos doctor`, `termos install`
- **Event-driven** — plugins subscribe to events, core stays clean

## Quick Start

```bash
# Install
./install.sh

# Check dependencies
termos doctor

# Open workspace launcher (inside tmux)
termos open
```

## tmux Configuration

Add to your `~/.config/tmux/tmux.conf`:

```bash
# Set TermOS home
set-environment -g TERMOS_HOME ~/.config/termos

# Workspace launcher
bind p display-popup -w 75% -h 75% -E "termos open"
```

Then press `Ctrl+Space p` to open the launcher.

## Project Structure

```
termOS/
├── bin/termos              # CLI entry point
├── config/
│   ├── termos.conf         # Configuration
│   └── tmux.conf           # tmux config
├── src/
│   ├── core/               # Bootstrap, logger, config, events
│   ├── workspace/          # Launcher, detector, builder
│   ├── layouts/            # Layout per project type
│   ├── plugins/            # Auto-detect & open tools
│   └── cli/                # CLI commands
├── install.sh
├── uninstall.sh
└── Makefile
```

## CLI Commands

| Command | Description |
|---------|-------------|
| `termos open` | Open workspace launcher |
| `termos doctor` | Check dependencies |
| `termos install` | Install dependencies |
| `termos update` | Reload configuration |
| `termos list` | List active sessions |
| `termos version` | Show version |

## Dependencies

**Required:** tmux (3.2+), fzf

**Recommended:** neovim, zoxide, yazi, lazygit, glow, btop, zsh

## License

MIT
