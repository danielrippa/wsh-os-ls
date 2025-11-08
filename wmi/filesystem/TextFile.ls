
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-filesystem } = dependency 'os.com.FileSystem'
    { string-as-lines } = dependency 'value.string.Text'
    { value-or-error } = dependency 'prelude.error.Value'
    { delete-file } = dependency 'os.filesystem.File'

    { argtype, contextualized } = create-error-context 'os.filesystem.TextFile'

    io-modes = reading: 1, writing: 2, appending: 8

    open-textstream = (filepath, mode) -> com-filesystem!OpenTextFile (argtype '<String>' {filepath}), (argtype '<Number|Void>' {mode}), yes

    use-stream = (stream, stream-task) -> result = stream-task stream ; stream.close! ; result

    read-textfile = (filepath) -> filepath |> open-textstream _ , io-modes.reading |> use-stream _ , (.ReadAll! unless it.AtEndOfStream)

    try-read-textfile = (filepath) -> value-or-error -> read-textfile filepath

    read-textfile-lines = (filepath) -> filepath |> read-textfile |> string-as-lines

    try-read-textfile-lines = (filepath) -> value-or-error -> read-textfile-lines filepath

    write-textfile = (filepath, content) -> argtype '<String>' {content} ; open-textstream filepath, io-modes.writing |> use-stream _ , (.Write content)

    try-write-textfile = (filepath, content) -> value-or-error -> write-textfile filepath, content

    try-consume-textfile = (filepath) ->

      value-or-error ->

        content = read-textfile filepath
        delete-file filepath
        content

    {
      read-textfile, try-read-textfile, read-textfile-lines, try-read-textfile-lines,
      write-textfile, try-write-textfile,
      try-consume-textfile
    }