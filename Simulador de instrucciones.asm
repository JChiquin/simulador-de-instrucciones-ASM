.TITLE MACROS PARA LA PANTALLA
.PSECT Datos, NOEXE, WRT
Blink           :  .LONG SMG$M_BLINK
Normal          :  .LONG SMG$M_NORMAL
Borra           :  .LONG SMG$M_ERASE_LINE
Inversa         :  .LONG SMG$M_REVERSE
Negrita         :  .LONG SMG$M_BOLD
Teclado         :  .LONG 0
Ventana         :  .LONG 0
Pizarron        :  .LONG 0
Pantalla        :  .LONG 0
Tecla           :  .BYTE 0
Teclasalir      :  .BYTE 0
Blanco          :  .BYTE 0
;----------------------PORTADA------------------------------------
Men0            :  .ASCID/REPUBLICA BOLIVARIANA DE VENEZUELA/
Men1            :  .ASCID/UNIVERSIDAD CENTROCCIDENTAL LISANDRO ALVARADO/
Men2            :  .ASCID/DECANATO DE CIENCIA Y TECNOLOGIA/
Men3            :  .ASCID/Simulador de Instrucciones VAX/
Men4            :  .ASCID/          BARQUISIMETO   2016 /

;------------------EL MENU Y MENSAJES--------------------------
Men5            :  .ASCID /Presione una Tecla para Continuar/
Men6            :  .ASCID /1.-/
Men7            :  .ASCID /Principal/
Men8            :  .ASCID /2.-/
Men9            :  .ASCID /Cargar Instrucciones(Max 10)/
Men10           :  .ASCID /3.-/
Men11           :  .ASCID /Incializar registros/
Men12           :  .ASCID /MENU/
Men13           :  .ASCID /4.-/
Men14           :  .ASCID /Ejecutar Instrucciones/
Men15           :  .ASCID /5.-/
Men16           :  .ASCID /Salir/


MenCuadroIns    :  .ASCID /Instrucciones/
MenCuadroIns2   :  .ASCID /  Guardadas/
Men1.           :  .ASCID / 1. /
Men2.           :  .ASCID / 2. /
Men3.           :  .ASCID / 3. /
Men4.           :  .ASCID / 4. /
Men5.           :  .ASCID / 5. /
Men6.           :  .ASCID / 6. /
Men7.           :  .ASCID / 7. /
Men8.           :  .ASCID / 8. /
Men9.           :  .ASCID / 9. /
Men10.          :  .ASCID /10. /

MenAutores              : .ASCID /Integrantes:/
MenAutores1             : .ASCID /Chiquin Jorge/
MenAutores2             : .ASCID /Vargas Alexander/
MenAutores3             : .ASCID /Fernandez Ysidro/


MenSalir                : .ASCID /INGRESE UN GUION (-) PARA VOLVER AL MENU/
MenSalir3       : .ASCID /PRESIONE ENTER PARA CONTINUAR, GUION(-) PARA VOLVER AL MENU/

MenMenu                 : .ASCID /Seleccione una opcion del menu/

MenLimpiar:.ASCID/                                                                        /
MenLimpiar2             : .ASCID /                          /
MenLimpiar3:.ASCID/                                              /

MenTutorial:.ASCID/Ejemplos: ADDR1R2 , subr0r9, MULr4r4, divR8R2/
MenErrorOperandos:.ASCID/ERROR! La instruccion debe tener 2 registros/
Men7Caracteres:.ASCID/ERROR! La instruccion es de solo 7 caracteres sin espacios/
Menmenor7Caracteres:.ASCID/ERROR! La instruccion esta incompleta/
MenOperacionInvalida:.ASCID/ERROR! Codigo de Operacion Invalida/
MenIndiceRegistros:.ASCID/ERROR! Indice de registro debe estar entre 0 y 9/
MenLimiteInstrucciones:.ASCID/Limite maximo de instrucciones alcanzado (10)/

MenCadena               : .ASCID /Ingrese Instruccion Nro/
MenDosPuntos            : .ASCID /: /

