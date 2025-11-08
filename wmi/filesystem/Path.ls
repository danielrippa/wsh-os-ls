
  do ->

    { com-filesystem } = dependency 'os.com.FileSystem'
    { trim } = dependency 'prelude.String'
    { create-error-context } = dependency 'prelude.error.Context'

    { argtype } = create-error-context 'os.filesystem.Path'

    fs = com-filesystem!

    path-separator = fs.BuildPath ' ', ' ' |> trim

    build-path = (string-array) -> (argtype '[ *:String ]' {string-array}) * "#path-separator"

    get-parent-folderpath = (path) -> (argtype '<String>' {path}) |> fs.GetParentFolderName

    get-name-from-path = (path) -> fs.GetBaseName (argtype '<String>' {path})

    get-extension-from-path = (path) -> fs.GetExtensionName (argtype '<String>' {path})

    get-drive-from-path = (path) -> fs.GetDriveName (argtype '<String>' {path})

    get-absolute-path = (path) -> fs.GetAbsolutePathName (argtype '<String>' {path})

    ensure-path-separator-last = (path) ->

      switch path.slice -1
        | path-separator => path
        else build-path [ path, '' ]

    parse-path = (path) ->

      original-path = (argtype '<String>' {path})

      absolute-path = get-absolute-path path
      drive = get-drive-from-path absolute-path

      type = if fs.FolderExists absolute-path => 'folder' else 'unknown'
      if type is 'unknown' => if fs.FileExists absolute-path => type = 'file'

      if type is 'unknown' => type = if (absolute-path.slice -1) is path-separator => 'folder' else 'file'

      parent-folderpath = get-parent-folderpath absolute-path

      if type is 'folder'
        absolute-path = ensure-path-separator-last absolute-path
        parent-folder-path = get-parent-folderpath parent-folderpath

      parent-folderpath = ensure-path-separator-last parent-folderpath

      parent-folderpath = parent-folderpath.replace drive, ''

      name = get-name-from-path absolute-path
      extension = get-extension-from-path absolute-path

      { original-path, absolute-path, type, drive, name, extension, parent-folderpath }

    recompose-parsed-path = (parsed-path) ->

      { drive, parent-folderpath, name, extension } = (argtype '<Object>' {parsed-path})

      filename = "#name#{ if extension isnt '' => ".#extension" else '' }"

      "#drive#parent-folderpath#filename"

    {
      path-separator,
      build-path,
      get-parent-folderpath,
      get-name-from-path,
      get-extension-from-path,
      get-drive-from-path,
      get-absolute-path,
      parse-path, recompose-parsed-path
    }