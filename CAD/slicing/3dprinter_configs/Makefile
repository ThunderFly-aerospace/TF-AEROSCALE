
PRINTERS=edee mlab3d mini
SOURCES=$(wildcard src/*.ini)
MERGE=tools/merge_slic3r_conf.sh

all: clean default

default: $(wildcard src/models/*.ini)
	mkdir dist
	for printer in $(PRINTERS); do \
		mkdir dist/$$printer > /dev/null; \
		for model in $^; do \
			$(MERGE) -m $$model -m src/$$printer.ini -m src/generic.ini -o dist/$$printer/$$(basename $$model) ; \
		done \
	done

clean:
	rm dist -r 2> /dev/null || true
