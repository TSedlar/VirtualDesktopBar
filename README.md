# VirtualDesktopBar
A Rainmeter widget that displays user-specified workspace tabs

<a href="https://streamable.com/ubweq">
  <img src="https://i.imgur.com/OrpNqET.gif" width="640" height="360"></img>
</a>

## Requirements

This project makes use of of two main projects:
- [Rainmeter](https://www.rainmeter.net/), which is required to be installed.
- [AutoHotKey](https://www.autohotkey.com/)

## Installing

Installation can be done by simply [Downloading](https://github.com/TSedlar/VirtualDesktopBar/archive/master.zip) the master branch and extracting it to `Documents/Rainmeter/Skins/`

## Setting things up

Within your main `Rainmeter.ini`, you're going to want to set up a `DesktopWorkArea`. This will make windows not collide with the taskbar when they are maximized.

As an example for my monitor, which is 2560x1440:

Rainmeter.ini should contain:
```
DesktopWorkArea=41,34,2556,1436
```

This all depends on your taskbar height, etc.

## Shout outs

- [windows-desktop-switcher](https://github.com/pmb6tz/windows-desktop-switcher) for portions of the AHK script
- [material-shell](https://github.com/PapyElGringo/material-shell) for the UI idea and icons

## Suggestions

Use this with Microsoft's [PowerToys](https://github.com/microsoft/PowerToys), so you can set window zones and tile windows!

## Other Info

It should be pretty straight forward to make changes to the configuration of this widget.

To change colors and sizes, go [here](https://github.com/TSedlar/VirtualDesktopBar/blob/master/VirtualDesktopBar.ini#L16-L22).

To modify workspace categories, you can add, change, or remove [here](https://github.com/TSedlar/VirtualDesktopBar/blob/master/VirtualDesktopBar.ini#L32-L48).

Lastly, when adding categories, make sure to add a matching icon with the same name under [assets/images](https://github.com/TSedlar/VirtualDesktopBar/tree/master/assets/images)
