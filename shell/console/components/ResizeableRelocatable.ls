
  do ->

    { create-instance } = dependency 'value.Instance'

    create-resizeable-relocatable-behavior = ->

      top = left = height = width = 0

      instance = create-instance do

        resizing-events: notifier: <[ on-resized ]>
        relocation-events: notifier: <[ on-relocated ]>

        top:
          getter: -> top
          setter: -> top := it ; @relocation-events.notify <[ on-relocated ]> { top, left }

        left:
          getter: -> left
          setter: -> left := it ; @relocation-events.notify <[ on-relocated ]> { top, left }

        height:
          getter: -> height
          setter: -> height := it ; @resizing-events.notify <[ on-resized ]> { height, width }

        width:
          getter: -> width
          setter: -> width := it ; @resizing-events.notify <[ on-resized ]>  { height, width }

        relocate: method: (row, column) ->

          top := row ; left := column ; @relocation-events.notify <[ on-relocated ]> { top, left }

        resize: method: (rows, columns) ->

          height := rows ; width := columns ; @resizing-events.notify <[ on-resized ]>  { height, width }

      instance

    {
      create-resizeable-relocatable-behavior
    }