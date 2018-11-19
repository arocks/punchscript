(* Node of an Abstract Syntax tree *)

type expression =
  | Variable of string                  (* Variable evaluated to its value *)
  | IntVal of int                       (* Literal integer value *)
  | Plus of expression * expression     (* Addition *)
  | Minus of expression * expression    (* Subtraction *)
  | Multiply of expression * expression (* Multiplication *)
  | Divide of expression * expression   (* Division *)
  | Modulo of expression * expression   (* Mod: Division Remainder *)            
  | Equal of expression * expression    (* Compare for equal values *)            
  | NotEqual of expression * expression (* Compare for unequal values *)            
  | Greater of expression * expression  (* Compare if left is greater *)            
  | Lesser of expression * expression   (* Compare if left is lesser *)            

(* Punch is line-oriented. Each line is converted to a "command" *)

type command =
  | BlankLine                           (* Empty or a comment line *)
  | Assign of string * expression       (* Create new variable *)
  | PrintVar of string                  (* Print evaluated result *)
  | PrintLit of string                  (* Print literal string *)
  | IfElse of expression * command list * command list
                                        (* If true do first list else other list *)
  | While of expression * command list  (* While true do loop *)
