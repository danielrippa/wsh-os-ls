
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-shell-application } = dependency 'os.com.ShellApplication'

    { argtype } = create-error-context 'os.com.ShellNamespace'

    get-shell-namespace = -> com-shell-application!Namespace it

    get-shell-namespace-by-csidl = (csidl) -> get-shell-namespace (argtype '<Number>' {csidl})

    {
      get-shell-namespace, get-shell-namespace-by-csidl
    }