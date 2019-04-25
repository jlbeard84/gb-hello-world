INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]

EntryPoint: 
    di ; Disable interrupts
    jp Start ;

REPT $150 - $104
    db 0
ENDR

SECTION "Game code", ROM0

Start:
    ; turn off the LCD
.waitVBlank
    ld a, [rLY]
    cp 144 ; check if the lcd is past blank
    jr c, .waitVBlank

    xor a ; ld a, 0 ; set up for copying font data to vram
    ld [rLCDC], a

    ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles
.copyFont
    ld a, [de] ; one byte from the source
    ld [hli], a ; increment hl
    inc de ; move counter
    dec bc ; dec remaining count
    ld a, b ; put b into a to check if there are any bytes remaning
    or c
    jr nz, .copyFont
