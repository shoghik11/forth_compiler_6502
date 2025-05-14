.segment "BASIC"
    .word $0801          ; Load address
    .byte $0C, $08       ; Line number = 2060
    .byte $9E            ; SYS token
    .byte "2","0","6","4",0 ; SYS2064, 0-terminated
    .word 0              ; End of BASIC


.segment "ZEROPAGE"
sp:    .res 1
tmp1:  .res 1
tmp2:  .res 1
tmp3:  .res 1

.segment "BSS"
stack: .res 256

.segment "CODE"

init:
    LDA #$FF
    STA sp
    RTS

push:
    LDY sp
    STA stack,Y
    DEY
    STY sp
    RTS

pop:
    INY
    STY sp
    LDA stack,Y
    RTS
; Print function which is now a wrapper to print_decimal
print:
    JSR print_decimal
    RTS

print_decimal:
    JSR pop
    STA tmp3        ; value to print
    LDX #0          ; index for digit buffer

print_convert:
    LDA tmp3
    CMP #10
    BCC print_done
    LDA tmp3
    LDX #10
    JSR divide_by_10
    STA tmp3
    PHA             ; push remainder
    INX
    JMP print_convert

print_done:
    LDA tmp3
    CLC
    ADC #$30        ; convert to ASCII
    JSR $FFD2       ; CHROUT

print_digits:
    PLA
    CLC
    ADC #$30
    JSR $FFD2
    DEX
    BNE print_digits

print_exit:
    RTS

; helper: divide A by 10
divide_by_10:
    STA tmp2        ; store dividend
    LDA #0          ; clear A
    STA tmp1        ; clear tmp1 (remainder counter)
    LDX #0          ; clear X (quotient)
    LDY #0          ; clear Y (optional)

divide_loop:
    LDA tmp2
    SEC
    SBC #10
    BCC done_divide
    STA tmp2
    INX
    JMP divide_loop

done_divide:
    STX tmp2        ; quotient → tmp2
    LDA tmp2        ; return quotient in A
    RTS

print_stack:
    LDY sp
print_loop:
    INY
    CPY #$00
    BEQ done
    LDA stack,Y
    JSR print_decimal  ; print the value
    JMP print_loop
done:
    RTS

add:
    JSR pop
    STA tmp1
    JSR pop
    CLC
    ADC tmp1
    JSR push
    RTS

sub:
    JSR pop
    STA tmp1
    JSR pop
    SEC
    SBC tmp1
    JSR push
    RTS

mul:
    JSR pop
    STA tmp1
    JSR pop
    STA tmp2
    LDA #0
    STA tmp3

multiply_loop:
    LSR tmp1
    BCC skip_add
    CLC
    LDA tmp3
    ADC tmp2
    STA tmp3

skip_add:
    ASL tmp2
    DEC tmp1
    BNE multiply_loop

    LDA tmp3
    JSR push
    RTS

dup:
    LDY sp
    INY
    LDA stack,Y
    JSR push
    RTS

swap:
    JSR pop
    STA tmp1
    JSR pop
    STA tmp2
    LDA tmp1
    JSR push
    LDA tmp2
    JSR push
    RTS

drop:
    INY
    STY sp
    RTS

over:
    LDY sp
    INY
    INY
    LDA stack,Y
    JSR push
    RTS

mod:
    JSR pop
    STA tmp1     ; divisor
    JSR pop
    STA tmp2     ; dividend

    LDA tmp2
    LDY #0

mod_loop:
    SEC
    SBC tmp1
    BCC mod_done
    INY
    JMP mod_loop

mod_done:
    CLC
    ADC tmp1
    JSR push
    RTS

neg:
    JSR pop
    EOR #$FF
    CLC
    ADC #1
    JSR push
    RTS

nip:
    JSR pop
    STA tmp1
    JSR pop
    LDA tmp1
    JSR push
    RTS

tack:
    JSR neg
    RTS
