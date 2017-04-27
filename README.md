# Ludicrous Makefiles

## Rationale

As a sysadmin by trade, I've come to appreciate the GNU Make utility as a
general purpose automation tool, useful for many project types and not just
those involving compiled languages. It's a fairly easy choice, as GNU Make is
part of the standard development tool-chain for most project types.  In fact, if
you have any interest in this project (and I would think so, since you're
reading this blather) there's a good chance you already have GNU Make installed.

In addition to its ubiquity, GNU Make's syntax is straightforward and its
concept of a recipe is relatively easy to understand even for folks who don't
use it often. A recipe defines a target, its dependencies and the shell commands
used to build it. And as such, recipes are self-documenting.

I'm no expert, by any means, but I have used Make to great success in my work as
a sysadmin. During this time a number of patterns have surfaced. Therefore, the
purpose of this project is to explore these patterns, put them down into a
sharable form while learning more about Make, so that they can be improved over
time. If useful to a broader audience, all the better.

## Goals

1. Provide a useful set of primitives for use with various project types
  - artifact downloader
  - automatic help text generation
  - semi-automatic prerequisite checking
  - semi-automatic cleanup
2. Not too much magic
3. A full unit test suite
4. Mechanism for for inclusion of primitives in an ala carte fashion
5. Ability to override behaviors via local config

## Starting a new project

```
make -f <(curl https://git.io/v93pb)
```

... More to come ...

