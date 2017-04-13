datatype expression =
     EXP_NUM   of int
   | EXP_ID    of string
   | EXP_ADD   of {lft: expression, rht: expression}
   | EXP_MULT  of {lft: expression, rht: expression}
   | EXP_IFEQ  of {test: expression, tPath: expression, fPath: expression}
   | EXP_PRINT of expression
   | EXP_FUNC  of {var: expression, alg: expression}
;