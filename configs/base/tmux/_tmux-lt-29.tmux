# ~/.tmux.conf

###########################################################################
# General options

# Default termtype. If the rcfile sets $TERM, that overrides this value.
# set -g default-terminal xterm-256color
# set -g default-terminal xterm-ghostty

# be quiet
set-option -g visual-activity off
set-option -g visual-bell off
set-option -g visual-silence off
set-option -g bell-action none
set-window-option -g monitor-activity off

# Watch for activity in background windows
setw -g monitor-activity on

# scrollback size
set -g history-limit 10000

# Start windows and panes at 1, not 0
set -g base-index 1
set -g pane-base-index 1
set -g renumber-windows on

# pass through xterm keys
set -g xterm-keys on

# Put status bar on top
set-option -g status-position top

# Update status bar content
set -g status-left " ⛋  "
set -g status-right " | #{host} "

# Update tab content
set -wg window-status-format " #I #W "
set -wg window-status-current-format "❱ #I #W "

###########################################################################
# General keymap

# Keep your finger on ctrl, or don't, same result
bind-key C-d detach-client
bind-key C-p paste-buffer

# Redraw the client (if interrupted by wall, etc)
bind R refresh-client

# reload tmux config
unbind r
bind r \
    source-file ~/.tmux.conf \;\
    display 'Reloaded tmux config.'

###########################################################################
# Window management / navigation

# open new tab
unbind c
bind-key t new-window
bind-key C-t new-window

# close tab
unbind x
bind-key q kill-window
bind-key C-q kill-window

# close pane
bind-key w kill-pane
bind-key C-w kill-pane

# move tab at start/end
bind-key o move-window -t 0
bind-key O move-window -t 99

# move tab to left/right
bind-key [ swap-window -t -1\; select-window -t -1
bind-key ] swap-window -t +1\; select-window -t +1

# C-Space (no prefix) to tab to next window
unbind C-Space
unbind -n C-Space
unbind Space
unbind -n Space

# next tab
bind-key n next-window
bind-key C-n next-window

# previous tab
bind-key p previous-window
bind-key C-p previous-window

###########################################################################
# Pane management / navigation

# Add vertical (right) split with v or C-v
unbind v
unbind C-v
bind-key v split-window -h -c "#{pane_current_path}"
bind-key C-v split-window -h -c "#{pane_current_path}"

# Add horizontal (bottom) split with h or C-h
unbind h
unbind C-h
bind-key h split-window -v -c "#{pane_current_path}"
bind-key C-h split-window -v -c "#{pane_current_path}"

# C-g C-k to passthrough a C-k
# C-k is consumed for pane navigation but we want it for kill-to-eol
unbind C-k
bind C-k send-key C-k

###########################################################################
# Mouse mode is on by default.
set -g mouse on

bind m \
    set -g mouse on \;\
    display "Mouse ON"

bind M \
    set -g mouse off \;\
    display "Mouse OFF"

###########################################################################
# Color scheme

# default statusbar colors
set-option -g status-fg colour15
set-option -g status-bg colour238

# default window title colors
set-window-option -g window-status-fg colour16
set-window-option -g window-status-bg colour67

# active window title colors
set-window-option -g window-status-current-fg colour15
set-window-option -g window-status-current-bg colour22

# background activity window title colors (fg <-> bg)
set-window-option -g window-status-activity-fg colour67
set-window-option -g window-status-activity-bg colour18

# pane border
set-option -g pane-border-fg white
set-option -g pane-active-border-fg green

# message text
set-option -g message-fg colour16
set-option -g message-bg colour11

# selection
set-window-option -g mode-style bg=colour81,fg=colour16

# set default shell
# set-option -g default-shell "/bin/zsh"
# set-option -g default-shell "/usr/local/bin/nu"
