
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { value-or-error } = dependency 'prelude.error.Value'

    { argtype, create-error } = create-error-context 'os.com.Object'

    com-object = (automation-id) ->

      argtype '<String>' {automation-id}

      { value: com-automation-instance, error } = value-or-error -> new ActiveXObject automation-id
      throw create-error "Unable to create '#automation-id' com automation instance", error unless error is void

      com-automation-instance

    get-com-object = (automation-id) ->

      argtype '<String>' {automation-id}

      { value: com-automation-instance, error } = value-or-error -> GetObject automation-id
      throw create-error "Unable to create '#automation-id' com automation instance", error unless error is void

      com-automation-instance

    com-object-as-object = (some-com-object) ->

      properties = {} ; e = new Enumerator some-com-object.Properties_

      loop

        break if e.atEnd!

        item = e.item!

        properties[ item.Name ] = item.Value

        e.moveNext!

      properties

    {
      com-object, get-com-object,
      com-object-as-object
    }