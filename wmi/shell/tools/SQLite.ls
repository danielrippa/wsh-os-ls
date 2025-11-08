
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { create-process } = dependency 'os.shell.Process'
    { parse-path, recompose-parsed-path } = dependency 'os.filesystem.Path'
    { double-quotes } = dependency 'value.string.Quotes'
    { tool } = dependency 'os.shell.Tool'

    { argtype } = create-error-context 'os.shell.tools.SQLite'

    normalize-db-filepath = (filepath) -> filepath |> parse-path |> (-> (if it.extension is '' then it.extension = 'db') ; it) |> recompose-parsed-path

    quoted = -> [ double-quotes arg for arg in it ] * ' '

    sqlite = (db-filepath, ...args) -> tool 'sqlite' (normalize-db-filepath db-filepath), quoted args

    {
      sqlite
    }