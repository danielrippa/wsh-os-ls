
  do ->

    { create-process } = dependency 'os.shell.Process'
    { object-members-as-array } = dependency 'value.Object'
    { string-as-lines } = dependency 'value.string.Text'
    { trim-space } = dependency 'value.string.Whitespace'

    record-as-string = (key, value) -> "#key:#value"

    mkrow = (db-filepath, table-name, records-object) ->

      process = create-process 'mkrow', [ db-filepath, table-name ] ++ (object-members-as-array records-object, record-as-string)

      process <<< rows: process-as-rows process

      process

    process-as-rows = ({ stdout }) ->

      rows = [] ; return rows if stdout is void

      [ header, ...rows-lines ] = string-as-lines stdout

      column-names = header / '|'

      for row-line in rows-lines

        continue if (trim-space row-line) is ''

        row = { [ column-names[index], value ] for value, index in row-line / '|' }

        rows.push row

      rows

    {
      mkrow, process-as-rows
    }