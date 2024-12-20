; Hit snake part should eventually turns into a drop bomb

drop_bomb {

  const ubyte BOMB_CHAR = $3D
  const ubyte BOMB_COLOR = colors.LIGHT_GREEN

  const ubyte BOMB_ON     = 0 ; Grenade countdown, 0 doubles as off
  const ubyte BOMB_X      = 1 ; X position
  const ubyte BOMB_Y      = 2 ; Y position
  const ubyte FIELD_COUNT = 3

  ; Max number of bombs allowed
  const ubyte MAX_BOMBS = 10 ; same as snake.ENEMY_COUNT for now

  ; Array with Bomb data
  ubyte[FIELD_COUNT * MAX_BOMBS] bombData;

  ubyte active_bombs;

  sub init() {
     ; Default start
    active_bombs = 0
    sys.memset( &bombData, FIELD_COUNT * MAX_BOMBS, 0)
  }

  sub create( ubyte x, ubyte y ) {
      txt.setcc( x, y, BOMB_CHAR, BOMB_COLOR )
  }

  sub move() {
    
  }
}
