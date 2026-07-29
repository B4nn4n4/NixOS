{
  programs.nixvim = {
    enable = true;

    colorschemes.tokyonight.enable = true;

    plugins = {
      	telescope.enable = true;
      	lualine.enable = true;
    };
    clipboard = {
	register = "unnamedplus";
	providers.wl-copy.enable = true;    
    };
  };
}
