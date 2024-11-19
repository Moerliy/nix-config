#
#  Shell
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./shell
#           ├─ default.nix *
#           └─ ...
#
[
  ./git.nix
  ./zsh.nix
  ./direnv.nix
  ./fish.nix
  ./zoxide.nix
  ./lazygit/default.nix
  ./bat.nix
]
