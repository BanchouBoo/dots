## Notice
These are purely for reference purposes. If you aren't me you should not try to clone and use these directly. You are free to use whatever is here however you want, though.

## Setup Notes
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