MenRegistro             : .ASCID /Ingrese registro /
Men1Digito              : .ASCID /Debe ser un digito entre 0 y 9/
MenCuadrito             : .ASCID /    Arreglo Registros/
MenCuadrito2            : .ASCID /Resultado de Instruccion/
MenCuadritoIndice    : .ASCID /0   1   2   3   4   5   6   7   8   9/
MenFlecha               : .ASCID/-->/
MenLimpiarFlecha        : .ASCID/   /
MenValidacion: .ASCID/Debe cargar instrucciones e inicializar registros/
MenDivision0: .ASCID/No se ejecuto la instruccion. Division entre 0/
;----------------LAS VARIABLES--------------------------

limIns=10

tamano=11
leerIns                 :  .blkb tamano
long_leerIns            :  .long 0
desc_leerIns            :  .long tamano
                           .long leerIns

tamano2=70
insGuardadas            :  .BLKB tamano2
long_insGuardadas       :  .long 0
desc_insGuardadas       :  .long tamano2
                           .long insGuardadas

correcto                :  .byte 0
ejecutadas              :  .byte 0
fil                     :  .long 0

contIns                 :  .long 0
contInsstr              :  .BLKb 2
desc_contIns            :  .long 2
                           .long contInsstr

tamano3=10
registros                :  .BLKB tamano3
long_registros           :  .long 0
desc_registros           :  .long tamano3
                            .long registros

contReg                 :  .long 0
contRegstr              :  .BLKb 2
desc_contReg            :  .long 2
                           .long contRegstr

valorReg                :  .byte 0
long_valorReg           :  .long 0
valorRegstr             :  .BLKB 2
desc_valorReg           :  .long 2
                           .long valorRegstr

ope: .ASCII /ADDSUBMULDIV/
i                       :  .byte 0

;**********************    Limpia una region de la pantalla virtual *********
        .MACRO LIMPIAR_PANTALLA Cf, Ff, Cc, Fc, Pant
           PUSHAL  Cf
           PUSHAL  Ff
           PUSHAL  Cc
           PUSHAL  Fc
           PUSHAL  Pant
           CALLS #5, G^SMG$ERASE_DISPLAY
    .ENDM  LIMPIAR_PANTALLA

;*******************  Coloca el cursor en la pantalla virtual *****************
    .MACRO GOTOXY  Columna, Fila
           PUSHL Columna
           PUSHL Fila
           CALLS #2,G^SCR$SET_CURSOR
    .ENDM  GOTOXY

;********************** Define el teclado virtual  ****************************
    .MACRO CREA_TECLADO Keyboard
           PUSHAL Keyboard
           CALLS #1,G^SMG$CREATE_VIRTUAL_KEYBOARD
    .ENDM  CREA_TECLADO

;********************  Define un Marco ****************************************
   .MACRO CREA_PIZARRON Piza
          PUSHAL Piza
          CALLS #1,G^SMG$CREATE_PASTEBOARD
   .ENDM  CREA_PIZARRON

; ********************* Define una pantalla virtual  **************************
   .MACRO  CREAR_PANTALLA  Atributo, Pant, NumCol, NumFil
           PUSHAL Atributo
           PUSHAL Pant
           PUSHAL NumCol
           PUSHAL NumFil
           CALLS #4,G^SMG$CREATE_VIRTUAL_DISPLAY
   .ENDM   CREAR_PANTALLA

;********************** Pega una pantalla en un Marco  ************************
   .MACRO PEGAR_PANTALLA Piza, Pant
         PUSHAL #1
          PUSHAL #1
          PUSHAL Piza
                    PUSHAL Pant
          CALLS #4,G^SMG$PASTE_VIRTUAL_DISPLAY
   .ENDM  PEGAR_PANTALLA

;***********************  Dibuja un cuadro ************************************
.MACRO RECTANGULO Cf, Ff, Cc, Fc, Pant
         PUSHAL Cf
         PUSHAL Ff
         PUSHAL Cc
         PUSHAL Fc
         PUSHAL Pant
         CALLS #5,G^SMG$DRAW_RECTANGLE
.END RECTANGULO

;**********************     Lee una tecla Sin eco en la pantalla *************
    .MACRO READKEY  Tecl, Teclad
           PUSHAL Tecl
           PUSHAL Teclad
           CALLS #2,G^SMG$READ_KEYSTROKE
    .ENDM  READKEY

