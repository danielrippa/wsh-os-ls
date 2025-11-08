
  do ->

    { com-object } = dependency 'os.com.Object'

    com-filesystem = -> com-object 'Scripting.FileSystemObject'

    {
      com-filesystem
    }