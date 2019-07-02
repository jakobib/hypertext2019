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

$(NAME).tex: metadata.yaml latex.yaml $(TEXT) $(BIB)
	pandoc --template template.tex --natbib --bibliography $(BIB) \
		-s -o $@ metadata.yaml latex.yaml $(TEXT)

$(BIB): wcite.json
	$(WCITE) wcite.yaml -f bibtex > $(BIB)

$(NAME).pdf: $(NAME).tex
	@echo pdflatex $@
	pdflatex $< && bibtex $(basename $<) && pdflatex $< && pdflatex $<

html/index.html: metadata.yaml interactions.yaml $(TEXT) wcite.yaml wcite.json svg
	mkdir -p html
	$(PANDOC) -s -t json \
		wcite.yaml metadata.yaml interactions.yaml html.yaml $(TEXT) references.html \
	  | ./adjust-for-html.jq | \
	$(PANDOC) -f json -F $(PWCITE) -F pandoc-citeproc --section-divs \
	   --template template.html -o $@

.SUFFIXES: .tikz .svg
.tikz.svg:
	./tikz2svg.sh $<
	mkdir -p html && cp *.svg html
