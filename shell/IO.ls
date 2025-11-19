
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-object } = dependency 'os.com.Object'
    { control-chars: { lf } } = dependency 'value.string.Ascii'
    { value-or-error } = dependency 'prelude.error.Value'

    { create-error } = create-error-context 'os.shell.IO'

    arguments-as-string = (args, separator = '') -> [ (arg) for arg in args ] * "#separator"

    com-debug-writer = -> com-object 'Debug.Writer'

    debug-writer = void ; get-debug-writer = -> (if debug-writer is void => debug-writer := com-debug-writer!) ; debug-writer

    debug = -> get-debug-writer!Write arguments-as-string arguments, ' '

    [ stderr, stdout ] = do ->

      stream-write = (stream-name) -> -> WScript[ stream-name ].Write arguments-as-string arguments

      [ (stream-write stream-name) for stream-name in <[ StdErr StdOut ]> ]

    lnwrite-and-writeln = (fn) ->

      * -> fn lf ; fn ...
        -> fn ... ; fn lf

    [ lf-stderr, stderr-lf ] = lnwrite-and-writeln stderr
    [ lf-stdout, stdout-lf ] = lnwrite-and-writeln stdout

    [ stderr-lines, stdout-lines ] = do ->

      write-lines = (fn) -> -> for line in it => fn line

      [ (write-lines fn) for fn in [ stderr-lf, stdout-lf ] ]

    read-stdin = (timeout) ->

      com-object 'StdIn.Reader' => json = ..ReadStdin timeout

      { value: stdin, error: error-message } = eval "(#json)"
      if error-message isnt void => create-error error-message

      stdin

    try-read-stdin = (timeout) -> value-or-error -> read-stdin timeout

    get-key = ->

      loop

        input-event = get-console-input!get-input-event!
        continue if event is void



    {
      debug,
      stderr, lf-stderr, stderr-lf, stderr-lines,
      stdout, lf-stdout, stdout-lf, stdout-lines,
      read-stdin, try-read-stdin
    }