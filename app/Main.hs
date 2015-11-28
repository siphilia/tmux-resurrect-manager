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
    trm alias RESURRECT_NAME ALIAS_NAME
    trm last [ALIAS_NAME | RESURRECT_NAME ]
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

