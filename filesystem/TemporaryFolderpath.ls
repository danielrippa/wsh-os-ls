
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { known-folder-csidls, get-known-folderpath-by-csidl, known-folder-guids, get-known-folderpath-by-guid } = dependency 'os.filesystem.KnownFolderPath'
    { folder-exists, special-folders, special-folder } = dependency 'os.filesystem.Folder'

    { create-error } = create-error-context 'os.filesystem.TemporaryFile'

    temporary-folderpath = void

    #

    appdata-local-folderpath = ->

      { appdata-locallow } = known-folder-guids ; get-known-folderpath-by-guid appdata-locallow => return .. if folder-exists

      { local-app-data } = known-folder-csidls ; folderpath = get-known-folderpath-by-csidl local-app-data

      for suffix in [ 'Low', '' ] => "#folderpath#suffix" => return .. if folder-exists ..

      void

    special-temporary-folderpath = ->

      special-folders

        windows-folderpath = special-folder ..windows

        folderpath = special-folder ..temporary

          return if .. is windows-folderpath then .. else void

    user-envvar-temp-folderpath = ->

      folderpath = void ; names = <[ temp tmp ]>

      each-envvar 'user', (name, value) ->

        envvar = lower-case name ; return unless envvar in names
        if folder-exists value => folderpath := value ; return no

      folderpath

    #

    set-temporary-folderpath = -> temporary-folderpath := it

    get-temporary-folderpath = ->

      temporary-folderpath => return .. unless .. is void

      appdata-local-folderpath! => return set-temporary-folderpath .. unless .. is void
      special-temporary-folderpath! => return set-temporary-folderpath .. unless .. is void
      user-env-var-temp-folderpath! => return set-temporary-folderpath .. unless .. is void

      throw create-error "Unable to get temporary folderpath."

    {
      get-temporary-folderpath
    }

