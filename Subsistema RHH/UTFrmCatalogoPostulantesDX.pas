unit UTFrmCatalogoPostulantesDX;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinsdxBarPainter, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinscxPCPainter,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, DB,
  cxDBData, dxSkinsdxStatusBarPainter, dxRibbonSkins, dxSkinsdxRibbonPainter,
  dxRibbonCustomizationForm, cxClasses, dxRibbon, dxStatusBar, dxBar,
  dxRibbonMiniToolbar, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, DBClient, dxSkinsForm,
  cxRadioGroup, cxBarEditItem, ClientModuleUnit1, UInteliDialog,
  cxFontNameComboBox, cxImage, cxLabel, cxCurrencyEdit, Menus, cxContainer,
  JvExControls, JvLabel, cxTextEdit, StdCtrls, cxButtons, ExtCtrls,
  cxEditRepositoryItems, dxBarBuiltInMenu, cxPC, frxClass, frxPreview, ComCtrls,
  dxCore, cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar, cxGroupBox,
  dxGDIPlusClasses, Mask, RxToolEdit, frxExportPDF, ShellAPI, frxDBSet,
  cxGridChartView, cxGridDBChartView, cxGridCustomPopupMenu, cxGridPopupMenu,
  frxDesgn, frxDCtrl, DateUtils;

