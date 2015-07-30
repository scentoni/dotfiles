% dotfiles
% Scott Centoni
% 2015-02-17

Set up dotfiles with [Homesick](https://github.com/technicalpickles/homesick)
or [homeshick](https://github.com/andsens/homeshick).

## Using Homesick

```
gem install homesick
homesick clone scentoni/dotfiles
homesick symlink dotfiles
```

Problems with older versions of [Bash](http://lists.gnu.org/archive/html/bug-bash/2007-07/msg00036.html).

## Using Homeshick

```
git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
homeshick clone scentoni/dotfiles
```

## removing this castle

```
rm -rf $HOME/.homesick/repos/dotfiles
```

