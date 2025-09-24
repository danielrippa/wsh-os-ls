
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { create-instance } = dependency 'value.Instance'

    { argtype, create-error } = create-error-context 'os.shell.console.components.Component'

    create-component-manager = ->

      component-types-by-name = {} ; components-by-id = {} ; components-by-type-name = {}

      create-instance do

        component-type-events: notifier: <[ on-component-type-registered ]>
        component-events: notifier: <[ on-component-created ]>

        register-component-type: method: (component-type-name, component-constructor) ->

          throw argerror {component-type-name} "is an already registered component type name" if component-types-by-name[ argtype '<String>' {component-type-name} ] isnt void

          component-types-by-name[ component-type-name ] := (argtype '<Function>' {component-constructor})

          @component-type-events.notify <[ on-component-registered ]> component-type-name, component-constructor

        create-component: method: (component-type-name) ->

          component-constructor = component-types-by-name[ argtype '<String>' {component-type-name} ]

          throw argerror {component-type-name} "is not registered. Unable to create component" if component-constructor is void

          try component = component-constructor! ; component-id = component.get-id!
          catch error => throw create-error "Unable to create component '#component-type-name' instance", error

          components = components-by-type-name[ component-type-name ]
          if components is void => components = {} ; components-by-type-name[ component-type-name ] := components

          components[ component-id ] = component ; components-by-id[ component-id ] := component

          @component-events.notify <[ on-component-created ]> component, component-id, component-type-name

          component

    component-manager = void ; get-component-manager = -> (if component-manager is void => component-manager := create-component-manager!) ; component-manager

    {
      get-component-manager
    }