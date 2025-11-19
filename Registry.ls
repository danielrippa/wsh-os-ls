
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-shell } = dependency 'os.com.Shell'
    { build-path } = dependency 'os.filesystem.Path'
    { value-or-error } = dependency 'prelude.error.Value'

    { argtype, contextualized } = create-error-context 'os.Registry'

    registry-key-and-value = (key, value-name) -> build-path (argtype '[ *:String ]' {key}) ++ (argtype '<String>' {value-name})

    read-registry-value = (key, value-name) ->

      { value: registry-value, error } = value-or-error -> com-shell!RegRead registry-key-and-value key, value-name
      throw contextualized error unless error is void ; registry-value

    try-read-registry-value = (key, value-name) -> value-or-error -> read-registry-value key, value-name

    {
      read-registry-value, try-read-registry-value
    }