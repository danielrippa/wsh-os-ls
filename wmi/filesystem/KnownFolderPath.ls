
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { get-shell-namespace-by-csidl } = dependency 'os.shell.Namespace'
    { read-registry-value } = dependency 'os.Registry'
    { folder-exists } = dependency 'os.filesystem.Folder'

    { argtype, create-error } = create-error-context 'os.filesystem.KnownFolderPath'

    known-folder-csidls =

      admin-tools: 0x30
      alt-startup: 0x1d
      app-data: 0x1a
      bit-bucket: 0x0a
      desktop: 0x00
      desktop-directory: 0x10
      profile: 0x28
      program-files: 0x26
      program-files-x86: 0x2a
      programs: 0x02
      send-to: 0x09
      start-menu: 0x0b
      start-up: 0x07
      system: 0x25
      system-x86: 0x29
      windows: 0x24

      local-app-data: 0x1c

      program-files-common: 0x28
      program-files-common-x86: 0x2c

      common-app-data: 0x23
      common-desktop-directory: 0x19
      common-documents: 0x2e
      common-favorites: 0x1f
      common-music: 0x35
      common-pictures: 0x36
      common-programs: 0x17
      common-start-menu: 0x16
      common-start-up: 0x18

    #

    get-known-folderpath-by-csidl = (csidl) ->

      get-shell-namespace-by-csidl csidl =>

        throw create-error "Unknown folderpath for csidl #csidl." unless ..?

        return ..Self.Path

    #

    shell-folders-registry-key = <[ HKCU Software Microsoft Windows CurrentVersion Explorer ]> ++ [ 'Shell Folders' ]

    known-folder-guids =

      libraries: '1B3EA5DC-B587-4786-B4EF-BD1DC332AEAE'
      contacts: '56784854-C6CB-462B-8169-88E350ACB882'
      roaming-tiles: '00BCFC5A-ED94-4E48-96A1-3F6217F21990'
      searches: '7D1D3A04-DEBB-4115-95CF-2F29DA2920DA'
      downloads: '374DE290-123F-4565-9164-39C4925E467B'
      appdata-locallow: 'A520A1A4-1780-4FF6-BD18-167343C5AF16'
      links: 'BFB9D5E0-C6A9-404C-B2B2-AE6DB6AF4968'
      saved-games: '4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4'

    read-shell-folders-registry-value = (value-name) -> read-registry-value shell-folders-registry-key, value-name

    get-known-folderpath-by-guid = (guid) -> read-shell-folders-registry-value "{#{ argtype '<String>' {guid} }}"

    {
      known-folder-csidls, get-known-folderpath-by-csidl,
      known-folder-guids, get-known-folderpath-by-guid
    }