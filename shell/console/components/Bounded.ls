
  do ->

    create-bounded-behavior = (rows, columns) ->

      { argtype } = context 'create-component-size-behavior'
      argtype '<Number>' {rows} ; argtype '<Number>' {column}

      row = column = 0

      create-instance do

        size-events: notifier: <[ on-resize ]>
        location-events: notifier: <[ on-relocation ]>

        resize: member: (new-height, new-width) ->

          @size-events.notify <[ on-resize ]> rows, (argtype '<Number>' {new-height}), columns, (argtype '<Number>' {new-width})
          rows := new-height ; columns := new-width

        relocate: member: (new-top, new-left) ->

          @location-events.notify <[ on-relocation ]> row, (argtype '<Number>' {new-top}), column, (argtype '<Number>' {new-left})
          row := new-top ; column := new-left

        top:
          getter: -> row
          setter: -> @relocate it, @get-left!

        left:
          getter: -> column
          setter: -> @relocate @get-top!, it

        bottom: getter: -> row + rows
        right: getter: -> column + columns

        bounding-box: getter: -> { top: row, left: column, bottom: @get-bottom!, right: @get-right! }

        size: getter: -> { height: rows, width: columns }

        intersects: method: (other) ->

          { top, left, bottom, right } = @get-bounding-box! ; { top: other-top, left: other-left, bottom: other-bottom, right: other-right } = other.get-bounding-box!

          if left < other-right
            if right > other-left
              if top < other-bottom
                if bottom > other-top

                  return yes

          no

        contains: method: (other) ->

          { top, left, bottom, right } = @get-bounding-box! ; { top: other-top, left: other-left, bottom: other-bottom, right: other-right } = other.get-bounding-box!

          if left <= other-left
            if right >= other-right
              if top <= other-top
                if bottom >= other-bottom

                  return yes

          no

        contains-location: method: (row, column) ->

          { top, left, bottom, right } = @get-bounding-box!

          if column >= left
            if column < right
              if row >= top
                if row < bottom

                  return yes

          no

    {
      create-bounded-behavior
    }