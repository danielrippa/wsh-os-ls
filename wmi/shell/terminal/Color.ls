
  do ->

    { sgr } = dependency 'terminal.Control'

    reset = -> sgr [ 0 ]

    #

    c4 = (type, color) -> sgr [ type * 10 + color ]

    fg4 = -> c4 3, it
    bg4 = -> c4 4, it

    #

    c8 = (type, color) -> sgr [ (type * 10) + 8, 5, color ]

    c8-hi = (type, color) -> c8 type, color + 8

    rgb216 = (r, g, b) -> (r * 36) + (g * 6) + (b) |> (+ 16)

    c8-rgb = (type, r, g, b) -> c8 type, rgb216 r, g, b

    c8-gray = (type, level) -> c8 type, level + 232

    fg8 = -> c8 3, it
    bg8 = -> c8 4, it

    fg8-hi = -> c8-hi 3, it
    bg8-hi = -> c8-hi 4, it

    fg8-rgb = (r, g, b) -> c8-rgb 3, r, g, b
    bg8-rgb = (r, g, b) -> c8-rgb 4, r, g, b

    fg8-gray = -> c8-gray 3, it
    bg8-gray = -> c8-gray 4, it

    #

    c24 = (type, r, g, b) -> sgr [ (type * 10) + 8, 2, r, g, b ]

    fg24 = (r, g, b) -> c24 3, r, g, b
    bg24 = (r, g, b) -> c24 4, r, g, b

    {
      reset,
      c4, fg4, bg4,
      c8, c8-hi, c8-gray, fg8, bg8, fg8-hi, bg8-hi, fg8-rgb, bg8-rgb, fg8-gray, bg8-gray,
      c24, fg24, bg24
    }