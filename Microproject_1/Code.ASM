;������� ����� ���192 ������� 6
format PE console
entry start

include 'include/win32a.inc'

section '.data' data readable writable
        resultsStr      db 'The results are:',10, 0
        strMax          db 'Max number before being overflow: %d = %d + %d + %d. ',10, 0
        firstOverflow   db 'First number after overflow is %d.', 0
        strScanInt      db  '[%d] -> %d ',10, 0 ;��� ������ ��������� ������������������ ���������� � �� ���������� �������
        f1Elem          db '[f_1] = %d', 10, 0 ;��� ������ ������� �� ���� ��������� ��������� �� ������������
        f2Elem          db '[f_2] = %d', 10, 0 ;��� ������ ������� �� ���� ��������� ��������� �� ������������
        f3Elem          db '[f_3] = %d', 10, 0 ;��� ������ �������� �� ���� ��������� ��������� �� ������������
        tmpStack        dd ? ;����� ��������� ��������� �� ���� ��� ����� � ������������
        a               dd 0 ;������ ������� ��������������� ������ �����
        b               dd 0 ;������ ������� ��������������� ������ �����
        c               dd 0 ;������ ������� ��������������� ������ �����
        sum             dd 0 ;�������� ����� a, b, c
        reserve         dd 0 ;����� ������� � ������������ ������ ����������� ���������� ��������� � ������������ �����
        counter         dd 0 ;������� ��� ���������� ��������� �������� � ������������������ ����������
        NULL = 0
section '.code' code readable executable

start:

       call inizialization
       call loop_output
       call printResults


finish:

        call [getch]
        push NULL
        call [ExitProcess]


;---------------������������-(SUBPROGRAMS)----------------------------
inizialization:
              ;���� �������� ����� � ������� ������ ���� ��������� ������������������ ���������� - 0, 1, 1
              ;� �� ���������� �����
              mov [tmpStack], esp
              push 0
              push 1
              push strScanInt
              call[printf]
              push 1
              push 2
              push strScanInt
              call[printf]
              push 1
              push 3
              push strScanInt
              call[printf]
              ;���� ���������� ������������� ������ ������ - 0, 1, 1, � ���������� ����� ���������� ������ 4
              mov eax, 0
              mov [a], eax
              mov eax,  1
              mov [b], eax
              mov [c], eax
              mov [counter], 4
              mov esp, [tmpStack]
              ret


loop_output:
        mov [tmpStack], esp
;����� � ����� ��������� ����� ������������������ ���������� ������ � ��������������� ���������� �������
;������� ������ �� ����� - ����� ��������� �����(sum)������ ������ ������� �������� ������(b)
        lp:
         mov eax,[a]
         add eax, [b]
         add eax, [c]
         mov [sum], eax
         mov eax, [sum]
         cmp eax, [b]
         jl printResults
         mov eax, [b]
         mov [a], eax
         mov eax, [c]
         mov [b], eax
         mov eax, [sum]
         mov [c], eax
         push [c]
         mov eax, [counter]
         inc eax
         push eax
         mov [counter], eax
         push strScanInt
         call [printf]

         jmp lp
         mov esp, [tmpStack]
         ret


printResults:
;����� ���������� ����� ����������� ����������
        mov [tmpStack], esp
        push resultsStr
        call[printf]
        mov eax, [c]
        sub eax, [b]
        sub eax, [a]
        mov [reserve], eax ;������ � reserve �������� �������� ����� ��������� ������������� ������ � ����� ����������� ����������
        ;����� �������, reserve - ��� ���������� ������� ������������ �����
        ;���� ���������� ����� ��������� ���� ��������� ������������������ ���������� �� ������������
        mov eax,[a]
        push eax
        push f1Elem
        call [printf]
        mov eax,[b]
        push eax
        push f2Elem
        call [printf]
        mov eax,[c]
        push eax
        push f3Elem
        call [printf]
        ;���� ���������� ����� ���������� ����� � ����, ��� ��� ����������
        push [b]
        push [a]
        push [reserve]
        push [c]
        push strMax
        call[printf]
        ;���� ���������� ���������� ��������� ����� (��� ��� ����� �����������) � �� �����
        mov eax, [c]
        add eax, [a]
        add eax, [b]
        push eax
        push firstOverflow
        call [printf]
        mov esp, [tmpStack]
        jmp finish
        ret

;---------------------------------------------------------------------
section '.idata' import data readable
        library kernel, 'kernel32.dll',\
        msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'

