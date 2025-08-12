{pkgs, ...}: {
  home.packages = with pkgs;
    [
      # Some lsps for languages that should work out of the box
      taplo # toml lsp
      vtsls # typescript
      typescript-language-server
      helix-gpt
      nil
      marksman
    ]
    ++ (with python312Packages; [
      pycodestyle
      pylint
      flake8
    ]);
  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_frappe";
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
          "C-f" = "jump_forward";
          "p" = "paste_before";
          "P" = "paste_after";
          "C-g" = "jump_backward";
          "C-s" = "save_selection";
          "C-a" = "goto_next_buffer";
          "C-i" = "goto_previous_buffer";
          "C-e" = "goto_file_end";
          "C-l" = "last_picker";
          "A-." = "repeat_last_motion";
          # Changes
          "R" = "replace_with_yanked";
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
          "A-f" = "expand_selection";
          "A-g" = "shrink_selection";
          "A-n" = "select_next_sibling";
          "A-p" = "select_prev_sibling";
          # Search
          "*" = "search_selection";
        };
      };
    };
    languages = {
      language-server = {
        helix-gpt = {
          command = "helix-gpt";
        };
        copilot = {
          command = "copilot-language-server";
          args = ["--stdio"];
        };
        pylsp.config = {
          pycodestyle.enabled = false;
          pyflakes.enabled = false;
          yapf.enabled = false;
          pylint.enabled = true;
          flake8.enabled = true;
        };
      };

      language =
        [
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
            formatter = {
              command = "${pkgs.black}/bin/black";
              args = ["-" "--quiet"];
            };
            language-servers = ["pylsp" "helix-gpt"];
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
        ]
        ++ (
          let
            lsps = ["typescript-language-server" "helix-gpt"];
          in [
            {
              name = "javascript";
              language-servers = lsps;
            }
            {
              name = "typescript";
              language-servers = lsps;
            }
            {
              name = "tsx";
              language-servers = lsps;
            }
          ]
        );
    };
  };
}
