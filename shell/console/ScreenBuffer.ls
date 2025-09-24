
    { create-error-context } = dependency 'prelude.error.Context'
    { create-instance } = dependency 'value.Instance'
    { com-object } = dependency 'os.com.Object'
    { create-text-attributes: text-style } = dependency 'os.shell.console.TextAttributes'
    { object-member-names } = dependency 'value.Object'
    { get-timestamp } = dependency 'value.Date'

    { argtype, argerror, context } = create-error-context 'os.shell.console.ScreenBuffer'

    com-screenbuffer = -> com-object 'Console.ScreenBuffer'

    create-screen-buffer-name = -> "screen-buffer-#{ get-timestamp! }"

    #

    create-screen-buffer-cursor = (handle) ->

      { argtype } = context 'create-screen-buffer-cursor'

      cursor = com-object 'Console.Cursor'

      instance = create-instance do

        handle: setter: -> cursor.Handle = it

        visible:
          getter: -> cursor.Visible
          setter: (cursor-visibility) -> cursor.Visible = (argtype '<Boolean>' {cursor-visibility})

        size:
          getter: -> cursor.Size
          setter: (new-cursor-size) -> cursor.Size = (argtype '<Number>' {new-cursor-size})

        row:
          getter: -> cursor.Row
          setter: (cursor-row) -> cursor.Row = (argtype '<Number>' {cursor-row})

        column:
          getter: -> cursor.Column
          setter: (cursor-column) -> cursor.Column = (argtype '<Number>' {cursor-column})

        goto: member: (cursor-row, cursor-column) -> cursor.Goto (argtype '<Number>' {cursor-row}), (argtype '<Number>' {cursor-column})

        new-line: member: -> @goto @get-row! + 1, 0

      instance

        ..set-handle handle if handle isnt void

    #

    create-screen-buffer-color-palette = (handle) ->

      palette = com-object 'Console.Palette'

      instance = create-instance do

        handle: setter: -> palette.Handle = it

        get-color: method: (color-index) -> rgb-string = palette.GetColorCsv (argtype '<Number>' {color-index}) ; [ r, g, b ] = rgb-string |> (/ ',') |> map _ , string-as-decimal ; { r, g, b }
        set-color: method: (color-index, rgb) -> argtype '{ r:Number g:Number b:Number }' {rgb} ; { r, g, b } = rgb ; palette.SetColorRGB (argtype '<Number>' {color-index} ; ), r, g, b

      instance

        ..set-handle handle if handle isnt void

    #

    create-screen-buffer-viewport = (handle) ->

      viewport = com-object 'Console.Viewport'

      instance = create-instance do

        handle: setter: -> viewport.Handle = it

        top:
          getter: -> viewport.Left
          setter: -> viewport.Left = it

        left:
          getter: -> viewport.Left
          setter: -> viewport.Left = it

        bottom: getter: -> viewport.Bottom

        right: getter: -> viewport.Right

        height: getter: -> viewport.Height

        width: getter: -> viewport.Width

        max-height: getter: -> viewport.MaxHeight

        max-width: getter: -> viewport.MaxWidth

        #

        events: notifier: <[ on-viewport-relocated on-viewport-resized ]>

        move-to: method: (row, column) -> viewport.MoveTo row, column ; @events.notify <[ on-viewport-relocated ]> @

        resize-to-buffer: method: -> viewport.ResizeToBuffer! ; @events.notify <[ on-viewport-resized ]> @

      instance

        ..set-handle handle if handle isnt void

    #

    create-screen-buffer = (name) ->

      screen-buffer = com-screenbuffer! => handle = ..Handle

      cursor = create-screen-buffer-cursor handle
      color-palette = create-screen-buffer-color-palette handle
      viewport = create-screen-buffer-viewport handle

      name = if name is void then create-screen-buffer-name! else (argtype '<String>' {name})

      instance = create-instance do

        name: getter: -> name

        handle:
          getter: -> screen-buffer.Handle
          setter: (handle) ->

            screen-buffer.Handle = (argtype '<Number>' {handle})

            cursor.set-handle handle
            color-palette.set-handle handle
            viewport.set-handle handle

        close: method: -> screen-buffer.Close!

        activate: method: -> get-screen-buffer-manager!activate-screen-buffer name
        is-active: method: -> get-screen-buffer-manager!get-active-screen-buffer-name! is name

        cursor: getter: -> cursor
        viewport: getter: -> viewport

        get-palette-color: method: (index) -> color-palette.get-color index

        set-palette-color: method: (index, rgb) -> color-palette.set-color index, rgb

        write: method: -> [ ("#arg") for arg in arguments ] |> (* '') |> screen-buffer.Write
        writeln: method: -> @write ... ; @get-cursor!new-line!

        set-text-at: method: (row, column, text) -> screen-buffer.SetCharsAt (argtype '<Number>' {row}), (argtype '<Number>' {column}), (argtype '<String>' {text})

        set-style-at: method: (row, column, attribute-value, length) -> screen-buffer.SetAttrAt (argtype '<Number>' {row}), (argtype '<Number>' {column}), (argtype '<Number>' {attribute-value}), (argtype '<Number>' {length})

        set-styled-text-at: method: (row, column, text, attribute-value) -> screen-buffer.WriteTextWithAttrs (argtype '<Number>' {row}), (argtype '<String>' {column}), (argtype '<String> {text}'), (argtype '<Number>' {attribute-value})

        text-style:
          getter: -> screen-buffer.TextAttributes
          setter: (text-attributes) -> screen-buffer.TextAttributes = (argtype '<Number>' {text-attributes})

        set-ink-style: method: (ink-style = {}) -> style = text-style @text-style! ; style.set-ink (argtype '<Oject>' {ink-style}) ; @set-text-style style.value!

        set-paper-style: method: (paper-style = {}) -> style = text-style @text-style! ; style.set-paper (argtype '<Oject>' {paper-style}) ; @set-text-style style.value!

        set-border-style: method: (border-style = {}) -> style = text-style @text-style! ; style.set-borders (argtype '<Oject>' {border-style}) ; @set-text-style style.value!

        set-inverted-style: method: (enabled-state) -> style = text-style @text-style! ; style.set-inverted (argtype '<Boolean>' {enabled-state}) ; @set-text-style style.value!

        copy-area: method: (row, column, height, width, screen-buffer-handle = @handle!) -> screen-buffer.CopyArea (argtype '<Number>' {row}), (argtype '<Number>' {column}), (argtype '<Number>' {height}), (argtype '<Number>' {width}), (argtype '<Number>' {screen-buffer-handle})

        paste-area-at: method: (row, column, target-screen-buffer-handle = @handle!) -> screen-buffer.PasteAreaAt (argtype '<Number>' {row}), (argtype '<Number>' {column}), (argtype '<Number>' {target-screen-buffer-handle})

        set-paste-area-content: method: (height, width, text, attributes = [], fill-char = '', default-attributes) -> screen-buffer.SetPasteAreaContent (argtype '<Number>' {height}), (argtype '<Number>' {width}), (argtype '<String>' {text}), (argtype '<Array>' {attributes}), (argtype '<String>' {fill-char}), (argtype '<Number>' {default-attributes})

        set-paste-area-text: method: (row, column, text) -> screen-buffer.SetPasteAreaChars (argtype '<Number>' {row}), (argtype '<Number>' {column}), (argtype '<String>' {text})

        set-area: method: (row, column, height, width = 1, character, attributes-value = -1) -> screen-buffer.SetArea (argtype '<Number>' {row}), (argtype '<Number>' {column}), (argtype '<Number>' {height}), (argtype '<Number>' {width}), (argtype '<String>' {character}), (argtype '<Number>' {attributes-value})

        set-area-attribute: method: (row, column, height, width = 1, attributes-value) -> screen-buffer.SetAreaAttribute (argtype '<Number>' {row}), (argtype '<Number>' {column}), (argtype '<Number>' {height}), (argtype '<Number>' {width}), (argtype '<Number>' {attributes-value})

        terminal-mode:
          getter: -> screen-buffer.VirtualTerminalProcessingEnabled
          setter: (new-terminal-mode-state) -> screen-buffer.VirtualTerminalProcessingEnabled = (argtype '<Boolean>' {new-terminal-mode-state})

        enable-raw-mode: method: !->

          screen-buffer

            ..ProcessedOutputEnabled = off
            ..WrapAtEOLOutputEnabled = off
            ..NewlineAutoReturnEnabled = off
            ..LvbGridWorldwideEnabled = off

      instance

    sb = com-screenbuffer!

    create-screen-buffer-handle = -> sb.CreateScreenBufferHandle!

    activate-screen-buffer = (screen-buffer-handle) -> sb.ActivateScreenBuffer screen-buffer-handle

    new-screen-buffer = (name) ->

      create-screen-buffer name

        ..set-handle create-screen-buffer-handle!

    create-screen-buffer-manager = ->

      { argtype, argerror } = context 'create-screen-manager'

      screen-buffers-by-name = {}
      active-screen-buffer-name = void

      instance = create-instance do

        screen-buffer-events: notifier: <[ on-screen-buffer-added on-screen-buffer-removed ]>

        get-screen-buffer: method: (screen-buffer-name) ->

          argtype '<String>' {screen-buffer-name}

          screen-buffer = screen-buffers-by-name[ screen-buffer-name ]

          throw argerror {screen-buffer-name} "doesn't match any added screen buffer name" if screen-buffer is void

          screen-buffer

        add-screen-buffer: method: (name) ->

          argtype '<String|Void>' {name}

          if name is void then name := create-screen-buffer-name!

          throw argerror {name} "is an existing screen buffer name. Unable to add screen buffer" unless screen-buffers-by-name[ name ] is void

          screen-buffer = new-screen-buffer name

          screen-buffers-by-name[ name ] := screen-buffer

          screen-buffer

        screen-buffer-names: getter: -> object-member-names screen-buffers-by-name

        remove-screen-buffer: method: (screen-buffer-name) ->

          screen-buffer = @get-screen-buffer screen-buffer-name

          delete screen-buffers-by-name[ screen-buffer-name ]

          screen-buffer.close!

        activate-screen-buffer: method: (screen-buffer-name) ->

          screen-buffer = @get-screen-buffer screen-buffer-name

          activate-screen-buffer screen-buffer.get-handle!

          active-screen-buffer-name := screen-buffer-name

        active-screen-buffer-name: getter: -> active-screen-buffer-name

      instance

    screen-buffer-manager = void ; get-screen-buffer-manager = -> (if screen-buffer-manager is void then screen-buffer-manager := create-screen-buffer-manager!) ; screen-buffer-manager

    {
      create-screen-buffer-cursor, create-screen-buffer-color-palette, create-screen-buffer-viewport, create-screen-buffer,
      get-screen-buffer-manager
    }