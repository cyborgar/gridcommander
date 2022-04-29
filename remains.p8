; Handle the "grenade" type of remains left after shooting the snake.
;
; Note that we could potentially use ring buffer to efficiently handle
; the bomblets but this partiall breaks if we allow shooting remains etc.
; though this depends on how this mechnaism will work.
;
; TODO :
;  - what happens when remains are hit by bullet?
; 
remains {

  const ubyte REMAINS_CHAR = $2B

  const ubyte GR_COUNTDOWN = 0 ; Grenade countdown, 0 doubles as off
  const ubyte GR_X         = 1 ; x position
  const ubyte GR_Y         = 2 ; Y position
  const ubyte FIELD_COUNT  = 3

  ; Max number of "remains" are same as total snake elements
  const ubyte REMAINS_COUNT = 10 ; same as snake.ENEMY_COUNT

  ubyte[FIELD_COUNT * REMAINS_COUNT] remainsData;

  ubyte i; Module loop counter (reduce variable use)
  uword remainsRef ; Point to remains object (avoid parm passing)

  ; Clear data
  sub init() {
    sys.memset(&remainsData, FIELD_COUNT * REMAINS_COUNT, 0)
  }

  sub add(ubyte x, ubyte y) {
    ; Initial "bomb" is white
    txt.setcc( x, y, REMAINS_CHAR, colors.WHITE )

    ; Find free remains position
    i = 0
    remainsRef = &remainsData
    while ( i < REMAINS_COUNT ) {
      if remainsRef[GR_COUNTDOWN] == 0 {
        remainsRef[GR_COUNTDOWN] = 150 ; Set max countdown
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
    while ( i < REMAINS_COUNT ) {
      ubyte count = remainsRef[GR_COUNTDOWN]
      if count > 0 {
        count--
        remainsRef[GR_COUNTDOWN] = count
        when count {
	  0 -> explode()
         10 -> txt.setclr( remainsRef[GR_X], remainsRef[GR_Y], colors.RED )
         30 -> txt.setclr( remainsRef[GR_X], remainsRef[GR_Y], colors.ORANGE )
         70 -> txt.setclr( remainsRef[GR_X], remainsRef[GR_Y], colors.YELLOW )
        }
      }

      remainsRef += FIELD_COUNT
      i++
    }

  }

  sub explode() {
      txt.setcc( remainsRef[GR_X], remainsRef[GR_Y], 
      		 gamescreen.BCK_CHAR, gamescreen.BCK_COLOR )
  }
}