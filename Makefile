NAME=infrastructure-agnostic-hypertext
TEXT=$(NAME).md
BIB=bibliography.bib

# required executables
WCITE=./node_modules/wcite/bin/wcite
PWCITE=./node_modules/wcite/bin/pwcite
PANDOC=pandoc

all: html pdf
html: $(NAME).html
pdf: $(NAME).pdf
svg: $(patsubst %.tikz,%.svg,$(wildcard *.tikz))

wikidata:
	$(WCITE) wcite.json update
	cat <<< "$$(jq -f adjust-bibliography.jq wcite.json)" > wcite.json

$(NAME).tex: metadata.yml $(TEXT) $(BIB)
	pandoc --template template.tex --natbib --bibliography $(BIB) -s -o $@ metadata.yml $(TEXT)

# TODO: remove following fixes once citation-js has been updated
$(BIB): wcite.json rawbib.bib
	$(WCITE) wcite.yml -f bibtex | \
		sed 's/edition=\([^{][^,]\+\),/edition={\1},/' | \
		sed 's/inproceedings/article/' > $(BIB)
	cat rawbib.bib >> $(BIB)

$(NAME).pdf: $(NAME).tex
	@echo pdflatex $@
	pdflatex $< && bibtex $(basename $<) && pdflatex $<

$(NAME).html: metadata.yml $(TEXT) wcite.yml wcite.json
	$(PANDOC) -s -o $@ -F $(PWCITE) -F pandoc-citeproc \
	   --template template.html \
	   --css css/rash.css --css css/bootstrap.min.css \
	   wcite.yml metadata.yml $(TEXT)

.SUFFIXES: .tikz .svg
.tikz.svg:
	./tikz2svg.sh $<
