#!/usr/bin/env zsh
## B U L L E T T R A I N R E L O A D E D
## INFO|DOC ##
 # Modified/added elemeners dumped from zshrc into fork for conveience
 #
 # TODO: Consider changing variable names where possibly too generic
 #
 # TODO: Migrate to native zsh functionality where possible to minimize forking
 #         - List of techniques at:
 #           https://zdharma.org/Zsh-100-Commits-Club/Zsh-Native-Scripting-Handbook.html
 #
 # TODO: Update implementation details of prompt to align with zsh plugin best
 #       practices.
 #         - Zsh Plugin Standard reference at:
 #           https://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
 #
 # An example of applying the two above TODOs would be the function:
 # ``` zsh
 #
 #   preexec() {
 #       cmd_timestamp=`date +%s`
 #   }
 #
 # ```
 # Becomes:
 # ``` zsh
 #
 #   ### Plugin Area: Initialization
 #
 #   # Check add-zsh-hook is loaded
 #   if { ! (( ${+functions[add-zsh-hook]} )) } {
 #       builtin autoload -Uz add-zsh-hook || {
 #           builtin print -r -- "Loading add-zsh-hook failed."
 #           exit 1;
 #       }
 #   }
 #
 #   # Load datetime module to replace date command
 #   #   - Via https://github.com/zdharma/Zsh-100-Commits-Club/blob/75381b30ac62b69007c36065e9749ce7d76c11f9/zsh-plugin-assessor/zsh-plugin-assessor#L66
 #   zmodload zsh/datetime || {
 #       builtin print -r -- "Module zsh/datetime is needed, aborting"
 #       exit 1
 #   }
 #
 #   # ...
 #
 #   ### Plugin Stage: Global variable declarations
 #     # - Only declaring one here for example, will be alongside all other globals
 #   builtin typeset -gi BULLETTRAIN_TIME_CMD_TIMESTAMP
 #
 #   # ...
 #
 #   ### Plugin Stage: Hook Definitions
 #     # - Single declaration for example, as with variable declaration above
 #
 #   # preexec hook function
 #   :bullet-train_preexec()
 #   {
 #       (( BULLETTRAIN_TIME_CMD_TIMESTAMP = EPOCHSECONDS ))
 #   }
 #
 #   # ...
 #
 #   # plugin hook registration function
 #   .bullet-train_register_hooks()
 #   {
 #       # ...
 #       add-zsh-hook preexec :bullet-train_preexec
 #       # ...
 #   }
 # ```
##

# zstd::0
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Then ${0:h} to get plugin’s directory
local plugind="${0:h}"

# Load base theme
local prompt_base='bullet-train-base.zsh-theme'
source "${plugind}/${prompt_base}" || {
    print -r -- "Error loading base bullet-train prompt."
    exit 1
}

