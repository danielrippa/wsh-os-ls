
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { create-instance } = dependency 'value.Instance'
    { com-object } = dependency 'os.com.Object'

    { argtype } = create-error-context 'os.shell.console.Window'

    create-console-window = ->

      window = com-object 'Console.Window'

      create-instance do

        title:
          getter: -> window.Title
          setter: (new-window-title) -> window.Title = (argtype '<String>' {new-window-title})

        code-page:
          getter: -> window.CodePage
          setter: (new-code-page) -> window.CodePage = (argtype '<Number>' {new-code-page})

        height:
          getter: -> window.Height
          setter: (new-window-height) -> window.Height = (argtype '<Number>' {new-window-height})

        width:
          getter: -> window.Width
          setter: (new-window-width) -> window.Width = (argtype '<Number>' {new-window-width})

        resize: method: (new-window-height, new-window-width) -> window.Resize (argtype '<Number>' {new-window-height}), (argtype '<Number>' {new-window-width})

        resize-screen-buffer: method: (handle) -> window.ResizeScreenBufferToWindow (argtype '<Number>' {handle})

    console-window = void ; get-console-window = -> (if console-window is void => console-window := create-console-window!) ; console-window

    {
      get-console-window
    }