open TextIO;

val OPTIONAL = true;

exception InvalidSymbol of string;
exception InvalidNumber of string;

datatype token =
     TK_LAM
   | TK_NUM of int
   | TK_ID of string
   | TK_PLUS
   | TK_MULT
   | TK_LPAR
   | TK_RPAR
   | TK_IFEQ
   | TK_PRINT
   | TK_EOF
;

val keywordTokens =
   [
      ("println", TK_PRINT),
      ("ifleq0", TK_IFEQ)
   ]
;

val symbolTokens =
   [
      ("*", TK_MULT),
      ("+", TK_PLUS),
      ("(", TK_LPAR),
      (")", TK_RPAR),
      ("λ", TK_LAM)
   ]
;

fun error s = (output (stdErr, s); OS.Process.exit OS.Process.failure);

fun member s xs = List.exists (fn st => st = s) xs;

fun pairLookup s xs =
   case List.find (fn (st, _) => st = s) xs of
      NONE => NONE
   |  SOME (_, v) => SOME v
;

fun streamReduce pred func base fstr =
   case lookahead fstr of
      NONE => base
   |  SOME c => if pred c
         then (input1 fstr; streamReduce pred func (func (c, base)) fstr)
         else base
;

val clearWhitespace = streamReduce Char.isSpace (fn _ => ()) ();
fun buildToken pred fstr = implode (rev (streamReduce pred (op ::) [] fstr));

fun outputIdentifier id =
   case pairLookup id keywordTokens of
      NONE => TK_ID id
   |  SOME tk => tk
;

fun outputNumber s =
   case Int.fromString s of
      SOME n => TK_NUM n
   |  NONE => raise InvalidNumber s
;

fun outputSymbol sym =
   case pairLookup sym symbolTokens of
      NONE => raise InvalidSymbol sym
   |  SOME tk => tk
;

val recognizeIdentifier = buildToken Char.isAlphaNum;
val recognizeNumber = buildToken Char.isDigit;

fun simple_symbol fstr s = s;


fun recognizeSymbol fstr =
   case input1 fstr of
      SOME c =>
         (
             simple_symbol fstr (str c)
         )
   |  NONE => raise InvalidSymbol "-eof-"
;

fun recognizeFirstToken fstr =
   case lookahead fstr of
      SOME c => if Char.isAlpha c
                then outputIdentifier (recognizeIdentifier fstr)
                else if Char.isDigit c
                then outputNumber (recognizeNumber fstr)
                else outputSymbol (recognizeSymbol fstr)
   | NONE => TK_EOF
;

fun nextToken fstr = (clearWhitespace fstr; recognizeFirstToken fstr) 
   handle InvalidSymbol s => error ("invalid symbol: '" ^ s ^ "'\n")
        | InvalidNumber s => error ("invalid number: '" ^ s ^ "'\n")
;

