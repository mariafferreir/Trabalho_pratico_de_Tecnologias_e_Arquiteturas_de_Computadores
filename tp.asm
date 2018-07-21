.8086
.model small
.stack 2048

dseg	segment para public 'data'
		
		Car		db	32	; Guarda um caracter do Ecran 
		Cor		db	7	; Guarda os atributos de cor do caracter
		Car2		db	32	; Guarda um caracter do Ecran 
		Cor2		db	7	; Guarda os atributos de cor do caracter
		POSy		db	5	; a linha pode ir de [1 .. 25]
		POSx		db	10	; POSx pode ir [1..80]	
		POSya		db	5	; Posição anterior de y
		POSxa		db	10	; Posição anterior de x
		
		
		
;##########LINHA/COL Imp_Fich_Config	
		linha4 	db 	8
		col4  	db	30
;##########LINHA/COL PONTUAÇOES
		linha2 		db 	6
		col2  		db	37
		
;##########LINHA/COL CONFIG_GRELHA
		linha3 		db 	3
		col3  		db	4
	
;##########FICHEIROS
		Erro_Open       db      'Erro ao tentar abrir o ficheiro$'
		Erro_Ler_Msg    db      'Erro ao tentar ler do ficheiro$'
		Erro_Close      db      'Erro ao tentar fechar o ficheiro$'
		fname         	db      'TAB.txt',0
		HandleFich      dw      0
		car_fich        db      ?
		Fich         	db      'points.txt',0			
		buffer 			db 55 ;nr max de chars.
						db ? ;nr de char inseridos peo utilizador.
						db 55 dup(0) ;chars inseridos.
		buffer_a 			db 16 ;nr max de chars.
							db ? ;nr de char inseridos peo utilizador.
							db 16 dup(0) ;chars inseridos.
		fhandle dw	0
		msgErrorCreate	db	"Ocorreu um erro na criacao do ficheiro!$"
		msgErrorWrite	db	"Ocorreu um erro na escrita para ficheiro!$"
		msgErrorClose	db	"Ocorreu um erro no fecho do ficheiro!$"
		
		
;##########VARIAVEIS TABULEIRO		
		ultimo_num_aleat dw 0
		
		str_num db 5 dup(?),'$'
	
        linha		db	0	; Define o número da linha que está a ser desenhada
        nlinhas		db	0
		core		db 	0
		cara		db	' '	
		
		vetcores 	db   54 dup(?)
;##########VARIAVEIS EXPLOSAO DO TABULEIRO

		linhadovet	db 	1
		colunadovet	db 	1
		
;##########VARIAVEIS TEMPORIZADOR
		tempo     		db  '0066'		
		tempo_aux 		db  '    '	
		Minutos			dw		0	; Vai guardar os minutos actuais
		Segundos		dw		60	; Vai guardar os segundos actuais
		Old_seg			dw		0	; Guarda os últimos segundos que foram lidos
		STR12			DB 		"            "	; String para o tempo
		Minus_de_jogo 	dw 		0	; vai ter os minutso que passaram desque iniciou o jogo
		Secs_de_jogo 	dw 		0	; vai ter os secs que passaram desque inicio o jogo
		contador		dw		0	

;##############VARIAVEIS PONTOS	
		matriz 			db 	5 dup(4 dup(0))
		ospontos        db  '0000'
		pointsaux 		db  '    '
		newpoints		db	'    '
		matriz_a 		db 	5 dup(4 dup(0))
		fnewtop			db	'filent.txt',0
		
;################VARIAVEIS 		NOVO_TABULEIRO_NECESSARIO?
		tabx 		db	 	8
		taby 		db	 	30
		
dseg	ends

cseg	segment para public 'code'
assume		cs:cseg, ds:dseg



;Tiago$0093Fernando$0099Camilo$0101Francisca$0109Cris$0114  <-- info do fich com os pontos
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
MOSTRA MACRO STR 
		MOV AH,09H
		LEA DX,STR 
		INT 21H
ENDM	
goto_xy	macro		POSx,POSy
		mov		ah,02h
		mov		bh,0		; numero da página
		mov		dl,POSx
		mov		dh,POSy
		int		10h
endm

;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################


escreve_car macro
 		mov 	bx,	HandleFich			
		mov		ah, 40h				
		lea		dx, Car
		mov 	cx,	1	
		int		21H	
endm
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################

goto_xy	macro		POSx,POSy
		mov		ah,02h
		mov		bh,0		; numero da página
		mov		dl,POSx
		mov		dh,POSy
		int		10h
endm

;########################################################################



;####         ##########            ################ ############  ############  ####           ############
;####         ##########            ################ ############  ############  ####           ############
;####         ####                        ####       ####          ####          ####           ####    ####
;####         ####                        ####       ####          ####          ####           ####    ####
;####         ##########                  ####       ##########    ####          ####           ############
;####         ##########                  ####       ##########    ####          ####           ############
;####         ####                        ####       ####          ####          ####           ####    ####
;####         ####                        ####       ####          ####          ####           ####    ####
;###########  ##########                  ####       ############  ############  #############  ####    ####
;###########  ##########                  ####       ############  ############  #############  ####    ####



LE_TECLA	PROC

		mov		ah,08h
		int		21h
		mov		ah,0
		cmp		al,0
		jne		SAI_TECLA
		mov		ah, 08h
		int		21h
		mov		ah,1
SAI_TECLA:	RET
LE_TECLA	endp


;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;CONTADOR DE PONTOS
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################

	contador_de_pontos proc
			xor ax,ax
			add ospontos[3],2
			mov ah, ospontos[3]
			cmp ah,':'
			jne put
			inc ospontos[2]
			mov ah,'0'
			mov ospontos[3],ah
			mov	ah, ospontos[2]
			cmp ah,':'
			jne put
			inc ospontos[1]
			mov ah,'0'
			mov ospontos[2],ah
			mov	ah, ospontos[1]
			cmp ah,':'
			jne put
			inc ospontos[0]
			mov ah,'0'
			mov ospontos[1],ah
	put:
			mov ah,ospontos[0]
			mov al,	050h
			mov	es:[1286],ah
			mov	es:[1287],al
			mov ah,ospontos[1]
			mov al,	050h
			mov	es:[1288],ah
			mov	es:[1289],al
			mov ah,ospontos[2]
			mov al,	050h
			mov	es:[1290],ah
			mov	es:[1291],al
			mov ah,ospontos[3]
			mov al,	050h
			mov	es:[1292],ah
			mov	es:[1293],al
			
			
			
	ret
	contador_de_pontos endp

;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;Relogio
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
	
	
	Ler_TEMPO PROC												; HORAS - LE Hora DO SISTEMA E COLOCA em tres variaveis (Horas, Minutos, Segundos)
															; CH - Horas, CL - Minutos, DH - Segundos
	PUSH 	AX												
	PUSH 	BX
	PUSH 	CX												
	PUSH 	DX												
	
	PUSHF
	
	MOV 	AH, 2CH             							; Buscar a horas
	INT 	21H                 
		
	XOR 	AX,AX
	MOV 	AL, DH              							; Segundos para al
	mov 	contador, AX									; Guarda segundos na variavel correspondente
	
	POPF
	POP 	DX
	POP 	CX
	POP 	BX
	POP 	AX
 	RET 
Ler_TEMPO   ENDP 
	
	
	
Trata_Horas PROC												; Imprime o tempo no monitor

	PUSHF
	PUSH 	AX
	PUSH	BX
	PUSH 	CX
	PUSH 	DX		

	cmp 	Segundos, 0
	je 		acabou
	CALL 	Ler_TEMPO											; Horas, minutos e segundos do sistema
		
	MOV		AX, contador
	cmp		AX, Old_seg											; Verifica se os segundos mudaram desde a última leitura
	je		fim_horas											; Se a hora não mudou desde a última leitura sai.
	mov		Old_seg, AX											; Se segundos são diferentes actualiza informação do tempo
	
	dec 	Segundos
	cmp 	Segundos, 0
	jne 	naoacabou
	
naoacabou:
	mov 	ax,Segundos
	MOV 	bl, 10     
	div 	bl
	add 	al, 30h												; Caracter correspondente às dezenas
	add		ah,	30h												; Caracter correspondente às unidades
	MOV 	STR12[0],al											; 
	MOV 	STR12[1],ah
	MOV 	STR12[2],'s'		
	MOV 	STR12[3],'$'
	GOTO_XY	4,5
	MOSTRA	STR12 			
	
	goto_xy	POSy,POSx											; Volta a colocar o cursor onde estava antes de actualizar as horas	

fim_horas:		
	goto_xy	POSx,POSy											; Volta a colocar o cursor onde estava antes de actualizar as horas
	
	POPF
	POP 	DX		
	POP 	CX
	POP 	BX
	POP 	AX
	RET		

acabou:																			;Pedir nome do utilizador e meter isso e os pontos num ficheiro
	call end_screen
	
Trata_Horas ENDP


;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;end_screen chamada pelo trata horas
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################

end_screen PROC NEAR

mov	al,020h
	mov	ah,' ' 
	mov	bx,0
	mov	cx,25*80

CIC:    
	mov	es:[bx],ah
	mov	es:[bx+1],al
	inc	bx
	inc	bx
	loop	CIC
	
;TOYBLAST
	;LETRA -
	
	mov	al,0AFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'-'             ; AH - Caracter
	mov	bx,386           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA |
	
	mov	al,0AFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'|'             ; AH - Caracter
	mov	bx,388           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0A4h             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,390           ; BX = linha*160 + coluna*2=2*160+35*2=390 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,0A5h             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,392             ; BX = linha*160 + coluna*2=2*160+36*2=2154-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA Y
	
	mov	al,0AEh             ; AL - static ou não / background color / cor do texto
	mov	ah,'Y'             ; AH - Caracter
	mov	bx,394             ; BX = linha*160 + coluna*2=8*160+37*2=2156 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;ESPAÇO
	
	mov	al,0A0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,396           ; BX = linha*160 + coluna*2=8*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	;LETRA B
	
	mov	al,0A6h             ; AL - static ou não / background color / cor do texto
	mov	ah,'B'             ; AH - Caracter
	mov	bx,398           ; BX = linha*160 + coluna*2=8*160+39*2=2160 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA L
	
	mov	al,0A4h             ; AL - static ou não / background color / cor do texto
	mov	ah,'L'             ; AH - Caracter
	mov	bx,400           ; BX = linha*160 + coluna*2=8*160+40*2=2162 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,0ADh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,402           ; BX = linha*160 + coluna*2=8*160+41*2=2164 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA S
	
	mov	al,0A1h             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,404           ; BX = linha*160 + coluna*2=8*160+42*2=2166 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0A5h             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,406           ; BX = linha*160 + coluna*2=8*160+43*2=2168 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA |
	
	mov	al,0AFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'|'             ; AH - Caracter
	mov	bx,408           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA -
	
	mov	al,0AFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'-'             ; AH - Caracter
	mov	bx,410           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al



	
;#####SAIR	
	;LETRA S
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,3980       ; BX = linha*160 + coluna*2=24*160+70*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,3982           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA I
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'I'             ; AH - Caracter
	mov	bx,3984          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA R
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,3986          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	
	
;#######MENU
	
	;LETRA M
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'M'             ; AH - Caracter
	mov	bx,3968            ; BX = linha*160 + coluna*2=24*160+64*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA E
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,3970           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA N
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'N'             ; AH - Caracter
	mov	bx,3972          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA U
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'U'             ; AH - Caracter
	mov	bx,3974          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	
	;LETRA N
	
	mov	al,02Eh             ; AL - static ou não / background color / cor do texto
	mov	ah,'N'             ; AH - Caracter
	mov	bx,1676           ; BX = linha*160 + coluna*2=10*160+38*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
		;LETRA O
	
	mov	al,02Eh             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,1678          ; BX = linha*160 + coluna*2=2*160+35*2=390 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
		;LETRA M
	
	mov	al,02Eh              ; AL - static ou não / background color / cor do texto
	mov	ah,'M'             ; AH - Caracter
	mov	bx,1680          ; BX = linha*160 + coluna*2=2*160+35*2=390 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
		;LETRA E
	
	mov	al,02Eh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,1682           ; BX = linha*160 + coluna*2=2*160+35*2=390 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
		;LETRA :
	
	mov	al,02Eh             ; AL - static ou não / background color / cor do texto
	mov	ah,':'             ; AH - Caracter
	mov	bx,1684           ; BX = linha*160 + coluna*2=2*160+35*2=390 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
		;BARRA
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1984           ; BX = linha*160 + coluna*2=12*160+33*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1986           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
		mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1988           ; BX = linha*160 + coluna*2==-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
		mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1990           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
		mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1992           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
		mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1994           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
		mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1996           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
		mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1998           ; BX = linha*160 + coluna*2==-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
		mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,2000           ; BX = linha*160 + coluna*2==-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
		mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,2002           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
		mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,2004           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,2006           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,2008           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,2010           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,2012           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;#####PONTOS
	
		
	mov	al,02Eh              ; AL - static ou não / background color / cor do texto
	mov	ah,'P'             ; AH - Caracter
	mov	bx,2306         ; BX = linha*160 + coluna*2=14*160+33*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,002Eh             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'               ; AH - Caracter
	mov	bx,2308          ; BX = linha*160 + coluna*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,02Eh                ; AL - static ou não / background color / cor do texto
	mov	ah,'N'              ; AH - Caracter
	mov	bx,2310	; BX = linha*160 + coluna*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,02Eh            ; AL - static ou não / background color / cor do texto
	mov	ah,'T'              ; AH - Caracter
	mov	bx,2312          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	
	
	mov	al,02Eh               ; AL - static ou não / background color / cor do texto
	mov	ah,'O'              ; AH - Caracter
	mov	bx,2314          ; BX = linha*160 + coluna*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,02Eh               ; AL - static ou não / background color / cor do texto
	mov	ah,'S'               ; AH - Caracter
	mov	bx,2316          ; BX = linha*160 + coluna*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,02Eh               ; AL - static ou não / background color / cor do texto
	mov	ah,':'             ; AH - Caracter
	mov	bx,2318         ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	
	
	
	
	
	;#####ENTER
	;LETRA E
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,2636   ; BX = linha*160 + coluna*2=16*160+38*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA N
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'N'             ; AH - Caracter
	mov	bx,2638           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,2640          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA E
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,2642         ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

		
		;LETRA R
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,2644        ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	
			mov ah,ospontos[0]
			mov newpoints[0],ah
			mov al,	02Fh
			mov	es:[2322],ah
			mov	es:[2323],al
			mov ah,ospontos[1]
			mov newpoints[1],ah
			mov al,	02Fh
			mov	es:[2324],ah
			mov	es:[2325],al
			mov ah,ospontos[2]
			mov newpoints[2],ah
			mov al,	02Fh
			mov	es:[2326],ah
			mov	es:[2327],al
			mov ah,ospontos[3]
			mov newpoints[3],ah
			mov al,	02Fh
			mov	es:[2328],ah
			mov	es:[2329],al
			
	
			
			
			
			
			
			
			
			;abre ficheiro
		xor 	si,si
        mov     ah,3dh			; vamos abrir ficheiro para leitura 
        mov     al,0			; tipo de ficheiro	
        lea     dx,Fich			; nome do ficheiro
        int     21h				; abre para leitura 
        jc      erro_abrir		; pode aconter erro a abrir o ficheiro 
        mov     HandleFich,ax	; ax devolve o Handle para o ficheiro 
        jmp     ler_ciclo		; depois de aberto vamos ler o ficheiro 

erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai

		

ler_ciclo:

        mov     ah,3fh				; indica que vai ser lido um ficheiro 
        mov     bx,HandleFich		; bx deve conter o Handle do ficheiro previamente aberto 
        mov     cx,1				; numero de bytes a ler 
        lea     dx,car_fich			; vai ler para o local de memoria apontado por dx (car_fich)
        int     21h					; faz efectivamente a leitura
		jc	    erro_ler			; se carry é porque aconteceu um erro
		cmp	    ax,0				;EOF?	verifica se já estamos no fim do ficheiro 
		je	    fecha_ficheiro		; se EOF fecha o ficheiro

		
		mov 	al,car_fich
		cmp		al, '$'
		je		nova_linha
		

		
		jmp 	ler_ciclo
		
	nova_linha:

		
		
		mov     ah, 3fh
     	mov     bx, HandleFich
     	mov     cx, 1				; vai ler apenas um byte de cada vez
     	lea     dx, car_fich		; DX fica a apontar para o caracter lido
      	int     21h					; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0				; verifica se já chegou o fim de ficheiro EOF? 
		je		fecha_ficheiro		; se chegou ao fim do ficheiro fecha e sai
		mov 	bx,0				;1 algarismo da 1 coluna
		mov 	al,car_fich
		mov 	matriz[si][bx],al 	;meter numero
		;mov		ah, 02h
		;mov		dl, matriz[si][bx]
		;int		21H

		
		mov     ah, 3fh
     	mov     bx, HandleFich
     	mov     cx, 1				; vai ler apenas um byte de cada vez
     	lea     dx, car_fich		; DX fica a apontar para o caracter lido
      	int     21h					; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0				; verifica se já chegou o fim de ficheiro EOF? 
		je		fecha_ficheiro		; se chegou ao fim do ficheiro fecha e sai
		mov 	bx,1				;2 algarismo da coluna
		mov 	al,car_fich
		mov 	matriz[si][bx],al 	;meter numero
		;mov		ah, 02h
		;mov		dl, matriz[si][bx]
		;int		21H
		

		mov     ah, 3fh
     	mov     bx, HandleFich
     	mov     cx, 1				; vai ler apenas um byte de cada vez
     	lea     dx, car_fich		; DX fica a apontar para o caracter lido
      	int     21h					; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0				; verifica se já chegou o fim de ficheiro EOF? 
		je		fecha_ficheiro		; se chegou ao fim do ficheiro fecha e sai
		mov 	bx,2				;1 algarismo da 1  coluna
		mov 	al,car_fich
		mov 	matriz[si][bx],al 	;meter numero
		;mov		ah, 02h
		;mov		dl, matriz[si][bx]
		;int		21H


		mov     ah, 3fh
     	mov     bx, HandleFich
     	mov     cx, 1				; vai ler apenas um byte de cada vez
     	lea     dx, car_fich		; DX fica a apontar para o caracter lido
      	int     21h					; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0				; verifica se já chegou o fim de ficheiro EOF? 
		je		fecha_ficheiro		; se chegou ao fim do ficheiro fecha e sai
		mov 	bx,3				;2 algarismo da 2 coluna
		mov 	al,car_fich
		mov 	matriz[si][bx],al 	;meter numero
		;mov		ah, 02h
		;mov		dl, matriz[si][bx]
		;int		21H
	
		
		
		add si,4
		
	
		jmp ler_ciclo
		
		
erro_ler:
		mov     ah,09h
		lea     dx,Erro_Ler_Msg
		int     21h
		jmp 	sai
	  
	  
fecha_ficheiro:
	
		
		
		
		;###
		;mov		ah, 02h
		;mov		dl, newpoints[0]
		;int		21H
		;mov		ah, 02h
		;mov		dl,newpoints[1]
		;int		21H
		;mov		ah, 02h
		;mov		dl,newpoints[2]
		;int		21H
		;mov		ah, 02h
		;mov		dl,newpoints[3]
		;int		21H
		
		;mov		ah, 02h
		;mov		dl, matriz[0][0]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[0][1]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[0][2]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[0][3]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[4][0]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[4][1]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[4][2]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[4][3]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[8][0]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[8][1]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[8][2]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[8][3]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[12][0]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[12][1]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[12][2]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[12][3]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[16][0]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[16][1]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[16][2]
		;int		21H
		;mov		ah, 02h
		;mov		dl, matriz[16][3]
		;int		21H
	;###
	mov     ah,3eh
	mov     bx,HandleFich
	int     21h
	jnc     comparacao

	mov     ah,09h
	lea     dx,Erro_Close
	Int     21h
	jmp 	sai

troca:
	mov bx,0
	mov al,matriz[si][bx]	;tira o primeiro algarismo da matriz
	mov pointsaux[bx],al 	; mete-o na variavel auxiliar
	mov al,newpoints[bx]		;tira o primeiro algarismo de tempo
	mov matriz[si][bx],al 	;mete-o na matriz
	mov al, pointsaux[bx]	;tira o primeiro alrismo da variavel auxiliar
	mov newpoints[bx],al 		;mete-o na variavel aux
	
	inc bx
	mov al,matriz[si][bx]	;tira o segundo algarismo da matriz
	mov pointsaux[bx],al 	; mete-o na variavel auxiliar
	mov al,newpoints[bx]		;tira o segundo algarismo de tempo
	mov matriz[si][bx],al 	;mete-o na matriz
	mov al, pointsaux[bx]	;tira o segundo alrismo da variavel auxiliar
	mov newpoints[bx],al 		;mete-o na variavel aux
	
	inc bx
	mov al,matriz[si][bx]	;tira o treceiro algarismo da matriz
	mov pointsaux[bx],al 	; mete-o na variavel auxiliar
	mov al,newpoints[bx]		;tira o treceiro algarismo de tempo
	mov matriz[si][bx],al 	;mete-o na matriz
	mov al, pointsaux[bx]	;tira o treceiro alrismo da variavel auxiliar
	mov newpoints[bx],al 		;mete-o na variavel aux
	
	inc bx
	mov al,matriz[si][bx]	;tira o quarto algarismo da matriz
	mov pointsaux[bx],al 	; mete-o na variavel auxiliar
	mov al,newpoints[bx]		;tira o quarto algarismo de tempo
	mov matriz[si][bx],al 	;mete-o na matriz
	mov al, pointsaux[bx]	;tira o quarto alrismo da variavel auxiliar
	mov newpoints[bx],al 		;mete-o na variavel aux
	jmp comparacao
	
	
	
	
comparacao:
	mov 	si,16
 aqui:	
 ;#############milhares
 
 	mov 	bx,0						;temos o tempo assim: 0000 (em hexadecimal)
 	mov     al,newpoints[bx]
	;###
	;mov		ah, 02h
	;mov		dl, newpoints[bx]
	;int		21H
	;mov		ah, 02h
	;mov		dl, matriz[si][bx]
	;int		21H
	;###
 	cmp 	al,matriz[si][bx] 	;compara [0]000
 	ja 		troca
 	cmp 	al,matriz[si][bx]
 	jl 		continua
;##############centenas

 	mov 	bx,1
 	mov     al,newpoints[bx]	
	;###
	;mov		ah, 02h
	;mov		dl, newpoints[bx]
	;int		21H
	;mov		ah, 02h
	;mov		dl, matriz[si][bx]
	;int		21H
	;###
 	cmp 	al,matriz[si][bx] 	;compara 0[0]00
 	ja 		troca
 	cmp 	al,matriz[si][bx]
 	jl 		continua
;##############dezenas

 	mov 	bx,2
 	mov     al,newpoints[bx]
	;###
	;mov		ah, 02h
	;mov		dl, newpoints[bx]
	;int		21H
	;mov		ah, 02h
	;mov		dl, matriz[si][bx]
	;int		21H
	;###
 	cmp 	al,matriz[si][bx]	;compara 00[0]0
 	ja 		troca
 	cmp 	al,matriz[si][bx]
 	jl		continua
	
	
;#################unidades
 	mov 	bx,3
 	mov     al,newpoints[bx]
	;###
	;mov		ah, 02h
	;mov		dl, newpoints[bx]
	;int		21H
	;mov		ah, 02h
	;mov		dl, matriz[si][bx]
	;int		21H
	;###
 	cmp 	al,matriz[si][bx] 	;compara 000[0]
 	ja 		troca
 	cmp 	al,matriz[si][bx]
 	jl 		continua
	
continua:
 	dec		si
	dec		si
	dec		si
	dec		si
 	cmp 	si,-4								
	jne		aqui


sai:


	;mov cx,20
	;xor si,si
;print:
	;mov ah,02h
	;mov dl,matriz[si][0]
	;int 21h
		
	;inc si

	;loop print


		mov		ah, 3ch				; Abrir o ficheiro para escrita
		mov		cx, 00H				; Define o tipo de ficheiro ??
		lea		dx, fnewtop			; DX aponta para o nome do ficheiro 
		int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
		mov 	HandleFich,ax
		jnc		comeca_save			; Se não existir erro escreve no ficheiro
	
		jmp		fim
	
	
	
comeca_save:

		mov 	si,0
novalinha:
			;escreve o 1 caracter da 1 caluna
		mov 	bx,0
		mov 	al,matriz[si][bx]
		mov 	Car,al 				
		escreve_car	
			;escreve o 2 caracter da 1 caluna
		mov 	bx,1
		mov 	al,matriz[si][bx]
		mov 	Car,al 				
		escreve_car	
			;escreve o 1 caracter da 2 caluna
		mov 	bx,2
		mov 	al,matriz[si][bx]
		mov 	Car,al 				
		escreve_car
			;escreve o 2 caracter da 2 caluna
		mov 	bx,3
		mov 	al,matriz[si][bx]
		mov 	Car,al 				
		escreve_car


		add si, 4
		cmp si,20
		jne novalinha
			;fecha_ficheiro
		mov bx,HandleFich	        	
		mov	ah,3eh			; indica que vamos fechar
		int	21h				; fecha mesmo
		jnc	fundo				; se não acontecer erro termina
	

		mov	ah, 09h
		lea	dx, Erro_Close
		int	21h
		
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;POE NOVO RESUL NO FICHEIRO







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ACABA DE POR O FUNDO

fundo:
		
		
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h	; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor, ah	; Guarda a cor que está na posição do Cursor	
		
		inc			POSx
		goto_xy		POSx,POSy	; Vai para nova possição2
		mov 		ah, 08h		; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car2, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor2, ah	; Guarda a cor que está na posição do Cursor	
		dec			POSx
	

CICLO:		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
		
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
IMPRIME:	mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 		POSya, al

jmp LER_SETA
		
		
		
CICLO1:		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		 
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
IMPRIME1:	mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 		POSya, al
		
		
		
;#######MENU		
		cmp  	POSy,24
		jne  	ClicouEnter
		
		cmp		POSx,64
		je  	ini
		
		cmp		POSx,65
		je  	ini
		
		
		cmp		POSx,66
		je  	ini
		
		
		cmp		POSx,67
		je  	ini
		
	
;#######SAIR		
		
		cmp		POSx,70
		je  	fim; SAIR
		
		cmp		POSx,71
		je  	fim; SAIR
		
		cmp		POSx,72
		je  	fim; SAIR
		
		cmp		POSx,73
		je  	fim; SAIR
		
		
;#######ENTER		
ClicouEnter:
		cmp  	POSy,16
		jne  	LER_SETA
		
		cmp		POSx,38
		je  	ini
		
		cmp		POSx,39
		je  	ini
		
		
		cmp		POSx,40
		je  	ini
		
		
		cmp		POSx,41
		je  	ini
		
		cmp		POSx,42
		je  	ini
		
		
	jmp LER_SETA	
		

		
		
LER_SETA:	
		call 	LE_TECLA
		cmp		ah, 1
		je		ESTEND
		CMP 	AL, 27	; ESCAPE
		JE		FIM
		cmp 	al,0Dh
		je		CICLO1
		jmp		LER_SETA
		
ESTEND:		
		cmp 	al,48h
		jne		BAIXO
		dec		POSy		;cima
		cmp 	POSy,12
		jne 	CICLO
		cmp     POSx,32
		je		NRS
		jmp		CICLO

BAIXO:		
		cmp		al,50h
		jne		ESQUERDA
		inc 	POSy		;Baixo
		cmp 	POSy,12
		jne 	CICLO
		cmp     POSx,32
		je		NRS
		jmp		CICLO

ESQUERDA:
		cmp		al,4Bh
		jne		DIREITA
		dec		POSx		;Esquerda
		dec		POSx		;Esquerda
		cmp 	POSy,12
		jne 	CICLO
		cmp     POSx,32
		je		NRS
		jmp		CICLO

DIREITA:
		cmp		al,4Dh
		jne		LER_SETA
		inc		POSx		;Direita
		inc		POSx		;Direita
		cmp 	POSy,12
		jne 	CICLO
		cmp     POSx,32
		je		NRS
		jmp		CICLO
		
		
NRS:

	goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	
		inc		POSxa
		
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 	POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 	ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
		
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		
		
		mov dl,0
		xor si,si
		xor di,di
		mov ah, 0Ah 				;SERVICE TO CAPTURE STRING FROM KEYBOARD.
		mov dx, offset buffer_a		;equivalente a lea
		int 21h
		
		
		;CHANGE CHR(11) BY '$'.
		mov si, offset buffer_a + 1 	;NUMBER OF CHARACTERS ENTERED....... equivalente a lea 
		mov cl, [ si ] 				;MOVE LENGTH TO CL.
		mov ch, 0 					;CLEAR CH TO USE CX.
		inc cx 						;TO REACH CHR(11).
		add si, cx 					;NOW SI POINTS TO CHR(11).
		mov al, '$'
		mov [ si ], al 				;REPLACE CHR(11) BY '$'.
		
		inc POSy
		jmp CICLO



