# Layouts

Layouts define the pane arrangement for each project type.

## Available Layouts

### default
- Editor (main pane)
- File manager (right)
- Shell (bottom)

### java
- Editor (main pane)
- LazyGit (right)
- Shell (bottom)

### python
- Editor (main pane)
- LazyGit (right)
- Shell with venv auto-activation (bottom)

### node
- Editor (main pane)
- LazyGit (right)
- Shell (bottom)

## Creating a Layout

1. Create `src/layouts/mytype.sh`
2. Define the layout function:

```bash
layout::mytype() {
    local session="$1"
    local dir="$2"

    tmux rename-window -t "$session:1" "MyType"
    tmux send-keys -t "$session:1.1" "nvim ." C-m
    # ... more panes
}
```

The function receives:
- `$1` — session name
- `$2` — project directory
