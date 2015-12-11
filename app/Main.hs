{-# LANGUAGE QuasiQuotes #-}
module Main where

import qualified Data.Text.IO          as TIO
import           System.Environment    (getArgs)
import           Text.Shakespeare.Text (st)
import qualified TRM

main :: IO ()
main = do
    args <- getArgs
    case args of
        ["alias",to,name] -> createResurrectAlias to name
        ["last",to] -> updateLast to
        ["last"] -> printLast
        ["list"] -> printResurrectList
        ["path"] -> printResurrectDirectoryPath
        _ -> showHelp

showHelp :: IO ()
showHelp = TIO.putStrLn [st|Usage:
    trm list
        Show the all resurrect files.

    trm alias RESURRECT_NAME ALIAS_NAME
        Create ALIAS_NAME symbolic link that link to RESURRECT_NAME.

    trm last [ALIAS_NAME | RESURRECT_NAME ]
        Change the "last" symbolic link to ALIAS_NAME or RESURRECT_NAME.

    trm path
        Show directory path in which resurrect files is saved.
|]

printResurrectList :: IO ()
printResurrectList = mapM_ putStrLn =<< TRM.getResurrectList

createResurrectAlias :: FilePath -> FilePath -> IO ()
createResurrectAlias = TRM.createAlias

updateLast :: FilePath -> IO ()
updateLast to = TRM.changeLast to

printLast :: IO ()
printLast = do
    lastPath <- TRM.getLast
    to <- TRM.readLast
    TIO.putStrLn [st|#{lastPath} -> #{to}|]

printResurrectDirectoryPath :: IO ()
printResurrectDirectoryPath = putStrLn =<< TRM.getResurrectDirectory

