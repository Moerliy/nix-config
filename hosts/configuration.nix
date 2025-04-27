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

    systemd.services.nix-daemon.serviceConfig = {
      CPUQuota = "75%";   # Limits nix-daemon to 50% of total CPU time
      Nice = 19;          # Lowers priority (optional)
      # IOSchedulingClass = "idle"; # Lowers disk priority (optional)
    };

    fonts = {
      packages = with pkgs; [
        source-code-pro
        font-awesome
        carlito # NixOS
        vegur # NixOS
        #corefonts # Microsoft
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
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
          deno # Javascript/Typescript Runtime
          nodePackages.pnpm # Package Manager
          python3 # python runtime
          nix-tree # Browse Nix Store
          pciutils # Manage PCI
          ranger # File Manager
          smartmontools # Disk Health
          tldr # Helper
          usbutils # Manage USB
          glxinfo
          wget # Retriever
          xdg-utils # Environment integration
          cmake # cmake
          gnumake # gnu make
          gcc # gnu c compiler
          meson
          ninja
          jq
          bluetuith # bluetooth
          xclip # clipboard
          xsel # clipboard
          autocutsel # clipboard
          openvpn # vpn
          gmp # gnu multiple precision arithmetic library
          ncurses # new curses
          cloc # count lines of code
          sbctl # Secure Boot Key Manager

          python311Packages.numpy

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
          anki # Flashcards
          catppuccin-kvantum # Theme Manager
          freecad-wayland # CAD
          orca-slicer # 3D Printer Slicer

          # File Management
          file-roller # Archive Manager
          pcmanfm # File Browser
          p7zip # Zip Encryption
          rsync # Syncer - $ rsync -r dir1/ dir2/
          unzip # Zip Files
          zip # Zip

          #llm
          # local-ai

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
