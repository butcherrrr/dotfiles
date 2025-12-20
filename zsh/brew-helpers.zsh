###############################################################################
# Homebrew Helper Functions
###############################################################################

# Interactive Homebrew search + install using fzf (API-based, no local scanning)
brewin() {
  command -v brew >/dev/null || { echo "brew not found"; return 1; }
  command -v fzf  >/dev/null || { echo "fzf not found"; return 1; }

  # Use bat if available, otherwise plain cat
  local pager_cmd='cat'
  command -v bat >/dev/null && pager_cmd='bat --plain --color=always'

  # macOS opener
  local opener="open"
  command -v open >/dev/null || opener="xdg-open"

  # Cache directory
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/brew-fzf"
  mkdir -p "$cache_dir"

  # Cache files (refresh daily)
  local formula_cache="$cache_dir/formulae.txt"
  local cask_cache="$cache_dir/casks.txt"

  # Update cache if older than 1 day or doesn't exist
  local cache_age=86400  # 1 day in seconds
  local now=$(date +%s)

  if [ ! -f "$formula_cache" ] || [ $((now - $(stat -f %m "$formula_cache" 2>/dev/null || echo 0))) -gt $cache_age ]; then
    echo "Updating formulae cache..."
    curl -s "https://formulae.brew.sh/api/formula.json" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for item in data:
    print(item['name'])
" > "$formula_cache" 2>/dev/null
  fi

  if [ ! -f "$cask_cache" ] || [ $((now - $(stat -f %m "$cask_cache" 2>/dev/null || echo 0))) -gt $cache_age ]; then
    echo "Updating casks cache..."
    curl -s "https://formulae.brew.sh/api/cask.json" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for item in data:
    print(item['token'])
" > "$cask_cache" 2>/dev/null
  fi

  # Start query (optional arg)
  local initial_query="${1:-}"

  # Pre-load all packages into fzf (no runtime filesystem access)
  local all_packages
  all_packages="$(
    cat "$formula_cache" 2>/dev/null | sed 's/^/formula\t/'
    cat "$cask_cache" 2>/dev/null | sed 's/^/cask\t/'
  )"

  # fzf list lines as: "<type>\t<name>"
  local out
  out="$(
    echo "$all_packages" | fzf --multi --ansi --query "$initial_query" \
      --prompt='brew ❯ ' \
      --delimiter=$'\t' --with-nth=2 \
      --header=$'enter: install  •  ctrl-y: copy name  •  ctrl-o: open homepage  •  ?: toggle preview' \
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
