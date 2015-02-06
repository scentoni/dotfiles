Set up dotfiles with [Homesick](https://github.com/technicalpickles/homesick)
or [homeshick](https://github.com/andsens/homeshick).


## Using Homesick


```
gem install homesick
homesick clone scentoni/dotfiles
homesick symlink dotfiles
```

## Using Homeshick
```
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh" 
homeshick clone scentoni/dotfiles
```

## removing this castle

```
rm -rf $HOME/.homesick/repos/dotfiles
```
