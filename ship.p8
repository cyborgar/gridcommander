; 
; Draw, move and handle the player ship
;

%import bullets

ship {
  const ubyte SHIP_CHAR = $8B
  const ubyte SHIP_COLOR = colors.WHITE

  ubyte x
  ubyte y
  ubyte direction; 0-3 = up, right, down, left

  ; Init ship
  sub init() {
    ; Default start position
    x = ( base.RBORDER - base.LBORDER) / 2
    y = base.BBORDER - 6
    draw()
  }

  sub draw() {
    txt.setcc(x, y, SHIP_CHAR, SHIP_COLOR)
  }

  sub up() {
    gamescreen.clear(x, y)
    if y > base.UBORDER + 1 {
      y--
    }
    if check_collision()
      y++
    draw()
  }

  sub right() {
    gamescreen.clear(x, y)
    if x < base.RBORDER - 1 {
      x++
    }
    if check_collision()
      x--
    draw()
  }

  sub down() {
    gamescreen.clear(x, y)
    if y < base.BBORDER - 1 {
      y++
    }
    if check_collision()
      y--
    draw()
  }

  sub left() {
    gamescreen.clear(x, y)
    if x > base.LBORDER + 1 {
      x--
    }
    if check_collision()
      x++
    draw()
  }

  ; Will have to check collision before "deploying" bullets.
  ; Could replace border check?
  ; What about hitting "laser"?
  sub fire() {
;    if main.stage_start_delay ; No bullets in stage end/start
;      return
    if y == base.UBORDER + 1 ; Don't fire when at the top
      return
    bullets.trigger(x, y-1)
    sound.fire()
  }

  ; Check for collision with anything. Note that walls are already handled
  sub check_collision() -> bool {
    ubyte hit_char = txt.getchr(x, y)
    if hit_char != gamescreen.BCK_CHAR { ; Hit something
      if hit_char == remains.REM_CHAR1 or hit_char == remains.REM_CHAR2 or hit_char == remains.REM_CHAR3
        return true

      ; explode ship
      ; destroy offending "unit"
      ; deduct life
      ; if more lives
      ;   reset start of player
      ; else
      ;   end game
    }

    return false
  }

}