;*****************  Escribe tiras de caracteres de tamano normal **************
   .MACRO WRITE   Col, Fil, Atrib, Men, Vent
          PUSHAL   Atrib
          PUSHAL   #0
                    PUSHAL   Col
          PUSHAL   Fil
          PUSHAL   Men
          PUSHAL   Vent
          CALLS #6,G^SMG$PUT_CHARS
    .ENDM WRITE

;******************   Escribe tiras de caracteres en tamano doble *************
   .MACRO WRITE_DOB   Col, Fil, Atrib, Men, Vent
          PUSHAL   Atrib
          PUSHAL   Col
          PUSHAL   Fil
          PUSHAL   Men
          PUSHAL   Vent
          CALLS #5,G^SMG$PUT_CHARS_HIGHWIDE
    .ENDM  WRITE_DOB

;**********************   Borra una linea  ************************************
    .MACRO CLR_LINEA Cf,Ff,Cc,Fc,pantalla
           PUSHAL  Cf
           PUSHAL  Ff
           PUSHAL  Cc
           PUSHAL  Fc
           PUSHAL  Pantalla
                      CALLS #5, G^SMG$DRAW_LINE
    .ENDM  CLR_LINEA

;**********************   Para Realizar Saltos Largos  ************************
    .MACRO SALTAR  Cond, Etiqueta, ?Opci1, ?Opci2
                        B'Cond  Opci1
                        BRB     Opci2
                        Opci1: JMP Etiqueta
                        Opci2: NOP
    .ENDM SALTAR

;=====================================================================
        .MACRO STR_NUM descriptor, numero
        PUSHAL numero
        PUSHAL descriptor
        CALLS #2, G^OTS$CVT_TU_L
        .ENDM STR_NUM

;=====================================================================
        .MACRO NUM_STR numero, descriptor
        PUSHAL descriptor
        PUSHAL numero
        CALLS #2, G^OTS$CVT_L_TU
        .ENDM NUM_STR

;=====================================================================
    .MACRO LEER lon, men, desc_tira
        PUSHAL lon
        PUSHAL men
        PUSHAL desc_tira
        CALLS #3, G^LIB$GET_INPUT
        MOVL lon, desc_tira
    .ENDM LEER

;=====================================================================
    .MACRO IMPRIMIR mensaje
        PUSHAL mensaje
        CALLS #1, G^LIB$PUT_OUTPUT
    .ENDM IMPRIMIR

;==============================================================
        .MACRO CUADRO
                Limpiar_pantalla #79, #24, #1, #1, Pantalla
                Rectangulo #80, #24, #1, #1, pantalla         ;grande 1
                Rectangulo #78, #22, #3, #2, pantalla         ;grande 2
        .ENDM CUADRO


;-----------------------MACROS---------------------------------
.MACRO LEER_INS long_leerIns,desc_leerIns,leerIns,correcto,contIns,desc_contIns,-
                insGuardadas,long_insGuardadas,Blanco,ope,i,Teclasalir,-
                ?Do,?while,?endwhile,?while2,?endwhile2,?else,?menor7,?mayor7,-
                ?else1,?for,?endIf1,?else2,?for1,?then,?endIF2,?endIf4,?else3,-
                ?endIf3,?salir

CUADRO
MOVAB insGuardadas, R11
MOVAB leerIns,R10

;====Limpiar instrucciones guardadas si ya se ejecutaron (ejecutadas=1)====
CMPB ejecutadas,#1
BNEQ Do
        MOVB #^A/ /,Blanco
        MOVC5 #1,Blanco,#^A/ /,long_insGuardadas,(R11)
        CLRL R9                         ;indice de instrucciones guardadas
        CLRL long_insGuardadas
        CLRL contIns
        CLRb ejecutadas
