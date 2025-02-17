# dots

Set up as a git bare repo https://www.atlassian.com/git/tutorials/dotfiles

Repo config:

- Hide untracked files: `dots config --local status.showUntrackedFiles no`

- Sparse checkout to not pull README or LICENSE: `dots config --local core.sparsecheckout true`

  - `~/.dots/info/sparse-checkout`
    ```
    /*
    !README.*
    !LICENSE
    ```
