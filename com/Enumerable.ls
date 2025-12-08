
  do ->

    { create-error-context } = dependency 'prelude.error.Context'

    { argtype } = create-error-context 'os.com.Enumerable'

    id = -> it

    enumerable-as-array = (enumerable, fn = id) ->

      enumerator = new Enumerator (argtype '<Object>' {enumerable}) ; argtype '<Function>' {fn} ; index = 0

      items = []

      loop

        break if enumerator.at-end!

        items.push fn enumerator.item!, index++, enumerable, enumerator

        enumerator.move-next!

      items

    {
      enumerable-as-array
    }