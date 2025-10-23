(lang dune 3.20)

(name ocaml-web)

(generate_opam_files true)

(source
 (github leandronsp/ocaml-web))

(authors "Leandro Proença <leandronsp@example.com>")

(maintainers "Leandro Proença <leandronsp@example.com>")

(license LICENSE)

(documentation https://github.com/leandronsp/ocaml-web/README.md)

(package
 (name ocaml-web)
 (synopsis "Yet another HTTP server")
 (description "This time in OCaml")
 (depends ocaml))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
