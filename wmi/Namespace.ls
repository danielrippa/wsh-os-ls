
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { map-object } = dependency 'value.Object'
    { build-path } = dependency 'os.filesystem.Path'

    { argtype } = create-error-context 'os.wmi.Namespace'

    namespace = -> build-path <[ root ]> ++ it

    wmi-namespaces = map-object do

      cim: <[ cimv2 ]>
      subscription: <[ subscription ]>
      wmi: <[ WMI ]>
      ldap: <[ directory LDAP ]>
      storage: <[ Microsoft Windows Storage ]>
      security-center: <[ SecurityCenter2 ]>

      void
      namespace

    wmi-namespace = (resource, path = wmi-namespaces.cim, host = '.') ->

      argtype '<String>' {path} ; argtype '<String>' {host}

      namespace = build-path [ "winmgmts:", '', host ] ++ [ path ]

      if (argtype '<String|Void>' {resource}) isnt void

        namespace = build-path [ namespace, resource ]

      namespace

    {
      wmi-namespace
    }