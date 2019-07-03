NAME=an-infrastructure-agnostic-model-of-hypertext
BIB=../bibliography.bib
PWCITE=../node_modules/wcite/bin/pwcite

all: $(NAME).pdf html

$(NAME).pdf: $(NAME).tex
	pdflatex $< && bibtex $(basename $<) && pdflatex $< && pdflatex $<

$(NAME).tex: metadata.yaml latex.yaml $(NAME).md $(BIB)
	pandoc --template ../template.tex --natbib --bibliography $(BIB) \
		-s -o $@ metadata.yaml latex.yaml $(NAME).md

html: ../html/short-version.html

../html/short-version.html: metadata.yaml latex.yaml $(NAME).md $(BIB)
	pandoc -s -t json \
		-M csl=../acm-sig-proceedings.csl \
		../wcite.yaml metadata.yaml ../html.yaml $(NAME).md ../references.html \
	  | ../adjust-for-html.jq | \
	pandoc -f json \
		-F $(PWCITE) -F pandoc-citeproc --section-divs \
	   --template ../template.html -o $@
