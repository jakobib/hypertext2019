NAME=infrastructure-agnostic-hypertext
TEXT=$(NAME).md
BIB=bibliography.bib

# required executables
WCITE=./node_modules/wcite/bin/wcite
PWCITE=./node_modules/wcite/bin/pwcite
PANDOC=pandoc

all: html pdf
html: html/index.html
pdf: $(NAME).pdf
svg: $(patsubst %.tikz,%.svg,$(wildcard *.tikz))

wikidata:
	$(WCITE) wcite.json update
	jq -f adjust-bibliography.jq wcite.json > tmp.json && mv tmp.json wcite.json

$(NAME).tex: metadata.yaml latex.yaml $(TEXT) $(BIB)
	pandoc --template template.tex --natbib --bibliography $(BIB) \
		-s -o $@ metadata.yaml latex.yaml $(TEXT)

# TODO: remove following fixes once citation-js has been updated
$(BIB): wcite.json rawbib.bib
	$(WCITE) wcite.yaml -f bibtex | \
		sed 's/edition=\([^{][^,]\+\),/edition={\1},/' | \
		sed 's/inproceedings/article/' > $(BIB)
	cat rawbib.bib >> $(BIB)

$(NAME).pdf: $(NAME).tex
	@echo pdflatex $@
	pdflatex $< && bibtex $(basename $<) && pdflatex $<

html/index.html: metadata.yaml $(TEXT) wcite.yaml wcite.json
	$(PANDOC) -s -o $@ -F $(PWCITE) -F pandoc-citeproc \
	   --template template.html \
	   wcite.yaml metadata.yaml $(TEXT) references.html

.SUFFIXES: .tikz .svg
.tikz.svg:
	./tikz2svg.sh $<
	cp *.svg html
