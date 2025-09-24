
  do ->

    { get-console-state, set-console-state } = dependency 'os.shell.console.State'
    { get-console-input } = dependency 'os.shell.console.Input'
    { create-screen-buffer } = dependency 'os.shell.console.ScreenBuffer'
    { csi } = dependency 'os.shell.terminal.Control'

    get-terminal-device-attributes = ->

      input-text = void

      try

        console-state = get-console-state!

        console-input = get-console-input! ; screen-buffer = create-screen-buffer!

        console-input.enable-passthrough-mode! ; screen-buffer.set-terminal-mode on

        screen-buffer.write csi 'c' ; input-text = console-input.read-text!

      finally

        set-console-state console-state

      return {} if input-text is void

      [ prefix, suffix ] = input-text / '[?'

      [ attribute-values ] = suffix / 'c'

      # https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-Secondary-Device-Attributes-(DA2)
      # https://github.com/microsoft/terminal/blob/main/src/terminal/adapter/adaptDispatch.cpp#L1452

      WScript.Echo attribute-values

      [ conformance-level, ...feature-extensions ] = attribute-values / ';'

      { conformance-level, feature-extensions }

    get-terminal-device-feature-extensions = ->

      { feature-extensions } = get-terminal-device-attributes!

      WScript.Echo feature-extensions

      feature-names = [] ; return feature-names if feature-extensions is void

      for feature in feature-extensions

        feature-name = switch feature

          | '4' => 'sixel'
          | '6' => 'selective-erase'
          | '7' => 'soft-fonts'
          | '14' => '8-bit-interface-architecture'
          | '21' => 'horizontal-scrolling'
          | '22' => 'color-text'
          | '23' => 'greek-character-set'
          | '24' => 'turkish-character-set'
          | '28' => 'rectangular-area-operations'
          | '32' => 'text-macros'
          | '42' => 'iso-latin-2-character-set'
          | '52' => 'clipboard-access'

        if feature-name isnt void => feature-names.push feature-name

      feature-names

    {
      get-terminal-device-attributes,
      get-terminal-device-feature-extensions
    }