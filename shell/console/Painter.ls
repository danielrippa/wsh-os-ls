
  do ->


    { create-error-context } = dependency 'prelude.error.Context'
    { create-instance } = dependency 'value.Instance'
    { com-object } = dependency 'os.com.Object'

    { create-error } = create-error-context 'os.shell.console.Painter'

    com-painter = void ; get-com-painter = -> (if com-painter is void => com-painter := com-object 'Console.Painter') ; com-painter

    deserialize = (fn) -> json = fn! ; eval "(#json)"

    create-console-painter = ->

      create-instance do

        client-rectangle: getter: -> deserialize -> get-com-painter!GetClientRectangle!

        cell-area-as-pixel-rect: method: (top, left, bottom, right) -> deserialize -> get-com-painter!CellRectToPixelRect left, top, right, bottom


        fill-border: method: (x, y, hatch-style, fill-r, fill-g, fill-b, alpha, border-r, border-g, border-b) ->



        fill-dithered: method: (x, y, fill-r, fill-g, fill-b, border-r, border-g, border-b) ->

          get-com-painter!FillDithered x, y, fill-r, fill-g, fill-b, border-r, border-g, border-b

        fill-hatched: method: (x, y, hatch-style, fill-r, fill-g, fill-b, alpha, border-r, border-g, border-b) ->

          get-com-painter!FillHatchedAlpha x, y, hatch-style, fill-r, fill-g, fill-b, alpha, border-r, border-g, border-b

        measure-text: method: (text, font-name, height, weight, italic, underline, strikeout) ->

          { error: error-message, Width, Height } = deserialize -> get-com-painter!MeasureText text, font-name, -height, 0. weight, italic, underline, strikeout
          if error-message isnt void => throw create-error error-message

          { width: Width, height: Height }

        draw-text: method: (text, x, y, r, g, b, font-name= 'Consolas', height = 16, weight = 100, italic = no, underline = no, strikeout = no) ->

          { error: error-message } = deserialize -> get-com-painter!DrawTextWithFont text, x, y, r, g, b, font-name, -height, 0, weight, italic, underline, strikeout
          if error-message isnt void => throw create-error error-message

        draw-png-image: method: (filepath, x, y, width, height, alpha) ->

          get-com-painter!DrawPngAlpha filepath, x, y, width, height, alpha

    console-painter = void ; get-console-painter = -> (if console-painter is void => console-painter := create-console-painter!) ; console-painter

    {
      get-console-painter
    }
