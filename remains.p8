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
  ; This is awkard. Maybe would be better to use a put the related
  ; chars within the same bit patter so a test like with
  ; "& 11111100" would work to identify stuff. Much faster than 3
  ; comparsions. Need better tool to rearrange chars.
  const ubyte REM_CHAR1 = $2B
  const ubyte REM_CHAR2 = $2A
  const ubyte REM_CHAR3 = $A0

  ; Remains go through stages of behavior look and behavior data array 
  ; contains sets of:
  ;   Screencode, Color, Trigger delay
  ubyte[] REMAINS_INFO = [
    $A0, colors.WHITE,  200, ; Shrinking due to hits
    $2B, colors.WHITE,  150, ; Actual start element 
    $2B, colors.YELLOW, 90,
    $2B, colors.ORANGE, 50,
    $2A, colors.RED,    30,
    $2A, colors.ORANGE, 10 ]
  const ubyte REM_CHAR  = 0
  const ubyte REM_COL   = 1
  const ubyte REM_DELAY = 2
  const ubyte REM_INFO_COUNT = 3
  const ubyte REM_INFO_MAX = 5 ; Index of last char/col info 

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
  ubyte j; Secondary loop variable (reduce variable use)
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
        remainsRef[GR_COUNTDOWN] = REMAINS_INFO[REM_INFO_COUNT + REM_DELAY] ; Set start countdown
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

	; Need to check for status change
	if count == 0 {
	  drop_bomb.create( remainsRef[GR_X], remainsRef[GR_Y] )
	} else {
	  check_deterioration(count)
	}
      }

      remainsRef += FIELD_COUNT
      i++
    }
  }

  ; Need to check if we change look
  sub check_deterioration(ubyte count) {
      j = 0;
      uword remInfo = &REMAINS_INFO
      while( j <= REM_INFO_MAX ) {
        if count == remInfo[REM_DELAY] {
	  txt.setcc( remainsRef[GR_X], remainsRef[GR_Y], remInfo[REM_CHAR],
	  remInfo[REM_COL] )
	  
	  return
	}

        remInfo += REM_INFO_COUNT
        j++
      }   
  }

  sub bullet_hit(ubyte x, ubyte y) {
      ; First find what we hit
      remainsRef = &remainsData
      i = 0
      while( i < MAX_REMAINS ) {
        ubyte count = remainsRef[GR_COUNTDOWN]
	if count > 0 { ; Only look at active "elements"
	  ; Have we found it
	  if x == remainsRef[GR_X] and y == remainsRef[GR_Y] {
	    count += 30
	    if count > 220 {
	       ; remains deleted
	       remainsRef[GR_COUNTDOWN] = 0;
	       gamescreen.clear(x, y)
	    } else {
	      remainsRef[GR_COUNTDOWN] = count
	      ; Color adjust?
	      
	    }
	    return
	  }
	}
	remainsRef += FIELD_COUNT
      }
      ; we should not end up here (i.e we SHOULD find one of the "remains"
      ; parts 
  }

}

