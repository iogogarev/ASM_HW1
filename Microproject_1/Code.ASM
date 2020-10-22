;Гогарев Игорь БПИ192 Вариант 6
format PE console
entry start

include 'include/win32a.inc'

section '.data' data readable writable
        resultsStr      db 'The results are:',10, 0
        strMax          db 'Max number before being overflow: %d = %d + %d + %d. ',10, 0
        firstOverflow   db 'First number after overflow is %d.', 0
        strScanInt      db  '[%d] -> %d ',10, 0 ;для вывода элементов последовательности трибоначчи с их порядковым номером
        f1Elem          db '[f_1] = %d', 10, 0 ;для вывода первого из трех последних элементов до переполнения
        f2Elem          db '[f_2] = %d', 10, 0 ;для вывода второго из трех последних элементов до переполнения
        f3Elem          db '[f_3] = %d', 10, 0 ;для вывода третьего из трех последних элементов до переполнения
        tmpStack        dd ? ;будет содеражть указатель на стек при входе в подпрограмму
        a               dd 0 ;первый элемент рассматриваемой тройки чисел
        b               dd 0 ;второй элемент рассматриваемой тройки чисел
        c               dd 0 ;третий элемент рассматриваемой тройки чисел
        sum             dd 0 ;содержит сумму a, b, c
        reserve         dd 0 ;будет хранить в подпрограмме вывода результатов наименьшее слагаемое в максимальной сумме
        counter         dd 0 ;счетчик для вычисления порядкого элемента в последовательности трибоначчи
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


;---------------ПОДПРОГРАММЫ-(SUBPROGRAMS)----------------------------
inizialization:
              ;ниже проходит вывод в консоль первых трех элементов последовательности трибоначчи - 0, 1, 1
              ;и их порядковый номер
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
              ;ниже происходит инициализация первой тройки - 0, 1, 1, а порядковый номер становится равным 4
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
;здесь в цикле выводятся числа последовательности трибоначчи вместе с соответствующим порядковым номером
;условия выхода из цикла - когда очередная сумма(sum)станет меньше второго элемента тройки(b)
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
;здесь происходит вывод результатов вычислений
        mov [tmpStack], esp
        push resultsStr
        call[printf]
        mov eax, [c]
        sub eax, [b]
        sub eax, [a]
        mov [reserve], eax ;теперь в reserve записана разность между последней положительной суммой и двумя наибольшими слагаемыми
        ;таким образом, reserve - это наименьший элемент макисмальной суммы
        ;ниже происходит вывод последних трех элементов последовательности трибоначчи до переполнения
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
        ;ниже происходит вывод наибольшей суммы и того, как она получилась
        push [b]
        push [a]
        push [reserve]
        push [c]
        push strMax
        call[printf]
        ;ниже происходит вычисления следующей суммы (она уже будет переполнена) и ее вывод
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

