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

  ; Copy data from data blob into Screen/Color ram
  sub draw() {
    uword charPtr = &rawdata
    uword colPtr = charPtr + 1000

    uword screenPtr = c64.Screen
    uword colorPtr = c64.Colors

    uword i
    for i in 1 to 1000 {
      screenPtr[0] = charPtr[0]
      colorPtr[0] = colPtr[0]
      screenPtr++
      colorPtr++
      charPtr++
      colPtr++
    }
  }
}
