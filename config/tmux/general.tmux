
# Reload tmux config
bind r source-file ~/.config/tmux/tmux.conf

# Set default terminal
# set -g default-terminal "tmux-256color"
set-option -ga terminal-overrides ",*:Tc"
# set-option -sa terminal-features ',tmux-256color:RGB'

# Set scrollback buffer to 10000
set -g history-limit 10000

# Set default shell in tmux
set -g default-shell /run/current-system/sw/bin/zsh

# Screen Saver
set -g lock-after-time 500
set -g lock-command "asciiquarium"

# Lower delay waiting for chord after escape key press.
set -g escape-time 10

# Binding prefix to CTRL+SPACE
unbind C-b
set -g prefix C-Space

# Start windows at 1, instead of 0    
set -g base-index 1 

# Clipboard bindings
bind-key y run "tmux save-buffer - | xclip -i sel clipboard"
bind-key p run "xclip -o | tmux load-buffer - ; tmux paste-buffer"

# Create bottom horizontal split-window
bind-key h run "tmux splitw -fv; tmux resize-pane -D 15"

## Use vim keybindings in copy mode
set-option -g mouse on
setw -g mode-keys vi
set-option -s set-clipboard off
bind P paste-buffer
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X rectangle-toggle
unbind -T copy-mode-vi Enter
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel 'xclip -se c -i'
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel 'xclip -se c -i'

# Set new panes to open in current directory
bind c new-window -c "#{pane_current_path}"
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
