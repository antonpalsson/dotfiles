{ config, lib, pkgs, ... }:

let
  # Dotfiles needs to be in this path now
  dumbDotfilesPath = "${config.home.homeDirectory}/github/antonpalsson/dotfiles/";
  dumbLn = path: config.lib.file.mkOutOfStoreSymlink (dumbDotfilesPath + path);
in
{
  home = {
    stateVersion = "24.11";
    packages = [
      pkgs.git
      pkgs.neovim
      pkgs.tmux
      pkgs.mise
      pkgs.kitty
      pkgs.yarn

      pkgs.z-lua
      pkgs.tree
      pkgs.fzf
      pkgs.fd
      pkgs.ripgrep

      pkgs.cowsay
    ];

    file = {
      ".zshrc".source = dumbLn ".zshrc";
      ".config/.gitconfig".source = dumbLn ".gitconfig";
      ".config/tmux/tmux.conf".source = dumbLn ".tmux.conf";
      ".config/kitty/kitty.conf".source = dumbLn "kitty.conf";
      ".config/nvim".source = dumbLn "nvim";

      # ".zshrc".source = ./.zshrc;
      # ".config/.gitconfig".source = ./.gitconfig;
      # ".config/tmux/tmux.conf".source = ./.tmux.conf;
      # ".config/kitty/kitty.conf".source = ./kitty.conf;
      # ".config/nvim" = { source = ./nvim; recursive = true; };
    };
  };
}
