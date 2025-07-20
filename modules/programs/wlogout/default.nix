{
  pkgs,
  config,
  lib,
  vars,
  host,
  animated-wallpaper,
  ...
}: let
  # if ./config/secrets exists, add it to the configFilesToLink
  configFilesToLink = {
    "wlogout/icons/hibernate.png" = ./icons/hibernate.png;
    "wlogout/icons/lock.png" = ./icons/lock.png;
    "wlogout/icons/logout.png" = ./icons/logout.png;
    "wlogout/icons/reboot.png" = ./icons/reboot.png;
    "wlogout/icons/shutdown.png" = ./icons/shutdown.png;
    "wlogout/icons/suspend.png" = ./icons/suspend.png;
  };
  # Function to help map attrs for symlinking home.file, xdg.configFile
  # e.g. from { ".hgrc" = ./hgrc; } to { ".hgrc".source = ./hgrc; }
  toSource = configDirName: dotfilesPath: {source = dotfilesPath;};
  hvr = "4";
  mgn = "10";
  animatedWallpaperPkg = animated-wallpaper.packages.${pkgs.system}.default;
  enableAnimatedWallpaper =
    if host.hostName == "asahi"
    then false
    else true;
in
  with lib; {
    options.wlogout = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          Enable wlogout configuration.
        '';
      };
    };

    config = mkIf config.wlogout.enable {
      home-manager.users.${vars.user} = {
        programs = {
          wlogout = {
            enable = true;
            layout = [
              {
                label = "lock";
                action =
                  if enableAnimatedWallpaper
                  then "${animatedWallpaperPkg}/bin/hyprlock"
                  else "hyprlock";
                text = "Lock";
                keybind = "l";
              }
              {
                label = "logout";
                action = "loginctl terminate-user $USER";
                text = "Logout";
                keybind = "e";
              }
              {
                label = "suspend";
                action = "systemctl suspend";
                text = "Suspend";
                keybind = "u";
              }
              {
                label = "shutdown";
                action = "systemctl poweroff";
                text = "Shutdown";
                keybind = "s";
              }
              {
                label = "hibernate";
                action = "systemctl hibernate";
                text = "Hibernate";
                keybind = "h";
              }
              {
                label = "reboot";
                action = "systemctl reboot";
                text = "Reboot";
                keybind = "r";
              }
            ];
            style = ''
              @define-color base   #1e1e2e;
              @define-color mantle #181825;
              @define-color crust  #11111b;

              @define-color text     #cdd6f4;
              @define-color subtext0 #a6adc8;
              @define-color subtext1 #bac2de;

              @define-color surface0 #313244;
              @define-color surface1 #45475a;
              @define-color surface2 #585b70;

              @define-color overlay0 #6c7086;
              @define-color overlay1 #7f849c;
              @define-color overlay2 #9399b2;

              @define-color blue      #89b4fa;
              @define-color lavender  #b4befe;
              @define-color sapphire  #74c7ec;
              @define-color sky       #89dceb;
              @define-color teal      #94e2d5;
              @define-color green     #a6e3a1;
              @define-color yellow    #f9e2af;
              @define-color peach     #fab387;
              @define-color maroon    #eba0ac;
              @define-color red       #f38ba8;
              @define-color mauve     #cba6f7;
              @define-color pink      #f5c2e7;
              @define-color flamingo  #f2cdcd;
              @define-color rosewater #f5e0dc;

              * {
                  background-image: none;
                  font-size: 24px;
              }

              window {
                  background-color: transparent;
              }

              button {
                  color: @text;
                  background-color: alpha(@surface0, 0.7);
                  border-style: solid;
                  border-width: 1px;
                  background-repeat: no-repeat;
                  background-position: center;
                  background-size: 20%;
                  border-radius: 0px;
                  border-color: @overlay0;
                  box-shadow: none;
                  text-shadow: none;
                  animation: gradient_f 20s ease-in infinite;
              }

              button:focus {
                  background-color: @surface2;
                  background-size: 30%;
                  border-color: @mauve;
                  border-radius: 6px;
              }

              button:hover {
                  background-color: @surface2;
                  background-size: 40%;
                  animation: gradient_f 20s ease-in infinite;
                  transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
                  border-color: @mauve;
                  border-radius: 6px;
              }

              button:hover#lock {
                  border-radius: 4px;
                  margin : ${hvr}px 0px ${hvr}px ${mgn}px;
              }

              button:hover#logout {
                  border-radius: 4px;
                  margin : ${hvr}px 0px ${hvr}px ${mgn}px;
              }

              button:hover#suspend {
                  border-radius: 4px;
                  margin : ${hvr}px 0px ${hvr}px 0px;
              }

              button:hover#shutdown {
                  border-radius: 4px;
                  margin : ${hvr}px 0px ${hvr}px 0px;
              }

              button:hover#hibernate {
                  border-radius: 4px;
                  margin : ${hvr}px ${mgn}px ${hvr}px 0px;
              }

              button:hover#reboot {
                  border-radius: 4px;
                  margin : ${hvr}px ${mgn}px ${hvr}px 0px;
              }

              #lock {
                  background-image: image(url("icons/lock.png"));
                  border-radius: 4px 0px 0px 4px;
                  margin : ${mgn}px 0px ${mgn}px ${mgn}px;
              }

              #logout {
                  background-image: image(url("icons/logout.png"));
                  border-radius: 0px 0px 0px 0px;
                  margin : ${mgn}px 0px ${mgn}px ${mgn}px;
              }

              #suspend {
                  background-image: image(url("icons/suspend.png"));
                  border-radius: 0px 0px 0px 0px;
                  margin : ${mgn}px 0px ${mgn}px 0px;
              }

              #shutdown {
                  background-image: image(url("icons/shutdown.png"));
                  border-radius: 0px 0px 0px 0px;
                  margin : ${mgn}px 0px ${mgn}px 0px;
              }

              #hibernate {
                  background-image: image(url("icons/hibernate.png"));
                  border-radius: 0px 0px 0px 0px;
                  margin : ${mgn}px ${mgn}px ${mgn}px 0px;
              }

              #reboot {
                  background-image: image(url("icons/reboot.png"));
                  border-radius: 0px 4px 4px 0px;
                  margin : ${mgn}px ${mgn}px ${mgn}px 0px;
              }

            '';
          };
        };
        # Symlink files under ~/.config, e.g. ~/.config/alacritty/alacritty.yml
        xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource configFilesToLink;
      };
    };
  }
