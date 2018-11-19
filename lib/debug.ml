open Syntax
    
let rec show_expr e env = match e with
  | Variable var    -> var
  | IntVal i        -> string_of_int i
  | Plus (x, y)     -> (show_expr x env) ^ " + "  ^ (show_expr y env)
  | Minus (x, y)    -> (show_expr x env) ^ " - "  ^ (show_expr y env)
  | Multiply (x, y) -> (show_expr x env) ^ " * "  ^ (show_expr y env)
  | Divide (x, y)   -> (show_expr x env) ^ " / "  ^ (show_expr y env)
  | Modulo (x, y)   -> (show_expr x env) ^ " % "  ^ (show_expr y env)
  | Equal (x, y)    -> (show_expr x env) ^ " == " ^ (show_expr y env)
  | NotEqual (x, y) -> (show_expr x env) ^ " <> " ^ (show_expr y env)
  | Greater (x, y)  -> (show_expr x env) ^ " > "  ^ (show_expr y env)
  | Lesser (x, y)   -> (show_expr x env) ^ " < "  ^ (show_expr y env)


let rec show_lines ls env prefix = match ls with
  | h::t  ->
    let output = show_line h env in
    prefix ^ output ^ "\n" ^ (show_lines t env prefix)
  | []    -> ""
    
and show_line l env = match l with
  | BlankLine          ->
    ""
  | Assign (var, expr) ->
    "ASSIGN " ^ var ^ " = " ^ (show_expr expr env)
  | PrintVar var          ->
    "PRINT " ^ var
  | PrintLit lit          ->
    "PRINT \"" ^ lit ^ "\""
  | IfElse (expr, b1, b2) ->
    "IF " ^ (show_expr expr env) ^ " THEN\n" ^ (show_lines b1 env "...") ^ "ELSE\n" ^ (show_lines b2 env "...") ^ "ENDIF"
  | While (expr, b) ->
    "WHILE " ^ (show_expr expr env) ^ " DO\n" ^ (show_lines b env "...") ^ "END WHILE"
