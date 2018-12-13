# jshortcuts
Some fun bash tools to improve one's workflow.

This is the jebri-shortcuts pack. I make fun little scripts to make your work quicker!

Most of these were built specifically for the Altair Engineering QA/Field Ops user.



Use of these shortcuts are enhanced with the addition of aliases and colors.

These can be used easily when added to your ~/.bash_profile.

Here's an example of some lines you might want to add to your ~/.bash_profile:

----------------------------------------------------

# ========== jshortcuts ==========

# Globals

JSHOR='[/path/to/jshortcuts]'

# Aliases

source "$JSHOR/resources/aliases.sh"

----------------------------------------------------

After you edit your bash profile, make certain to run "source ~/.bash_profile"
to make certain the aliases are committed.

Be certain to check out the resources/.jshor_config file and set up defaults
specific to your environment.

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


Disclaimer: This is my first library of scripts. I didn't follow any particular
standard for directory structure or known best practice.
