
  do ->

    { create-error-context } = dependency 'prelude.error.Context'
    { control-chars } = dependency 'value.string.Ascii'

    { argtype } = create-error-context 'os.shell.terminal.Control'

    esc = (esc-value) -> argtype '<String>' {esc-value} ; "#{ control-chars.esc }#esc-value"

    csi = (csi-value) -> argtype '<String>' {csi-value} ; "#{ esc '[' }#csi-value"

    st = esc control-chars.st

    dcs = (dcs-value) -> argtype '<String>' {dcs-value} ; "#{ esc 'P' }#dcs-value#st"

    sgr = (sgr-value) -> argtype '<String>' {sgr-value} ; csi "#{ sgr-value * ';' }m"

    {
      esc,
      csi, dcs, sgr,
      st
    }