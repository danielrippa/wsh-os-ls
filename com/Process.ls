
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-object } = dependency 'os.com.Object'
    { value-or-error } = dependency 'prelude.error.Value'

    { contextualized } = create-error-context 'os.com.Process'

    com-process = ->

      { value: process, error } = value-or-error (-> com-object 'Process.Details')
      throw contextualized error unless error is void ; process

    {
      com-process
    }