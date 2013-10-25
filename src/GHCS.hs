{-# LANGUAGE CPP #-}

import Control.Monad

import System.Environment( getArgs )
import System.Exit
import System.Directory
import System.IO

import System.Process

#if ! ( defined(mingw32_HOST_OS) || defined(__MINGW32__) )
import System.Posix.Process
import System.Posix.Files

getMTime f = getFileStatus f >>= return . modificationTime
#endif

main = do
    scr : args <- getArgs
    let cscr = takeWhile (/= '.') scr

    scrExists <- doesFileExist scr
    cscrExists <- doesFileExist cscr
    compile <- if scrExists && cscrExists
               then do
#if defined(mingw32_HOST_OS) || defined(__MINGW32__)
                 return False
#else
                 scrMTime <- getMTime scr
                 cscrMTime <- getMTime cscr
                 return $ cscrMTime <= scrMTime
#endif
               else return True

    when compile $ do
         r <- system $ "ghc --make " ++ scr
         case r of
           ExitFailure i -> do
                   hPutStrLn stderr $ "'ghc --make " ++ scr ++ "' failed: " ++ show i
                   exitFailure
           ExitSuccess -> return ()
           
#if defined(mingw32_HOST_OS) || defined(__MINGW32__)
    pid <- runCommand cscr
    waitForProcess pid >>= exitWith
#else
    executeFile cscr False args Nothing
#endif
