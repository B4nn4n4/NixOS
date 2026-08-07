{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = "z";
      maplocalleader = ",";
    };

    colorschemes.tokyonight.enable = true;

    plugins = {
      telescope.enable = true;
      lualine.enable = true;
    };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "99";
        version = "c174224";

        src = pkgs.fetchFromGitHub {
          owner = "ThePrimeagen";
          repo = "99";
          rev = "c174224";
          hash = "sha256-iilpiG81kHIv7Y0qvPzZOanNA0lsPotlB18cvtmTy0o=";
        };

        doCheck = false;
      })
    ];

    extraConfigLua = ''
      local ai = require("99")

      ai.setup({})
      ai.set_model("opencode/big-pickle")
      -- Auto reload files modified by 99 / external tools
      vim.o.autoread = true

      vim.api.nvim_create_autocmd({
        "FocusGained",
        "BufEnter",
        "CursorHold",
        "CursorHoldI",
      }, {
        command = "checktime",
      })
    '';

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>99";
        action = "<cmd>lua require('99').open()<CR>";
      }
      {
        mode = "n";
        key = "<leader>9v";
        action = "<cmd>lua require('99').vibe()<CR>";
      }
      {
        mode = "n";
        key = "<leader>9s";
        action = "<cmd>lua require('99').search()<CR>";
      }
      {
        mode = "n";
        key = "<leader>9t";
        action = "<cmd>lua require('99').tutorial()<CR>";
      }
      {
        mode = "v";
        key = "<leader>9v";
        action = "<cmd>lua require('99').visual()<CR>";
      }
      {
        mode = "n";
        key = "<leader>9x";
        action = "<cmd>lua require('99').stop_all_requests()<CR>";
      }
      {
        mode = "n";
        key = "<leader>9l";
        action = "<cmd>lua require('99').view_logs()<CR>";
      }
      {
        mode = "n";
        key = "<leader>9c";
        action = "<cmd>lua require('99').clear_previous_requests()<CR>";
      }
    ];
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    opencode
  ];
}
