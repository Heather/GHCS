GHCS
====

[![Build Status](https://travis-ci.org/Heather/GHCS.png?branch=master)](https://travis-ci.org/Heather/GHCS)

Light thing to make shell scripting on haskell neat.

originally came from StackOverflow with

 - lesser improvements
 - move to up to date haskell platform
 - windows support

``` haskell
when compile $ do
     r <- system $ "ghc --make " ++ scr
     case r of
       ExitFailure i > do
               hPutStrLn stderr $ "'ghc --make " ++ scr ++ "' failed: " ++ show i
               exitFailure
       ExitSuccess > return ()
```
 
``` shell
$ time hs-echo.hs "Hello, world\!"     
[1 of 1] Compiling Main             ( hs-echo.hs, hs-echo.o )
Linking hs-echo ...
Hello, world!
hs-echo.hs "Hello, world!"  0.83s user 0.21s system 97% cpu 1.062 total

$ time hs-echo.hs "Hello, world, again\!"
Hello, world, again!
hs-echo.hs "Hello, world, again!"  0.01s user 0.00s system 60% cpu 0.022 total
```

``` shell
C:\test>t GHCS test.hs
[1 of 1] Compiling Main             ( test.hs, test.o )
Linking test.exe ...
hello world
command took 0:0:0.75 (0.75s total)

C:\test>t GHCS test.hs
hello world
command took 0:0:0.13 (0.13s total)
```
