object TicRepModuleUnit: TTicRepModuleUnit
  OldCreateOrder = False
  Height = 244
  Width = 518
  object frxDBDOrganizacion: TfrxDBDataset
    UserName = 'frxDBDOrganizacion'
    CloseDataSource = False
    FieldAliases.Strings = (
      'codigoorganizacion=codigoorganizacion'
      'nombreorganizacion=nombreorganizacion'
      'tituloorganizacion=tituloorganizacion'
      'descripcion=descripcion'
      'comentarios=comentarios'
      'telefono1=telefono1'
      'telefono2=telefono2'
      'telefono3=telefono3'
      'telefono4=telefono4'
      'telefono5=telefono5'
      'rfc=rfc'
      'codigopadre=codigopadre')
    DataSet = ClientModule1.cdOrganizacion
    BCDToCurrency = False
    Left = 128
    Top = 8
  end
  object frxDBPersonal: TfrxDBDataset
    UserName = 'frxDBPersonal'
    CloseDataSource = False
    FieldAliases.Strings = (
      'Nombres=Nombres'
      'APaterno=APaterno'
      'AMaterno=AMaterno'
      'NombreCompleto=NombreCompleto'
      'codigopersonal=codigopersonal'
      'curp=curp'
      'descripcion=descripcion'
      'idpersonal=idpersonal'
      'imagenpersonal=imagenpersonal'
      'numerosegurosocial=numerosegurosocial'
      'fechaalta=fechaalta'
      'Gruposanguineo=Gruposanguineo'
      'rfc=rfc'
      'telefono=telefono'
      'contacto=contacto'
      'telefonocontacto=telefonocontacto'
      'doccontratacion=doccontratacion'
      'idcargo=idcargo'
      'titulocargo,=titulocargo,'
      'nivel=nivel'
      'iddepartamento=iddepartamento'
      'titulodepartamento=titulodepartamento'
      'CodigoSalario=CodigoSalario'
      'fechaaplicacion=fechaaplicacion'
      'IdLlave=IdLlave'
      'salario=salario'
      'codigomoneda=codigomoneda'
      'TituloMoneda=TituloMoneda'
      'Simbolo=Simbolo')
    BCDToCurrency = False
    Left = 40
    Top = 8
  end
  object frxDBDResguardo: TfrxDBDataset
    UserName = 'frxDBDResguardo'
    CloseDataSource = False
    FieldAliases.Strings = (
      'aprobo=aprobo'
      'area=area'
      'codigoticresguardo=codigoticresguardo'
      'comentarios=comentarios'
      'enterado=enterado'
      'entrego=entrego'
      'idticresguardos=idticresguardos'
      'idusuario=idusuario'
      'numresguardo=numresguardo'
      'recibio=recibio'
      'tiporesguardo=tiporesguardo'
      'codigoinsumo=codigoinsumo'
      'fechaasig=fechaasig'
      'fechavigencia=fechavigencia'
      'IdAcceso=IdAcceso'
      'idarticulo=idarticulo'
      'idpersonal=idpersonal'
      'idresguardodetalle=idresguardodetalle'
      'idresguardoentrega=idresguardoentrega'
      'idresguardorecibido=idresguardorecibido'
      'numinsumoespecificado=numinsumoespecificado'
      'tituloarticulo=tituloarticulo'
      'codigopersonal=codigopersonal'
      'personalrecibio=personalrecibio'
      'personalentrego=personalentrego'
      'personalenterado=personalenterado'
      'personalaprobo=personalaprobo ')
    BCDToCurrency = False
    Left = 128
    Top = 56
  end
  object frxDBdevueltos: TfrxDBDataset
    UserName = 'frxDBdevueltos'
    CloseDataSource = False
    FieldAliases.Strings = (
      'aprobo=aprobo'
      'area=area'
      'codigoticresguardo=codigoticresguardo'
      'comentarios=comentarios'
      'enterado=enterado'
      'entrego=entrego'
      'idticresguardos=idticresguardos'
      'idusuario=idusuario'
      'numresguardo=numresguardo'
      'recibio=recibio'
      'tiporesguardo=tiporesguardo'
      'codigoinsumo=codigoinsumo'
      'fechaasig=fechaasig'
      'fechavigencia=fechavigencia'
      'IdAcceso=IdAcceso'
      'idarticulo=idarticulo'
      'idpersonal=idpersonal'
      'dresguardodetalle=dresguardodetalle'
      'idresguardoentrega=idresguardoentrega'
      'idresguardorecibido=idresguardorecibido'
      'numinsumoespecificado=numinsumoespecificado'
      'descripcioninsumo=descripcioninsumo'
      'tituloarticulo=tituloarticulo'
      'codigopersonal=codigopersonal'
      'personalrecibio=personalrecibio'
      'personalentrego=personalentrego'
      'personalenterado=personalenterado '
      'personalaprobo=personalaprobo')
    BCDToCurrency = False
    Left = 40
    Top = 56
  end
  object frxDBDMantenimientos: TfrxDBDataset
    UserName = 'frxDBDMantenimientos'
    CloseDataSource = False
    FieldAliases.Strings = (
      'asignado=asignado'
      'codigoinsumo=codigoinsumo'
      'codigomantenimiento=codigomantenimiento'
      'descripcionfallas=descripcionfallas'
      'fechamantto=fechamantto'
      'idmantenimiento=idmantenimiento'
      'numinsumoespecificado=numinsumoespecificado'
      'pospuesto=pospuesto'
      'realizo=realizo'
      'tareasrealizadas=tareasrealizadas'
      'tipommanto=tipommanto'
      'personalr=personalr'
      'personala=personala')
    BCDToCurrency = False
    Left = 40
    Top = 112
  end
end
