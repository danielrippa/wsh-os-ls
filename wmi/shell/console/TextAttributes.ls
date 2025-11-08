
  do ->

    { create-instance } = dependency 'value.Instance'
    { com-object } = dependency 'os.com.Object'

    create-text-attributes = (value = 0) ->

      com-attributes = com-object 'Console.TextAttributes'

      com-attributes.Value = value

      create-instance do

        value:
          getter: -> com-attributes.Value
          setter: -> com.attributes.Value = it

        ink: setter: ({ red = false, green = false, blue = false, intensity = false }) ->

          com-attributes.SetInk red, green, blue, intensity

        paper: setter: ({ red = false, green = false, blue = false, intensity = false }) ->

          com-attributes.SetPaper red, green, blue, intensity

        borders: setter: ({ top = false, left = false, bottom = false, right = false }) ->

          com-attributes.SetBorders top, left, bottom, right

        inverted: setter: -> com-attributes.SetInverted it

        set-attributes: method: ({ ink = {}, paper = {}, borders = {}, inverted = false }) ->

          { red: ink-red = false, green: ink-green = false, blue: ink-blue = false, intensity: ink-intensity = false } = ink
          { red: paper-red = false, green: paper-green = false, blue: paper-blue = false, intensity: paper-intensity = false } = paper
          { top = false, left = false, bottom = false, right = false } = borders

          com-attributes.SetAll do

            ink-red
            ink-green
            ink-blue
            ink-intensity
            paper-red
            paper-green
            paper-blue
            paper-intensity
            top
            left
            bottom
            right
            inverted

        enable-ink-bits: method: (red = false, green = false, blue = false, intensity = false) ->

          com-attributes.EnableInkBits red, green, blue, intensity

        disable-ink-bits: method: (red = false, green = false, blue = false, intensity = false) ->

          com-attributes.DisableInkBits red, green, blue, intensity

        enable-paper-bits: method: (red = false, green = false, blue = false, intensity = false) ->

          com-attributes.EnablePaperBits red, green, blue, intensity

        disable-paper-bits: method: (red = false, green = false, blue = false, intensity = false) ->

          com-attributes.DisablePaperBits red, green, blue, intensity

        enable-border-bits: method: (top = false, left = false, bottom = false, right = false) ->

          com-attributes.EnableBorderBits top, left, bottom, right

        disable-border-bits: method: (top = false, left = false, bottom = false, right = false) ->

          com-attributes.DisableBorderBits top, left, bottom, right

    text-color = (red = false, green = false, blue = false, intensity = false) -> { red, green, blue, intensity }
    text-border = (top = false, left = false, bottom = false, right = false) -> { top, left, bottom, right }

    text-colors =

      black: text-color!
      red: text-color on
      green: text-color off on
      curry: text-color on on
      navy: text-color off off on
      purple: text-color on off on
      celestial: text-color off on on
      gray: text-color on on on

      silver: text-color off off off on
      vermillion: text-color on off off on
      emerald: text-color off on off on
      yellow: text-color on on off on
      blue: text-color off off on on
      fuchsia: text-color on off on on
      turquoise: text-color off on on on
      white: text-color on on on on

    text-borders =

      top: text-border on
      sides: text-border off on on
      underlined: text-border off off off on

      nw: text-border on on
      ne: text-border on off on
      se: text-border off off on on
      sw: text-border off on off on

      ew: text-border off on on
      ns: text-border on off off on

      all: text-border on on on on

    {
      create-text-attributes,
      text-color, text-colors,
      text-border, text-borders
    }