Do:

        Write #5, #21, negrita,   MenLimpiar , pantalla
        Write #5, #23, negrita,   MenLimpiar , pantalla
        LIMPIAR_PANTALLA #40, #11, #30 ,#9 , pantalla
        CUADRO_INSTRUCCIONES
        CUADRO_IMPRIMIR_INS leerIns,insGuardadas,desc_leerIns,long_insGuardadas,i
        Rectangulo #80, #24, #1, #1, pantalla         ;grande 1
        Rectangulo #78, #22, #3, #2, pantalla         ;grande 2
        Write #22, #23, inversa,   MenSalir, pantalla
        Write_DOB  #14,  #4,  negrita, Men9, pantalla
        Write #5, #17, negrita, MenTutorial, pantalla
        CLRL long_leerIns
        MOVL #9,desc_leerIns
        Write #5, #10, negrita,   MenCadena, pantalla
        INCL contIns
        NUM_STR contIns, desc_contIns
        Write #28, #10, negrita, desc_contIns, pantalla
        DECL contIns
        LEER long_leerIns, MenDosPuntos, desc_leerIns ;codigo nuevo

        CLRL R7
        while:
        CMPL R7,long_leerIns
        BGEQ  endwhile
        CMPB (R10)[R7], #^A/-/
        SALTAR EQL, salir
        INCL R7
        BRW while
        endwhile:

        MAYUSCULAS leerIns

        MOVB #1,correcto

;========VALIDACION CODIGO OPERACIONES========
        MOVAL ope,R6
        CLRL R8
        while2:
                CMPC3 #3,(R6)[R8],(R10)
                SALTAR EQL, else
                CMPL R8,#9
                BEQL endWhile2
                ADDL #3,R8
        BRW while2
        endWhile2:
        Write #5, #21, negrita,   MenOperacionInvalida , pantalla

        CLRB correcto
        SALTAR RW, endIF2

;========VALIDACION LONGITUD INSTRUCCION========
        else:
                CMPL long_leerIns, #7
                SALTAR EQL, else1
                BLSS menor7
                Write #5, #21, negrita,   Men7Caracteres, pantalla
                BRB mayor7
                menor7:
                Write #5, #21, negrita,   Menmenor7Caracteres, pantalla
                mayor7:
                CLRB correcto
        SALTAR RW, endIF2

;========VALIDACION CANTIDAD REGISTROS========
        else1:
                CLRL R7
                CLRL R6
                SUBL3 #1,long_leerIns,R8
                for:
                        CMPB (R10)[R6], #^A/R/
                        BNEQ endIf1
                                INCL R7        ;contador de R
                        endIf1:
                ACBL R8,#1,R6,for
                CMPL R7,#2
                BEQL else2
                        Write #5, #21, negrita,   MenErrorOperandos, pantalla
                        CLRB correcto
                SALTAR RW, endIF2

;========VALIDACION INDICE REGISTROS========
        else2:
                MOVL #4,R6
                for1:
                        CMPB  (R10)[R6],#^A/0/
                        BLSS then
                        CMPB  (R10)[R6],#^A/9/
                        BGTR then
                ACBL #6,#2,R6,for1
                BRW endIF2
                then:
                Write #5, #21, negrita,MenIndiceRegistros, pantalla
                CLRB correcto

        endIF2:
;========GUARDAR INSTRUCCION VALIDADA========
        CMPB correcto,#1
        SALTAR NEQ, else3
                INCL contIns
                MOVC3 #7,(R10),(R11)[R9]
                ADDL #7,R9
                ADDL #7,long_insGuardadas
                CMPL contIns,#limIns
                SALTAR NEQ, endIf4
                        Write #5, #21, negrita,   MenLimiteInstrucciones, pantalla
                        Write #22, #23, negrita,   MenLimpiar, pantalla
                        Write #22, #23, inversa,   Men5, pantalla
                        CUADRO_IMPRIMIR_INS leerIns,insGuardadas-
                                           ,desc_leerIns,long_insGuardadas,i
                        ReadKey Teclasalir, Teclado
                endIf4:
                BRW endIf3
        else3:
                Write #12, #23, inversa,   MenSalir3, pantalla
                ReadKey Teclasalir, Teclado
        endIf3:
;while(contIns<limIns and Teclasalir<>"-")
CMPL contIns,#limIns
BGEQ salir
CMPB Teclasalir,#^A/-/
SALTAR NEQ, DO

salir:

.ENDM LEER_INS

.MACRO MAYUSCULAS leerIns, ?for,?endIf
    CLRL R8
    MOVAB leerIns,R10
    for:
            CMPB (R10)[R8],#97
            BLSS endIf
                SUBB #32,(R10)[R8]
            endIf:
    ACBL #6,#1,R8,for
.ENDM MAYUSCULAS

