(* 
 Javascript specific parts
*)


let process code =
  let lexbuf = Lexing.from_string code in
  match Punchlib.Interpreter.interpret lexbuf false with
  | Output out ->
    Printf.sprintf "0\n%s\n%!" out
  | CommonException (line, col, errmsg) ->
    Printf.sprintf "1\n%d:%d: %s\n%!" line col errmsg


let post_msg msg =
  let module J = Js.Unsafe in
  let () = J.call 
      (J.variable "postMessage") (J.variable "self")
      [|J.inject (Js.string msg)|]
  in ()


let onmessage event =
  let i = event##.data##.input in
  post_msg (process (Js.to_string i))


(* Install service worker event handler for 'onmessage' *)
let _ = Js.Unsafe.set (Js.Unsafe.variable "self") (Js.string "onmessage") onmessage
