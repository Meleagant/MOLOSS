.PHONY: all clean native byte profile debug various_tests doc sanity

OCBFLAGS = -I src -I tests
OCB = ocamlbuild -use-ocamlfind $(OCBFLAGS)

all:  native byte

clean:
	$(OCB) -clean

# build executable
native: sanity
	$(OCB) src/main.native

byte: sanity
	$(OCB) src/main.byte

profile: sanity
	$(OCB) -tag profile src/main.native

debug: sanity
	$(OCB) -tag debug src/main.byte

# tests
various_tests: native
	$(OCB) tests/various_tests.native

# documentation
doc_html: doc/moloss.odocl
	$(OCB) doc/moloss.docdir/index.html

doc_man: doc/moloss.odocl
	$(OCB) doc/moloss.docdir/man

doc_tex: doc/moloss.odocl
	$(OCB) doc/moloss.docdir/moloss.tex

doc_texinfo: doc/moloss.odocl
	$(OCB) doc/moloss.docdir/moloss.texi

doc_dot: doc/moloss.odocl
	$(OCB) doc/moloss.docdir/moloss.dot

doc: doc_html doc_man doc_tex doc_texinfo doc_dot

# check if packages are available
sanity:
	ocamlfind query unix
	ocamlfind query minisat
	ocamlfind query msat

graph:
	dot -Tpdf solve.docdir/dep.dot -o dep.pdf