.MACRO CUADRO_INSTRUCCIONES
        Rectangulo #77, #21, #63, #07, pantalla
        Rectangulo #77, #21, #63, #10, pantalla
        Write #64, #08, negrita,   MenCuadroIns, pantalla
        Write #64, #09, negrita,   MenCuadroIns2, pantalla
        Write #64, #11, negrita,   Men1., pantalla
        Write #64, #12, negrita,   Men2., pantalla
        Write #64, #13, negrita,   Men3., pantalla
        Write #64, #14, negrita,   Men4., pantalla
        Write #64, #15, negrita,   Men5., pantalla
        Write #64, #16, negrita,   Men6., pantalla
        Write #64, #17, negrita,   Men7., pantalla
        Write #64, #18, negrita,   Men8., pantalla
        Write #64, #19, negrita,   Men9., pantalla
        Write #64, #20, negrita,   Men10., pantalla
.ENDM CUADRO_INSTRUCCIONES

.MACRO CUADRO_IMPRIMIR_INS leerIns,insGuardadas,desc_leerIns,long_insGuardadas,i,?for

        MOVAB leerIns,R10
        MOVAB insGuardadas, R11

        MOVL #7,desc_leerIns
        SUBL #7,long_insGuardadas
        CLRL R8
        MOVB #11,i
        for:
                MOVC3 #7,(R11)[R8],(R10)
                Write #69,i, negrita,   desc_leerIns, pantalla
                INCB i
        ACBL long_insGuardadas,#7,R8,for
        ADDL #7,long_insGuardadas

.ENDM CUADRO_IMPRIMIR_INS

.MACRO LLENAR_REGISTROS leerIns,contReg,registros,long_registros,desc_conReg,-
                        long_leerIns,desc_leerIns,correcto,i,valorReg,-
                        desc_valorReg,-
                        ?while,?ewhile,?Do,?else,?then,?endIf,?endIf2
    CUADRO
    CUADRITO #17,#19,#15,#16,MenCuadrito
    MOVAB leerIns,R10
    CLRL contReg
    CLRL R6
    MOVAB registros,R7
    while:
    CMPL R6,long_registros
    BGEQ ewhile
         CLRB (R7)[R6]
         INCL R6
    BRW while
    ewhile:
    CLRL long_registros
    CLRL R6

    Do:
        LIMPIAR_PANTALLA #40, #11, #30 ,#9 , pantalla
        Rectangulo #80, #24, #1, #1, pantalla         ;grande 1
        Rectangulo #78, #22, #3, #2, pantalla         ;grande 2
        Write_DOB  #20,  #4,  negrita, Men14, pantalla
        Write #5, #10, negrita, MenRegistro  , pantalla
        NUM_STR contReg, desc_contReg
        Write #22, #10, negrita, desc_contReg, pantalla

        CLRL long_leerIns
        MOVL #9,desc_leerIns
        LEER long_leerIns, MenDosPuntos,desc_leerIns ;codigo nuevo

        MOVB #1,correcto
        CMPL long_leerIns,#1
        SALTAR EQL,else
                Write #5, #21, negrita,Men1Digito, pantalla
                CLRB correcto
                ReadKey Tecla,Teclado
                Write #5, #21, negrita,   MenLimpiar , pantalla
                SALTAR RW,endIf
        else:
                CMPB  (R10),#^A/0/
                BLSS then
                CMPB  (R10),#^A/9/
                BGTR then
                SALTAR RW,endIf
                then:
                Write #5, #21, negrita,Men1Digito, pantalla
                CLRB correcto
                ReadKey Tecla,Teclado
                Write #5, #21, negrita,   MenLimpiar , pantalla
        endIf:

        CMPB correcto,#1
        SALTAR NEQ,endIf2
                STR_NUM desc_leerIns,valorReg
                MOVB valorReg,(R7)[R6]
                INCL R6
                INCL contReg
                INCL long_registros
                LLENAR_CUADRITO registros,i,long_registros,valorReg,-
                                desc_valorReg,#-1,#18
        endIf2:

    ;While(R6<=9 or correcto==0)
    CMPL R6,#9
    SALTAR LEQ,Do
    TSTB correcto
    SALTAR EQL,Do
    ReadKey Tecla,Teclado
.ENDM LLENAR_REGISTROS

