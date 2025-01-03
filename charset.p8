; Load new character set from bin file at $3000

charset $3000 {

raw:
  %asmbinary "chardata.bin"

  const uword CHARSET = $3000 ; Copied "const ubyte" doesn't like %raw (uword)
  	      	      	      ; Fix later to have extra label?

  ; activate the new charset in RAM
  sub load() {
    ubyte block = c64.CIA2PRA
    const ubyte PAGE1 = ((cbm.Screen >> 6) & $F0) | ((CHARSET >> 10) & $0E)
    c64.CIA2PRA = (block & $FC) | (lsb(cbm.Screen >> 14) ^ $03)
    c64.VMCSB = PAGE1
  }
}
