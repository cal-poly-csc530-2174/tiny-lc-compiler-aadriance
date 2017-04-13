use "lamCalcTok.sml";
use "lamCalcAST.sml";

fun parseParen cur stream =

;

fun parseLam cur stream =
    case cur of
        TK_NUM n => EXP_NUM n
        | TK_ID i => EXP_ID i
        | TK_LPAR => parseParen (nextToken stream) stream
        | _ => (print ("err: did not find valid token in lam"); OS.Process.exit OS.Process.failure)
;

fun parse file =
  let
    val stream = TextIO.openIn file
    val cur = nextToken stream
    (* val (last, prog) = parseProgram cur (PROGRAM {elems= []}) stream *)
  in
    if (last = TK_EOF) then prog else (print ("err: did not find EOF");
                                        OS.Process.exit OS.Process.failure)
  end
;