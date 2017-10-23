# jshortcuts
Some fun bash tools to improve my workflow.

This is the jebri-shortcuts pack. I make fun little scripts to make your work quicker!

Most of these were built specifically for the Candi QA/Field Ops user.

Make certain the jshortcuts folder is in your home directory (~/ or /Users/[yourUser]/)

Use of these shortcuts are enhanced with the addition of aliases and colors.

These can be used easily when added to your ~/.bash_profile.

Here's an example of some lines you might want to add to your ~/.bash_profile

----------------------------------------------------

# ========== jshortcut aliases ==========

# Globals

JSHOR='/Users/[your-user]/jshortcuts'

RED='\033[0;31m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'
PURPLE='\033[0:35m'
NC='\033[0m'
BLACK='\033[0;30m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BROWN='\033[0;33m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTBLUE='\033[1;34m'
LIGHTGREEN='\033[1;32m'
LIGHTCYAN='\033[1;36m'
LIGHTRED='\033[1;31m'
LIGHTPURPLE='\033[1;35m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'

# Aliases

source "$JSHOR/resources/aliases.sh"

----------------------------------------------------

After you edit your bash profile, make certain to run "source ~/.bash_profile" to make
certain the aliases are committed

As of the authorship of this readme, the directory structure is as follows:

jshortcuts
  README.txt
  .old
    [old/deprecated scripts]
  resources
    .help_pages
      [help pages for all scripts]
    .jshor_config
    aliases.sh
    findSubnet.sh
    sanitize.sh
  scripts
    add_keys.sh
    alias_adder.sh
    dag.sh
    gimme.sh
    go.sh
    open_jira.sh
    peek.sh
    showBMPProducts.php
