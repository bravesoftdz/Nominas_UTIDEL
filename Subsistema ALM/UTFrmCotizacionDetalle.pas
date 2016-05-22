unit UTFrmCotizacionDetalle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTFrmDetalleDocs, StdCtrls, Mask, DBCtrls, DB, DBClient,
  NxCollection, Buttons, NxScrollControl, NxCustomGridControl, NxCustomGrid,
  NxDBGrid, ExtCtrls, JvExMask, JvToolEdit, JvMaskEdit, JvCheckedMaskEdit,
  JvDatePickerEdit, JvDBDatePickerEdit, NxDBColumns, NxColumns, JvMemoryDataset,
  ClientModuleUnit1,JvExStdCtrls, JvCombobox, JvDBCombobox, JvGroupBox,
  UTFrmPartidaDoc, AdvShapeButton,  JvExControls, JvLabel, AdvTabSet,
  AdvOfficeTabSet, AdvOfficeTabSetStylers, AdvCombo, AdvSmoothTabPager,
  JvComponentBase, JvEnterTab, alm_genericclasses;

type
  TInteger = class
    entero: integer;
  end;

type
  TFrmCotizacionDetalle = class(TFrmDetalleDocs)
    NxDBNumberColumn1: TNxDBNumberColumn;
    NxDBTextColumn1: TNxDBTextColumn;
    memComentarios: TDBMemo;
    NxDBDateColumn1: TNxDBDateColumn;
    JvMaskEdit1: TJvMaskEdit;
    edtSerie: TEdit;
    JvLabel1: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    AdvOfficeTabSetOfficeStyler1: TAdvOfficeTabSetOfficeStyler;
    tab1: TAdvSmoothTabPager;
    AdvSmoothTabPager11: TAdvSmoothTabPage;
    AdvSmoothTabPager12: TAdvSmoothTabPage;
    cmbFirmante1: TAdvComboBox;
    cmbFirmante2: TAdvComboBox;
    cmbFirmante3: TAdvComboBox;
    cmbFirmante4: TAdvComboBox;
    cmbFirmante5: TAdvComboBox;
    cmbFirmante6: TAdvComboBox;
    cmbFirmante7: TAdvComboBox;
    cmbFirmante8: TAdvComboBox;
    cmbFirmante9: TAdvComboBox;
    cmbFirmante10: TAdvComboBox;
    edtReferencia: TDBEdit;
    JvDBDatePickerEdit1: TJvDBDatePickerEdit;
    JvLabel2: TJvLabel;
    lblLugar: TJvLabel;
    lblProveedor: TJvLabel;
    procedure Inicializar; override;
    procedure FormShow(Sender: TObject);
    procedure btnLugarClick(Sender: TObject);
    procedure edtConsecutivoExit(Sender: TObject);
    procedure BtnRecClick(Sender: TObject);
  private
    { Private declarations }
    ListaFirmas: array[0..9] of TAdvComboBox;
    FirmantesDoc: TListaFirmantes;
    procedure CargarFirmantes;
  protected
    procedure HacerComponentesEditables; override;
    function createPopUpPartida: TFrmPartidaDoc; override;
    procedure CargarCampos; override;
  public
    { Public declarations }
  end;

var
  FrmCotizacionDetalle: TFrmCotizacionDetalle;

implementation

uses
  UInteliDialog,Unit2, UTFrmCotizacionPartida,xDatabase,
  UTfrmCiudad, strutils;

{$R *.dfm}

procedure TFrmCotizacionDetalle.HacerComponentesEditables;
begin
  // no hacer nada
end;
procedure TFrmCotizacionDetalle.BtnRecClick(Sender: TObject);
var
  iConsecutivo: Integer;
  strConsecutivo: String;
  dia,mes,anio: word;
  formatoSerie: String;
  Firmante: TFirmante;
  i: Integer;
  ListIndex: Integer;
