###############################################################################
# Git Helper Functions
###############################################################################

# Interactive git branch checkout using fzf
gbf() {
  git branch --all \
    | sed 's/^..//' \
    | fzf --preview 'git log -1 --color=always {}' \
      --preview-window=right:60%:border-left:hidden \
      --bind '?:toggle-preview' \
    | xargs git checkout
}

# Interactive git log viewer using fzf
glf() {
  git log --oneline --color=always \
    | fzf --ansi --preview 'COLUMNS=$FZF_PREVIEW_COLUMNS git show --color=always {1} | delta --width $FZF_PREVIEW_COLUMNS' \
      --preview-window=right:60%:border-left:hidden \
      --bind '?:toggle-preview'
}