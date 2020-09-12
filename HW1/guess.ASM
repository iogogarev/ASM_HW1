format PE console
entry start

include 'include/win32a.inc'

section '.data' data readable writable
        formatStr db '%s', 0
        formatNum db '%d', 0
        printNum db '%d', 10, 0
        a dd ?
        b dd ?
        c dd ?

        enterStr db 'Enter your number: ', 0
        greaterStr db 'The number is greater!', 10, 0
        lessStr db 'The number is less!', 10, 0
        guessStr db 'You are right!', 10, 0
        answerStr db '%d! = %d', 0
        NULL = 0
        number = 10

section '.code' code readable executable
        start:
                lp:
                        push enterStr
                        call [printf]
                        push a
                        push formatNum
                        call[scanf]
                        cmp [a], number
                        jl less
                        jg greater
                        jmp finish
               less:
                        push greaterStr
                        call [printf]
                        jmp lp
               greater:
                        push lessStr
                        call [printf]
                        jmp lp
               finish:
                        push guessStr
                        call[printf]
                        call [getch]
                        push NULL
                        call [ExitProcess]




section '.idata' import data readable
        library kernel, 'kernel32.dll',\
        msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'