type
  TFrmCatalogoPersonalDEX = class(TForm)
    DxBManagerMain: TdxBarManager;
    CdPersonal: TClientDataSet;
    dsPersonal: TDataSource;
    DxMiniToolPersonal: TdxRibbonMiniToolbar;
    dxTabPersonal: TdxRibbonTab;
    DxRibbonPersonal: TdxRibbon;
    DxSkinCtrlMain: TdxSkinController;
    DxBarPersional: TdxBar;
    DxBarBtnNUevo: TdxBarLargeButton;
    DxBarBtnEditar: TdxBarLargeButton;
    DxBarBtnInasistencia: TdxBarButton;
    DxBarBtnEliminarRegistro: TdxBarButton;
    DxBarBtnModificarFechaBaja: TdxBarLargeButton;
    DxBarFiniquito: TdxBar;
    DxBarBtnModificarContratacion: TdxBarButton;
    DxBarBtnGenerarBaja: TdxBarLargeButton;
    DxBarBtnHistorialContratos: TdxBarLargeButton;
    DxBarBusquedas: TdxBar;
    DxBarBtnBuscar: TdxBarLargeButton;
    cxRadioFiltroPersonal: TcxBarEditItem;
    DxBarExtras: TdxBar;
    DxBarBtnTodoPersonal: TdxBarLargeButton;
    DxBarBtnListaInfonavit: TdxBarLargeButton;
    cxStyleReposEstilosGrid: TcxStyleRepository;
    cxstyl1: TcxStyle;
    cxstylFont: TcxStyle;
    cxstylFontContent: TcxStyle;
    cxstylSexo: TcxStyle;
    pnlBuscar: TPanel;
    CxBtnBuscar: TcxButton;
    CxBtnCancelarBuscar: TcxButton;
    Buscar_Nombre: TcxTextEdit;
    JvLabel6: TJvLabel;
    CxItemReposBarraMenu: TcxEditRepository;
    CxRadioGroupFiltro: TcxEditRepositoryRadioGroupItem;
    CdFechaBaja: TClientDataSet;
    cxPageContenedor: TcxPageControl;
    cxTabPersonal: TcxTabSheet;
    CxGridMain: TcxGrid;
    CxGridPersonal: TcxGridDBTableView;
    CxColumnCodigoEmpleado: TcxGridDBColumn;
    grdColumDbGridGrid1DBTableView1Column12: TcxGridDBColumn;
    CxColumnEmpleado: TcxGridDBColumn;
    grdColumDbGridGrid1DBTableView1Column3: TcxGridDBColumn;
    grdColumDbGridGrid1DBTableView1Column4: TcxGridDBColumn;
    grdColumDbGridGrid1DBTableView1Column5: TcxGridDBColumn;
    grdColumDbGridGrid1DBTableView1Column6: TcxGridDBColumn;
    grdColumDbGridGrid1DBTableView1Column7: TcxGridDBColumn;
    grdColumDbGridGrid1DBTableView1Column8: TcxGridDBColumn;
    grdColumDbGridGrid1DBTableView1Column9: TcxGridDBColumn;
    grdColumDbGridGrid1DBTableView1Column10: TcxGridDBColumn;
    grdColumDbGridGrid1DBTableView1Column11: TcxGridDBColumn;
    CxColumnInfonavit: TcxGridDBColumn;
    CxColumnAplicacion: TcxGridDBColumn;
    CxColumnT�rmino: TcxGridDBColumn;
    cxColumnatAplicacionInfonavit: TcxGridDBColumn;
    CxColumnTermino: TcxGridDBColumn;
    CxLevelPersonal: TcxGridLevel;
    cxTabInfonavit: TcxTabSheet;
    FrxPreviewInfonavit: TfrxPreview;
    cxGBOnfonavit: TcxGroupBox;
    imgLogo2: TcxImage;
    pnlBtn: TPanel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    CxLbl3: TcxLabel;
    CxRGroupInfonavit: TcxRadioGroup;
    cxGBFiltroinfo: TcxGroupBox;
    cxDateEditTermino: TcxDateEdit;
    CxLbl1: TcxLabel;
    CxLbl2: TcxLabel;
    CdDatosEmpresa: TClientDataSet;
    FrxReportGeneral: TfrxReport;
    cxGBBajaPersonal: TcxGroupBox;
    lblNombreEmpleadoBaja: TLabel;
    Label2: TLabel;
    JvLabel1: TJvLabel;
    Edtfechab: TcxDateEdit;
    cbTipoFiniquito: TComboBox;
    btn2: TcxButton;
    btn3: TcxButton;
    CdInasistenciaUpt: TClientDataSet;
    CdTipoInasistencia: TClientDataSet;
    CdInasistencia: TClientDataSet;
    DxBarBtnDetalladoNomina: TdxBarLargeButton;
    DxBarBtnExportarInfonavit: TdxBarLargeButton;
    DxBarBtnVerCompleto: TdxBarLargeButton;
    DxBarBtnCerrar: TdxBarLargeButton;
    FrxPDFExportInfonavit: TfrxPDFExport;
    FrxReportGeneralExterno: TfrxReport;
    dxTabInfonavit: TdxRibbonTab;
    DxBarInfonavitBar: TdxBar;
    cxTabHistorialContratos: TcxTabSheet;
    dxTabHistorialContratos: TdxRibbonTab;
    DxBarContratos: TdxBar;
    gridHistorialContrataciones: TcxGrid;
    CxGridHistorialContratos: TcxGridDBTableView;
    TipoMovimiento: TcxGridDBColumn;
    Guardia: TcxGridDBColumn;
    fechaalta: TcxGridDBColumn;
    Titulo: TcxGridDBColumn;
    TituloSalario: TcxGridDBColumn;
    FechaMovimiento: TcxGridDBColumn;
    TituloTipoNomina: TcxGridDBColumn;
    TituloGuardia: TcxGridDBColumn;
    CxLevelDatosContrato: TcxGridLevel;
    DxBarBtnReporteContratos: TdxBarLargeButton;
    DxBarBtnGrafica: TdxBarLargeButton;
    DxBarBtnCerrarContratos: TdxBarLargeButton;
    dsReporteHistorialGuardias: TfrxDBDataset;
    frxReporteHistorialGuardias: TfrxReport;
    cdHistorialContratacion: TClientDataSet;
    dsHistorialContratacion: TDataSource;
    CxLevelGraficaSalarios: TcxGridLevel;
    cxGridChartSalarios: TcxGridDBChartView;
    CxSerieSalarios: TcxGridDBChartSeries;
    CxDataGroupNombreEmpleado: TcxGridDBChartDataGroup;
    pnlEmpleado: TPanel;
    CxDataGroupFechaMvto: TcxGridDBChartDataGroup;
    frxDBDPersonal: TfrxDBDataset;
    FrxCdDatosEmpresa: TfrxDBDataset;
    FrxReportOtros: TfrxReport;
    CdBuscar: TClientDataSet;
    cxStyleReposStatusPersonal: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxstylPersonalEspecial: TcxStyle;
    cxstylPersonalBaja: TcxStyle;
    cxstylBajaEspecial: TcxStyle;
    CxColumnTipoMovimiento: TcxGridDBColumn;
    CxColumnDiasDescanso: TcxGridDBColumn;
    CxColumnEspecial: TcxGridDBColumn;
    DxPopMenuPersonal: TdxRibbonPopupMenu;
    DxBarBtnRefrescar: TdxBarLargeButton;
    frxDBOrganizacion: TfrxDBDataset;
    CdBaja: TClientDataSet;
    CdPersonalImss: TClientDataSet;
    FrxDesignerInfonavit: TfrxDesigner;
    FrxDialogCtrlsControles: TfrxDialogControls;
    DxBarBtnContratar: TdxBarLargeButton;
    cdTipoNomina: TClientDataSet;
    cdDepartamento: TClientDataSet;
    cdSalario: TClientDataSet;
    cdCargo: TClientDataSet;
    cdOrganizacion: TClientDataSet;
    cdRangoSalario: TClientDataSet;
    cdImss: TClientDataSet;
    cdGuardias: TClientDataSet;
    CxColumnRegpat: TcxGridDBColumn;
    cxTabDescuentos: TcxTabSheet;
    FrxPreviewDescuentosInf: TfrxPreview;
    FrxCdDescuentosInfonavit: TfrxDBDataset;
    DxBarBtnDescuentosInf: TdxBarLargeButton;
    CdDescuentosInfonavit: TClientDataSet;
    cxGBDescuentosInfonavit: TcxGroupBox;
    cxImage2: TcxImage;
    Panel2: TPanel;
    cxButton5: TcxButton;
    cxButton6: TcxButton;
    cxLabel4: TcxLabel;
    cxDateEditIInicioDescuento: TcxDateEdit;
    cxDateEditFinDescuento: TcxDateEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    FrxReportDescuentos: TfrxReport;
    dxTabDescuentosInf: TdxRibbonTab;
    DxBarOpcionesDescuento: TdxBar;
    CxColumnIDPersonal: TcxGridDBColumn;
    CxGridPersonalColumn1: TcxGridDBColumn;
    DxBarBtnResumenEmpleados: TdxBarLargeButton;
    FrxReportEmpleados: TfrxReport;
    btnReporteConceptosExtraEmpleados: TdxBarLargeButton;
    cxDateEditInicio: TcxDateEdit;
    DxBarBtnHistorialFiniquitos: TdxBarButton;
    dxTabFiniquitos: TdxRibbonTab;
    cxTabFiniquitos: TcxTabSheet;
    DxBarOpcionesFiniquitos: TdxBar;
    DxBarBtnExportarFiniquitos: TdxBarLargeButton;
    DxBarBtnVerCompletoFiniquitos: TdxBarLargeButton;
    DxBarBtnCerraFiniquito: TdxBarLargeButton;
    FrxPreviewFiniquitos: TfrxPreview;
    procedure FormCreate(Sender: TObject);
    procedure DxBarBtnTodoPersonalClick(Sender: TObject);
    procedure DxBarBtnNUevoClick(Sender: TObject);
    procedure cxRadioPersonalPropertiesChange(Sender: TObject);
    procedure DxBarBtnBuscarClick(Sender: TObject);
    procedure Buscar_NombreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CxBtnCancelarBuscarClick(Sender: TObject);
    procedure CxBtnBuscarClick(Sender: TObject);
    procedure DxBarBtnGenerarBajaClick(Sender: TObject);
    procedure cxRadioFiltroPersonalCurChange(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure DxBarBtnListaInfonavitClick(Sender: TObject);
    procedure FrxReportGeneralGetValue(const VarName: string;
      var Value: Variant);
    procedure DxBarBtnInasistenciaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DxBarBtnCerrarClick(Sender: TObject);
    procedure DxBarBtnVerCompletoClick(Sender: TObject);
    procedure DxBarBtnExportarInfonavitClick(Sender: TObject);
    procedure cxPageContenedorChange(Sender: TObject);
    procedure cxTabInfonavitHide(Sender: TObject);
    procedure cxTabHistorialContratosShow(Sender: TObject);
    procedure DxBarBtnReporteContratosClick(Sender: TObject);
    procedure DxBarBtnHistorialContratosClick(Sender: TObject);
    procedure DxBarBtnGraficaClick(Sender: TObject);
    procedure DxBarBtnCerrarContratosClick(Sender: TObject);
    procedure DxRibbonPersonalTabChanged(Sender: TdxCustomRibbon);
    procedure DxBarBtnDetalladoNominaClick(Sender: TObject);
    procedure DxBarBtnModificarContratacionClick(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure CxGridPersonalStylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure DxBarBtnEditarClick(Sender: TObject);
    procedure DxBarBtnEliminarRegistroClick(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure DxBarBtnRefrescarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FrxReportOtrosGetValue(const VarName: string; var Value: Variant);
    procedure FrxReportOtrosDblClickObject(Sender: TfrxView;
      Button: TMouseButton; Shift: TShiftState; var Modified: Boolean);
    procedure CxGridPersonalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DxBarBtnContratarClick(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure DxBarBtnDescuentosInfClick(Sender: TObject);
    procedure cxDateEditFinDescuentoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DxBarBtnResumenEmpleadosClick(Sender: TObject);
    procedure btnReporteConceptosExtraEmpleadosClick(Sender: TObject);
    procedure CxRGroupInfonavitPropertiesChange(Sender: TObject);
  private
    procedure CambiarEstadoBtn;
    procedure modificarFechaBaja;
    procedure CargarPersonal(IdPersonal: Integer);
    Procedure CambiarTab(Sender: TObject);
    { Private declarations }
  public
    ListaPersonal: String;
    { Public declarations }
  end;

var
  FrmCatalogoPersonalDEX: TFrmCatalogoPersonalDEX;

implementation

{$R *.dfm}

uses
  Unit2, UtFrmFichaGeneralPersonal, UTFrmExcepciones, UTFRMDatosContratacion,
  UTFrmConcentradoNomina, UtfrmModificaPersonalImss, UTFrmContratarWizard ,
  UtFrmReporteConceptoExtraEmpleados;

procedure TFrmCatalogoPersonalDEX.btnReporteConceptosExtraEmpleadosClick(Sender: TObject);
var
  idx: Integer;
  cursor: TCursor;
  IdEmpleado: string;
  NombreEmpleado: string;
  CodigoEmpleado: String;
  ListaPersonal: TStringList;
begin
  Cursor := Screen.Cursor;
  try
    Screen.Cursor := crAppStart;
    ListaPersonal := TStringList.Create;

    if CxGridPersonal.Controller.SelectedRowCount = 0 then
      raise InteligentException.CreateByCode(24, ['Debe seleccionar al menos un registro de empleado.']);

    Application.CreateForm(TFrmReporteConceptoExtraEmpleados, FrmReporteConceptoExtraEmpleados);
    FrmReporteConceptoExtraEmpleados.ListaPersonal := '';

    for idx := 0 to CxGridPersonal.Controller.SelectedRowCount - 1 do
    begin
      IdEmpleado := FrmReporteConceptoExtraEmpleados.ListaPersonal + VarToStr(CxGridPersonal.Controller.SelectedRows[idx].Values[CxColumnIDPersonal.Index]);
      NombreEmpleado := VarToStr(CxGridPersonal.Controller.SelectedRows[Idx].Values[CxColumnEmpleado.Index]);
      CodigoEmpleado := VarToStr(CxGridPersonal.Controller.SelectedRows[Idx].Values[CxColumnCodigoEmpleado.Index]);
      FrmReporteConceptoExtraEmpleados.ListaPersonal := IdEmpleado + ',';
      ListaPersonal.Add(CodigoEmpleado + ' - ' + NombreEmpleado);
    end;

    //Asignamos la lista informativa del personal
    FrmReporteConceptoExtraEmpleados.ListaPersonalStr := ListaPersonal;

    if not CargarDatosFiltrados(CdDatosEmpresa, 'idConfiguracion', [18]) then
      raise InteligentException.CreateByCode(6, ['idConfiguracion', 'Configuracion', '18']);

    if CdDatosEmpresa.Active then
      CdDatosEmpresa.Refresh
    else
      CdDatosEmpresa.Open;

    FrmReporteConceptoExtraEmpleados.ShowModal;
  finally
    //ListaPersonal.Destroy;
    FrmReporteConceptoExtraEmpleados.frxConceptosExtraXEmpleado.DataSet := nil;
    Screen.Cursor := Cursor;
  end;
end;

procedure TFrmCatalogoPersonalDEX.btn2Click(Sender: TObject);
var
  Cursor: TCursor;
begin
  Try
    cdPersonal.Refresh;

    // Validar la fecha de baja
    Cursor := Screen.Cursor;
    Try
      Screen.Cursor := crAppStart;

      if Not Assigned(cdBuscar) then
        cdBuscar := TClientDataSet.Create(Self);

      if Assigned(cdBuscar) then
      begin
        if cdBuscar.ProviderName = '' then
          if Not CrearConjunto(cdBuscar, 'nuc_personal_validafecha', ccSelect) then
            raise InteligentException.CreateByCode(5, ['nuc_personal_validafecha']);

        if cdBuscar.ProviderName <> '' then
        begin
          if Not CargarDatosFiltrados(cdBuscar, 'IdPersonal,Fecha', [cdPersonal.FieldByName('IdPersonal').AsInteger, ClientModule1.DatetoStrSql(EdtFechaB.Date)]) then
            raise InteligentException.CreateByCode(6, ['nuc_personal_validafecha', cdPersonal.FieldByName('IdPersonal').AsString + '/' + ClientModule1.DatetoStrSql(EdtFechaB.Date), 'Id. Personal / Fecha']);

          if cdBuscar.Active then
            cdBuscar.Refresh
          else
            cdBuscar.Open;

          if cdBuscar.RecordCount = 0 then
            raise InteligentException.CreateByCode(24, ['No es posible dar de baja a esta personal ya que no ha sido dada de alta nunca.']);

          if cdBuscar.FieldByName('Reingreso').IsNull then
            raise InteligentException.CreateByCode(24, ['La persona que est� tratando dar de baja no ha sido contratada a la fecha de ' + ClientModule1.DatetoStrSql(EdtFechaB.Date)]);

          if (Not cdBuscar.FieldByName('Baja').IsNull) {and (cdBuscar.FieldByName('Baja').AsDateTime < EdtFechaB.Date)} then
            raise InteligentException.CreateByCode(24, ['No es posible dar de baja a ' + cdPersonal.FieldByName('NombreCompleto').AsString + ' con fecha ' + DateToStr(EdtFechaB.Date) + ' debido a que ya que existe un movimiento de ' + cdBuscar.FieldByName('TipoMovimiento').AsString + ' el d�a ' + cdBuscar.FieldByName('Baja').AsString]);
        end;
      end;
    Finally
      CambiarEstadoBtn;
      Screen.Cursor := Cursor;
    End;

    ClientModule1.ImprimeReporte('fichabaja.fr3', FrxReportOtros);
    cxGBBajaPersonal.Visible:=False;
  Except
    on e:InteligentException do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOk], 0);

    on e:Exception do
      InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + #10 + #10 + e.Message, mtError, [mbOk], 0);
  End;
end;

procedure TFrmCatalogoPersonalDEX.btn3Click(Sender: TObject);
begin
  CambiarEstadoBtn;
end;

procedure TFrmCatalogoPersonalDEX.Buscar_NombreKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = 13 then
  begin
    if CxBtnBuscar.CanFocus then
      CxBtnBuscar.SetFocus;
  end;
end;

procedure TFrmCatalogoPersonalDEX.CambiarEstadoBtn;
Var
  Estado: Boolean;
begin
  Estado := (cdPersonal.Active) and (cdPersonal.RecordCount > 0);
  //Habilitar todos los que necesiten un registro como m�nimo.
  //DxBarBtnNuevo.Enabled := Estado;
  DxBarBtnDescuentosInf.Enabled := Estado;
  DxBarBtnEditar.Enabled := Estado;
  DxBarBtnEliminarRegistro.Enabled := Estado;
  DxBarBtnModificarContratacion.Enabled := Estado;
  DxBarBtnInasistencia.Enabled := Estado;
  DxBarBtnHistorialContratos.Enabled := Estado;
  DxBarBtnDetalladoNomina.Enabled := Estado;
  DxBarBtnModificarFechaBaja.Enabled := Estado;
  DxBarBtnRefrescar.Enabled := Estado;
  DxBarBtnGenerarBaja.Enabled := Estado;
  DxBarBtnContratar.Enabled := Estado;
  btnReporteConceptosExtraEmpleados.Enabled := Estado;
end;

procedure TFrmCatalogoPersonalDEX.CambiarTab(Sender: TObject);
begin
   if (cxPageContenedor.ActivePage = cxTabInfonavit) then
    dxTabInfonavit.Active := True
  else if cxPageContenedor.ActivePage = cxTabPersonal then
    dxTabPersonal.Active := True
  else if cxPageContenedor.ActivePage = cxTabHistorialContratos then
    dxTabHistorialContratos.Active := True
  else if cxPageContenedor.ActivePage = cxTabDescuentos then
    dxTabDescuentosInf.Active := True;
end;

procedure TFrmCatalogoPersonalDEX.CargarPersonal(IdPersonal: Integer);
begin
  if cdPersonal.ProviderName <> '' then
  begin
    if not CargarDatosFiltrados(cdPersonal, 'Activo,IdPersonal', ['Si',IdPersonal]) then
      raise InteligentException.CreateByCode(6, ['IdPersonal', 'Cat�logo Personal', VarToStr(IdPersonal)]);

    if cdPersonal.Active then
      CdPersonal.Refresh
    else
      CdPersonal.Open;
  end;
end;

procedure TFrmCatalogoPersonalDEX.CxBtnBuscarClick(Sender: TObject);
var
  ALeer: Real;
  EstadoBtn: Boolean;
  locParam: TParamFilter;
begin
  try
    try
      locParam := TParamFilter.Create;
      if cxRadioFiltroPersonal.CurEditValue = 2  then
        locParam.Add('idPersonalImss', 'NULO');

      if cxRadioFiltroPersonal.CurEditValue = 1  then
        locParam.Add('IdPersonalImss2', 'NONULO');

      // Localizar el personal indicado
      CdPersonal.Close;
      Buscar_Nombre.Text := TrimRight(TrimLeft(Buscar_Nombre.Text));

      if (Buscar_Nombre.Text <> '') then
      begin
          if Buscar_Nombre.Text <> '' then
          begin
            locParam.Add('CadenaBuscar', Buscar_Nombre.Text);
            CargarDatosFiltrados(cdPersonal,locParam);
          end;

        ALeer := CuantosRegistros(cdPersonal);
        if (ALeer < 100) or ((ALeer >= 100) and (InteliDialog.ShowModal('Se han localizado muchos registros', 'El criterio de busqueda que se ha especificado devuelve un total de ' + FloatToStrF(ALeer, ffNumber, 10, 0) + ' Empleados.' + #10 + #10 + '�Desea leer todos esos registros en este momento?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)) then
        begin
          // Refrescar los datos
          if cdPersonal.Active then
            cdPersonal.Refresh
          else
            cdPersonal.Open;
        end
        else
        // Limpiar el criterio
        CargarDatosFiltrados(cdPersonal, 'CodigoPersonal,CadenaBuscar', [-1, -1]);
      end;
    finally
      CambiarEstadoBtn;
      locParam.Destroy;
    end;
  except
    on e: InteligentException do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOK], 0);
  end;
end;

procedure TFrmCatalogoPersonalDEX.CxBtnCancelarBuscarClick(Sender: TObject);
begin
  pnlBuscar.Visible := Not pnlBuscar.Visible;
end;

procedure TFrmCatalogoPersonalDEX.cxButton1Click(Sender: TObject);
var
  cursor: TCursor;
  param: TParamFilter;
begin
  try
    param := TParamFilter.Create;
    cdPersonal.AfterScroll := nil;
    Cursor := Screen.Cursor;
    Screen.Cursor := crAppStart;
    try
      param.Add('Infonavit', 'Si');
      if (CdPersonal.Active) and (CdPersonal.RecordCount = 0) then
      begin
        if CxRGroupInfonavit.ItemIndex <> 0 then
        begin
          if not CargarDatosFiltrados(cdPersonal, 'infonavit,FechaInicio,FechaTermino', ['Si', ClientModule1.DatetoStrSql(cxDateEditInicio.Date), ClientModule1.DatetoStrSql(cxDateEditTermino.Date)]) then
            raise InteligentException.CreateByCode(6, ['Infonavit', 'Cat�logo de Personal', 'Si']);
        end
        else
          if not CargarDatosFiltrados(cdPersonal, 'infonavit', ['Si']) then
            raise InteligentException.CreateByCode(6, ['Infonavit', 'Cat�logo de Personal', 'Si']);

        if cdPersonal.Active then
          cdPersonal.Refresh
        else
          cdPersonal.Open;
      end;

      if not CargarDatosFiltrados(CdDatosEmpresa, 'idConfiguracion', [18]) then
        raise InteligentException.CreateByCode(6, ['idConfiguracion', 'Configuracion', '18']);

      if CdDatosEmpresa.Active then
        CdDatosEmpresa.Refresh
      else
        CdDatosEmpresa.Open;

      //CambiaEstadoBtn;
      ClientModule1.ImprimeReporte('resumenInfonavit.fr3', FrxReportGeneral);
      //FrxReportGeneral.DesignReport();

      if Not cxTabInfonavit.Visible then
        cxTabInfonavit.TabVisible := True;

      cxPageContenedor.Properties.TabIndex := cxTabInfonavit.TabIndex;
    finally
      param.Destroy;
      Screen.Cursor := cursor;
    end;
  Except
    on e: InteligentException do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOK], 0 );
  end;
end;

procedure TFrmCatalogoPersonalDEX.cxButton5Click(Sender: TObject);
var
  Cursor: TCursor;
begin
  try
    Cursor := Screen.Cursor;
    try
      Screen.Cursor := crAppStart;
      if cxButton5.CanFocus then
        cxButton5.SetFocus;

      if not CargarDatosFiltrados(CdDatosEmpresa, 'idConfiguracion', [18]) then
        raise InteligentException.CreateByCode(6, ['idConfiguracion', 'Configuracion', '18']);

      if CdDatosEmpresa.Active then
        CdDatosEmpresa.Refresh
      else
        CdDatosEmpresa.Open;

      if CdDescuentosInfonavit.ProviderName = '' then
        if not CrearConjunto(CdDescuentosInfonavit, 'nom_detalle_infonavit', ccCatalog) then
          raise InteligentException.CreateByCode(5, ['Personal Infonavit']);

      if not CargarDatosFiltrados(CdDescuentosInfonavit, 'ClaveConcepto,ListaPersonal,FechaInicio,FechaTermino', ['PrestamoInfonavit', ListaPersonal, ClientModule1.DatetoStrSql(cxDateEditIinicioDescuento.Date), ClientModule1.DatetoStrSql(cxDateEditFinDescuento.Date)]) then
        raise InteligentException.CreateByCode(6, ['IdPersonal', 'Detalle Infonavit', CdPersonal.FieldByName('IdPersonal').AsString]);

      if CdDescuentosInfonavit.Active then
        CdDescuentosInfonavit.Refresh
      else
        CdDescuentosInfonavit.Open;

      ClientModule1.ImprimeReporte('DescuentosInfonavit.fr3', FrxReportDescuentos);

      cxPageContenedor.ActivePage := cxTabDescuentos;
      cxTabDescuentos.TabVisible := True;
    finally
      Screen.Cursor := Cursor;
    end;
  except
    on e: InteligentException do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOK], 0);
  end;
