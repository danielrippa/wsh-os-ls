
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-shell } = dependency 'os.com.Shell'
    { wql-query } = dependency 'os.wmi.Wql'
    { value-or-error } = dependency 'prelude.error.Value'
    { double-quotes } = dependency 'value.string.Quotes'
    { create-temporary-file } = dependency 'os.filesystem.TemporaryFile'
    { trim-space } = dependency 'value.string.Whitespace'

    { value-as-string } = dependency 'prelude.reflection.Value'

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

    #

    shell-escape-executable = (value) ->

      trimmed = trim-space value

      if trimmed.index-of ' ' is -1
        trimmed
      else
        double-quotes trimmed

    run-process = (executable, parameters) ->

      shell-escaped-executable = shell-escape-executable executable

      command-line = "%comspec% /c #shell-escaped-executable #{ (argtype '[ *:String ]' {parameters}) * ' ' }"

      errorlevel = com-shell!Run command-line, 0, yes ; { errorlevel, command-line, executable, shell-escaped-executable, parameters }

    #

    file-redirection = ({ filepath }, stream-index) -> "#stream-index> #{ double-quotes filepath }"

    create-process = (executable, parameters) ->

      temporary-files = [ (create-temporary-file!) for i til 2 ]

      redirections = [ (file-redirection file, index + 1) for file, index in temporary-files ]

      process-result = run-process executable, parameters ++ redirections

      [ stdout, stderr ] = [ (file.read-and-remove!) for file in temporary-files ]

      { errorlevel, shell-escaped-executable, command-line } = process-result

      { errorlevel, executable, shell-escaped-executable, parameters, redirections, command-line, stdout, stderr }

    {
      get-current-process-id,
      get-process-details,
      get-process-ancestor-names,
      run-process, create-process
    }