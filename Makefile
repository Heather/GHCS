.PHONY: all all_win32 clean win32 GHCS

all:        clean | GHCS
all_win32:  clean | win32

win32: dosed | GHCS

dosed:
    mv GHCS.cabal GHCS.cabal_backup
	sed '/unix/d' GHCS.cabal_backup > GHCS.cabal

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