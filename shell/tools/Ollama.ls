
  do ->

    { create-uri-builder } = dependency 'net.URI'
    { create-instance } = dependency 'value.Instance'

    create-ollama-uri = (hostname, port = 11434) ->

      uri = create-uri-builder hostname, { port, path: 'api' }

      create-instance do

        get-generation-url: method: -> uri.with-path 'generate' .as-string!

    {
      create-ollama-uri
    }