;   Hello World GB
; Josh Beard, 2018
; github.com/jlbeard84
; Adapted from https://gb-archive.github.io/salvage/tutorial_de_ensamblador/

INCLUDE "gbhw.inc"

SECTION "start",HOME[$0100]
    nop
    jp  appstart

; ROM header as defined in gbhw.inc
    ROM_HEADER  ROM_NOMBC, ROM_SIZE_32KBYTE, RAM_SIZE_0KBYTE

; app starts here
appstart:
    nop
    di                    ; disabled interrupts
    ld  sp, $ffff         ; top of ram

initializtion:
    ld   a, %11100100     ; palette colors darkest to lightest
    ld   [rBGP], a        ; write in palette register
    ld   a, 0             ; write 0 records scroll x,y
    ld   [rSCX], a        ; positioned visible screen
    ld   [rSCY], a        ; at the upper left of ram
    call lcd_off

    ; load tile in ram
    ld   hl, TileMap      ; DL loaded tile
    ld   de, _VRAM        ; address in vram
    ld   b, 16            ; b = 16, number of bytes to copy

.loop_load:
    ld   a, [hl]           ; load to data pointed by HL
    ld   [de], a           ; and insert address pointed in DE
    dec  b                
    jr   z, .end_loop_load ; if b==0, finished
    inc  hl                ; read direction ++
    inc  de                ; write direction ++
    jr   .loop_load        ; restart loop

.end_loop_load:
    ; render tiles
    ld   hl, _SCRN0        ; HL to background
    ld   [hl], $00         ; $00 = tile 0

    ; configure display
    ld   a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ8|LCDCF_OBJOFF
    ld   [rLCDC], a

loop:
    halt
    nop
    jr   loop

lcd_off:
    ld   a, [rLCDC]
    rlca                  ; sets high bit of LCFC in carry flag
    ret  nc               ; already off again

.wait_vblank
    ld   a, [rLY]
    cp   145
    jr   nz, .wait_vblank

    ; in vblank turn off lcd
    ld   a, [rLCDC]
    res  7, a             ; 0 bit 7 on LCD
    ld   [rLCDC], a       ; write a into LCDC
    ret

;tile data
TileMap:
    DB  $7C, $7C, $82, $FE, $82, $D6, $82, $D6
    DB  $82, $FE, $82, $BA, $82, $C6, $7C, $7C
EndTileMap: