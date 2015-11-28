module TRM
    ( getResurrectDirectory
    , getLast
    , getResurrectList
    , readLast
    , changeLast
    , createAlias
    ) where

import           Control.Applicative
import           Control.Monad
import qualified System.Directory    as SD
import           System.FilePath     ((</>))
import qualified System.FilePath     as SF
import qualified System.Posix        as SP

getResurrectDirectory :: IO FilePath
getResurrectDirectory = (</> ".tmux/resurrect") <$> SD.getHomeDirectory

getLast :: IO FilePath
getLast = (</> "last") <$> getResurrectDirectory

getResurrectList :: IO [FilePath]
getResurrectList = filter (\fp -> SF.takeExtension fp == ".txt") <$> (SD.getDirectoryContents =<< getResurrectDirectory)

readLast :: IO FilePath
readLast = SP.readSymbolicLink =<< getLast

changeLast :: FilePath -> IO ()
changeLast to = do
    l <- getLast
    isExist <- SD.doesFileExist l
    when isExist $ SD.removeFile l
    SP.createSymbolicLink to =<< getLast

-- | Similar System.Posix.Files.createSymbolicLink.
-- @createAlias linkTo name@ creates a symbolic link named @name@
-- which points to the file @linkTo@.
--
-- but symbolic link create to @$HOME/.tmux/resurrect@ directory.
createAlias :: FilePath -> FilePath -> IO ()
createAlias linkTo name = do
    d <- getResurrectDirectory
    SP.createSymbolicLink linkTo (d </> name)

