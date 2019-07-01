NAME=an-infrastructure-agnostic-model-of-hypertext
BIB=../bibliography.bib

$(NAME).pdf: $(NAME).tex
	pdflatex $< && bibtex $(basename $<) && pdflatex $< && pdflatex $<

$(NAME).tex: metadata.yaml latex.yaml $(NAME).md $(BIB)
	pandoc --template ../template.tex --natbib --bibliography $(BIB) \
		-s -o $@ metadata.yaml latex.yaml $(NAME).md
