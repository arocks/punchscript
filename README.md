<p align="center"> 
<img width="210" height="298" src="https://raw.githubusercontent.com/arocks/punchscript/master/web/img/logo-full.png">
</p>

# Punchscript

An imperative language made up of Rajinikanth punch dialogues. It currently supports only Integer data types.

Here is how Fizz Buzz in Punchscript looks like:

![Screenshot of Punchscript code](https://raw.githubusercontent.com/arocks/punchscript/master/web/img/screenshot.png)

More examples are in the tests directory.

Try it here: [Online Interpreter](https://arunrocks.com/punchscript/) 

Read more: [Blog post](https://arunrocks.com/punchscript-rajinikanth/) | [Language Specs](https://github.com/arocks/punchscript-specs)

## Installation

Latest stable version of OCaml (developed in version 4.06.0) should be obtained from opam.

Install menhir, js_of_ocaml and other dependencies

```
$ opam depext -i core merlin utop ocp-indent
$ opam depext -i menhir js_of_ocaml-compiler sedlex
$ opam depext -i js_of_ocaml js_of_ocaml-ppx js_of_ocaml-lwt 
```

Use the Makefile to build a release target producing the javascript file:

```
$ make release
```

Go to the `web` directory and run any local web server, for e.g.:

```
$ python3 -m http.server
```

You can also create OCaml bytecode executable for debug and testing:

```
$ make debug
```

## License

GNU GPL ver 3. See the file COPYING for details.

(C) 2018 by Arun Ravindran
