
  do ->

    { known-folder-csidls, get-known-folderpath-by-csidl } = dependency 'os.filesystem.KnownFolderPath'
    { get-shell-namespace-by-csidl } = dependency 'os.shell.Namespace'
    { enumerable-as-array } = dependency 'os.com.Enumerable'

    get-drives-namespace = -> get-shell-namespace-by-csidl known-folder-csidls.drives

    get-drive = (drive-letter) -> get-drives-namespace!ParseName "#drive-letter:"

    get-drive-verbs = (drive-letter) -> get-drive drive-letter |> (.Verbs!) |> enumerable-as-array

    invoke-drive-verb = (drive-letter, verb) -> get-drive drive-letter => ..InvokeVerb verb

    {
      get-drive, get-drive-verbs, invoke-drive-verb
    }

