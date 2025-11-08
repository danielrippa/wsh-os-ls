
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-object } = dependency 'os.com.Object'

    { value-as-string } = dependency 'prelude.reflection.Value'

    { argtype } = create-error-context 'os.shell.console.ConsoleState'

    console-components = ->

      screen-buffer = com-object 'Console.ScreenBuffer' ; color-palette = com-object 'Console.Palette'
      console-input = com-object 'Console.Input' ; console-window = com-object 'Console.Window'

      { screen-buffer, color-palette, console-input, console-window }

    get-console-state = ->

      { screen-buffer, color-palette, console-input, console-window } = console-components!

      { ModeState: input-mode-state, CodePage: input-code-page } = console-input
      { TextAttributes: text-attributes, ModeState: output-mode-state } = screen-buffer

      color-palette-string = color-palette.GetPaletteAsString!

      { Title: window-title, CodePage: output-code-page } = console-window

      {
        input-mode-state, output-mode-state,
        input-code-page, output-code-page,
        text-attributes, color-palette-string,
        window-title
      }

    set-console-state = (state) ->

      {
        input-mode-state, output-mode-state,
        input-code-page, output-code-page,
        text-attributes, color-palette-string,
        window-title
      } = state

      { screen-buffer, color-palette, console-input, console-window } = console-components!

      console-input => ..ModeState = input-mode-state ; ..CodePage = input-code-page
      screen-buffer => ..ModeState = output-mode-state ; ..TextAttributes = text-attributes

      color-palette => ..SetPaletteFromString color-palette-string

      console-window => ..Title = window-title ; ..CodePage = output-code-page

    {
      get-console-state, set-console-state
    }