end_screen ENDP


;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;le tecla jogo
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################


LE_TECLA_JOGO	PROC
		call trata_horas
		mov		ah,08h
		int		21h
		mov		ah,0
		cmp		al,0
		jne		SAI_TECLA_JOGO
		mov		ah, 08h
		int		21h
		mov		ah,1
SAI_TECLA_JOGO:	RET
LE_TECLA_JOGO	endp

;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;DELAY
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################

delay proc
	pushf
	push	ax
	push	cx
	push	dx
	push	si
	
	mov	ah,2Ch
	int	21h
	mov	al,100
	mul	dh
	xor	dh,dh
	add	ax,dx
	mov	si,ax


ciclo:	mov	ah,2Ch
	int	21h
	mov	al,100
	mul	dh
	xor	dh,dh
	add	ax,dx

	cmp	ax,si 
	jnb	naoajusta
	add	ax,6000 ; 60 segundos
naoajusta:
	sub	ax,si
	cmp	ax,di
	jb	ciclo

	pop	si
	pop	dx
	pop	cx
	pop	ax
	popf
	ret
delay endp


;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;------------------------------------------------------
;CalcAleat - calcula um numero aleatorio de 16 bits
;Parametros passados pela pilha
;entrada:
;não tem parametros de entrada
;saida:
;param1 - 16 bits - numero aleatorio calculado
;notas adicionais:
; deve estar definida uma variavel => ultimo_num_aleat dw 0
; assume-se que DS esta a apontar para o segmento onde esta armazenada ultimo_num_aleat
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################

CalcAleat proc near

	sub	sp,2		; 
	push	bp
	mov	bp,sp
	push	ax
	push	cx
	push	dx	
	mov	ax,[bp+4]
	mov	[bp+2],ax

	mov	ah,00h
	int	1ah

	add	dx,ultimo_num_aleat	; vai buscar o aleatório anterior
	add	cx,dx	
	mov	ax,65521
	push	dx
	mul	cx			
	pop	dx			 
	xchg	dl,dh
	add	dx,32749
	add	dx,ax

	mov	ultimo_num_aleat,dx	; guarda o novo numero aleatório  

	mov	[BP+4],dx		; o aleatório é passado por pilha

	pop	dx
	pop	cx
	pop	ax
	pop	bp
	ret
CalcAleat endp

;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;------------------------------------------------------
;impnum - imprime um numero de 16 bits na posicao x,y
;Parametros passados pela pilha
;entrada:
;param1 -  8 bits - posicao x
;param2 -  8 bits - posicao y
;param3 - 16 bits - numero a imprimir
;saida:
;não tem parametros de saída
;notas adicionais:
; deve estar definida uma variavel => str_num db 5 dup(?),'$'
; assume-se que DS esta a apontar para o segmento onde esta armazenada str_num
; sao eliminados da pilha os parametros de entrada
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################

impnum proc near
	push	bp
	mov	bp,sp
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	mov	ax,[bp+4] ;param3
	lea	di,[str_num+5]
	mov	cx,5
prox_dig:
	xor	dx,dx
	mov	bx,10
	div	bx
	add	dl,'0' ; dh e' sempre 0
	dec	di
	mov	[di],dl
	loop	prox_dig

	mov	ah,02h
	mov	bh,00h
	mov	dl,[bp+7] ;param1
	mov	dh,[bp+6] ;param2
	int	10h
	mov	dx,di
	mov	ah,09h
	int	21h
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	bp
	ret	4 ;limpa parametros (4 bytes) colocados na pilha
impnum endp

;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;TAB CONFIGURADO
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################
;########################################################################





