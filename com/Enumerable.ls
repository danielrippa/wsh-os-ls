
  do ->

    { create-error-context } = dependency 'prelude.error.Context'

    { argtype } = create-error-context 'os.com.Enumerable'

    id = -> it

    get-enumeration-items = (enumerable, fn = id) ->

      enumerator = new Enumerator (argtype '<Object>' {enumerable}) ; argtype '<Function>' {fn} ; index = 0

      items = []

      loop

        break if enumerator.at-end!

        items.push fn enumerator.item!, index++, enumerable, enumerator

        enumerator.move-next!

      items

    {
      get-enumeration-items
    }