{
  config,
  apple-silicon,
  hyprland,
  lib,
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

  users.users.${vars.user} = {
    name = "${vars.user}";
    home = "/home/${vars.user}";
    shell = pkgs.bash;
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
      neovim
    ];
  };

  networking = {
    #computerName = "MacBook";
    hostName = "MacBook";
  };

  fonts = {
    fontDir.enable = true;
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
      #interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
    settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7YpFP8PwtkuGc="];
    };
  };

  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
  };

  environment = {
    shells = with pkgs; [bash];
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
      TERM = "xterm-256color";
    };
  };

  custom-scripts.enable = true;
  sane-defaults.enable = true;
  fish.enable = true;
  kitty.enable = true;
  starship.enable = true;
  neovim.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    nodejs
    python3
    cmake
    gnumake
    gcc
  ];

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = "23.11";
      packages = with pkgs; [
      ];
    };
    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {
      input.kb_layout = "de";
      "$mod" = "SUPER";
      bind = ["$mod, return, exec, kitty"];
      monitor = ["eDP-1, preferred, auto, auto"];
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.setupAsahiSound = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #  font = "Lat2-Terminus16";
    keyMap = "de-latin1";
    useXkbConfig = false;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "de";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.11"; # Did you read the comment?
}
