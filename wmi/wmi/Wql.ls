
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { wmi-service } = dependency 'os.wmi.Service'
    { get-enumeration-items } = dependency 'os.com.Enumerable'

    { argtype } = create-error-context 'os.wmi.Wql'

    wql-query-flags = return-immediately: 0x10, forward-only: 0x20

    wql-query-flags => wql-query-flags-default = ..return-immediately + ..forward-only

    wql-exec = (query, query-flags = wql-query-flags-default , service = wmi-service!) ->

      argtype '<Object>' {service} ; argtype '<String>' {query} ; argtype '<Number>' {query-flags}

      service |> (.ExecQuery query, 'WQL', query-flags) |> get-enumeration-items

    field-list = (list) -> if (argtype '<Array|Void>' {list}) is void then '*' else list * ', '

    predicate = (string) -> if (argtype '<String|Void>' {string}) is void then '' else "WHERE #string"

    wql-query = (wmi-class, flags, filter, fields, service) ->

      wql-exec "SELECT #{ field-list fields } FROM #wmi-class #{ predicate filter }", flags, service

    {
      wql-query-flags, wql-exec,
      wql-query
    }