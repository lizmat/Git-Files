use path-utils:ver<0.0.21+>:auth<zef:lizmat> <
  path-exists path-is-directory path-is-github-repo
>;

# Public API for listing files in git repo
my sub git-files(*@paths, :$non-existing-also) is export {
    my str $prefix = "";

    # Return git files from current working directory, recursively
    my sub git-files-cwd() {
        run(<git ls-files>, :out).out.lines(:close).map({
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
        }).Slip;
    }

    if @paths {
        @paths.map( -> $path {
            my $io := $path.IO;
            if $io.f {
                $_ with git-files-cwd.first(* eq $path)
            }
            elsif $io.d {
                temp $*CWD = $io;
                $prefix    = $path ~ $*SPEC.dir-sep;
                git-files-cwd
            }
        }).Slip
    }

    # just the current dir
    else {
        git-files-cwd
    }
}

# vim: expandtab shiftwidth=4
