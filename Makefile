#
#	Makefile for the GDEM dataset project.
#
#	This Makefile is the human-facing driver.
#	Each rule calls the appropriate tool instead of reimplementing work:
#		clean:  rm generated output
#		test:   npm test
#		site:   build the status site from site.in/ into site.out/
#		state:  fetch live dataset state into dataflow.out/site-state.txt
#		deploy: fetch state, build the site, publish to labs.bannister.us
#		install: reserved; not yet defined.
#

clean:
	rm -f dataflow.out/* site.out/* logs/*

test:
	npm test

site:
	sh scripts/site-build.sh

state:
	sh scripts/site-state-fetch.sh

deploy: state site
	sh scripts/site-deploy.sh

install:
	@echo '==== No install yet defined'

.PHONY: clean test site state deploy install
