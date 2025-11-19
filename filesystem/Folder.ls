
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-filesystem } = dependency 'os.com.FileSystem'
    { build-path } = dependency 'os.filesystem.Path'
    { string-as-lines } = dependency 'value.string.Text'

    { argtype, create-error } = create-error-context 'os.filesystem.Folder'

    fs = com-filesystem!

    special-folders = windows: 0, system: 1, temporary: 2

    get-special-folder = (folder-spec) -> fs.GetSpecialFolder (argtype '<Number>' {folder-spec})

    folder-exists = (folderpath) -> fs.FolderExists (argtype '<String>' {folderpath})

    {
      special-folders, get-special-folder,
      folder-exists
    }