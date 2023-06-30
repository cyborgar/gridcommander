title {

rawdata:
  %asmbinary "title.bin"

  sub draw() {
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

}
