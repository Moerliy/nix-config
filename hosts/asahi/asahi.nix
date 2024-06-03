{
  apple-silicon,
  pkgs,
  vars,
  ...
}: {
  imports =
    [
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

  # programs
  kitty.enable = true; # Terminal emulator

  # Shell related
  sane-defaults.enable = true;
  fish.enable = true;
  starship.enable = true;
  git.enable = true;
  zoxide.enable = true;
  zsh.enable = true;
  custom-scripts.enable = true;

  # Editors
  neovim.enable = true;

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

  # Asahi settings
  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.setupAsahiSound = true;

  # backlight control
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [225];
        events = ["key"];
        command = "${pkgs.light}/bin/light -A 10";
      }
      {
        keys = [224];
        events = ["key"];
        command = "${pkgs.light}/bin/light -U 10";
      }
    ];
  };

  # Network settings
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = "23.11";
    };
  };
  system.stateVersion = "23.11"; # Did you read the comment?
}