.MACRO EJECUTAR_INS leerIns,insGuardadas,desc_leerIns,long_insGuardadas-
                    ,i,registros,fil,contIns,long_registros,valorReg,-
                    desc_valorReg,-
                    ?while,?else,?else1,?else2,?division0,?endIf,?ewhile

    CUADRO
    Write_DOB  #20,  #4,  negrita, Men11, pantalla
    CUADRO_IMPRIMIR_INS leerIns,insGuardadas,desc_leerIns,long_insGuardadas,i
    CUADRO_INSTRUCCIONES
    CUADRITO #14,#16,#12,#13,MenCuadrito
    LLENAR_CUADRITO registros,i,long_registros,valorReg,-
                    desc_valorReg,#-1,#15
    Write #12, #23, inversa,   MenSalir3, pantalla

    MOVAB registros, R11
    MOVAB insGuardadas, R10
    MOVL #10,fil
    MOVL #4,R9
    CLRL R7
    CLRL R6
    MOVL contIns,R12
    while:
    ReadKey Tecla,Teclado
    CMPB Tecla, #^A/-/
    SALTAR EQL,ewhile
    TSTL R12
    SALTAR EQL,ewhile
        Write #60,fil,negrita,MenLimpiarFlecha, pantalla
        Write #8, #10, negrita, MenLimpiar3, pantalla
        INCL fil
        Write #60,fil,blink,MenFlecha, pantalla
        LLENAR_CUADRITO registros,i,long_registros,valorReg,-
                        desc_valorReg,#-1,#15
        SUBB3 #48,(R10)[R9],R7
        ADDL #2,R9
        SUBB3 #48,(R10)[R9],R6
        SUBL #6,R9

        CMPB (R10)[R9],#^A/A/
        BNEQ else
                ADDB (R11)[R7],(R11)[R6]
                SALTAR RW, endIf
        else:
        CMPB (R10)[R9],#^A/S/
        BNEQ else1
                SUBB (R11)[R7],(R11)[R6]
                SALTAR RW, endIf
        else1:
        CMPB (R10)[R9],#^A/M/
        BNEQ else2
                MULB (R11)[R7],(R11)[R6]
                SALTAR RW, endIf
        else2:
                TSTB (R11)[R7]
                BEQL division0
                        DIVB (R11)[R7],(R11)[R6]
                        BRW endIf
                division0:
                        Write #8,#10,negrita,MenDivision0,pantalla
        endIf:
        DECL R12
        ADDL #11,R9
        CUADRITO #19,#21,#17,#18,MenCuadrito2
        LLENAR_CUADRITO registros,i,long_registros,valorReg,-
                        desc_valorReg,R6,#20
        GOTOXY #69,#23
    SALTAR RW,while
    ewhile:
    MOVB #1,ejecutadas   ;las instrucciones fueron ejecutadas
.ENDM EJECUTAR_INS


.MACRO CUADRITO Fc,Ff,Fmen1,Fmen2,Mensaje
        Write #16,Fmen1, negrita,Mensaje, pantalla
        Write #9,Fmen2, negrita,MenCuadritoIndice, pantalla
        Rectangulo #11, Ff, #7,  Fc, pantalla
        Rectangulo #15, Ff, #11, Fc, pantalla
        Rectangulo #19, Ff, #15, Fc, pantalla
        Rectangulo #23, Ff, #19, Fc, pantalla
        Rectangulo #27, Ff, #23, Fc, pantalla
        Rectangulo #31, Ff, #27, Fc, pantalla
        Rectangulo #35, Ff, #31, Fc, pantalla
        Rectangulo #39, Ff, #35, Fc, pantalla
        Rectangulo #43, Ff, #39, Fc, pantalla
        Rectangulo #47, Ff, #43, Fc, pantalla
.ENDM CUADRITO

.MACRO LLENAR_CUADRITO registros,i,long_registros,valorReg,-
                        desc_valorReg,actualizar,Fc-
                        ?while,?endIf,?ewhile
        MOVAB registros, R11
        CLRL R8
        MOVB #8,i
        while:
        CMPL R8,long_registros
        SALTAR GEQ,ewhile
                MOVB (R11)[R8],valorReg
                NUM_STR valorReg,desc_valorReg
                Write i,Fc, negrita,   desc_valorReg, pantalla
                CMPL R8,actualizar
                BNEQ endIf
                       Write i,Fc,inversa,desc_valorReg,pantalla
                endIf:
                ADDL #4,i
                INCL R8
        BRW while
        ewhile:
