{
  apple-silicon,
  pkgs,
  vars,
  inputs,
  system,
  pkgs-stable,
  host,
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
  eww.enable = true;
  wlogout.enable = true;
  waybar.enable = true;

  # programs
  kitty.enable = true; # Terminal emulator

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

  # Asahi settings
  hardware = {
    asahi = {
      withRust = true;
      # addEdgeKernelConfig = true;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "replace";
      setupAsahiSound = true;
    };
    bluetooth = {
      enable = true;
    };
  };

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

      git.enable = true;
      lazygit.enable = true;

      bat.enable = true;

      home = {
        stateVersion = "23.11";
        packages = with pkgs-stable; [
          # Collaboration tools
          webcord-vencord
        ];
      };
    };
  };
  system.stateVersion = "23.11"; # Did you read the comment?
}
