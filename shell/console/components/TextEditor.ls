
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { create-instance } = dependency 'value.Instance'
    { create-component } = dependency 'os.shell.console.Component'
    { create-text-line-editor } = dependency 'os.shell.console.components.TextLine'

    { context } = create-error-context 'os.shell.console.components.TextEditor'

    #

    create-text-lines-view = (text-editor) ->

    #

    create-line-number-gutter = (text-editor) ->

      instance = create-instance do

        render: method: (screen-buffer) ->

      instance `compose-with` [ create-component! ]

    #

    text-document-model-type = '{ ... }'

    create-text-editor-component = (text-document-model) ->

      { argtype } = context 'create-text-editor-model' ; argtype text-document-model-type, text-document-model

      line-editor = upper-lines-view = lower-lines-view = void

      instance = create-instance do

        text-document: getter: -> text-document-model

        upper-lines: getter: -> upper-lines-view
        lower-lines: getter: -> lower-lines-view

        line-editor: getter: -> line-editor

        render: (screen-buffer) -> for sub-component in [ upper-lines-view, lower-lines-view ] => sub-component.render screen-buffer

        consume-input-event: method: (input-event) -> line-editor.consume-input-event input-event

      instance `compose-with` [ create-component! ]

      [ upper-lines-view, lower-lines-view ] = [ (create-text-lines-view instance) til 2 ] ;

      line-editor = create-text-line-editor instance ; line-numbers-gutter = void

    {
      create-text-editor-model
    }