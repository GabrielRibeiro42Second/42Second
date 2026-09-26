# TermOS

Um sistema de estudos para tmux focado em quem precisa de organização e disciplina.

## O que é o TermOS?

TermOS é um gerenciador de workspaces. Pressione uma tecla e tenha o layout necessário para o projeto selecionado — com dashboard em TUI, relatório de saúde e detector de linguagem compartilhado entre Bash e Lua.

## Features

- **Dashboard em TUI** — `termos dashboard`, interface em Bubble Tea com lista, filtro e detalhes do projeto
- **Launcher inteligente** — popup do fzf para navegar e abrir projetos
- **Auto-detecção** — reconhece Java, Python, Node, Rust, Go, Docker e mais
- **Motor de layout** — cada tipo de projeto recebe um layout de painéis personalizado
- **Sistema de plugins** — Git, Docker, README e Tarefas se abrem automaticamente em janelas separadas
- **Relatório de saúde** — `termos report` roda o pipeline Lua (scanner → inspector → presenter)
- **CLI completa** — `open`, `dashboard`, `start`, `report`, `doctor`, `install`, `update`, `list`
- **Orientado a eventos** — plugins assinam eventos, o núcleo permanece limpo

## Quick Start

```bash
# Compilar o dashboard (uma vez)
make build

# Instalar
./install.sh

# Checando dependências
termos doctor

# Abrindo o dashboard
termos dashboard

# Abrindo projetos (dentro do tmux)
termos open
```

## tmux Configs

Adicione ao seu `~/.config/tmux/tmux.conf`:

```bash
# TermOS na home
set-environment -g TERMOS_HOME ~/.config/termos

# Workspace launcher
bind p display-popup -w 75% -h 75% -E "termos open"

# Dashboard TUI
bind d display-popup -w 90% -h 85% -E "termos dashboard"
```

Pressione `Ctrl+Space p` para abrir o Launcher.

## Project Structure

```
termOS/
├── bin/
│   ├── termos              # CLI entry point (bash)
│   └── termos-tui          # Dashboard (Go + Bubble Tea)
├── config/
│   ├── termos.conf         # Configuração
│   └── tmux.conf           # Tema tmux (Solarized Osaka)
├── src/
│   ├── bash/
│   │   ├── core/           # bootstrap, logger, config, events, tmux…
│   │   ├── workspace/      # launcher, detector, builder
│   │   ├── layouts/        # layout por tipo de projeto
│   │   ├── plugins/        # git, docker, readme, tasks
│   │   └── cli/            # comandos do CLI
│   ├── lua/                # pipeline de relatório (scanner→presenter)
│   └── go/                 # dashboard TUI + testes
├── tests/                  # suite Lua
├── install.sh
├── uninstall.sh
└── Makefile
```

## CLI Commands

| Command | Description |
|---------|-------------|
| `termos open` | Open workspace launcher (fzf) |
| `termos dashboard` | Dashboard em TUI (Bubble Tea) |
| `termos start <dir>` | Abrir/conectar um workspace |
| `termos report [dir]` | Relatório de saúde do projeto |
| `termos doctor` | Check dependencies |
| `termos install` | Install dependencies |
| `termos update` | Reload configuration |
| `termos list` | List active sessions |
| `termos version` | Show version |

## Development

```bash
make test      # suite Lua + suite Go
make test-go   # só Go
make lint      # shellcheck
make build     # compila bin/termos-tui
```

## Dependencies

**Required:** tmux (3.2+), fzf

**Recommended:** neovim, zoxide, yazi, lazygit, glow, btop, zsh, lua + luafilesystem (para `termos report`)

**To build:** go 1.25+

## License

MIT
