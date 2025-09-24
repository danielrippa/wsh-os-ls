
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-filesystem } = dependency 'os.com.FileSystem'
    { string-as-lines } = dependency 'value.string.Text'
    { value-or-error } = dependency 'prelude.error.Value'

    { argtype, contextualized } = create-error-context 'os.filesystem.TextFile'

    io-modes = reading: 1, writing: 2, appending: 8 ; fso = com-filesystem!

    open-textstrean = (filepath, mode) -> fso.OpenTextFile (argtype '<String>' {filepath}), (argtype '<Number|Void>' {mode}), yes

    use-stream = (stream, stream-task) -> result = stream-task stream ; stream.close! ; result

    try-read-textfile = (filepath) -> value-or-error -> open-textstream filepath, io-modes.reading |> use-stream _ , (.ReadAll!)

    try-read-textfile-lines = (filepath) -> failure-result = try-read-textfile filepath ; { value: content, error } = failure-result => return .. unless error is void ; content |> string-as-lines

    try-write-textfile = (filepath, content) -> value-or-error -> open-textstream filepath, io-modes.writing |> use-stream _ , (.Write (argtype '<String>' {content}))

    try-consume-textfile = (filepath) ->

      { value: content, error } = try-read-textfile filepath ; return { error: contextualized error } if error?
      { value, error } = try-delete-file filepath ; return { error: contextualized error } if error?

      { value: content }

    {
      try-read-textfile, try-read-textfile-lines,
      try-write-textfile,
      try-consume-textfile
    }