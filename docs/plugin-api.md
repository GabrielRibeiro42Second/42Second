# Plugin API

Plugins are auto-executed for every workspace. They receive the session name and project directory.

## Creating a Plugin

1. Create `src/plugins/myplugin.sh`
2. Define the plugin function:

```bash
plugin::myplugin() {
    local session="$1"
    local dir="$2"

    # Only activate if condition is met
    [[ -f "$dir/somefile" ]] || return 0

    # Create a window
    tmux new-window -t "$session" -n "MyTool" -c "$dir"
    tmux send-keys -t "$session:MyTool" "my-tool" C-m
}
```

## Available Plugins

### git
Opens LazyGit if `.git` exists.

### docker
Opens docker compose logs if `docker-compose.yml` or `compose.yml` exists.

### readme
Opens README with glow if README.md exists.

### tasks
Opens TODO.md in editor if it exists.

## Plugin Lifecycle

Plugins are executed in alphabetical order after the layout is applied. Each plugin receives:
- `$1` — session name
- `$2` — project directory

A plugin should `return 0` early if its conditions aren't met.
