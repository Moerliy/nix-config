{
  apple-silicon,
  catppuccin,
  pkgs,
  vars,
  inputs,
  system,
  pkgs-stable,
  host,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    apple-silicon.nixosModules.apple-silicon-support
    ../../scripts/default.nix
  ]
  ++ (import ../../modules);

  # Login Manager
  gdm.enable = true;

  # Desktop
  hyprland.enable = true;
  wallpaper.enable = true;
  rofi.enable = true;
  gtk-theme.enable = true;
  qt-theme.enable = true;
  mako.enable = true;
  eww.enable = true;
  wlogout.enable = false;
  waybar.enable = true;

  # programs
  kitty.enable = true; # Terminal emulator
  vesktop.enable = true; # Discord client

  # Shell related
  sane-defaults.enable = true;
  fish.enable = true;
  starship.enable = true;
  zoxide.enable = true;
  zsh.enable = true;
  custom-scripts.enable = true;

  networking = {
    hostName = "MacBook";
  };

  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      #interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam-run"
      "steam-unwrapped"
    ];

  # Asahi settings
  hardware = {
    asahi = {
      setupAsahiSound = true;
    };
    bluetooth = {
      enable = true;
    };
  };

  boot = {
    loader = {
      grub.minegrub-world-sel = {
        enable = true;
        customIcons = [
          {
            name = "nixos";
            lineTop = "NixOS (23/11/2023, 23:03)";
            lineBottom = "Survival Mode, No Cheats, Version: 23.11";
            # Icon: you can use an icon from the remote repo, or load from a local file
            imgName = "nixos";
            # customImg = builtins.path {
            #   path = ./nixos-logo.png;
            #   name = "nixos-img";
            # };
          }
        ];
      };
      efi = {
        canTouchEfiVariables = false;
      };
    };
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "5GB";
    };
  };

  # backlight control
  programs.light.enable = true;
  services = {
    actkbd = {
      enable = true;
      bindings = [
        {
          keys = [ 225 ];
          events = [ "key" ];
          command = "${pkgs.light}/bin/light -A 10";
        }
        {
          keys = [ 224 ];
          events = [ "key" ];
          command = "${pkgs.light}/bin/light -U 10";
        }
      ];
    };
    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;
  };

  # Network settings
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };
  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        vars
        system
        pkgs-stable
        pkgs
        host
        ;
    };
    users.${vars.user} = {
      imports = [
        catppuccin.homeModules.catppuccin
      ]
      ++ (import ../../modules/home-manager);

      # Editors
      neovim.enable = true;
      tmux.enable = true;

      git.enable = true;
      lazygit.enable = true;
      neofetch.enable = true;

      bat.enable = true;

      home = {
        stateVersion = "25.05";
        packages = with pkgs; [
          # Collaboration tools
          # webcord-vencord
          vesktop
        ];
      };
    };
  };
  system.stateVersion = "25.05"; # Did you read the comment?
}
