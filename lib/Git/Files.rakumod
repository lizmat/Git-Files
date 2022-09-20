use path-utils:ver<0.0.9>:auth<zef:lizmat> <
  path-exists
  path-is-directory
  path-is-github-repo
>;

# Public API for listing files in git repo
my sub git-files(*@paths, :$non-existing-also) is export {
    my str $prefix = "";

    # Return git files from current working directory, recursively
    my sub git-files-cwd() {
        my $proc := run <git ls-files>, :out, :err;
        if $proc.err.slurp -> $error {
            die $error;
        }
        $proc.out.lines(:close).map({
             my str $path = $prefix ~ $_;
             path-exists($path)
               ?? path-is-directory($path)
                 ?? path-is-github-repo($path)
                   ?? git-files($_)
                   !! Empty
                 !! $path
               !! $non-existing-also
                 ?? $path
                 !! Empty
        }).Slip
    }

    if @paths {
        @paths.map( -> $path {
            temp $*CWD = $path.IO;
            $prefix    = $path ~ $*SPEC.dir-sep;
            git-files-cwd
        }).Slip
    }

    # just the current dir
    else {
        git-files-cwd
    }
}

=begin pod

=head1 NAME

Git::Files - List known files of a git repository

=head1 SYNOPSIS

=begin code :lang<raku>

use Git::Files;

.say for git-files;          # current directory

.say for git-files <lib t>;  # "lib" and "t" dirs from current dir

.say for git-files :non-existing-also;  # also non-existing files

.say for git-files "/path/to/git/repo";      # all files in git repo
.say for git-files "/path/to/git/repo/dir";  # files in dir in git repo

=end code

=head1 DESCRIPTION

The C<Git::Files> distribution exports a single subroutine C<git-files> that
takes zero or more paths, and returns a C<Slip> of paths (as strings)
of all the files that are known to Git in the specified paths.

If no paths are specified, will assume the current directory.

Since it is possible that Git still knows about files that have been
deleted, but not yet committed, returned paths may not actually exist.
These will not be returned, unless the C<:non-existing-also> named
argument is specified with a true value.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Git-Files .
Comments and Pull Requests are welcome.

If you like this module, or what I’m doing more generally, committing to a
L<small sponsorship|https://github.com/sponsors/lizmat/>  would mean a great
deal to me!

=head1 COPYRIGHT AND LICENSE

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
