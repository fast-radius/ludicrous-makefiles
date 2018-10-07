# Ludicrous Makefiles

[![Build Status](https://travis-ci.org/martinwalsh/ludicrous-makefiles.svg?branch=master)](https://travis-ci.org/martinwalsh/ludicrous-makefiles)

## Goals

1. Provide a useful set of primitives for use with various project types
    - artifact downloader
    - automatic help text generation
    - semi-automatic prerequisite checking
    - semi-automatic cleanup
2. Not too much magic
3. Unit tests
4. Mechanism for for inclusion of primitives in an ala carte fashion
5. Ability to override behaviors via local config (not implemented)

## Starting a new project

Run the following command in the root of your project:

```
make -f <(curl -L https://git.io/fxs2w)  # release: v2018.10.1
```

Edit the generated `Makefile` and add any useful includes as necessary (see
[includes/](https://github.com/martinwalsh/ludicrous-makefiles/tree/master/includes) for more
examples):

```
# Makefile
include .makefiles/virtualenv.mk
```

Run `make` to download the added includes:

```
$ make
===> downloading .makefiles/virtualenv.mk
```

## Rationale

As a sysadmin by trade, I've come to appreciate the GNU Make utility as a general purpose automation
tool. Make is useful for many project types, and not just those involving compiled languages.  It's
a relatively easy choice, as Make is typically part of the standard development tool-chain. In fact,
there's a good chance you already have GNU Make installed whether you realize it or not.

In addition to its ubiquity, Make's syntax is straightforward. Its concept of a recipe is easy to
understand even for those who don't use it often. A recipe defines a target, its dependencies and
the shell commands used to build it. As such, Make recipes are also self-documenting.

I'm no expert by any means, but I have used Make with great success in my work as a sysadmin.
During this time a number of patterns have surfaced. And so the purpose of this project is to
explore those patterns. Put them down into a sharable form, so that they can be improved over time
and new patterns might be found.
