inherited FrmDatosAlmacen: TFrmDatosAlmacen
  Caption = 'Datos del almac'#233'n'
  ClientHeight = 305
  ClientWidth = 390
  ExplicitWidth = 406
  ExplicitHeight = 343
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelBarraLugar: TPanel
    Top = 256
    Width = 390
    ExplicitTop = 256
    ExplicitWidth = 390
  end
  inherited PanelDatosLugares: TPanel
    Width = 390
    Height = 256
    ExplicitWidth = 390
    ExplicitHeight = 256
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 33
      Height = 13
      Caption = 'C'#243'digo'
    end
    object Label2: TLabel
      Left = 16
      Top = 43
      Width = 26
      Height = 13
      Caption = 'T'#237'tulo'
    end
    object Image1: TImage
      Left = 355
      Top = 48
      Width = 17
      Height = 16
      Cursor = crHandPoint
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000100000
        001008060000001FF3FF610000001974455874536F6674776172650041646F62
        6520496D616765526561647971C9653C000001764944415478DA63FCFFFF3F03
        258071701970318D91819191018C9998186602858C81F8ECBF7F0CE9206520AC
        3FEB3F6E032EA432A60135A701856681689D3407E32BB30E9C85F141B4C1ECFF
        B3701A703A81F18C69AE8BF19595276E7D7FF5E5B376B285F1D5B927CE728AF1
        F0AA0719A95D9871E8ACE982FF26380D381AC598C6C2CD96AB1EA4AFF3F4E483
        E752E6F292CF4E3E7C2E61222B7967E3952B7FBEFE9A6CBD0C8F0BF6043282A8
        3410D68BD23306C981F0951557CE02C5401A67B9ACC713069B3D18D3B804D873
        B5FCE4751E9E7EF95CCE5854F2D1D9D7CFA50D84246F6E7D72E5FBA7DF937D77
        E071C16A07C633AE45AAC627963EB8F5F9E5EFCF76A9E2C68766BF3CCB2BCECA
        6BE027A87678F6ABB3A107F084C16C43C6346094A5DDFEC6304B958B212DB49A
        DB7875EBD7B3303E88EEB98DC7058C8C8CAC404A1C88B9D3C519EA15D919D4EE
        FF64B835F325433D50EC0F10BF00AAFF8ECF0066202500C4EC58121DC8800F40
        F5BF701A400E187803004C4CCFE175D027640000000049454E44AE426082}
    end
    object Label5: TLabel
      Left = 16
      Top = 70
      Width = 45
      Height = 13
      Caption = 'Ubicaci'#243'n'
    end
    object Label3: TLabel
      Left = 16
      Top = 124
      Width = 54
      Height = 13
      Caption = 'Descripci'#243'n'
    end
    object Label4: TLabel
      Left = 16
      Top = 178
      Width = 60
      Height = 13
      Caption = 'Comentarios'
    end
    object Image2: TImage
      Left = 212
      Top = 17
      Width = 17
      Height = 16
      Cursor = crHandPoint
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000100000
        001008060000001FF3FF610000001974455874536F6674776172650041646F62
        6520496D616765526561647971C9653C000001764944415478DA63FCFFFF3F03
        258071701970318D91819191018C9998186602858C81F8ECBF7F0CE9206520AC
        3FEB3F6E032EA432A60135A701856681689D3407E32BB30E9C85F141B4C1ECFF
        B3701A703A81F18C69AE8BF19595276E7D7FF5E5B376B285F1D5B927CE728AF1
        F0AA0719A95D9871E8ACE982FF26380D381AC598C6C2CD96AB1EA4AFF3F4E483
        E752E6F292CF4E3E7C2E61222B7967E3952B7FBEFE9A6CBD0C8F0BF6043282A8
        3410D68BD23306C981F0951557CE02C5401A67B9ACC713069B3D18D3B804D873
        B5FCE4751E9E7EF95CCE5854F2D1D9D7CFA50D84246F6E7D72E5FBA7DF937D77
        E071C16A07C633AE45AAC627963EB8F5F9E5EFCF76A9E2C68766BF3CCB2BCECA
        6BE027A87678F6ABB3A107F084C16C43C6346094A5DDFEC6304B958B212DB49A
        DB7875EBD7B3303E88EEB98DC7058C8C8CAC404A1C88B9D3C519EA15D919D4EE
        FF64B835F325433D50EC0F10BF00AAFF8ECF0066202500C4EC58121DC8800F40
        F5BF701A400E187803004C4CCFE175D027640000000049454E44AE426082}
    end
    object DBEditCodigo: TDBEdit
      Left = 85
      Top = 16
      Width = 121
      Height = 21
      DataField = 'codigoalmacen'
      DataSource = dsDatos
      TabOrder = 0
    end
    object DBEditTitulo: TDBEdit
      Left = 84
      Top = 43
      Width = 262
      Height = 21
      DataField = 'tituloalmacen'
      DataSource = dsDatos
      TabOrder = 1
    end
    object DBMemoUbicacion: TDBRichEdit
      Left = 88
      Top = 70
      Width = 261
      Height = 48
      DataField = 'ubicacion'
      DataSource = dsDatos
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      PlainText = True
      TabOrder = 2
    end
    object DBMemoDescripcion: TDBRichEdit
      Left = 88
      Top = 124
      Width = 261
      Height = 48
      DataField = 'descripcion'
      DataSource = dsDatos
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      PlainText = True
      TabOrder = 3
    end
    object DBMemoComentarios: TDBRichEdit
      Left = 88
      Top = 178
      Width = 261
      Height = 56
      DataField = 'comentarios'
      DataSource = dsDatos
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      PlainText = True
      TabOrder = 4
    end
  end
end