end;

procedure TFrmCatalogoPersonalDEX.cxDateEditFinDescuentoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = 13 then
    cxButton5.SetFocus;
end;

procedure TFrmCatalogoPersonalDEX.CxGridPersonalKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 116 then
  begin
    DxBarBtnRefrescar.Click;
  end;
end;

procedure TFrmCatalogoPersonalDEX.CxGridPersonalStylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  if ARecord.values[CxColumnEspecial.Index] = 'Si' then
    AStyle := cxstylPersonalEspecial;

  if (ARecord.values[CxColumnTipoMovimiento.Index] = 'Baja') and (ARecord.Values[CxColumnDiasDescanso.Index] = 0) then
    AStyle := cxstylPersonalBaja;

  if (ARecord.values[CxColumnTipoMovimiento.Index] = 'Baja') and (ARecord.Values[CxColumnDiasDescanso.Index] = 0) and (ARecord.values[CxColumnEspecial.Index] = 'Si') then
    AStyle := cxstylBajaEspecial;
end;

procedure TFrmCatalogoPersonalDEX.cxPageContenedorChange(Sender: TObject);
begin
  CambiarTab(nil);
end;

procedure TFrmCatalogoPersonalDEX.cxRadioFiltroPersonalCurChange(
  Sender: TObject);
