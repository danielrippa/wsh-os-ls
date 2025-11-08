
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-object } = dependency 'os.com.Object'
    { value-or-error } = dependency 'prelude.error.Value'

    { value-as-string } = dependency 'prelude.reflection.Value'

    { create-error, argtype } = create-error-context 'os.shell.Clipboard'

    create-clipboard = -> com-object 'Shell.Clipboard'

    get-clipboard-text = ->

      json = create-clipboard!GetText! ; { value: clipboard-text, error: error-message } = eval "(#json)"
      if error-message isnt void => throw create-error error-message

      clipboard-text

    try-get-clipboard-text = -> value-or-error -> get-clipboard-text!

    set-clipboard-text = (text) ->

      json = create-clipboard!SetText (argtype '<String>' {text}) ; { error: error-message } = eval "(#json)"
      if error-message isnt void => throw create-error error-message

    try-set-clipboard-text = (text) -> value-or-error -> set-clipboard-text text

    {
      try-get-clipboard-text, try-set-clipboard-text
    }