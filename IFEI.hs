-----------------------------------------------------------------------
-- IFEI - Interactive Fiction Engine and Interpreter
-----------------------------------------------------------------------
import System.IO
import System.Directory
import Data.Char
import Data.List.Split
import Data.Bool

-----------------------------------------------------------------------
-- I/O Aspects
-----------------------------------------------------------------------
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
            
            
            --Fancy ASCII display.
            putStrLn $ "\n==" ++ (replicate (length (name ++ " loaded.")) '=') ++ "=="
            putStrLn $ "| " ++ name ++ " loaded. |"
            putStrLn $ "==" ++ (replicate (length (name ++ " loaded.")) '=') ++ "==\n"
            
            
            putStrLn $ unwords $ splitFile contents
            --let fileLines = lines contents
            --putStrLn $ createRooms fileLines
            game
            hClose handle
        else do
            --Fancy ASCII display.
            putStrLn "\n============================"
            putStrLn "| The file does not exist. |"
            putStrLn "============================\n"
            main
        
        
--Command handling. For now, it will only accept Exit.       
game = do
    command <- getLine

    --map toLower command will take the command and make it all lower-case.
    --commands are not case sensitive.
    --TODO: Make a function that will handle all possible commands given from paths.
    if (map toLower command) == "exit"
        then do
            putStrLn "Are you sure you want to exit the game? Type 'exit' again to quit."
            command <- getLine
            if (map toLower command) == "exit"
                then putStrLn "Goodbye."
                else do
                    putStrLn "Cancelled."
                    game
        else do
            putStrLn "Invalid command."
            game
            

--processCommand
--Take input command and check paths for commmand
--If input and a path match, take that path.
--Path ID == Room ID == Destination Room
--processCommand :: String -> [Path] -> ???

-----------------------------------------------------------------------
-- Functional Aspects
-----------------------------------------------------------------------
--Int: Room ID. Identifies the room.
--String: Text data associated with the room.
--[Path]: The list of paths that can be taken from the room.
--data Room = Room Int String [Path]

--Int: Room ID. This is the room the path will lead to.
--String: The command that invokes the path.
--data Path = Path Int String

-- Creates a type synonym for gamedata 
type Gamedata = [Room]
type Room = (Int,String,[Path])
type Path = (Int, String)

{-|
We might want to create some sort of data structure to hold all the
room and path data. List of Tuples?
So the end result would be something like but dynamically generated:

gameData = [(Room0,[Paths0]) , (Room1,[Paths1]), (Room2,[Paths2]),...]


If we do this, we can easily grab a room using list indices.
We will need to implement some sort of exception handling in case
the user decides to number rooms out of order.

-}
--startsWith, from Data.List.Split
--https://hackage.haskell.org/package/split-0.1.1/docs/Data-List-Split.html
--Take the input file and turn it into a list of Strings (incomplete Rooms).
--Technically could be condensed into one line in the I/O section, but kept separate for clarity.

createGamedata :: String -> Gamedata
createGamedata cont = (map parseRooms (splitFile cont))

--split file into Rooms (each a string)
splitFile :: String -> [String]
splitFile = split (startsWith "[Room")

--creates a Room from a string
parseRooms :: String -> Room
parseRooms r = (createRoom (splitRoom r))

--split rooms into strings of description and each path
splitRoom :: String -> [String]
splitRoom = split (startsWith "[Path-to")

--creates a Room from a list of Room element strings
createRoom :: [String] -> Room
createRoom p =  (1,(head p),(parsePaths (tail p)))

--take list of strings and extract a list of Paths
parsePaths :: [String] -> [Path]
parsePaths [] = []
parsePaths (p:ps) = ((getPathNum p),(getDesc p)):(parsePaths ps)

--extracts description string from path string
getDesc :: String -> String
getDesc d = tail (last (splitPath d))

--extracts path number from path string
getPathNum :: String -> Int
getPathNum n = digitToInt (last (head (splitPath n)))

--splits Path up into 2 strings
splitPath :: String -> [String]
splitPath = wordsBy (== ']')

--Helper function.
--May or may not be needed.
--Gets first word from string line.
getFirstWord :: String -> String
getFirstWord [] = ""
getFirstWord x = head (words x)



--createRooms :: [String] -> [(Room,[Path])]
--Take divided file and turn it into gameData
--Old code. Please edit this.
createRooms :: [String] -> String
createRooms [] = ""
createRooms (c:cs)
    | x == "[Room" = printRoom (c,cs)
    | x == "[Path" = "Insert command function here"
    where x = getFirstWord c



--Helper function to printRoom.
--Takes paths and turns them into a string to display alongside the room text.
--printPath :: [Path] -> String



--Prints a room and its associated commands.
--printRoom :: (Room,[Path]) -> String
--Temporary: (Text Data,[Commands]) -> Printed Room
printRoom :: (String,[String]) -> String
printRoom (x,y) = unlines [x] ++ unwords y