begin
  cxTabPersonal.Caption := 'Mostrando: ' + CxRadioGroupFiltro.Properties.Items.Items[cxRadioFiltroPersonal.CurEditValue].Caption;
end;

procedure TFrmCatalogoPersonalDEX.cxRadioPersonalPropertiesChange(
  Sender: TObject);
begin
  //CxLevelPersonal.Caption := 'Mostrando: ' + TcxRadioGroupProperties(cxRadioPersonal.Properties).Items.Items[TcxRadioGroup(TcxRadioGroupProperties(cxRadioPersonal.Properties).Items).ItemIndex].Caption;

end;

procedure TFrmCatalogoPersonalDEX.CxRGroupInfonavitPropertiesChange(
  Sender: TObject);
begin
  cxGBFiltroinfo.Enabled := CxRGroupInfonavit.ItemIndex > 0;
  if CxRGroupInfonavit.ItemIndex = 0 then
  begin
    cxDateEditTermino.Text := '';
    cxDateEditInicio.Text := '';
  end;
end;

procedure TFrmCatalogoPersonalDEX.cxTabHistorialContratosShow(Sender: TObject);
begin
  try
    Cursor := Screen.Cursor;
    try
      Screen.Cursor := crAppStart;
      pnlEmpleado.Caption := 'EMPLEADO: ' + cdPersonal.FieldByName('NombreCompleto').AsString;
      if not CargarDatosFiltrados(cdHistorialContratacion, 'IdPersonal', [cdPersonal.FieldByName('IdPersonal').AsInteger]) then
        raise InteligentException.CreateByCode(6, ['Historial de Guardias', 'IdPersonal', '-1']);

      if cdHistorialContratacion.Active then
        cdHistorialContratacion.Refresh
      else
      begin
        cdHistorialContratacion.Fields.Clear;
        cdHistorialContratacion.Open;
      end;

    finally
      Screen.Cursor := Cursor;
    end;
  except
    on e: InteligentException do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOK], 0);
  end;
end;

procedure TFrmCatalogoPersonalDEX.cxTabInfonavitHide(Sender: TObject);
begin
  dxTabInfonavit.Visible := cxTabInfonavit.TabVisible;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnBuscarClick(Sender: TObject);
begin
  pnlBuscar.Visible := Not pnlBuscar.Visible;
  if (pnlBuscar.Visible) and (Buscar_Nombre.CanFocus) then
    Buscar_Nombre.SetFocus;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnCerrarClick(Sender: TObject);
