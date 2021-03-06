unit UTFrmSubsidioTablaISPT_Anual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UInteliDialog, ClientModuleUnit1, JvCombobox, JvExControls, JvLabel,
  StdCtrls, JvExStdCtrls, JvDBCombobox, ExtCtrls, Grids, DBGrids, DB, AdvTabSet,
  DBClient, StrUtils, DBCtrls, JvDBLookup, NxColumns, NxDBColumns,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxDBGrid, AdvGlowButton,
  ComCtrls, ToolWin, Spin, NxEdit, Mask, JvExMask, JvToolEdit, JvMaskEdit,
  JvCheckedMaskEdit, JvDatePickerEdit, MoneyEdit;

type
  TFrmSubsidioTablaISPT_Anual = class(TForm)
    Panel1: TPanel;
    tsPeriodos: TAdvTabSet;
    dsTablaISR: TDataSource;
    NextDBGrid1: TNextDBGrid;
    LimiteInferior: TNxDBNumberColumn;
    NxDBNumberColumn1: TNxDBNumberColumn;
    NxDBNumberColumn2: TNxDBNumberColumn;
    Memo1: TMemo;
    ToolBar1: TToolBar;
    Btn_Agregar: TToolButton;
    Btn_Editar: TToolButton;
    Btn_Quitar: TToolButton;
    Btn_Refresh: TToolButton;
    ToolButton6: TToolButton;
    Panel_BotonesLinea: TPanel;
    Btn_AgregarLinea: TAdvGlowButton;
    Btn_AceptarLinea: TAdvGlowButton;
    Btn_CerrarLinea: TAdvGlowButton;
    Panel_DatosLinea: TPanel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    ToolButton1: TToolButton;
    Btn_NuevaTabla: TToolButton;
    ToolButton5: TToolButton;
    eFechaAplicacion: TJvDatePickerEdit;
    JvLabel5: TJvLabel;
    eLimiteInferior: TMoneyEdit;
    eSubsidio: TMoneyEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure tsPeriodosChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure cbTipoTablaClick(Sender: TObject);
    procedure Btn_RefreshClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_AgregarClick(Sender: TObject);
    procedure Btn_AgregarLineaClick(Sender: TObject);
    procedure Btn_CerrarLineaClick(Sender: TObject);
    procedure Btn_QuitarClick(Sender: TObject);
    procedure Btn_EditarClick(Sender: TObject);
  private
    cdTablaISR,
    cdHistorial: TClientDataSet;
    Llenando: Boolean;
    OrigCaption: String;
    FrmCaptura: TForm;
    Buscar: TClientDataSet;
    Actualizar: Boolean;
    procedure LeerDatos;
    procedure ValidaCaptura;
    procedure CrearVentana;
  public
    { Public declarations }
  end;

var
  FrmSubsidioTablaISPT_Anual: TFrmSubsidioTablaISPT_Anual;

implementation

{$R *.dfm}

procedure TFrmSubsidioTablaISPT_Anual.cbTipoTablaClick(Sender: TObject);
var
  sFecha: String;
  Anio, Mes, Dia: Word;
  Cursor: TCursor;
begin
  if Not Llenando then
  begin
    Cursor := Screen.Cursor;
    Try
      Screen.Cursor := crAppStart;

      DecodeDate(cdHistorial.FieldByName('FechaAplicacion').AsDateTime, Anio, Mes, Dia);
      sFecha := IntToStr(Anio) + '-' + RightStr('0' + IntToStr(Mes), 2) + '-' + RightStr('0' + IntToStr(Dia), 2);

      cdTablaISR.Close;

      if Not CargarDatosFiltrados(cdTablaISR, 'FechaAplicacion', [sFecha]) then
        raise InteligentException.CreateByCode(6, ['Tipo de Tabla de ISPT/Fecha de Aplicaci�n', cdTablaISR.FieldByName('IdTipoTabla').AsString + '/' + sFecha]);
      cdTablaISR.Open;
    Finally
      Screen.Cursor := Cursor;
    End;
  end;
end;

procedure TFrmSubsidioTablaISPT_Anual.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    EliminarConjunto([cdTablaISR, cdHistorial]);

    if Assigned(Buscar) then
      EliminarConjunto(Buscar);
  finally
    LiberarVentana(Self, Action);
  end;
  {
  cdTablaISR.Free;
  cdHistorial.Free;
  FrmSubsidioTablaISPT_Anual.Free;  }

end;

procedure TFrmSubsidioTablaISPT_Anual.FormCreate(Sender: TObject);
var
  Cursor: TCursor;
