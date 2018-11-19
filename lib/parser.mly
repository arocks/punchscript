(* -*-fundamental-*- *)
%{
%}

(* Define tokens and <value> (references in Lexer too) *)
%token EOF
%token NEWLINE
%token <string> VARIABLE
%token <string> STRINGLITERAL
%token <int> INT_LITERAL
%token <string> VER_LITERAL
%token ASSIGN_LHS ASSIGN_RHS
%token PRINT
%token IF ELSE ENDIF
%token WHILE ENDWHILE
%token PLUS MINUS MULTIPLY DIVIDE MODULO
%token LPAREN RPAREN
%token EQUAL NOTEQUAL GREATER LESSER
%token LANG_VER


(* Precedence and associativity *)
%nonassoc EQUAL NOTEQUAL GREATER LESSER
%left PLUS MINUS
%left MULTIPLY DIVIDE MODULO


(* Top level rule *)
%start program
%type <Syntax.command list> program

%%


(* === Grammar Rules start === *)

(*
===============
Quick Reference
===============

Left side:
      TOKEN                   : Terminal token
      expr                    : Non-terminal
      val=TOKEN               : Extract the value of token into 'val'
      list(abc)               : Menhir shortcut to create a list of items 

Right side:
      Syntax.Abc	      : Abstract syntax tree node
      
*)


  program:
    | l=list(line) EOF                      { l }

  terminator:
    | NEWLINE				    { }
    | EOF				    { }
    
  line:
    | NEWLINE				    { Syntax.BlankLine }
    | LANG_VER VER_LITERAL terminator       { Syntax.BlankLine }
    | e=expression ASSIGN_LHS v=VARIABLE ASSIGN_RHS terminator
                                            { Syntax.Assign (v, e) }
    | PRINT v=VARIABLE terminator           { Syntax.PrintVar v }
    | PRINT s=STRINGLITERAL terminator      { Syntax.PrintLit s }
    | IF e=expression terminator if_l=list(line) ELSE terminator else_l=list(line) ENDIF terminator
                                            { Syntax.IfElse (e, if_l, else_l) }
    | IF e=expression terminator if_l=list(line) ENDIF terminator
                                            { Syntax.IfElse (e, if_l, []) }
    | WHILE e=expression terminator while_l=list(line) ENDWHILE terminator
                                            { Syntax.While (e, while_l) }
      	 	      		 		 

  expression:
    | v=VARIABLE                            { Syntax.Variable v }
    | i=INT_LITERAL                         { Syntax.IntVal i   }
    | e1=expression MULTIPLY e2=expression  { Syntax.Multiply (e1, e2) }
    | e1=expression PLUS     e2=expression  { Syntax.Plus (e1, e2)     }
    | e1=expression MINUS    e2=expression  { Syntax.Minus (e1, e2)    }
    | e1=expression DIVIDE   e2=expression  { Syntax.Divide (e1, e2)   }
    | e1=expression MODULO   e2=expression  { Syntax.Modulo (e1, e2)   }
    | e1=expression EQUAL    e2=expression  { Syntax.Equal (e1, e2)    }
    | e1=expression NOTEQUAL e2=expression  { Syntax.NotEqual (e1, e2) }
    | e1=expression GREATER  e2=expression  { Syntax.Greater (e1, e2)  }
    | e1=expression LESSER   e2=expression  { Syntax.Lesser (e1, e2)   }
    | LPAREN e=expression RPAREN            { e }

(* === Grammar Rules start === *)