begin
  if cxPageContenedor.ActivePage = cxTabDescuentos then
  begin
    cxTabDescuentos.TabVisible := False;
    dxTabDescuentosInf.Visible := False;
  end
  else if cxPageContenedor.ActivePage = cxTabInfonavit then
  begin
    cxTabInfonavit.TabVisible := False;
  end;
  cxPageContenedor.ActivePage := cxTabPersonal;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnCerrarContratosClick(Sender: TObject);
begin
  cxTabHistorialContratos.TabVisible := False;
  dxTabHistorialContratos.Visible := False;
  cxTabPersonal.TabVisible := True;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnContratarClick(Sender: TObject);
var
    Resp:Integer;
    OldC:TCursor;
    FechaC,Cargo,Depto,Nomina:string;
begin

  //cxDBListBox1.Items.AddObject('',TObject(Id))

  // Iniciar wizard de contrataci�n
  Try
    if (Not cdPersonal.FieldByName('IdPersonalImss').IsNull) or (cdPersonal.FieldByName('IdPersonalImss').AsString <> '')  then
      if (InteliDialog.ShowModal('Aviso', 'El personal seleccionado ya se encuentra contratado. Es recomendable recontratar con una n�mina diferente. Desea continuar?', mtConfirmation, [mbYes, mbNo], 0)) = mrNo then
        raise InteligentException.CreateByCode(24, ['Proceso de contrataci�n cancelado por el usuario.']);

    OldC := Screen.Cursor;
    Try
      Screen.Cursor := crAppStart;

      if CdORganizacion.ProviderName = '' then
      begin
        if not CrearConjunto(CdOrganizacion,'nuc_organizacion',ccCatalog) then
          raise InteligentConnection.CreateByCode(5, ['Organizaci�n']);
        CdOrganizacion.open;
      end;

      if CdDepartamento.ProviderName = '' then
        if not CrearConjunto(CdDepartamento, 'nuc_departamento', ccCatalog) then
          raise InteligentConnection.CreateByCode(5, ['Departamentos']);

      if CdCargo.ProviderName = '' then
        if not CrearConjunto(CdCargo,'nuc_cargo',ccCatalog) then
          raise InteligentConnection.CreateByCode(5, ['Cargos']);

      if cdImss.ProviderName = '' then
        if not CrearConjunto(CdImss, 'nuc_personalimss', ccUpdate) then
          raise InteligentConnection.CreateByCode(5, ['datos de IMSS']);

      if cdGuardias.ProviderName = '' then
      begin
        if not CrearConjunto(cdGuardias, 'nom_guardia', ccCatalog) then
          raise InteligentConnection.CreateByCode(5, ['Guardias']);

        cdGuardias.Open;
      end;

      if cdTipoNomina.ProviderName = '' then
      begin
        if not CrearConjunto(cdTipoNomina, 'nom_tiponomina', ccCatalog) then
          raise InteligentConnection.CreateByCode(5, ['Tipos de n�minas']);

        if Not CargarDatosFiltrados(cdTipoNomina, 'TipoCalculo', ['PERIODICA']) then
          raise InteligentException.CreateByCode(6, ['Tipos de N�mina', 'PERIODICA', 'Tipo C�lculo']);

        cdTipoNomina.Open;
      end;

      if cdSalario.ProviderName = '' then
        // Nos permite buscar los salarios
        if not CrearConjunto(cdSalario, 'rhu_salario', ccCatalog) then
          raise InteligentConnection.CreateByCode(5, ['Salarios']);

      if cdRangoSalario.ProviderName = '' then
        //nos permite buscar los rangos de salarios
        if not CrearConjunto(CdRangoSalario, 'nom_rangosalarios', ccCatalog) then
          raise InteligentConnection.CreateByCode(5, ['rangos de salarios']);

      cdTipoNomina.First;

      if Not CargarDatosFiltrados(cdImss, 'IdPersonalImss', [-9]) then
        raise InteligentException.CreateByCode(6, ['Registros de Personal ante el IMSS', -9, 'IdPersonalImss']);

      cdImss.Open;
      cdImss.Append;
      cdImss.FieldByName('TipoMovimiento').AsString := 'Alta';
      cdImss.FieldByName('FechaMovimiento').AsDateTime := Now;
      cdImss.FieldByName('IdTipoNomina').AsInteger := cdTipoNomina.FieldByName('IdTipoNomina').AsInteger;

      Application.CreateForm(TFrmContratarWizard, FrmContratarWizard);
      FrmContratarWizard.lblNombre.Caption.Text := cdPersonal.FieldByName('NombreCompleto').AsString;
      FrmContratarWizard.dsOrganizacion.DataSet := cdOrganizacion;
      FrmContratarWizard.dsDepartamento.DataSet := cdDepartamento;
      FrmContratarWizard.dsCargo.DataSet := cdCargo;
      FrmContratarWizard.dsTipoNomina.DataSet := cdTipoNomina;
      FrmContratarWizard.dsRangoSalario.DataSet := cdRangoSalario;
      FrmContratarWizard.dsSalarios.DataSet := cdSalario;
      FrmContratarWizard.dsGuardias.DataSet := cdGuardias;
      FrmContratarWizard.dsImss.DataSet := cdImss;
      FrmContratarWizard.dsDatos.DataSet := cdPersonal;
      FrmContratarWizard.ShowModal;
    Finally
      Screen.Cursor := OldC;
      FrmContratarWizard.Free;
      DxBarBtnRefrescarClick(nil);
    End;
  Except
    on e:InteligentConnection do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOk], 0);

    on e:InteligentException do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOk], 0);

    on e:Exception do
      InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + #10 + #10 + e.Message, mtError, [mbOk], 0);
  End;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnDescuentosInfClick(Sender: TObject);
var
  Forma: TForm;
  idx: Integer;
begin
  if CxGridPersonal.Controller.SelectedRowCount > 0 then
  begin
    Try
      ListaPersonal := '';
      for idx := 0 to CxGridPersonal.Controller.SelectedRowCount - 1 do
      begin
        ListaPersonal := ListaPersonal + VarToStr(CxGridPersonal.Controller.SelectedRows[idx].Values[CxColumnIDPersonal.Index]) + ',';
      end;

      Forma := TForm.Create(Nil);
      Forma.Width := 285;
      Forma.Height := 200;
      Forma.BorderStyle := bsDialog;
      Forma.Position := poMainFormCenter;
      Forma.Caption := 'Descuentos Infonavit';
      cxGBDescuentosInfonavit.Parent := Forma;
      cxGBDescuentosInfonavit.Align := alClient;
      cxGBDescuentosInfonavit.Visible := True;
      Forma.ShowModal;

      if cdPersonal.Active then
        CambiarEstadoBtn;
    Finally
      cxGBDescuentosInfonavit.Visible := False;
      cxGBDescuentosInfonavit.Align := alNone;
      cxGBDescuentosInfonavit.Parent := Self;
      Forma.free;
    End;
  End;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnDetalladoNominaClick(Sender: TObject);
begin
  Try
    Application.CreateForm(TFrmConcentradoNomina, FrmConcentradoNomina);
    FrmConcentradoNomina.Individual := True;
    FrmConcentradoNomina.IdPersonal := CdPersonal.FieldByName('IdPersonal').asInteger;
    FrmConcentradoNomina.Nombre := CdPersonal.FieldByName('nombreCompleto').asString;
    FrmConcentradoNomina.ShowModal;
  Finally
    FreeAndNil(FrmConcentradoNomina);
  End;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnEditarClick(Sender: TObject);
begin
  Application.CreateForm(TFrmFichaGeneralPersonal, FrmFichaGeneralPersonal);
  FrmFichaGeneralPersonal.accion := 'Editar';
  FrmFichaGeneralPersonal.IdPersonal := CdPersonal.FieldByName('idpersonal').AsInteger;
  FrmFichaGeneralPersonal.ShowModal;
  cdPersonal.AfterScroll := nil;
  cdPersonal.Refresh;
  CambiarEstadoBtn;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnEliminarRegistroClick(
  Sender: TObject);
var
  cdPersonalUpt: TClientDataSet;
  LocIdPersonal: Integer;
  LocNamePersonal: string;
  cursor: TCursor;
