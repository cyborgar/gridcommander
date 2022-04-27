%import sound
%import joystick

base {

  ; Define playfield limits
  ; Note that these are the "border" part and the actual playfield
  ; is inside these limits 
  const ubyte LBORDER = 0
  const ubyte RBORDER = 39
  const ubyte UBORDER = 2
  const ubyte BBORDER = 24

  ; Not needed on C64
  sub platform_setup() {
    c64.EXTCOL = $c
    sound.init()
  }

  ; Not needed on C64
  sub draw_extra_border() {
  }

}
