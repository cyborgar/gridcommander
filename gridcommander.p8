%import syslib
%import textio

%import base
%import colors
%import charset
%import title
%import gamescreen
%import ship
%import snake

main {

  ; main variables
  uword score
  ubyte current_stage
  ubyte player_lives
  uword wave_ticks

  ; player move variables
  ubyte player_speed = 4
  ubyte player_sub_counter

  ; bullet move variables
  ubyte bullet_frequency ; Controll frequency between shots
  ubyte bullet_speed = 2
  ubyte bullet_sub_counter

  ; remains move variables
  ubyte remains_speed = 3
  ubyte remains_sub_counter

  ; enemy move variables
  ubyte enemy_speed = 6
  ubyte enemy_sub_counter

  sub start() {
    base.platform_setup()
    charset.load()

    repeat {
      game_title()
      game_loop()
      game_end()
    }
  }

  sub game_title() {
    title.draw()
;    usage.setup()  ; Add control info etc. here maybe

    ; Add startup delay to prevent "start" button press from
    ; immediately trigger start of game
    sys.wait(50)

    wait_key( 32, ">>> press start or space to begin <<<", 1, 23,
             &colors.o_pulse, 1);
  }

  sub game_loop() {
    gamescreen.init()

    ; Use to identify diagonal movement since this need to be "slower" for
    ; diagonal movement feel natural.
    ubyte move_count

    player_lives = 3
    score = 0
    current_stage = 0
    bullet_frequency = 0

    player_sub_counter = 0
    bullet_sub_counter = 0
    enemy_sub_counter = 0
    remains_sub_counter = 0

    ship.init()
    bullets.init()
    snake.init()
    remains.init()

    snake.create_snake()

    repeat {
      ubyte time_lo = lsb(c64.RDTIM16())

      ; May needed to find a better timer
      if time_lo >= 1 {
        c64.SETTIM(0,0,0)
        wave_ticks++

        ; Move bullets
        bullet_sub_counter++
        if bullet_sub_counter == bullet_speed {
          bullets.move()
          bullet_sub_counter = 0
        }

        ; Move remains
        remains_sub_counter++
        if remains_sub_counter == remains_speed {
          remains.do_countdowns()
          remains_sub_counter = 0
        }

        ; Player movement
        player_sub_counter++
        move_count = 0
        if player_sub_counter == player_speed {
          ; Check joystick
          joystick.pull_info()

          if joystick.pushing_fire() {
            if bullet_frequency == 0 {
              ship.fire()
              bullet_frequency = 3
            } else
              bullet_frequency--
          }
	
          ; This joystick code isn't very efficient when we can move in
	  ; both planes. At worst all 4 calls may be called. Consider
	  ; rewrite that returns single value (joystick.direction_value)
	  ; and use array to look up delay counter and x/y movements.

          if joystick.pushing_left() {
            ship.left()
            move_count++
          } else if joystick.pushing_right() {
            ship.right()
            move_count++
          }

          if joystick.pushing_up() {
            ship.up()
            move_count++
          } else if joystick.pushing_down() {
            ship.down()
            move_count++
          }

          ; Check keyboard
          ubyte key = c64.GETIN()
      	  when key {
            'w' -> ship.up()
            'd' -> ship.right()
            's' -> ship.down()
            'a' -> ship.left()
            ' ' -> ship.fire()
		      }

          ; Reduce move counter if we are moving in one plane only, we
          ; don't want have diagonal movement faster
          if ( move_count == 1) {
            player_sub_counter = 1
          } else {
            player_sub_counter = 0
          }
        }

        ; Enemy movement
        enemy_sub_counter++
        if enemy_sub_counter == enemy_speed {
          snake.move_all()
          enemy_sub_counter = 0
        }
      }
    }
  }

  sub game_end() {
  }

  sub wait_key(ubyte key, uword strRef, ubyte x, ubyte y,
               uword colorRef, ubyte do_usage) {
    ubyte time_lo = lsb(c64.RDTIM16())
    ubyte color = 0

    ubyte inp = 0
    while inp != key {
       inp = c64.GETIN()
       if time_lo >= 2 {
         c64.SETTIM(0,0,0)
         write( colorRef[color], x, y, strRef )
         color++
         if color == colors.PULSE_SIZE {
           color = 0
;           if do_usage
;             usage.draw()
         }
       }
       ; Let's also check joystick start (up)
       joystick.pull_info()
       if joystick.pushing_up()
         return

       time_lo = lsb(c64.RDTIM16())
    }
  }

  sub write(ubyte color, ubyte x, ubyte y, uword messageptr) {
    txt.color(color)
    txt.plot( x, y )
    txt.print( messageptr )
  }

  sub add_score(uword points) {
    score += points

    ; Add new life counter?
    gamescreen.printScore()
  }

}
