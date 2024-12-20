;
; Horizontal "snake" enemy (at least for now)
;
; Enemy originates "outside" playfield and may need negative x/y position
; values. Each elements is handled "separately" since snakes are split
; when hit (unless it's the first or last element)
;

%import remains

snake {
  ubyte[] SNAKE_CHARS = [$89, $8A]
  ubyte[] SNAKE_COLOR = [colors.LIGHT_GREEN, colors.GREEN]

  byte[] x_mv = [ 0, 1, 0, -1 ]
  byte[] y_mv = [ -1, 0, 1, 0 ]

  const ubyte SN_ON     = 0 ; Enemy element active?
  const ubyte SN_DIR    = 1 ; Current movement direction (0=up, 1=right etc.)
  const ubyte SN_X      = 2 ; X position
  const ubyte SN_Y      = 3 ; Y position
  const ubyte SN_DURAB  = 4 ; Allow some enemy elements to higher durability ? For later
  const ubyte FIELD_COUNT = 5

  ; Max number of snake components
  const ubyte ENEMY_COUNT = 10 

  ; Will need to cast SN_X and SN_Y to byte later to deal with neg values
  ubyte[FIELD_COUNT * ENEMY_COUNT] snakeData

  uword snakePartRef ; Point to part of snake (avoid passing parameter)

  ; Clear data 
  sub init() {
     sys.memset(&snakeData, FIELD_COUNT * ENEMY_COUNT, 0)
  }

  ; Deplying enemy parts outside game field. Need to not draw if this is the case
  ; Avoids separate separate "visible" field. Though the SN_DELAY may be a possibility 
  ; to use as well.
  sub create_snake() {
    ubyte x = base.RBORDER + 1

    snakePartRef = &snakeData
    repeat ENEMY_COUNT {
      snakePartRef[SN_ON] =    1 ; Active
      snakePartRef[SN_DIR] =   3    ; Go left
      snakePartRef[SN_X] =     x    ; Postion from par (Can be negative later)
      snakePartRef[SN_Y] = base.UBORDER + 1 ; Fixed deplyment y pos
      snakePartRef[SN_DURAB] = 1     ; Just 1 hit to kill
      snakePartRef += FIELD_COUNT
      x++
    }
  }

  sub move_all() {
    snakePartRef = &snakeData
    repeat ENEMY_COUNT {
      if snakePartRef[SN_ON] == 1 {
        ubyte x = snakePartRef[SN_X]
        ubyte y = snakePartRef[SN_Y]
        ubyte dir = snakePartRef[SN_DIR]
        ; Within plafield
        if  x > base.LBORDER and x < base.RBORDER {
          ubyte nx
          ubyte ny

          gamescreen.clear(x, y)
          nx = ( x + x_mv[dir] ) as ubyte
          ny = ( y + y_mv[dir] ) as ubyte
          ubyte chr = txt.getchr(nx, ny)
          when chr {
             gamescreen.BCK_CHAR -> {
               snakePartRef[SN_X] = nx
               snakePartRef[SN_Y] = ny
            }
            gamescreen.WALL_LEFT  -> { 
              snakePartRef[SN_Y]++ 
              if snakePartRef[SN_Y] == base.BBORDER {
                snakePartRef[SN_Y] -= 10
                snakePartRef[SN_X] = base.RBORDER - 1
              } else {
                snakePartRef[SN_DIR] = 1
              }
            }
            gamescreen.WALL_RIGHT -> {
              snakePartRef[SN_Y]++ 
              if snakePartRef[SN_Y] == base.BBORDER {
                snakePartRef[SN_Y] -= 10
                snakePartRef[SN_X] = base.LBORDER + 1
              } else {
                snakePartRef[SN_DIR] = 3
              }
            }
            remains.REM_CHAR1, remains.REM_CHAR2, remains.REM_CHAR3 -> { ; We hit a existing "bomb", need to move down
              snakePartRef[SN_Y]++ 
              if snakePartRef[SN_DIR] == 3 {
                snakePartRef[SN_DIR] = 1
              } else {
                snakePartRef[SN_DIR] = 3
              }
	      ; Is new location occupied?
	      chr = txt.getchr(x, y+1)
	      while (chr == remains.REM_CHAR1 or chr == remains.REM_CHAR2 or chr == remains.REM_CHAR3) {
                snakePartRef[SN_Y]++ ; Skip another level down
                y++
                chr = txt.getchr(x, y+1)
              }
            }
          }
          draw( snakePartRef[SN_X], snakePartRef[SN_Y] )
        } else { ; Outside visible borders? Move, but don't display yet
          snakePartRef[SN_X] = (x + x_mv[dir]) as ubyte
          snakePartRef[SN_Y] = (y + y_mv[dir]) as ubyte
          if snakePartRef[SN_X] > base.LBORDER and snakePartRef[SN_X] < base.RBORDER {
            draw( snakePartRef[SN_X], snakePartRef[SN_Y] )
          }
        }
      }

      snakePartRef += FIELD_COUNT
    }
  }

  sub draw( ubyte x, ubyte y ) {
    txt.setcc(x, y, SNAKE_CHARS[0], SNAKE_COLOR[0] )
  }

  ; loop through parts to find hit "bit"
  sub bullet_hit( ubyte hx, ubyte hy ) {
    snakePartRef = &snakeData
    repeat ENEMY_COUNT { ; Find right part
      ubyte x = snakePartRef[SN_X]
      ubyte y = snakePartRef[SN_Y]

      if x == hx and y == hy {
        snakePartRef[SN_ON] = 0 ; Part was "destroyed"
	main.add_score(10)

        ; Covert to a "grenade" 
        remains.add(x,y);
        return
      }

      snakePartRef += FIELD_COUNT
    }
  }
}