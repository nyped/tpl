#!/usr/bin/env bash
# tpl
# Fri Apr  9 11:45:30 PM CEST 2021
# lennypeers

readonly VERSION=0.1

fail() {
  echo -e "$1" >&2
  exit ${2:-255}
}

usage() {
  cat << EOF
Usage: tpl <cmd | filename>
Available commands:
-h, --help      Show this message
-v, --version   Display misc infos

Where filename is Makefile,
or of the format BASE.EXT,
with EXT in:
c
h
py
sh
md
make
EOF
}

infos() {
  cat << EOF
tpl v${VERSION}
MIT License
Copyright (c) 2021 lennypeers
EOF
}

# wraps a variable with two strings
# wrap var_name left_string right_string
wrap() {
  local content
  eval content="\$${1}"
  export "${1}=${2:-}${content}${3:-}"
}

write() {
  [[ -f $2 && "$FORCE" != 1 ]] && fail "File $2 exists." 1
  envsubst < "$1" > "$2"
  perms "$2"
}

perms() {
  case "$1" in
    *.sh | *.py)
      chmod +x "$1"
      ;;
  esac
}

find_template() {
  case "$1" in
    cmain | c_main | cm | [cC])
      TEMPLATE="${TPL_TEMP_DIR}"/c_main.c
      NAME="$2".c
      ;;

    cheader | c_header | ch)
      TEMPLATE="${TPL_TEMP_DIR}"/c_header.h
      NAME="$2".h
      ;;

    [Mm]akefile | [Mm]ake)
      TEMPLATE="${TPL_TEMP_DIR}"/c_Makefile
      NAME=Makefile
      ;;

    [Pp]ython | [Pp]y)
      TEMPLATE="${TPL_TEMP_DIR}"/python.py
      NAME="$2".py
      ;;

    [bB]ash | [Ss]h | [Ss]hell)
      TEMPLATE="${TPL_TEMP_DIR}"/bash.sh
      NAME="$2".sh
      ;;

    [Zz]sh)
      TEMPLATE="${TPL_TEMP_DIR}"/zsh.sh
      NAME="$2".sh
      ;;

    [Mm]d | [Mm]arkdown)
      TEMPLATE="${TPL_TEMP_DIR}"/article.md
      NAME="$2".md
      ;;

    [Rr]eadme)
      TEMPLATE="${TPL_TEMP_DIR}"/git_readme.md
      NAME="$2".md
      ;;

    *)
      fail "Entry not found." 254
      ;;
  esac
}

set_vars() {
  source "${TPL_CONF}"

  export TITLE=" ${1}"
  export DATE=" $(date)"
  export TITLE_CAP="${1^^}"
}

find_tpl_dirs() {
  # TODO: check for conf somewhere else
  TPL_CONF=/usr/share/tpl/config
  TPL_TEMP_DIR=/usr/share/tpl/templates

  [[ -f ~/.config/tpl/config ]] && \
    TPL_CONF=~/.config/tpl/config
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
      [[ -n $FOUND ]] && fail "Only one file expected" 253
      EXT=make FOUND=1
    ;;

    *.*)
      [[ -n $FOUND ]] && fail "Only one file expected" 253
      FOUND=1
      IFS=. read -r BASE EXT <<< "$1"
    ;;

    *)
      usage >&2
      exit 255
    ;;
  esac

  shift
done

find_tpl_dirs
find_template "$EXT" "${BASE:-foobar}"
set_vars "${BASE:-foobar}"
write "$TEMPLATE" "$NAME"

# vim: set ts=2 sts=2 sw=2 et :
