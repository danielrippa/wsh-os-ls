
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-process } = dependency 'os.com.Process'
    { wql-query } = dependency 'os.wmi.Wql'
    { value-or-error } = dependency 'prelude.error.Value'

    { argtype, contextualized } = create-error-context 'os.shell.Process'

    get-current-process-id = -> com-process!GetCurrentProcessId!

    get-process-details = (process-id) ->

      json = com-process!GetProcessDetails (argtype '<Number>' {process-id})
      eval "(#json)"

    get-process-ancestor-names = (process-id) ->

      pid = argtype '<Number>' {process-id}

      ancestor-names = []

      loop

        { value: result, error } = value-or-error -> wql-query 'Win32_Process', void, "ProcessId = #{ pid }", <[ Name ParentProcessId ]>
        throw contextualized error if error isnt void

        argtype '<Array|Void>' {result} ; break if result is void ; break if result.length is 0

        [ process ] = result ; { ParentProcessId: pid, Name: ancestor-name } = process ; ancestor-names.push ancestor-name

      ancestor-names

    {
      get-current-process-id,
      get-process-details,
      get-process-ancestor-names
    }