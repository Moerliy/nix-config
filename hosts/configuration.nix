{
  pkgs,
  pkgs-stable,
  vars,
  host,
  ...
}: let
  terminal = pkgs.${vars.terminal};
in
  with host; {
    boot = {
      # Use the systemd-boot EFI boot loader.
      loader = {
        systemd-boot.enable = true;
        efi = {
          canTouchEfiVariables =
            if hostName == "asahi"
            then false
            else true;
        };
      };
      tmp = {
        cleanOnBoot = true;
        tmpfsSize = "5GB";
      };
    };

    users.users.${vars.user} = {
      name = "${vars.user}";
      home = "/home/${vars.user}";
      shell = pkgs.bash;
      isNormalUser = true;
      extraGroups = ["wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "optical" "storage"];
    };

    # Set your time zone.
    time.timeZone = "Europe/Berlin";

    # Select internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_MONETRY = "de_DE.UTF-8";
      };
    };

    # console settings
    console = {
      font = "Lat2-Terminus16";
      keyMap = "de-latin1";
      useXkbConfig = false;
    };

    security = {
      rtkit.enable = true;
      polkit.enable = true;
      sudo.wheelNeedsPassword = false;
    };

    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        source-code-pro
        font-awesome
        carlito # NixOS
        vegur # NixOS
        #corefonts # Microsoft
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "JetBrainsMono"
          ];
        })
      ];
    };

    environment = {
      shells = with pkgs; [bash];
      variables = {
        TERMINAL = "${vars.terminal}";
        EDITOR = "${vars.editor}";
        VISUAL = "${vars.editor}";
        TERM = "xterm-256color";
      };
      systemPackages = with pkgs;
        [
          # Terminal
          terminal # Terminal Emulator
          btop # Resource Manager
          coreutils # GNU Utilities
          git # Version Control
          killall # Process Killer
          lshw # Hardware Config
          nano # Text Editor
          vim # Text Editor
          neovim # Text Editor
          nodejs # Javascript Runtime
          nodePackages.pnpm # Package Manager
          python3 # python runtime
          nix-tree # Browse Nix Store
          pciutils # Manage PCI
          ranger # File Manager
          smartmontools # Disk Health
          tldr # Helper
          usbutils # Manage USB
          wget # Retriever
          xdg-utils # Environment integration
          cmake # cmake
          gnumake # gnu make
          gcc # gnu c compiler

          # Video/Audio
          alsa-utils # Audio Control
          feh # Image Viewer
          linux-firmware # Proprietary Hardware Blob
          mpv # Media Player
          pavucontrol # Audio Control
          pipewire # Audio Server/Control
          pulseaudio # Audio Server/Control
          qpwgraph # Pipewire Graph Manager
          vlc # Media Player

          # Apps
          appimage-run # Runs AppImages on NixOS
          firefox # Browser
          remmina # XRDP & VNC Client

          # File Management
          gnome.file-roller # Archive Manager
          pcmanfm # File Browser
          p7zip # Zip Encryption
          rsync # Syncer - $ rsync -r dir1/ dir2/
          unzip # Zip Files
          zip # Zip

          # Other Packages Found @
          # - ./<host>/default.nix
          # - ../modules
        ]
        ++ (with pkgs-stable; [
          # Apps
          image-roll # Image Viewer
        ]);
    };
  }