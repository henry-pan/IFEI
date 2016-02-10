-----------------------------------------------------------------------
-- IFEI - Interactive Fiction Engine and Interpreter
-----------------------------------------------------------------------
import System.IO
import System.Directory

--Reads from a text file.
--fileLines is a list of the lines in text file. 
main = do
    putStrLn "Please load a game by typing in the name of the game file, without the file extension: "
    name <- getLine
    validFile <- doesFileExist (name ++ ".txt")
    if validFile
        then do
            handle <- openFile (name ++ ".txt") ReadMode
            contents <- hGetContents handle
            
            putStrLn $ "\n|=" ++ (replicate (length (name ++ " loaded.")) '=') ++ "=|"
            putStrLn $ "| " ++ name ++ " loaded. |"
            putStrLn $ "|=" ++ (replicate (length (name ++ " loaded.")) '=') ++ "=|\n"
            
            let fileLines = lines contents
            let command = getCommand fileLines
            putStrLn $ command
            hClose handle
        else do
            putStrLn "\n============================"
            putStrLn "| The file does not exist. |"
            putStrLn "============================\n"
            main

--Int: Room ID. Identifies the room.
--String: Text data associated with the room.
--[Path]: The list of paths that can be taken from the room.
data Room = Room Int String [Path]

--Int: Room ID. This is the room the path will lead to.
--String: The command that invokes the path.
data Path = Path Int String

{-|
We might want to create some sort of data structure to hold all the
room and path data. List of Tuples?
So the end result would be something like but dynamically generated:

gameData = [(Room0,[Paths0]) , (Room1,[Paths1]), (Room2,[Paths2])]


If we do this, we can easily grab a room using list indices.
We will need to implement some sort of exception handling in case
the user decides to number rooms out of order.

-}



--Gets first word from string line.
getFirstWord :: String -> String
getFirstWord [] = ""
getFirstWord x = head (words x)

--Gets lists of all the lines from input file, and does something depending on first word of string.
--BUG: Can't get it to recurse through the entire list, so for now it just reads the first item in list.
--Merge with createRooms?
getCommand :: [String] -> String
getCommand [] = ""
getCommand (c:cs)
    | x == "[Room" = printRoom (c,cs)
    | x == "[Path" = "Insert command function here"
    where x = getFirstWord c

    
--Take the words of the input file and turn it into a list of Rooms.
--createRooms :: [String] -> [Room]
    
    
--Prints a Room and its associated commands.
--(Text Data,[Commands]) -> Printed Room
--Temporary!
printRoom :: (String,[String]) -> String
printRoom (x,y) = unwords [x] ++ unwords y
