#!/usr/bin/env bash

###########################################################
#
# tmux.sh
#
# Único ponto do TermOS que conhece a sintaxe de alvos do
# tmux. Todas as chamadas passam por aqui para que layouts
# e plugins funcionem com qualquer `base-index` /
# `pane-base-index` (0 ou 1).
#
# API:
#
#   tmux::available
#   tmux::server_up
#   tmux::version
#   tmux::first_window "session"            -> índice
#   tmux::active_pane "session" "window"    -> pane_id
#   tmux::rename_window "session" "nome"
#   tmux::send_text  "pane_id" "texto"
#   tmux::send_enter "pane_id"
#   tmux::run        "pane_id" "comando"
#   tmux::split_h    "pane_id" "dir"        -> pane_id
#   tmux::split_v    "pane_id" "dir"        -> pane_id
#   tmux::select_layout "session" "window" "layout"
#   tmux::focus      "pane_id"
#   tmux::new_window "session" "nome" "dir" -> pane_id
#   tmux::select_window "session" "window"
#
###########################################################

tmux::available() {
    command -v tmux &>/dev/null
}

tmux::server_up() {
    tmux::available && tmux list-sessions &>/dev/null
}

tmux::version() {
    tmux -V 2>/dev/null | tr -dc '0-9.' | sed 's/\.$//'
}

# Primeiro (menor) índice de janela da sessão. Independente
# de base-index.
tmux::first_window() {
    local session="$1"
    local index

    index=$(tmux list-windows -t "$session" -F '#{window_index}' 2>/dev/null | sort -n | head -n 1)

    if [[ -z "$index" ]]; then
        return 1
    fi

    printf '%s\n' "$index"
}

# pane_id da janela ativa de uma sessão/janela.
tmux::active_pane() {
    local session="$1"
    local window="$2"

    tmux display-message -p -t "$session:$window" '#{pane_id}' 2>/dev/null
}

tmux::rename_window() {
    local session="$1"
    local name="$2"
    local window

    window=$(tmux::first_window "$session") || return 1
    tmux rename-window -t "$session:$window" "$name"
}

# Escreve texto literalmente (sem interpretar nomes de teclas).
tmux::send_text() {
    local target="$1"
    local text="$2"

    tmux send-keys -t "$target" -l "$text"
}

tmux::send_enter() {
    local target="$1"
    tmux send-keys -t "$target" C-m
}

# Envia um comando e confirma com Enter.
tmux::run() {
    local target="$1"
    local command="$2"

    tmux::send_text "$target" "$command"
    tmux::send_enter "$target"
}

tmux::split_h() {
    local target="$1"
    local dir="${2:-}"

    local args=(-h -P -F '#{pane_id}' -t "$target")
    [[ -n "$dir" ]] && args+=(-c "$dir")

    tmux split-window "${args[@]}" 2>/dev/null
}

tmux::split_v() {
    local target="$1"
    local dir="${2:-}"

    local args=(-v -P -F '#{pane_id}' -t "$target")
    [[ -n "$dir" ]] && args+=(-c "$dir")

    tmux split-window "${args[@]}" 2>/dev/null
}

# Aplica um layout do tmux. O quarto parâmetro opcional define
# o tamanho do main pane (ex.: "60%") — sem isso o tmux usa o
# default de 80 colunas e espreme os demais panes em telas
# menores que 80.
tmux::select_layout() {
    local session="$1"
    local window="$2"
    local layout="$3"
    local main_size="${4:-}"

    if [[ -n "$main_size" ]]; then
        case "$layout" in
            main-horizontal)
                tmux set -w -t "$session:$window" main-pane-height "$main_size" 2>/dev/null
                ;;
            main-vertical)
                tmux set -w -t "$session:$window" main-pane-width "$main_size" 2>/dev/null
                ;;
        esac
    fi

    tmux select-layout -t "$session:$window" "$layout" 2>/dev/null
}

tmux::focus() {
    local target="$1"
    tmux select-pane -t "$target" 2>/dev/null
}

tmux::select_window() {
    local session="$1"
    local window="$2"
    tmux select-window -t "$session:$window" 2>/dev/null
}

tmux::new_window() {
    local session="$1"
    local name="$2"
    local dir="${3:-}"

    local args=(new-window -t "$session" -n "$name" -P -F '#{pane_id}')
    [[ -n "$dir" ]] && args+=(-c "$dir")

    tmux "${args[@]}" 2>/dev/null
}