Imp_Fich_Config	PROC
		mov   ax,0b800h ;segmento mem video (imaginar como um array unidimensional: B800:0000h [][][][][][][][][][][][][]... (ao fim de 160 muda-se de linha)
		mov   es,ax		;segmento mem video nao se pode meter um valor direto no es

		;offset mem video (linha,coluna)
		
		
		mov al,linha4	;linha 						(incrementar a cada loop)
		mov bl,160		;160 = nr de bytes de cada linha, visto q cada linha tem 80 quadrados de 2 bytes
		mul bl			;multiplicar linhas p bytes (10*160)
		mov di,ax
		
		
		mov al,col4		;coluna 						
		mov bl,2		;2 = nr de bytes de cada quadrado
		mul bl			;multiplicar colunas p bytes (30*2)
		add di,ax

;abre ficheiro

        mov     ah,3dh			; vamos abrir ficheiro para leitura 
        mov     al,0			; tipo de ficheiro	
        lea     dx,fname			; nome do ficheiro
        int     21h				; abre para leitura 
        jc      erro_abrir		; pode aconter erro a abrir o ficheiro 
        mov     HandleFich,ax	; ax devolve o Handle para o ficheiro 
        jmp     ler_ciclo		; depois de aberto vamos ler o ficheiro 

erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai

ler_ciclo:

		mov cx,6
ciclo2:
		push cx
		mov cx,9
ciclo1:
		push cx
		
        mov     ah,3fh			; indica que vai ser lido um ficheiro 
        mov     bx,HandleFich	; bx deve conter o Handle do ficheiro previamente aberto 
        mov     cx,1			; numero de bytes a ler 
        lea     dx,car_fich		; vai ler para o local de memoria apontado por dx (car_fich)
        int     21h				; faz efectivamente a leitura
		jc	    erro_ler		; se carry é porque aconteceu um erro
		cmp	    ax,0			;EOF?	verifica se já estamos no fim do ficheiro 
		je	    fecha_ficheiro	; se EOF fecha o ficheiro
		
		mov al,' '
		mov	es:[di],al
		mov al,car_fich
		shl ax,1
		shl ax,1
		shl ax,1
		shl ax,1
		mov	es:[di+1],al
		inc di
		inc di
		mov al,' '
		mov	es:[di],al
		mov al,car_fich
		shl ax,1
		shl ax,1
		shl ax,1
		shl ax,1
		mov	es:[di+1],al
		inc di
		inc di
		
		pop cx
		loop ciclo1
		
		pop cx
		add di, 124  	;(160 - 9 * 2) incremento de linha
		loop ciclo2
		jmp fecha_ficheiro
		
erro_ler:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro:					; vamos fechar o ficheiro 
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     sai

        mov     ah,09h			; o ficheiro pode não fechar correctamente
        lea     dx,Erro_Close
        Int     21h
sai:	  RET
Imp_Fich_Config	endp


;########        ########  ############  ####  #######       ####
;#########      #########  ############  ####  ########      ####
;#### #####    ##### ####  ####    ####        #### ####     ####
;####  #####  #####  ####  ####    ####        ####  ####    ####
;####   ##########   ####  ############  ####  ####   ####   ####
;####    ########    ####  ####    ####  ####  ####    ####  ####
;####                ####  ####    ####  ####  ####     #### ####
;####                ####  ####    ####  ####  ####      ########
;####                ####  ####    ####  ####  ####       #######
;####                ####  ####    ####  ####  ####        ######


ini:

Main  proc
		mov		ax, dseg
		mov		ds,ax
		mov		ax,0B800h
		mov		es,ax
		
		mov		ah, '0'
		mov		ospontos[0],ah
		mov		ospontos[1],ah
		mov		ospontos[2],ah
		mov		ospontos[3],ah
		
		call menu
	
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h	; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor, ah	; Guarda a cor que está na posição do Cursor	
		
		inc			POSx
		goto_xy		POSx,POSy	; Vai para nova possição2
		mov 		ah, 08h		; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car2, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor2, ah	; Guarda a cor que está na posição do Cursor	
		dec			POSx
	


CICLO:		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
		
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
IMPRIME:	
		mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 		POSya, al

jmp LER_SETA
		
		
		
CICLO1:		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		 
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
IMPRIME1:	
		mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		

		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 	POSya, al
		
		
		
;Opçoes menu		
		cmp  	POSx,30
		jne  	LER_SETA
		
		
		cmp		POSy,15 	;jogar
		je  	op_jogar; SAIR
		
		cmp		POSy,17		;ver pontuaçao
		je  	ver_pontuacao; SAIR
		
		
		cmp		POSy,19		;configurar grelha
		je  	config_grelha; SAIR
		
		
		cmp		POSy,21		;sair
		je  	fim; SAIR
		
	
		jmp  	LER_SETA
		
	
op_jogar:
		call	opcoes_jogar
		jmp 	LER_SETA
		
ver_pontuacao:
		call	ver_pontuacoes
		jmp 	LER_SETA
	
config_grelha:
		call	configurar_grelha
		jmp 	LER_SETA

;APAGAR:
;		xor		bx,bx
;		mov		cx,25*80
;		
;apaga:			mov	byte ptr es:[bx],' '
;		mov		byte ptr es:[bx+1],7
;		inc		bx
;		inc 	bx
;		loop	apaga
;		ret		
		
		
		
LER_SETA:	
		call 	LE_TECLA
		cmp		ah, 1
		je		ESTEND
		CMP 	AL, 27	; ESCAPE
		JE		FIM
		cmp 	al,0Dh
		je		CICLO1
		jmp		LER_SETA
		
ESTEND:		
		cmp 		al,48h
		jne		BAIXO
		dec		POSy		;cima
		jmp		CICLO

BAIXO:		
		cmp		al,50h
		jne		ESQUERDA
		inc 	POSy		;Baixo
		jmp		CICLO

ESQUERDA:
		cmp		al,4Bh
		jne		DIREITA
		dec		POSx		;Esquerda
		dec		POSx		;Esquerda

		jmp		CICLO

DIREITA:
		cmp		al,4Dh
		jne		LER_SETA
		inc		POSx		;Direita
		inc		POSx		;Direita
		
		jmp		CICLO
		

Main	endp








;;;;;;;;;;;;;;;;;;;;;;IMPRIME MENU

menu PROC NEAR
mov   ax,0b800h
	mov   es,ax

	mov	al,050h
	mov	ah,' ' 
	mov	bx,0
	mov	cx,25*80

CIC:    
	mov	es:[bx],ah
	mov	es:[bx+1],al
	inc	bx
	inc	bx
	loop	CIC

	
	;TOYBLAST
	
	;LETRA T
	
	mov	al,0DBh             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,1350           ; BX = linha*160 + coluna*2=2*160+35*2=2140 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,0D2h             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,1352             ; BX = linha*160 + coluna*2=8*160+36*2=2154-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA Y
	
	mov	al,0DEh             ; AL - static ou não / background color / cor do texto
	mov	ah,'Y'             ; AH - Caracter
	mov	bx,1354             ; BX = linha*160 + coluna*2=8*160+37*2=2156 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;ESPAÇO
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1356           ; BX = linha*160 + coluna*2=8*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	;LETRA B
	
	mov	al,0D6h             ; AL - static ou não / background color / cor do texto
	mov	ah,'B'             ; AH - Caracter
	mov	bx,1358           ; BX = linha*160 + coluna*2=8*160+39*2=2160 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA L
	
	mov	al,0D4h             ; AL - static ou não / background color / cor do texto
	mov	ah,'L'             ; AH - Caracter
	mov	bx,1360           ; BX = linha*160 + coluna*2=8*160+40*2=2162 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,0D7h             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,1362           ; BX = linha*160 + coluna*2=8*160+41*2=2164 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA S
	
	mov	al,0D1h             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,1364           ; BX = linha*160 + coluna*2=8*160+42*2=2166 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0DBh             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,1366           ; BX = linha*160 + coluna*2=8*160+43*2=2168 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;MENU
	
	
;################* JOGAR
	
	;LETRA *
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'_'             ; AH - Caracter
	mov	bx,2460           ; BX = linha*160 + coluna*2=15*160+30*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;ESPAÇO
	mov	al,05Bh              ; AL - static ou não / background color / cor do texto
	mov	ah,'_'             ; AH - Caracter
	mov	bx,2462           ; BX = linha*160 + coluna*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA J
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'J'             ; AH - Caracter
	mov	bx,2464           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA O
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,2466          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA G
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'G'             ; AH - Caracter
	mov	bx,2468           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,2470           ; BX = linha*160 + coluna*2=> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA R
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,2472          ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
;################* VER PONTUACAO
	
	;LETRA *
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'_'             ; AH - Caracter
	mov	bx,2780           ; BX = linha*160 + coluna*2=17*160+30*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;ESPAÇO
	mov	al,05Bh              ; AL - static ou não / background color / cor do texto
	mov	ah,'_'             ; AH - Caracter
	mov	bx,2782          ; BX = linha*160 + coluna*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA V
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'V'             ; AH - Caracter
	mov	bx,2784           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA E
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,2786          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA R
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,2788           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;ESPAÇO
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,2790           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA P
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'P'             ; AH - Caracter
	mov	bx,2792          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,2794          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA N
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'N'             ; AH - Caracter
	mov	bx,2796          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,2798          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA U
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'U'             ; AH - Caracter
	mov	bx,2800          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,2802          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA Ç
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'C'             ; AH - Caracter
	mov	bx,2804          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,2806          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,2808          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
;################CONFIGURAR GRELHA
	
	;LETRA *
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'_'             ; AH - Caracter
	mov	bx,3100          ; BX = linha*160 + coluna*2=19*160+30*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;ESPAÇO
	mov	al,05Bh              ; AL - static ou não / background color / cor do texto
	mov	ah,'_'             ; AH - Caracter
	mov	bx,3102           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA C
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'C'             ; AH - Caracter
	mov	bx,3104          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,3106          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA N
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'N'             ; AH - Caracter
	mov	bx,3108
						; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA F
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'F'             ; AH - Caracter
	mov	bx,3110          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA I
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'I'             ; AH - Caracter
	mov	bx,3112         ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA G
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'G'             ; AH - Caracter
	mov	bx,3114          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA U
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'U'             ; AH - Caracter
	mov	bx,3116          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA R
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,3118          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,3120          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA R
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,3122          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;ESPAÇO
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,3124           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA G
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'G'             ; AH - Caracter
	mov	bx,3126          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA R
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,3128          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA E
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,3130          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA L
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'L'             ; AH - Caracter
	mov	bx,3132          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA H
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'H'             ; AH - Caracter
	mov	bx,3134          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,3136          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
;################* SAIR
	
	;LETRA *
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'_'             ; AH - Caracter
	mov	bx,3420          ; BX = linha*160 + coluna*2=21*160+30*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;ESPAÇO
	mov	al,05Bh              ; AL - static ou não / background color / cor do texto
	mov	ah,'_'             ; AH - Caracter
	mov	bx,3422          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA S
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,3424          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,3426          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA I
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'I'             ; AH - Caracter
	mov	bx,3428
						; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA R
	
	mov	al,5Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,3430        ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	RET
menu ENDP

;###################################################
;###################################################
;###################################################
;###################################################
;###################################################
;OPCOES JOGAR
;###################################################
;###################################################
;###################################################
;###################################################


opcoes_jogar PROC NEAR

		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
	
		PUSHF
		
		
	mov	al,040h
	mov	ah,' ' 
	mov	bx,0
	mov	cx,25*80

CIC:    
	mov	es:[bx],ah
	mov	es:[bx+1],al
	inc	bx
	inc	bx
	loop	CIC

;TOYBLAST
	;LETRA -
	
	mov	al,0CFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'-'             ; AH - Caracter
	mov	bx,386           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA |
	
	mov	al,0CFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'|'             ; AH - Caracter
	mov	bx,388           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0C3h             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,390           ; BX = linha*160 + coluna*2=2*160+35*2=390 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,0C2h             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,392             ; BX = linha*160 + coluna*2=2*160+36*2=2154-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA Y
	
	mov	al,0CEh             ; AL - static ou não / background color / cor do texto
	mov	ah,'Y'             ; AH - Caracter
	mov	bx,394             ; BX = linha*160 + coluna*2=8*160+37*2=2156 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;ESPAÇO
	
	mov	al,0C0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,396           ; BX = linha*160 + coluna*2=8*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	;LETRA B
	
	mov	al,0CAh             ; AL - static ou não / background color / cor do texto
	mov	ah,'B'             ; AH - Caracter
	mov	bx,398           ; BX = linha*160 + coluna*2=8*160+39*2=2160 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA L
	
	mov	al,0C3h             ; AL - static ou não / background color / cor do texto
	mov	ah,'L'             ; AH - Caracter
	mov	bx,400           ; BX = linha*160 + coluna*2=8*160+40*2=2162 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,0CEh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,402           ; BX = linha*160 + coluna*2=8*160+41*2=2164 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA S
	
	mov	al,0C1h             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,404           ; BX = linha*160 + coluna*2=8*160+42*2=2166 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0C3h             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,406           ; BX = linha*160 + coluna*2=8*160+43*2=2168 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA |
	
	mov	al,0CFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'|'             ; AH - Caracter
	mov	bx,408           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA -
	
	mov	al,0CFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'-'             ; AH - Caracter
	mov	bx,410           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
;#####SAIR	
	;LETRA S
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,3980       ; BX = linha*160 + coluna*2=24*160+70*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,3982           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA I
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'I'             ; AH - Caracter
	mov	bx,3984          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA R
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,3986          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	
	
;#######MENU
	
	;LETRA M
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'M'             ; AH - Caracter
	mov	bx,3968            ; BX = linha*160 + coluna*2=24*160+64*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA E
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,3970           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA N
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'N'             ; AH - Caracter
	mov	bx,3972          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA U
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'U'             ; AH - Caracter
	mov	bx,3974          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	

;MODO ALEATORIO


	;LETRA _
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'_'             ; AH - Caracter
	mov	bx,2140          ; BX = linha*160 + coluna*2=13*160+30*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA _
	mov	al,04Bh              ; AL - static ou não / background color / cor do texto
	mov	ah,'_'             ; AH - Caracter
	mov	bx,2142          ; BX = linha*160 + coluna*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA M
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'M'             ; AH - Caracter
	mov	bx,2144           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA O
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,2146          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA D
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'D'             ; AH - Caracter
	mov	bx,2148           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	mov	al,04Bh              ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,2150           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;ESPAÇO
	mov	al,40h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,2152          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA A
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,2154         ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA L
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'L'             ; AH - Caracter
	mov	bx,2156         ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA E
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,2158         ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,2160         ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,2162        ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA O
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,2164          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA R
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,2166          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA I
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'I'             ; AH - Caracter
	mov	bx,2168         ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,2170         ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	

;MODO CONFIGURADO


	;LETRA _
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'_'             ; AH - Caracter
	mov	bx,2460           ; BX = linha*160 + coluna*2=15*160+30*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA _
	mov	al,04Bh              ; AL - static ou não / background color / cor do texto
	mov	ah,'_'             ; AH - Caracter
	mov	bx,2462          ; BX = linha*160 + coluna*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA M
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'M'             ; AH - Caracter
	mov	bx,2464           ; BX = linha*160 + coluna*2=-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA O
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,2466          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA D
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'D'             ; AH - Caracter
	mov	bx,2468           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	mov	al,04Bh              ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,2470           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;ESPAÇO
	mov	al,40h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,2472         ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA C
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'C'             ; AH - Caracter
	mov	bx,2474          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,2476          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA N
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'N'             ; AH - Caracter
	mov	bx,2478
						; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA F
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'F'             ; AH - Caracter
	mov	bx,2480          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA I
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'I'             ; AH - Caracter
	mov	bx,2482         ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA G
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'G'             ; AH - Caracter
	mov	bx,2484          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA U
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'U'             ; AH - Caracter
	mov	bx,2486          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA R
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,2488          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,2490          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	;LETRA D
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'D'             ; AH - Caracter
	mov	bx,2492          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,4Bh             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,2494          ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	
	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	
	goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h	; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor, ah	; Guarda a cor que está na posição do Cursor	
		
		inc			POSx
		goto_xy		POSx,POSy	; Vai para nova possição2
		mov 		ah, 08h		; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car2, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor2, ah	; Guarda a cor que está na posição do Cursor	
		dec			POSx
	

CICLO_C1:		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
		
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
IMPRIME_C:	mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 		POSya, al

jmp LER_SETA_C
		
		
		
CICLO_C2:		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		 
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
IMPRIME_C2:	mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 	POSya, al

;#########MODO ALEATORIO
modo_al:
		cmp POSx, 30
		jne  MENU_C
		
		cmp POSy, 13
		jne modo_conf
		call modo_aleatorio
		jmp MENU_C
;#########MODO CONFIGURADO
modo_conf:
		cmp POSy, 15
		jne MENU_C		
		call modo_configurado

		
;#######MENU		
MENU_C:
		cmp  	POSy,24
		jne  	LER_SETA_C
		
		cmp		POSx,64
		je  	ini
		
		cmp		POSx,65
		je  	ini
		
		
		cmp		POSx,66
		je  	ini
		
		
		cmp		POSx,67
		je  	ini
		
	
;#######SAIR		
		
		cmp		POSx,70
		je  	fim; SAIR
		
		cmp		POSx,71
		je  	fim; SAIR
		
		cmp		POSx,72
		je  	fim; SAIR
		
		cmp		POSx,73
		je  	fim; SAIR
		
DOOR_C:
		POPF
		POP DX
		POP CX
		POP BX
		POP AX
		ret
		
		
LER_SETA_C:	
		call 	LE_TECLA
		cmp		ah, 1
		je		ESTEND_C
		CMP 	AL, 27	; ESCAPE
		JE		FIM
		cmp 	al,0Dh
		je		CICLO_C2
		jmp		LER_SETA_C
		
ESTEND_C:		cmp 		al,48h
		jne		BAIXO_C
		dec		POSy		;cima
		jmp		CICLO_C1

BAIXO_C:		cmp		al,50h
		jne		ESQUERDA_C
		inc 	POSy		;Baixo
		jmp		CICLO_C1

ESQUERDA_C:
		cmp		al,4Bh
		jne		DIREITA_C
		dec		POSx		;Esquerda
		dec		POSx		;Esquerda
		jmp		CICLO_C1

DIREITA_C:
		cmp		al,4Dh
		jne		LER_SETA_C
		inc		POSx		;Direita
		inc		POSx		;Direita
		jmp		CICLO_C1
	
	
	

opcoes_jogar ENDP



;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;LETRAS
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################

letras PROC NEAR
INICIO:
	mov   ax,0b800h
	mov   es,ax

	mov	al,030h
	mov	ah,' ' 
	mov	bx,0
	mov	cx,25*80

CIC:    
	mov	es:[bx],ah
	mov	es:[bx+1],al
	inc	bx
	inc	bx
	loop	CIC
	
;TOYBLAST
	;LETRA -
	
	mov	al,0BFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'-'             ; AH - Caracter
	mov	bx,386           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA |
	
	mov	al,0BFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'|'             ; AH - Caracter
	mov	bx,388           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0B4h             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,390           ; BX = linha*160 + coluna*2=2*160+35*2=390 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,0B5h             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,392             ; BX = linha*160 + coluna*2=2*160+36*2=2154-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA Y
	
	mov	al,0BEh             ; AL - static ou não / background color / cor do texto
	mov	ah,'Y'             ; AH - Caracter
	mov	bx,394             ; BX = linha*160 + coluna*2=8*160+37*2=2156 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;ESPAÇO
	
	mov	al,0B0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,396           ; BX = linha*160 + coluna*2=8*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	;LETRA B
	
	mov	al,0B6h             ; AL - static ou não / background color / cor do texto
	mov	ah,'B'             ; AH - Caracter
	mov	bx,398           ; BX = linha*160 + coluna*2=8*160+39*2=2160 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA L
	
	mov	al,0B4h             ; AL - static ou não / background color / cor do texto
	mov	ah,'L'             ; AH - Caracter
	mov	bx,400           ; BX = linha*160 + coluna*2=8*160+40*2=2162 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,0B8h             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,402           ; BX = linha*160 + coluna*2=8*160+41*2=2164 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA S
	
	mov	al,0B1h             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,404           ; BX = linha*160 + coluna*2=8*160+42*2=2166 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0B5h             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,406           ; BX = linha*160 + coluna*2=8*160+43*2=2168 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA |
	
	mov	al,0BFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'|'             ; AH - Caracter
	mov	bx,408           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA -
	
	mov	al,0BFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'-'             ; AH - Caracter
	mov	bx,410           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
;#####SAIR	
	;LETRA S
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,3980       ; BX = linha*160 + coluna*2=24*160+70*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,3982           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA I
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'I'             ; AH - Caracter
	mov	bx,3984          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA R
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,3986          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	
	
;#######MENU
	
	;LETRA M
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'M'             ; AH - Caracter
	mov	bx,3968            ; BX = linha*160 + coluna*2=24*160+64*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA E
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,3970           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA N
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'N'             ; AH - Caracter
	mov	bx,3972          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA U
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'U'             ; AH - Caracter
	mov	bx,3974          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
letras ENDP
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;TABULEIRO
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
		
tabuleiro proc near
	mov	cx,10		; Faz o ciclo 10 vezes
ciclo4:
		call	CalcAleat
		pop	ax 		; vai buscar 'a pilha o número aleatório

		mov	dl,cl	
		mov	dh,70
		push	dx		; Passagem de parâmetros a impnum (posição do ecran)
		push	ax		; Passagem de parâmetros a impnum (número a imprimir)
		call	impnum		; imprime 10 aleatórios na parte direita do ecran
		loop	ciclo4		; Ciclo de impressão dos números aleatórios
		
		mov   	ax, 0b800h	; Segmento de memória de vídeo onde vai ser desenhado o tabuleiro
		mov   	es, ax	
		mov	linha, 	8	; O Tabuleiro vai começar a ser desenhado na linha 8 
		mov	nlinhas, 6	; O Tabuleiro vai ter 6 linhas
		
ciclo2:		mov	al, 160		
		mov	ah, linha
		mul	ah
		add	ax, 60
		mov 	bx, ax		; Determina Endereço onde começa a "linha". bx = 160*linha + 60

		mov	cx, 9		; São 9 colunas 
ciclo:  	
		mov 	dh,	cara	; vai imprimir o caracter "SPACE"
		mov	es:[bx],dh	;
		xor 	si,si
novacor:	
		call	CalcAleat	; Calcula próximo aleatório que é colocado na pinha 
		pop	ax ; 		; Vai buscar 'a pilha o número aleatório
		and 	al,70h	; posição do ecran com cor de fundo aleatório e caracter a preto
		cmp	al, 30h		; Se o fundo de ecran é preto
		je	novacor		; vai buscar outra cor 

		mov 	dh,	   cara		; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh		
		mov	es:[bx+1], al	; Coloca as características de cor da posição atual 
		inc	bx		
		inc	bx		; próxima posição e ecran dois bytes à frente 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh
		mov	es:[bx+1], al
		inc	bx
		inc	bx
		
		mov	di,1 ;delay de 1 centesimo de segundo
		call	delay
		loop	ciclo		; continua até fazer as 9 colunas que correspondem a uma liha completa
		
		inc	linha		; Vai desenhar a próxima linha
		dec	nlinhas		; contador de linhas
		mov	al, nlinhas
		cmp	al, 0		; verifica se já desenhou todas as linhas 
		jne	ciclo2		; se ainda há linhas a desenhar continua 
		ret
tabuleiro ENDP

;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;MODO ALEATORIO
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################
;######################################################################



modo_aleatorio PROC NEAR
		mov		ax, dseg
		mov		ds,ax
		mov		ax,0B800h
		mov		es,ax
		mov 	Segundos,60
		
		
		call letras
		call tabuleiro
;########################################################################################################################################
			
;######TEMPORIZADOR
	;ESPAÇO
	

;FILA1
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,642         ; BX = linha*160 + coluna*2=4*160+4*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,644          ; BX = linha*160 + coluna*2=4*160+2*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,646          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,'M'             ; AH - Caracter
	mov	bx,648          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,'P'             ; AH - Caracter
	mov	bx,650          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,652          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,654          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                      ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,656          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
;FILA2	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,802         ; BX = linha*160 + coluna*2=5*160+1*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,804         ; BX = linha*160 + coluna*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h            ; AL - static ou não / background color / cor do texto
	mov	ah,' '               ; AH - Caracter
	mov	bx,806          ; BX = linha*160 + coluna*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,808	; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h          ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,810          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,812          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '               ; AH - Caracter
	mov	bx,814          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,0D0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,816         ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al


;###PONTUACAO

;FILA3	

	mov	al,0D0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,962         ; BX = linha*160 + coluna*2=6*160+1*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,964         ; BX = linha*160 + coluna*2=6*160+2*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h            ; AL - static ou não / background color / cor do texto
	mov	ah,' '               ; AH - Caracter
	mov	bx,966          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx, 968	; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h          ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,970          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,972          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '               ; AH - Caracter
	mov	bx,974          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,0D0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,976         ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al



;FILA4
;PONTOS	
	
	mov	al,0D0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1122         ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,'P'             ; AH - Caracter
	mov	bx,1124         ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h            ; AL - static ou não / background color / cor do texto
	mov	ah,'O'               ; AH - Caracter
	mov	bx,1126          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,'N'              ; AH - Caracter
	mov	bx,1128	; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h          ; AL - static ou não / background color / cor do texto
	mov	ah,'T'              ; AH - Caracter
	mov	bx,1130          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'              ; AH - Caracter
	mov	bx,1132          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'               ; AH - Caracter
	mov	bx,1134          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1136         ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	
;FILA5
	mov	al,0D0h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1282        ; BX = linha*160 + coluna*2=6*160+1*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	mov	al,0D0h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1284        ; BX = linha*160 + coluna*2=6*160+2*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h            ; AL - static ou não / background color / cor do texto
	mov	ah,' '               ; AH - Caracter
	mov	bx,1286          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,1288	; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h          ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,1290          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,1292          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '               ; AH - Caracter
	mov	bx,1294          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,0D0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1296         ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
		
		
;#########################################################################################################################################	
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h	; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor, ah	; Guarda a cor que está na posição do Cursor	
		
		inc			POSx
		goto_xy		POSx,POSy	; Vai para nova possição2
		mov 		ah, 08h		; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car2, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor2, ah	; Guarda a cor que está na posição do Cursor	
		dec			POSx
	

CICLO:		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
		
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
IMPRIME:	
		mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 	POSya, al

jmp LER_SETA
		
		
		
CICLO1:		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		 
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
IMPRIME1:	mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 		POSya, al
		
		
		
;#######MENU		
		cmp  	POSy,24
		jne  	linhatab1
		
		cmp		POSx,64
		je  	ini; SAIR
		
		cmp		POSx,65
		je  	ini; SAIR
		
		
		cmp		POSx,66
		je  	ini; SAIR
		
		
		cmp		POSx,67
		je  	ini; SAIR
		
	
;#######SAIR		
		
		cmp		POSx,70
		je  	fim; SAIR
		
		cmp		POSx,71
		je  	fim; SAIR
		
		cmp		POSx,72
		je  	fim; SAIR
		
		cmp		POSx,73
		je  	fim; SAIR
		
;########TABULEIRO EXPLOSAO
linhatab1: 
		cmp 	POSy,8
		je     colunatab
		
linhatab2:
		cmp 	POSy,9
		je     colunatab
linhatab3:
		cmp 	POSy,10
		je      colunatab
linhatab4:
		cmp 	POSy,11
		je      colunatab
linhatab5:
		cmp 	POSy,12
		je 		colunatab
linhatab6:
		cmp 	POSy,13		
		je      colunatab
		jne 	LER_SETA
		
colunatab:
		cmp 	POSx,30
		je 		EXPLOSAO
		cmp 	POSx,32
		je 		EXPLOSAO
		cmp 	POSx,34
		je 		EXPLOSAO
		cmp 	POSx,36
		je 		EXPLOSAO
		cmp 	POSx,38
		je 		EXPLOSAO
		cmp 	POSx,40
		je 		EXPLOSAO
		cmp 	POSx,42
		je 		EXPLOSAO
		cmp 	POSx,44
		je 		EXPLOSAO
		cmp 	POSx,46
		je 		EXPLOSAO
		cmp 	POSx,48
		je 		EXPLOSAO

		jne  	LER_SETA
		
EXPLOSAO:
		call novo_tabuleiro_necessario
		xor 	ax,ax	; ax=0
		xor 	bx,bx	; bx=0
		xor		cx,cx 	; cx=0
		xor		si,si 	; si=0
		xor     dx,dx	; dx=0
		
		
		mov al,posx
		mov bl,2
		mul bl
	
		mov bx,ax
		xor ax,ax
	
		mov al,posy
		mov dl,160
		mul dl
	
		add	bx,ax ;POSICAO QUADRADO EXPLUSIVO
		
			
		xor 	ax,ax	; ax=0
		xor		cx,cx 	; cx=0
		xor		si,si 	; si=0
		xor     dx,dx	; dx=0
		
caso_quadrado_1:
		mov 	al,es:[bx]
		mov		ah,es:[bx+1]
		sub     bx,160
		mov		dl,es:[bx]
		mov		dh,es:[bx+1]
		add 	bx,160
		cmp 	ah,dh
		jne     caso_quadrado_2
			
;###CONFIRMAÇÃO QUE A COR DOS QUADRADOS ESTA A SER COMPARADA	
;		mov	al,03Fh             
;		mov	ah,'1'             
;		mov	bx,324           
	                     
;		mov	es:[bx],ah        
;		mov	es:[bx+1],al		
;		jmp fim	
		
	xor ax,ax
	xor cx,cx
	
	sub bx,480
	
	mov al,posy
	mov si,ax

	cmp si,8
	je	correcaotabuleiro1

	mov cx,13 
ciclo_corrige_tab1:  
	xor ax,ax
	xor dx,dx  
	
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+320],ax
	mov es:[bx+322],dx
	
	add bx,160
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+320],ax
	mov es:[bx+322],dx
	
	sub bx,320
	
	dec si
	cmp si,8
	je correcaotabuleiro1
	dec cx
	loop	ciclo_corrige_tab1	
	
	
