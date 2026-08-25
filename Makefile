#
#	Makefile for the GDEM dataset project.
#
#	This Makefile is the human-facing driver.
#	Each rule calls the appropriate tool instead of reimplementing work:
#		clean:  rm generated output
#		test:   npm test
#		site:   build the status site from site.in/ into site.out/
#		state:  fetch live dataset state into dataflow.out/site-state.txt
#		deploy: RETIRED - all publishing to labs.bannister.us goes through
#		        the homelab project (homelab-publish; see the homelab's
#		        documents/09-project-pages-conventions.md). This target
#		        only reminds you of that; use the homelab's make deploy.
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

deploy:
	@echo '==== RETIRED: publishing goes through the homelab project (homelab-publish).'
	@echo '==== Build the pages here (make site / make state), then run the homelab''s'
	@echo '==== "make deploy" to publish (see homelab documents/09-project-pages-conventions.md).'

install:
	@echo '==== No install yet defined'

.PHONY: clean test site state deploy install
