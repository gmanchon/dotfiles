
ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful oh-my-zsh plugins for Le Wagon bootcamps
plugins=(git gitfast last-working-dir common-aliases sublime zsh-syntax-highlighting history-substring-search pyenv ssh-agent poetry)

# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# 2021-05-27 GM
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Actually load Oh-My-Zsh
ZSH_DISABLE_COMPFIX=true
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)

# Load rbenv if installed (To manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Load pyenv (To manage your Python versions)
export PATH="${HOME}/.pyenv/bin:${PATH}" # Needed for Linux/WSL
# type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)"
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)" && RPROMPT+='[🐍 $(pyenv_prompt_info)]'

# new nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# old nvm
# Load nvm if installed (To manage your Node versions)
# export NVM_DIR="$HOME/.nvm"
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Anaconda binaries (python, pip, conda, jupyter, pytest, pylint etc.)
# export PATH="/anaconda3/bin:${HOME}/anaconda3/bin:${PATH}"

# Call `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use --silent
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    nvm use default --silent
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Load 'lewagon' virtualenv for the Data Bootcamp. You can comment these 2 lines to disable this behavior.
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# pyenv activate lewagon 2>/dev/null && echo "🐍 Loading 'lewagon' virtualenv"
# pyenv activate data_502 2>/dev/null && echPPo "🐍 Loading 'lewagon' virtualenv"
# export PYENV_VERSION="data_502" # prevents override by local .python-version files GM
# pyenv activate data_502 2>/dev/null # prevents override by local .python-version files GM
echo "🐍 Loading '$(pyenv version | cut -d ' ' -f1)' virtualenv"

# displays pyenv at the right of the prompt 2020-12-31
# type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)" && RPROMPT+='[🐍 $(pyenv_prompt_info)]'
# if [[ -n $(pyenv_prompt_info) ]]
# then
#   RPROMPT+='🐍 $(pyenv_prompt_info)'
# fi

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# 2019-04-08 GM
. ~/.profile_own

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export BUNDLER_EDITOR="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' -a"

# 2020-10-12 GM vscode
export PATH="${PATH}:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# 2020-12-25 pipx path added by pipx ensurepath
export PATH="$PATH:/Users/gmanchon/.local/bin"

# 2021-01-18 olist
# export PYTHONPATH="/Users/gmanchon/code/wagon-red/data-solutions/04-Decision-Science:$PYTHONPATH"

# 2021-04-09
alias nbc="nbcleanmeta $@"
alias cha="challengify $@"

# 2021-03-30 z
. $(brew --prefix)/etc/profile.d/z.sh

# 2021-04-12 setup from https://github.com/lewagon/data-lectures/wiki/How-to-set-up-a-lecture-edition-environment
jnbconvert() { ls *.ipynb | entr -r jupyter nbconvert "$1" --to slides --post serve --TemplateExporter.extra_template_basedirs=../templates --template=kitt; }

# windows setup
if command -v sw_vers &>/dev/null; then
    # echo "mac setup"

    arch_name="$(uname -m)"

    if [ "${arch_name}" = "x86_64" ]; then
        if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
            # echo "Running on Rosetta 2"

            export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
        else
            # echo "Running on native Intel"
        fi
    elif [ "${arch_name}" = "arm64" ]; then
        # echo "Running on ARM"
    else
        # echo "Unknown architecture: ${arch_name}"
    fi

else
    # echo "ubuntu setup"

    export BUNDLER_EDITOR="subl $@ >/dev/null 2>&1 -a"

    export BROWSER="/windir/c/Program Files/Google/Chrome/Application/chrome.exe"

    alias juno="jupyter notebook --port 8889 $@"

    # sudo /etc/init.d/postgresql start
fi
export BUNDLER_EDITOR="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl' -a"

arch_name="$(uname -m)"

if [ "${arch_name}" = "x86_64" ]; then
    if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
        echo "Your computer uses Apple Silicon (Rosetta) 🌟"
    else
        echo "Your computer has an Intel processor 🤖"
    fi
elif [ "${arch_name}" = "arm64" ]; then
    echo "Your computer uses Apple Silicon 🌟"
else
    echo "Unknown architecture: ${arch_name}, call a TA 🤔"
fi

# export PYTHONPATH="/Users/gmanchon/code/sandbox/decision/project-setup/lewagon:/Users/gmanchon/code/wagon-red/data-challenges/04-Decision-Science"

# 2021-02-15 gcloud run cli
# export CLOUDSDK_PYTHON="/usr/local/opt/python@3.8/libexec/bin/python"
# source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
# source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="$HOME/.poetry/bin:$PATH"

# 2021-05-31 node
export PATH="/usr/local/bin:$PATH"
