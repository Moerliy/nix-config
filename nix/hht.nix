#
#  Nix Setup using Home-manager
#
#  flake.nix
#   └─ ./nix
#       ├─ default.nix
#       └─ pacman.nix *
#
{
  inputs,
  pkgs,
  nixgl,
  vars,
  host,
  ...
}: {
  imports =
    import ../modules/home-manager;

  # editors
  neovim.enable = true;
  tmux.enable = true;

  git.enable = true;
  lazygit.enable = true;
  bat.enable = true;

  home = {
    username = "${vars.user}";
    homeDirectory = "/common/homes/all/${vars.user}";
    stateVersion = "23.11";

    packages = with pkgs; [
      (import nixgl {inherit pkgs;}).nixGLIntel # OpenGL for GUI apps
      #.nixVulkanIntel
      home-manager
      tmux
      zsh
    ];

    # file.".bash_aliases".text = ''
    #   alias alacritty="nixGLIntel ${pkgs.alacritty}/bin/alacritty"
    # ''; # Aliases for package using openGL (nixGL). home.shellAliases does not work
  };

  xdg = {
    enable = true;
    systemDirs.data = ["/common/homes/all/${vars.user}/.nix-profile/share"];
  }; # Add Nix Packages to XDG_DATA_DIRS

  nix = {
    settings = {
      sandbox = false;
      auto-optimise-store = true;
    };
    package = pkgs.nixVersions.stable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
}
