;ВАРИАНТ 6;
;Массив B сформировать по следующему правилу:
;он состоит из элементов А, значение которых кратно введенному числу X

format PE console
entry start

include 'include/win32a.inc'

section '.data' data readable writable

        strVecSize      db 'size of vector?', 0
        strX            db 'X? ', 0
        strIncorrectX   db 'Your X is incorrect! ', 0
        strArrayB       db 'Array B:', 10, 0
        strIncorSize    db 'incorrect size of vector = %d' , 10, 0
        strVecElemI     db '[%d]? ', 0
        strScanInt      db  '%d', 0
        strVecElemOut   db '[%d] = %d', 10, 0

        vec_size        dd 0
        tmpStack        dd ?
        a               dd ?
        b               dd ?
        X               dd ?
        remain          dd ?
        b_size          dd 0
        step            dd ?
        sum             dd 0
        i               dd ?
        tmp             dd ?
        tmpB            dd ?
        vec             rd 100
        vecB            rd 100
        NULL = 0

section '.code' code readable executable

start:
        call init

getVectorFunc:
        call getVector
        call putVec

incorrectX:
           push strIncorrectX
           call [printf]

finish:
        call [getch]
        push NULL
        call [ExitProcess]
;--------------------------------------------------------------------------------------------
;ПОДПРОГРАММЫ
init:
        mov [tmpStack], esp
        mov eax,[b_size]
        mov eax, 0
        mov [b_size], eax
        push strX
        call [printf]
        push X
        push strScanInt
        call [scanf]
        mov eax, [X]
        cmp eax, 0
        jle incorrectX
        PUSH strVecSize
        call [printf]
        push vec_size
        push strScanInt
        call [scanf]
        mov eax, [vec_size]
        cmp eax, 0
        jg getVectorFunc
        push [vec_size]
        push strIncorSize
        call [printf]
        jmp finish
        mov esp, [tmpStack]
        ret

getVector:
        mov [tmpStack], esp
        xor ecx, ecx
        mov ebx, vec

getVecLoop:
        mov [tmp], ebx

        cmp ecx, [vec_size]
        jge endInputVector
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]

        push ebx
        push strScanInt
        call [scanf]
        mov eax ,dword [ebx]
        mov [a], eax
        cmp eax, 0
        jl findRemain2
        findRemain:
               mov eax, [a]

               cmp eax, 0
               jle makeCompare
               sub eax, [X]
               mov [a], eax
               jmp findRemain

        findRemain2:
               mov eax, [a]

               cmp eax, 0
               jge makeCompare
               add eax, [X]
               mov [a], eax
               jmp findRemain2



        makeCompare:
        mov eax, [a]
        cmp eax, 0
        jne next
        mov eax,[b_size]
        imul eax, 4
        mov [step], eax
        mov eax, dword [ebx]
        mov ebx, vecB
        add ebx, [step]
        mov [tmpB], ebx

        mov [ebx], eax
        mov ebx, [tmpB]
        add ebx, 4
        mov eax,[b_size]
        add eax, 1
        mov [b_size], eax


next:
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop

endInputVector:
        push strArrayB
        call [printf]
        xor ecx, ecx
        xor edx, edx
        mov edx, vecB
        mov esp, [tmpStack]
        ret

putVec:
        mov [tmpStack], esp
        putVecLoop:

        mov [tmpB], edx
        cmp ecx, [b_size]
        je finish
        mov [i], ecx
        push dword [edx]
        push ecx
        push strVecElemOut
        call [printf]
        mov ecx, [i]
        inc ecx
        mov edx, [tmpB]
        add edx, 4
        jmp putVecLoop
        mov esp, [tmpStack]
        ret
;--------------------------------------------------------------------------------------------
section '.idata' import data readable
        library kernel, 'kernel32.dll',\
        msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'


