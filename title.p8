title {

rawdata:
  %asmbinary "title.bin"

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
