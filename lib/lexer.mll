(* -*-fundamental-*- *)
{
exception SyntaxError of string
}


(* === Lexer Rules start === *)

let variable      = ['_' 'a'-'z' 'A'-'Z'] ['_' 'a'-'z' 'A'-'Z' '0'-'9']*
let commentKeyw   = "MEHHH!"
let assignLhsKeyw = "SOLRAN"
let assignRhsKeyw = "SEIRAN"
let printKeyw     = "IDHU EPADI IRUKU"
let ifKeyw        = "MALAI DA ANNAMALAI"
let elseKeyw      = "EN VAZHI THANI VAZHI"
let endifKeyw     = "KATHAM, KATHAM"
let whileKeyw     = "NOORU THADAVA SONNA MAADIRI"
let endwhileKeyw  = "MAGIZHCHI"
let verKeyw       = "I AM CHITTI"

(*
===============
Quick Reference
===============

Actions:

      Parser.ABC              : Returns a Parser token to parser
      token lexbuf            : Recursive call to self i.e. skip this token
      Lexing.lexme lexbuf     : Extract matched string token (lexme means token)
*)

rule token = parse
    commentKeyw [^'\n']* '\n' { Lexing.new_line lexbuf; Parser.NEWLINE }
  | '\n'                      { Lexing.new_line lexbuf; Parser.NEWLINE }
  | ['\t' ' ']                { token lexbuf }
  | ['0'-'9']+	              { Parser.INT_LITERAL (int_of_string(Lexing.lexeme lexbuf)) }
  | ['0'-'9' '.']+            { Parser.VER_LITERAL (Lexing.lexeme lexbuf) }
  | assignLhsKeyw	      { Parser.ASSIGN_LHS } 
  | assignRhsKeyw	      { Parser.ASSIGN_RHS }
  | printKeyw		      { Parser.PRINT	  }
  | ifKeyw		      { Parser.IF	  }
  | elseKeyw		      { Parser.ELSE	  }
  | endifKeyw		      { Parser.ENDIF	  }
  | whileKeyw		      { Parser.WHILE	  }
  | endwhileKeyw	      { Parser.ENDWHILE	  }
  | verKeyw	              { Parser.LANG_VER	  }
  | '+'			      { Parser.PLUS       }
  | '-'			      { Parser.MINUS      }
  | '*'			      { Parser.MULTIPLY   }
  | '/'			      { Parser.DIVIDE     }
  | '%'			      { Parser.MODULO     }
  | '('			      { Parser.LPAREN     }
  | ')'			      { Parser.RPAREN     }
  | "=="		      { Parser.EQUAL      }
  | "<>"		      { Parser.NOTEQUAL   }
  | '>'		              { Parser.GREATER    }
  | '<'		              { Parser.LESSER     }
  | '"'                       { let buf = Buffer.create 10 in
                                strreader buf lexbuf }
  | variable		      { Parser.VARIABLE (Lexing.lexeme lexbuf) }
  | eof                       { Parser.EOF }
  | _                         { raise (SyntaxError (Lexing.lexeme lexbuf)) }

and strreader buf = parse
  | '"'                       { Parser.STRINGLITERAL (Buffer.contents buf) }
  | eof                       { raise End_of_file }
  | _ as char                 { Buffer.add_char buf char; strreader buf lexbuf }


(* === Lexer Rules end === *)

{
}
