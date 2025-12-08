
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { wmi-service } = dependency 'os.wmi.Service'
    { enumerable-as-array } = dependency 'os.com.Enumerable'

    { argtype } = create-error-context 'os.wmi.Wql'

    wql-query-flags = return-immediately: 0x10, forward-only: 0x20

    wql-query-flags => wql-query-flags-default = ..return-immediately + ..forward-only

    wql-exec = (query, query-flags = wql-query-flags-default , service = wmi-service!) ->

      argtype '<Object>' {service} ; argtype '<String>' {query} ; argtype '<Number>' {query-flags}

      service |> (.ExecQuery query, 'WQL', query-flags)

    field-list = (list) -> if (argtype '<Array|Void>' {list}) is void then '*' else list * ', '

    predicate = (string) -> if (argtype '<String|Void>' {string}) is void then '' else "WHERE #string"

    wql-query = (wmi-class, flags, filter, fields, service) ->

      wql-exec "SELECT #{ field-list fields } FROM #wmi-class #{ predicate filter }", flags, service

    build-predicate = (options = {}) ->

      parts = []

      { assoc-class, result-class, role, result-role } = options

      if assoc-class isnt void => parts.push "AssocClass=#assoc-class"
      if result-class isnt void => parts.push "ResultClass=#result-class"
      if role isnt void => parts.push "Role=#role"
      if result-role isnt void => parts.push "ResultRole=#result-role"

      if parts.length is 0 => '' else "WHERE #{ parts * ' ' }"

    get-path = -> if (typeof it) is 'string' => it else it.Path_.Path

    wql-associators = (object, options, flags, service) ->

      wql-exec "ASSOCIATORS OF {#{ get-path object }} #{ build-predicate options }", flags, service

    get-associators = (source, assoc-class, result-class) -> enumerable-as-array wql-associators source, { assoc-class, result-class }

    wql-references = (object, options, flags, service) ->

      wql-exec "REFERENCES OF {#{ get-path object }} #{ build-predicate options }", flags, service

    {
      wql-query-flags, wql-exec,
      wql-query,
      wql-associators, get-associators,
      wql-references
    }