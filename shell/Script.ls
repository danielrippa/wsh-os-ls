
  do ->

    { get-name-from-path } = dependency 'os.filesystem.Path'
    { create-error-context } = dependency 'prelude.error.Context'
    { com-shell } = dependency 'os.com.Shell'
    { com-process } = dependency 'os.com.Process'
    { get-current-process-id, get-process-ancestor-names } = dependency 'os.shell.Process'
    { lower-case } = dependency 'value.string.Case'
    { last-array-item } = dependency 'value.Array'
    { value-or-error } = dependency 'prelude.error.Value'
    { folder-exists } = dependency 'os.filesystem.Folder'
    { string-contains-segment: contains } = dependency 'value.string.Segment'

    { argtype, contextualized } = create-error-context 'os.shell.Script'

    shell = com-shell! ; process = com-process!

    WScript

      script-filepath = ..ScriptFullName
      script-name = get-name-from-path ..ScriptName

      exit = (errorlevel = 1) -> ..Quit (argtype '<Number>' {errorlevel})

      sleep = (milliseconds) -> ..Sleep (argtype '<Number>' {milliseconds})

      ..Arguments.Unnamed

        script-argument-at-index = (argument-index) -> ..Item (argtype '<Number>' {argument-index})

        script-arguments-count = ..Count

    script-arguments = [ (script-argument-at-index index) for index til script-arguments-count ]

    get-script-current-folder = -> shell.CurrentDirectory

    set-script-current-folder = (new-current-folder) ->

      succeeded = no

      if folder-exists (argtype '<String>' {new-current-folder})

        shell.CurrentDirectory = new-current-folder
        succeeded = yes

      succeeded

    try-set-script-current-folder = (new-current-folder) -> value-or-error -> set-script-current-folder new-current-folder

    get-script-process-id = -> get-current-process-id!

    get-script-terminal-host = -> get-script-process-id! |> get-process-ancestor-names |> last-array-item

    script-usage = (lines) -> argtype '[ *:String ]' {lines} ; [ first, ...rest ] = lines ; <[ Usage: ]> ++ [ '', "#script-name #first" ] ++ rest

    get-object-and-values-from-arguments = (args) ->

      object = {} ; values = []

      for arg in (argtype '[ *:String ]' {args})

        if arg `contains` '='

          [ key, value ] = arg / '='

          if object[key] is void => object[key] = []

          object[key].push value

        else

          values.push arg

      { object, values }

    {
      script-filepath, script-name,
      exit, sleep,
      script-argument-at-index, script-arguments-count, script-arguments,
      get-script-current-folder, set-script-current-folder, try-set-script-current-folder,
      get-script-terminal-host,
      script-usage,
      get-object-and-values-from-arguments
    }