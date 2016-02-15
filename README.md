# IFEI - Interactive Fiction Engine and Interpreter

###Authors: Steven Mazliach, Kavya Rammohan, Henry Pan, Thais Aoki. 
Interactive Fiction (Text Adventure) game engine and interpreter, created with Haskell and Java.

With IFEI, users can create, share, and play their own interactive fiction (Text Adventure) games!


#Formatting Rules
For your text adventure game to run correctly on IFEI, it must follow these rules:
- Rooms must be indicated with a Room tag `[Room ID]`, where `ID` is the room number.
- Rooms must be listed in consecutive order, i.e. `[Room 1]` must be followed by `[Room 2]`, if `[Room 2]` exists.
- Rooms must be separated from others with two newlines.
- Paths must be indicated with a Path tag `[Path-to ID]`, where `ID` is the room that the path leads to.
- Path text must be distinct; one path cannot be identical to another path in the same room.
- Path text cannot contain these reserved keywords: `exit`.
