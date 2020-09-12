format PE console
entry start

include 'include/win32a.inc'

section '.data' data readable writable
        formatStr db '%s', 0
        formatNum db '%d', 0
        printNum db '%d', 10, 0
        number dd ?
        a dd ?
        b dd ?
        c dd ?

        enterStr db 'Enter factorial number:', 0
        answerStr db '%d! = %d', 0
        NULL = 0


section '.code' code readable executable
        start:
                mov [a], 0
                mov [b], 1
                mov [c], 0
                push enterStr
                call [printf]
                push number
                push formatNum
                call[scanf]


                mov eax, [number]
                mov [b], eax


                mov eax, [number]
                mov [a], eax

                mov ebx, 0
                lp:

                        sub [number], 1
                        mov eax, [a]
                        imul eax, [number]
                        mov [a], eax
                        cmp [number], 1
                        jne lp


                push [a]
                push [b]
                push answerStr
                call [printf]
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