bits 16
org 0x7C00

boot:
	mov ax, 0x2401
	int 0x15 ; enable A10 bit
	mov ax, 0x3
	int 0x10 ; set VGA text mode 3
	lgdt [gdt_pointer] ; load the gdt table
	mov eax, cr0
	or eax, 0x1 ; set the protected mode bit on special CPU register cr0
	mov cr0, eax
	jmp CODE_SEG:boot2 ; long jump to the code segment

gdt_start:
	dq 0x0

gdt_code:
	dw 0xFFFF ; segment limit bits 0-15
	dw 0x0 ; base bits 0-15
	db 0x0 ; base bits 16-23
	db 10011010b ; access byte
	db 11001111b ; high 4 bits (flags) low 4 bits (limit 4 last bits)
	db 0x0 ; base bits 24-31

gdt_data:
	dw 0xFFFF ; segment limit bits 0-15
	dw 0x0 ; base bits 0-15
	db 0x0 ; base bits 16-23
	db 10010010b ; access byte
	db 11001111b ; high 4 bits (flags) low 4 bits (limit 4 last bits)
	db 0x0 ; base bits 24-31

gdt_end:

gdt_pointer:
	dw gdt_end - gdt_start
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32 ; tell nasm to output 32 bits
boot2:
	mov ax, DATA_SEG ; tell all segments to point at the data segment
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	mov esi, hello
	mov ebx, 0xb8000 ; memory location of VGA text buffer

.loop:
	lodsb
	or al, al
	jz halt
	or eax, 0x0100
	mov word [ebx], ax
	add ebx, 2
	jmp .loop

halt:
	cli
	hlt

hello: db "Hello world!", 0

times 510 - ($-$$) db 0
dw 0xAA55