begin
  // Si es una inserci�n, ajustar todo para que se calculen los campos serie y consecutivo
  // de manera correcta por el trigger
  //DecodeDate(dtpFecha.Date,anio,mes,dia);
  //if dsDatos.DataSet.State = dsInsert then
  //begin
  //  formatoSerie := AnsiReplaceStr(CadenaDoc,'{a�o}',inttostr(anio));
  //  formatoSerie := AnsiReplaceStr(FormatoSerie,'{consecutivo}','{consecutivo:' + inttostr(DigitosDoc) + '}');
  //  dsDatos.DataSet.FieldByName('consecutivo').AsInteger := iConsecutivo;
  //  dsDatos.DataSet.FieldByName('serie').AsString := formatoSerie;
  //end;
  dsDatos.DataSet.FieldByName('periodo').AsInteger := anio;

  // Crear las cadenas para guardar los datos de los firmantes
  FirmantesDoc.Clear;
  Firmante := TFirmante.Create;
  for i := low(ListaFirmas) to high(ListaFirmas) do
    if ListaFirmas[i].Visible then
    begin
      ListIndex := ListaFirmas[i].ItemIndex;
      Firmante.Id := TLista(ListaFirmas[i].Items.Objects[ListIndex]).Valor['idfirmante'];
      Firmante.Titulo := '-';
      Firmante.Nombre := TLista(ListaFirmas[i].Items.Objects[ListIndex]).Valor['nombre'] + ' ' +
                         TLista(ListaFirmas[i].Items.Objects[ListIndex]).Valor['apellidos'];
      Firmante.Puesto := TLista(ListaFirmas[i].Items.Objects[ListIndex]).Valor['titulocargo'];
      Firmante.Departamento := TLista(ListaFirmas[i].Items.Objects[ListIndex]).Valor['titulodepartamento'];
      FirmantesDoc.Add(Firmante);
    end;
  dsDatos.DataSet.FieldByName('FirmaId').AsString := FirmantesDoc.ListaId;
  dsDatos.DataSet.FieldByName('FirmaTitulo').AsString := FirmantesDoc.ListaTitulo;
  dsDatos.DataSet.FieldByName('FirmaNombre').AsString := FirmantesDoc.ListaNombre;
  dsDatos.DataSet.FieldByName('FirmaPuesto').AsString := FirmantesDoc.ListaPuesto;
  dsDatos.DataSet.FieldByName('FirmaDepto').AsString := FirmantesDoc.ListaDepartamento;

  inherited;
end;

procedure TFrmCotizacionDetalle.CargarCampos;
var
  cdCiudad,
  cdProveedor: TClientDataSet;
  ProviderName: String;
  idCiudad,
  idProveedor: integer;
begin
  inherited;

  // Cargar la descripci�n del campo idlugar
  idCiudad := dsDatos.DataSet.FieldByName('idCiudad').AsInteger;
  idProveedor := dsDatos.DataSet.FieldByName('idProveedor').AsInteger;
  cdCiudad := TClientDataSet.Create(nil);
  cdProveedor := TClientDataSet.Create(nil);
  CrearConjunto(cdCiudad, 'nuc_Ciudad', ProviderName, ccCatalog);
  CargarDatosFiltrados(cdCiudad, 'idCiudad', [idCiudad]);
  CrearConjunto(cdProveedor, 'alm_Proveedor', ProviderName, ccSelect);
  CargarDatosFiltrados(cdProveedor, 'idProveedor', [idProveedor]);
  cdCiudad.Open;
  cdProveedor.Open;
  // Si el registro regresa solo un registro, entonces poner los datos correspondientes
  if cdCiudad.RecordCount = 1 then
  begin
    lblLugar.Caption := cdCiudad.FieldByName('codigoCiudad').AsString + ' - ' +
                        cdCiudad.FieldByName('tituloCiudad').AsString
  end
  else
    lblLugar.Caption := '';

  if cdProveedor.RecordCount = 1 then
  begin
    lblProveedor.Caption := cdProveedor.FieldByName('codigoProveedor').AsString + ' - ' +
                        cdProveedor.FieldByName('razonsocial').AsString
  end
  else
    lblLugar.Caption := '';

  cdCiudad.Close;
  EliminarConjunto(ProviderName);
  cdCiudad.Free;

  // Si es una inserci�n, poner algunos campos con valores por default
  if dsDatos.DataSet.State = dsInsert then
  begin
//    dsDatos.DataSet.FieldByName('fecha').AsDateTime := now;
//    dsDatos.DataSet.FieldByName('fecharequerida').AsDateTime := now;
//    dsDatos.DataSet.FieldByName('idUsuario').AsInteger := ClientModule1.cdUsuario.FieldByName('idusuario').AsInteger;
//    dsDatos.DataSet.FieldByName('estado').AsString := 'pendiente';
//    dsDatos.DataSet.FieldByName('serie').AsString := CadenaDoc;
//    dsDatos.DataSet.FieldByName('consecutivo').AsInteger := 0;
//    edtSerie.Text := AnsiReplaceStr(CadenaDoc,'{a�o}','0000');
//    edtSerie.Text := AnsiReplaceStr(edtSerie.Text,'{consecutivo}',DupeString('0',DigitosDoc));
//    dsDatos.DataSet.FieldByName('idorganizacion').AsInteger := clientmodule1.cdAcceso.FieldByName('idorganizacion').AsInteger;
  end
  else
  begin
    edtSerie.Text := dsDatos.DataSet.FieldByName('serie').AsString;
    Panel4.Enabled := False;
    //edtReferencia.SetFocus;
  end;

end;


procedure TFrmCotizacionDetalle.btnLugarClick(Sender: TObject);
var
  Ciudad: TLista;
  frmCiudad: TFrmCiudad;
begin
  inherited;
  frmCiudad := TFrmCiudad.Create(nil);
  Ciudad := frmCiudad.SeleccionarItem;
  if assigned(Ciudad) then
  begin
    dsDatos.DataSet.FieldByName('idCiudad').AsInteger := Ciudad.Valor['idCiudad'];
    //edtTituloLugar.Text := Ciudad.Valor['tituloCiudad'];
    memComentarios.SetFocus;
  end;
  frmCiudad.Free;
  Ciudad.Free;
