
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { create-process } = dependency 'os.shell.Process'
    { value-or-error } = dependency 'prelude.error.Value'

    { create-error } = create-error-context 'os.filesystem.SymbolicLink'

    create-folder-junction = (source-path, link-path) ->

      { errorlevel, stderr: error-message } = create-process 'mklink', [ '/J', link-path, source-path ]
      if errorlevel isnt 0 => throw create-error error-message

    try-create-folder-junction = (source-path, link-path) -> value-or-error -> create-folder-junction source-path, link-path

    {
      try-create-folder-junction
    }