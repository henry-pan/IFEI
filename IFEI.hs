import System.IO

--Asks for your name. Reads text file.
--fileLines is a list of the lines in text file. 
main = do
    putStrLn $ "Please load a game by typing in the name of the game file, without the file extension: "
    name <- getLine
    handle <- openFile (name ++ ".txt") ReadMode
    contents <- hGetContents handle
    putStrLn $ "\n" ++ name ++ " loaded.\n"
    let fileLines = lines contents
    let command = getCommand fileLines
    putStrLn $ command
    hClose handle

--Gets first word from string line.
getFirstWord :: String -> String
getFirstWord [] = ""
getFirstWord x = head (words x)

--Gets lists of all the lines from input file, and does something depending on first word of string.
--BUG: Can't get it to recurse through the entire list, so for now it just reads the first item in list.
getCommand :: [String] -> String
getCommand [] = ""
getCommand (c:cs)
    |x == "makeRoom" = "Insert room function here"
    |x == "option"   = "Insert options function here"
    where x = getFirstWord c
   
