#
#  Specific system configuration settings for MacBook 8,1
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix
#       ├─ macbook.nix *
#       └─ ./modules
#           └─ default.nix
#
{
  pkgs,
  vars,
  host,
  inputs,
  system,
  pkgs-stable,
  ...
}: {
  imports =
    [
      ../scripts/default.nix
      ../modules/sane-defaults.nix
    ]
    ++ (import ./modules)
    ++ (import ../modules/shell)
    ++ (import ../modules/theming)
    ++ (import ../modules/programs);

  users.users.${vars.user} = {
    name = "${vars.user}";
    home = "/Users/${vars.user}";
    shell = pkgs.fish;
  };

  networking = {
    computerName = "MacBook";
    hostName = "MacBook";
  };

  custom-scripts.enable = true;

  # desktop related
  skhd.enable = true; # Simple hotkey daemon
  sketchybar.enable = true; # Status bar
  yabai.enable = true; # Window manager

  # programs
  kitty.enable = true; # Terminal emulator

  # shell related
  sane-defaults.enable = true;
  fish.enable = true;
  starship.enable = true;
  git.enable = true;
  bat.enable = true;
  zoxide.enable = true;
  zsh.enable = true;

  fonts = {
    packages = with pkgs; [
      source-code-pro
      font-awesome
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
        ];
      })
    ];
  };

  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  system = {
    defaults = {
      NSGlobalDomain = {
        AppleShowAllFiles = true;
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "WhenScrolling";
        AppleScrollerPagingBehavior = true;
        "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleTemperatureUnit = "Celsius";
        AppleICUForce24HourTime = true;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = true;
        NSScrollAnimationEnabled = true;
        _HIHideMenuBar = true;
      };
      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
      };
      finder = {
        QuitMenuItem = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh'';
    stateVersion = 4;
  };

  environment = {
    shells = with pkgs; [fish];
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
      TERM = "xterm-256color";
    };
  };

  services = {
    nix-daemon.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    brews = [
    ];
    casks = [
      "xquartz"
      "alfred"
      "firefox"
      "jellyfin-media-player"
      "plex-media-player"
      "anki"
    ];
  };
  home-manager = {
    extraSpecialArgs = {inherit inputs vars system pkgs-stable pkgs host;};
    users.${vars.user} = {
      imports =
        [
        ]
        ++ (import ../modules/home-manager);

      # editors
      neovim.enable = true;
      tmux.enable = true;

      home = {
        stateVersion = "22.05";
        packages = with pkgs; [
          discord
          nodejs
        ];
      };
    };
  };
}
