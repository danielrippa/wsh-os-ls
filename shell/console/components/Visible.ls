
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { create-instance } = dependency 'value.Instance'

    { context } = create-error-context 'os.shell.console.components.Visible'

    create-visible-behavior = (visible = yes) ->

      { argtype } = context 'create-visible-behavior'

      argtype '<Boolean>' {visible}

      create-instance do

        visibility-events: notifier: <[ on-visibility-changed ]>

        visible:
          getter: -> visible
          setter: (new-visible-state) -> visible := (argtype '<Boolean>' {new-visible-state}) ; @visibility-events.notify <[ on-visibility-changed ]> @

        hide: method: -> @set-visible no
        show: method: -> @set-visible on

        toggle-visibility: method: -> @set-visible not @get-visible!

    {
      create-visible-behavior
    }