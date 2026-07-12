# TermOS

Um sistema de estudos para tmux focado em quem precisa de organização e disciplina.

## Oque é o termOS?

TermOS é um gerenciador de workspaces. Precione uma tecla e tenho o layout necessario para o projeto selecionado.

## Features

- **Laucher de espaço de trabalho inteligente** 
— popup do fzf para navegar e abrir projetos 
- **Auto-detecção** — reconhece Java, Python, Node, Rust, Go, Docker e mais 
- **Motor de layout** — cada tipo de projeto recebe um layout de painéis personalizado 
- **Sistema de plugins** — Git, Docker, README, Tarefas se abrem automaticamente em janelas separadas 
- **Ferramenta CLI** — 'termos open', 'termos doctor', 'termos install' 
- **Orientado a eventos** — plugins assinam eventos, o núcleo permanece limpo

## Quick Start

```bash
# Install
./install.sh

# Checando dependencies
termos doctor

# Abrindo projetos (dentro do tmux)
termos open
```

## tmux Configs

Add to your `~/.config/tmux/tmux.conf`:

```bash
# TermOS na home
set-environment -g TERMOS_HOME ~/.config/termos

# Workspace launcher
bind p display-popup -w 75% -h 75% -E "termos open"
```

Precione `Ctrl+Space p` para abrir o Laucher

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
