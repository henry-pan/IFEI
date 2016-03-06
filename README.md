# IFEI - Interactive Fiction Engine and Interpreter

###Authors: Steven Mazliach, Kavya Rammohan, Henry Pan, Thais Aoki. 
Interactive Fiction (Text Adventure) game engine and interpreter, implemented in both Haskell and Java.

With IFEI, users can create, share, and play their own interactive fiction (Text Adventure) games without needing any sort of programming or game creation skills!

##Creating your own text adventure game
Making your own games on IFEI is easy!

An IFEI game is a `txt` file. Each game is composed of "rooms", which contain "paths" to other "rooms". Note that a "room" does not necessarily mean a physical room; it's more like a page in a book.

Below is the list of formatting rules that your game file must follow. If you are unsure about formatting, you can check the sample games or templates.

###Formatting Rules
For your text adventure game to run correctly on IFEI, it must follow these rules:
- Rooms must be indicated with a Room tag `[Room ID]`, where `ID` is the room number.
- The first Room of the game must be Room 1.
- Rooms must be listed in consecutive order, i.e. `[Room 1]` must be followed by `[Room 2]`, if `[Room 2]` exists.
- Rooms must be separated from others with two newlines.
- Paths must be indicated with a Path tag `[Path-to ID]`, where `ID` is the room that the path leads to.
- Paths must lead to a Room that exists.
- Path text must be distinct; one path cannot be identical to another path in the same room.
- Path text cannot contain only these reserved keywords: `exit`, `exit!`, `eject`, `eject!`, `restart`, `restart!`, `repeat`, `help`.

##Playing a text adventure game
To play a text adventure game, place a game file in the same directory as IFEI. Open IFEI and follow the on-screen instructions. You will be asked to load the game, which you can do by just typing the name of the game. To take a "path", type in the path name (indicated with a `-`) word for word. If you are ever unsure about commands, you may type `help` and IFEI will display a list of commands that can be typed.
###System Commands
Commands requiring double-entry can be forced without confirmation using an `!` at the end, like `exit!`.

Command | Function
--- | ---
`help` | Displays the list of available commands.
`repeat` | Shows the text of the current room.
`restart` | Restart the game. **Requires double-entry.**
`eject` | Eject currently loaded game to load another one. **Requires double-entry.**
`exit` | Quit the game and IFEI. **Requires double-entry.**
