
  do ->

    { create-instance } = dependency 'value.Instance'
    { create-bounded-behavior } = dependency 'os.shell.console.components.Bounded'
    { drop-array-items } = dependency 'value.Array'

    max-node-components = 4
    max-quadtree-recursion-depth = 8

    create-quadtree-node = (row, column, height, width, initial-depth, quadtree) ->

      components = [] ; child-quadtree-nodes = [] ; is-split = no

      horizontal-divider = column + (Math.floor width / 2)
      vertical-divider = row + (Math.floor height / 2)

      instance = create-instance do

        components: getter: -> components

        is-split: method: -> is-split

        split-node: method: ->

          top-half-height = Math.floor height / 2 ; bottom-half-height = height - top-half-height
          left-half-width = Math.floor width / 2 ; right-half-width = width - left-half-width

          new-depth = initial-depth + 1

          child-quadtree-nodes

            ..push create-quadtree-node row, column, top-half-height, left-half-width, new-depth, quadtree
            ..push create-quadtree-node row, (column + left-half-width), top-half-height, right-half-width, new-depth, quadtree
            ..push create-quadtree-node (row + top-half-height), column, bottom-half-height, left-half-width, new-depth, quadtree
            ..push create-quadtree-node (row + top-half-height), (column + left-half-width), bottom-half-height, right-half-width, new-depth, quadtree

          is-split := yes

          old-components = components ; components := []

          for component in old-components => @insert-component component

        insert-component: method: (component) ->

          return no unless @intersects component

          if is-split

            indices = @get-child-node-indices component

            if indices.length is 1

              child-node = child-quadtree-nodes[ indices.0 ] ; child-node.insert-component component

            else

              components.push component

          else

            components.push component

            if components.length > max-node-components and initial-depth < max-quadtree-recursion-depth

              @split-node!

              old-components = components ; components := []

              for component in old-components => @insert-component component

          yes

        remove-component: method: (component) ->

          return no unless @intersects component

          initial-component-count = components.length

          components := drop-array-items components, (== component)

          removed-here = initial-component-count isnt components.length

          if is-split

            indices = @get-child-node-indices component

            if indices.length is 1

              child-node = child-quadtree-nodes[ indices.0 ]

              removed-from-child = child-node.remove-component component

              if removed-from-child then yes else removed-here

            else

              removed-here

          else

            removed-here

        get-child-node-indices: method: (component) ->

          indices = []

          { top, left, bottom, right } = component.get-bounding-box!

          fits-top-left = right < vertical-divider and bottom < horizontal-divider
          fits-top-right = left >= vertical-divider and bottom < horizontal-divider
          fits-bottom-left = right < vertical-divider and top >= horizontal-divider
          fits-bottom-right = left >= vertical-divider and top >= horizontal-divider

          indices

            ..push 0 if fits-top-left
            ..push 1 if fits-top-right
            ..push 2 if fits-bottom-left
            ..push 3 if fits-bottom-right

          indices

        get-component-at-location: method: (top, left) ->

          for index from components.length - 1 to 0 by -1

            component = components[index] ; return component if component.contains-location top, left

          if is-split

            child-index =

              if left < vertical-divider
                if top < horizontal-divider
                  0
                else
                  2
              else
                if top < horizontal-divider
                  1
                else
                  3

            component = child-quadtree-nodes[ child-index ].get-component-at-location top, left

            return component if component?

          void

    #

    create-quadtree = (row, column, height, width) ->

      instance = create-instance do

        insert-component: method: (component) -> root.insert-component component
        remove-component: method: (component) -> root.remove-component component

        get-component-at-location: method: (top, left) -> root.get-component-at-location (row + top), (column + left)

      root = create-quadtree-node row, column, height, width, 0, instance

    {
      create-quadtree
    }