correcaotabuleiro1:	
			call contador_de_pontos
			xor AX,AX
			xor bx,bx
			mov al,posx
			mov	bl,2
			mul bl
			
			xor bx,bx
			mov bx,ax ; bx=coluna*2
			xor ax,ax
			
			add bx,1440 ; bx=coluna*2+linha*160=posx*2+9*160

		mov cx,1	
novacorcorrecao1:	
		xor ax,ax
		call	CalcAleat	; Calcula próximo aleatório que é colocado na pinha 
		pop	ax ; 		; Vai buscar 'a pilha o número aleatório
		and 	al,70h	; posição do ecran com cor de fundo aleatório e caracter a preto
		cmp	al, 30h		; Se o fundo de ecran é preto
		je	novacorcorrecao1		; vai buscar outra cor 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh		
		mov	es:[bx+1], al	; Coloca as características de cor da posição atual 
		inc	bx		
		inc	bx		; próxima posição e ecran dois bytes à frente 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh
		mov	es:[bx+1], al
		dec	bx		
		dec	bx
		
		sub	bx,160

		cmp cx,0
		je  Ciclo
		dec cx
		jmp novacorcorrecao1	
		
caso_quadrado_2:
		
		mov 	al,es:[bx]
		mov		ah,es:[bx+1]
		add     bx,4
		mov		dl,es:[bx]
		mov		dh,es:[bx+1]
		sub 	bx,4
		cmp 	ah,dh
		jne     caso_quadrado_3
		
;###CONFIRMAÇÃO QUE A COR DOS QUADRADOS ESTA A SER COMPARADA	
;		mov	al,03Fh             
;		mov	ah,'2'             
;		mov	bx,324           
	                     
;		mov	es:[bx],ah        
;		mov	es:[bx+1],al	
		
;		jmp fim
		
	xor ax,ax
	
	sub bx,160
	
	mov al,posy
	mov si,ax

	cmp si,8
	je	correcaotabuleiro2

	mov cx,6
ciclo_corrige_tab2:  
	xor ax,ax
	xor dx,dx  
	
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+160],ax
	mov es:[bx+162],dx
	
	add bx,4
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+160],ax
	mov es:[bx+162],dx
	
	sub bx,4
	sub bx,160
	dec si
	cmp si,8
	je correcaotabuleiro2
	dec cx
	loop	ciclo_corrige_tab2	
		
		
		
		
		
		
correcaotabuleiro2:
			call contador_de_pontos		
			xor AX,AX
			xor bx,bx
			mov al,posx
			mov	bl,2
			mul bl
			
			xor bx,bx
			mov bx,ax ; bx=coluna*2
			xor ax,ax
			
			add bx,1280 ; bx=coluna*2+linha*160=posx*2+8*160

		mov cx,1	

novacorcorrecao2:	
		xor ax,ax
		call	CalcAleat	; Calcula próximo aleatório que é colocado na pinha 
		pop	ax ; 		; Vai buscar 'a pilha o número aleatório
		and 	al,70h	; posição do ecran com cor de fundo aleatório e caracter a preto
		cmp	al, 30h		; Se o fundo de ecran é preto
		je	novacorcorrecao2		; vai buscar outra cor 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh		
		mov	es:[bx+1], al	; Coloca as características de cor da posição atual 
		inc	bx		
		inc	bx		; próxima posição e ecran dois bytes à frente 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh
		mov	es:[bx+1], al
		dec	bx		
		dec	bx
		
		add	bx,4
		
		cmp cx,0
		je  Ciclo
		dec cx
		jmp novacorcorrecao2


caso_quadrado_3:
		mov 	al,es:[bx]
		mov		ah,es:[bx+1]
		add     bx,160
		mov		dl,es:[bx]
		mov		dh,es:[bx+1]
		sub 	bx,160
		cmp 	ah,dh
		jne     caso_quadrado_4
			
;###CONFIRMAÇÃO QUE A COR DOS QUADRADOS ESTA A SER COMPARADA	
;		mov	al,03Fh             
;		mov	ah,'3'             
;		mov	bx,324           
	                     
;		mov	es:[bx],ah        
;		mov	es:[bx+1],al	
;		jmp fim

	xor ax,ax
	xor cx,cx
	
	sub bx,320
	
	mov al,posy
	mov si,ax

	cmp si,8
	je	correcaotabuleiro3

	mov cx,13 ; CX=1 POIS É APENAS UM CUBO
ciclo_corrige_tab3:  
	xor ax,ax
	xor dx,dx  
	
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+320],ax
	mov es:[bx+320],dx
	
	add bx,160
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+320],ax
	mov es:[bx+322],dx
	
	sub bx,160
	sub bx,160
	dec si
	cmp si,8
	je correcaotabuleiro3
	dec cx
	loop	ciclo_corrige_tab3	
		
		
correcaotabuleiro3:		
			call contador_de_pontos
			xor AX,AX
			xor bx,bx
			mov al,posx
			mov	bl,2
			mul bl
			
			xor bx,bx
			mov bx,ax ; bx=coluna*2
			xor ax,ax
			
			add bx,1440 ; bx=coluna*2+linha*160=posx*2+9*160

			mov cx,1	

novacorcorrecao3:	
		xor ax,ax
		call	CalcAleat	; Calcula próximo aleatório que é colocado na pinha 
		pop	ax ; 		; Vai buscar 'a pilha o número aleatório
		and 	al,70h	; posição do ecran com cor de fundo aleatório e caracter a preto
		cmp	al, 30h		; Se o fundo de ecran é preto
		je	novacorcorrecao3		; vai buscar outra cor 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh		
		mov	es:[bx+1], al	; Coloca as características de cor da posição atual 
		inc	bx		
		inc	bx		; próxima posição e ecran dois bytes à frente 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh
		mov	es:[bx+1], al
		dec	bx		
		dec	bx
		
		sub	bx,160

		cmp cx,0
		je  Ciclo
		dec cx
		jmp novacorcorrecao3
		
caso_quadrado_4:
		mov 	al,es:[bx]
		mov		ah,es:[bx+1]
		sub    	bx,4
		mov		dl,es:[bx]
		mov		dh,es:[bx+1]
		add 	bx,4
		cmp 	ah,dh
		jne    	LER_SETA		
		
		
;###CONFIRMAÇÃO QUE A COR DOS QUADRADOS ESTA A SER COMPARADA	
;		mov	al,03Fh             
;		mov	ah,'4'             
;		mov	bx,324           
	                     
;		mov	es:[bx],ah        
;		mov	es:[bx+1],al		
		
;		jmp fim	
		
	xor ax,ax
	
	sub bx,160
	
	mov al,posy
	mov si,ax

	cmp si,8
	je	correcaotabuleiro4

	mov cx,6
ciclo_corrige_tab4:  
	xor ax,ax
	xor dx,dx  
	
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+160],ax
	mov es:[bx+162],dx
	
	sub bx,4
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+160],ax
	mov es:[bx+162],dx
	
	add bx,4
	sub bx,160
	dec si
	cmp si,8
	je correcaotabuleiro4
	dec cx
	loop	ciclo_corrige_tab4	
		
		
			
correcaotabuleiro4:	
			call contador_de_pontos	
			xor AX,AX
			xor bx,bx
			mov al,posx
			mov	bl,2
			mul bl
			
			xor bx,bx
			mov bx,ax ; bx=coluna*2
			xor ax,ax
			
			add bx,1280 ; bx=coluna*2+linha*160=posx*2+8*160

		mov cx,1	

novacorcorrecao4:	
		xor ax,ax
		call	CalcAleat	; Calcula próximo aleatório que é colocado na pinha 
		pop	ax ; 		; Vai buscar 'a pilha o número aleatório
		and 	al,70h	; posição do ecran com cor de fundo aleatório e caracter a preto
		cmp	al, 30h		; Se o fundo de ecran é preto
		je	novacorcorrecao4		; vai buscar outra cor 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh		
		mov	es:[bx+1], al	; Coloca as características de cor da posição atual 
		inc	bx		
		inc	bx		; próxima posição e ecran dois bytes à frente 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh
		mov	es:[bx+1], al
		dec	bx		
		dec	bx
		
		sub	bx,4

		cmp cx,0
		je  Ciclo
		dec cx
		jmp novacorcorrecao4
		
	
		
LER_SETA:	call 		LE_TECLA_JOGO
		cmp		ah, 1
		je		ESTEND
		CMP 		AL, 27	; ESCAPE
		JE		FIM
		cmp 	al,0Dh
		je		CICLO1
		jmp		LER_SETA
		
ESTEND:		cmp 		al,48h
		jne		BAIXO
		dec		POSy		;cima
		jmp		CICLO

BAIXO:		cmp		al,50h
		jne		ESQUERDA
		inc 		POSy		;Baixo
		jmp		CICLO

ESQUERDA:
		cmp		al,4Bh
		jne		DIREITA
		dec		POSx		;Esquerda
		dec		POSx		;Esquerda

		jmp		CICLO

DIREITA:
		cmp		al,4Dh
		jne		LER_SETA
		inc		POSx		;Direita
		inc		POSx		;Direita
		
		jmp		CICLO
		
fim:
		jmp ini

modo_aleatorio ENDP

;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;MODO CONFIGURADO
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################






modo_configurado PROC NEAR


		mov		ax, dseg
		mov		ds,ax
		mov		ax,0B800h
		mov		es,ax
		mov 	Segundos,60


		mov	al,030h
		mov	ah,' ' 
		mov	bx,0
		mov	cx,25*80

	CIC2:    
		mov	es:[bx],ah
		mov	es:[bx+1],al
		inc	bx
		inc	bx
		loop	CIC2
		
		call letras
		call Imp_Fich_Config
		
;####################################################################################

	
;######TEMPORIZADOR
	;ESPAÇO
	

;FILA1
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,642         ; BX = linha*160 + coluna*2=4*160+4*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,644          ; BX = linha*160 + coluna*2=4*160+2*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,646          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,'M'             ; AH - Caracter
	mov	bx,648          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,'P'             ; AH - Caracter
	mov	bx,650          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,652          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,654          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                      ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,656          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
