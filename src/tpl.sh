#!/usr/bin/env bash
# tpl

readonly VERSION=0.5.0

readonly TPL_BASE=/usr/share/tpl
readonly TPL_TEMP_DIR=${TPL_BASE}/templates
readonly TPL_BASE_HOME=~/.config/tpl
readonly TPL_TEMP_DIR_HOME=${TPL_BASE_HOME}/templates/

declare -a targets

usage() {
  cat << EOF
tpl - template creator

Usage: $0 [-f | -h | -l | -v] <base.extension | extension>

-f, --force     Overwrite existing file
-h, --help      Show this message
-l, --list      List available extensions
-v, --version   Display version

If no basename is given but only an extension, the template is printed on
stdout.

Custom templates can be added to \$HOME/.config/tpl/templates.
Default config can be found at /usr/share/tpl/config and can be overwritten at
\$HOME/.config/tpl/config
EOF
}

version() {
  cat << EOF
tpl v${VERSION}
MIT License
Copyright (c) 2023 nyped
EOF
}

fail() {
  echo -e "$1" >&2
  exit "${2:-255}"
}

write() {
  [[ -f $2 && "$force" != 1 ]] && fail "File '$2' exists." 253
  envsubst < "$1" > "$2"
}

perms() {
  chmod "${perms[$2]}" "$1" &> /dev/null || true
}

find_template() {
  if [[ -f ${TPL_TEMP_DIR_HOME}/$1 ]]; then
    TEMPLATE="${TPL_TEMP_DIR_HOME}/$1"
  elif [[ -f ${TPL_TEMP_DIR}/$1 ]]; then
    TEMPLATE="${TPL_TEMP_DIR}/$1"
  else
    fail "Missing '$1' template" 254
  fi
}

read_conf() {
  declare -Ag perms

  # shellcheck source=/dev/null
  source /usr/share/tpl/config
  # shellcheck source=/dev/null
  [[ -f ~/.config/tpl/config ]] && source ~/.config/tpl/config
}

for arg do
  case "$arg" in
    -h | --help)
      usage
      exit 0
      ;;

    -v | --version)
      version
      exit 0
      ;;

    -f | --force)
      force=1
      ;;

    -l | --list)
      {
        ls $TPL_TEMP_DIR
        ls $TPL_TEMP_DIR_HOME
      } 2>/dev/null | sort | uniq
      exit 0
      ;;

    *)
      targets+=("$arg")
      ;;
  esac
done

[[ ${#targets[@]} == 0 ]] && {
  usage
  exit 253
}

read_conf

for target in "${targets[@]}"; do
  ext=""

  case "$target" in
    *.)  # trailing dot (no extension)
      fail "not extension given" 255
      ;;

    *.*)  # base and ext
      out="$target" ext="${target##*.}"
      base="$(basename "$target")" base="${base%.*}"
      export TITLE="$base"
      ;;

    *)  # no dot, assuming extension only
      ext="$target" out=/dev/stdout
      force=1  # force write for vim
      export TITLE=dummy
      ;;
  esac

  find_template "$ext"
  write "$TEMPLATE" "$out"
  perms "$out" "$ext"
done

# vim: set ts=2 sts=2 sw=2 et :
