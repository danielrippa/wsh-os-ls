
  do ->

    safe-array-as-array = (safe-array) ->

      return [] if safe-array is void

      try return new VBArray safe-array .to-array!
      catch => return [safe-array]

    {
      safe-array-as-array
    }