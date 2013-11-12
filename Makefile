.PHONY: all all_win32 clean win32 GHCS

all:        clean | GHCS
all_win32:  clean | linux

win32: sed '/unix/d' GHCS.cabal | GHCS

GHCS:
	cabal install --only-dependencies
	cabal configure
	cabal build

clean:
	@echo " --- Clean binaries --- "
	rm -f GHCS
	@echo " --- Clean temp files --- "
	find . -name '*~' -delete;
	find . -name '#*#' -delete;