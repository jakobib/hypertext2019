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

# TODO: remove following fix once citation-js has been updated
$(BIB): wcite.json
	$(WCITE) wcite.yaml -f bibtex | \
		sed 's/inproceedings/article/' > $(BIB)

$(NAME).pdf: $(NAME).tex
	@echo pdflatex $@
	pdflatex $< && bibtex $(basename $<) && pdflatex $<

html/index.html: metadata.yaml $(TEXT) wcite.yaml wcite.json
	$(PANDOC) -s -t json wcite.yaml metadata.yaml $(TEXT) references.html \
	  | ./adjust-for-html.jq | \
	$(PANDOC) -f json -F $(PWCITE) -F pandoc-citeproc \
	   --template template.html -o $@

.SUFFIXES: .tikz .svg
.tikz.svg:
	./tikz2svg.sh $<
	cp *.svg html
