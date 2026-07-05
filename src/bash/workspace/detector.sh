#!/usr/bin/env bash

###########################################################
#
# detector.sh
#
# Detecta o tipo de projeto com base em arquivos presentes.
#
# API:
#
#   detector::detect "project_dir"
#
# Retorna uma string com o tipo:
#   java, python, node, rust, go, docker, make, default
#
###########################################################

detector::detect() {
    local dir="$1"
    local type="default"

    detector::_has "$dir" "pom.xml"          && type="java"   && echo "$type" && return
    detector::_has "$dir" "build.gradle"     && type="java"   && echo "$type" && return
    detector::_has "$dir" "build.gradle.kts" && type="java"   && echo "$type" && return
    detector::_has "$dir" "pyproject.toml"   && type="python" && echo "$type" && return
    detector::_has "$dir" "setup.py"         && type="python" && echo "$type" && return
    detector::_has "$dir" "requirements.txt" && type="python" && echo "$type" && return
    detector::_has "$dir" "package.json"     && type="node"   && echo "$type" && return
    detector::_has "$dir" "Cargo.toml"       && type="rust"   && echo "$type" && return
    detector::_has "$dir" "go.mod"           && type="go"     && echo "$type" && return
    detector::_has "$dir" "Makefile"         && type="make"   && echo "$type" && return
    detector::_has "$dir" "CMakeLists.txt"   && type="cmake"  && echo "$type" && return
    detector::_has "$dir" "justfile"         && type="just"   && echo "$type" && return
    detector::_has "$dir" "Dockerfile"       && type="docker" && echo "$type" && return

    echo "$type"
}

detector::_has() {
    local dir="$1"
    local file="$2"
    [[ -f "$dir/$file" ]]
}

detector::is_dotfiles() {
    local dir="$1"
    local basename
    basename=$(basename "$dir")
    [[ "$basename" == ".config" || "$basename" == "dotfiles" || "$basename" == "Dotfiles" ]]
}

detector::is_learning() {
    local dir="$1"
    local basename
    basename=$(basename "$dir" | tr '[:upper:]' '[:lower:]')
    [[ "$basename" == *"estudo"* || "$basename" == *"course"* || "$basename" == *"cs50"* || "$basename" == *"roadmap"* ]]
}
