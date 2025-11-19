
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { create-process } = dependency 'os.shell.Process'
    { string-as-lines } = dependency 'value.string.Text'
    { filter } = dependency 'prelude.Array'
    { map-array-items } = dependency 'value.Array'
    { trim-space } = dependency 'value.string.Whitespace'

    { argtype, create-error } = create-error-context 'os.filesystem.FolderItems'

    get-folder-item-names = ->

      parameters = [ "#arg" for arg in arguments ]

      { errorlevel, stdout, stderr } = create-process 'dir', parameters ++ <[ /b ]>
      throw create-error "Unable to get folder items for parameters #{ parameters * ' ' }. Errorlevel: #errorlevel.#{ if stderr isnt void then " #stderr" else '' }" \
        if errorlevel isnt 0 or stderr isnt void

      stdout |> string-as-lines |> map-array-items _ , trim-space |> filter _ , (!= '')

    {
      get-folder-item-names
    }