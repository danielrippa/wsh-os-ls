
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { get-temporary-folderpath } = dependency 'os.filesystem.TemporaryFolderPath'
    { build-path } = dependency 'os.filesystem.Path'
    { com-filesystem } = dependency 'os.com.FileSystem'
    { value-or-error } = dependency 'prelude.error.Value'
    { read-textfile } = dependency 'os.filesystem.TextFile'
    { delete-file } = dependency 'os.filesystem.File'

    { contextualized } = create-error-context 'os.filesystem.TemporaryFile'

    get-temporary-filename = -> com-filesystem!GetTempName!

    get-temporary-filepath = -> build-path [ get-temporary-folderpath!, get-temporary-filename! ]

    create-temporary-file = ->

      filepath = get-temporary-filepath!

      read-and-remove = ->

        { value, error } = value-or-error -> content = read-textfile filepath ;  ; delete-file filepath ; content
        throw contextualized error unless error is void ; value

      try-read-and-remove = -> value-or-error -> @read-and-remove!

      { filepath, read-and-remove, try-read-and-remove }

    {
      get-temporary-filepath, get-temporary-filename,
      create-temporary-file
    }
