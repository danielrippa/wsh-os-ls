
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { tool } = dependency 'os.shell.Tool'
    { get-temporary-filepath } = dependency 'os.filesystem.TemporaryFile'
    { try-write-textfile } = dependency 'os.filesystem.TextFile'
    { lines-as-string, string-as-lines } = dependency 'value.string.Text'
    { try-delete-file } = dependency 'os.filesystem.File'
    { value-or-error } = dependency 'prelude.error.Value'

    { value-as-string } = dependency 'prelude.reflection.Value'

    { argtype, contextualized } = create-error-context 'os.shell.tools.Schemagen'

    schemagen = (command, filepath) -> tool 'schemagen', command, filepath

    entity-lines-as-schemagen-output-lines = (command, lines) ->

      filepath = get-temporary-filepath!

      for-lines = "for entity lines: '#{ lines * ', ' }'"

      { error } = try-write-textfile filepath, lines-as-string lines
      throw create-error "Unable to create schema file #for-lines.", error unless error is void

      { stdout: schemagen-output, errorlevel, stderr: error } = schemagen command, filepath
      throw create-error "Unable to execute schemagen tool #for-lines.", error if errorlevel isnt 0

      try-delete-file filepath ; schemagen-output |> string-as-lines

    entity-lines-as-puml-lines = (lines) -> entity-lines-as-schemagen-output-lines 'puml', lines

    try-entity-lines-as-puml-lines = (lines) -> value-or-error -> entity-lines-as-puml-lines lines

    entity-lines-as-sql-lines = (lines) -> entity-lines-as-schemagen-output-lines 'sql', lines

    try-entity-lines-as-sql-lines = (lines) -> value-or-error -> entity-lines-as-sql-lines lines

    {
      try-entity-lines-as-puml-lines,
      try-entity-lines-as-sql-lines,
      entity-lines-as-puml-lines,
      entity-lines-as-sql-lines
    }