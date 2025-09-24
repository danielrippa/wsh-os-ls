
  do ->

    { name-from-path } = dependency 'os.filesystem.Path'
    { create-error-context } = dependency 'prelude.error.Context'
    { com-shell } = dependency 'os.com.Shell'
    { com-process } = dependency 'os.com.Process'
    { get-current-process-id, get-process-ancestor-names } = dependency 'os.shell.Process'
    { lower-case } = dependency 'value.string.Case'
    { last-array-item } = dependency 'value.Array'

    { argtype } = create-error-context 'os.shell.Script'

    shell = com-shell! ; process = com-process!

    WScript

      script-filepath = ..ScriptFullName
      script-name = name-from-path ..ScriptName

      exit = (errorlevel = 1) -> ..Quit (argtype '<Number>' {errorlevel})

      sleep = (milliseconds) -> ..Sleep (argtype '<Number>' {milliseconds})

      ..Arguments.Unnamed

        script-argument-at-index = (argument-index) -> ..Item (argtype '<Number>' {argument-index})

        script-arguments-count = ..Count

    script-arguments = [ (script-argument-at-index index) for index til script-arguments-count ]

    get-script-current-folder = -> shell.CurrentDirectory

    set-script-current-folder = (new-current-folder) -> shell.CurrentDirectory = (argtype '<String>' {new-current-folder})

    get-script-process-id = -> get-current-process-id!

    get-script-terminal-host = -> get-script-process-id! |> get-process-ancestor-names |> last-array-item

    {
      script-filepath, script-name,
      exit, sleep,
      script-argument-at-index, script-arguments-count, script-arguments,
      get-script-current-folder, set-script-current-folder,
      get-script-terminal-host
    }