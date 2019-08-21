# jshortcuts

Shell script tools to improve development workflow.

## Description

This is the jebri-shortcuts pack.
Put simply, I made these lightweight tools to make your work quicker and easier!

For all scripts, simply type the alias in the terminal to run the tool.
See [List of Shortcut Tools](#list-of-shortcut-tools) for the aliases.

I built these while working at Candi Controls and on Altair Engineering's SmartEdge team.
Many of these tools are primarily useful only for an Engineer working with Altair SmartWorks at this time.

## Getting Started

### Setting Up Your Bash Profile

Rather than the traditional method of putting CLI tools in a `bin/` directory, I opted to go with aliases.
This makes installation a little less fool-proof, but easier to reverse.
It also allows all the code to stay in this git repository, located anywhere you like on your computer.

To use jshortcuts, we'll need to simply add the correct lines to our bash profile.
If you don't have a file called `.bash_profile` in your home directory, you'll want to make one  (e.g., `touch ~/.bash_profile`).
Now, you can edit that file with your favorite editor (e.g., `nano ~/.bash_profile`).

Here's an example of some lines you will want to add to your `~/.bash_profile` in order to take advantage of these shortcuts:

```
# ========== jshortcuts ==========

# Globals

JSHOR='[/path/to/jshortcuts]'

# Aliases

source "$JSHOR/util/aliases.sh"
```

Note that the `[/path/to/jshortcuts]` above should be replaced with the path to the root of this repo, without the trailing slash.
For me, this is `/Users/jebrii/jdev/jshortcuts`.

Once you are finished, save the changes to the file (e.g., `Ctrl + O` if you opted to use `nano`).
Now, run `source ~/.bash_profile` to make the terminal recognize the changes you have made and assign the aliases.

### Configuration

Before starting, check out the `util/.jshor_config.example` file and set up defaults specific to your environment.
You will want to change all the following variables:

* `ssh_keys` - By default, this is your `.ssh/` folder, which usually sits in your home directory. You will want to replace "[your-user]" with your username.
* `ssh_key_gw` - This is the path to the specific identity key you use to ssh into Gateways. Generally, this is the `candi4k` key.
* `default_subnet` - This is the first three octets of the LAN subnet on which you operate in your office. At the Altair SmartEdge HQ, devices are addressed as "10.38.0.XXX", so mine is "10.38.0".
* `sn_index` and `iface` - You should leave these as they are, unless you have an extra interface that you need to circumvent on your system. I will add more details in a later version.
* `user` and `dest` - These are used for ssh-ing into Gateways. You are probably an Altair team member, and so these should stay as they are. If not and you are using `go` ssh into servers as a user other than "root", then change `user` accordingly.
* `dag_pages` - This is an array of extensions used to access standard diagnostic pages for Altair SmartEdge Gateways. Change these if you need `dag` to bring up different pages.
* `al_iface` - This is the interface to alias with `ala` by default. This usually will be your primary network interface. By default, it's set to "en0", which (on Macs) represents your WiFi interface. If you use something else often, then change it accordingly (*hint*: To view your network interfaces, type `ifconfig` into the terminal).
* `al_ip` - This is the IP address that will be added by default as an alias if nothing else is specified. If you are frequently trying to alias to a specific IP, put it here and you can use `ala` without specifying your alias every time.
* `al_nm` - You can leave this unchanged.
* `proj` - This represents the project abbreviation used in JIRA for your tickets. Replace this with the project you use the most often.
* `browser` - Your preferred browser, written as the .app file appears in your `/Applications` folder. For instance, `/Applications/Firefox.app` would be "Firefox" and `/Applications/Google\ Chrome.app` would be "Google Chrome".
* `jira_server` and `conf_server`- These represent the addresses where your JIRA and Confluence instances are respectively hosted. Replace these with the addresses to your specific instances.

Once you are finished, save the file as `.jshor_config` (without the "`.example`" extension).
Now you are ready to run the scripts!

## List of Shortcut Tools

All these tools have robust help pages.
Please refer to them for further details and options by adding `-h` to the end of the command.

* `addkeys` (src/add_keys.sh) - Quickly adds all keys in your .ssh keys folder (specified in configs) to the keychain. *Note*: There's no help page for this tool. It takes no arguments and all configuration is done in `util/.jshor_config`.
* `ala` (src/alias_adder.sh) - Quickly adds an alias to a specified network interface.
* `dag` (src/dag.sh) - Opens diagnostic pages for a Gateway at a specified local IP address.
* `gimme` (src/gimme.sh) - Quickly ssh-es into a Gateway at a specified IP and secure copies a file or directory between the Gateway and your local machine.
* `go` (src/go.sh) - Pings a Gateway at a specified local IP address and ssh-es into it if it finds it to be online.
* `conf` (src/open_conf.sh) - Quickly opens Confluence, with optional arguments to go to specific pages.
* `jira` (src/open_jira.sh) - Quickly opens JIRA, with optional arguments to go to specific dashboards, filters, searches, or to open one or more specific tickets by number.
* `peek` (src/peek.sh) - Quickly opens a specified local IP address in your browser to view. This is useful for local devices t hat serve up GUIs or have info you want to be able to see quickly.

## Directory Structure

As of the authorship of this readme, the directory structure is as follows:
```
jshortcuts
├── README.txt
├── util/
│   ├── help_pages/
│   │   ├── add_keys_help.txt
│   │   ├── alias_adder_help.txt
│   │   ├── dag_help.txt
│   │   ├── gimme_help.txt
│   │   ├── go_help.txt
│   │   ├── open_conf_help.txt
│   │   ├── open_jira_help.txt
│   │   └── peek_help.txt
│   ├── .jshor_config
│   ├── aliases.sh
│   ├── findSubnet.sh
│   └── sanitize.sh
└── src/
    ├── add_keys.sh
    ├── alias_adder.sh
    ├── dag.sh
    ├── gimme.sh
    ├── go.sh
    ├── open_conf.sh
    ├── open_jira.sh
    └── peek.sh
```

Disclaimer: This is my first library of scripts.
I didn't follow any particular standard for directory structure or known best practice.

## Supported Systems

jshortcuts requires Mac OS 10.12 or above.
It basically doesn't work with anything else.

If you don't use Mac... Sorry?? ...you know... for, like, your life choices and all. But, yeah... you can't use this tool.
