
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { com-object } = dependency 'os.com.Object'
    { value-or-error } = dependency 'prelude.error.Value'
    { build-path } = dependency 'os.filesystem.Path'

    { value-as-string } = dependency 'prelude.reflection.Value'

    { argtype, create-error, argerror } = create-error-context 'os.shell.Credentials'

    vault = com-object 'Credential.GenericVault'

    valid-persistence-types = [ (index + 1) for value, index in <[ session local-machine enterprise ]> ]

    collect-credential = (target-name, user-name, persistence-type = 2, title) ->

      if (argtype '<Number>' {persistence-type}) not in valid-persistence-types => argerror {persistence-type} "Must be any of #{ valid-persistence-types * ', ' }."

      json = vault.CollectCredential (argtype '<String>' {target-name}), (argtype '<String>' {user-name}), persistence-type, (argtype '<String|Void>' {title})
      { Value, Error } = eval "(#json)"

      if Error => throw create-error Error
      if Value.Cancelled => return void

      Value

    try-collect-credential = (target-name, persistence-type, title) -> value-or-error -> collect-credential target-name, persistence-type, title

    read-credential = (target-name) ->

      json = vault.ReadCredential target-name ; { Value, Error } = eval "(#json)"
      if Error => throw create-error Error

      Value

    try-read-credential = (target-name) -> value-or-error -> read-credential target-name

    {
      collect-credential, try-collect-credential,
      read-credential, try-read-credential
    }
