
  do ->

    { com-object } = dependency 'os.com.Object'

    xml-http-progids = <[ WinHttp.WinHttpRequest.5.1 MSXML2.XMLHTTP.6.0 ]>

    create-xml-http = -> for progid in xml-http-progids => try http-request = com-object progid ; return http-request

    {
      create-xml-http
    }