
  do ->

    dec = (.to-string!)

    keys = (codes, names) -> { [ (codes[index]), name ] for name, index in names }

    modifier-keys = { [(dec index + 16), name] for name, index in <[ shift ctrl alt ]> }

    digits = [ 0 to 9 ] ; alphabet = [ \a to \z ]

    numpad-keys = { [(dec index + 96), name ] for name, index in digits ++ <[ multiply add comma substract decimal divide ]> }

    system-keys = { [(dec index + 91), name ] for name, index in <[ left-windows right-windows application-menu ]> } <<< keys [ 44 19 ] <[ printscreen pause ]>

    lock-keys = { [ codekey, "#{name}lock" ] for codekey, name of keys [ 20 144 145 ] <[ caps num scroll ]> }

    browser-keys = { [ (dec index + 166), "browser-#name" ] for name, index in <[ back forward refresh stop search favorites home ]> }

    application-keys = { [ (dec index + 182), "application-#{index + 1}" ] for index til 1 } <<< keys [ 180 ] <[ mail ]>

    alphabetic-keys = { [ (dec index + 65), name ] for name, index in alphabet } <<< keys [ 32 ] <[ space ]>

    numeric-keys = { [ (dec digit + 48), dec digit ] for digit in digits }

    function-keys = { [ (dec index + 112), "f#index" ] for index to 23 }

    page-keys = { [ (dec index + 33), "page-#name" ] for name, index in <[ up down ]> }

    boundary-keys = { [ (dec index + 35), name ] for name, index in <[ end home ]> }

    arrow-keys = { [ (dec index + 37), "arrow-#name" ] for name, index in <[ left up right down ]> }

    navigation-keys = page-keys with boundary-keys with arrow-keys with keys [ 9 ] <[ tab ]>

    edition-keys = keys [ 8 45 46 ] <[ backspace insert delete ]>

    media-volume-keys = { [ (dec index + 173), "volume-#name" ] for name, index in <[ mute down up ]> }

    media-track-keys = { [ (dec index + 176), "track-#name" ] for name, index in <[ next previous ]> }

    media-keys = { [ (dec index + 178), "media-#name" ] for name, index in <[ stop play-pause ]> } with media-volume-keys with media-track-keys

    oem-keys = { [ (dec index + 187), "oem-#name" ] for name, index in <[ plus comma minus period ]> }

    {
      modifier-keys,
      numpad-keys,
      system-keys,
      lock-keys,
      browser-keys,
      application-keys,
      alphabetic-keys,
      numeric-keys,
      function-keys,
      page-keys,
      boundary-keys,
      arrow-keys,
      navigation-keys,
      edition-keys,
      media-volume-keys,
      media-track-keys,
      media-keys,
      oem-keys
    }