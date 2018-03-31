bits 16     ; tell compiler this is 16 bit code
org 0x7C00  ; tell compiler the offset of the output

boot:
    mov si, hello   ; put the address of the hello label in si register
    mov ah, 0x0e    ; 0x0e means "Write character in TTY mode", put that in ah register
    
.loop:
    lodsb       ; load si into al
    or al, al   ; al == 0?
    jz halt     ; if al == 0 then jump to halt label
    int 0x10    ; run BIOS interrupt Video Services
    jmp .loop
    
halt:
    cli ; clear interrupt flag
    hlt ; halt execution
    
hello: db "Hello World!" , 0    ; initialize memory with the string

times 510 - ($-$$) db 0 ; pad up to 510 bytes with zeros
dw 0xaa55               ; mark this 512 byte sector bootable
