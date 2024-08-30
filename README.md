# gh-cat

Concatenate and print the contents of files from a remote GitHub repository

```
Usage: gh cat repo path ...

Concatenate and print the contents of files in a GitHub repo

Arguments:
    repo            like: username/repo
    path            file path within the repo

Options:
    -b, --branch    branch or tag name
    -c, --cmd       cat-style output command
    -h, --help      print usage
    -v, --version   print version
    -V, --verbose   enable debug output

Dependencies: curl

Examples:
    gh cat jparise/gh-cat README.md
    gh cat jparise/gh-cat README.md LICENSE > file
    gh cat jparise/gh-cat -c "bat --number" README.md
    gh cat cli/cli -b trunk README.md
```

It can be run as a standalone executable (`gh-cat`) or as a
[GitHub CLI extension](https://cli.github.com/manual/gh_extension).

Files will be piped to a cat-style command for printing. The first available of
`batcat`, `bat`, or `cat` will be used by default, but this command can also be
explicitly specified using the `--cmd` option.

When [bat][] is used, its `--file-name` argument will be added automatically.

[bat]: https://github.com/sharkdp/bat

## Installation

```sh
gh extension install jparise/gh-cat
```

### Dependencies

* [`curl`](https://curl.se/)
* [`gh`](https://cli.github.com/)
* [`bat`](https://github.com/sharkdp/bat) (optional)

## Examples

```sh
# Print the contents of README.md from the jparise/gh-cat repository
$ gh cat jparise/gh-cat README.md

# Print the concatenated contents of README.md and LICENSE and redirect that
# output to `file`
$ gh cat jparise/gh-cat README.md LICENSE > file

# Print the contents of README.md using the command `bat --number`.
$ gh cat jparise/gh-cat -c "bat --number" README.md

# Print the contents of README.md from the cli/cli repository's `trunk` branch
$ gh cat cli/cli -b trunk README.md
```

## License

This code is released under the terms of the MIT license.
See [`LICENSE`](LICENSE) for details.
