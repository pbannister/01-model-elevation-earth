#
#	Makefile for the GDEM dataset project.
#
#	This Makefile is the human-facing driver.
#	Each rule calls the appropriate tool instead of reimplementing work:
#		clean:  rm generated output
#		test:   npm test
#		deploy, install: reserved; not yet defined.
#

clean:
	rm -f dataflow.out/* site.out/* logs/*

test:
	npm test

deploy:
	@echo '==== No deploy yet defined'

install:
	@echo '==== No install yet defined'

.PHONY: clean test deploy install
