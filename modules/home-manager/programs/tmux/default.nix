#
#  Terminal multiplexer
#
{
  pkgs,
  vars,
  lib,
  config,
  host,
  ...
}: let
  configFilesToLink = {
    "tmux/config.yaml" = ./config/config.yaml;
    "tmux/statusline.conf" = ./config/statusline.conf;
    # "tmux/tmux.conf" = ./config/tmux.conf;
    "tmux/utility.conf" = ./config/utility.conf;
    "tmux/util" = ./config/util;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};

  defaultCommand =
    if host.hostName == "hht"
    then "${pkgs.zsh}/bin/zsh"
    else "${pkgs.fish}/bin/fish";
in
  with lib; {
    options.tmux = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          mdDoc
          ''
            Enable the Git package.
          '';
      };
    };

    config = mkIf config.tmux.enable {
      programs = {
        tmux = {
          enable = true;
          extraConfig = ''
            # plugins
            set -g @plugin 'tmux-plugins/tpm'
            set -g @plugin 'catppuccin/tmux'
            set -g @plugin 'alexwforsythe/tmux-which-key'
            set -g @plugin 'omerxx/tmux-sessionx'
            set -g @plugin 'sainnhe/tmux-fzf'
            # copy config.yaml to ./plugins/tmux-which-key if it exists
            if-shell "! test -f ~/.config/tmux/plugins/tmux-which-key/config.yaml" "run-shell 'ln -s ~/.config/tmux/config.yaml ~/.config/tmux/plugins/tmux-which-key/config.yaml'" "run-shell 'rm ~/.config/tmux/plugins/tmux-which-key/config.yaml ; ln -s ~/.config/tmux/config.yaml ~/.config/tmux/plugins/tmux-which-key/config.yaml'"

            set -g default-terminal "tmux-256color"
            set -ga terminal-overrides ',*:Tc' # this is for 256 color
            set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q' # this is for the cursor shape
            set -g default-command ${defaultCommand}
            set -g status-position top
            set-option -g repeat-time 0
            set-option -g focus-events on
            # set-option -g set-clipboard on
            set-option -g mouse off
            set-option -g detach-on-destroy off

            set-window-option -g mode-keys vi

            #### basic settings

            set-option -g status-justify "left"
            #set-option utf8-default on
            #set-option -g mouse-select-pane
            set-window-option -g mode-keys vi
            #set-window-option -g utf8 on
            # look'n feel
            set-option -g status-fg cyan
            set-option -g status-bg black
            set -g pane-active-border-style fg=colour166,bg=default
            set -g window-style fg=colour10,bg=default
            set -g window-active-style fg=colour12,bg=default
            set-option -g history-limit 64096

            set -sg escape-time 10

            #### COLOUR
            set -g @catppuccin_flavor 'mocha' # or frappe, macchiato, latte

            set -g @catppuccin_window_left_separator ""
            set -g @catppuccin_window_right_separator " "
            set -g @catppuccin_window_middle_separator " █"
            set -g @catppuccin_window_number_position "right"

            set -g @catppuccin_window_default_fill "number"
            set -g @catppuccin_window_default_text "#W"

            set -g @catppuccin_window_current_fill "number"
            set -g @catppuccin_window_current_text "#W"

            set -g @catppuccin_status_modules_right "directory user host session"
            set -g @catppuccin_status_left_separator  " "
            set -g @catppuccin_status_right_separator ""
            set -g @catppuccin_status_right_separator_inverse "no"
            set -g @catppuccin_status_fill "icon"
            set -g @catppuccin_status_connect_separator "no"

            set -g @catppuccin_directory_text "#{pane_current_path}"

            #### sessionx
            # Window mode can be turned on so that the default layout
            # Has all the windows listed rather than sessions only
            set -g @sessionx-window-mode 'off'
            # Tree mode can be enabled which means that instead of a preview,
            # a hierarchy of sessions and windows will be shown
            set -g @sessionx-tree-mode 'off'
            set -g @sessionx-layout 'reverse'
            set -g @sessionx-prompt " "
            set -g @sessionx-pointer "▶ "
            set -g @sessionx-zoxide-mode 'on'
            # If you're running fzf lower than 0.35.0 there are a few missing features
            # Upgrade, or use this setting for support
            set -g @sessionx-legacy-fzf-support 'off'

            # import
            if-shell "uname -s | grep -q Moritz" "source ~/.config/tmux/macos.conf"

            #source ~/.config/tmux/statusline.conf
            source ~/.config/tmux/utility.conf

            # initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
            if "test ! -d ~/.tmux/plugins/tpm" \
               "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"
            run '~/.tmux/plugins/tpm/tpm'
          '';
        };
      };
      xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
    };
  }
