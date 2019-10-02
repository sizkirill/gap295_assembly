.586 
.model  flat, stdcall
option casemap:none  

; Link in the CRT.
includelib libcmt.lib
includelib libvcruntime.lib
includelib libucrt.lib
includelib legacy_stdio_definitions.lib

extern printf:NEAR
extern scanf:NEAR
extern _getch:NEAR

.data
    healthStr DB 'Health %d', 0Ah, 0
    health DD 20
.code

main proc C
        push ebp
        mov ebp, esp
        push edi

        call ShowHealth

    MainLoop:
        ; get player input
        call _getch
        mov edi, eax

        ; check to see if we're quitting
        cmp edi, 71h ; 71h == 'q'
        je Dead

        ; check for death
        and edi, 0fh ; hacky!
        sub health, edi
        cmp health, 0
        jle Dead

        call ShowHealth
        jmp MainLoop

    Dead:
        pop edi
        mov esp, ebp
        pop ebp

        xor eax, eax
        ret
main endp

ShowHealth proc
        push ebp
        mov ebp, esp

        push health
        push offset healthStr
        call printf
        add esp, 8

        mov esp, ebp
        pop ebp

        ret
ShowHealth endp

END