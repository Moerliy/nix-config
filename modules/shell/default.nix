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
  ./zsh.nix
  ./direnv.nix
  ./fish.nix
  ./zoxide.nix
]
