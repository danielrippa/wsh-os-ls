
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { create-process } = dependency 'os.shell.Process'
    { value-as-string } = dependency 'prelude.reflection.Value'
    { value-or-error } = dependency 'prelude.error.Value'
    { parse-filepath, compose-parsed-filepath } = dependency 'os.filesystem.File'
    { try-read-objectfile } = dependency 'os.filesystem.ObjectFile'

    { create-error, argtype, contextualized } = create-error-context 'os.shell.Tool'

    is-tool-in-path = (tool-name) -> { errorlevel } = create-process 'where' [ tool-name ] ; errorlevel is 0

    tool-not-found-error = (tool-name) -> create-error "Tool '#tool-name' not found."

    validate-tool-in-path = (tool-name) ->

      unless is-tool-in-path tool-name

        throw tool-not-found-error tool-name

      yes

    try-validate-tool-in-path = (tool-name) -> value-or-error -> validate-tool-in-path tool-name

    get-tool-configuration = (tool-name) ->

      parsed-filepath = parse-filepath tool-name ; parsed-filepath.extension = 'conf'
      conf-filepath = compose-parsed-filepath parsed-filepath

      { value: tool-configuration, error } = try-read-objectfile conf-filepath
      throw create-error "Unable to read configuration file '#conf-filepath'.", error unless error is void

      tool-configuration

    try-get-tool-configuration = (tool-name) -> value-or-error -> get-tool-configuration tool-name

    tool = (tool-name, ...args) ->

      argtype '<String>' {tool-name} ; argtype '[ *:String ]' {args}

      tool-filepath = tool-name

      unless is-tool-in-path tool-name

        { exe-filepath } = get-tool-configuration tool-name ; exe-filepath => tool-filepath = .. unless .. is void

      create-process tool-filepath, args

    {
      is-tool-in-path,
      validate-tool-in-path, try-validate-tool-in-path,
      tool, get-tool-configuration, try-get-tool-configuration
    }