
  do ->

    { com-filesystem } = dependency 'os.com.FileSystem'
    { trim } = dependency 'prelude.String'
    { create-error-context } = dependency 'prelude.error.Context'

    { argtype } = create-error-context 'os.filesystem.Path'

    fso = com-filesystem!

    path-separator = fso.BuildPath ' ', ' ' |> trim

    build-path = (string-array) -> (argtype '[ *:String ]' {string-array}) * "#path-separator"

    parent-folderpath = (path) -> (argtype '<String>' {path}) |> fso.GetParentFolderName

    name-from-path = (path) -> fso.GetBaseName (argtype '<String>' {path})

    {
      path-separator,
      build-path,
      parent-folderpath,
      name-from-path
    }