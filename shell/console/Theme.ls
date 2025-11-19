
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { create-instance } = dependency 'value.Instance'
    { try-read-textfile-lines } = dependency 'os.filesystem.TextFile'
    { camel-case } = dependency 'value.string.Case'
    { trim-space, string-as-words } = dependency 'value.string.Whitespace'
    { first-array-item } = dependency 'value.Array'

    { argtype, create-error } = create-error-context 'os.shell.console.Palette'

    create-console-theme = ->

      theme-colors = {}

      create-instance do

        set-color: method: (color-name, red, green, blue) ->

          argtype '<String> {color-name}' ; argtype '<Number>' {red} ; argtype '<Number>' {green} ; argtype '<Number>' {blue}

          theme-colors[ name ] := { red, green, blue }

        add-color: method: (color-name, r, g, b) ->

          argtype '<String>' {color-name} ; argtype '<Number>' {r} ; argtype '<Number>' {g} ; argtype '<Number>' {b}

          name = camel-case color-name ; throw create-error "A theme color with name '#color-name' already exists. Unable to add." if theme-colors[ name ] isnt void

          theme-colors[ name ] := { r, g, b }

        load-from-lines: method: (theme-lines) ->

          for theme-line, line-index in theme-lines

            line = trim-space theme-line ; continue if line is '' ; continue if (first-array-item line / '') is '#'

            words = string-as-words line ; throw create-error "Invalid line syntax in line '#line' at index #line-index in console theme file '#filepath'. Valid syntax is 'color-name decimal-red decimal-green decimal-blue'." if words.length isnt 4
            [ color-name, red-value, green-value, blue-value ] = words

            color-values = [ red-value, green-value, blue-value ]

            colors = [ (parse-int color) for color in color-values ]

            for color, color-index in colors

              try argtype '<Number>' {color}
              catch error => throw create-error "Unable to convert color value '#{ color-values[ color-index ] }' to number in line '#line' at index #line-index in console theme file '#filepath'. Valid syntax is 'color-name decimal-red decimal-green decimal-blue'.", error

            [ red, green, blue ] = colors

            @add-color (camel-case color-name), red, green, blue

        load-from-file: method: (filepath) ->

          { value: theme-lines, error } = try-read-textfile-lines filepath
          throw create-error "Unable to read console theme file '#filepath'.", error if error isnt void

          @load-theme-from-lines theme-lines

        get-color: method: (color-name) ->

          theme-color = theme-colors[ camel-case color-name ] ; throw create-error "No theme color with name '#color-name' was added." if theme-color is void
          theme-color

        color-names: getter: -> object-member-names theme-colors

        apply-colors-to-screen-buffer: method: (screen-buffer, color-names) !->

          argtype '<Object>' {screen-buffer} ; argtype '[ *:String ]' {color-names}

          for color-name, color-index in color-names
            screen-buffer.set-palette-color color-index, @get-color color-name

    {
      create-console-theme
    }