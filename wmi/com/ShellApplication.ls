
  do ->

    { com-object } = dependency 'os.com.Object'

    com-shell-application = -> com-object 'Shell.Application'

    {
      com-shell-application
    }