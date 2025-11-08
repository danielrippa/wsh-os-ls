
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { try-inetstate } = dependency 'os.shell.tools.InetState'
    { string-as-words } = dependency 'value.string.Text'
    { value-or-error } = dependency 'prelude.error.Value'

    { value-as-string } = dependency 'prelude.reflection.Value'

    { contextualized } = create-error-context 'os.net.Web'

    unavailable-connection-flags = <[ OFFLINE DISCONNECTED ]>

    is-web-available = ->

      { value: connection-state-flags, error } = try-inetstate! ; if error isnt void => throw contextualized error

      for state-flag in connection-state-flags => if state-flag in unavailable-connection-flags => ; return no

      yes


    try-is-web-available = -> value-or-error -> is-web-available!

    {
      try-is-web-available
    }