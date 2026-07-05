# Architecture

## Overview

TermOS is organized as a modular bash framework with clear separation of concerns.

## Layers

```
CLI (bin/termos)
  └── Commands (src/cli/)
        └── Workspace Engine (src/workspace/)
              ├── Launcher (fzf popup)
              ├── Detector (project type)
              ├── Builder (session + layout + plugins)
              └── Core (src/core/)
                    ├── bootstrap.sh
                    ├── logger.sh
                    ├── config.sh
                    ├── filesystem.sh
                    ├── session.sh
                    ├── tmux.sh
                    └── events.sh
```

## Core Modules

### bootstrap.sh
Entry point for all scripts. Sets up environment variables and loads all core modules.

### logger.sh
Structured logging with levels: DEBUG, INFO, WARN, ERROR. Enable with `TERMOS_DEBUG=1`.

### config.sh
Loads `termos.conf` and provides `config::get`/`config::set` API.

### session.sh
tmux session management: create, switch, kill, list.

### tmux.sh
Low-level tmux operations: windows, splits, key sends.

### events.sh
Pub/sub event system. Plugins register handlers for events like `workspace::created`.

## Data Flow

```
User presses prefix+p
  → display-popup opens launcher.sh
    → fzf shows project list
    → User selects project
    → session::name_from_path creates session name
    → If session exists: switch to it
    → If not: builder::build
      → detector::detect determines type
      → session::create creates tmux session
      → layout file is sourced and applied
      → Each plugin file is sourced and executed
      → events::emit fires workspace::created
    → session::switch connects to new workspace
```

## Adding a Layout

1. Create `src/layouts/mytype.sh`
2. Define `layout::mytype() { ... }`
3. That's it. detector.sh will find it automatically.

## Adding a Plugin

1. Create `src/plugins/myplugin.sh`
2. Define `plugin::myplugin() { ... }`
3. The plugin receives `$session` and `$dir` as arguments.
4. It will be auto-loaded for every workspace.
