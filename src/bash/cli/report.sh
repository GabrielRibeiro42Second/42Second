#!/usr/bin/env bash

###########################################################
#
# report.sh
#
# Roda o pipeline Lua (scanner → inspector → presenter) e
# imprime um relatório de saúde do projeto.
#
# Uso:
#
#   termos report [diretorio]
#
###########################################################

report::_lua_bin() {
    local candidate
    for candidate in lua lua5.4 lua5.3 lua5.1 luajit; do
        if command -v "$candidate" &>/dev/null; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done
    return 1
}

report::run() {
    local lua_bin
    if ! lua_bin=$(report::_lua_bin); then
        printf '\n  \033[0;33m⚠  Lua não encontrado (necessário para "termos report").\033[0m\n\n'
        return 1
    fi

    if ! "$lua_bin" -e 'require("lfs")' 2>/dev/null; then
        printf '\n  \033[0;33m⚠  luafilesystem (lfs) ausente.\033[0m\n'
        printf '  Arch: sudo pacman -S lua-filesystem\n\n'
        return 1
    fi

    local path="${1:-.}"
    if [[ ! -d "$path" ]]; then
        printf '\n  \033[0;31m✘  Diretório inexistente: %s\033[0m\n\n' "$path"
        return 1
    fi

    LUA_PATH="$TERMOS_LUA/?.lua;$TERMOS_LUA/?/init.lua;;" \
        "$lua_bin" "$TERMOS_LUA/cli/report.lua" "$path"
}
