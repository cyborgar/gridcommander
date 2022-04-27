;
; Draw and move bullets
;

bullets {
  const ubyte BULLET_CHAR = $90
  const ubyte BULLET_COLOR = colors.YELLOW

  ; Need to differentiate between max "fired shots" and max number
  ; of tracked bullets since we want to have upgrades that can fire
  ; in multiple directions
  const ubyte MAX_SHOTS = 2
  const ubyte MAX_BULLETS = 8 ; Allow shots in 4 directions
  
  const ubyte BD_ON = 0  ; active ?
  const ubyte BD_DIR = 1 ; direction (0=up, 1=right, 2=down, 3=right)
  const ubyte BD_X = 2   ; grid x pos
  const ubyte BD_Y = 3   ; grid y pos
  const ubyte FIELD_COUNT = 4

  ubyte[FIELD_COUNT * MAX_BULLETS] bulletData ; Data structre for bullets
  uword bulletRef; Global reference to current bullet (save param passing)

  ubyte current_max_shots = 2
  ubyte active_shots = 0

  sub init() {
    ; Default start 
    active_shots = 0
    sys.memset(&bulletData, FIELD_COUNT * MAX_BULLETS, 0)
  }

  ; Initially just one bullet going upward
  sub trigger(ubyte x, ubyte y) {
    if active_shots == current_max_shots ; All used
      return

    bulletRef = &bulletData
    ubyte i = 0
    while i < MAX_BULLETS {
      if bulletRef[BD_ON] == false { ; Find first "free" bullet
        bulletRef[BD_ON] = true
        bulletRef[BD_DIR] = 0
        bulletRef[BD_X] = x
        bulletRef[BD_Y] = y
        draw()
        active_shots++
        return; We can stop here
      }
      bulletRef += FIELD_COUNT
      i++
    }

  }

  sub clear() {
    txt.setcc(bulletRef[BD_X], bulletRef[BD_Y], 
              gamescreen.BCK_CHAR, gamescreen.BCK_COLOR)
  }

  sub draw() {
    txt.setcc(bulletRef[BD_X], bulletRef[BD_Y], BULLET_CHAR, BULLET_COLOR)
  }

  sub move() {
    bulletRef = &bulletData
    ubyte i = 0
    while i < MAX_BULLETS {
      if bulletRef[BD_ON] == true {
        clear() ; Clear old position
        bulletRef[BD_Y]--;
        if bulletRef[BD_Y] == base.UBORDER { ; Hit top border
          bulletRef[BD_ON] = false
          active_shots--
        } else {       
          ; Hit something?
          if txt.getchr( bulletRef[BD_X], bulletRef[BD_Y] )
               != gamescreen.BCK_CHAR {
	    ; Check what we hit
	    ; Can just hit snake right now, but should check more
            snake.bullet_hit( bulletRef[BD_X], bulletRef[BD_Y] ) ; Handle snake hit
            bulletRef[BD_ON] = false
            active_shots--
          } else {
            draw()
          }
        }
      }
      bulletRef += FIELD_COUNT
      i++
    }
  }

}
