#
#  Apps
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./programs
#           ├─ default.nix *
#           └─ ...
#
[
  ./kitty.nix
  ./tmux/default.nix
  ./rofi.nix
  ./wlogout/default.nix
]
