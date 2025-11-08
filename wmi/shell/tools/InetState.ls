
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { tool } = dependency 'os.shell.Tool'
    { value-or-error } = dependency 'prelude.error.Value'
    { string-as-words } = dependency 'value.string.Text'

    { contextualized } = create-error-context 'os.shell.tools.InetState'

    inetstate = ->

      { stdout: state, errorlevel } = tool 'inetstate'
      if errorlevel is 1 => return <[ DISCONNECTED ]>

      state |> string-as-words

    try-inetstate = -> value-or-error -> inetstate!

    {
      try-inetstate
    }