# Prompt Order
  BULLETTRAIN_PROMPT_ORDER=(
    multi
    dir
    screen
    perl
    ruby
#    virtualenv
    aws
    go
    rust
    elixir
    git
    hg
    cmd_exec_time
  )
 #
 # Vars
  declare -i BULLETTRAIN_TIME_TRIGGER=0
   BULLETTRAIN_CONTEXT_ROOT="𝚛𝚘𝚘𝚝"
   BULLETTRAIN_CONTEXT_ROOT_FG=118
   BULLETTRAIN_PROMPT_CHAR="λ"
   BULLETTRAIN_PROMPT_CHAR_FG=230
   BULLETTRAIN_STATUS_BG=green
   BULLETTRAIN_STATUS_ERROR_BG=red
   BULLETTRAIN_STATUS_FG=white
   BULLETTRAIN_TIME_BG=235
   BULLETTRAIN_TIME_FG=255
   BULLETTRAIN_TIME_12HR=false
   BULLETTRAIN_CUSTOM_BG=black
   BULLETTRAIN_CUSTOM_FG=default
   BULLETTRAIN_GO_BG=cyan
   BULLETTRAIN_GO_FG=white
   BULLETTRAIN_RUST_BG=black
   BULLETTRAIN_RUST_FG=white
   BULLETTRAIN_DIR_BG=247
   BULLETTRAIN_DIR_FG=254
   BULLETTRAIN_GIT_BG=white
   BULLETTRAIN_GIT_FG=black
   BULLETTRAIN_CONTEXT_BG=black
   BULLETTRAIN_CONTEXT_FG=white
   BULLETTRAIN_SCREEN_BG=white
   BULLETTRAIN_SCREEN_FG=black
   BULLETTRAIN_EXEC_TIME_BG=yellow
   BULLETTRAIN_EXEC_TIME_FG=black
   BULLETTRAIN_KCTX_BG=yellow
   BULLETTRAIN_KCTX_FG=white
   BULLETTRAIN_ELIXIR_BG=magenta
   BULLETTRAIN_ELIXIR_FG=white
   BULLETTRAIN_PERL_BG=yellow
   BULLETTRAIN_PERL_FG=black
   BULLETTRAIN_VIRTUALENV_BG=yellow
   BULLETTRAIN_VIRTUALENV_FG=white
   BULLETTRAIN_NVM_BG=green
   BULLETTRAIN_NVM_FG=white
   BULLETTRAIN_AWS_BG=yellow
   BULLETTRAIN_AWS_FG=black
   BULLETTRAIN_RUBY_BG=red
   BULLETTRAIN_RUBY_FG=white

   # Vars from theme cleanup
   BULLETTRAIN_PROMPT_CHAR="λ"
   BULLETTRAIN_DIR_BG=247
   BULLETTRAIN_CONTEXT_FG=white

   # TIMESTATUS
   BULLETTRAIN_TIME_BG_PRE=$BULLETTRAIN_TIME_BG

 #

 # Bullet Train Functions

  # Overwrite existing
  prompt_cmd_exec_time()
  {
    if (( BULLETTRAIN_last_exec_duration > BULLETTRAIN_EXEC_TIME_ELAPSED ))
    then
        prompt_segment $BULLETTRAIN_EXEC_TIME_BG \
                       $BULLETTRAIN_EXEC_TIME_FG \
                       "$(displaytime $BULLETTRAIN_last_exec_duration)";
    fi
  }


  prompt_multi()
  {
    if [[ ! -f $ZSH/.tmp ]]; then
        touch $ZSH/.tmp ||
            print -P "Bullettrain: %F{red}prompt_multi error.%f"
    fi

    if [[ $UID -eq 0 ]]; then
    	BT_MULTICONTEXT_FG=$BULLETTRAIN_CONTEXT_ROOT_FG
    	_context=$BULLETTRAIN_CONTEXT_ROOT
    else
        BT_MULTICONTEXT_FG=$BULLETTRAIN_TIME_FG
        _context="$(s_context)"
    fi

    if [[ $BULLETTRAIN_TIME_12HR == true ]]; then
        local date='%D{%r}'
    else
        local date='%D{%T}'
    fi
    if
    trigger=$(grep -c "." $ZSH/.tmp)

    ### RET ERROR BLOCK ###
    if [[ $RETVAL -ne 0 &&  $trigger -lt 2 ]]; then
        MULTI_BG=$BULLETTRAIN_STATUS_ERROR_BG
        MULTI_FG=$BULLETTRAIN_TIME_FG
        prompt_segment $MULTI_BG $MULTI_FG "$date"

        MULTI_BG=$BULLETTRAIN_CONTEXT_BG
        MULTI_FG=$BT_MULTICONTEXT_FG
        if [[ $UID -eq 0 ]]; then
            prompt_segment $MULTI_BG $MULTI_FG  "𝚛𝚘𝚘𝚝"
        else
            prompt_segment $MULTI_BG $MULTI_FG "$_context"
        fi
    else
    ### NORMAL PRINT ###
        if [[ -n "$_context" ]]; then
            MULTI_BG=$BULLETTRAIN_TIME_BG
            MULTI_FG=$BULLETTRAIN_TIME_FG
            BULLETTRAIN_TIME_BG=$BULLETTRAIN_TIME_BG_PRE
            prompt_segment $MULTI_BG $MULTI_FG "$date "

            MULTI_FG=$BT_MULTICONTEXT_FG
            if [[ $UID -eq 0 ]]; then
                prompt_segment $MULTI_BG $BT_MULTICONTEXT_FG "root" ###"𝚛𝚘𝚘𝚝"
            else
                prompt_segment $MULTI_BG $MULTI_FG "$_context"
            fi
        fi
    fi
  }

  s_context()
  {
    local user="$(whoami)"
    echo -n $user
    # [[ "$user" != "$BULLETTRAIN_CONTEXT_DEFAULT_USER" ||
    #                   -n "$BULLETTRAIN_IS_SSH_CLIENT"    ]] && echo -n "${user}"
  }

  build_prompt()
  {
    RETVAL=$?
    if [[ $RETVAL -ne 0  ]]; then
      echo '.' >> $ZSH/.tmp
    fi
    if [[ $RETVAL  ]]; then
      echo '' > $ZSH/.tmp
    fi
    for segment in $BULLETTRAIN_PROMPT_ORDER; do
      prompt_$segment
    done
    prompt_end
  }
 PS2="";
 #