begin
  try
    Cursor := Screen.Cursor;
    Screen.Cursor := crAppStart;
    try
      cdPersonalUpt := TClientDataSet.Create(Self);
      LocIdPersonal := cdPersonal.FieldByName('IdPersonal').AsInteger;
      LocNamePersonal := cdPersonal.FieldByName('NombreCompleto').AsString;
      if InteliDialog.ShowModal('Confirmaci�n', '�Est� seguro que desea eliminar el empleado [' + LocNamePersonal + ']', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        if cdPersonalUpt.ProviderName = '' then
          if not CrearConjunto(cdPersonalUpt, 'nuc_personal', ccUpdate) then
            raise InteligentException.CreateByCode(5, ['Cat�logo de Personal']);

        if not CargarDatosFiltrados(cdPersonalUpt, 'idPersonal', [LocIdPersonal]) then
          raise InteligentException.CreateByCode(6, ['IdPersonal', 'Cat�logo de Personal', VarToStr(LocIdPersonal)]);

        if cdPersonalUpt.Active then
          cdPersonalUpt.Refresh
        else
          cdPersonalUpt.Open;

        if cdPersonalUpt.RecordCount = 0 then
          raise InteligentException.CreateByCode(13, ['IdPersonal', 'Personal']);

        cdPersonalUpt.Edit;
        cdPersonalUpt.FieldByName('Activo').AsString := 'No';
        cdPersonalUpt.Post;
        cdPersonalUpt.ApplyUpdates(-1);

        ClientModule1.registrarEvento('CATALOGO DE PERSONAL', 'DESACTIVACION DE REGISTRO', LocNamePersonal, 0.0, 0);
        if CdPersonal.Active then
          cdPersonal.Refresh;
      end;
    finally
      if cdPersonalUpt.State  in [dsEdit, dsInsert] then
        cdPersonalUpt.Cancel;

      if Assigned(cdPersonalUpt) then
        cdPersonalUpt.Destroy;

      CambiarEstadoBtn;
      screen.Cursor := Cursor;
    end;
  except
    on e: InteligentException do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOK], 0);
  end;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnExportarInfonavitClick(
  Sender: TObject);
var
  NombreCompleto, TituloExport: String;
  ReporteExportar: TfrxReport;
begin
  Try
    if cxPageContenedor.ActivePage = cxTabDescuentos then
    begin
      ReporteExportar := FrxReportDescuentos; //Descuentos Infonavit
      TituloExport := 'Exportar Resumen de Descuentos Infonavit.';
    end
    else if cxPageContenedor.ActivePage = cxTabInfonavit then
    begin
      ReporteExportar := FrxReportGeneral;
      TituloExport := 'Exportar Resumen de Empleados con Infonavit.';
    end;

    NombreCompleto := '';
    FrxPDFExportInfonavit.ExportTitle := TituloExport;
    FrxPDFExportInfonavit.ExportObject(ReporteExportar);
    Try
      FrxPDFExportInfonavit.DefaultPath := 'C:\Users\';
      FrxPDFExportInfonavit.FileName := NombreCompleto + '.pdf';
      if ReporteExportar.Export(FrxPDFExportInfonavit) then
      begin
        if InteliDialog.ShowModal('Aviso', '�Desea abrir el documento exportado?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then

        NombreCompleto := FrxPDFExportInfonavit.FileName;
        ShellExecute(Self.Handle, Nil, PChar(NombreCompleto), '', '', SW_SHOWNORMAL);
      end;
    Finally
      ReporteExportar.ShowReport(True);
    End;
  Except
    on e:Exception do
      InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + e.Message, mtError, [mbOk], 0);
  End;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnGenerarBajaClick(Sender: TObject);
var
  Forma: TForm;
begin
  Try
    if not CargarDatosFiltrados(CdDatosEmpresa, 'idConfiguracion', [18]) then
      raise InteligentException.CreateByCode(6, ['idConfiguracion', 'Configuracion', '18']);

    if CdDatosEmpresa.Active then
      CdDatosEmpresa.Refresh
    else
      CdDatosEmpresa.Open;

    if cdPersonal.FieldByName('IdPersonalimss').IsNull then
      raise InteligentException.CreateByCode(24, ['El Personal que intenta modificar, no se encuentra contratado.']);

    // Verificar si el personal est� activo
    if cdFechaBaja.ProviderName = '' then
      if Not CrearConjunto(cdFechaBaja, 'nuc_personal_baja', ccCatalog) then
        raise InteligentException.CreateByCode(5, ['Movimientos de contrataci�n']);

    if Not CargarDatosFiltrados(cdFechaBaja, 'IdPersonal', [cdPersonal.FieldByName('IdPersonal').AsInteger]) then
      raise InteligentException.CreateByCode(6, ['Movimientos de contrataci�n', cdPersonal.FieldByName('IdPersonal').AsInteger, 'Id. Personal']);

    if cdFechaBaja.Active then
      cdFechaBaja.Refresh
    else
      cdFechaBaja.Open;

    if cdFechaBaja.RecordCount > 0 then
      raise InteligentException.CreateByCode(24, ['El empleado ' + cdPersonal.FieldByName('NombreCompleto').AsString + ' ya se encuentra dado de baja el d�a: ' + cdFechaBaja.FieldByName('FechaBaja').AsString]);

    lblNombreEmpleadoBaja.Caption := cdPersonal.FieldByName('NombreCompleto').AsString;
    Edtfechab.Date := Date;
    cxGBBajaPersonal.Visible := True;
    Try
      Forma := TForm.Create(Nil);
      Forma.Width := 295;
      Forma.Height := 195;
      Forma.Position := poMainFormCenter;
      Forma.Caption := 'Baja de Personal';
      cxGBBajaPersonal.Parent := Forma;
      cxGBBajaPersonal.Align := alClient;
      cxGBBajaPersonal.Visible := True;

      Forma.ShowModal;

      if CdPersonal.Active then
        CdPersonal.Refresh;
    Finally
      CambiarEstadoBtn;
      cxGBBajaPersonal.Visible := False;
      cxGBBajaPersonal.Align := alNone;
      cxGBBajaPersonal.Parent := Self;
      Forma.Free;
    End;
  Except
    on e:InteligentException do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOk], 0);

    on e:Exception do
      InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + #10 + #10 + e.Message, mtError, [mbOk], 0);
  End;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnGraficaClick(Sender: TObject);
begin
  if CxLevelGraficaSalarios.active then
  begin
    if cdHistorialContratacion.Filtered then
      cdHistorialContratacion.Filtered := False;
    CxLevelDatosContrato.Active := True;
    DxBarBtnGrafica.Caption := 'Ver Gr�fica de Salarios';
  end
  else
  begin
    try
      cdHistorialContratacion.Filtered := False;
      cdHistorialContratacion.Filter := 'TipoMovimiento = ' + QuotedStr('Reingreso');
      cdHistorialContratacion.Filtered := True;
    except
      cdHistorialContratacion.Filtered := False;
    end;
    CxLevelGraficaSalarios.Active := True;
    DxBarBtnGrafica.Caption := 'Ocultar Gr�fica de Salarios';
  end;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnHistorialContratosClick(
  Sender: TObject);
begin
  cxTabHistorialContratos.TabVisible := False;
  cxTabHistorialContratos.TabVisible := True;
  dxTabHistorialContratos.Visible := True;
  cxPageContenedor.ActivePage := cxTabHistorialContratos;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnInasistenciaClick(Sender: TObject);