.ENDM LLENAR_CUADRITO


;=====================SECCION DE CODIGO===============================
.PSECT Codigo, EXE,NOWRT,LONG
.ENTRY Libreria, 0
CLRL R9
;--------------------------PORTADA-----------------------------------
          CREA_TECLADO Teclado
          CREA_PIZARRON Pizarron
          CREAR_PANTALLA  Normal, Pantalla, #80, #24
          PEGAR_PANTALLA Pizarron, Pantalla
          opc1:Limpiar_pantalla #79, #24, #1, #1, Pantalla
          Rectangulo #81, #20, #1, #1, pantalla         ;grande 1
          Rectangulo #78, #20, #3, #2, pantalla         ;grande 2
          Rectangulo #80, #24, #1, #22, pantalla        ;pequeno
          Write #20, #4,  negrita, Men0, pantalla
          Write #15, #5,  negrita, Men1, pantalla
          Write #22, #6,  negrita, Men2, pantalla
          Write #22, #12, negrita, Men3, pantalla
          Write #50, #15, negrita, MenAutores, pantalla
          Write #50, #16, negrita, MenAutores1, pantalla
          Write #50, #17, negrita, MenAutores2, pantalla
          Write #50, #18, negrita, MenAutores3, pantalla
          Write #22, #23, blink, Men4, pantalla
          ReadKey Tecla, Teclado

;---------------------MENU--------------------------------
     pan2:Limpiar_pantalla #79, #24, #1, #1, Pantalla
          Rectangulo #81, #2,  #1, #1,    pantalla      ;grande 1
          Rectangulo #78, #20, #3, #2,    pantalla      ;grande 2
          Rectangulo #80, #24, #1, #22,   pantalla      ;pequeno
          Write #23, #23, blink,   MenMenu, pantalla
          Write #8,  #10, inversa, Men6, pantalla
          Write #12, #10, negrita, Men7, pantalla
          Write #38, #10, inversa, Men8, pantalla
          Write #42, #10, negrita, Men9, pantalla
          Write #8,  #12, inversa, Men10, pantalla
          Write #12, #12, negrita, Men11, pantalla
          Write_DOB  #37,  #4,  negrita, Men12, pantalla
          Write #38, #12, inversa, Men13, pantalla
          Write #42, #12, negrita, Men14, pantalla
          Write #8, #14, inversa, Men15, pantalla
          Write #12, #14, negrita, Men16, pantalla

 ;------------------------BOTONES----------------------------------
     ning:ReadKey Tecla, Teclado
          CMPB Tecla, #^A/1/
          SALTAR eql, opc1
          CMPB Tecla, #^A/2/
          SALTAR  eql, opc2
          CMPB Tecla, #^A/3/
          SALTAR eql, opc3
          CMPB Tecla, #^A/4/
          SALTAR eql, opc4
          CMPB Tecla, #^A/5/
          SALTAR eql, opc5
          jmp ning
    opc2:
          CMPL contIns,#limIns
          SALTAR EQL, limite
                LEER_INS long_leerIns,desc_leerIns,leerIns,correcto,contIns,-
                         desc_contIns,insGuardadas,long_insGuardadas,-
                         Blanco,ope,i,Teclasalir
          BRW endIf
          limite:
                Write #20, #21, negrita, MenLimiteInstrucciones, pantalla
                ReadKey tecla,teclado
          endIf:
          jmp pan2
    opc3:
          LLENAR_REGISTROS leerIns,contReg,registros,long_registros,desc_conReg,-
                           long_leerIns,desc_leerIns,correcto,i,valorReg,-
                           desc_valorReg
          jmp pan2
    opc4:
          TSTL contIns
          BEQL then
          TSTL long_registros
          BNEQ else
          then:
                Write #16, #21, negrita, MenValidacion, pantalla
                ReadKey tecla,teclado
                BRW endIf2
          else:
                EJECUTAR_INS leerIns,insGuardadas,desc_leerIns,long_insGuardadas-
                             ,i,registros,fil,contIns,long_registros,valorReg,-
                             desc_valorReg
          endIf2:
          jmp pan2
    opc5:Limpiar_pantalla #79, #24, #1, #1, Pantalla
          RET
.END Libreria