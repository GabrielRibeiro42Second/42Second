#!/usr/bin/env bash

###########################################################
#
# builder.sh
#
# Monta o workspace: cria sessão, aplica layout, executa plugins.
#
# API:
#
#   builder::build "session_name" "project_dir"
#
###########################################################

builder::build() {
    local session="$1"
    local dir="$2"

    logger::info "Construindo workspace: $session"

    local type
    type=$(detector::detect "$dir")

    logger::debug "Tipo detectado: $type"

    session::create "$session" "$dir"

    _builder::_apply_layout "$type" "$session" "$dir"

    _builder::_run_plugins "$session" "$dir"

    tmux select-window -t "$session:1"

    events::emit "workspace::created" "$session" "$dir" "$type"
}

_builder::_apply_layout() {
    local type="$1"
    local session="$2"
    local dir="$3"

    local layout_file="$TERMOS_LAYOUTS_DIR/${type}.sh"

    if [[ ! -f "$layout_file" ]]; then
        layout_file="$TERMOS_LAYOUTS_DIR/default.sh"
    fi

    if [[ -f "$layout_file" ]]; then
        logger::debug "Aplicando layout: $layout_file"
        source "$layout_file"
        "layout::${type}" "$session" "$dir" 2>/dev/null || \
            layout::default "$session" "$dir"
    else
        logger::warn "Nenhum layout encontrado, usando session limpa"
    fi
}

_builder::_run_plugins() {
    local session="$1"
    local dir="$2"

    local plugin
    for plugin in "$TERMOS_PLUGINS_DIR"/*.sh; do
        [[ -f "$plugin" ]] || continue
        logger::debug "Executando plugin: $(basename "$plugin")"
        source "$plugin"
        local plugin_name
        plugin_name=$(basename "$plugin" .sh)
        "plugin::${plugin_name}" "$session" "$dir" 2>/dev/null || \
            logger::warn "Plugin falhou: $plugin_name"
    done
}
