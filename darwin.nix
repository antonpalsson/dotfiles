{ config, lib, pkgs, ... }:

{
  users.users.polle.home = "/Users/polle";

  system = {
    stateVersion = 4;

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    defaults = {
      finder.AppleShowAllExtensions = true;
      finder._FXShowPosixPathInTitle = true;

      dock.autohide = true;

      NSGlobalDomain.AppleShowAllExtensions = true;
      NSGlobalDomain.InitialKeyRepeat = 14;
      NSGlobalDomain.KeyRepeat = 1;
    };
  };

  environment = {
    shells = [ pkgs.bash pkgs.zsh ];
    loginShell = pkgs.zsh;

    systemPackages = [
      pkgs.coreutils
    ];
  };

  programs = {
    zsh.enable = true;
  };
}
