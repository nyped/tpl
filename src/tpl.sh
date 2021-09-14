#!/usr/bin/env bash
# tpl
# Fri Apr  9 11:45:30 PM CEST 2021
# lennypeers

readonly VERSION=0.4

TPL_BASE=/usr/share/tpl
TPL_TEMP_DIR=${TPL_BASE}/templates
TPL_BASE_HOME=~/.config/tpl
TPL_TEMP_DIR_HOME=${TPL_BASE_HOME}/templates/

declare -a TARGETS

fail() {
  echo -e "$1" >&2
  exit ${2:-255}
}

usage() {
  cat << EOF
Usage: tpl <cmd | [-f | --force] files>
Available commands:
-h, --help      Show this message
-v, --version   Display misc infos

-f, --force     Overwrite existing file

Where filenams are in Makefile or README,
or of the format BASE.EXT, with EXT in:
c
h
py
sh
zsh
md

Custom templates can be added to ~/.config/tpl/templates.
Default config can be found at /usr/share/tpl/config and
can be overwritten in ~/.config/tpl/config
EOF
}

infos() {
  cat << EOF
tpl v${VERSION}
MIT License
Copyright (c) 2021 lennypeers
EOF
}

write() {
  [[ -f $2 && "$FORCE" != 1 ]] && fail "File $2 exists." 1
  envsubst < "$1" > "$2"
  perms "$2" "$3"
}

perms() {
  for ex in "${!perms[@]}"; do
    if [[ $ex == $2 ]]; then
      chmod ${perms[$ex]} "$1"
      return
    fi
  done
}

find_template() {
  NAME="$2.$1" NAME="${NAME##.}"

  [[ -f ${TPL_TEMP_DIR_HOME}/$1 ]] &&
    TEMPLATE="${TPL_TEMP_DIR_HOME}/$1"

  [[ -f ${TPL_TEMP_DIR}/$1 ]] &&
    TEMPLATE="${TPL_TEMP_DIR}/$1"

  [[ -z $TEMPLATE ]] && fail "Missing $1 template" 254
}

read_conf() {
  declare -ag globals
  declare -Ag perms

  source /usr/share/tpl/config
  [[ -f ~/.config/tpl/config ]] && \
    source ~/.config/tpl/config

  for glob in ${globals[@]}; do
    eval content="\$${glob}"
    export "$glob=$content"
  done
}

set_title() {
  export TITLE=" ${1}" TITLE_CAP="${1^^}"
}

while [[ -n $1 ]]; do
  case "$1" in
    -h | --help)
      usage
      exit 0
    ;;

    -v | --version)
      infos
      exit 0
    ;;

    -f | --force)
      FORCE=1
    ;;

    [Mm]akefile | [Mm]ake)
      TARGETS+=(.Makefile)
    ;;

    README)
      TARGETS+=(.README)
    ;;

    *.*)
      TARGETS+=("$1")
    ;;

    *)
      usage >&2
      exit 255
    ;;
  esac

  shift
done

[[ ${#TARGETS[@]} == 0 ]] && fail "No file given" 253

read_conf

for file in "${TARGETS[@]}"; do
  IFS=. read -r BASE EXT <<< "$file"
  set_title "$BASE"
  find_template "$EXT" "$BASE"
  write "$TEMPLATE" "$NAME" "$EXT"
  BASE= EXT=
done

# vim: set ts=2 sts=2 sw=2 et :
