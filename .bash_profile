for file in ~/.{bash_prompt,bash_profile.local}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

export EDITOR=emacs

export HISTCONTROL=erasedups
export HISTSIZE=50000
export HISTFILESIZE=50000

export CLICOLOR=1
export GREP_OPTIONS="--color"
export LESS="--RAW-CONTROL-CHARS --no-init --quit-if-one-screen"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

shopt -s checkwinsize # check window size after each command
shopt -s extglob      # enable extended pattern-matching features
shopt -s histappend   # append to HISTFILE rather than overwrite
shopt -s nocaseglob   # treat pathname expansion as case-insensitive

alias ll="ls -Al"
alias cp="cp -v"
alias mv="mv -v"
alias rm="rm -v"
alias e="emacs"
alias sc="e ~/.bash_profile && rf"
alias rf=". ~/.bash_profile"
alias clc="claude --chrome"


# "most frequent", shows you the commands you use the most. Good targets for aliasing shorter,
# even 1-character versions. e.g. alias g=git
alias mostfreq='cut -f1 -d" " ~/.bash_history | sort | uniq -c | sort -nr | head -n 30';

# here's what I've aliased and have probably saved loads of time
alias g='git';                       # 1 char vs 3. Minor, but repeated how many times?
alias gb='git branch';               # an abbreviated 'git status' and 'git branch' info
alias gd='git diff';
alias gs='gb; git status --short';   # more complete "where am I?" command than "git status"
alias gap='git add -p';              # default to the "selectively git-add my changes, interactively"
alias gc='git commit --verbose';
alias gp='git pull';
alias gch='git checkout'
alias gl='git log --oneline --graph';

# diff my local main with "production"
alias gdp='git diff origin/main main';

# diff my local branch with origin
alias gdo='git diff origin/$(__git_ps1) $(__git_ps1)';

# which files are different on my current branch from main?
alias gdm='git diff main $(git rev-parse --abbrev-ref HEAD) --name-only'



# for when you want to make it seem like you've got a long-running analytical task
alias look_busy='perl -le "use Time::HiRes qw( usleep ); while (1) { print \"=\" x int(rand(50)) . rand(100); usleep(rand(int(1000000))); }"';



# "open modified", opens all modified files in the current git directory
function om {
    $EDITOR $(git status --short | awk '$1 ~ /^M$/ {print $2}')
}



# git-based tab-autocomplete
#source ./git-completion.bash

# turn it on for the shortened aliases from before
#__git_complete g _git
#__git_complete gch _git_checkout
#__git_complete gd _git_diff
#__git_complete gb _git_branch
