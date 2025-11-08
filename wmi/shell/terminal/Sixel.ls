
  do ->

    { dcs } = dependency 'terminal.Control'
    { code-units-as-string } = dependency 'unsafe.String'
    { floor, round } = dependency 'unsafe.Number'
    { is-hsl, hsl-as-rgb } = dependency 'color.Hsl'
    { clone } = dependency 'unsafe.Object'
    { map-items, take-items-while } = dependency 'unsafe.Array'

    # https://vt100.net/docs/vt3xx-gp/chapter14.html

    color-spaces = hsl: 1, rgb: 2

    is-predefined-sixel-color-index = (index) ->

      match index, index

        | (>=   0), (<=  15) => yes # primary
        | (>= 232), (<= 255) => yes # grayscale

        else no

    normalize-by = (value, factor) -> value |> (/ 255) |> (* factor) |> floor

    value-as-sixel-level = -> it `normalize-by` 5

    primary-colors = <[
      0,0,0        128,0,0  0,128,0  128,128,0  0,0,128  128,0,128  0,128,128  192,192,192
      128,128,128  255,0,0  0,255,0  255,255,0  0,0,255  255,0,255  0,255,255  255,255,255
    ]>

    rgb-as-primary-color-sixel-index = ({ r, g, b }) -> primary-colors `item-index` ([ r, g, b ] * ',')

    is-primary-color = -> (rgb-as-primary-color-sixel-index it)?

    is-grayscale-color = ({r, g, b}) -> (r is g) and (g is b) and (b is r)

    rgb-as-grayscale-color-sixel-index = ({ r }) -> r `normalize-by` 23 |> (+ 232)

    rgb-as-sixel-color-index = (rgb) ->

      match rgb

        | is-primary-color   => rgb-as-primary-color-sixel-index   rgb
        | is-grayscale-color => rgb-as-grayscale-color-sixel-index rgb

        else

          { r, g, b } = rgb
          [ r, g, b ] = [ r, g, b ] `map-items` value-as-sixel-level

          r *= 36 ; g *= 6

          r + g + b + 16

    color-as-sixel-color-index = (color, hsl-support) ->

      if (is-hsl color) and hsl-support

        color = hsl-as-rgb color

      rgb-as-sixel-color-index color

    serialize-color = (color, keys) -> [ (color[key]) for key in keys ] * ';'

    hashed = -> "#{ '#' }#it"

    get-color-definition-string = (color-index, pixel, hsl-support) ->

      [ color-space, serialized-color ] = if hsl-support and (is-hsl pixel)
        [ color-spaces.hsl, serialize-color color, <[ h s l ]> ]
      else
        [ color-spaces.rgb, serialize-color color, <[ r g b ]> ]

      [ (hashed color-index), color-space, serialized-color ] * ';'

    flatten = (arr) -> [].concat.apply [], arr

    analize-bitmap-colors = (bitmap, background-color-index, hsl-support) ->

      initial-analysis = color-indices: {}, color-definitions: []

      bitmap |> flatten |> (pixels) ->

        analysis = initial-analysis

        for pixel in pixels

          color-index = color-as-sixel-color-index pixel, hsl-support
          continue if color-index is background-color-index

          if not analysis.color-indices[color-index]

            analysis.color-indices[color-index] = on

            if not is-predefined-sixel-color-index color-index

              definition = get-color-definition-string color-index, pixel, hsl-support

              analysis.color-definitions.push definition

        analysis

    sixel-character-offset = '?'.char-code-at 0

    sixel-context = (background-color, hsl-support) ->

      background-color-index = color-as-sixel-color-index background-color, hsl-support

      (fn) -> (args...) -> fn ...args, background-color-index, hsl-support

    bitmap-as-sixels = (bitmap, background-color, hsl-support = no) ->

      run = sixel-context background-color, hsl-support

      { color-definitions } = bitmap

        |> (run analize-bitmap-colors)

      sixels = bitmap

        |> (run generate-sixel-pixel-data)
        |> run-length-encode-string

      dcs "q#{ color-definitions * '' }#sixels"

    {
      bitmap-as-sixels
    }