(*
Evaluate the program and return the standard output i.e. printed output
*)

type result =
  | Output of string
  | CommonException of int * int * string (* Line no:, Column no:, Exception *)


let make_exception (lexbuf: Lexing.lexbuf) error_msg =
  let pos = lexbuf.lex_curr_p in
  let line_no = pos.pos_lnum in
  let offset = (pos.pos_cnum - pos.pos_bol) in
  CommonException (line_no, offset, error_msg)


let interpret lexbuf traceme =
  try
    let _ = Random.self_init() in
    let ast = Parser.program Lexer.token lexbuf in
    Output (Eval.eval_prog ast Eval.globals traceme)
  with
  | End_of_file ->
    make_exception lexbuf "KATHAM, KATHAM!"
  | Lexer.SyntaxError odd_char ->
    make_exception lexbuf ("ENNAMMA KANNU, SOWKIYAMA? " ^ odd_char)
  | Parser.Error ->
    make_exception lexbuf "THILLU MULLU"
  | Eval.RuntimeError msg ->
    make_exception lexbuf ("KANNA, PANNI DHAN KOOTAMA VARUM... " ^ msg)
  | Eval.DivideByZero ->
    make_exception lexbuf "DIVIDE BY ZERO? JUJUBE."
  | Eval.PossibleInfiniteLoop ->
    make_exception lexbuf "POSSIBLE INFINITE LOOP."

