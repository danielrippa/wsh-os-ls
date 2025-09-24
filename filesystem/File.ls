
  do ->

    { com-filesystem } = dependency 'os.com.FileSystem'
    { create-error-context } = dependency 'prelude.error.Context'
    { value-or-error } = dependency 'prelude.error.Value'

    { argtype } = create-error-context 'os.filesystem.File' ; fso = com-filesystem!

    absolute-filepath = (filepath) -> fso.GetAbsolutePathName (argtype '<String>' {filepath})

    file-exists = (filepath) -> fso.FileExists (argtype '<String>' {filepath})

    try-delete-file = (filepath) -> value-or-error -> fso.DeleteFile (argtype '<String>' {filepath})

    {
      absolute-filepath,
      file-exists,
      try-delete-file
    }