from sexpdata import *
import sys
#Symbol.value() to get string!

def process(exp):
    outStr = ''
    if type(exp) is list:
        if type(exp[0]) is Symbol:
            test = exp[0].value()
            if test == 'λ' : 
                outStr = '(function (' + process(exp[1]) + ')' + '{ return' +  process(exp[2]) + '})'
                print('lam step')
            elif test == '+' : 
                outStr = '(' + process(exp[1]) + '+' + process(exp[2]) + ')'
                print('plus step')
            elif test == '*' : 
                outStr = '(' + process(exp[1]) + '*' + process(exp[2]) + ')'
                print('mult step')
            elif test == 'ifleq0' : 
                outStr = '(' + process(exp[1]) + ' <= 0 ?' + process(exp[2]) + ':' + process(exp[3]) + ')'
                print('if less 0 step')
            elif test == 'println' : 
                outStr = '(console.log(' + process(exp[1]) + '))'
                print('print step')
            elif len(exp) == 2:
                    outStr = '(' + process(exp[0]) + '(' + process(exp[1]) + '))'
                    print('apply step')
            else:
                outStr = test
                print('string step')
        else:
            if len(exp) == 2:
                    outStr = '(' + process(exp[0]) + '(' + process(exp[1]) + '))'
                    print('apply step')
            else:
                outStr = process(exp[0])
                print('int step')
    else:
        if type(exp)  is Symbol:
            outStr = exp.value()
            print('final value step')
        else:
            outStr = str(exp)
            print('final int step')
    print('~'+outStr)
    return outStr

def main():
    inName = sys.argv[1]
    outName = sys.argv[2]
    inF = open(inName, 'r')
    outF = open(outName, 'w')
    inStr = inF.read()
    outStr = ''
    print(inStr)
    exp = loads(inStr)
    print(exp)
    print(len(exp))
    outStr = process(exp)
    print(outStr)
    outF.write(outStr)

if __name__ == "__main__":
    main()