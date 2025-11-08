
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { try-validate-tool-in-path } = dependency 'os.shell.Tool'
    { create-process } = dependency 'os.shell.Process'
    { double-quotes } = dependency 'value.string.Quotes'

    { value-as-string } = dependency 'prelude.reflection.Value'

    { argtype, contextualized } = create-error-context 'os.shell.tools.Pug'

    pug = (pug-filepath, extension, output-folderpath, json-filepath) ->

      { error } = try-validate-tool-in-path 'pug' ; throw contextualized error unless error is void

      argtype '<String>' {pug-filepath} ; argtype '<String>' {extension}
      argtype '<String|Void>' {output-folderpath} ; argtype '<String|Void>' {json-filepath}

      args = <[ --silent --pretty --extension ]> ++ extension

      if output-folderpath isnt void => args = args ++ [ '--out', double-quotes output-folderpath ]
      if json-filepath isnt void => args = args ++ [ '--obj', double-quotes json-filepath ]

      create-process 'pug', args ++ pug-filepath

    {
      pug
    }
