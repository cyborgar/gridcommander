; Handle the "grenade" type of remains left after shooting the snake.
;
; Note that we could potentially use ring buffer to efficiently handle
; the bomblets but this partially breaks if we allow shooting remains etc.
; though this depends on how this mechanism will work.
;
; TODO :
;  - what happens when remains are hit by bullet?
;

%import colors
%import drop_bomb

remains {

  const ubyte REMAINS_CHAR = $2B

  ; Remains go through stages of behavior look and behavior data array 
  ; contains sets of:
  ;   Screencode, Color, Trigger delay
  ubyte[] REMAINS_INFO = [
    $2B, colors.WHITE,  150, ; First element set max countdown
    $2B, colors.YELLOW, 90,
    $2B, colors.ORANGE, 50,
    $2A, colors.RED,    30,
    $2A, colors.ORANGE, 10,
    $3D, colors.YELLOW, 0 ]
  const ubyte REM_CHAR  = 0
  const ubyte REM_COL   = 1
  const ubyte REM_DELAY = 2

  const ubyte REMAINS_SAFE = 2; Not explosive yet
  const ubyte REMAINS_DROP = 5; When remains drop
  const ubyte REMAINS_LAST = 5; Last element

  const ubyte GR_COUNTDOWN = 0 ; Grenade countdown, 0 doubles as off
  const ubyte GR_X         = 1 ; X position
  const ubyte GR_Y         = 2 ; Y position
  const ubyte GR_STAGE     = 3 ; Progress in behavior
  const ubyte FIELD_COUNT  = 4

  ; Max number of "remains" are same as total snake elements
  const ubyte MAX_REMAINS = 10 ; same as snake.ENEMY_COUNT

  ubyte[FIELD_COUNT * MAX_REMAINS] remainsData;

  ubyte i; Module loop counter (reduce variable use)
  uword remainsRef ; Point to remains object (avoid parm passing)

  ; Clear data
  sub init() {
    sys.memset(&remainsData, FIELD_COUNT * MAX_REMAINS, 0)
  }

  sub add(ubyte x, ubyte y) {
    ; Initial "bomb" is white
    txt.setcc( x, y, REMAINS_INFO[REM_CHAR], REMAINS_INFO[REM_COL] )

    ; Find free remains position
    i = 0
    remainsRef = &remainsData
    while ( i < MAX_REMAINS ) {
      if remainsRef[GR_COUNTDOWN] == 0 {
        remainsRef[GR_COUNTDOWN] = REMAINS_INFO[REM_DELAY] ; Set max countdown
        remainsRef[GR_X] = x
        remainsRef[GR_Y] = y

	return
      }

      remainsRef += FIELD_COUNT
      i++
    }
    
  }

  ; Loop over all active remains and change state/trigger bomb
  sub do_countdowns() {
    i = 0
    remainsRef = &remainsData
    while ( i < MAX_REMAINS ) {
      ubyte count = remainsRef[GR_COUNTDOWN]
      if count > 0 {
        count--
        remainsRef[GR_COUNTDOWN] = count
        when count {
         0 -> drop_bomb.create( remainsRef[GR_X], remainsRef[GR_Y] )
         30 -> txt.setclr( remainsRef[GR_X], remainsRef[GR_Y], colors.RED )
         80 -> txt.setclr( remainsRef[GR_X], remainsRef[GR_Y], colors.ORANGE )
         150 -> txt.setclr( remainsRef[GR_X], remainsRef[GR_Y], colors.YELLOW )
        }
      }

      remainsRef += FIELD_COUNT
      i++
    }

  }

}