begin
  Try
    if cdPersonal.FieldByName('IdPersonalimss').IsNull then
      raise InteligentException.CreateByCode(24, ['El Personal que intenta modificar, no se encuentra contratado.']);

    if cdInasistenciaUpt.ProviderName = '' then
      if Not CrearConjunto(cdInasistenciaUpt, 'nom_inasistencia', ccUpdate) then
        raise InteligentException.CreateByCode(5, ['Inasistencias']);

    if cdTipoInasistencia.ProviderName = '' then
    begin
      if Not CrearConjunto(cdTipoInasistencia, 'nom_tipoinasistencia', ccCatalog) then
        raise InteligentException.CreateByCode(5, ['Tipos de Inasistencia']);

      cdTipoInasistencia.Open;
    end;

    Application.CreateForm(TFrmExcepciones, FrmExcepciones);
    FrmExcepciones.dsPersonal.DataSet := cdPersonal;
    FrmExcepciones.dsInasistencia.DataSet := cdInasistencia;
    FrmExcepciones.dsTipoInasistencia.DataSet := cdTipoInasistencia;
    FrmExcepciones.dsInasistenciaUpt.DataSet := cdInasistenciaUpt;

    if Not CargarDatosFiltrados(cdInasistenciaUpt, 'IdExcepcion', [-9]) then
      raise InteligentException.CreateByCode(21, ['Inasistencia']);

    if cdInasistenciaUpt.Active then
      cdInasistenciaUpt.Refresh
    else
      cdInasistenciaUpt.Open;

    FrmExcepciones.ShowModal;
  Finally
    CambiarEstadoBtn;
    FrmExcepciones.dsPersonal.DataSet := Nil;
    cdInasistenciaUpt.Close;
  End;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnListaInfonavitClick(Sender: TObject);
var
  Forma: TForm;
begin
  Try
    Forma := TForm.Create(Nil);
    Forma.Width := 285;
    Forma.Height := 225;
    Forma.BorderStyle := bsDialog;
    Forma.Position := poMainFormCenter;
    Forma.Caption := 'Filtros infonavit.';
    cxGBOnfonavit.Parent := Forma;
    cxGBOnfonavit.Align := alClient;
    cxGBOnfonavit.Visible := True;
    Forma.ShowModal;
    if cdPersonal.Active then
      CambiarEstadoBtn;
  Finally
    cxGBOnfonavit.Visible := False;
    cxGBOnfonavit.Align := alNone;
    cxGBOnfonavit.Parent := Self;
    Forma.free;
  End;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnModificarContratacionClick(
  Sender: TObject);
var
  Marca: TBookMark;
begin
  try
    cdPersonal.AfterScroll := nil;
    try
      Try
        Marca := nil;
        Marca := cdPersonal.Bookmark;
        cdPersonal.Refresh;
      Finally
        cdPersonal.GotoBookmark(Marca);
      End;

      if cdPersonal.FieldByName('IdPersonalimss').IsNull then
        raise InteligentException.CreateByCode(24, ['El Personal que intenta modificar, no se encuentra contratado.']);

      Application.CreateForm(TFrmDatosContratacion ,FrmDatosContratacion);
      FrmDatosContratacion.IdPersonal := cdPersonal.FieldByName('IdPersonal').AsInteger;

      FrmDatosContratacion.ShowModal;

      if Marca <> Nil then
      begin
        cdPersonal.Refresh;
        cdPersonal.GotoBookmark(Marca);
      end;
    finally
      CambiarEstadoBtn;
      FrmDatosContratacion.Free;
    end;
  except
    on e:InteligentException do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOk], 0);

    on e:Exception do
      InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + #10 + #10 + e.Message, mtError, [mbOk], 0);
  end;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnNUevoClick(Sender: TObject);
begin
   Application.CreateForm(TFrmFichaGeneralPersonal, FrmFichaGeneralPersonal);
  FrmFichaGeneralPersonal.accion := 'Nuevo';
  FrmFichaGeneralPersonal.ShowModal;
  cdPersonal.AfterScroll := nil;
  if CdPersonal.active then
    cdPersonal.Refresh
  else
    CdPersonal.Open;

  CambiarEstadoBtn;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnRefrescarClick(Sender: TObject);
var
  cursor: TCursor;
begin
  Cursor := Screen.Cursor;
  try
    Screen.Cursor := crAppStart;
    if cdPersonal.Active then
      cdPersonal.Refresh;
  finally
    Screen.Cursor := Cursor;
  end;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnReporteContratosClick(
  Sender: TObject);
begin
  ClientModule1.ImprimeReporte('HistorialGuardias.fr3', frxReporteHistorialGuardias);
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnResumenEmpleadosClick(
  Sender: TObject);
var
  Cursor: TCursor;
begin
  try
    Cursor := Screen.Cursor;
    try
      Screen.Cursor := crAppStart;

      if not CargarDatosFiltrados(CdDatosEmpresa, 'idConfiguracion', [18]) then
        raise InteligentException.CreateByCode(6, ['idConfiguracion', 'Configuracion', '18']);

      if CdDatosEmpresa.Active then
        CdDatosEmpresa.Refresh
      else
        CdDatosEmpresa.Open;

      ClientModule1.ImprimeReporte('ResumenPersonal.fr3', FrxReportEmpleados);

    finally
      Screen.Cursor := Cursor;
    end;
  except
    on e: InteligentException do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOK], 0);
  end;
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnTodoPersonalClick(Sender: TObject);
var
  cursor: TCursor;
begin
  try
    Cursor := Screen.Cursor;
    try
      Screen.Cursor := crAppStart;
      CargarPersonal(-1);
    finally
      CambiarEstadoBtn;
      Screen.Cursor := Cursor;
    end;
  except
    on e: InteligentException do
      InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOK], 0);
  end
end;

procedure TFrmCatalogoPersonalDEX.DxBarBtnVerCompletoClick(Sender: TObject);
var
  NombreReporte: String;
begin
  if cxPageContenedor.ActivePage = cxTabDescuentos then
    NombreReporte := 'DescuentosInfonavit.fr3'
  else
    NombreReporte := 'ResumenInfonavit.fr3';

  ClientModule1.ImprimeReporte(NombreReporte , FrxReportGeneralExterno);

//  RutaReporte := ExtractFilePath(Application.ExeName);
//
//  FrxReportGeneralExterno.LoadFromFile(ClientModule1.CdRutaReportes.FieldByName('Valor1').asString + 'resumenInfonavit.fr3');
//  FrxReportGeneralExterno.DesignReport;
//
//  if InteliDialog.ShowModal('Aviso', '�Desea generar nuevamente el reporte modificado?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
//    ClientModule1.ImprimeReporte('ResumenInfonavit.fr3', FrxReportGeneralExterno);
end;

procedure TFrmCatalogoPersonalDEX.DxRibbonPersonalTabChanged(
  Sender: TdxCustomRibbon);
begin
  if DxRibbonPersonal.ActiveTab = dxTabPersonal then
    cxPageContenedor.ActivePage := cxTabPersonal
  else if DxRibbonPersonal.ActiveTab = dxTabInfonavit then
    cxPageContenedor.ActivePage := cxTabInfonavit
  else if DxRibbonPersonal.ActiveTab = dxTabHistorialContratos then
    cxPageContenedor.ActivePage := cxTabHistorialContratos
  else if dxRibbonPersonal.ActiveTab = dxTabDescuentosInf then
    cxPageContenedor.activePage := cxTabDescuentos;
end;

procedure TFrmCatalogoPersonalDEX.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if CdBuscar.Active then
    CdBuscar.Close;

  if cdHistorialContratacion.Active then
    cdHistorialContratacion.Close;

//  if CdPersonal.Active then
//    CdPersonal.Close;

  if CdTipoInasistencia.Active then
    CdTipoInasistencia.Close;

  if CdInasistencia.Active then
    CdInasistencia.Close;

  if (CdInasistenciaUpt.Active) and (CdInasistenciaUpt.State in [dsInsert, dsEdit])  then
    CdInasistenciaUpt.Cancel;

  if CdInasistenciaUpt.Active then
    CdInasistenciaUpt.Close;

  if CdDatosEmpresa.Active then
    CdDatosEmpresa.Close;

  if CdFechaBaja.Active then
    CdFechaBaja.Close;

  if CdBuscar.ProviderName <> '' then
    EliminarConjunto(CdBuscar);

  if cdHistorialContratacion.ProviderName <> '' then
    EliminarConjunto(cdHistorialContratacion);

  if CdTipoInasistencia.ProviderName <> '' then
    EliminarConjunto(CdTipoInasistencia);

  if CdInasistencia.ProviderName <> '' then
    EliminarConjunto(CdInasistencia);

  if CdInasistenciaUpt.ProviderName <> '' then
    EliminarConjunto(CdInasistenciaUpt);

  if CdDatosEmpresa.ProviderName <> '' then
    EliminarConjunto(CdDatosEmpresa);

  if CdFechaBaja.ProviderName <> '' then
    EliminarConjunto(CdFechaBaja);

  if cdPersonal.Active then
    cdPersonal.Close;

  if cdPersonal.ProviderName <> '' then
    EliminarConjunto(cdPersonal);

  action := caFree;