begin
  Actualizar := False;

  Try
    Cursor := Screen.Cursor;
    Try
      Screen.Cursor := crAppStart;

      cdTablaISR := TClientDataSet.Create(Self);
      cdHistorial := TClientDataSet.Create(Self);

      dsTablaISR.DataSet := cdTablaISR;

      if Not CrearConjunto(cdHistorial, 'nom_subsidioispt_historialanual', ccSelect) then
        raise InteligentException.CreateByCode(5, ['Historial de la Tabla del Subsidio de Impuesto Sobre el Producto del Trabajo (ISPT)']);
      cdHistorial.Open;

      if Not CrearConjunto(cdTablaISR, 'nom_subsidioisptanual', ccCatalog) then
        raise InteligentException.CreateByCode(5, ['Tabla del Subsidio de Impuesto Sobre el Producto del Trabajo (ISPT)']);
        cdTablaISR.Open;
    Finally
      Screen.Cursor := Cursor;
    End;
  Except
    on e:InteligentException do
    begin
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOk], 0);
      PostMessage(Self.Handle, WM_CLOSE, 0, 0);
    end;

    on e:Exception do
    begin
      InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + #10 + #10 + e.Message, mtError, [mbOk], 0);
      PostMessage(Self.Handle, WM_CLOSE, 0, 0);
    end;
  End;
end;

procedure TFrmSubsidioTablaISPT_Anual.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
     27: Close;
     46: Btn_Quitar.Click;
    116: Btn_Refresh.Click;
  end;
end;

procedure TFrmSubsidioTablaISPT_Anual.FormShow(Sender: TObject);
begin
  OrigCaption := Self.Caption;

  LeerDatos;
end;

procedure TFrmSubsidioTablaISPT_Anual.tsPeriodosChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
  var  sFecha: String;
       Anio, Mes, Dia: Word;
       Cursor: TCursor;
begin
  if (Not Llenando) and (tsPeriodos.AdvTabs.Count > 0) then
  begin
    cdHistorial.RecNo := NewTab +1;
    //cbTipoTabla.OnClick(Sender); El codigo que sigue es el equivalente____V
    Cursor := Screen.Cursor;
    Try
      Screen.Cursor := crAppStart;

      DecodeDate(cdHistorial.FieldByName('FechaAplicacion').AsDateTime, Anio, Mes, Dia);
      sFecha := IntToStr(Anio) + '-' + RightStr('0' + IntToStr(Mes), 2) + '-' + RightStr('0' + IntToStr(Dia), 2);

      cdTablaISR.Close;

      if Not CargarDatosFiltrados(cdTablaISR, 'FechaAplicacion', [-1]) then
        raise InteligentException.CreateByCode(6, ['Tabla Anual de ISPT/Fecha de Aplicaci�n', cdTablaISR.FieldByName('FechaAplicacion').AsString + '/' + sFecha]);
      cdTablaISR.Open;
    Finally
      Screen.Cursor := Cursor;
    End;

    if NewTab = 0 then
      Caption := OrigCaption
    else
      Caption := OrigCaption + ' (SOLO LECTURA)';
  end;
end;

procedure TFrmSubsidioTablaISPT_Anual.LeerDatos;
Const
  NomMes: Array[1..12] of String = ('ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC');
var
  Resultado: Boolean;
  sFecha: String;
begin
  tsPeriodos.AdvTabs.Clear;
  // Llenar las cejas inferiores
  Try
    Llenando := True;

    while not cdHistorial.Eof do
    begin
      sFecha := cdHistorial.FieldByName('FechaAplicacion').AsString;
      sFecha := Copy(sFecha,1,2) + '-' + NomMes[StrToInt(Copy(sFecha,4,2))] + '-' + Copy(sFecha,7,4);
      With tsPeriodos.AdvTabs.Add do
        if tsPeriodos.AdvTabs.Count = 1 then
          Caption := '* Actual (' + sFecha + ')'
        else
          Caption := sFecha;

      cdHistorial.Next;
    end;
  Finally
    Llenando := False;
  End;

  tsPeriodos.OnChange(Nil, 0, Resultado);
end;

procedure TFrmSubsidioTablaISPT_Anual.Btn_AgregarClick(Sender: TObject);
var
  Resultado: Integer;
