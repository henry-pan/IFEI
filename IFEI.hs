-----------------------------------------------------------------------
-- IFEI - Interactive Fiction Engine and Interpreter
-----------------------------------------------------------------------
import System.IO
import System.Directory
import Data.Char
import Data.List.Split
import Data.Bool
import System.Exit

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
    --We need to pass in a Room as an parameter to processCommand.
    processCommand (map toLower command) --Room
    game
            

--Function that handles all possible commands given.
processCommand :: String -> IO()
processCommand x = case x of
   "exit" ->  processExit
   "restart" -> processRestart
   --"repeat" -> processRepeat
   --"help" -> processHelp
   _ -> processPaths x
   
   
--Function that handles exit command.
processExit :: IO()
processExit = do 
    putStrLn "Are you sure you want to exit the game? Type 'exit' again to quit."
    com <- getLine
    if (map toLower com) == "exit"
        then do 
            putStrLn "Goodbye."
            exitSuccess 
    else do
        putStrLn "Cancelled."
        game 

        
--Function that handles restart command. NOT DONE.
--This function should just transfer the player to Room 1, as every game begins in Room 1.
processRestart :: IO()
processRestart = do 
    putStrLn "Are you sure you want to restart the game? Type 'restart' again to restart."
    com <- getLine
    if (map toLower com) == "restart"
        then do 
            putStrLn "\n================="
            putStrLn "| Restarting... |"
            putStrLn "=================\n"
    else do
        putStrLn "Cancelled."
        game

        
--processRepeat - Displays the contents of the room again.
--Useful if for some reason the player floods the terminal with junk and needs to see the room again.
--INCOMPLETE. Needs to take in Room to show Room text.
--processRepeat :: IO()


--processHelp - Displays every possible command, including reserved commands.
--INCOMPLETE. Needs to take in Paths to show path commands.
processHelp :: IO()
processHelp = do
    putStrLn "\n================"
    putStrLn "| Command List |"
    putStrLn "================"
    putStrLn "Help\nRepeat\nRestart\nExit"
    game


--processPaths
--Take input command and check paths for commmand
--If input and a path match, take that path.
--If there are no matches, call processInvalid.
--Path ID == Room ID == Destination Room
--processPaths :: String -> [Path] -> IO()
----INCOMPLETE. Don't know how to access Gamedata
processPaths :: String -> IO ()
processPaths s = do
    putStrLn s
    game

--Function that handles invalid command.
processInvalid :: IO()
processInvalid = do 
    putStrLn "Invalid command."
    game
-----------------------------------------------------------------------
-- Functional Aspects
-----------------------------------------------------------------------
{-|
We might want to create some sort of data structure to hold all the
room and path data. List of Tuples?
So the end result would be something like but dynamically generated:

gameData = [(Room0,[Paths0]) , (Room1,[Paths1]), (Room2,[Paths2]),...]


If we do this, we can easily grab a room using list indices.
We will need to implement some sort of exception handling in case
the user decides to number rooms out of order.

-}

--Int: Room ID. Identifies the room.
--String: Text data associated with the room.
--[Path]: The list of paths that can be taken from the room.
--data Room = Room Int String [Path]

--Int: Room ID. This is the room the path will lead to.
--String: The command that invokes the path.
--data Path = Path Int String

-- Create type synonyms
type Gamedata = [Room]
type Room = (Int, String, [Path])
type Path = (Int, String)


--Take the input file and turn it into a list of Strings (incomplete Rooms).
createGamedata :: String -> Gamedata
createGamedata cont = (map parseRooms (splitFile cont))


--split file into Rooms (each a string)
--Technically could be condensed into one line in the I/O section, but kept separate for clarity.
splitFile :: String -> [String]
splitFile = split (startsWith "[Room")


--creates a Room from a string
parseRooms :: String -> Room
parseRooms r = pRoom r (createRoom (splitRoom r))


--split rooms into strings of description and each path
splitRoom :: String -> [String]
splitRoom = split (startsWith "[Path-to")


--creates a Room from a list of Room element strings
createRoom :: [String] -> Room
createRoom p =  (parsePaths (tail p))


--take list of strings and extract a list of Paths
parsePaths :: [String] -> [Path]
parsePaths [] = []
parsePaths (p:ps) = ((getPathNum p),(getDesc p)):(parsePaths ps)


--Gets string of room and path list, and append them to make Room
pRoom :: String -> [Path] ->Room
pRoom x p = (getPathNum x, getDescRoom x, p)


--Gets description of the room.
getDescRoom :: String -> String
getDescRoom d = last (wordsBy (==']') (head( wordsBy (=='[') d)))


--extracts description string from path string
getDesc :: String -> String
getDesc d = tail (last (splitPath d))


--extracts path number from path string
getPathNum :: String -> Int
getPathNum n = digitToInt (last (head (splitPath n)))


--splits Path up into 2 strings
splitPath :: String -> [String]
splitPath = wordsBy (== ']')




-----------------------------------------------------------------------
-- Temporary / WIP Code
-----------------------------------------------------------------------

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
