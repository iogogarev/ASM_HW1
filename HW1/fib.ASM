format PE console
entry start

include 'include/win32a.inc'

section '.data' data readable writable
        formatStr db '%s', 0
        formatNum db '%d', 0
        printNum db '%d', 10, 0
        max dd ?
        a dd ?
        b dd ?
        c dd ?

        enterStr db 'Enter quantity of fibbonacci numbers:', 0

        NULL = 0


section '.code' code readable executable
        start:
                mov [a], 0
                mov [b], 1
                mov [c], 0
                push enterStr
                call [printf]
                push max
                push formatNum
                call[scanf]
                mov ebx, 0
                lp:
                        mov eax, [a]
                        add eax,[b]
                        mov [c], eax

                        mov eax, [b]
                        mov [a], eax

                        mov eax, [c]
                        mov [b], eax


                        push [a]
                        push printNum
                        call [printf]


                        add ebx, 1
                        cmp ebx, [max]
                        jne lp



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