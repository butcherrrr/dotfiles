###############################################################################
# Homebrew Helper Functions
###############################################################################

# Interactive Homebrew search + install using fzf
brewin() {
  command -v brew >/dev/null || { echo "brew not found"; return 1; }
  command -v fzf  >/dev/null || { echo "fzf not found"; return 1; }

  # Use bat if available, otherwise plain cat
  local pager_cmd='cat'
  command -v bat >/dev/null && pager_cmd='bat --plain --color=always'

  # macOS opener
  local opener="open"
  command -v open >/dev/null || opener="xdg-open"

  # Start query (optional arg)
  local initial_query="${1:-}"

  # fzf list lines as: "<type>\t<name>"
  # Live reload on every query change using {q}
  local out
  out="$(
    fzf --multi --ansi --phony --query "$initial_query" \
      --prompt='brew ❯ ' \
      --delimiter=$'\t' --with-nth=2 \
      --header=$'enter: install  •  ctrl-y: copy name  •  ctrl-o: open homepage  •  ?: toggle preview' \
      --bind "change:reload:
        (
          brew search --formula \"{q}\" 2>/dev/null | sed 's/^/formula\t/' ;
          brew search --cask    \"{q}\" 2>/dev/null | sed 's/^/cask\t/'
        )" \
      --preview-window=right:60%:border-left:hidden \
      --bind '?:toggle-preview' \
      --preview "
        if [ '{1}' = 'formula' ]; then
          brew info --formula '{2}' 2>/dev/null
        else
          brew info --cask '{2}' 2>/dev/null
        fi | $pager_cmd
      " \
      --bind "ctrl-y:execute-silent(echo -n '{2}' | pbcopy)+refresh-preview" \
      --bind "ctrl-o:execute-silent(
        url=\$(brew info --json=v2 --{1} '{2}' 2>/dev/null \
          | python3 - <<'PY'
import json,sys
j=json.load(sys.stdin)
# formulae or casks, take first item
k='formulae' if j.get('formulae') else 'casks'
item=j[k][0] if j.get(k) else {}
print(item.get('homepage',''))
PY
        );
        [ -n \"\$url\" ] && $opener \"\$url\" >/dev/null 2>&1
      )+refresh-preview"
  )" || return 0

  # Install selected items
  echo "$out" | while IFS=$'\t' read -r kind name; do
    [ -z "$name" ] && continue
    if [ "$kind" = "cask" ]; then
      echo "→ brew install --cask $name"
      brew install --cask "$name"
    else
      echo "→ brew install $name"
      brew install "$name"
    fi
  done
}

# Interactive Homebrew uninstall using fzf
brewrm() {
  command -v brew >/dev/null || { echo "brew not found"; return 1; }
  command -v fzf  >/dev/null || { echo "fzf not found"; return 1; }

  # Use bat if available, otherwise cat
  local pager_cmd='cat'
  command -v bat >/dev/null && pager_cmd='bat --plain --color=always'

  local out
  out="$(
    (
      brew list --formula 2>/dev/null | sed 's/^/formula\t/'
      brew list --cask    2>/dev/null | sed 's/^/cask\t/'
    ) | fzf --multi --ansi \
      --prompt='brew rm ❯ ' \
      --delimiter=$'\t' --with-nth=2 \
      --header=$'enter: uninstall  •  ctrl-r: cleanup  •  ?: toggle preview' \
      --preview-window=right:60%:border-left:hidden \
      --bind '?:toggle-preview' \
      --preview "
        if [ '{1}' = 'formula' ]; then
          brew info --formula '{2}' 2>/dev/null
        else
          brew info --cask '{2}' 2>/dev/null
        fi | $pager_cmd
      " \
      --bind "ctrl-r:execute(brew cleanup)+reload(
        (brew list --formula 2>/dev/null | sed 's/^/formula\t/'; brew list --cask 2>/dev/null | sed 's/^/cask\t/')
      )"
  )" || return 0

  # Uninstall selected items
  echo "$out" | while IFS=$'\t' read -r kind name; do
    [ -z "$name" ] && continue
    if [ "$kind" = "cask" ]; then
      echo "→ brew uninstall --cask $name"
      brew uninstall --cask "$name"
    else
      echo "→ brew uninstall $name"
      brew uninstall "$name"
    fi
  done
}
