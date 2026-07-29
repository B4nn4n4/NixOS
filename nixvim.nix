{
  programs.nixvim = {
    enable = true;

    colorschemes.tokyonight.enable = true;

    plugins = {
      telescope.enable = true;
      lualine.enable = true;
    };
  };
}
