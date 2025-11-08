
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-object } = dependency 'os.com.Object'
    { create-instance } = dependency 'value.Instance'
    { value-or-error } = dependency 'prelude.error.Value'

    { argtype, create-error } = create-error-context 'os.shell.console.Input'

    input = com-object 'Console.Input'

    create-console-input = ->

      create-instance do

        code-page:
          getter: -> input.CodePage
          setter: (new-code-page) -> input.CodePage = (argtype '<Number>' {new-code-page})

        read-text: method: (timeout = 200) ->

          argtype '<Number>' {timeout}
          json = input.ReadTextInput timeout ; { value: text-input, error } = eval "(#json)"
          if error isnt void => throw create-error "Unable to read console input: #error."

          text-input

        get-input-event: method: ->

          input-event = eval "(#{ input.GetInputEvent! })"

          switch input-event.type

            | 'None' => void
            | 'KeyPressed', 'KeyReleased' =>

              { key-type, key-code } = input-event

              switch key-type

                | 'function' => input-event <<< function-key: "f#{ key-code - 111 }"

                else input-event

            else input-event

        mode-state:
          getter: -> input.ModeState
          setter: -> input.ModeState = it

        echo-input-enabled: getter: -> input.EchoInputEnabled
        quick-mode-enabled: getter: -> input.QuickEditModeEnabled
        processed-input-enabled: getter: -> input.ProcessedInputEnabled
        insert-mode-enabled: getter: -> input.InsertModeEnabled
        mouse-input-enabled: getter: -> input.MouseInputEnabled

        extended-flags-enabled:
          getter: -> input.ExtendedFlagsEnabled
          setter: -> input.ExtendedFlagsEnabled = it

        window-input-enabled:
          getter: -> input.WindowInputEnabled
          setter: -> input.WindowInputEnabled = it

        line-input-enabled:
          getter: -> input.LineInputEnabled
          setter: -> input.LineInputEnabled = it

        enable-raw-mode: method: ->

          input

            ..ExtendedFlagsEnabled = yes
            ..QuickEditModeEnabled = no

            ..MouseInputEnabled = yes

            ..LineInputEnabled = no
            ..EchoInputEnabled = no
            ..ProcessedInputEnabled = no

            ..WindowInputEnabled = yes

        enable-password-mode: method: ->

          input

            ..LineInputEnabled = yes
            ..ProcessedInputEnabled = yes
            ..EchoInputEnabled = no

        enable-passthrough-mode: method: ->

          input

            ..ProcessedInputEnabled = no
            ..LineInputEnabled = no
            ..EchoInputEnabled = no

        enable-quick-edit-mode: method: ->

          input

            ..ExtendedFlagsEnabled = yes
            ..MouseInputEnabled = no
            ..QuickEditModeEnabled = yes

        disable-quick-edit-mode: method: ->

          input.QuickEditModeEnabled = no

        enable-mouse-input: method: ->

          input

            ..ExtendedFlagsEnabled = yes
            ..QuickEditModeEnabled = no
            ..MouseInputEnabled = yes

        disable-mouse-input: method: ->

          input.MouseInputEnabled = no

        enable-insert-mode: method: ->

          input

            ..ExtendedFlagsEnabled = yes
            ..LineInputEnabled = yes
            ..InsertModeEnabled = yes

        disable-insert-mode: method: ->

          input.InsertModeEnabled = no

        enable-processed-input: method: ->

          input

            ..LineInputEnabled = yes
            ..ProcessedInputEnabled = yes

        disable-processed-input: method: ->

          input.ProcessedInputEnabled = no

        enable-echo-input: method: ->

          input

            ..LineInputEnabled = yes
            ..EchoInputEnabled = yes

        disable-echo-input: method: ->

          input.EchoInputEnabled = no

    console-input = void ; get-console-input = -> (if console-input is void then console-input := create-console-input!) ; console-input

    input-event-matches = (one, another) ->

      for member-name, member-value of another
        return no if one[ member-name ] isnt member-value

      yes

    read-input-text = (timeout) -> create-console-input!read-text timeout

    try-read-input-text = (timeout) -> value-or-error -> read-input-text timeout

    {
      get-console-input,
      input-event-matches,
      read-input-text, try-read-input-text
    }