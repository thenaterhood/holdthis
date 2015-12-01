# HoldThis

HoldThis is a simple Ruby script for bookmarking and retrieving
commands and paths. HoldThis was born out of the fact that I frequently
paste commands and paths I need to remember for a while into the nearest
chat window prefaced with "hey hold this for a sec" until I need
them again.

## Usage

    holdthis -l # List the bookmarks holdthis is currently holding
    holdthis -n <name> <path/command> # Create a new bookmark with the given name (overwriting any that already exist)
    holdthis <name> # Open, call, or go to the path/command under <name>
    holdthis -d <name> # Delete the bookmark with the given name

Some useful usages:

    holdthis -n foo !! # Bookmark the previous command as "foo"
    holdthis -n here `pwd` # Bookmark the current path as "here"

HoldThis stores your bookmarks in ~/.holdthis. This is a Yaml file
so feel free to manually edit it.

Be aware that HoldThis will not do any checking of whether bookmarked
commands are malicious and may not properly avoid shell injection issues.
Prior to executing a command, HoldThis will print it to the console and
provide the option to cancel. For opening/editing files, HoldThis does
not do any verification.

## Installation
Install holdthis.rb to somewhere in your path and rename it to holdthis.
Make sure it's executable.

## License
HoldThis is licensed under the MIT license (included as LICENSE).

Though not required by the license terms, please consider contributing,
providing feedback, or simply dropping a line to say that this software
was useful to you. Pull requests are always welcome.
