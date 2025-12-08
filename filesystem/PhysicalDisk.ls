
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { wql-associators } = dependency 'os.wmi.Wql'
    { enumerable-as-array } = dependency 'os.com.Enumerable'
    { safe-array-as-array } = dependency 'os.com.SafeArray'

    { create-error } = create-error-context 'os.filesystem.PhysicalDisk'

    get-bytes = -> try parse-int it catch => 0

    disk-capability-type-names = <[
      unknown
      other
      sequential-access
      random-access
      supports-writing
      encryption
      compression
      removable-media
      manual-cleaning
      automatic-cleaning
      smart-notification
      supports-dual-sided-media
      ejectable
    ]>

    get-capabilities = (wmi-capabilities) ->

      capabilities = []

      capability-codes = safe-array-as-array wmi-capabilities

      for capability-code in capability-codes

        name = disk-capability-type-names[ capability-code ]

        capabilities.push if name isnt void then name else "unknown-code-#capability-code"

      capabilities

    get-wmi-physical-disk = (wmi-partition) ->

      id = wmi-partition.Name

      [ wmi-physical-disk ] = enumerable-as-array wql-associators wmi-partition, assoc-class: 'Win32_DiskDriveToDiskPartition', result-class: 'Win32_DiskDrive'
      throw create-error "Unable to resolve Physical Disk for Partition '#id'." if wmi-physical-disk is void

      wmi-physical-disk

    get-wmi-physical-disk-capabilities = (wmi-physical-disk) -> get-capabilities wmi-physical-disk.Capabilities

    {
      get-wmi-physical-disk,
      get-wmi-physical-disk-capabilities
    }