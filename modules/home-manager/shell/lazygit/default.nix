#
#
# Lazygit
#
#
{
  lib,
  pkgs,
  config,
  vars,
  ...
}:
with lib;
{
  options.lazygit = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Enable lazygit
      '';
    };
  };

  config = mkIf config.lazygit.enable {
    programs = {
      lazygit = {
        enable = true;
        settings = {
          gui = {
            editor = "nvim";
            authorColors = { };
            branchColors = { };
            scrollHeight = 2;
            scrollPastBottom = true;
            mouseEvents = true;
            nerdFontsVersion = "3";
            skipDiscardChangeWarning = false;
            skipStashWarning = false;
            sidePanelWidth = 0.3333;
            expandFocusedSidePanel = false;
            mainPanelSplitMode = "flexible";
            language = "auto";
            timeFormat = "02 Jan 06 15:04 MST";

            commitLength = {
              show = true;
            };

            skipNoStagedFilesWarning = false;
            showListFooter = true;
            showFileTree = true;
            showRandomTip = true;
            showCommandLog = true;
            showBottomLine = true;
            commandLogSize = 8;
            splitDiff = "auto";

            theme = {
              activeBorderColor = [
                "#cba6f7"
                "bold"
              ];
              inactiveBorderColor = [ "#a6adc8" ];
              optionsTextColor = [ "#89b4fa" ];
              selectedLineBgColor = [ "#313244" ];
              cherryPickedCommitBgColor = [ "#45475a" ];
              cherryPickedCommitFgColor = [ "#cba6f7" ];
              unstagedChangesColor = [ "#f38ba8" ];
              defaultFgColor = [ "#cdd6f4" ];
              searchingActiveBorderColor = [ "#f9e2af" ];
            };
          };

          git = {
            pagers = [
              {
                pager = "delta --dark --paging=never";
                colorArg = "always";
                useConfig = false;
              }
            ];

            commit = {
              signOff = false;
            };

            merging = {
              manualCommit = false;
              args = "";
            };

            skipHookPrefix = "WIP";
            autoFetch = true;
            autoRefresh = true;

            branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";

            allBranchesLogCmds = [
              "git log --graph --all --color=always --abbrev-commit --decorate --date=relative  --pretty=medium"
            ];

            overrideGpg = false;
            disableForcePushing = false;
            commitPrefixes = { };
            parseEmoji = false;

            log = {
              order = "topo-order";
              showGraph = "always";
              showWholeGraph = false;
            };
          };

          update = {
            method = "prompt";
            days = 14;
          };

          refresher = {
            refreshInterval = 10;
            fetchInterval = 60;
          };

          confirmOnQuit = false;
          quitOnTopLevelReturn = false;

          customCommands = [
            {
              key = "F";
              context = "files";
              command = "git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done";
              description = "Fetch and prune remots mirrors and locals";
            }
            {
              key = "C";
              context = "files";
              command = "git cz c";
              description = "commit with commitizen";
              loadingText = "opening commitizen commit tool";
              output = "terminal";
            }
            {
              key = "M";
              command = "git mergetool {{ .SelectedFile.Name }}";
              context = "files";
              loadingText = "opening git mergetool";
              output = "terminal";
            }
            {
              key = "G";
              command = "git commit -a";
              context = "files";
              loadingText = "GPT commit";
              output = "terminal";
            }
            {
              key = "<c-a>";
              description = "Search the whole history (From a ref and down) for an expression in a file";
              command = "git checkout {{index .PromptResponses 3}}";
              context = "commits";

              prompts = [
                {
                  type = "input";
                  title = "Search word:";
                }
                {
                  type = "input";
                  title = "File/Subtree:";
                }
                {
                  type = "input";
                  title = "Ref:";
                  initialValue = "{{index .CheckedOutBranch.Name }}";
                }
                {
                  type = "menuFromCommand";
                  title = "Commits:";
                  command = "git log --oneline {{index .PromptResponses 2}} -S'{{index .PromptResponses 0}}' --all -- {{index .PromptResponses 1}}";
                  filter = "(?P<commit_id>[0-9a-zA-Z]*) *(?P<commit_msg>.*)";
                  valueFormat = "{{ .commit_id }}";
                  labelFormat = "{{ .commit_id | green | bold }} - {{ .commit_msg | yellow }}";
                }
              ];
            }
          ];

          os = {
            editPreset = "nvim-remote";
          };

          disableStartupPopups = false;
          services = { };
          notARepository = "skip";
          promptToReturnFromSubprocess = true;
        };
      };
    };
    home.packages = with pkgs; [
      commitizen
      # gptcommit
    ];
  };
}