end;

procedure TFrmCatalogoPersonalDEX.FormCreate(Sender: TObject);
begin
  if cdPersonal.ProviderName = '' then
    if Not CrearConjunto(cdPersonal, 'nuc_personal', ccCatalog) then
      raise InteligentException.CreateByCode(5, ['Cat�logo de Personal']);

  //if Assigned(Form2) then
    dsPersonal.DataSet := cdPersonal;

  if not CrearConjunto(CdDatosEmpresa, 'nuc_configuracion', ccCatalog) then
    raise InteligentException.CreateByCode(5, ['nuc_Configuraci�n']);

  if Not CrearConjunto(cdHistorialContratacion, 'nuc_personalimss_contratacion', ccSelect) then
    raise InteligentException.CreateByCode(5, ['nuc_personalimss_contratacion']);

  if Not CrearConjunto(cdPersonalimss, 'nuc_personalimss', ccUpdate) then
    raise InteligentException.CreateByCode(5, ['Personal']);

  if Not CrearConjunto(cdBaja, 'nuc_personalimss', ccUpdate) then
    raise InteligentException.CreateByCode(5, ['Personal']);


  cxTabPersonal.Visible := True;
  dxTabInfonavit.Visible := False;
  cxTabInfonavit.TabVisible := False;
  cxTabDescuentos.TabVisible := False;
  dxTabDescuentosInf.Visible := False;
  dxTabHistorialContratos.Visible := False;
  cxTabHistorialContratos.TabVisible := False;
end;

procedure TFrmCatalogoPersonalDEX.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 116 then
  begin
    DxBarBtnRefrescar.Click;
  end;
end;

procedure TFrmCatalogoPersonalDEX.FrxReportGeneralGetValue(
  const VarName: string; var Value: Variant);
begin
  if CompareText(VarName, 'LeyendaRango') = 0 then
  begin
    if (cxDateEditInicio.Text = '') and (cxDateEditTermino.Text = '') then
      Value := 'Procesado: Todo el Personal'
    else
      Value := 'Procesado del ' + cxDateEditInicio.Text + ' al ' + cxDateEditTermino.Text;
  end;
end;

procedure TFrmCatalogoPersonalDEX.FrxReportOtrosDblClickObject(Sender: TfrxView;
  Button: TMouseButton; Shift: TShiftState; var Modified: Boolean);
var
  LocIdPersonal : string;
begin
  try
    if not CargarDatosFiltrados(cdBaja, 'idPersonalIMss', [-9]) then
      raise InteligentException.CreateByCode(6, ['IdPErsonalImss', 'Personal Imss', '-9']);

    if cdBaja.Active then
      cdBaja.Refresh
    else
      cdBaja.Open;
    if sender.name = 'MFechaB' then
      DxBarBtnModificarFechaBajaClick(nil);

    if sender.name = 'MBajaP' then
    try
      if ssCtrl in Shift then
      begin
        if (InteliDialog.ShowModal('Confirmaci�n.', 'Est� seguro que desea dar de baja al personal seleccionado?', mtConfirmation, [mbYes,mbNo], 0)) = mryes then
        begin
          if not CargarDatosFiltrados(cdPersonalimss, 'IdPersonal', [Sender.TagStr]) then
            raise InteligentException.CreateByCode(6,['Personal IMSS',Sender.TagStr,'IdPersonal']);

          if cdPersonalImss.Active then
            cdPersonalImss.Refresh
          else
            cdPersonalImss.Open;

          if (cdPersonalimss.FieldByName('FechaMovimiento').AsDateTime < Edtfechab.Date) and (cdPersonalimss.FieldByName('TipoMovimiento').AsString<>'Baja') then
          begin
            cdBaja.Append;
            LocIdPersonal := CdPersonalImss.FieldByName('IdPersonal').AsString;
            cdBaja.FieldByName('IdPersonalIMSS').AsInteger := 0;
            cdBaja.FieldByName('IdPersonal').AsInteger := cdPersonalimss.FieldByName('IdPersonal').AsInteger;
            cdBaja.FieldByName('IdTipoNomina').AsInteger := cdPersonalimss.FieldByName('IdTipoNomina').AsInteger;
            cdBaja.FieldByName('FechaMovimiento').AsDateTime := Edtfechab.Date;
            cdBaja.FieldByName('FechaRegistro').AsDateTime := Now();
            cdBaja.FieldByName('TipoMovimiento').AsString := 'Baja';
            cdBaja.FieldByName('IdPlazaDetalle').AsInteger := cdPersonalimss.FieldByName('IdPlazaDetalle').AsInteger;
            cdBaja.FieldByName('RegistroPatronal').AsString := cdPersonalimss.FieldByName('RegistroPatronal').AsString;
            cdBaja.FieldByName('SalarioDiario').AsFloat := cdPersonalimss.FieldByName('SalarioDiario').AsFloat;
            cdBaja.FieldByName('SalarioIntegrado').AsFloat := cdPersonalimss.FieldByName('SalarioIntegrado').AsFloat;
            cdBaja.FieldByName('Procesado').AsString := 'Si';
            cdBaja.FieldByName('cobrafestivos').AsString := cdPersonalimss.FieldByName('cobrafestivos').AsString;
            cdBaja.FieldByName('jornada').AsInteger := cdPersonalimss.FieldByName('jornada').AsInteger;
            if not cdPersonalimss.FieldByName('idPeriodosGuardia').IsNull then
              cdBaja.FieldByName('idPeriodosGuardia').AsInteger := cdPersonalimss.FieldByName('idPeriodosGuardia').AsInteger
            else
              cdBaja.FieldByName('idPeriodosGuardia').Clear;
            cdBaja.FieldByName('IdDepartamento').AsInteger := cdPersonalimss.FieldByName('IdDepartamento').AsInteger;
            cdBaja.FieldByName('IdCargo').AsInteger := cdPersonalimss.FieldByName('IdCargo').AsInteger;
            cdBaja.FieldByName('IdOrganizacion').AsInteger := cdPersonalimss.FieldByName('IdOrganizacion').AsInteger;
            cdBaja.FieldByName('TipoFiniquito').AsInteger := cbTipoFiniquito.ItemIndex;
            cdBaja.Post;
            cdBaja.ApplyUpdates(-1);
            ClientModule1.registrarEvento('BAJA PERSONAL', 'BAJA DE PERSONAL', 'IDPersonal: ' + LocIdPersonal, 0.0, 0);
            InteliDialog.ShowModal('Aviso', 'Se ha registrado la baja del personal correctamente.', mtInformation, [mbOk], 0);
            FrxReportOtros.PreviewForm.Close;
          end;
        end;
      end;
    except
      on e:InteligentException do
        ;
      on e:exception do
        InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + #10 + e.Message, mtError, [mbOk], 0);
    End;
  finally
    if (cdBaja.Active) and (cdBaja.State in [dsInsert, dsEdit]) then
      cdBaja.Close;
  end;
end;

procedure TFrmCatalogoPersonalDEX.FrxReportOtrosGetValue(const VarName: string;
  var Value: Variant);
begin
  if CompareText(VarName, 'FECHABAJA') = 0 then
    Value := EdtFechaB.text;

  if CompareText(VarName,'TipoFiniquito') = 0 then
    Value := cbTipoFiniquito.Text;
end;



procedure TFrmCatalogoPersonalDEX.modificarFechaBaja;
begin

end;

end.

