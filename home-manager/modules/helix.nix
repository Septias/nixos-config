{pkgs, ...}: {
  home.packages = with pkgs; [
    vscode-extensions.vadimcn.vscode-lldb
    vscode-langservers-extracted
  ];
  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_frappe";
      editor = {
        end-of-line-diagnostics = "hint";
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
        #line-number = "relative";
        completion-timeout = 10;
        completion-replace = true;
        statusline.left = ["mode" "spinner" "file-name" "read-only-indicator" "file-modification-indicator" "total-line-numbers"];
        auto-save.focus-lost = true;
      };
      keys = {
        # https://docs.helix-editor.com/keymap.html
        insert = {
          "C-s" = [":w" "normal_mode"];
          "C-r" = "insert_register";
          "C-x" = "completion";
          "C-u" = "kill_to_line_start";
          "C-k" = "kill_to_line_end";
        };
        normal = {
          "C-m" = ["extend_to_line_bounds" "delete_selection" "paste_after"];
          "C-h" = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
          "C-f" = "jump_forward";
          "C-g" = "jump_backward";
          "C-s" = "save_selection";
          "C-b" = "goto_previous_buffer";
          "C-e" = "goto_file_end";
          "C-l" = "last_picker";
          # Changes
          "R" = "replace_with_yanked";
          "=" = "format_selections";
          "A-d" = "delete_selection_noyank";
          "Q" = "record_macro";
          "q" = "replay_macro";
          # Selection manipulation
          "s" = "select_regex";
          "S" = "split_selection";
          "&" = "align_selections";
          "_" = "trim_selections";
          "C" = "copy_selection_on_next_line";
          "A-f" = "expand_selection";
          "A-g" = "shrink_selection";
          "A-n" = "select_next_sibling";
          "A-b" = "select_prev_sibling";
          # Search
          "*" = "search_selection";
        };
      };
    };
    languages = {
      language-server.helix-gpt = {
        command = "helix-gpt";
      };
      language = [
        {
          name = "rust";
          language-servers = ["rust-analyzer" "helix-gpt"];
          debugger = {
            command = "codelldb";
            name = "codelldb";
            port-arg = "--port {}";
            transport = "tcp";
            templates = [
              {
                name = "binary";
                request = "launch";
                completion = [
                  {
                    completion = "filename";
                    name = "binary";
                  }
                ];
                args = {
                  program = "{0}";
                  runInTerminal = false;
                };
              }
            ];
          };
        }
        {
          name = "javascript";
          language-servers = ["typescript-language-server" "helix-gpt"];
        }
        {
          name = "python";
          language-servers = ["pylsp" "helix-gpt"];
        }
        {
          name = "markdown";
          language-servers = ["helix-gpt"];
          soft-wrap.enable = true;
        }
      ];
    };
  };
}