;FILA2	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,802         ; BX = linha*160 + coluna*2=5*160+1*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,804         ; BX = linha*160 + coluna*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h            ; AL - static ou não / background color / cor do texto
	mov	ah,' '               ; AH - Caracter
	mov	bx,806          ; BX = linha*160 + coluna*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,808	; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h          ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,810          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,812          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '               ; AH - Caracter
	mov	bx,814          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,0D0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,816         ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al


;###PONTUACAO

;FILA3	

	mov	al,0D0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,962         ; BX = linha*160 + coluna*2=6*160+1*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,964         ; BX = linha*160 + coluna*2=6*160+2*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h            ; AL - static ou não / background color / cor do texto
	mov	ah,' '               ; AH - Caracter
	mov	bx,966          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx, 968	; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h          ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,970          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,972          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '               ; AH - Caracter
	mov	bx,974          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,0D0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,976         ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al



;FILA4
;PONTOS	
	
	mov	al,0D0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1122         ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,'P'             ; AH - Caracter
	mov	bx,1124         ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h            ; AL - static ou não / background color / cor do texto
	mov	ah,'O'               ; AH - Caracter
	mov	bx,1126          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,'N'              ; AH - Caracter
	mov	bx,1128	; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h          ; AL - static ou não / background color / cor do texto
	mov	ah,'T'              ; AH - Caracter
	mov	bx,1130          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'              ; AH - Caracter
	mov	bx,1132          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'               ; AH - Caracter
	mov	bx,1134          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1136         ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	
;FILA5
	mov	al,0D0h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1282        ; BX = linha*160 + coluna*2=6*160+1*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	mov	al,0D0h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1284        ; BX = linha*160 + coluna*2=6*160+2*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h            ; AL - static ou não / background color / cor do texto
	mov	ah,' '               ; AH - Caracter
	mov	bx,1286          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h              ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,1288	; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h          ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,1290          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '              ; AH - Caracter
	mov	bx,1292          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	mov	al,050h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '               ; AH - Caracter
	mov	bx,1294          ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	mov	al,0D0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,1296         ; BX = linha*160 + coluna*2=*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
;####################################################################################
	
	goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h	; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor, ah	; Guarda a cor que está na posição do Cursor	
		
		inc			POSx
		goto_xy		POSx,POSy	; Vai para nova possição2
		mov 		ah, 08h		; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car2, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor2, ah	; Guarda a cor que está na posição do Cursor	
		dec			POSx
	

CICLO:		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
		
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
IMPRIME:	mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 		POSya, al

jmp LER_SETA
		
		
		
CICLO1:		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		 
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
IMPRIME1:	mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 		POSya, al
		
		
		
;#######MENU		
		cmp  	POSy,24
		jne  	linhatab1
		
		cmp		POSx,64
		je  	ini; SAIR
		
		cmp		POSx,65
		je  	ini; SAIR
		
		
		cmp		POSx,66
		je  	ini; SAIR
		
		
		cmp		POSx,67
		je  	ini; SAIR
		
	
;#######SAIR		
		
		cmp		POSx,70
		je  	fim; SAIR
		
		cmp		POSx,71
		je  	fim; SAIR
		
		cmp		POSx,72
		je  	fim; SAIR
		
		cmp		POSx,73
		je  	fim; SAIR
		
;########TABULEIRO EXPLOSAO
linhatab1: 
		cmp 	POSy,8
		je     colunatab
		
linhatab2:
		cmp 	POSy,9
		je     colunatab
linhatab3:
		cmp 	POSy,10
		je      colunatab
linhatab4:
		cmp 	POSy,11
		je      colunatab
linhatab5:
		cmp 	POSy,12
		je 		colunatab
linhatab6:
		cmp 	POSy,13		
		je      colunatab
		jne 	LER_SETA
		
colunatab:
		cmp 	POSx,30
		je 		EXPLOSAO
		cmp 	POSx,32
		je 		EXPLOSAO
		cmp 	POSx,34
		je 		EXPLOSAO
		cmp 	POSx,36
		je 		EXPLOSAO
		cmp 	POSx,38
		je 		EXPLOSAO
		cmp 	POSx,40
		je 		EXPLOSAO
		cmp 	POSx,42
		je 		EXPLOSAO
		cmp 	POSx,44
		je 		EXPLOSAO
		cmp 	POSx,46
		je 		EXPLOSAO
		cmp 	POSx,48
		je 		EXPLOSAO

		jne  	LER_SETA
		
EXPLOSAO:
		
		call novo_tabuleiro_necessario
		xor 	ax,ax	; ax=0
		xor 	bx,bx	; bx=0
		xor		cx,cx 	; cx=0
		xor		si,si 	; si=0
		xor     dx,dx	; dx=0
		
		
		mov al,posx
		mov bl,2
		mul bl
	
		mov bx,ax
		xor ax,ax
	
		mov al,posy
		mov dl,160
		mul dl
	
		add	bx,ax ;POSICAO QUADRADO EXPLUSIVO
		
			
		xor 	ax,ax	; ax=0
		xor		cx,cx 	; cx=0
		xor		si,si 	; si=0
		xor     dx,dx	; dx=0
		
caso_quadrado_1:
		mov 	al,es:[bx]
		mov		ah,es:[bx+1]
		sub     bx,160
		mov		dl,es:[bx]
		mov		dh,es:[bx+1]
		add 	bx,160
		cmp 	ah,dh
		jne     caso_quadrado_2
			
;###CONFIRMAÇÃO QUE A COR DOS QUADRADOS ESTA A SER COMPARADA	
;		mov	al,03Fh             
;		mov	ah,'1'             
;		mov	bx,324           
	                     
;		mov	es:[bx],ah        
;		mov	es:[bx+1],al		
;		jmp fim	
		
	xor ax,ax
	xor cx,cx
	
	sub bx,480
	
	mov al,posy
	mov si,ax

	cmp si,8
	je	correcaotabuleiro1

	mov cx,13 
ciclo_corrige_tab1:  
	xor ax,ax
	xor dx,dx  
	
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+320],ax
	mov es:[bx+322],dx
	
	add bx,160
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+320],ax
	mov es:[bx+322],dx
	
	sub bx,320
	
	dec si
	cmp si,8
	je correcaotabuleiro1
	dec cx
	loop	ciclo_corrige_tab1	
	
	
correcaotabuleiro1:	
			call contador_de_pontos
			xor AX,AX
			xor bx,bx
			mov al,posx
			mov	bl,2
			mul bl
			
			xor bx,bx
			mov bx,ax ; bx=coluna*2
			xor ax,ax
			
			add bx,1440 ; bx=coluna*2+linha*160=posx*2+9*160

		mov cx,1	
novacorcorrecao1:	
		xor ax,ax
		call	CalcAleat	; Calcula próximo aleatório que é colocado na pinha 
		pop	ax ; 		; Vai buscar 'a pilha o número aleatório
		and 	al,70h	; posição do ecran com cor de fundo aleatório e caracter a preto
		cmp	al, 30h		; Se o fundo de ecran é preto
		je	novacorcorrecao1		; vai buscar outra cor 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh		
		mov	es:[bx+1], al	; Coloca as características de cor da posição atual 
		inc	bx		
		inc	bx		; próxima posição e ecran dois bytes à frente 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh
		mov	es:[bx+1], al
		dec	bx		
		dec	bx
		
		sub	bx,160

		cmp cx,0
		je  Ciclo
		dec cx
		jmp novacorcorrecao1	
		
caso_quadrado_2:
		
		mov 	al,es:[bx]
		mov		ah,es:[bx+1]
		add     bx,4
		mov		dl,es:[bx]
		mov		dh,es:[bx+1]
		sub 	bx,4
		cmp 	ah,dh
		jne     caso_quadrado_3
		
;###CONFIRMAÇÃO QUE A COR DOS QUADRADOS ESTA A SER COMPARADA	
;		mov	al,03Fh             
;		mov	ah,'2'             
;		mov	bx,324           
	                     
;		mov	es:[bx],ah        
;		mov	es:[bx+1],al	
		
;		jmp fim
		
	xor ax,ax
	
	sub bx,160
	
	mov al,posy
	mov si,ax

	cmp si,8
	je	correcaotabuleiro2

	mov cx,6
ciclo_corrige_tab2:  
	xor ax,ax
	xor dx,dx  
	
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+160],ax
	mov es:[bx+162],dx
	
	add bx,4
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+160],ax
	mov es:[bx+162],dx
	
	sub bx,4
	sub bx,160
	dec si
	cmp si,8
	je correcaotabuleiro2
	dec cx
	loop	ciclo_corrige_tab2	
		
		
		
		
		
		
correcaotabuleiro2:
			call contador_de_pontos		
			xor AX,AX
			xor bx,bx
			mov al,posx
			mov	bl,2
			mul bl
			
			xor bx,bx
			mov bx,ax ; bx=coluna*2
			xor ax,ax
			
			add bx,1280 ; bx=coluna*2+linha*160=posx*2+8*160

		mov cx,1	

novacorcorrecao2:	
		xor ax,ax
		call	CalcAleat	; Calcula próximo aleatório que é colocado na pinha 
		pop	ax ; 		; Vai buscar 'a pilha o número aleatório
		and 	al,70h	; posição do ecran com cor de fundo aleatório e caracter a preto
		cmp	al, 30h		; Se o fundo de ecran é preto
		je	novacorcorrecao2		; vai buscar outra cor 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh		
		mov	es:[bx+1], al	; Coloca as características de cor da posição atual 
		inc	bx		
		inc	bx		; próxima posição e ecran dois bytes à frente 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh
		mov	es:[bx+1], al
		dec	bx		
		dec	bx
		
		add	bx,4
		
		cmp cx,0
		je  Ciclo
		dec cx
		jmp novacorcorrecao2


caso_quadrado_3:
		mov 	al,es:[bx]
		mov		ah,es:[bx+1]
		add     bx,160
		mov		dl,es:[bx]
		mov		dh,es:[bx+1]
		sub 	bx,160
		cmp 	ah,dh
		jne     caso_quadrado_4
			
;###CONFIRMAÇÃO QUE A COR DOS QUADRADOS ESTA A SER COMPARADA	
;		mov	al,03Fh             
;		mov	ah,'3'             
;		mov	bx,324           
	                     
;		mov	es:[bx],ah        
;		mov	es:[bx+1],al	
;		jmp fim

	xor ax,ax
	xor cx,cx
	
	sub bx,320
	
	mov al,posy
	mov si,ax

	cmp si,8
	je	correcaotabuleiro3

	mov cx,13 ; CX=1 POIS É APENAS UM CUBO
ciclo_corrige_tab3:  
	xor ax,ax
	xor dx,dx  
	
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+320],ax
	mov es:[bx+320],dx
	
	add bx,160
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+320],ax
	mov es:[bx+322],dx
	
	sub bx,160
	sub bx,160
	dec si
	cmp si,8
	je correcaotabuleiro3
	dec cx
	loop	ciclo_corrige_tab3	
		
		
correcaotabuleiro3:		
			call contador_de_pontos
			xor AX,AX
			xor bx,bx
			mov al,posx
			mov	bl,2
			mul bl
			
			xor bx,bx
			mov bx,ax ; bx=coluna*2
			xor ax,ax
			
			add bx,1440 ; bx=coluna*2+linha*160=posx*2+9*160

			mov cx,1	

novacorcorrecao3:	
		xor ax,ax
		call	CalcAleat	; Calcula próximo aleatório que é colocado na pinha 
		pop	ax ; 		; Vai buscar 'a pilha o número aleatório
		and 	al,70h	; posição do ecran com cor de fundo aleatório e caracter a preto
		cmp	al, 30h		; Se o fundo de ecran é preto
		je	novacorcorrecao3		; vai buscar outra cor 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh		
		mov	es:[bx+1], al	; Coloca as características de cor da posição atual 
		inc	bx		
		inc	bx		; próxima posição e ecran dois bytes à frente 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh
		mov	es:[bx+1], al
		dec	bx		
		dec	bx
		
		sub	bx,160

		cmp cx,0
		je  Ciclo
		dec cx
		jmp novacorcorrecao3
		
caso_quadrado_4:
		mov 	al,es:[bx]
		mov		ah,es:[bx+1]
		sub    	bx,4
		mov		dl,es:[bx]
		mov		dh,es:[bx+1]
		add 	bx,4
		cmp 	ah,dh
		jne    	LER_SETA		
		
		
;###CONFIRMAÇÃO QUE A COR DOS QUADRADOS ESTA A SER COMPARADA	
;		mov	al,03Fh             
;		mov	ah,'4'             
;		mov	bx,324           
	                     
;		mov	es:[bx],ah        
;		mov	es:[bx+1],al		
		
;		jmp fim	
		
	xor ax,ax
	
	sub bx,160
	
	mov al,posy
	mov si,ax

	cmp si,8
	je	correcaotabuleiro4

	mov cx,6
ciclo_corrige_tab4:  
	xor ax,ax
	xor dx,dx  
	
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+160],ax
	mov es:[bx+162],dx
	
	sub bx,4
	
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov es:[bx+160],ax
	mov es:[bx+162],dx
	
	add bx,4
	sub bx,160
	dec si
	cmp si,8
	je correcaotabuleiro4
	dec cx
	loop	ciclo_corrige_tab4	
		
		
			
correcaotabuleiro4:	
			call contador_de_pontos	
			xor AX,AX
			xor bx,bx
			mov al,posx
			mov	bl,2
			mul bl
			
			xor bx,bx
			mov bx,ax ; bx=coluna*2
			xor ax,ax
			
			add bx,1280 ; bx=coluna*2+linha*160=posx*2+8*160

		mov cx,1	

novacorcorrecao4:	
		xor ax,ax
		call	CalcAleat	; Calcula próximo aleatório que é colocado na pinha 
		pop	ax ; 		; Vai buscar 'a pilha o número aleatório
		and 	al,70h	; posição do ecran com cor de fundo aleatório e caracter a preto
		cmp	al, 30h		; Se o fundo de ecran é preto
		je	novacorcorrecao4		; vai buscar outra cor 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh		
		mov	es:[bx+1], al	; Coloca as características de cor da posição atual 
		inc	bx		
		inc	bx		; próxima posição e ecran dois bytes à frente 

		mov 	dh,	   cara	; Repete mais uma vez porque cada peça do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh
		mov	es:[bx+1], al
		dec	bx		
		dec	bx
		
		sub	bx,4

		cmp cx,0
		je  Ciclo
		dec cx
		jmp novacorcorrecao4
		
	
		
APAGAR:
		xor		bx,bx
		mov		cx,25*80
		
