# bootstrapping

This repo captures some decisions about how I bootstrap a new
computer. It helps me spend less time in the setup by making some of
my preferred configurations repeatable. I don't even try to run this
install start to finish anymore. I update this README and the related
code when I bootstrap a new device, so I can remember what worked last
time.

I write the scripts to be mostly idempotent. It shouldn't hurt to
re-run them.

### As of September 2025

Here's the order of operations as best as I can reconstruct from
.zhistory. I was tempted to overhaul this code for the minimum needed
to make emacs, git, and the terminal work. I was tempted to adopt
nix. But my impatience won out.

    xcode-select --install
    git clone https://github.com/dobbs/dotfiles.git workspace/dobbs/dotfiles
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    /opt/homebrew/bin/brew shellenv >> .zprofile
    source .zprofile
    brew install --cask emacs --no-quarantine
    brew install --cask ghostty
    brew install --cask 1password

### generate ssh key for github
    mkdir -p ~/.ssh
    ~/workspace/dobbs/dotfiles/home/bin/d-keygen github.com
    open https://github.com/settings/ssh/new
    pbcopy < ~/.ssh/github.com/id_ecdsa.pub
    # title: mbp:~/.ssh/github.com/id_ecdsa.pub
    # key: paste from clipboard
    # click Add SSH key
    cd ~/workspace/dobbs/dotfiles
    git remote set-url origin git@github.com:dobbs/dotfiles.git

### all the other things

    cd ~/workspace/dobbs/dotfiles
    ./install.sh prelude
    ./install.sh brews
    ./install.sh casks
    ./install.sh dotfiles
    ./install.sh emacs-packages
    ./install.sh all

### When xcode-select doesn't work

xcode-select failed once. So I installed the CLI tools manually:
https://developer.apple.com/download/more/?=xcode

### update emacs packages

I do this rarely, and it's painful when I do. I do not have the
patience do develop fluency in emacs packages. Here are some notes
from the most recent episode of yak shaving stupid package conflicts.

    rm -rf ~/.emacs.d       # nuke the existing configuration
    ./install.sh prelude    # reinstall prelude defaults
    ./install.sh dotfiles   # fixes the symlink at ~/.emacs.d/personal

edit 'package-selected-packages in ./home/.emacs.d/personal/custom.el
oh-my-zsh emacs plugin launches emacs in deamon mode. So we have to
quit emacs from the MacOS application menu to close that deamon.

    ./install.sh emacs-packages
    e .

spot check editing:

double-check magit by testing a commit of the changes. This is one of
the main things that has broken in past upgrades.

double-check a javascript file to be sure indent configurations are
correctly set to two spaces (default is 4)

#### shell script to inspect changes to package-selected-packages

Review the diff of changes made to 'package-selected-packages. Copy
the old list into OLDER and the new list into NEWER. Then run this
command to get a readable report of the differences.

    OLDER="..."
    NEWER="..."

    echo -e "\nThings only in OLDER & not in NEWER"
    comm -23 <(tr ' ' "\n" <<<$OLDER | sort) <(tr ' ' "\n" <<<$NEWER | sort)

    echo -e "\nThings only in NEWER & not in OLDER"
    comm -13 <(tr ' ' "\n" <<<$OLDER | sort) <(tr ' ' "\n" <<<$NEWER | sort)

### maybe emacs updates would be easier if I did this more often

When I update rarely, some of these steps fail on conflicting packages
changes. Maybe if I think do this more frequently, the conflicts will
be simpler to resolve.

Inside emacs:

    M-x package-list-packages    # view all the packages
    / u                          # filter to view upgradable ones
    U                            # mark them to upgrade
    x                            # do the actual upgrades
    M-x prelude-update-packages  # update prelude packages
    M-x prelude-update           # update prelude itself
