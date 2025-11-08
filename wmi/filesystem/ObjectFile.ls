
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { try-read-textfile-lines } = dependency 'os.filesystem.TextFile'
    { file-exists } = dependency 'os.filesystem.File'
    { trim-space } = dependency 'value.string.Whitespace'
    { string-interval, string-split-by-first-segment } = dependency 'value.string.Segment'
    { keep-array-items, each-array-item } = dependency 'value.Array'
    { camel-case } = dependency 'value.string.Case'
    { value-or-error } = dependency 'prelude.error.Value'

    { create-error, contextualized } = create-error-context 'os.filesystem.ObjectFile'

    is-member-line = ->

      line = trim-space it ; return no if line is ''
      initial-char = line `string-interval` [ 0, 1 ] ; return no if initial-char is '#'

      yes

    read-objectfile = (filepath) ->

      throw create-error "Object file '#filepath' not found." unless file-exists filepath

      { value: textfile-lines, error } = try-read-textfile-lines filepath
      throw contextualized error unless error is void

      member-lines = textfile-lines |> keep-array-items _ , is-member-line

      object = {}

      each-array-item member-lines, (line) ->

        [ member-name, member-value ] = line `string-split-by-first-segment` ' '

        return if member-value is void

        object[ camel-case member-name ] := member-value

      object

    try-read-objectfile = (filepath) -> value-or-error -> read-objectfile filepath

    {
      read-objectfile, try-read-objectfile
    }

