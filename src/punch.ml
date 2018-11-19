let main lexbuf = match Punchlib.Interpreter.interpret lexbuf true with
  | Output out ->
    Printf.fprintf stdout "OUTPUT:\n\n%s\n%!" out
  | CommonException (line, col, errmsg) ->
    Printf.fprintf stderr "ERROR:\n\n%d:%d: %s\n%!" line col errmsg


let _ = main (Lexing.from_channel stdin) 
