colors {

  const ubyte BLACK = 0
  const ubyte WHITE = 1
  const ubyte RED = 2
  const ubyte CYAN = 3
  const ubyte PURPLE = 4
  const ubyte GREEN = 5
  const ubyte BLUE = 6
  const ubyte YELLOW = 7
  const ubyte ORANGE = 8
  const ubyte BROWN = 9
  const ubyte PINK = 10
  const ubyte DARK_GREY = 11
  const ubyte MIDDLE_GREY = 12
  const ubyte LIGHT_GREEN = 13
  const ubyte LIGHT_BLUE = 14
  const ubyte LIGHT_GREY = 15

  const ubyte PULSE_SIZE = 20

  ; Gradual blue to white transition
  ubyte[] blue_pulse = [BLUE, LIGHT_BLUE, LIGHT_BLUE, CYAN, CYAN, CYAN,
      WHITE, WHITE, WHITE, WHITE, CYAN, CYAN, CYAN, LIGHT_BLUE,
      LIGHT_BLUE, BLUE, BLUE, BLACK, BLACK, BLACK]

  ; Jagged red/brown to yellow/white shimmer
  ubyte[] o_pulse = [ BLACK, RED, RED, PINK, WHITE, WHITE, BLACK, BROWN, ORANGE, YELLOW,
      BLACK, RED, RED, PINK, WHITE, BLACK, BROWN, ORANGE, YELLOW, YELLOW ]


}