begin
  Try
    // Crear la ventana de captura de nuevos renglones en caso de ser necesario
    if Not Assigned(FrmCaptura) then
    begin
      if Not Assigned(Buscar) then
      begin
        Buscar := TClientDataSet.Create(Self);
        if Not CrearConjunto(Buscar, 'nom_subsidioisptanual', ccUpdate) then
          raise InteligentException.CreateByCode(5, ['Tabla Anual del Subsidio del I.S.P.T.']);
      end;

      CrearVentana;
      FrmCaptura.Height := 176;

      Panel_DatosLinea.Parent := FrmCaptura;
      Panel_BotonesLinea.Parent := FrmCaptura;

      Panel_DatosLinea.Visible := True;
      Panel_DatosLinea.Align := alClient;

      Panel_BotonesLinea.Visible := True;
      Panel_BotonesLinea.Align := alBottom;
    end;

    // Verificar si se debe editar la fecha de aplicaci�n
    if CompareText(TWinControl(Sender).Name, 'Btn_NuevaTabla') = 0 then
    begin
      eFechaAplicacion.Date := Now;
      eFechaAplicacion.Enabled := True;
    end
    else
    begin
      eFechaAplicacion.Date := cdHistorial.FieldByName('FechaAplicacion').AsDateTime;
      eFechaAplicacion.Enabled := False;
    end;

    FrmCaptura.Caption := 'Captura datos de nuevo rengl�n de tabla de I.S.P.T.';
    Try
      Resultado := FrmCaptura.ShowModal;
      //if Resultado <> mrAbort then
      begin
        // Verificar si se requiere actualizar el Historial de la tabla
        if CompareText(TWinControl(Sender).Name, 'Btn_NuevaTabla') = 0 then
        begin
          cdHistorial.Refresh;
          LeerDatos;
        end;

        if Actualizar then
          Btn_Refresh.Click;
      end;
    Finally
      ;
    End;
  Except
    on e:InteligentException do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOk], 0);

    on e:Exception do
      InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + #10 + #10 + e.Message, mtError, [mbOk], 0);
  End;
end;

procedure TFrmSubsidioTablaISPT_Anual.Btn_AgregarLineaClick(Sender: TObject);
begin
  Try
    ModalResult := mrAbort;
    Cursor := Screen.Cursor;

    Try
      Screen.Cursor := crAppStart;

      ValidaCaptura;

      // Si todo est� bien, proceder a grabar los datos
      If Not CargarDatosFiltrados(Buscar, 'IdSubsidioISPT', [-9]) then
        raise Exception.Create('No se ha podido acceder a la tabla del Subsidio de I.S.P.T.');
      Buscar.Open;

      Buscar.Append;
      Buscar.FieldByName('IdSubsidioISPT').AsInteger := 0;
      Buscar.FieldByName('LimiteInferior').AsString := FloatToStr(eLimiteInferior.Value);
      Buscar.FieldByName('Subsidio').AsString := FloatToStr(eSubsidio.Value);
      Buscar.FieldByName('IdUsuario').AsInteger := 0;
      Buscar.FieldByName('sIdUsuario').AsString := '';
      Buscar.FieldByName('FechaAplicacion').AsDateTime := eFechaAplicacion.Date;
      Buscar.Post;
      Buscar.ApplyUpdates(-1);

      if CompareText(TWinControl(Sender).Name, 'Btn_AgregarLinea') = 0 then
      begin
        eLimiteInferior.Value := 0.01;
        eSubsidio.Value := 0;
        eLimiteInferior.SetFocus;
      end;
    Finally
      Screen.Cursor := Cursor;
    End;

    Actualizar := True;
    ModalResult := mrOk;
  Except
    on e:InteligentException do
      InteliDialog.ShowModal('Error de captura', e.message, mtInformation, [mbOk], 0);

    on e:Exception do
      InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + #10 + #10 + e.Message, mtError, [mbOk], 0);
  End;
    cdTablaISR.Refresh;
end;

procedure TFrmSubsidioTablaISPT_Anual.Btn_CerrarLineaClick(Sender: TObject);
begin
  if Assigned(FrmCaptura) then
    FrmCaptura.Close;
    cdTablaISR.Open;
    cdTablaISR.Refresh;
end;

procedure TFrmSubsidioTablaISPT_Anual.Btn_EditarClick(Sender: TObject);
begin
  // Editar el registro
  Try
    if cdTablaISR.RecordCount = 0 then
      raise Exception.Create('No existen datos que editar');

    CrearVentana;
    eFechaAplicacion.Enabled := False;
    eFechaAplicacion.Date := cdTablaISR.FieldByName('FechaAplicacion').AsDateTime;
    eLimiteInferior.Value := cdTablaISR.FieldByName('LimiteInferior').AsFloat;
    eSubsidio.Value := cdTablaISR.FieldByName('Subsidio').AsFloat;

    // Localizar el registro a editar
    if Not Assigned(Buscar) then
    begin
      Buscar := TClientDataSet.Create(Self);
      if Not CrearConjunto(Buscar, 'nom_subsidioisptanual', ccUpdate) then
        raise InteligentException.CreateByCode(5, ['Tabla de Subsidio del I.S.P.T.']);
    end;

    Buscar.Close;
    if Not CargarDatosFiltrados(Buscar, 'IdSubsidioISPT', [cdTablaISR.FieldByName('IdSubsidioISPT').AsInteger]) then
      raise InteligentException.CreateByCode(6, ['Tabla de Subsidio del I.S.P.T.', 'IdSubsidioISPT', cdTablaISR.FieldByName('IdSubsidioISPT').AsInteger]);
    Buscar.Open;

    Buscar.Edit;
    FrmCaptura.ShowModal;
  Except
    on e:Exception do
      InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + #10 + #10 + e.Message, mtError, [mbOk], 0);
  End;
