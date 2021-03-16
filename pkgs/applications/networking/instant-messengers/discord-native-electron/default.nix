{ pkgs, basePkg ? pkgs.discord }:

let
  inherit (pkgs) callPackage;
in {
  discord = callPackage ./base.nix {
    inherit basePkg;
    desktopName = "Discord";
  };
  discord-ptb = callPackage ./base.nix {
    inherit basePkg;
    desktopName = "Discord PTB";
  };
  discord-canary = callPackage ./base.nix {
    inherit basePkg;
    desktopName = "Discord Canary";
  };
}.${basePkg.pname}