apaga:			mov	byte ptr es:[bx],' '
		mov		byte ptr es:[bx+1],7
		inc		bx
		inc 		bx
		loop		apaga
		ret		
		
		
		
LER_SETA:	call 		LE_TECLA_JOGO
		cmp		ah, 1
		je		ESTEND
		CMP 		AL, 27	; ESCAPE
		JE		FIM
		cmp 	al,0Dh
		je		CICLO1
		jmp		LER_SETA
		
ESTEND:		cmp 		al,48h
		jne		BAIXO
		dec		POSy		;cima
		jmp		CICLO

BAIXO:		cmp		al,50h
		jne		ESQUERDA
		inc 		POSy		;Baixo
		jmp		CICLO

ESQUERDA:
		cmp		al,4Bh
		jne		DIREITA
		dec		POSx		;Esquerda
		dec		POSx		;Esquerda

		jmp		CICLO

DIREITA:
		cmp		al,4Dh
		jne		LER_SETA
		inc		POSx		;Direita
		inc		POSx		;Direita
		
		jmp		CICLO

	
fim:

















modo_configurado ENDP

;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;NOVO TABULEIRO NECESSARIO?
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################


novo_tabuleiro_necessario proc
	
	
	
	xor ax,ax 	; ax=0
	xor bx,bx	; bx=0
	xor cx,cx	; cx=0
	xor dx,dx	; dx=0
	xor si,si
	
posicao_celula:	
	xor bx,bx
	mov al,tabx	 ;al=tabx			
	mov bl,2	 ;bl=2				
	mul bl		 ;al=tabx*2			
	
	mov cx,ax
	xor ax,ax
	xor bx,bx
	
	mov al,taby	; al=taby			
	mov bl,160	; bl=160			
	mul bl		; bl=taby*160		
										
									
	add	cx,ax ;POSICAO DA CELULA bx+ax
	mov bx,cx
	xor ax,ax 	; ax=0
	xor cx,cx	; cx=0
	xor dx,dx	; dx=0
	xor bx,bx
	
	tipo_1:
		xor 	ax,ax
		xor		dx,dx
	
	
		mov 	al,es:[bx]
		mov		ah,es:[bx+1]
		sub     bx,160
		mov		dl,es:[bx]
		mov		dh,es:[bx+1]
		add 	bx,160
		

		cmp 	ah,dh
		jne     tipo_2
						
		
		jmp     fim_funcao



		
	tipo_2:		
		xor 	ax,ax
		xor		dx,dx
		
		mov 	al,es:[bx]
		mov		ah,es:[bx+1]
		add     bx,4
		mov		dl,es:[bx]
		mov		dh,es:[bx+1]
		sub 	bx,4
	
	
	
		cmp 	ah,dh
		jne     tipo_3
		jmp     fim_funcao

	
		
		
	tipo_3:
		xor 	ax,ax
		xor		dx,dx
		
		
		mov 	al,es:[bx]
		mov		ah,es:[bx+1]
		add     bx,160
		mov		dl,es:[bx]
		mov		dh,es:[bx+1]
		sub 	bx,160

	
		cmp 	ah,dh
		jne     tipo_4
		jmp     fim_funcao

		
	tipo_4:
		xor 	ax,ax
		xor		dx,dx

		
		mov 	al,es:[bx]
		mov		ah,es:[bx+1]
		sub    	bx,4
		mov		dl,es:[bx]
		mov		dh,es:[bx+1]
		add 	bx,4
		
		
		cmp 	ah,dh
		jne     ociclo
		jmp     fim_funcao

		
		
ociclo:
		xor ax,ax
		xor bx,bx 
	
	;FIMMMM
		mov al,tabx
		cmp al,46
		inc taby
		mov tabx,30
	
		xor ax,ax
		inc tabx
		inc tabx
		
		dec cx
		cmp cx,0
		je  tab
		jne	posicao_celula
		
		
tab: 
	call tabuleiro

fim_funcao:
		ret
novo_tabuleiro_necessario endp





;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;VER PONTUACOES
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################
;##########################################################




ver_pontuacoes PROC NEAR


		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
	
		PUSHF
		
		
		

		mov		al,020h
		mov		ah,' ' 
		mov		bx,0
		mov		cx,25*80

CIC_A:    
		mov		es:[bx],ah
		mov		es:[bx+1],al
		inc		bx
		inc		bx
		loop	CIC_A
	

	
		
		
		mov 	al,linha2	;linha 						(incrementar a cada loop)
		mov 	bl,160		;160 = nr de bytes de cada linha, visto q cada linha tem 80 quadrados de 2 bytes
		mul 	bl			;multiplicar linhas p bytes (10*160)
		mov 	di,ax
		
		
		mov 	al,col2		;coluna 						
		mov 	bl,2		;2 = nr de bytes de cada quadrado
		mul 	bl			;multiplicar colunas p bytes (30*2)
		add 	di,ax
		xor 	si,si
		xor 	bx,bx
		push 	bx
;abre ficheiro
	
        mov     ah,3dh			; vamos abrir ficheiro para leitura 
        mov     al,0			; tipo de ficheiro	
        lea     dx,Fich			; nome do ficheiro
        int     21h				; abre para leitura 
        jc      erro_abrir		; pode aconter erro a abrir o ficheiro 
        mov     HandleFich,ax	; ax devolve o Handle para o ficheiro 
        jmp     ler_ciclo		; depois de aberto vamos ler o ficheiro 

erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     sai

		

ler_ciclo:

        mov     ah,3fh				; indica que vai ser lido um ficheiro 
        mov     bx,HandleFich		; bx deve conter o Handle do ficheiro previamente aberto 
        mov     cx,1				; numero de bytes a ler 
        lea     dx,car_fich			; vai ler para o local de memoria apontado por dx (car_fich)
        int     21h					; faz efectivamente a leitura
		jc	    erro_ler			; se carry é porque aconteceu um erro
		cmp	    ax,0				;EOF?	verifica se já estamos no fim do ficheiro 
		je	    fecha_ficheiro		; se EOF fecha o ficheiro

		
		mov 	al,car_fich
		cmp		al, '$'
		je		nova_linha
		
		mov		es:[di],al
		mov 	ah,20h
		mov		es:[di+1],ah
		inc 	di
		inc 	di
		pop 	bx
		inc 	bx
		push 	bx
		
		jmp 	ler_ciclo
	
	nova_linha:
		pop 	bx
		add 	bx,bx
		add 	di, 160  	;(160) incremento de linha
		sub		di,bx
		xor 	bx,bx
		push 	bx
		
		
		mov     ah, 3fh
     	mov     bx, HandleFich
     	mov     cx, 1				; vai ler apenas um byte de cada vez
     	lea     dx, car_fich		; DX fica a apontar para o caracter lido
      	int     21h					; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0				; verifica se já chegou o fim de ficheiro EOF? 
		je		fecha_ficheiro		; se chegou ao fim do ficheiro fecha e sai
		mov 	bx,0				;1 algarismo da 1 coluna
		mov 	al,car_fich
		mov 	matriz[si][bx],al 	;meter numero
		mov		es:[di],al
		mov 	ah,20h
		mov		es:[di+1],ah
		inc 	di
		inc 	di
		
		mov     ah, 3fh
     	mov     bx, HandleFich
     	mov     cx, 1				; vai ler apenas um byte de cada vez
     	lea     dx, car_fich		; DX fica a apontar para o caracter lido
      	int     21h					; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0				; verifica se já chegou o fim de ficheiro EOF? 
		je		fecha_ficheiro		; se chegou ao fim do ficheiro fecha e sai
		mov 	bx,1				;2 algarismo da coluna
		mov 	al,car_fich
		mov 	matriz[si][bx],al 	;meter numero
		mov		es:[di],al
		mov 	ah,20h
		mov		es:[di+1],ah
		inc 	di
		inc 	di

		mov     ah, 3fh
     	mov     bx, HandleFich
     	mov     cx, 1				; vai ler apenas um byte de cada vez
     	lea     dx, car_fich		; DX fica a apontar para o caracter lido
      	int     21h					; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0				; verifica se já chegou o fim de ficheiro EOF? 
		je		fecha_ficheiro		; se chegou ao fim do ficheiro fecha e sai
		mov 	bx,2				;1 algarismo da 1  coluna
		mov 	al,car_fich
		mov 	matriz[si][bx],al 	;meter numero
		mov		es:[di],al
		mov 	ah,20h
		mov		es:[di+1],ah
		inc 	di
		inc 	di

		mov     ah, 3fh
     	mov     bx, HandleFich
     	mov     cx, 1				; vai ler apenas um byte de cada vez
     	lea     dx, car_fich		; DX fica a apontar para o caracter lido
      	int     21h					; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0				; verifica se já chegou o fim de ficheiro EOF? 
		je		fecha_ficheiro		; se chegou ao fim do ficheiro fecha e sai
		mov 	bx,3				;2 algarismo da 2 coluna
		mov 	al,car_fich
		mov 	matriz[si][bx],al 	;meter numero
		mov		es:[di],al
		mov 	ah,20h
		mov		es:[di+1],ah
		inc 	di
		inc 	di
		
		
		add si,4
		add di,320
		sub di,8
		
	
		jmp ler_ciclo


erro_ler:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro:					; fechar o ficheiro 
			
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     sai

        mov     ah,09h			; o ficheiro pode não fechar correctamente
        lea     dx,Erro_Close
        Int     21h

	sai:
	
	
	
;TOYBLAST
	;LETRA -
	
	mov	al,0AFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'-'             ; AH - Caracter
	mov	bx,386           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA |
	
	mov	al,0AFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'|'             ; AH - Caracter
	mov	bx,388           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0A4h             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,390           ; BX = linha*160 + coluna*2=2*160+35*2=390 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,0A5h             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,392             ; BX = linha*160 + coluna*2=2*160+36*2=2154-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA Y
	
	mov	al,0AEh             ; AL - static ou não / background color / cor do texto
	mov	ah,'Y'             ; AH - Caracter
	mov	bx,394             ; BX = linha*160 + coluna*2=8*160+37*2=2156 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;ESPAÇO
	
	mov	al,0A0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,396           ; BX = linha*160 + coluna*2=8*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	;LETRA B
	
	mov	al,0A6h             ; AL - static ou não / background color / cor do texto
	mov	ah,'B'             ; AH - Caracter
	mov	bx,398           ; BX = linha*160 + coluna*2=8*160+39*2=2160 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA L
	
	mov	al,0A4h             ; AL - static ou não / background color / cor do texto
	mov	ah,'L'             ; AH - Caracter
	mov	bx,400           ; BX = linha*160 + coluna*2=8*160+40*2=2162 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,0A8h             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,402           ; BX = linha*160 + coluna*2=8*160+41*2=2164 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA S
	
	mov	al,0A1h             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,404           ; BX = linha*160 + coluna*2=8*160+42*2=2166 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0A5h             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,406           ; BX = linha*160 + coluna*2=8*160+43*2=2168 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA |
	
	mov	al,0AFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'|'             ; AH - Caracter
	mov	bx,408           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA -
	
	mov	al,0AFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'-'             ; AH - Caracter
	mov	bx,410           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
;#####SAIR	
	;LETRA S
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,3980       ; BX = linha*160 + coluna*2=24*160+70*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,3982           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA I
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'I'             ; AH - Caracter
	mov	bx,3984          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA R
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,3986          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	
	
;#######MENU
	
	;LETRA M
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'M'             ; AH - Caracter
	mov	bx,3968            ; BX = linha*160 + coluna*2=24*160+64*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA E
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,3970           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA N
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'N'             ; AH - Caracter
	mov	bx,3972          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA U
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'U'             ; AH - Caracter
	mov	bx,3974          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
;######PONTUAÇÕES
	;LETRA P
	
	mov	al,02Dh             ; AL - static ou não / background color / cor do texto
	mov	ah,'P'             ; AH - Caracter
	mov	bx,708           ; BX = linha*160 + coluna*2=160*4+33*2=706-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,02Dh                           ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,710            ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA N
	
	mov	al,02Dh                           ; AL - static ou não / background color / cor do texto
	mov	ah,'N'             ; AH - Caracter
	mov	bx,712            ; BX = linha*160 + coluna*2=2*160+35*2=390 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,02Dh                          ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,714              ; BX = linha*160 + coluna*2=2*160+36*2=2154-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA U
	
	mov	al,02Dh                         ; AL - static ou não / background color / cor do texto
	mov	ah,'U'             ; AH - Caracter
	mov	bx,716              ; BX = linha*160 + coluna*2=8*160+37*2=2156 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA  A
	
	mov	al,02Dh                            ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,718           ; BX = linha*160 + coluna*2=8*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	;LETRA C
	
	mov	al,02Dh                            ; AL - static ou não / background color / cor do texto
	mov	ah,'C'             ; AH - Caracter
	mov	bx,720           ; BX = linha*160 + coluna*2=8*160+39*2=2160 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	


	;LETRA O
	
	mov	al,02Dh                           ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,722           ; BX = linha*160 + coluna*2=8*160+39*2=2160 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	
	
		;LETRA E
	
	mov	al,02Dh                          ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,724				;BX = linha*160 + coluna*2=8*160+39*2=2160 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	

		;LETRA S
	
	mov	al,02Dh                       ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,726           ; BX = linha*160 + coluna*2=8*160+39*2=2160 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al	

	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MOUSE



	goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h	; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor, ah	; Guarda a cor que está na posição do Cursor	
		
		inc			POSx
		goto_xy		POSx,POSy	; Vai para nova possição2
		mov 		ah, 08h		; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car2, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor2, ah	; Guarda a cor que está na posição do Cursor	
		dec			POSx
	

CICLO_A1:		
		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
		
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		
IMPRIME_A1:	
		mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		
		
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 	POSya, al

		jmp LER_SETA_A
		
		
		
CICLO_A2:		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 	POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		 
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		
IMPRIME_A2:	
		mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 	POSya, al
		
		
		
;#######MENU		
		cmp  	POSy,24
		jne  	LER_SETA_A
		
		cmp		POSx,64
		je  	DOOR_A; volta ao menu
		
		cmp		POSx,65
		je  	DOOR_A; volta ao menu
		
		
		cmp		POSx,66
		je  	DOOR_A; volta ao menu
		
		
		cmp		POSx,67
		je  	DOOR_A; volta ao menu
		
	
;#######SAIR		
		
		cmp		POSx,70
		je  	fim; SAIR
		
		cmp		POSx,71
		je  	fim; SAIR
		
		cmp		POSx,72
		je  	fim; SAIR
		
		cmp		POSx,73
		je  	fim; SAIR
		

		jmp  	LER_SETA_A
		

		
		
