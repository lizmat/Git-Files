[![Actions Status](https://github.com/lizmat/Git-Files/actions/workflows/linux.yml/badge.svg)](https://github.com/lizmat/Git-Files/actions) [![Actions Status](https://github.com/lizmat/Git-Files/actions/workflows/macos.yml/badge.svg)](https://github.com/lizmat/Git-Files/actions) [![Actions Status](https://github.com/lizmat/Git-Files/actions/workflows/windows.yml/badge.svg)](https://github.com/lizmat/Git-Files/actions)

NAME
====

Git::Files - List known files of a git repository

SYNOPSIS
========

```raku
use Git::Files;

.say for git-files;          # current directory

.say for git-files <lib t>;  # "lib" and "t" dirs from current dir

.say for git-files :non-existing-also;  # also non-existing files

.say for git-files "/path/to/git/repo";      # all files in git repo
.say for git-files "/path/to/git/repo/dir";  # files in dir in git repo
```

DESCRIPTION
===========

The `Git::Files` distribution exports a single subroutine `git-files` which takes zero or more paths, and returns a `Slip` of paths (as strings) of all the files that are known to Git in the specified paths.

If no paths are specified, will assume the current directory.

Since it is possible that Git still knows about files that have been deleted, but not yet committed, returned paths may not actually exist. These will not be returned, unless the `:non-existing-also` named argument is specified with a true value.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Git-Files . Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

COPYRIGHT AND LICENSE
=====================

Copyright 2022, 2024, 2025 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

