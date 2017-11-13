## Keyboard-war
Bullet hell game with kaomoji-based characters. Early pre-pre-alpha stage. Game's name is to be changed.

Most of the code is written in Moonscript. I won't compile the code to Lua before it gets to release, so LPeg library is **required** to run the game. Moonscript is not required, though (because I have it in a single file: see moonyscript.lua).

If you want to use Moonscript with Love2d without too much problems (i.e. wrong error line numbers and need for compile step), you can have a look at this repo. You need 2 things:
* Use Moonscript loader to be able to require \*.moon files (see main.lua)
* Provide custom love.errhand function to rewrite error messages (see main.lua and util/errhand.lua)

## TODO
* [x] Playable prototype
* [x] Code cleanup
* [x] Code unstupiditification
* [x] Code cleanup
* [ ] Start using a level editor (Tiled? Make own? Stay with declarative description?)
* [ ] More playable prototype
* [ ] More enemies and bullet types
* [ ] More levels
* [ ] Procedural backgrounds
* [ ] Dialogs?
* [ ] ...
* [ ] More code cleanup
* [ ] Procedural sound
* [ ] Gamestate-based quasiprocedural music
* [ ] Code cleanup

## Source and project page
https://github.com/Penguinum/keyboard-war

## License
MIT (see LICENSE file)

## Engine
[LÖVE](https://love2d.org)

## Used 3rd party libraries and resources
Libraries:
* [HardonCollider](https://github.com/vrld/HC)
* [hump](https://github.com/vrld/hump)

Fonts:
* [Noto by Google](https://www.google.com/get/noto)
