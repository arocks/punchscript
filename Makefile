.PHONY: all clean test

DUNE       := jbuilder
OCAMLRUN   := ocamlrun
OCAMLDEBUG := ocamldebug
EXECUTABLE := punch.exe
BYTECODE   := src/punch.bc
JSFILE     := js/jsbridge.bc.js

all: debug

debug:
	$(DUNE) build --dev $(BYTECODE)

run: debug
	OCAMLRUNPARAM=b $(OCAMLRUN) ./_build/default/$(BYTECODE)

test: debug
	OCAMLRUNPARAM=b $(OCAMLRUN) ./_build/default/$(BYTECODE) < tests/test.punch # Run with debugging

release:
	$(DUNE) build $(JSFILE)

clean:
	git clean -f -d
	rm -f *~
	rm -rf _build/
