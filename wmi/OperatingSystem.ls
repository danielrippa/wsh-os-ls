
  do ->

    { wql-query } = dependency 'os.wmi.Wql'

    get-operating-system ->

      [ os ] = wql-query "Win32_OperatingSystem" ;
      { Caption: name, ProductType: type, Version: version, BuildNumber: build, OSArchitecture: architecture } = os

      { name, type, version, build, architecture }

    {
      get-operating-system
    }