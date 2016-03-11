-----------------------------------------------------------------------
-- IFEI - Interactive Fiction Engine and Interpreter
-----------------------------------------------------------------------
import System.IO
import System.Directory
import System.Exit
import Data.Char
import Data.List.Split
import Data.Bool

-----------------------------------------------------------------------
-- I/O Aspects
-----------------------------------------------------------------------
--Reads from a text file.
--fileLines is a list of the lines in text file. 
main = do
    putStrLn ">>> Please load a game by typing in the name of the game file, without the file extension: "
    name <- getLine
    validFile <- doesFileExist (name ++ ".txt")
    if validFile
    then do
        handle <- openFile (name ++ ".txt") ReadMode
        contents <- hGetContents handle

        putStrLn $ "\n==" ++ (replicate (length (name ++ " loaded.")) '=') ++ "=="
        putStrLn $ "| " ++ name ++ " loaded. |"
        putStrLn $ "==" ++ (replicate (length (name ++ " loaded.")) '=') ++ "=="

        let gData = createGamedata contents
        putStrLn (roomDesc (head gData))
        game gData (head gData) (head gData)
        hClose handle
    else do
        putStrLn "\n============================"
        putStrLn "| The file does not exist. |"
        putStrLn "============================\n"
        main


--Command handling.    
game :: Gamedata -> Room -> Room -> IO()
game gd r bm = do
    if trd r == []
    then do
        putStrLn ">>> The game's over!"
        command <- getLine
        processCommand gd r bm (map toLower command)
    else do
        command <- getLine
    --map toLower command will take the command and make it all lower-case.
    --commands are not case sensitive.
    --We need to pass in a Room as an parameter to processCommand.
        processCommand gd r bm (map toLower command)


--Function that handles all possible commands given.
processCommand :: Gamedata -> Room -> Room -> String -> IO()
processCommand gd r bm x = case x of
    "exit!" -> ifeiExit
    "exit" ->  processExit gd r bm
    "eject!" -> ifeiEject
    "eject" -> processEject gd r bm
    "restart!" -> ifeiRestart gd
    "restart" -> processRestart gd r bm
    "load!" -> ifeiLoad gd r bm
    "load" -> processLoad gd r bm
    "save" -> processSave gd r bm
    "repeat" -> processRepeat gd r bm
    "help" -> processHelp gd r bm
    _ -> processPaths gd r bm x


--Function that handles exit command.
processExit :: Gamedata -> Room -> Room -> IO()
processExit gd r bm = do 
    putStrLn "\n>>> Are you sure you want to exit IFEI? Type 'exit' again to quit."
    com <- getLine
    if (map toLower com) == "exit" || (map toLower com) == "exit!"
    then ifeiExit
    else do
        putStrLn "\n>>> Cancelled."
        game gd r bm

ifeiExit :: IO()
ifeiExit = do
    putStrLn "\n>>> Goodbye."
    exitSuccess


--Function that handles eject command.
processEject :: Gamedata -> Room -> Room -> IO()
processEject gd r bm = do
    putStrLn "\n>>> Are you sure you want to eject the game? Type 'eject' again to quit."
    com <- getLine
    if (map toLower com) == "eject" || (map toLower com) == "eject!"
    then ifeiEject
    else do
        putStrLn "\n>>> Cancelled."
        game gd r bm

ifeiEject :: IO()
ifeiEject = do
    putStrLn "\n"
    main

--Function that handles restart command.
--This function should just transfer the player to Room 1, as every game begins in Room 1.
processRestart :: Gamedata -> Room -> Room -> IO()
processRestart gd r bm = do 
    putStrLn "\n>> Are you sure you want to restart the game? Type 'restart' again to restart."
    com <- getLine
    if (map toLower com) == "restart" || (map toLower com) == "restart!"
    then ifeiRestart gd
    else do
        putStrLn "\n>>> Cancelled."
        game gd r bm

ifeiRestart :: Gamedata -> IO()
ifeiRestart gd = do
    putStrLn "\n================="
    putStrLn "| Restarting... |"
    putStrLn "================="
    putStrLn (roomDesc (head gd))
    game gd (head gd) (head gd)

    
--processLoad
processLoad :: Gamedata -> Room -> Room -> IO()
processLoad gd r bm = do
    putStrLn "\n>> Load from bookmark? Type 'load' again to load."
    com <- getLine
    if (map toLower com) == "load" || (map toLower com) == "load!"
    then ifeiLoad gd bm bm
    else do
        putStrLn "\n>>> Cancelled."
        game gd r bm

