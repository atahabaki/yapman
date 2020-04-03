# Usage

Yapman is a tool for install/update/remove ... AUR package and more. It's very simple and can be customizable. Good luck! :D

## Operations:

Yapman is operation based tool. So, everything is operation for yapman.

Current operation lists:

* Initialize {init}
* Update {-u update}
* Install {-i install}
* Get {-g get}
* Grab information {-a info}
* Remove {-r remove}
* Search {-s search}
* Clear cache {-c clear-cache}
* Show version {-v version}
* Get help {-h help}

## Read this first

* Inside "\<" and "\>" means an array of similar things.

    `<package(s)>`: means package list

* Whatever gets inside these "{","}" means you can use any of them to get the things done.

    `{-i install}`: use "-i" or "install"

* "[","]" means optional.

    `[<operation>]`: pass an operation or don't.

That's all for now. Take care!..

## Updating all packages

It's really simple. Just paste this:

```
yapman -u
```

Or make an alias for this and its' length will be 4:

```bash
alias yapu="yapman -u"
```

whenever you type `yapu`, you simply typed `yapman -u`.

## Installing a package

Extremly simple:

```
yapman -i <package(s)>
```

## Getting a package

This one is different from installing package. The difference between is getting a package means (for this tool) downloading a package.

```
yapman -g <package(s)>
```

## Grabbing information about a(n) package(s)

Showing packages' information.

If you were curious about who did this package or what's the dependendies of this. Just type this:

```
yapman -a <package(s)>
```

## Removing package

Really simple:

```
yapman -r <package(s)>
```

## Search a package name

Searching package by its' name:

```
yapman -s <query(s)>
```

## Clear caches

Clear cache files, too easy:

```
yapman -c
```

## Show version

Nothing could be easier than this one:

```
yapman -v
```

## Getting more help

We care about you, so we put all information here and to man pages. You can find whatever you want.

```
yapman -h [<operation>]
```