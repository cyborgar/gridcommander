;
; The base playfield data is loaded from binary file. Char and color data
; each take a 1000 bytes.
;
gamescreen {

rawdata:
  %asmbinary "playfield.bin"

  const ubyte BCK_CHAR = $5B ; Our "empty" char inside play field
  const ubyte BCK_COLOR = colors.BLUE

  const ubyte WALL_TOP = $F2
  const ubyte WALL_LEFT = $EB
  const ubyte WALL_RIGHT = $F3
  const ubyte WALL_BOTTOM = $F1

  sub init() {
    draw_playfield()
    printScore()
  }

  ; Copy data from data blob into Screen/Color ram
  sub draw_playfield() {
    uword charPtr = &rawdata
    uword colPtr = charPtr + 1000

    uword screenPtr = cbm.Screen
    uword colorPtr = cbm.Colors

    repeat 1000 {
      screenPtr[0] = charPtr[0]
      colorPtr[0] = colPtr[0]
      screenPtr++
      colorPtr++
      charPtr++
      colPtr++
    }
  }

  sub printScore() {
    conv.str_uw0(main.score)
    ubyte i
    for i in 0 to 4 {
      txt.setcc( 30 + i, 0, conv.string_out[i], 1)
    }
  }

}
