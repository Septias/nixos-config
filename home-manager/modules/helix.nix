{pkgs, ...}: {
  home.packages = with pkgs; [
    taplo
    typescript-language-server
    rust-analyzer
    nil
    marksman
    nodePackages.vscode-json-languageserver
    python313Packages.ruff
    python313Packages.python-lsp-server
  ];
  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    defaultEditor = true;
    settings = {
      theme = "kitty256";
      editor = {
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "warning";
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
        bufferline = "multiple";
        line-number = "absolute";
        completion-timeout = 5;
        completion-replace = true;
        statusline.left = ["mode" "spinner" "file-name" "read-only-indicator" "file-modification-indicator" "total-line-numbers" "primary-selection-length"];
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
          "C-b" = ":echo %sh{git blame -L %{cursor_line},+1 %{buffer_name}}";
          "C-f" = "jump_forward";
          "E" = ":quit!";
          "p" = "paste_before";
          "P" = "paste_after";
          "C-g" = "jump_backward";
          "C-s" = "save_selection";
          "C-i" = "goto_next_buffer";
          "C-u" = "goto_previous_buffer";
          "C-l" = "last_picker";
          "C-D" = "page_cursor_half_up";
          "A-." = "repeat_last_motion";
          "C-r" = ":reset-diff-change";
          "C-space" = [":w"];
          # Changes
          "`" = "switch_to_lowercase";
          "R" = "replace_with_yanked";
          "A-u" = "earlier";
          "A-U" = "later";
          "I" = "insert_at_line_start";
          "A" = "insert_at_line_end";
          "=" = ":format";
          "A-d" = "delete_selection_noyank";
          "Q" = "record_macro";
          "q" = "replay_macro";
          # Selection manipulation
          "s" = "select_regex";
          "S" = "split_selection";
          "&" = "align_selections";
          "_" = "trim_selections";
          "C" = "copy_selection_on_next_line";
          "K" = "keep_selections";
          "A-f" = "expand_selection";
          "A-g" = "shrink_selection";
          "A-n" = "select_next_sibling";
          "A-N" = "select_prev_sibling";
          # Search
          "*" = "search_selection";
        };
      };
    };
    languages = {
      language-server = {
        copilot = {
          command = "copilot-language-server";
          args = ["--stdio"];
        };
        nil = {
          command = "nil";
          config.nil.nix.flake.autoArchive = true;
        };
        pylsp.config.pylsp.plugins = {
          ruff.enabled = false;
          autopep8.enabled = false;
          flake8.enabled = false;
          mccabe.enabled = false;
          pycodestyle.enabled = false;
          pyflakes.enabled = false;
          pylint.enabled = false;
          yapf.enabled = false;
        };
      };

      language = [
        {
          name = "rust";
          language-servers = ["rust-analyzer"];
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
          name = "python";
          auto-format = true;
          language-servers = ["pylsp" "ruff"];
        }
        {
          name = "markdown";
          soft-wrap.enable = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "${pkgs.alejandra}/bin/alejandra";
          };
        }
        {
          name = "javascript";
          language-servers = ["typescript-language-server"];
        }
        {
          name = "typescript";
          language-servers = ["typescript-language-server"];
        }
        {
          name = "tsx";
          language-servers = ["typescript-language-server"];
        }
      ];
    };
  };
}
