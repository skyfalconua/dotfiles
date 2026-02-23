# -- git -- -- --

_parse_git_branch () {
  git symbolic-ref -q --short HEAD 2>/dev/null
}

_parse_git_tag () {
  git describe --tags --exact-match 2>/dev/null
}

_parse_git_commit () {
  PAGER= git log -1 --format='%h' 2>/dev/null
}

_parse_git_dirty() {
  if [ -z "$(git status -s)" ]; then
    echo -n "%F{green}✓%F{reset_color}"
  else
    echo -n "%F{yellow}⚡%F{reset_color}"
  fi
}

# -- hg -- -- --

_parse_hg_branch () {
  hg branch 2>/dev/null
}

_parse_hg_dirty() {
  if [ -z "$(hg status 2>/dev/null)" ]; then
    echo -n "%F{green}✓%F{reset_color}"
  else
    echo -n "%F{yellow}⚡%F{reset_color}"
  fi
}

# -- git_or_hg -- -- --

_git_or_hg_branch () {
  local git_branch=`_parse_git_branch || _parse_git_tag || _parse_git_commit`
  if [ ! $git_branch = "" ]; then
    echo -n "±:$git_branch:"`_parse_git_dirty` && return
  fi

  local hg_branch=`_parse_hg_branch`
  if [ ! $hg_branch = "" ]; then
    echo -n "☿:$hg_branch:"`_parse_hg_dirty` && return
  fi

  echo -n "○" && return
}
