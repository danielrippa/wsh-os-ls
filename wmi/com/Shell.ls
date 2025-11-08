
  do ->

    { com-object } = dependency 'os.com.Object'

    com-shell = -> com-object 'WScript.Shell'

    {
      com-shell
    }