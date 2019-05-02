#!/bin/bash

TIKZ=$1
if [[ ! -e "$TIKZ" ]]; then
  echo "usage: $0 input.tikz"
  exit
fi

NAME=$(basename "${TIKZ%.*}")
DIR=$(readlink -f $(dirname "$TIKZ"))

TMPDIR=`mktemp -d 2>/dev/null || mktemp -d -t 'tikztmp'` # also works on OSX
TEX="$TMPDIR/$NAME.tex"

cat <<TEX > "$TEX"
\documentclass[tikz]{standalone}
\begin{document}
TEX
cat "$TIKZ" >> "$TEX"
echo '\end{document}' >> "$TEX"

cd "$TMPDIR"
pdflatex "$NAME"
pdf2svg "$NAME.pdf" "$DIR/$NAME.svg"
cd -
