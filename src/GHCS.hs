{-# LANGUAGE
    CPP
  , MultiWayIf
  , LambdaCase
  #-}

import Control.Monad

import System.Info (os)
import System.Environment( getArgs )
import System.Exit
import System.Directory
import System.IO

import System.Process

#if ! ( defined(mingw32_HOST_OS) || defined(__MINGW32__) )
import System.Posix.Process
import System.Posix.Files

getMTime f = liftM modificationTime (getFileStatus f)
#else
getMTime = getModificationTime
#endif

main = do
    scr : args <- getArgs
    let cscr = takeWhile (/= '.') scr
            ++  if | os `elem` ["win32", "mingw32", "cygwin32"] -> ".exe"
                   | otherwise -> ""

    scrExists  <- doesFileExist scr
    cscrExists <- doesFileExist cscr
    compile    <- if scrExists && cscrExists
                   then do
                     scrMTime  <- getMTime scr
                     cscrMTime <- getMTime cscr
                     return $ cscrMTime <= scrMTime
                   else return True

    when compile $ system ("ghc --make " ++ scr)
                   >>= \case ExitFailure i -> do
                               hPutStrLn stderr $ "'ghc --make " ++ scr ++ "' failed: " ++ show i
                               exitFailure
                             ExitSuccess -> return ()

#if defined(mingw32_HOST_OS) || defined(__MINGW32__)
    pid <- runCommand cscr
    waitForProcess pid >>= exitWith
#else
    executeFile cscr False args Nothing
#endif
