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
      open = false;
      modesetting.enable = true;
      powerManagement.enable = false;
      nvidiaSettings = true;
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

  boot = {
    loader = {
      # grub = {
      #   enable = true;
      #   efiSupport = true;
      #   device = "nodev";
      #   useOSProber = true;
      # };
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = lib.mkForce false;
        windows = {
          "windows" = let
            # To determine the name of the windows boot drive, boot into edk2 first, then run
            # `map -c` to get drive aliases, and try out running `FS1:`, then `ls EFI` to check
            # which alias corresponds to which EFI partition.
            boot-drive = "HD1a65535a1";
          in {
            title = "Windows";
            efiDeviceHandle = boot-drive;
            sortKey = "0_windows";
          };
        };

        edk2-uefi-shell.enable = true;
        edk2-uefi-shell.sortKey = "1_edk2";
      };
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "5GB";
    };
  };

  # System clock might be incorrect after booting Windows and going back to the NixOS.
  # It can be fixed by either setting RTC time standard to UTC on Windows, or setting it to localtime on NixOS.
  # Setting RTC time standard to localtime, compatible with Windows in its default configuration:
  time.hardwareClockInLocalTime = true;

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
