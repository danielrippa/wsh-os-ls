
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { wql-query } = dependency 'os.wmi.Wql'
    { enumerable-as-array } = dependency 'os.com.Enumerable'

    { create-error } = create-error-context 'os.filesystem.LogicalDisk'

    get-bytes = -> try parse-int it catch => 0

    get-wmi-logical-disk = (drive-letter) ->

      [ wmi-logical-disk ] = enumerable-as-array wql-query 'Win32_LogicalDisk',, "DeviceID='#drive-letter:'"

      throw create-error "Logical Disk '#drive-letter' not found." if wmi-logical-disk is void

      wmi-logical-disk

    {
      get-wmi-logical-disk
    }