{
  pkgs,
  vars,
  config,
  lib,
  host,
  inputs,
  system,
  pkgs-stable,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
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
  wlogout.enable = true;
  waybar.enable = true;

  # programs
  kitty.enable = true; # Terminal emulator

  # Shell related
  sane-defaults.enable = true;
  fish.enable = true;
  starship.enable = true;
  git.enable = true;
  bat.enable = true;
  lazygit.enable = true;
  zoxide.enable = true;
  zsh.enable = true;
  custom-scripts.enable = true;

  environment = {
    systemPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  networking = {
    hostName = "Nvidia";
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

  nixpkgs.config.nvidia.acceptLicense = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
    bluetooth = {
      enable = true;
    };
  };

  # backlight control
  programs.light.enable = true;

  # Network settings
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";

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
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs vars system pkgs-stable pkgs host;};
    users.${vars.user} = {
      imports =
        [
        ]
        ++ (import ../../modules/home-manager);

      # Editors
      neovim.enable = true;
      tmux.enable = true;

      home = {
        stateVersion = "24.05";
      };
    };
  };
  system.stateVersion = "24.05"; # Did you read the comment?
}
