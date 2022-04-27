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

  sub clear() {
    txt.setcc(x, y, gamescreen.BCK_CHAR, gamescreen.BCK_COLOR)
  }

  sub up() {
    clear()
    if y > base.UBORDER + 1 {
      y--
    }
    if check_collision()
      y++
    draw()
  }

  sub right() {
    clear()
    if x < base.RBORDER - 1 {
      x++
    }
    if check_collision()
      x--
    draw()
  }

  sub down() {
    clear()
    if y < base.BBORDER - 1 {
      y++
    }
    if check_collision()
      y--
    draw()
  }

  sub left() {
    clear()
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
  sub check_collision() -> ubyte {
    ubyte hit_char = txt.getchr(x, y)
    if hit_char != gamescreen.BCK_CHAR { ; Hit something
      if hit_char == $2b
        return 1

      ; explode ship
      ; destroy offending "unit"
      ; deduct life
      ; if more lives
      ;   reset start of player
      ; else
      ;   end game
    }

    return 0
  }

}