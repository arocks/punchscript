open Syntax

exception RuntimeError of string
exception DivideByZero
exception PossibleInfiniteLoop

let globals: (string, int) Hashtbl.t = Hashtbl.create 10
let max_integer  = 55555
let min_integer  = -max_integer
let loop_max     = max_integer
  

let get_var env var =
  try
    match var with
    | "GURU"        -> max_integer
    | "SISHYAN"     -> min_integer
    | "BILLA"       -> Random.int max_integer
    | _             -> Hashtbl.find env var
  with
  | Not_found -> raise (RuntimeError ("Variable lookup failed for: " ^ var))


let divide numerator denominator =
  if denominator = 0 then
    raise DivideByZero
  else
    numerator / denominator


let rec eval_expr e env = match e with
  | Variable var    -> get_var env var
  | IntVal i        -> i
  | Plus (x, y)     -> eval_expr x env + eval_expr y env
  | Minus (x, y)    -> eval_expr x env - eval_expr y env
  | Multiply (x, y) -> eval_expr x env * eval_expr y env
  | Divide (x, y)   -> divide (eval_expr x env) (eval_expr y env)
  | Modulo (x, y)   -> eval_expr x env mod eval_expr y env
  | Equal (x, y)    -> if (eval_expr x env) = (eval_expr y env)  then 1 else 0
  | NotEqual (x, y) -> if (eval_expr x env) <> (eval_expr y env) then 1 else 0
  | Greater (x, y)  -> if (eval_expr x env) > (eval_expr y env)  then 1 else 0
  | Lesser (x, y)   -> if (eval_expr x env) < (eval_expr y env)  then 1 else 0


let rec eval_lines ls env = match ls with
  | h::t  ->
    let output = eval_line h env in
    output ^ (eval_lines t env)
  | []    -> ""
    
and eval_line l env = match l with
  | BlankLine          ->
    "" (* No Output *)
  | Assign (var, expr) ->
    let rhs = eval_expr expr env in
    let () = Hashtbl.replace env var rhs in
    "" (* No Output *)
  | PrintVar var          ->
    let value = get_var env var in
    (string_of_int value) ^ "\n"
  | PrintLit lit          ->
    lit ^ "\n"
  | IfElse (expr, b1, b2) ->
    let cond = eval_expr expr env in
    if cond <> 0 then eval_lines b1 env else eval_lines b2 env 
  | While (expr, b) ->
    let counter = ref 0 in
    let output = ref "" in
    while (eval_expr expr env) <> 0 do
      if !counter > loop_max then raise PossibleInfiniteLoop else counter := !counter + 1;
      output := !output ^ eval_lines b env
    done;
    !output (* Accumulated Loop Output *)


let rec eval_prog p env traceme = match p with
  | h::t  ->
    let output = eval_line h env in
    (* DEBUG *)
    let () = if traceme=true then Printf.printf ">> %s\n%s\n%!" (Debug.show_line h env) output else () in
    (* DEBUG *)
    output ^ (eval_prog t env traceme)
  | []    -> ""