DOOR_A:

		POPF
		POP DX
		POP CX
		POP BX
		POP AX
		jmp ini
		
;APAGAR(A):
;		xor		bx,bx
;		mov		cx,25*80
		
;apaga1:			
;		mov		byte ptr es:[bx],' '
;		mov		byte ptr es:[bx+1],7
;		inc		bx
;		inc 	bx
;		loop	apaga1
;		ret		
		
		
		
LER_SETA_A:	
		call 	LE_TECLA
		cmp		ah, 1
		je		ESTEND_A
		CMP 	AL, 27	; ESCAPE
		JE		FIM
		cmp 	al,0Dh
		je		CICLO_A2
		jmp		LER_SETA_A
		
ESTEND_A:		
		cmp 		al,48h
		jne		BAIXO_A
		dec		POSy		;cima
		jmp		CICLO_A1

BAIXO_A:		
		cmp		al,50h
		jne		ESQUERDA_A
		inc 	POSy		;Baixo
		jmp		CICLO_A1

ESQUERDA_A:
		cmp		al,4Bh
		jne		DIREITA_A
		dec		POSx		;Esquerda
		dec		POSx		;Esquerda

		jmp		CICLO_A1

DIREITA_A:
		cmp		al,4Dh
		jne		LER_SETA_A
		inc		POSx		;Direita
		inc		POSx		;Direita
		
		jmp		CICLO_A1


ver_pontuacoes ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONFIGURA UM TABULEIRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONFIGURA UM TABULEIRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONFIGURA UM TABULEIRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONFIGURA UM TABULEIRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONFIGURA UM TABULEIRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONFIGURA UM TABULEIRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONFIGURA UM TABULEIRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONFIGURA UM TABULEIRO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

configurar_grelha PROC NEAR




		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
	
		PUSHF
		
		
		
	mov	al,030h
	mov	ah,' ' 
	mov	bx,0
	mov	cx,25*80

CIC_B:    
	mov	es:[bx],ah
	mov	es:[bx+1],al
	inc	bx
	inc	bx
	loop	CIC_B
	
	
	
		
	xor di,di
	
	xor ax,ax
	mov al,linha3	;linha (incrementar a cada loop)
	mov bl,160		;160 = nr de bytes de cada linha, visto q cada linha tem 80 quadrados de 2 bytes
	mul bl			;multiplicar linhas p colunas
	add di,ax
	
	xor ax,ax
	mov al,col3		;coluna 						
	mov bl,2		;2 = nr de bytes de cada quadrado
	mul bl			;multiplicar colunas p bytes (30*2)
	add di,ax		
	
	
;TOYBLAST
	;LETRA -
	
	mov	al,0BFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'-'             ; AH - Caracter
	mov	bx,386           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA |
	
	mov	al,0BFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'|'             ; AH - Caracter
	mov	bx,388           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0B4h             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,390           ; BX = linha*160 + coluna*2=2*160+35*2=390 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA O
	
	mov	al,0B5h             ; AL - static ou não / background color / cor do texto
	mov	ah,'O'             ; AH - Caracter
	mov	bx,392             ; BX = linha*160 + coluna*2=2*160+36*2=2154-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA Y
	
	mov	al,0BEh             ; AL - static ou não / background color / cor do texto
	mov	ah,'Y'             ; AH - Caracter
	mov	bx,394             ; BX = linha*160 + coluna*2=8*160+37*2=2156 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;ESPAÇO
	
	mov	al,0B0h             ; AL - static ou não / background color / cor do texto
	mov	ah,' '             ; AH - Caracter
	mov	bx,396           ; BX = linha*160 + coluna*2=8*160+38*2=2158 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	;LETRA B
	
	mov	al,0B6h             ; AL - static ou não / background color / cor do texto
	mov	ah,'B'             ; AH - Caracter
	mov	bx,398           ; BX = linha*160 + coluna*2=8*160+39*2=2160 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA L
	
	mov	al,0B4h             ; AL - static ou não / background color / cor do texto
	mov	ah,'L'             ; AH - Caracter
	mov	bx,400           ; BX = linha*160 + coluna*2=8*160+40*2=2162 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,0BDh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,402           ; BX = linha*160 + coluna*2=8*160+41*2=2164 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA S
	
	mov	al,0B1h             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,404           ; BX = linha*160 + coluna*2=8*160+42*2=2166 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0B5h             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,406           ; BX = linha*160 + coluna*2=8*160+43*2=2168 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA |
	
	mov	al,0BFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'|'             ; AH - Caracter
	mov	bx,408           ; BX = linha*160 + coluna*2-> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA -
	
	mov	al,0BFh             ; AL - static ou não / background color / cor do texto
	mov	ah,'-'             ; AH - Caracter
	mov	bx,410           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
;################ INSIRA 54 CORES
	
	mov	ah,30h		
	mov	al,'I' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'n' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'s' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'i' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'r' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'a' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'5' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'4' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'c' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'o' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'r' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'e' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'s' 
	mov	es:[di],al
	mov	es:[di+1],ah
	
	add di,132
	add di,160
	
;###############QUADRADO PRETO + 0->PRETO
	
	mov	ah,00h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,00h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'0' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'-' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'>' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'P' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'r' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'e' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'t' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'o' 
	mov	es:[di],al
	mov	es:[di+1],ah

	add di,138
	add di,160
	
;###############QUADRADO AZUL + 1->AZUL
	
	mov	ah,10h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,10h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'1' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'-' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'>' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'A' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'z' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'u' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'l' 
	mov	es:[di],al
	mov	es:[di+1],ah
	
	
	add di,140
	add di,160
	
;###############QUADRADO VERDE + 2->VERDE
	
	
	mov	ah,20h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,20h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'2' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'-'
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'>' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'V' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'e' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'r' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'d' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'e' 
	mov	es:[di],al
	mov	es:[di+1],ah
	
	
	add di,138
	add di,160
	
;###############QUADRADO CIANO + 3->CIANO
	
	mov	ah,40h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,40h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'4' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'-' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'>' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'V' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'e' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'r' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'m' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'e' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'l' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'h' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'o' 
	mov	es:[di],al
	mov	es:[di+1],ah
	
	
	add di,132
	add di,160
	
;################QUADRADO MANGENTA + 5->MANGENTA


	mov	ah,50h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,50h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'5' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'-' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'>' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'M' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'a' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'n' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'g' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'e' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'n' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'t' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'a' 
	mov	es:[di],al
	mov	es:[di+1],ah
	
	
	add di,132
	add di,160
	
;###########QUADRADO CASTANHO + 6->CASTANHO
	
	mov	ah,60h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,60h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'6' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'-' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'>' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'C' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'a' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'s' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'t' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'a' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'n' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'h' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'o' 
	mov	es:[di],al
	mov	es:[di+1],ah

	
	add di,132
	add di,160
	
;###########QUADRADO CINZENTO + 7->CINZENTO
	
	mov	ah,70h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,70h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'7' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'-' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'>' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'C' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'i' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'n' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'z' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'e' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'n' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'t' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,'o' 
	mov	es:[di],al
	mov	es:[di+1],ah
	
	
	
	add di,128
	add di,160
	add di,160
	add di,160
	
;################ESPAÇO PARA ESCREVER
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh	
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh	
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh	
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh	
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,0Fh		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	mov	ah,30h		
	mov	al,' ' 
	mov	es:[di],al
	mov	es:[di+1],ah
	inc di
	inc di
	

	
	
	
;#####ENTER
	;LETRA E
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,3480     ; BX = linha*160 + coluna*2=21*160+60*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA N
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'N'             ; AH - Caracter
	mov	bx,3482           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA T
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'T'             ; AH - Caracter
	mov	bx,3484          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA E
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,3486         ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

		
		;LETRA R
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,3488        ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	
	
	
	
	
	
	
	
;#####SAIR	
	;LETRA S
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'S'             ; AH - Caracter
	mov	bx,3980       ; BX = linha*160 + coluna*2=24*160+70*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA A
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'A'             ; AH - Caracter
	mov	bx,3982           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA I
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'I'             ; AH - Caracter
	mov	bx,3984          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA R
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'R'             ; AH - Caracter
	mov	bx,3986          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	
	
;#######MENU
	
	;LETRA M
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'M'             ; AH - Caracter
	mov	bx,3968            ; BX = linha*160 + coluna*2=24*160+64*2= -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA E
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'E'             ; AH - Caracter
	mov	bx,3970           ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA N
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'N'             ; AH - Caracter
	mov	bx,3972          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al
	
	;LETRA U
	
	mov	al,0Fh             ; AL - static ou não / background color / cor do texto
	mov	ah,'U'             ; AH - Caracter
	mov	bx,3974          ; BX = linha*160 + coluna*2 -> escreve o caracter numa celula específica
	                       ; -> só funciona quando o deslocamento é efetuado a partir de linha 0, coluna 0
	mov	es:[bx],ah        
	mov	es:[bx+1],al

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
	
	goto_xy		POSx,POSy	; Vai para nova posição
		mov 		ah, 08h	; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor, ah	; Guarda a cor que está na posição do Cursor	
		
		inc			POSx
		goto_xy		POSx,POSy	; Vai para nova posição2
		mov 		ah, 08h		; Guarda o Caracter que está na posição do Cursor
		mov			bh,0		; numero da página
		int			10h			
		mov			Car2, al	; Guarda o Caracter que está na posição do Cursor
		mov			Cor2, ah	; Guarda a cor que está na posição do Cursor	
		dec			POSx
	

CICLO_B1:		
		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 	ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
		
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
IMPRIME_B1:	
		mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 	POSya, al

jmp LER_SETA_B
		
		
		
CICLO_B2:		
		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 	POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		 
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
IMPRIME_B2:	
		mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posição do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 	POSya, al
		
;######ENTER
		
le_enter:
		cmp 	POSy,21
		jne		MENU_B
		
		cmp 	POSx,60
		je 		savefile

		cmp 	POSx,61
		je 		savefile
		
		cmp 	POSx,62
		je 		savefile

		cmp 	POSx,63
		je 		savefile
		
		cmp 	POSx,64
		je 		savefile		
		
;#######MENU	
MENU_B:	
		cmp  	POSy,24
		jne  	SAIR_B
		
		
		cmp		POSx,64
		je  	DOOR_B; SAIR
		
		cmp		POSx,65
		je  	DOOR_B; SAIR
		
		
		cmp		POSx,66
		je  	DOOR_B; SAIR
		
		
		cmp		POSx,67
		je  	DOOR_B; SAIR
		
	
;#######SAIR		
SAIR_B:		
		cmp		POSx,70
		je  	fim; SAIR
		
		cmp		POSx,71
		je  	fim; SAIR
		
		cmp		POSx,72
		je  	fim; SAIR
		
		cmp		POSx,73
		je  	fim; SAIR
		
		cmp 	POSx,73
		jne  	LER_SETA_B

		
		
		
		
LER_SETA_B:	
		call 	LE_TECLA
		cmp		ah, 1
		je		ESTEND_B
		CMP 	AL, 27	; ESCAPE
		JE		FIM
		cmp 	al,0Dh
		je		CICLO_B2
		jmp		LER_SETA_B
		
ESTEND_B:		
		cmp 	al,48h
		jne		BAIXO_B
		dec		POSy		;cima
		cmp 	POSy,21
		jne 	CICLO_B1
		cmp     POSx,2
		je		NRS
		jmp		CICLO_B1

BAIXO_B:		
		cmp		al,50h
		jne		ESQUERDA_B
		inc 	POSy		;Baixo
		cmp 	POSy,21
		jne 	CICLO_B1
		cmp     POSx,2
		je		NRS
		jmp		CICLO_B1

ESQUERDA_B:
		cmp		al,4Bh
		jne		DIREITA_B
		dec		POSx		;Esquerda
		dec		POSx		;Esquerda
		cmp 	POSy,21
		jne 	CICLO_B1
		cmp     POSx,2
		je		NRS
		jmp		CICLO_B1

DIREITA_B:
		cmp		al,4Dh
		jne		LER_SETA_B
		inc		POSx		;Direita
		inc		POSx		;Direita
		cmp 	POSy,21
		jne 	CICLO_B1
		cmp     POSx,2
		je		NRS
		jmp		CICLO_B1
		

		


		
NRS:

	goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 	POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possição
		mov 	ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 	ah, 08h
		mov		bh,0		; numero da página
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que está na posição do Cursor2
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posição do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	
		int		21H			
		
	
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		
		
		mov dl,0
		xor si,si
		xor di,di
		mov ah, 0Ah 				;SERVICE TO CAPTURE STRING FROM KEYBOARD.
		mov dx, offset buffer		;equivalente a lea
		int 21h
		
		
		;CHANGE CHR(55) BY '$'.
		mov si, offset buffer + 1 	;NUMBER OF CHARACTERS ENTERED..... equivalente a lea
		mov cl, [ si ] 				;MOVE LENGTH TO CL.
		mov ch, 0 					;CLEAR CH TO USE CX.
		inc cx 						;TO REACH CHR(55).
		add si, cx 					;NOW SI POINTS TO CHR(55).
		mov al, '$'
		mov [ si ], al 				;REPLACE CHR(55) BY '$'.
		
		inc POSy
		jmp CICLO_B1

		
		
savefile:
		mov		ah, 3ch				; Abrir o ficheiro para escrita
		mov		cx, 00H				; Define o tipo de ficheiro ??
		lea		dx, fname			; DX aponta para o nome do ficheiro 
		int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
		jnc		escreve				; Se não existir erro escreve no ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorCreate
		int		21h
		jmp		DOOR_B
		
		

escreve:
		mov		bx, ax				; Coloca em BX o Handle
    	mov		ah, 40h				; indica que é para escrever
    	
		lea		dx, buffer			; DX aponta para a infromação a escrever
    	mov		cx,	54				; CX fica com o numero de bytes a escrever
		int		21h					; Chama a rotina de escrita
		jnc		close				; Se não existir erro na escrita fecha o ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorWrite
		int		21h

		
close:
		mov		ah,3eh				; fecha o ficheiro
		int		21h
		jnc		DOOR_B
	
		mov		ah, 09h
		lea		dx, msgErrorClose
		int		21h

		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,		
DOOR_B:
		POPF
		POP DX
		POP CX
		POP BX
		POP AX
		jmp outer

		
		
configurar_grelha ENDP


outer:
	jmp ini

fim:	
		

		xor		bx,bx
		mov		cx,25*80
		
apaga:			
		mov	byte ptr es:[bx],' '
		mov		byte ptr es:[bx+1],7
		inc		bx
		inc 	bx
		loop	apaga
		
		
		
		mov     ah,4CH
		int     21H
Cseg	ends
end	Main