ifeiLoad :: Gamedata -> Room -> Room -> IO()
ifeiLoad gd r bm = do
    putStrLn "\n==================="
    putStrLn "| Loading save... |"
    putStrLn "==================="
    putStrLn $ roomDesc bm
    game gd bm bm
    
    
--processSave
processSave :: Gamedata -> Room -> Room -> IO()
processSave gd r bm = do
    putStrLn "\n>>> Your progress has been saved. Type 'load' to return to this state at any time."
    game gd r r
    
--processRepeat - Displays the contents of the room again.
--Useful if for some reason the player floods the terminal with junk and needs to see the room again.
processRepeat :: Gamedata -> Room -> Room -> IO()
processRepeat gd r bm = do
    putStrLn $ roomDesc r
    game gd r bm


--processHelp - Displays every possible command, including reserved commands.
processHelp :: Gamedata -> Room -> Room -> IO()
processHelp gd r bm = do
    putStrLn "\n================"
    putStrLn "| Command List |"
    putStrLn "================"
    putStrLn "Help\nSave\nLoad\nRepeat\nRestart\nEject\nExit"
    if trd r == []
    then game gd r bm
    else do
        putStrLn $ printPDesc2 (trd r)
        game gd r bm


--processPaths
--Take input command and check paths for command
--If input and a path match, take that path.
--If there are no matches, call processInvalid.
processPaths :: Gamedata -> Room -> Room -> String -> IO()
processPaths gd r bm s = do
    let roomNum = pathToRoom (trd r) s
    if roomNum == -1
    then processInvalid gd r bm
    else do
        putStrLn $ roomDesc (gd !! (roomNum - 1))
        game gd (gd !! (roomNum - 1)) bm


--Function that handles invalid command.
processInvalid :: Gamedata -> Room -> Room -> IO()
processInvalid gd r bm = do 
    putStrLn "\n>>> Invalid command."
    game gd r bm
-----------------------------------------------------------------------
-- Functional Aspects
-----------------------------------------------------------------------
--Room
--Int: Room ID. Identifies the room.
--String: Text data associated with the room.
--[Path]: The list of paths that can be taken from the room.

--Path
--Int: Room ID. This is the room the path will lead to.
--String: The command that invokes the path.
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
createRoom :: [String] -> [Path]
createRoom p =  (parsePaths (tail p))


--take list of strings and extract a list of Paths
parsePaths :: [String] -> [Path]
parsePaths [] = []
parsePaths (p:ps) = ((getPathNum p),(getDesc p)):(parsePaths ps)


--Gets string of room and path list, and append them to make Room
pRoom :: String -> [Path] -> Room
pRoom x p = (getPathNum x, getDescRoom x, p)


--Gets description of the room.
getDescRoom :: String -> String
getDescRoom d = last (wordsBy (==']') (head( wordsBy (=='[') d)))


--extracts description string from path string
getDesc :: String -> String
getDesc d = (filter (/= '\n') (tail (last (splitPath d)))) ++ "\n"


--extracts path number from path string
getPathNum :: String -> Int
getPathNum n = read (last (wordsBy (==' ') (head (splitPath n))))


--splits Path up into 2 strings
splitPath :: String -> [String]
splitPath = wordsBy (== ']')


--Gets room description given a room.
roomDesc :: Room -> String
roomDesc (i, s, p) = s ++ printPDesc p


--Helper function that returns description of given path.
printPDesc :: [Path] -> String
printPDesc [] = ""
printPDesc (p:ps) = "- " ++ snd p ++ printPDesc ps
--Without the dash, for processHelp.
printPDesc2 :: [Path] -> String
printPDesc2 [] = ""
printPDesc2 (p:ps) = snd p ++ printPDesc2 ps


--Grab third element in tuple
trd :: (a,b,c) -> c
trd (_,_,z) = z        


--Given a list of Paths and a String, find the path that is invoked by
--the string and return the destination room.
pathToRoom :: [Path] -> String -> Int
pathToRoom [] s = -1 --invalid command
pathToRoom (x:xs) s
    | pathText == commandText = fst x
    | otherwise = pathToRoom xs s
    where pathText = map toLower (filter (/= '\n') (snd x))
          commandText = map toLower s


--For debugging
dumpData :: Gamedata -> String
dumpData [] = ""
dumpData (x:xs) = "[" ++ show (fst3 x) ++ show (snd3 x) ++ show (trd x) ++ "]\n"++ dumpData xs
fst3 :: (a,b,c) -> a
snd3 :: (a,b,c) -> b     
fst3 (a,_,_) = a
snd3 (_,b,_) = b
-----------------------------------------------------------------------
-- End of file
-----------------------------------------------------------------------
