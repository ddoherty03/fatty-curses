# fatty-curses

## About this fork

This is a temporary fork of [ruby/curses](https://github.com/ruby/curses)
for portable terminal suspension in [Fatty](https://github.com/ddoherty03/fatty),
the terminal interface used by [byr](https://github.com/ddoherty03/byr).

Fatty needs to leave curses mode while an editor or another interactive program
runs, then resume its existing screen. The upstream `Curses.close_screen` calls
`endwin()` but also clears Ruby's cached screen object. Fatty's Unix workaround
calls the native `endwin` symbol directly; that symbol is not exposed by the
Windows build we tested.

The `preserve-screen-suspension` branch adds **`Curses.endwin`**, which calls
`endwin()` without clearing the cached Ruby screen object. It returns `true`
on success and `false` on failure. Existing windows can be refreshed to resume
curses mode. The binding works with both ncurses and PDCurses; it is not a
Windows-only API.

Repeated suspension tests pass on Linux and Windows, including retaining a
window across garbage collection and running a child process. The regression
probe is [test/suspension.rb](test/suspension.rb). The earlier Fatty redraw
and shutdown defects were fixed in Fatty; this fork provides the suspension API.

The fork is distributed as **`fatty-curses`**, beginning with version `1.7.0.1`
(upstream `1.7.0` plus the suspension patch). Fatty depends on it directly, so
RubyGems installs it automatically for applications such as Byr. No Git checkout
or separate manual dependency installation is needed by end users.

Use `require "fatty-curses"` to explicitly select this fork. The existing
`require "curses"` entry point and `Curses` API remain available. Stock curses
can remain installed for other applications, but do not load both extensions
in the same Ruby process.

We intend to submit the binding and regression probe upstream. `gem install
curses` still installs upstream, without selecting this fork. The badges below
refer to the upstream project.

---

[![Gem Version](https://badge.fury.io/rb/curses.svg)](https://badge.fury.io/rb/curses)
[![ubuntu](https://github.com/ruby/curses/workflows/ubuntu/badge.svg)](https://github.com/ruby/curses/actions?query=workflow%3Aubuntu)
[![windows](https://github.com/ruby/curses/workflows/windows/badge.svg)](https://github.com/ruby/curses/actions?query=workflow%3Awindows)
[![macos](https://github.com/ruby/curses/workflows/macos/badge.svg)](https://github.com/ruby/curses/actions?query=workflow%3Amacos)

* https://github.com/ruby/curses
* https://github.com/ruby/curses/issues

## Description

A Ruby binding for curses, ncurses, and PDCurses.
curses is an extension library for text UI applications.

Formerly part of the Ruby standard library, [curses was removed and placed in this gem][1]
with the release of Ruby 2.1.0. (see [ruby/ruby@9c5b2fd][2])

## Install

    $ gem install fatty-curses

Requires ncurses or ncursesw (with wide character support).
On Debian based distributions, you can install it with apt:

    $ apt install libncurses5-dev

Or

    $ apt install libncursesw5-dev

On Windows, `gem install fatty-curses` will build bundled PDCurses, so you
don't need to install extra libraries.
However, if you prefer ncurses to PDCurses, specify the following option:

    > gem install fatty-curses -- --use-system-libraries

On mingw, you need DevKit to compile the extension library.

On MacOS, `ncurses` menu isn't natively supported. You can install the gem with menu support using homebrew:

    brew install ncurses
    gem install fatty-curses -- --use-system-libraries --with-ncurses-dir=/usr/local/opt/ncurses

_with `/usr/local/opt/ncurses` the path where homebrew installed ncurses on your machine_

## Documentation

Type the following command, and see `[rdoc]` of curses:

    gem install rubygems-server
    gem server -l

## Limitations

* On ncurses 6+ compiled with extended color support, more than 256 color pairs are supported transparently via the extended colors API (`init_extended_pair`, etc.). Use `Curses.support_extended_colors?` to check at runtime.

## Developers

After checking out the repo, run `bundle install` to install dependencies.

To compile the extension library, run `bundle exec rake compile`.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `fatty-curses.gemspec`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

curses is released under the Ruby and 2-clause BSD licenses.  See COPYING for
details.

It includes PDCursesMod, which is in the public domain:

  https://github.com/Bill-Gray/PDCursesMod

The version for Win32 console mode in the wincon subdirectory is used.

[1]: https://bugs.ruby-lang.org/issues/8584
[2]: https://github.com/ruby/ruby/commit/9c5b2fd8aa0fd343ad094d47a638cfd3f6ae0a81
