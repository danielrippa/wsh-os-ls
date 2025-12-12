
  do ->

    { com-object } = dependency 'os.com.Object'

    com-shell = -> com-object 'WScript.Shell'

    run = (command, window-style, wait-on-return) -> com-shell!Run command, window-style, wait-on-return

    {
      com-shell, run
    }