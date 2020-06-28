# yapman

![yapman logo](/mnt/this/Data/Projects/programming/linux/yapman/yapman-logo3.png)

**YAPMAN** 2.0 (Yet Another AUR Package Manager) is AUR helper. It is not like any other AUR helper this is much more simple.

## Why should I choose this one

I can hear you. Because of these:

* Lightweight,
* Powerful,
* Customizable & Configurable,
* Minimal dependency,
* and etc.

## Usage is very simple

Simple to install any package:

```bash
yapman -i <package(s)>
```

Simple to update all:

```bash
yapman -u
```

Simple to remove any installed package:

```bash
yapman -r <package(s)>
```

Getting more help:

```bash
yapman -h
```

Getting help about specific command:

```bash
yapman -h <command>
```

For more look at `USAGE.md` file

## Example Configuration File

```yapman.conf
#/usr/bin/env bash
# [General]

# Colorful by default. If you want to disable
# the fancy colorful outputs just uncomment the below line
#colorful_output="false"

# yapman uses "Bold texts" by default to achieve
# more friendly looking. If you want to disable this
# just uncomment out the below line.
#bold_output="false"

# yapman uses some colorful and bold texts to
# achieve more user friendly looking. To disable this
# uncomment the line below.
#no_visual="true"

# yapman uses logging by default.
# To disable, uncomment the line below.
#no_log="true"

# yapman cleans up work files after build.
# To disable, uncomment the line below.
#clean_after_build="false"

# yapman syncs missing dependencies with pacman.
# To disable, uncomment the line below.
#sync_missing_deps_pacman="false"

# yapman removes installed dependencies after successful build.
# To disable, uncomment the line below.
#remove_deps_after_build="false"
```

## Upcoming features

* Logging
* Manual Pages...
* Redesign/Rewrite the whole project again
* Modular design