end;

function TFrmCotizacionDetalle.createPopUpPartida: TFrmPartidaDoc;
Var
  temp: TFrmCotizacionPartida;
begin
  temp := TFrmCotizacionPartida.Create(nil);
  //temp.fechaRequeridaDefault := dtpFechaReq.Date;
  result := temp;
end;


procedure TFrmCotizacionDetalle.edtConsecutivoExit(Sender: TObject);
Var
  Num: integer;
begin

end;

procedure TFrmCotizacionDetalle.FormShow(Sender: TObject);
Var
  idfirmante: TInteger;
begin
  tab1.ActivePageIndex := 0;
  CargarFirmantes;
  inherited;
  edtReferencia.SetFocus;
end;

procedure TFrmCotizacionDetalle.Inicializar;
begin
  keyDetailField := 'idcotizaciondetalle';
  keyParentField := 'idcotizacion';
  entityDetailName := 'alm_cotizaciondetalle';
  codeDetailField := '';
end;

procedure TFrmCotizacionDetalle.CargarFirmantes;
var
  cdConfFirmantes,
  cdFirmantes: TClientDataSet;
  dpConfFirmantes,
  dpFirmantes: string;
  regFirmante: TLista;
  ItemSeleccionado: Integer;
  Hoy,FechaIni,FechaFin: TDate;
  i1,i2: integer;
  //Firmante: TFirmante;
begin
  // Llenar manualmente el arreglo para que posteriormente sea m�s sencillo el
  // manejo de los combos
  ListaFirmas[0] := cmbFirmante1;
  ListaFirmas[1] := cmbFirmante2;
  ListaFirmas[2] := cmbFirmante3;
  ListaFirmas[3] := cmbFirmante4;
  ListaFirmas[4] := cmbFirmante5;
  ListaFirmas[5] := cmbFirmante6;
  ListaFirmas[6] := cmbFirmante7;
  ListaFirmas[7] := cmbFirmante8;
  ListaFirmas[8] := cmbFirmante9;
  ListaFirmas[9] := cmbFirmante10;

  FirmantesDoc := TListaFirmantes.Create;
  with dsDatos.DataSet do
  begin
    FirmantesDoc.LoadData(FieldByName('firmaid').AsString,
                          FieldByName('firmatitulo').AsString,
                          FieldByName('firmanombre').AsString,
                          FieldByName('firmapuesto').AsString,
                          FieldByName('firmadepto').AsString);
  end;

  cdConfFirmantes := TClientDataSet.Create(nil);
  CrearConjunto(cdConfFirmantes, 'nuc_configuracionfirmante', dpConfFirmantes, ccCatalog);
  CargarDatosFiltrados(cdConfFirmantes, 'nombredocumento', ['COTIZACION']);
  cdConfFirmantes.Open;

  // Checar cuantos firmantes tiene el documento y hacer el llenado de los combos
  // correspondinetes
  cdConfFirmantes.First;
  while not cdConfFirmantes.eof do
  begin
    i1 := cdConfFirmantes.RecNo - 1;
    cdFirmantes := TClientDataSet.Create(nil);
    CrearConjunto(cdFirmantes, 'nuc_firmante', dpFirmantes, ccSelect);
    CargarDatosFiltrados(cdFirmantes, 'idcargo', [cdConfFirmantes.FieldByName('idcargo').AsInteger]);
    cdFirmantes.Open;
    with ListaFirmas[i1] do
    begin
      Visible := true;
      LabelCaption := cdConfFirmantes.FieldByName('titulocargo').AsString;
      // Llenar el combo con los firmantes para ese cargo
      cdFirmantes.First;
      while not cdFirmantes.eof do
      begin
        i2 := cdFirmantes.RecNo - 1;
        regFirmante := GetCurrentRecord(cdFirmantes);
        AddItem(regFirmante.Valor['nombre'] + ' ' + regFirmante.Valor['apellidos'],regFirmante);
        Hoy := Now;
        FechaIni := NVL(regFirmante.Valor['FechaInicio'],StrToDate('01/01/1900'));
        FechaFin := NVL(regFirmante.Valor['FechaFin'],StrToDate('01/01/1900'));
        // Checar cual es el indice del firmante que deber� aparecer como seleccionado
        // Si es una insercion, seleccionar el que est� vigente
        if (dsDatos.DataSet.State = dsInsert)
            or ((dsDatos.DataSet.State = dsEdit) and (i1 > FirmantesDoc.Count )) then
        begin
          if (Hoy >= FechaIni) and (Hoy <= FechaFin) then
            ItemSeleccionado := i2;
        end
        else  // Si es edici�n, seleccionar el que indica el registro
        begin
          if FirmantesDoc.Item[i1].Id = regFirmante.Valor['idfirmante'] then
            ItemSeleccionado := i2;
        end;
        cdFirmantes.Next;
      end;
      ItemIndex := ItemSeleccionado;
    end;

    EliminarConjunto(dpFirmantes);
    cdFirmantes.Free;
    cdConfFirmantes.Next;
  end;


end;

end.
