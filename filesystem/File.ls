
  do ->

    { com-filesystem } = dependency 'os.com.FileSystem'
    { create-error-context } = dependency 'prelude.error.Context'
    { value-or-error } = dependency 'prelude.error.Value'
    { build-path, path-separator } = dependency 'os.filesystem.Path'
    { folder-exists } = dependency 'os.filesystem.Folder'

    { argtype } = create-error-context 'os.filesystem.File' ; fs = com-filesystem!

    get-absolute-filepath = (filepath) -> fs.GetAbsolutePathName (argtype '<String>' {filepath})

    file-exists = (filepath) -> fs.FileExists (argtype '<String>' {filepath})

    delete-file = (filepath) -> fs.DeleteFile (argtype '<String>' {filepath})

    try-delete-file = (filepath) -> value-or-error -> delete-file filepath

    parse-filepath = (filepath) ->

      argtype '<String>' {filepath}

      absolute-filepath = get-absolute-filepath filepath

      fs

        [ drive ] = (..GetDriveName absolute-filepath) / "#path-separator"
        path = ..GetParentFolderName absolute-filepath ; path = path.replace drive, '' ; [ prefix, ...path ] = path / "#path-separator" ; path = path * "#path-separator"
        name = ..GetBaseName absolute-filepath
        extension = ..GetExtensionName absolute-filepath

      { absolute-filepath, filepath, drive, path, name, extension }

    compose-parsed-filepath = (parsed-filepath) ->

      argtype '<Object>' {parsed-filepath}
      { name, extension, drive, path } = parsed-filepath

      filename = if extension is void
        name
      else
        "#name.#extension"

      build-path [ drive, path, filename ]

    {
      get-absolute-filepath, parse-filepath, compose-parsed-filepath,
      file-exists,
      delete-file, try-delete-file
    }