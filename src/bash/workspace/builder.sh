#!/usr/bin/env bash

###########################################################
#
# builder.sh
#
# Monta o workspace: cria sessão, aplica layout, registra
# plugins como handlers de eventos e dispara o ciclo.
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
    _builder::_register_plugins

    events::emit "workspace::created" "$session" "$dir" "$type"

    _builder::_focus_first_window "$session"
}

# Escolhe e executa o layout.
#
# A função é invocada como condição de `||`, o que desativa
# `set -e` dentro dela: uma falha parcial do layout não
# derruba o CLI nem deixa a sessão pela metade.
_builder::_apply_layout() {
    local requested="$1"
    local session="$2"
    local dir="$3"
    local type="$requested"

    if ! _builder::_load_layout "$type"; then
        type="default"
        if ! _builder::_load_layout "default"; then
            logger::warn "Nenhum layout encontrado, usando sessão limpa"
            return 0
        fi
        logger::debug "Layout '$requested' inexistente, usando default"
    fi

    logger::debug "Aplicando layout: layout::$type"

    "layout::${type}" "$session" "$dir" \
        || logger::warn "Layout '$type' falhou"
}

# Sourceia o arquivo de layout e garante que a função
# correspondente exista. Retorna 0 apenas se existir.
_builder::_load_layout() {
    local type="$1"
    local layout_file="$TERMOS_LAYOUTS_DIR/${type}.sh"

    if declare -F "layout::${type}" >/dev/null 2>&1; then
        return 0
    fi

    if [[ -f "$layout_file" ]]; then
        logger::debug "Carregando layout: $layout_file"
        # shellcheck source=/dev/null
        source "$layout_file"
    fi

    declare -F "layout::${type}" >/dev/null 2>&1
}

_builder::_register_plugins() {
    local plugin plugin_name

    events::off "workspace::created"

    for plugin in "$TERMOS_PLUGINS_DIR"/*.sh; do
        [[ -f "$plugin" ]] || continue
        plugin_name=$(basename "$plugin" .sh)

        if ! declare -F "plugin::${plugin_name}" >/dev/null 2>&1; then
            # shellcheck source=/dev/null
            source "$plugin"
        fi

        if declare -F "plugin::${plugin_name}" >/dev/null 2>&1; then
            events::on "workspace::created" "plugin::${plugin_name}"
        else
            logger::warn "Plugin inválido: $plugin_name"
        fi
    done
}

_builder::_focus_first_window() {
    local session="$1"
    local window

    window=$(tmux::first_window "$session" 2>/dev/null) || return 0
    tmux::select_window "$session" "$window"
}
