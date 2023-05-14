# gh-cat

Concatenate and print the contents of files from a remote GitHub repository

```
Usage: gh cat repo path ...

Concatenate and print the contents of files in a GitHub repo

Arguments:
    repo            like: username/repo
    path            file path within the repo

Options:
    -h, --help      print usage
    -v, --version   print version
    -V, --verbose   enable debug output
    -b, --branch    branch or tag name

Dependencies: curl

Examples:
    gh cat jparise/gh-cat README.md
    gh cat jparise/gh-cat README.md LICENSE > file
    gh cat cli/cli -b trunk README.md
```

It can be run as a standalone executable (`gh-cat`) or as a
[GitHub CLI extension](https://cli.github.com/manual/gh_extension).

## Installation

```sh
gh extension install jparise/gh-cat
```

### Dependencies

* [`curl`](https://curl.se/)
* [`gh`](https://cli.github.com/)

## Examples

```sh
# Print the contents of README.md from the jparise/gh-cat repository
$ gh cat jparise/gh-cat README.md

# Print the concatenated contents of README.md and LICENSE and redirect that
# output to `file`
$ gh cat jparise/gh-cat README.md LICENSE > file

# Print the contents of README.md from the cli/cli repository's `trunk` branch
$ gh cat cli/cli -b trunk README.md
```

## License

This code is released under the terms of the MIT license.
See [`LICENSE`](LICENSE) for details.
