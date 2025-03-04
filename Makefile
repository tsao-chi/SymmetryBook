MK = latexmk -halt-on-error

all: book.pdf TAGS
book.pdf: always figures version.tex macros.fmt
	$(MK) -quiet book
see-errors: figures version.tex macros.fmt
	$(MK) book
one-by-one: figures version.tex macros.fmt
	pdflatex -halt-on-error --shell-escape -fmt macros book.tex
	makeindex book.idx
	biber book
	pdflatex -halt-on-error --shell-escape -fmt macros book.tex
	makeindex book.idx
	pdflatex -halt-on-error --shell-escape -fmt macros book.tex
figures:
	mkdir $@
macros.fmt: macros.tex tikzsetup.tex
	pdflatex -ini -jobname="macros" "&pdflatex macros.tex\dump"
version.tex: .git/refs/heads/master
	git log -1 --date=short \
    --pretty=format:'\newcommand{\OPTcommit}{%h}%n\newcommand{\OPTdate}{%ad}%n' \
    > version.tex
clean:
	rm -rf *.aux *.fdb_latexmk *.fls *.log *.out *.toc *.brf *.blg *.bbl *.bcf	\
		*.run.xml *.glo *.gls *.idx *.ilg *.ind					\
		*.auxlock *.synctex.gz TAGS version.tex macros.fmt
cleanall:
	rm -rf *.aux *.fdb_latexmk *.fls *.log *.out *.toc *.brf *.blg *.bbl *.bcf	\
		*.run.xml *.glo *.gls *.idx *.ilg *.ind					\
		*.pdf *.auxlock *.synctex.gz figures TAGS version.tex macros.fmt
always:

# This list should include all the tex files that go into the book, in the order they go.
# Compare with the \include commands in book.tex
BOOKFILES :=						\
	macros.tex					\
	tikzsetup.tex					\
	book.tex					\
	intro.tex					\
	intro-uf.tex					\
	circle.tex					\
	group.tex					\
	subgroups.tex					\
	symmetry.tex					\
	fggroups.tex					\
	fingp.tex					\
	EuclideanGeometry.tex				\
	galois.tex					\
	history.tex					\
	metamath.tex

TAGS : Makefile $(BOOKFILES)
	etags $(BOOKFILES)
