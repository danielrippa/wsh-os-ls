
  do ->

    { create-component } = dependency 'os.shell.console.Component'
    { create-instance } = dependency 'value.Instance'

    create-text-line-editor = ->

      instance = create-instance do

        consume-input-event: method: (input-event) ->

        render: method: (screen-buffer) ->

      instance `compose-with` [ create-component! ]

    {
      create-text-line-editor
    }