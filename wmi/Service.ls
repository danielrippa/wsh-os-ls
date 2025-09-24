
  do ->

    { wmi-namespace } = dependency 'os.wmi.Namespace'
    { get-com-object } = dependency 'os.com.Object'

    wmi-service = (namespace = wmi-namespace!) -> get-com-object namespace

    {
      wmi-service
    }