end;

procedure TFrmSubsidioTablaISPT_Anual.Btn_QuitarClick(Sender: TObject);
var
  Anio, Mes, Dia: Word;
  sFecha: String;
  Cursor: TCursor;
begin
  // Eliminar el registro solicitado
  Try
    if cdTablaISR.RecordCount <= 0 then
      raise Exception.Create('No existen registros que eliminar');

    DecodeDate(cdTablaISR.FieldByName('FechaAplicacion').AsDateTime, Anio, Mes, Dia);
    sFecha := IntToStr(Anio) + '-' + RightStr('0' + IntToStr(Mes), 2) + '-' + RightStr('0' + IntToStr(Dia), 2);

    Cursor := Screen.Cursor;
    Try
      Screen.Cursor := crAppStart;

      if Not Assigned(Buscar) then
      begin
        Buscar := TClientDataSet.Create(Self);
        if Not CrearConjunto(Buscar, 'nom_subsidioisptanual', ccUpdate) then
          raise InteligentException.CreateByCode(5, ['Tabla del Subsidio del I.S.P.T.']);
      end;

      Buscar.Close;
      If Not CargarDatosFiltrados(Buscar, 'FechaAplicacion, IdSubsidioISPT', [sFecha, cdTablaISR.FieldByName('IdSubsidioISPT').AsInteger]) then
        raise InteligentException.CreateByCode(6, ['Tabla Anual del Subsidio de I.S.P.T.', 'FechaAplicacion,IdSubsidioISPT', sFecha + '/' + cdTablaISR.FieldByName('IdSubsidioISPT').AsString]);
      Buscar.Open;
    Finally
      Screen.Cursor := Cursor;
    End;

    if (Buscar.RecordCount > 0) and (InteliDialog.ShowModal('Eliminar L�nea de Tabla de I.S.P.T.', '�Est� seguro que desea eliminar est� l�nea de la tabla del Impuesto Sobre el Producto del Trabajo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      Buscar.Delete;
      Buscar.ApplyUpdates(-1);

      cdHistorial.Refresh;
      LeerDatos;
    end;
  Except
    on e:Exception do
      InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + #10 + #10 + e.Message, mtError, [mbOk], 0);
  End;
end;

procedure TFrmSubsidioTablaISPT_Anual.Btn_RefreshClick(Sender: TObject);
begin
  LeerDatos;
  FormCreate(Sender);
end;

procedure TFrmSubsidioTablaISPT_Anual.ValidaCaptura;
var
  sFecha: String;
  Anio, Mes, Dia: Word;
begin
  Try
    // Primero verificar que el l�mite inferior no sea menor o igual a cero
    if eLimiteInferior.Value <= 0 then
    begin
      eLimiteInferior.SetFocus;
      raise Exception.Create('El valor para el L�mite Inferior no puede ser menor a 0.01');
    end;

    // Verificar que el Limite Inferior no exista ya en la base de datos
    DecodeDate(cdHistorial.FieldByName('FechaAplicacion').AsDateTime, Anio, Mes, Dia);
    sFecha := IntToStr(Anio) + '-' + RightStr('0' + IntToStr(Mes), 2) + '-' + RightStr('0' + IntToStr(Dia), 2);

    if Not CargarDatosFiltrados(Buscar, 'FechaAplicacion, LimiteInferior', [sFecha, eLimiteInferior.Value]) then
    begin
      eLimiteInferior.SetFocus;
      raise InteligentException.CreateByCode(5, ['Tabla del Subsidio de I.S.P.T.']);
    end;

    if CuantosRegistros(Buscar) > 0 then
    begin
      eLimiteInferior.SetFocus;
      raise InteligentException.CreateByCode(8, ['El valor para el L�mite Inferior: ' + eLimiteInferior.Text + ' ya existe en la tabla.']);
    end;

  Except
    Raise;
  End;
end;

procedure TFrmSubsidioTablaISPT_Anual.CrearVentana;
begin
  FrmCaptura := TForm.Create(Self);
  FrmCaptura.Width := Panel_DatosLinea.Width + 6;
end;

end.
