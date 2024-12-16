; C64 joystic support through
;   c64.CIA1PRA (port 2)
; a second joystick would use c64.CIA1PRB (port 1)
;
; Reverse bit pattern set, so we use EOR 255 to reverse
;
; Bit	  Function
;  0	    Up
;  1      Down
;  2      Left
;  3      Right
;  4	    Fire
;
; In addition to testing specific direction we can also get the bit value
; useful if diagonal movement is required. The values can 
;
;             1
;         9       5
;        8         4
;         10      6
;             2
;
joystick {

  ubyte joy_info

  sub init() {
    joy_info = 0
  }

  sub pull_info() {
    joy_info = c64.CIA1PRA ^ 255  
  }

  sub pushing_up() -> bool {
    return joy_info & 1 > 0
  }

  sub pushing_down() -> bool {
    return joy_info & 2 > 0
  }

  sub pushing_left() -> bool {
    return joy_info & 4 > 0
  }

  sub pushing_right() -> bool {
    return joy_info & 8 > 0
  }

  sub pushing_fire() -> bool {
    return joy_info & 16 > 0
  }

  sub direction_value() -> ubyte {
    return joy_info & 15
  }
}
