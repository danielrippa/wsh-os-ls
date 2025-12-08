
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { get-associators } = dependency 'os.wmi.Wql'
    { enumerable-as-array } = dependency 'os.com.Enumerable'

    { value-as-string } = dependency 'prelude.reflection.Value'

    { create-error } = create-error-context 'os.filesystem.DiskPartition'

    get-wmi-disk-partitions = (wmi-disk, assoc-class, is-physical) ->

      wmi-disk-partitions = get-associators wmi-disk, assoc-class, 'Win32_DiskPartition'

      throw create-error "Unable to resolve Partitions for #{ if is-physical => 'Physical' else 'Logical' } Drive '#{ wmi-disk.DeviceID }'." \
        if wmi-disk-partitions.length is 0

      wmi-disk-partitions

    get-wmi-logical-disk-partitions = (wmi-logical-disk) -> get-wmi-disk-partitions wmi-logical-disk, 'Win32_LogicalDiskToPartition', no

    get-wmi-physical-disk-partitions = (wmi-physical-disk) -> get-wmi-disk-partitions wmi-physical-disk, 'Win32_DiskDriveToDiskPartition', yes

    get-wmi-disk-partition-logical-disks = (wmi-partition) -> get-associators wmi-partition, 'Win32_LogicalDiskToPartition', 'Win32_LogicalDisk'

    {
      get-wmi-logical-disk-partitions,
      get-wmi-physical-disk-partitions,
      get-wmi-disk-partition-logical-disks
    }

