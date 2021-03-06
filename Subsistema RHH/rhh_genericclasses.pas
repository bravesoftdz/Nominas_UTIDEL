//****************************************************************************
// Variables incluidas en el c�lculo:
//   1.- DiasMesInicio (Numero de d�as en el mes de inicio de n�mina)
//   2.- DiasMesTermino  (N�mero de d�as en el mes de termino de n�mina)
//   3.- DiasMesAntes  (N�mero de d�as en el mes anterior al inicio de la n�mina)
//   4.- DiasMesDespues  (N�mero de d�as en el mes posterior al termino de la n�mina)
//   5.- NumeroSemanasInicio  (N�mero de semanas en el mes de inicio de la n�mina)
//   6.- NumeroSemanasTermino  (N�moer de semanas en el mes de termino de la n�mina)
//   7.- NumeroDiasBimestreInicio  (N�mero de dias en el bimestre al inicio de la n�mina
//   8.- NumeroSemanasBimestreInicio  (N�moer de semanas en el bimestre al inicio de la n�mina
//   9.- NumeroDiasBimestreTermino  (N�mero de dias en el bimestre al termino de la n�mina
//  10.- NumeroSemanasBimestreTermino  (N�mero de semanas en el bimestre al termino de la n�mina
//****************************************************************************
unit rhh_genericclasses;

interface

uses
  Windows, Classes, SysUtils, StrUtils, jvLabel, Graphics, DBClient, ExtCtrls,
  Controls, UInteliDialog, ClientModuleUnit1, DB, Variants, ComCtrls, Forms,
  DateUtils, StdCtrls, AdvOfficePager, AdvGlowButton, Dialogs, comobj, ExportaExcel,
  ShellAPI, cxProgressBar, frxClass, frxDBSet, NxDBGrid, AdvProgressBar, cxDBPivotGrid,
  cxGridDBTableView, cxGrid, DBGrids, cxGridDBCardView;

type
  TSigno = (sgNil, sgSuma, sgResta, sgMult, sgDiv, sgResiduo, sgEQ, sgMT, sgME, sgGT, sgGE, sgNE, sgRango, sgInv);

  TListaMemoria = Class
    Valor: String;
  End;

  TFormato = class
    CodigoConcepto: String;
    Clave: String;
    Titulo: String;
    Nombre: String;
    Modo: String;
    IdGrupoConcepto: Integer;
    Font: String;
    Size: Integer;
    Color: Integer;
    Height: Integer;
    Style: String;
  end;

  TVarValores = Class
  Protected
    sClase: String;
    sCodigo: String;
    sFormato: TFormato;
    ModuloPantalla: string;
  Private
    vValor: Variant;
  Public
    function AsString: String;
    function AsInteger: Integer;
    function AsFloat: Extended;
    function AsDate: TDate;
    function AsDateTime: TDateTime;
    function AsVariant: Variant;
    property Formato: TFormato read sFormato write sFormato;
  End;

  TTipos = (tvFloat, tvString, tvInteger);

  TValores = class
  private
    ListaValor: TStringList;
  public
    Constructor Create;
    Destructor Destroy;

    function Elemento(Nombre: String): TVarValores;
    procedure SetValue(Nombre: String; Valor: Variant; Datos: String = '');
    procedure SetValueNomina(Nombre: String; Valor: Variant);
    function ResetValue(Nombre: String; Valor: Variant): Boolean;
    function IsType(Nombre: String; Tipo: TTipos): Boolean;
  End;

  RegLog = record
    Campo: string;
    ValorAnt: string;
    ValorNuevo: string;
  end;

  TListaCambios = class
  protected
    FLista: TStringList;
    function GetCount: Integer;
    function GetItem(Index: Integer): RegLog;
    procedure SetItem(Index:Integer; pRegLog:RegLog);
    function Encode(ACampo, AValorAnt, AValorNuevo: string): string;
  public
    constructor Create; overload;
    constructor Create(AListaCambios: string); overload;
    destructor Destroy;
    procedure Add(ACampo, AValorAnt, AValorNuevo: string); overload;
    procedure Add(ARegLog: RegLog); overload;
    procedure Clear;
    function DelimitedString: String;
    property Items[Index: integer]: RegLog read GetItem write SetItem; default;
    property Count: Integer read GetCount;
  end;

  TJvLabelExt = class(TJvLabel)
  public
    oldFont: TFont;
    idplazadetalle: Integer;
    iddepartamento: Integer;
    titulodepartamento: String;
    idcargo: Integer;
    titulocargo: String;
    idpersonal: Integer;
    idplaza: integer;
  end;

  TPrueba = Class
    procedure OnClickCancel(Sender: TObject);
  End;

const
  TextoVacante = '(Vacante)';
  TextoVacanteND = '(Vacante no disponible)';
  ListaFunciones: Array[0..1] of String = ('ENTERO', 'ECIMAL');

Var
  cdDetalle,
  cdDetalleSave,
  cdAjusteNomina: TClientDataSet;
  IdPersonal, IdNomina,
  IdCargo, IdOrganizacion,
  IdDepartamento: Integer;
  SMGVDF: Real;
  Valores: TValores;
  NuevoTitulo: String;
  cdgcConcepto: TClientDataSet;
  myPrueba: TPrueba;
  TerminarProceso: Boolean;
  gcForma: TForm;
  dsAcumDetalle,
  dsAcumDetallePer: TDataSource;
  ListaMemoria: TStringList;

  //SAUL
  ExcelM: Variant;
  CoordenadasXY: string;
  CoordIniXY: string;
  ColAcum: Integer;
  RowAcum: Integer;
  ColY: Integer;
  RowX: Integer;
  ColIni: Integer;
  RowIni: Integer;
  OldNOmbre,
  sFechaRevisa: string;
  fechaInicio: TDate;
  Fechatermino: TDate;
  importeNOmina: Extended;
  iIdPersonal: Integer;
  codigoPersonal: string;

  //Para impresion de reportes 08/04/2015 manolo.
  CompReporte: tfrxReport;
  CompDatasetReporte: TfrxDBDataset;
  Reporte: string;
  UsePaginacion: Boolean;
  PBPaginacion: TAdvProgressBar;
  entityName: string;
  codeField: string;

procedure LocalImprimeReporte(cdDatos: TclientDataSet; Grid: TNextDBGrid; ModuloPantalla: String); overload;
procedure LocalImprimeReporte(cdDatos: TclientDataSet; Grid: TcxDBPivotGrid; ModuloPantalla: String); overload;
procedure LocalImprimeReporte(cdDatos: TclientDataSet; Grid: TcxGridDBTableView; ModuloPantalla: String); overload;
procedure LocalImprimeReporte(cdDatos: TclientDataSet; Grid: TDBGrid; ModuloPantalla: String); overload;
procedure LocalImprimeReporte(cdDatos: TclientDataSet; Grid: TcxGridDBCardView; ModuloPantalla: String); overload;

procedure CalcularDatosGeneralesEmpleado(DataSet: TClientDataSet;
  Valores: TValores; Panel_Progress: TPanel = Nil);

procedure CargarExcepcionesConceptosGenerales(IdPersonal: Integer; DataSet: TClientDataSet);

procedure CalcularConceptosNomina(DataSet: TClientDataSet;
  cdConceptoExtra: TClientDataSet; cdSumaConcepto: TClientDataSet;
  Var DataSetBuscar: TClientDataSet; Valores: TValores;
  var memPercepciones: TClientDataSet; var memDeducciones: TClientDataSet;
  var TotalPercepciones: Real; var TotalDeducciones: Real;
  const IdTipoTablaISPT: Integer; const Periodicidad: Word;
  Panel_Progress: TPanel = Nil);

procedure CalcularNominaEmpleado(DataSet, cdPersonalNomina, cdExcepciones,
  cdPersonal, cdConcepto, cdConceptoExtra, cdSumaConcepto, memPercepciones,
  memDeducciones: TClientDataSet; Panel_Progress: TPanel = Nil;
  EliminarConjuntos: Boolean = True;
  Ocultar: Boolean = True; LibroExcel: String = '');

function Reemplazar(Cadena, Buscar, Cambiar: String): String;

procedure GenerarCalculoVirtual(FormaPadre: TForm;
                                Limite: Real;

                                IdOrganizacion: Integer;
                                FactorPrimaDominical,
                                FactorPrimaVacacional,
                                SalMinGenDF,
                                SalMinGenZona,
                                SeguroVidaINFONAVIT: Real;
                                DiasExcentoPrimaVacacional,
                                DiasExcentoAguinaldo,
                                DiasTopeIntegrado: Integer;

                                IdTipoNomina,
                                DiasTrabajados,
                                DiasDescanso: Integer;

                                DiasFestivos: Integer;
                                Domingos: Integer;

                                Jornada: Integer;

                                InicioSemana: String;
                                IdTipoTablaISPT: Integer;
                                Periodicidad: Real;
                                SalarioDiario: Real;
                                SalarioIntegrado: Real;
                                Fechainicio: TDate;
                                FechaTermino: TDate;
                                Antiguedad: Integer;
                                Var memPercepciones: TClientDataSet;
                                Var memDeducciones: TClientDataSet;
                                Var NewSalario: Real;
                                Var NewSalarioIntegrado: Real;
                                Var NewAguinaldo: Real;
                                Var NewVacaciones: Real;
                                Var NewPrimaVacacional: Real;
                                Ocultar: Boolean = True);

procedure EliminarTodosConjuntos;
procedure ProcesarMensajes;
procedure CrearConjuntoDatosProyeccion(var cdNomina: TClientDataSet;
                                       var cdPersonalNomina: TClientDataSet;
                                       var cdPersonal: TClientDataSet;
                                       var cdgcConcepto: TClientDataSet;
                                       var cdConceptoExtra: TClientDataSet;
                                       var cdSumaConcepto: TClientDataSet;
                                       var memPercepciones: TClientDataSet;
                                       var memDeducciones: TClientDataSet;
                                           IdTipoNomina: Integer;
                                           DiasTrabajados: Integer;
                                           DiasDescanso: Integer;
                                           InicioSemana: String;
                                           IdTipoTablaISPT: Integer;
                                           Periodicidad: Real;
                                           AproxSalario: Real;
                                           AproxSalarioIntegrado: Real;
                                           SalMinGenDF: Real;
                                           SalMinGenZona: Real;
                                           DiasVacaciones: Integer;
                                           DiasAguinaldo: Integer;
                                           FactorPrimaDominical: Real;
                                           FactorPrimaVacacional: Real;
                                           DiasExcentoPrimaVacacional: Integer;
                                           DiasExcentoAguinaldo: Integer;
                                           SeguroVidaINFONAVIT: Real;
                                           DiasFestivos: Integer;
                                           Jornada:Integer;
                                           Limite: Real;
                                           SalarioDiario: Real;
                                           SalarioIntegrado: Real;
                                           Fechainicio: TDate;
                                           FechaTermino: TDate);

function DescargarPlantilla(var DatasetPlantilla: TClientDataSet; postFijo: String; Ruta: String): String;


implementation

{ TValores }

Constructor TValores.Create;
begin
  ListaValor := TStringList.Create;
  ListaValor.Clear;
end;

Destructor TValores.Destroy;
begin
  ListaValor.Clear;
  ListaValor.Free;
end;

function TValores.Elemento(Nombre: string): TVarValores;
var
  Indice: Integer;
  Variable: String;
  PasoVar: TVarValores;
begin
  Indice := ListaValor.IndexOf(Nombre);
  if Indice >= 0 then
    Result := TVarValores(ListaValor.Objects[Indice])
  else
  begin
    PasoVar := TVarValores.Create;
    PasoVar.sClase := '';
    PasoVar.sCodigo := Nombre;
    PasoVar.vValor := Nombre;

    Result := PasoVar;
  end;
end;

procedure TValores.SetValue(Nombre: String; Valor: Variant; Datos: String = '');
var
  Indice: Integer;
  Lista: TStringList;

function Formatea(Cadena: String): String;
var
  Cad: String;
  i: Integer;
begin
  Cad := '';
  for i := 1 to Length(Cadena) do
    if Cadena[i] = ' ' then
      Cad := Cad + '_'
    else
      Cad := Cad + Cadena[i];

  Result := Cad;
end;

begin
  if Pos('.', Nombre) < 1 then
    raise Exception.Create('Formato de llave de valor de n�mina es incorrecto, la tabla "nom_concepto" est� corrompida.');

  // Modificar el valor de la variable de memoria especificada
  Indice := ListaValor.IndexOf(Nombre);
  if Indice < 0 then
  begin
    ListaValor.AddObject(Nombre, TVarValores.Create);
    Indice := ListaValor.IndexOf(Nombre);

    cdDetalle.Append;
  end
  else
  begin
    if Not cdDetalle.Locate('IdPersonal', IdPersonal, []) then
      raise InteligentException.CreateByCode(12, [IdPersonal, 'Detalle de N�mina']);
    cdDetalle.Edit;
  end;

  TVarValores(ListaValor.Objects[Indice]).sClase := Copy(Nombre, 1, Pos('.', Nombre) -1);
  TVarValores(ListaValor.Objects[Indice]).sCodigo := Copy(Nombre, Pos('.', Nombre) +1, Length(Nombre));
  TVarValores(ListaValor.Objects[Indice]).vValor := Valor;
  if Datos <> '' then
  begin
    Try
      Lista := TStringList.Create;
      Lista.CommaText := Formatea(Datos);

      if Not Assigned(TVarValores(ListaValor.Objects[Indice]).Formato) then
        TVarValores(ListaValor.Objects[Indice]).Formato := TFormato.Create;

      TVarValores(ListaValor.Objects[Indice]).Formato.CodigoConcepto  := Lista[0];
      TVarValores(ListaValor.Objects[Indice]).Formato.Clave           := Lista[1];
      TVarValores(ListaValor.Objects[Indice]).Formato.Titulo          := Lista[2];
      TVarValores(ListaValor.Objects[Indice]).Formato.Nombre          := Lista[3];
      TVarValores(ListaValor.Objects[Indice]).Formato.Modo            := Lista[4];
      Try
        TVarValores(ListaValor.Objects[Indice]).Formato.IdGrupoConcepto := StrToInt(Lista[5]);
      Except
        TVarValores(ListaValor.Objects[Indice]).Formato.IdGrupoConcepto := -1;
      End;

      // Crear/Actualizar el registro
      if cdDetalle.State = dsInsert then
      begin
        cdDetalle.FieldByName('IdDetalleNomina').AsInteger := 0;
        cdDetalle.FieldByName('IdOrganizacion').AsInteger := IdOrganizacion;
        cdDetalle.FieldByName('IdPersonal').AsInteger := IdPersonal;
        cdDetalle.FieldByName('IdNomina').AsInteger := IdNomina;
        cdDetalle.FieldByName('IdCargo').AsInteger := IdCargo;
        cdDetalle.FieldByName('IdDepartamento').AsInteger := IdDepartamento;
        cdDetalle.FieldByName('IdGrupoConcepto').AsInteger := TVarValores(ListaValor.Objects[Indice]).Formato.IdGrupoConcepto;
        cdDetalle.FieldByName('CodigoConcepto').AsString := Lista[0];
        cdDetalle.FieldByName('Clave').AsString := Lista[1];
        cdDetalle.FieldByName('Titulo').AsString := Lista[2];
        cdDetalle.FieldByName('Descripcion').AsString := Lista[3];
        cdDetalle.FieldByName('Imprime').AsString := Lista[6];
        if (Length(Lista[4]) > 7) and (CompareText(Copy(Lista[4], Length(Lista[4]) - 6, 7), '-PATRON') = 0) then
        begin
          cdDetalle.FieldByName('Modo').AsString := 'IMSS';
          cdDetalle.FieldByName('Cargo').AsString := 'PATRONAL';
        end
        else
        begin
          if (Length(Lista[4]) > 7) and (CompareText(Copy(Lista[4], Length(Lista[4]) - 6, 7), '-OBRERO') = 0) then
          begin
            cdDetalle.FieldByName('Modo').AsString := 'IMSS';
            cdDetalle.FieldByName('Cargo').AsString := 'OBRERO';
          end
          else
          begin
            cdDetalle.FieldByName('Modo').AsString := Lista[4];
            cdDetalle.FieldByName('Cargo').AsString := 'OBRERO';
          end;
        end;
      end;
    Finally
      Lista.Clear;
      Lista.Free;
    End;

    if Valor = Null then
      cdDetalle.FieldByName('Valor').AsString := ''
    else
      cdDetalle.FieldByName('Valor').AsString := String(Valor);

    cdDetalle.Post;
  end;
end;

function TValores.ResetValue(Nombre: String; Valor: Variant): Boolean;
var
  Indice: Integer;
begin
  Result := False;

  // Actualizar los valores si es que este registro ya existe
  if Pos('.', Nombre) < 1 then
    Nombre := 'EMPLEADO.' + Nombre;

  // Modificar el valor de la variable de memoria especificada
  Indice := ListaValor.IndexOf(Nombre);

  // Solo procesar los registros que ya existan
  if Indice >= 0 then
  begin
    Valor := TVarValores(ListaValor.Objects[Indice]).vValor + Valor;
    TVarValores(ListaValor.Objects[Indice]).vValor := Valor;

    Result := True;
  end;
end;

function TValores.IsType(Nombre: String; Tipo: TTipos): Boolean;
begin
  Result := False;


end;

//******************************************************************************
//SETEAR VALOR DE NOMINA
procedure TValores.SetValueNomina(Nombre: String; Valor: Variant);
var
  Indice: Integer;

function Formatea(Cadena: String): String;
var
  Cad: String;
  i: Integer;
begin
  Cad := '';
  for i := 1 to Length(Cadena) do
    if Cadena[i] = ' ' then
      Cad := Cad + '_'
    else
      Cad := Cad + Cadena[i];

  Result := Cad;
end;

begin
  // Modificar el valor de la variable de memoria especificada
  Indice := ListaValor.IndexOf('NOMINA.' + Nombre);
  if Indice < 0 then
    raise InteligentException.CreateByCode(12, [IdPersonal, 'Detalle de N�mina']);

  if Not cdDetalle.Locate('IdPersonal;Clave', VarArrayOf([IdPersonal,Nombre]), []) then
    raise InteligentException.CreateByCode(12, [IdPersonal, 'Detalle de N�mina']);
  cdDetalle.Edit;

  TVarValores(ListaValor.Objects[Indice]).sClase := Copy(Nombre, 1, Pos('.', Nombre) -1);
  TVarValores(ListaValor.Objects[Indice]).sCodigo := Copy(Nombre, Pos('.', Nombre) +1, Length(Nombre));
  TVarValores(ListaValor.Objects[Indice]).vValor := TVarValores(ListaValor.Objects[Indice]).vValor + Valor;

  if Valor = Null then
    cdDetalle.FieldByName('Valor').AsString := ''
  else
  begin
    Valor := StrToFloat(cdDetalle.FieldByName('Valor').AsString) + Valor;
    cdDetalle.FieldByName('Valor').AsString := String(Valor);
  end;

  cdDetalle.Post;
end;
//******************************************************************************

{ TVarValores }

function TVarValores.AsString: String;
begin
  if vValor = Null then
    Result := ''
  else
    Result := vValor;
end;

function TVarValores.AsInteger: Integer;
begin
  if vValor = Null then
    Result := 0
  else
    Try
      Result := vValor;
    Except
      Result := 0;
    End;
end;

function TVarValores.AsFloat: Extended;
begin
  Try
    if vValor = Null then
      Result := 0
    else
      Try
        Result := vValor;
      Except
        Result := 0;
      End;
  Except
    Result := 0;
  End;
end;

function TVarValores.AsDate: TDate;
begin
  if vValor = Null then
    Result := 0
  else
    Try
      Result := Trunc(vValor);
    Except
      Result := 0;
    End;
end;

function TVarValores.AsDateTime: TDateTime;
begin
  if vValor = Null then
    Result := 0
  else
    Try
      Result := vValor;
    Except
      Result := 0;
    End;
end;

function TVarValores.AsVariant: Variant;
begin
  Result := vValor;
end;

{ TListaCambios }

procedure TListaCambios.Add(ARegLog: RegLog);
begin
  FLista.Add(Encode(ARegLog.Campo, ARegLog.ValorAnt, ARegLog.ValorNuevo));
end;

procedure TListaCambios.clear;
begin
  FLista.Clear;
end;

procedure TListaCambios.Add(ACampo, AValorAnt, AValorNuevo: String);
begin
  FLista.Add(Encode(ACampo, AValorAnt, AValorNuevo));
end;

constructor TListaCambios.Create;
begin
  FLista := TStringList.Create;
end;

constructor TListaCambios.Create(AListaCambios: string);
begin
  self.Create;
  FLista.Delimiter := ',';
  FLista.DelimitedText := AListaCambios;
end;

function TListaCambios.DelimitedString: String;
begin
  FLista.Delimiter := ',';
  result := FLista.DelimitedText;
end;

destructor TListaCambios.Destroy;
begin
  FLista.Clear;
  FLista.Free;
end;

function TListaCambios.Encode(ACampo, AValorAnt, AValorNuevo: string): string;
begin
  result := format('%s(''%s''-''%s'')', [ACampo, AValorAnt, AValorNuevo]);
end;

function TListaCambios.GetCount: Integer;
begin
  result := FLista.Count;
end;

function TListaCambios.GetItem(Index: Integer): RegLog;
Var
  tRegLog: RegLog;
  tString: String;
  Pos1,Pos2, Long: Integer;
begin
  tString := FLista[Index];
  // Decodificar la cadena para obtener los valores correspondientes a cada campo
  Long := Length(tString);
  Pos1 := AnsiPos('(''', tString);
  tRegLog.Campo := AnsiLeftStr(tString, Pos1 - 1);
  Pos1 := Pos1 + 2;
  Pos2 := AnsiPos('''-''', tString);
  tRegLog.ValorAnt := AnsiMidStr(tString, Pos1, Pos2 - Pos1);
  Pos1 := Pos2 + 3;
  Pos2 := Long - 1;
  tRegLog.ValorNuevo := AnsiMidStr(tString, Pos1, Pos2 - Pos1);
  Result := tRegLog;
end;

procedure TListaCambios.SetItem(Index: Integer; pRegLog: RegLog);
begin
  if Index < FLista.Count then
    FLista[Index] := Encode(pRegLog.Campo, pRegLog.ValorAnt, pRegLog.ValorNuevo)
end;

procedure CalcularDatosGeneralesEmpleado(DataSet: TClientDataSet;
  Valores: TValores; Panel_Progress: TPanel = Nil);
var
  i: Integer;
  ProcedePanel: Boolean;
  NombreRango: string;
  Valor: string;
begin
  ProcedePanel := False;
  if Assigned(Panel_Progress) and (Panel_Progress.Visible) and (Panel_Progress.ControlCount > 0) then
  begin
    ProcedePanel := True;

    if Panel_Progress.Controls[0].ClassType = TJvLabel then
      TJvLabel(Panel_Progress.Controls[0]).Caption := 'Cargando datos de N�mina...';
  end;

  // Cargar los datos generales del Empleado
  //Try
  for i := 0 to DataSet.FieldDefs.Count -1 do
  begin
    ProcesarMensajes;

    if (ProcedePanel) and (Panel_Progress.Controls[1].ClassType = TJvLabel) then
      TJvLabel(Panel_Progress.Controls[1]).Caption := 'Tomando el Valor: ' + DataSet.FieldDefs.Items[i].Name;

    Valores.SetValue('EMPLEADO.' + DataSet.FieldDefs.Items[i].Name, DataSet.FieldByName(DataSet.FieldDefs.Items[i].Name).AsVariant, DataSet.FieldDefs.Items[i].Name + ',' + DataSet.FieldDefs.Items[i].Name + ',' + DataSet.FieldDefs.Items[i].Name + ',' + DataSet.FieldDefs.Items[i].Name + ',EMPLEADO,Nil,Si');

    //Si el valor Existe, Colocarlo.
    Try
      NombreRango := DataSet.FieldDefs.Items[i].Name;
      ExcelM.Range[NombreRango].Select;

      // Cargar aqu� los valores del rango
      Valor :=  DataSet.FieldByName(DataSet.FieldDefs.Items[i].Name).asString;
      ExcelM.selection.value := Valor;
    Except
      Valor := '';
      ; // No hacer nada, solo para evitar los elementos que no existan
    End;
    if ProcedePanel then
    begin
      if (Panel_Progress.Controls[3].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[3]).Controls[0].ClassType = TcxProgressBar) then
        TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Position := TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Position +1;

      if (Panel_Progress.Controls[4].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[4]).Controls[0].ClassType = TcxProgressBar) then
        TcxProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Position := TcxProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Position +1;

      Panel_Progress.Repaint;
    end;
  end;
  {Except
    Raise;
  End;}
end;

procedure TPrueba.OnClickCancel(Sender: TObject);
begin
  TerminarProceso := True;
end;

procedure CalcularConceptosNomina(DataSet: TClientDataSet;
  cdConceptoExtra: TClientDataSet; cdSumaConcepto: TClientDataSet;
  Var DataSetBuscar: TClientDataSet; Valores: TValores;
  var memPercepciones: TClientDataSet; var memDeducciones: TClientDataSet;
  var TotalPercepciones: Real; var TotalDeducciones: Real;
  const IdTipoTablaISPT: Integer; const Periodicidad: Word;
  Panel_Progress: TPanel = Nil);

var
  ProcedePanel: Boolean;
  NombreRango: string;
  Valor: string;

function DescomponerValores(Analizar: String): Real;
var
  Cadena,
  Nombre,
  CampoValor: String;
  i, m1, m2: Integer;
  NewValor, Valor: Real;
  Signo: TSigno;
  NewDate: TDate;
  Cuenta: Integer;
  Componente: TComponent;
  Conjunto: TClientDataSet;
  cdMinutosNT, cdJornadaAplica: TClientDataset;
  AplicaPimss, AplicaIdCargo, AplicaTNomina: Integer;
  Campo, sFecha: String;
  Anio, Mes, Dia: Word;
  Aplicar,
  IMSSPatron,
  IMSSEmpleado,
  LocNewValor,
  Descontado,
  Maximo,
  Guarderias, Retiro: Real;
  pSalarioIntegrado,
  pSalMinDF: Real;
  pDiasTIMSS: Integer;
  DesgloseImss: String;
  ArchivoTexto: TextFile;
begin
  // Analizar la cadena
  Cadena := '';
  i := 0;
  Valor := 0;
  Campo := '';
  Signo := sgNil;
  if Analizar[1] = '-' then
    Analizar := Copy(Analizar, 2, Length(Analizar));
  while i < Length(Analizar) do
  begin
    Inc(i);

    if Analizar[i] = '{' then
    begin
      Cadena := TrimRight(TrimLeft(Cadena));
      if Cadena <> '' then
      begin
        case Cadena[1] of
          '+': Signo := sgSuma;
          '-': Signo := sgResta;
          '@': Signo := sgInv;
          '*': Signo := sgMult;
          '/': Signo := sgDiv;
          '\': Signo := sgResiduo;
          '=': Signo := sgEQ;
          '#': Signo := sgRango;
          '<': begin
                 if Length(Cadena) > 1 then
                 begin
                   if Cadena[2] = '=' then
                     Signo := sgME;
                   if Cadena[2] = '>' then
                     Signo := sgNE;
                 end
                 else
                   Signo := sgMT;
               end;
          '>': if Length(Cadena) > 1 then
               begin
                 if Cadena[2] = '=' then
                   Signo := sgGE
               end
               else
                 Signo := sgGT;
        end;
      end;

      Cadena := '';
    end;

    if Analizar[i] = '}' then
    begin
      // Verificar si se trata de un resultado o de una variable
      Try
        NewValor := StrToFloat(Cadena);
      Except
        NewValor := 0;

        // Verificar si es un campo de una tabla
        if (Copy(Cadena, 1, 9) = 'TABLAISPT') or (Copy(Cadena, 1, 8) = 'SUBSIDIO') or (Copy(Cadena, 1, 9) = 'TABLAIMSS') then
        begin
          // Buscar en la memoria si existe un objeto con dicho nombre
          Nombre := Copy(Cadena, 1, Pos('.', Cadena) -1);
          Campo := Copy(Cadena, Pos('.', Cadena) +1, Length(Cadena));

          //Componente := Screen.ActiveForm.FindComponent(Nombre);
          Componente := Application.MainForm.FindComponent(Nombre);
          //Componente := Self.FindComponent(Nombre);

          //SAUL TABLAISPT
          if Assigned(Componente) then
          begin
            Conjunto := TClientDataSet(Componente);

            Decodedate(DataSetBuscar.FieldByName('FechaTerminoNomina').AsDateTime, Anio, Mes, Dia);
            sFecha := IntToStr(Anio) + '-' + RightStr('0' + IntToStr(Mes), 2) + '-' + RightStr('0' + IntToStr(Dia), 2);


            if  (((Nombre = 'TABLAISPT') or (Nombre = 'SUBSIDIOISPT')) and (OldNombre <> Nombre)) or (Not Conjunto.Active) or ((Conjunto.Active) and (Conjunto.RecordCount = 0)) or ((Conjunto.Active) and (Conjunto.RecordCount > 0) and (Conjunto.FieldDefs.IndexOf('IdTipoTablaISPT') >= 0) and (Conjunto.FieldByName('IdTipoTablaISPT').AsInteger <> IdTipoTablaISPT) and (CompareText(sFecha, sFechaRevisa) <> 0)) or
                ((Conjunto.Active) and (Conjunto.RecordCount = 0)) or ((Conjunto.Active) and (Conjunto.RecordCount > 0) and (Conjunto.FieldDefs.IndexOf('IdTipoTablaISPT') >= 0) and (Conjunto.FieldByName('IdTipoTablaISPT').AsInteger = IdTipoTablaISPT) and (CompareText(sFecha, sFechaRevisa) <> 0)) then
            begin
              Decodedate(DataSetBuscar.FieldByName('FechaTerminoNomina').AsDateTime, Anio, Mes, Dia);
              sFechaRevisa := IntToStr(Anio) + '-' + RightStr('0' + IntToStr(Mes), 2) + '-' + RightStr('0' + IntToStr(Dia), 2);
              OldNombre := Nombre;

              if Not CargarDatosFiltrados(Conjunto, 'IdTipoTablaISPT,FechaAplicacion', [IdTipoTablaISPT, sFecha]) then
                raise InteligentException.CreateByCode(6, ['datos de la ' + Nombre, IdTipoTablaISPT, 'Tipo de Tabla de ISPT']);

              if Conjunto.Active then
                Conjunto.Refresh
              else
                Conjunto.Open;
            end;
          end
          else
          begin
            // Crear el conjunto de datos
            //Conjunto := TClientDataSet.Create(Screen.ActiveForm);
            Conjunto := TClientDataSet.Create(Application.MainForm);
            Conjunto.Name := Nombre;

            // Cerificar si es necesario crear el conjunto en el servidor
            if Not CrearConjunto(Conjunto, 'nom_' + LowerCase(nombre), ccCatalog) then
              raise InteligentException.CreateByCode(5, ['datos de la ' + Nombre]);

            Decodedate(DataSetBuscar.FieldByName('FechaTerminoNomina').AsDateTime, Anio, Mes, Dia);
            sFecha := IntToStr(Anio) + '-' + RightStr('0' + IntToStr(Mes), 2) + '-' + RightStr('0' + IntToStr(Dia), 2);

            if Copy(Cadena, 1, 9) = 'TABLAIMSS' then
            begin
              if Not CargarDatosFiltrados(Conjunto, 'FechaAplicacion', [sFecha]) then
                raise InteligentException.CreateByCode(6, ['datos de la ' + Nombre, 1, 'Fecha de Aplicaci�n']);
            end
            else
            begin
              Decodedate(DataSetBuscar.FieldByName('FechaTerminoNomina').AsDateTime, Anio, Mes, Dia);
              sFechaRevisa := IntToStr(Anio) + '-' + RightStr('0' + IntToStr(Mes), 2) + '-' + RightStr('0' + IntToStr(Dia), 2);

              if Not CargarDatosFiltrados(Conjunto, 'IdTipoTablaISPT,FechaAplicacion', [IdTipoTablaISPT, sFecha]) then
                raise InteligentException.CreateByCode(6, ['datos de la ' + Nombre, IdTipoTablaISPT, 'Tipo de Tabla de ISPT']);
            end;
            Conjunto.Open;
          end;

          if (Assigned(Conjunto)) and (Not Conjunto.Active) then
            Conjunto.Open;
        end
        else
        begin
          // Verificar si es un campo especial
          if CompareText(Cadena, 'EMPLEADO.DOMINGOS') = 0 then
          begin
            // Contar el n�mero de domingos que caen en este periodo
            NewDate := Trunc(Valores.Elemento('EMPLEADO.FechaInicio').AsDateTime);
            fechaInicio := Trunc(Valores.Elemento('EMPLEADO.FechaInicio').AsDateTime);//para almacenar en la tabla de RH, para historial de sueldos Sa�l
            Fechatermino := Trunc(Valores.Elemento('EMPLEADO.FechaTermino').AsDateTime);//guadar en Rh Historial de sueldos


            Cuenta := 0;
            while NewDate <= Trunc(Valores.Elemento('EMPLEADO.FechaTermino').AsDateTime) do
            begin
              if DayOfTheWeek(NewDate) = 7 then
                Inc(Cuenta);
              NewDate := IncDay(NewDate, 1);
            end;
            NewValor := Cuenta;
          end
          else
          begin
            Nombre := Copy(Cadena, 1, Pos('.', Cadena) -1);
            if CompareText(Nombre, 'EXTRA') = 0 then
            begin
              Campo := Copy(Cadena, Pos('.', Cadena) +1, Length(Cadena));

              // Localizar el concepto extra para este empleado
              Try
                cdConceptoExtra.Filtered := False;
                cdConceptoExtra.Filter := '(IdPersonal = ' + IntToStr(IdPersonal) + ') and (ClaveConcepto = ' + QuotedStr(Campo) + ')';
                cdConceptoExtra.Filtered := True;

                cdConceptoExtra.First;

                // Verificar el acumulado total para saber si se tiene que continuar descontando y cuanto es lo m�ximo
                Descontado := 0;
                if CompareText(cdConceptoExtra.FieldByName('Modo').AsString, 'DEDUCCION') = 0 then
                begin
                  cdSumaConcepto.Close;
                  CargarDatosFiltrados(cdSumaConcepto, 'IdConceptoExtra,IdPersonal,IdNomina', [cdConceptoExtra.FieldByName('IdConceptoExtra').AsInteger, IdPersonal, IdNomina]);
                  cdSumaConcepto.Open;
                  if cdSumaConcepto.RecordCount > 0 then
                  begin
                    Try
                      Descontado := StrToFloat(cdSumaConcepto.FieldByName('Importe').AsString);
                    Except
                      Descontado := 0;
                    End;

                    Try
                      Maximo := StrToFloat(cdSumaConcepto.FieldByName('Maximo').AsString);
                    Except
                      Maximo := 0;
                    End;

                    if Maximo = 0 then
                      Descontado := 0;
                  end;
                end;

                NewValor := 0;
                while Not cdConceptoExtra.Eof do
                begin
                  Try
                    Campo := Copy(cdConceptoExtra.FieldByName('AplicarSobre').AsString, 2, Length(cdConceptoExtra.FieldByName('AplicarSobre').AsString) -2);
                    if CompareText(cdConceptoExtra.FieldByName('Tipo').AsString, 'FIJO') = 0 then
                      LocNewValor := cdConceptoExtra.FieldByName('Cantidad').AsFloat;
                    if CompareText(cdConceptoExtra.FieldByName('Tipo').AsString, 'PORCENTAJE') = 0 then
                      LocNewValor := Valores.Elemento(Campo).AsFloat * (cdConceptoExtra.FieldByName('Cantidad').AsFloat / 100);
                  Except
                    LocNewValor := 0;
                  end;

                  NewValor := NewValor + LocNewValor;

                  cdConceptoExtra.Next;
                end;

                if (CompareText(cdConceptoExtra.FieldByName('Modo').AsString, 'DEDUCCION') = 0) and (Maximo > 0) then
                begin
                  // Verificar si el descuento total es mayor a la cantidad maxima
                  if Descontado + NewValor > Maximo then
                    NewValor := Maximo - Descontado;  // Ajustar la cantidad para cerrar el saldo
                end;

                if NewValor < 0 then
                  NewValor := 0;
              Finally
                cdConceptoExtra.Filtered := False;
              End;
            end
            else
            begin
              // Realizar la modificaci�n para el ajuste en el c�lculo del aguinaldo
//              if CompareText(Cadena, '{365} then

              // Preguntarle al objeto Valores que tipo tiene el elemento "Cadena"
              NewValor := Valores.Elemento(Cadena).AsFloat;
            end;
          end;
        end;
      End;

      // Devolver el valor
      case Signo of
        sgNil: Valor := NewValor;
        sgSuma: Valor := Valor + NewValor;
        sgResta: Valor := Valor - NewValor;
        sgInv: Valor := NewValor * -1;
        sgMult: Valor := Valor * NewValor;
        sgDiv:
        begin
          if NewValor = 0 then
            Valor := Valor
          else
            Valor := Valor / NewValor;
        end;

        sgResiduo:
        begin
          if NewValor = 0 then
            Valor := 0
          else
          begin
            m1 := Trunc(Valor);
            m2 := Trunc(NewValor);
            Valor := m1 Mod m2;
          end;
        end;

        sgMT: begin
                if Valor < NewValor then
                  Valor := 1
                else
                  Valor := -1;
              end;
        sgEQ: begin
                if Valor = NewValor then
                  Valor := 1
                else
                  Valor := -1;
              end;
        sgME: begin
                if Valor <= NewValor then
                  Valor := 1
                else
                  Valor := -1;
              end;
        sgGT: begin
                if Valor > NewValor then
                  Valor := 1
                else
                  Valor := -1;
              end;
        sgGE: begin
                if Valor >= NewValor then
                  Valor := 1
                else
                  Valor := -1;
              end;
        sgNE: begin
                if Valor <> NewValor then
                  Valor := 1
                else
                  Valor := -1;
              end;
        sgRango: begin
                   Conjunto.First;
                   while (not Conjunto.Eof) and (StrToFloat(Conjunto.FieldByName(Campo).AsString) <= Valor) do
                     Conjunto.Next;
                   if Not Conjunto.Eof then
                     Valor := Conjunto.FieldByName(DataSet.FieldByName('Clave').AsString).AsVariant;
                 end;
      end;

      //CALCULO DE JORNADA PERSONAL POR DIA DE SEMANA
      if Cadena = 'SISTEMA.CALCULARJORNADA' then
      BEGIN
        try
          try
            If Valores.Elemento('EMPLEADO.AplicaJornada').AsString = 'PIMSS' then
            begin
              AplicaPimss := Valores.Elemento('EMPLEADO.IdPersonalImss').AsInteger;
              AplicaIdCargo := -1;
              AplicaTNomina := -1;
            end
            else if Valores.Elemento('EMPLEADO.AplicaJornada').AsString = 'CARGO' then
            begin
              AplicaIdCargo := Valores.Elemento('EMPLEADO.IdCargo').AsInteger;
              AplicaPimss := -1;
              AplicaTNomina := -1;
            end
            else
            begin
              AplicaTNomina := Valores.Elemento('EMPLEADO.IdTipoNomina').AsInteger;
              AplicaPimss := -1;
              AplicaIdCargo := -1;
            end;

            if assigned(cdJornadaAplica) then
              cdJornadaAplica.Destroy;

            cdJornadaAplica := TClientDataset.Create(nil);

            if not CrearConjunto(cdJornadaAplica, 'calcular_jornada_personal', ccSelect) then
              raise InteligentException.CreateByCode(5, ['calcular_jornada_personal']);

            if not CargarDatosFiltrados(cdJornadaAplica, 'IdPersonalImss,IdCargo,IdTipoNomina', [AplicaPimss, AplicaIdCargo, AplicaTNomina]) then
              raise InteligentException.CreateByCode(6, ['calcular_jornada_personal', 'IdTipoNomina', inttoStr(IdPersonal)]);

            if cdJornadaAplica.Active then
              cdJornadaAplica.Refresh
            else
             cdJornadaAplica.Open;

            //*Llenar en los valores de la n�mina los valores de la jornada diaria que un trabajador deberia*/
            cdJornadaAplica.First;
            while Not cdJornadaAplica.eof do
            begin
              Valores.SetValue('NOMINA.JOR'+cdJornadaAplica.FieldByName('NombreDiaSemana').AsString, cdJornadaAplica.FieldByName('tmpJornada').AsString , 'JOR'+cdJornadaAplica.FieldByName('NombreDiaSemana').AsString+',Nil,'+'JOR'+cdJornadaAplica.FieldByName('NombreDiaSemana').AsString+','+'JOR'+cdJornadaAplica.FieldByName('NombreDiaSemana').AsString+','+'JOR'+cdJornadaAplica.FieldByName('NombreDiaSemana').AsString+',-1,Si');
              cdJornadaAplica.Next;
            end;
          finally
            if cdJornadaAplica.ProviderName <> '' then
              EliminarConjunto(cdJornadaAplica);
            cdJornadaAplica.Free;
          end;
        Except
          on e: InteligentException do
            inteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOK], 0);
        end;
      END;

      //CALCULO DE MINUTOS NO TRABAJADOS
      if Cadena = 'SISTEMA.CALCMINNT' then
      BEGIN
        try
          try
            if assigned(cdMinutosNt) then
              cdMinutosNT.Destroy;

            cdMinutosNt := TClientDataset.Create(nil);

            if not CrearConjunto(cdMinutosNT, 'calcular_minutos_nt', ccSelect) then
              raise InteligentException.CreateByCode(5, ['calcular_minutos_nt']);

            if not CargarDatosFiltrados(cdMinutosNT, 'pPersonal,FINomina,FTNomina', [IdPersonal, ClientModule1.DatetoStrSql(Valores.Elemento('EMPLEADO.FechaInicio').AsDateTime), ClientModule1.DatetoStrSql(Valores.Elemento('EMPLEADO.FechaTermino').AsDateTime)]) then
              raise InteligentException.CreateByCode(6, ['Calcular_minutos_nt', 'IdPersonal', inttoStr(IdPersonal)]);

            if cdMinutosNT.Active then
              cdMinutosNT.Refresh
            else
             cdMinutosNT.Open;

            //*Llenar en los valores de la n�mina los valores de los minutos nos tranajados por dia de semana*/
            cdMinutosNt.First;
            while Not cdMinutosNT.eof do
            begin
              Valores.SetValue('NOMINA.'+cdMinutosNt.FieldByName('DiaSemana').AsString, cdMinutosnt.FieldByName('MinutosNoTrabajados').AsString , cdMinutosNt.FieldByName('DiaSemana').AsString+',Nil,'+cdMinutosNt.FieldByName('DiaSemana').AsString+','+cdMinutosNt.FieldByName('DiaSemana').AsString+','+cdMinutosNt.FieldByName('DiaSemana').AsString+',-1,Si');
              cdMinutosNt.Next;
            end;
          finally
            if cdMinutosNt.ProviderName <> '' then
              EliminarConjunto(cdMinutosNt);
            cdMinutosNt.Free;
          end;
        Except
          on e: InteligentException do
            inteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOK], 0);
        end;
      END;

      if Cadena = 'TABLAIMSS.CalcularCuota' then
      begin
        {if (ProcedePanel) and (Not Assigned(Componente)) then
        begin
          if (Panel_Progress.Controls[3].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[3]).Controls[0].ClassType = TProgressBar) then
            TProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Max := TProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Max + Conjunto.RecordCount;

          if (Panel_Progress.Controls[4].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[4]).Controls[0].ClassType = TProgressBar) then
            TProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Max := TProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Max + Conjunto.RecordCount;

          Panel_Progress.Repaint;
        end;}

        Conjunto.First;
        IMSSPatron := 0.00;
        IMSSEmpleado := 0.00;
        Guarderias := 0.00;
        Retiro := 0.00;
        DesgloseImss := 'Inicio Calculo de Imss';
        while Not Conjunto.Eof do
        begin
          {if ProcedePanel then
          begin
            if (Panel_Progress.Controls[3].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[3]).Controls[0].ClassType = TProgressBar) then
              TProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Position := TProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Position +1;

            if (Panel_Progress.Controls[4].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[4]).Controls[0].ClassType = TProgressBar) then
              TProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Position := TProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Position +1;

            Panel_Progress.Repaint;
          end;}

          if Conjunto.FieldByName('ExentoSobre').AsString = 'NINGUNO' then
          begin
            DesgloseImss := DesgloseImss + '\n Excento Sobre: ' + Conjunto.FieldByName('ExentoSobre').AsString;

            if Conjunto.FieldByName('AplicarSobre').AsString = 'SMGVDF' then
            begin
              Aplicar := (Valores.Elemento('EMPLEADO.SalMinDF').AsFloat * (Valores.Elemento('EMPLEADO.DIASTIMSS').AsInteger - Valores.Elemento('EMPLEADO.Inasistencias').AsInteger));
              DesgloseImss := DesgloseImss + '\n Aplica sobre [SMGVDF] SalMinDF:' + Valores.Elemento('EMPLEADO.SalMinDF').AsString + ' * D�asTImss: ' + Valores.Elemento('EMPLEADO.DIASTIMSS').AsString + ' - Inasistencias: ' + Valores.Elemento('EMPLEADO.Inasistencias').AsString + ' = ' + FloatToStr(Aplicar);
            end;

            if Conjunto.FieldByName('AplicarSobre').AsString = 'SMGVZ' then
            begin
              Aplicar := (Valores.Elemento('EMPLEADO.SalMinGenZona').AsFloat * (Valores.Elemento('EMPLEADO.DIASTIMSS').AsInteger - Valores.Elemento('EMPLEADO.Inasistencias').AsInteger));
              DesgloseImss := DesgloseImss + #10#13 + 'Aplica sobre [SMGVDF] SalMinGenZona: ' + Valores.Elemento('EMPLEADO.SalMinGenZona').asString + ' * DIASTIMSS:' + Valores.Elemento('EMPLEADO.DIASTIMSS').AsString + ' - Inasistencias: ' + Valores.Elemento('EMPLEADO.Inasistencias').AsString + ' = ' + FloatToStr(Aplicar);
            end;

            if Conjunto.FieldByName('AplicarSobre').AsString = 'SBC' then
            begin
              Aplicar := (Valores.Elemento('EMPLEADO.SalarioIntegrado').AsFloat * (Valores.Elemento('EMPLEADO.DIASTIMSS').AsInteger - Valores.Elemento('EMPLEADO.Inasistencias').AsInteger));
              DesgloseImss := DesgloseImss + #10#13 + 'Aplica sobre [SBC] SalarioIntegrado: ' + Valores.Elemento('EMPLEADO.SalarioIntegrado').AsString + ' * DIASTIMSS:' + Valores.Elemento('EMPLEADO.DIASTIMSS').AsString + ' - Inasistencias:' + Valores.Elemento('EMPLEADO.Inasistencias').AsString + ' = ' + FloatToStr(Aplicar);
            end;

            if Conjunto.FieldByName('AplicarSobre').AsString = 'DIFERENCIA' then
            begin
              Aplicar := 0;
              DesgloseImss := DesgloseImss + #10#13 + 'Aplica sobre [DIFERENCIA]: ' + FloatToStr(Aplicar);
            end;
          end;

          if Conjunto.FieldByName('ExentoSobre').AsString = 'SMGVDF' then
          begin
            DesgloseImss := DesgloseImss + #10#13 + 'Excento Sobre: ' + Conjunto.FieldByName('ExentoSobre').AsString;

            if Conjunto.FieldByName('AplicarSobre').AsString = 'SMGVDF' then
            Begin
              Aplicar := (Valores.Elemento('EMPLEADO.SalMinDF').AsFloat - (Valores.Elemento('EMPLEADO.SalMinDF').AsFloat * Conjunto.FieldByName('CuantoExento').AsInteger)) * (Valores.Elemento('EMPLEADO.DIASTIMSS').AsInteger - Valores.Elemento('EMPLEADO.Inasistencias').AsInteger);
              DesgloseImss := DesgloseImss + #10#13 + 'Aplica sobre [SMGVDF]: (SalMinDF ' + Valores.Elemento('EMPLEADO.SalMinDF').AsString + ' - SalMinDF' + Valores.Elemento('EMPLEADO.SalMinDF').AsString + ' * CuantoExcento' +  Conjunto.FieldByName('CuantoExento').AsString +')) * (DIASTIMSS ' + Valores.Elemento('EMPLEADO.DIASTIMSS').AsString + ' - Inasistencias ' + Valores.Elemento('EMPLEADO.Inasistencias').AsString +') = ' + FloatToStr(Aplicar);
            End;

            if Conjunto.FieldByName('AplicarSobre').AsString = 'SMGVZ' then
            begin
              Aplicar := (Valores.Elemento('EMPLEADO.SalMinGenZona').AsFloat - (Valores.Elemento('EMPLEADO.SalMinDF').AsFloat * Conjunto.FieldByName('CuantoExento').AsInteger)) * (Valores.Elemento('EMPLEADO.DIASTIMSS').AsInteger - Valores.Elemento('EMPLEADO.Inasistencias').AsInteger);
              DesgloseImss := DesgloseImss + #10#13 + 'Aplica sobre [SMGVDF]: (SalMinGenZona ' + Valores.Elemento('EMPLEADO.SalMinGenZona').AsString + ' - (SalMinDF' + Valores.Elemento('EMPLEADO.SalMinDF').AsString  + ' * CuantoExcento ' + Conjunto.FieldByName('CuantoExento').AsString + ')) * ( DIASTIMSS ' + Valores.Elemento('EMPLEADO.DIASTIMSS').AsString + ' - Inasistencias ' + Valores.Elemento('EMPLEADO.Inasistencias').AsString + ') = ' + FloatToStr(Aplicar);
            end;

            if Conjunto.FieldByName('AplicarSobre').AsString = 'SBC' then
            begin
              pSalarioIntegrado := Valores.Elemento('EMPLEADO.SalarioIntegrado').AsFloat;
              pSalMinDF := Valores.Elemento('EMPLEADO.SalMinDF').AsFloat;
              pDiasTIMSS := Valores.Elemento('EMPLEADO.DIASTIMSS').AsInteger;
              Aplicar := (pSalarioIntegrado - (pSalMinDF * Conjunto.FieldByName('CuantoExento').AsInteger)) * (pDiasTIMSS - Valores.Elemento('EMPLEADO.Inasistencias').AsInteger);
              DesgloseImss := DesgloseImss + #10#13 + 'Aplica sobre [SBC]: (SDI ' + FloatToStr(pSalarioIntegrado) + ' - (SalMinDF ' + FloatToStr(pSalMinDF) + ' * CuantoExcento ' + Conjunto.FieldByName('CuantoExento').AsString + ')) * (DiasTIMSS ' + FloatToStr(pDiasTIMSS) + ' - Inasistencias ' + Valores.Elemento('EMPLEADO.Inasistencias').AsString + ') = ' + FloatToStr(Aplicar);
            end;

            if Conjunto.FieldByName('AplicarSobre').AsString = 'DIFERENCIA' then
              Aplicar := 0;
          end;

          if Conjunto.FieldByName('ExentoSobre').AsString = 'SMGVZ' then
          begin
            DesgloseImss := DesgloseImss + #10#13 + 'Excento Sobre: ' + Conjunto.FieldByName('ExentoSobre').AsString;

            if Conjunto.FieldByName('AplicarSobre').AsString = 'SMGVDF' then
            begin
              Aplicar := (Valores.Elemento('EMPLEADO.SalMinDF').AsFloat * (Valores.Elemento('EMPLEADO.DIASTIMSS').AsInteger - Valores.Elemento('EMPLEADO.Inasistencias').AsInteger)) - (Valores.Elemento('EMPLEADO.SalMinGenZona').AsFloat * Conjunto.FieldByName('CuantoExento').AsInteger);
              DesgloseImss := DesgloseImss + #10#13 + 'Aplica sobre [SMGVDF]: (SalMinDF ' + Valores.Elemento('EMPLEADO.SalMinDF').AsString + ' * DIASTIMSS ' + '( ' + Valores.Elemento('EMPLEADO.DIASTIMSS').AsString + ' - Inasistencias ' +Valores.Elemento('EMPLEADO.Inasistencias').AsString + ')) - (SalMinGenZona: ' + Valores.Elemento('EMPLEADO.SalMinGenZona').AsString + ' * CuantoExcento ' + Conjunto.FieldByName('CuantoExento').AsString + ') = ' + FloatToStr(Aplicar);
            end;

            if Conjunto.FieldByName('AplicarSobre').AsString = 'SMGVZ' then
            begin
              Aplicar := (Valores.Elemento('EMPLEADO.SalMinGenZona').AsFloat * (Valores.Elemento('EMPLEADO.DIASTIMSS').AsInteger - Valores.Elemento('EMPLEADO.Inasistencias').AsInteger)) - (Valores.Elemento('EMPLEADO.SalMinGenZona').AsFloat * Conjunto.FieldByName('CuantoExento').AsInteger);
              DesgloseImss := DesgloseImss + #10#13 + 'Aplica sobre [SMGVZ]: (SalMinGenZona ' + Valores.Elemento('EMPLEADO.SalMinGenZona').AsString + ' * (DIASTIMSS ' + Valores.Elemento('EMPLEADO.DIASTIMSS').asString + ' - Inasistencias ' + Valores.Elemento('EMPLEADO.Inasistencias').AsString + ')) - (SalMinGenZona ' + Valores.Elemento('EMPLEADO.SalMinGenZona').AsString + ' * CuantoExcento ' + Conjunto.FieldByName('CuantoExento').AsString + ') = ' + FloatToStr(Aplicar);
            end;

            if Conjunto.FieldByName('AplicarSobre').AsString = 'SBC' then
            begin
              Aplicar := (Valores.Elemento('EMPLEADO.SalarioIntegrado').AsFloat * (Valores.Elemento('EMPLEADO.DIASTIMSS').AsInteger - Valores.Elemento('EMPLEADO.Inasistencias').AsInteger)) - (Valores.Elemento('EMPLEADO.SalMinGenZona').AsFloat * Conjunto.FieldByName('CuantoExento').AsInteger);
              DesgloseImss := DesgloseImss + #10#13 + 'Aplica sobre [SMGVZ]: (SalarioIntegrado ' + Valores.Elemento('EMPLEADO.SalarioIntegrado').AsString + ' * (DIASTIMSS ' + Valores.Elemento('EMPLEADO.DIASTIMSS').asString + ' - Inasistencias ' + Valores.Elemento('EMPLEADO.Inasistencias').asString + ')) - (SalMinGenZona' + Valores.Elemento('EMPLEADO.SalMinGenZona').AsString + ' * CuantoExcento ' + Conjunto.FieldByName('CuantoExento').AsString + ') = ' + FloatToStr(Aplicar);
            end;

            if Conjunto.FieldByName('AplicarSobre').AsString = 'DIFERENCIA' then
              Aplicar := 0;
          end;

          if Aplicar < 0 then
            Aplicar := 0;

          Valores.SetValue('NOMINA.' + Conjunto.FieldByName('CodigoFactor').AsString + '-Patron', Round((Aplicar * (StrToFloat(Conjunto.FieldByName('Patron').AsString) / 100)) * 100) / 100, Conjunto.FieldByName('CodigoFactor').AsString + ',' + Conjunto.FieldByName('CodigoFactor').AsString + ',' + Conjunto.FieldByName('Nombre').AsString + ',' + Conjunto.FieldByName('Nombre').AsString + ',IMSS-PATRON,' + Conjunto.FieldByName('IdGrupoConcepto').AsString + ',Si');
          DesgloseImss := DesgloseImss + #10#13 + 'NOMINA.' + Conjunto.FieldByName('CodigoFactor').AsString + '-Patron' + FloatToStr(Round((Aplicar * (StrToFloat(Conjunto.FieldByName('Patron').AsString) / 100)) * 100) / 100) + ' ' + Conjunto.FieldByName('Nombre').AsString;
          Valores.SetValue('NOMINA.' + Conjunto.FieldByName('CodigoFactor').AsString + '-Obrero', Round((Aplicar * (StrToFloat(Conjunto.FieldByName('Empleado').AsString) / 100)) * 100) / 100, Conjunto.FieldByName('CodigoFactor').AsString + ',' + Conjunto.FieldByName('IdGrupoConcepto').AsString + ',' + Conjunto.FieldByName('Nombre').AsString + ',' + Conjunto.FieldByName('Nombre').AsString + ',IMSS-OBRERO,' + Conjunto.FieldByName('IdGrupoConcepto').AsString + ',Si');
          DesgloseImss := DesgloseImss + #10#13 + 'NOMINA.' + Conjunto.FieldByName('CodigoFactor').AsString + '-Obrero' + FloatToStr(Round((Aplicar * (StrToFloat(Conjunto.FieldByName('Empleado').AsString) / 100)) * 100) / 100) + ' ' + Conjunto.FieldByName('Nombre').AsString;

          if (CompareText(Conjunto.FieldByName('CodigoFactor').AsString, 'GuarderiasyPS') = 0) or (CompareText(Conjunto.FieldByName('CodigoFactor').AsString, 'Retiro') = 0) then
          begin
            if CompareText(Conjunto.FieldByName('CodigoFactor').AsString, 'GuarderiasyPS') = 0 then
            begin
              Guarderias := Guarderias + Valores.Elemento('NOMINA.' + Conjunto.FieldByName('Codigofactor').AsString + '-Patron').AsFloat;
              DesgloseImss := DesgloseImss + #10#13 + 'GuarderiasPatron = ' + FloatToStr(Guarderias);
            end
            else
            begin
              Retiro := Retiro + Valores.Elemento('NOMINA.' + Conjunto.FieldByName('Codigofactor').AsString + '-Patron').AsFloat;
              DesgloseImss := DesgloseImss + #10#13 + 'RetiroPatron  = ' + FloatToStr(Retiro);
            end;
          end
          else
          begin
            IMSSPatron := IMSSPatron + Valores.Elemento('NOMINA.' + Conjunto.FieldByName('Codigofactor').AsString + '-Patron').AsFloat;       //Round((Aplicar * (StrToFloat(Conjunto.FieldByName('Patron').AsString) / 100)) * 100) / 100;
            DesgloseImss := DesgloseImss + #10#13 + ' IMSSPATRON ' +  FloatToStr(IMSSPatron);
            IMSSEmpleado := IMSSEmpleado + Valores.Elemento('NOMINA.' + Conjunto.FieldByName('Codigofactor').AsString + '-Obrero').AsFloat;   //Round((Aplicar * (StrToFloat(Conjunto.FieldByName('Empleado').AsString) / 100)) * 100) / 100;
            DesgloseImss := DesgloseImss + #10#13 + ' IMSSEMPLEADO ' + FloatToStr(IMSSEmpleado);
          end;

          Conjunto.Next;
        end;
        DesgloseImss := DesgloseImss + #10#13 + 'Finalizando Calculo';
        Valores.SetValue('NOMINA.CUOTAIMSS-Patron', IMSSPatron, 'CUOTAIMSS-Patron,Nil,CUOTAIMSS-Patron,CUOTAIMSS-Patron,CUOTAIMSS-Patron,-1,Si');
        Valores.SetValue('NOMINA.CUOTAIMSS-Obrero', IMSSEmpleado, 'CUOTAIMSS-Obrero,Nil,CUOTAIMSS-Obrero,CUOTAIMSS-Obrero,CUOTAIMSS-Obrero,-1,Si');

        Valores.SetValue('NOMINA.GuarderiasyPS', Guarderias, 'GuarderiasyPS-Patron,Nil,GuarderiasyPS-Patron,GuarderiasyPS-Patron,GuarderiasyPS-Patron,-1,Si');
        DesgloseImss := DesgloseImss + #10#13 + FloatToStr(ImssPatron);
        DesgloseImss := DesgloseImss + #10#13 + FloatToStr(ImssEmpleado);
        DesgloseImss := DesgloseImss + #10#13 + FloatToStr(Guarderias);

        AssignFile(archivoTexto, 'CalculoImss.txt');
        try
          Rewrite(archivoTexto);
          Writeln(archivoTexto, DesgloseImss);
        finally
          Closefile(archivoTexto);
        end;

      end;

      Campo := Cadena;

      Cadena := '';
    end;

    if (Analizar[i] <> '{') and (Analizar[i] <> '}') then
      Cadena := Cadena + Analizar[i];
  end;

  Result := Valor;
end;

function AnalizaFormula(CadenaFormula: String): Real;
var
  i, iSub, Bi, APar, Ai, Par, CtaComa: Integer;
  Cadena, Analizar, Sub, Opcion: String;
  Resultado, RealPaso: Real;
  Multiplo: Int64;
  Truncar: Boolean;
  IdPersonal: Integer;
  ClaveConcepto,
  CadPaso: String;
  FechaInicio,
  FechaTermino: TDate;
  TipoCalculo, EsPTU: String;
  IdTipoNomina: Integer;
  Cond2, Cond3, Negativo,
  SaveMem: Boolean;
  LocListaMemoria: TListaMemoria;
  OrCadena: String;
begin
  // Verificar si se tienen datos de decimales
  Truncar := False;
  if (Pos(',', CadenaFormula) > 0) and (CadenaFormula[1] = '(') and (CadenaFormula[Length(CadenaFormula)] = ')') then
  begin
    CadenaFormula := Copy(CadenaFormula, 2, Length(CadenaFormula) -2);
    Sub := Copy(CadenaFormula, Pos(',', CadenaFormula) +1, Length(CadenaFormula));
    CadenaFormula := Copy(CadenaFormula, 1, Pos(',', CadenaFormula) -1);
    Try
      iSub := StrToInt(Sub);
      Truncar := iSub < 0;
      if Truncar then
        iSub := Abs(iSub);

      if iSub > 16 then
        iSub := 16;
    Except
      iSub := 2;
    End;

    Multiplo := 1;
    for i := 1 to iSub do
      Multiplo := Multiplo * 10;
  end
  else
    Multiplo := 100;

  CadenaFormula := '(' + CadenaFormula + ')';

  // Verificar los conjuntos de parentesis
  Par := 0;
  for i := 1 to Length(CadenaFormula) do
    case CadenaFormula[i] of
      '(': Inc(Par);
      ')': Dec(Par);
    end;

  if Par = 0 then
  begin
    // Localizar el parentesis m�s interno
    Cadena := CadenaFormula;

    Repeat
      i := 0;
      Par := 0;
      APar := 0;
      Bi := 0;
      while i < Length(Cadena) do
      begin
        Inc(i);

        if Cadena[i] = '(' then
        begin
          Inc(Par);
          if Par > APar then
            Bi := i;
        end;

        if Cadena[i] = ')' then
        begin
          // Si se cierra un parentesis se deber� guardar el n�mero m�ximo al cual se lleg� siempre y cuando sea superior al �ltimo localizado
          if Par > APar then
          begin
            APar := Par;
            Ai := i;
          end;

          Dec(Par);
        end;
      end;

      // Verificar si el parentesis corresponde a una condici�n
      if (bi > 3) and ((CompareText(Copy(Cadena, bi - 2, 2), 'SI') = 0)) and (Pos(',', Cadena) > 0) then
      begin
        // Realizar la condici�n para seleccionar la cadena que se va a procesar
        Opcion := Copy(Cadena, bi + 1, ai - bi - 1);
        Opcion := Copy(Opcion, 1, Pos(',', Opcion) - 1);
        Resultado := DescomponerValores(Opcion);
        if Resultado > 0 then
        begin
          // Obtener la formular para el caso de TRUE
          Analizar := Copy(Cadena, bi +1, ai - bi - 1);
          Analizar := Copy(Analizar, Pos(',', Analizar) +1, Length(Analizar));
          Analizar := Copy(Analizar, 1, Pos(',', Analizar) -1);
        end
        else
        begin
          // Obtener la formula para el caso de FALSE
          Analizar := Copy(Cadena, bi +1, ai - bi - 1);
          Analizar := Copy(Analizar, Pos(',', Analizar) +1, Length(Analizar));
          Analizar := Copy(Analizar, Pos(',', Analizar) +1, Length(Analizar));
        end;
      end
      else
      begin
        // Verificar si el parentesis corresponde a un acumulado del detalle
        //Cond1 := (bi > 12);
        Cond2 := (((bi > 12) and (CompareText(Copy(Cadena, bi - 11, 11), 'ACUMDETALLE') = 0)) or ((bi > 15) and ((CompareText(Copy(Cadena, bi - 14, 14), 'ACUMDETALLEPER') = 0) or (CompareText(Copy(Cadena, bi - 14, 14), 'ACUMDETALLEPTU') = 0) or (CompareText(Copy(Cadena, bi - 17, 17), 'ACUMDETALLEPTUMEM') = 0))));
        Cond3 := (Pos(',', Cadena) > 0);

        if {Cond1 and} Cond2 and Cond3 then

        //if (bi > 12) and ((CompareText(Copy(Cadena, bi - 11, 11), 'ACUMDETALLE') = 0)) and (Pos(',', Cadena) > 0) then
        begin
          // Contar el n�mero de comas en la cadena
          CtaComa := 0;
          for i := 1 to Length(Cadena) do
            if Cadena[i] = ',' then
              Inc(CtaComa);

          if CtaComa = 4 then
          begin
            TipoCalculo := '-1';
            IdTipoNomina := -1;
            OrCadena := Cadena;
            SaveMem := False;

            // Verificar si el concepto es un concepto de memoria y este ya fue registrado
            if ListaMemoria.IndexOf(Cadena) < 0 then
            begin
              // Verificar si se debe registrar en memoria este resultado
              if CompareText(Copy(Cadena, bi - 17, 17), 'ACUMDETALLEPTUMEM') = 0 then
              begin
                SaveMem := True;
                Cadena := Copy(Cadena, 1, bi -4) + Copy(Cadena, bi, Length(Cadena));
                Dec(Bi, 3);
              end;

              if (CompareText(Copy(Cadena, bi - 14, 14), 'ACUMDETALLEPER') = 0) or (CompareText(Copy(Cadena, bi - 14, 14), 'ACUMDETALLEPTU') = 0) or (CompareText(Copy(Cadena, bi - 14, 14), 'ACUMDETALLEPTUMEM') = 0) then
                TipoCalculo := 'PERIODICA';

              if CompareText(Copy(Cadena, bi - 14, 14), 'ACUMDETALLEPTU') = 0 then
                EsPTU := 'PTU'
              else
                EsPTU := '-1';

              // Verificar si ya existe el dataset para las totalizaciones
              if Not Assigned(dsAcumDetalle) then
                dsAcumDetalle := TDataSource.Create(Application.MainForm);

              if Not Assigned(dsAcumDetalle.DataSet) then
                dsAcumDetalle.DataSet := TClientDataSet.Create(Application.MainForm);

              if TClientDataSet(dsAcumDetalle.DataSet).ProviderName = '' then
                CrearConjunto(TClientDataSet(dsAcumDetalle.DataSet), 'nom_nomina_totaliza', ccSelect);

              // Verificar si permite negativos
              Negativo := False;
              if Copy(Cadena,1,3) = '(-(' then
              begin
                Cadena := Copy(Cadena,4,Length(Cadena));
                Cadena := '(' + Copy(Cadena,1,Length(Cadena) -2) + ')';
                Negativo := True;
              end;

              // Descomponer la cadena para obtener los parametros para el dataset
              if TipoCalculo = '-1' then
                Cadena := Copy(Cadena, 13, Length(Cadena))
              else
                Cadena := Copy(Cadena, 16, Length(Cadena));

              Cadena := Copy(Cadena, 1, Length(Cadena) -1);
              while Cadena[1] = '(' do
                Cadena := Copy(Cadena, 2, Length(Cadena) -2);

              // Obtener el tipo de n�mina que se desea procesar
              Sub := TrimLeft(TrimRight(Copy(Cadena, 1, Pos(',', Cadena) -1)));
              while Sub[1] = '{' do
                Sub := Copy(Sub, 2, Length(Sub) -2);

              Cadena := TrimLeft(TrimRight(Copy(Cadena, Pos(',', Cadena) +1, Length(Cadena))));
              while Cadena[1] = '(' do
                Cadena := Copy(Cadena, 2, Length(Cadena) -2);

              IdTipoNomina := Valores.Elemento(Sub).AsInteger;

              // Obtener el Id del empleado que se va a acumular
              Sub := TrimLeft(TrimRight(Copy(Cadena, 1, Pos(',', Cadena) -1)));
              while Sub[1] = '{' do
                Sub := Copy(Sub, 2, Length(Sub) -2);

              Cadena := TrimLeft(TrimRight(Copy(Cadena, Pos(',', Cadena) +1, Length(Cadena))));
              while Cadena[1] = '(' do
                Cadena := Copy(Cadena, 2, Length(Cadena) -2);

              IdPersonal := Valores.Elemento(Sub).AsInteger;

              // Obtener el rubro que se va a acumular
              Sub := TrimLeft(TrimRight(Copy(Cadena, 1, Pos(',', Cadena) -1)));
              while Sub[1] = '{' do
                Sub := Copy(Sub, 2, Length(Sub) -2);

              Cadena := TrimLeft(TrimRight(Copy(Cadena, Pos(',', Cadena) +1, Length(Cadena))));
              while Cadena[1] = '(' do
                Cadena := Copy(Cadena, 2, Length(Cadena) -2);

              ClaveConcepto := Copy(Sub, Pos('.', Sub) +1, Length(Sub));

              // Obtener fecha de inicio
              Sub := TrimLeft(TrimRight(Copy(Cadena, 1, Pos(',', Cadena) -1)));
              while Sub[1] = '{' do
                Sub := Copy(Sub, 2, Length(Sub) -2);

              Cadena := TrimLeft(TrimRight(Copy(Cadena, Pos(',', Cadena) +1, Length(Cadena))));
              while Cadena[1] = '(' do
                Cadena := Copy(Cadena, 2, Length(Cadena) -2);

              FechaInicio := Valores.Elemento(Sub).AsDate;

              // Obtener fecha de termino
              while Cadena[1] = '{' do
                Cadena := Copy(Cadena, 2, Length(Cadena) -2);

              Cadena := TrimLeft(TrimRight(Copy(Cadena, Pos(',', Cadena) +1, Length(Cadena))));
              while Cadena[1] = '(' do
                Cadena := Copy(Cadena, 2, Length(Cadena) -2);

              FechaTermino := Valores.Elemento(Cadena).AsDate;

              // Obtener los valores acumulados
              CargarDatosFiltrados(TClientDataSet(dsAcumDetalle.DataSet), 'EsPTU,IdTipoNomina,TipoCalculo,IdPersonal,Clave,FechaInicio,FechaTermino, Anio', [EsPtu, IdTipoNomina, TipoCalculo, IdPersonal, ClaveConcepto, ClientModule1.DateToStrSQL(FechaInicio), ClientModule1.DatetoStrSql(FechaTermino), YEAROF(FechaTermino)]);
              if dsAcumDetalle.DataSet.Active then
                dsAcumDetalle.DataSet.Refresh
              else
                dsAcumDetalle.DataSet.Open;

              Cadena := '{' + dsAcumDetalle.DataSet.FieldByName('Importe').AsString + '}';
            end
            else
              Cadena := '{' + TListaMemoria(ListaMemoria.Objects[ListaMemoria.IndexOf(Cadena)]).Valor + '}';

            if SaveMem then
            begin
              // Si es un concepto de memoria se deber� registrar en la lista
              LocListaMemoria := TListaMemoria.Create;
              LocListamemoria.Valor := dsAcumDetalle.DataSet.FieldByName('Importe').AsString;

              ListaMemoria.AddObject(OrCadena, LocListamemoria);
            end;

            Bi :=1;

            if Negativo then
              Analizar := '-(' + Cadena + ')'
            else
              Analizar := Cadena;

          end;
        end
        else
        begin
          // Verificar si el parentesis corresponde a una funci�n
          // ENTERO, DECIMAL
          if ((bi > 7) and ((CompareText(Copy(Cadena, bi - 6, 6), 'ENTERO') = 0))) or ((bi > 8) and ((CompareText(Copy(Cadena, bi - 7, 7), 'DECIMAL') = 0))) then
          begin
            CadPaso := Copy(Cadena, bi - 6, 6);

            case IndexStr(CadPaso, ListaFunciones) of
              0: begin
                   // Obtener el valor de los enteros
                   CadPaso := Copy(Cadena, bi, (ai +1) - bi);
                   RealPaso := DescomponerValores(CadPaso);
                   RealPaso := Int(RealPaso);
                   CadPaso := FloatToStr(RealPaso);
                   Cadena := Copy(Cadena, 1, bi -7) + '{' + CadPaso + '}' + Copy(Cadena, ai +1, Length(Cadena));
                   Analizar := Cadena;
                   bi := 1;
                   ai := Length(Cadena);
                 end;
              1: begin
                   // Obtener el valor de los decimales
                   CadPaso := Copy(Cadena, bi, (ai +1) - bi);
                   RealPaso := DescomponerValores(CadPaso);
                   RealPaso := (RealPaso - Int(RealPaso)) + 0.00001;   // Ni modos, tuve que ponerle esta pinche pastilla para que funcione
                   RealPaso := Trunc(RealPaso * Multiplo) / Multiplo;
                   CadPaso := FloatToStr(RealPaso);
                   Cadena := Copy(Cadena, 1, bi -8) + '{' + CadPaso + '}' + Copy(Cadena, ai +1, Length(Cadena));
                   Analizar := Cadena;
                   bi := 1;
                   ai := Length(Cadena);
                 end;
            end;
          end
          else
            Analizar := Copy(Cadena, bi + 1, ai - bi - 1);
        end;
      end;

      if Analizar <> '' then
      begin
        // Descomponer los valores de esta parte
        Resultado := DescomponerValores(Analizar);
        if (Analizar[1] <> '@') then
        begin
          if(Resultado < 0) and (Cadena[1] <> '-') and (Cadena[2] <> '-') then
            Resultado := 0;
        end
        else
          Resultado := Resultado;
      end
      else
        Resultado := 0;

        if Cadena[1] = '(' then
          Cadena := Copy(Cadena, 1, Bi - 1) + '{' + FloatToStr(Resultado) + '}' + Copy(Cadena, Ai + 1, Length(Cadena))
        else
          Cadena := Copy(Cadena, 1, Bi - 1) + '{' + FloatToStr(Trunc(Resultado * Multiplo) / Multiplo) + '}' + Copy(Cadena, Ai + 1, Length(Cadena));
    Until Cadena[1] <> '(';

    // Ajustar el redondeo tipo Excel
    if Resultado <> Trunc(Resultado) then
    begin
      if Resultado > 0 then
      begin
        if Truncar then
          Result := Trunc(Resultado * Multiplo) / Multiplo
        else
          Result := Round(Resultado * Multiplo) / Multiplo
        //Result := Round((Resultado + (1 / (Multiplo * 10))) * Multiplo) / Multiplo
      end
      else
        if Resultado < 0 then
          if Truncar then
            Result := Trunc(Resultado * Multiplo) / Multiplo
          else
            Result := Round(Resultado * Multiplo) / Multiplo;
          //Result := Round((Resultado + (-1 / (Multiplo * 10))) * Multiplo) / Multiplo;
    end
    else
      Result := Resultado;
  end
  else
    Result := -1; // Indicar que no coinsiden los parentesis
end;

begin
  DataSet.First;
  memPercepciones.EmptyDataSet;
  memDeducciones.EmptyDataSet;

  ProcedePanel := False;
  if Assigned(Panel_Progress) and (Panel_Progress.Visible) and (Panel_Progress.ControlCount > 0) then
  begin
    ProcedePanel := True;
    TJvLabel(Panel_Progress.Controls[0]).Caption := 'Calculando valores de N�mina';
  end;

  // Localizar los registros de los conceptos extra
  if cdConceptoExtra.ProviderName <> '' then
  begin
    cdConceptoExtra.Close;
    CargarDatosFiltrados(cdConceptoExtra, 'IdPersonal,IdNomina', [IdPersonal, IdNomina]);
    cdConceptoExtra.Open;
  end;

  TotalPercepciones := 0;
  TotalDeducciones := 0;

  Try
  while not DataSet.Eof do
  begin
    ProcesarMensajes;

    if (ProcedePanel) and (Panel_Progress.Controls[1].ClassType = TJvLabel) then
      TJvLabel(Panel_Progress.Controls[1]).Caption := '(' + DataSet.FieldByName('Clave').AsString + ')  - ' + DataSet.FieldByName('Titulo').AsString;

    if (ProcedePanel) and (Panel_Progress.Controls[2].ClassType = TJvLabel) then
      TJvLabel(Panel_Progress.Controls[2]).Caption := DataSet.FieldByName('Nombre').AsString;

    Valores.SetValue('NOMINA.' + DataSet.FieldByName('Clave').AsString, AnalizaFormula(DataSet.FieldByName('Cadena').AsString), DataSet.FieldByName('CodigoConcepto').AsString + ',' + DataSet.FieldByName('Clave').AsString + ',' + DataSet.FieldByName('Titulo').AsString + ',' + DataSet.FieldByName('Nombre').AsString + ',' + DataSet.FieldByName('Modo').AsString + ',' + DataSet.FieldByName('IdGrupoConcepto').AsString + ',' + DataSet.FieldByName('Imprime').AsString);

    try
      NombreRango := DataSet.FieldByName('Clave').AsString;
      ExcelM.Range[NombreRango].Select;
      Valor := Valores.Elemento('NOMINA.' + DataSet.FieldByName('Clave').AsString).AsString;
      ExcelM.Selection.Value := Valor;
    except
      Valor := '';
      ;
    end;
// Aqu� vas Rangel
{    cdAjusteNomina := TClientDataSet.Create(nil);
    if cdAjusteNomina.ProviderName = '' then
    begin
      //ajustes a la nomina
      if Not CrearConjunto(cdajusteNomina, 'nom_ajustenomina', ccCatalog) then
        raise InteligentException.CreateByCode(5, ['Ajuste N�mina']);
    end;

    if not CargarDatosFiltrados(cdajusteNomina, 'IdNomina,IdPersonal,Clave', [IdNomina, IdPersonal, DataSet.FieldByName('Clave').AsString]) then
      raise InteligentException.CreateByCode(6, ['Ajustes N�mina','IdNomina, IdPersonal','*' ]);

    if cdajusteNomina.Active then
      cdajusteNomina.Refresh
    else
      cdajusteNomina.Open;
}
    //Valores.Elemento(DataSet.FieldByName('Clave').AsString).AsString;
    Try
      cdAjusteNomina.Filtered := False;
      cdAjusteNomina.Filter := 'IdPersonal = ' + IntToStr(IdPersonal) + ' and Clave = ' + QuotedStr(DataSet.FieldByName('Clave').AsString);
      cdAjusteNomina.Filtered := True;
      cdAjusteNomina.First;

      if cdAjusteNomina.RecordCount > 0 then
      begin
        Valores.SetValueNomina(DataSet.FieldByName('Clave').AsString, cdAjusteNomina.FieldByName('Valor').AsExtended);

        // Verificar si es un concepto que se deba modificar en segundo rubro
        if CompareText(DataSet.FieldByName('Clave').AsString, 'ISPT') = 0 then
          Valores.SetValueNomina('ISPTAS', cdAjusteNomina.FieldByName('Valor').AsExtended);

        if CompareText(DataSet.FieldByName('Clave').AsString, 'ISPTAS') = 0 then
          Valores.SetValueNomina('ISPT', cdAjusteNomina.FieldByName('Valor').AsExtended);

        if CompareText(DataSet.FieldByName('Clave').AsString, 'IMMSEmpleado') = 0 then
          Valores.SetValueNomina('EyMCA', cdAjusteNomina.FieldByName('Valor').AsExtended);

        if CompareText(DataSet.FieldByName('Clave').AsString, 'EyMCA') = 0 then
          Valores.SetValueNomina('IMMSEmpleado', cdAjusteNomina.FieldByName('Valor').AsExtended);
      end;
    Finally
      cdAjusteNomina.Filtered := False;
    end;

    if (DataSet.FieldByName('Modo').AsString = 'PERCEPCION') or (DataSet.FieldByName('Modo').AsString = 'PER-MEMORIA') then
    begin
      if (DataSet.FieldByName('Imprime').AsString = 'Si') or ((DataSet.FieldByName('Imprime').AsString <> 'Si') and (DataSet.FieldByName('Modo').AsString = 'PERCEPCION')) or ((DataSet.FieldByName('Imprime').AsString = 'Datos') and (Valores.Elemento('NOMINA.' + DataSet.FieldByName('Clave').AsString).AsFloat <> 0)) then
      begin
        memPercepciones.Append;
        memPercepciones.FieldByName('IdPersonal').AsInteger := IdPersonal;
        memPercepciones.FieldByName('CodigoConcepto').AsString := DataSet.FieldByName('CodigoConcepto').AsString;
        memPercepciones.FieldByName('Titulo').AsString := DataSet.FieldByName('Titulo').AsString;
        memPercepciones.FieldByName('Nombre').AsString := DataSet.FieldByName('Nombre').AsString;
        memPercepciones.FieldByName('Modo').AsString := DataSet.FieldByName('Modo').AsString;
        memPercepciones.FieldByName('Importe').AsString := Valores.Elemento('NOMINA.' + DataSet.FieldByName('Clave').AsString).AsString;
        memPercepciones.Post;
      end;

      if (DataSet.FieldByName('Modo').AsString = 'PERCEPCION') then
        TotalPercepciones := TotalPercepciones + Valores.Elemento('NOMINA.' + DataSet.FieldByName('Clave').AsString).AsFloat;
    end;

    if (DataSet.FieldByName('Modo').AsString = 'DEDUCCION') or (DataSet.FieldByName('Modo').AsString = 'DED-MEMORIA') then
    begin
      if (DataSet.FieldByName('Imprime').AsString = 'Si') or ((DataSet.FieldByName('Imprime').AsString <> 'Si') and (DataSet.FieldByName('Modo').AsString = 'DEDUCCION')) or ((DataSet.FieldByName('Imprime').AsString = 'Datos') and (Valores.Elemento('NOMINA.' + DataSet.FieldByName('Clave').AsString).AsFloat <> 0)) then
      //if DataSet.FieldByName('Imprime').AsString = 'Si' then
      begin
        memDeducciones.Append;
        memDeducciones.FieldByName('IdPersonal').AsInteger := IdPersonal;
        memDeducciones.FieldByName('CodigoConcepto').AsString := DataSet.FieldByName('CodigoConcepto').AsString;
        memDeducciones.FieldByName('Titulo').AsString := DataSet.FieldByName('Titulo').AsString;
        memDeducciones.FieldByName('Nombre').AsString := DataSet.FieldByName('Nombre').AsString;
        memDeducciones.FieldByName('Modo').AsString := DataSet.FieldByName('Modo').AsString;
        memDeducciones.FieldByName('Importe').AsString := Valores.Elemento('NOMINA.' + DataSet.FieldByName('Clave').AsString).AsString;
        memDeducciones.Post;
      end;

      if (DataSet.FieldByName('Modo').AsString = 'DEDUCCION') then
        TotalDeducciones := TotalDeducciones + Valores.Elemento('NOMINA.' + DataSet.FieldByName('Clave').AsString).AsFloat;
    end;

    DataSet.Next;

    if ProcedePanel then
    begin
      if (Panel_Progress.Controls[3].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[3]).Controls[0].ClassType = TcxProgressBar) then
        TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Position := TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Position +1;

      if (Panel_Progress.Controls[4].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[4]).Controls[0].ClassType = TcxProgressBar) then
        TcxProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Position := TcxProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Position +1;

      Panel_Progress.Repaint;
    end;
  end;
  Except
    raise;
  end;

  // Registrar los totales de las percepciones y deducciones
  Valores.SetValue('NOMINA.TOTPER', TotalPercepciones, 'TOTPER,TOTPER,TOTAL PERCEPCIONES,TOTAL DE PERCEPCIONES,PER-MEMORIA,,No');
  memPercepciones.Append;
  memPercepciones.FieldByName('IdPersonal').AsInteger := IdPersonal;
  memPercepciones.FieldByName('CodigoConcepto').AsString := 'TOTPER';
  memPercepciones.FieldByName('Titulo').AsString := 'TOTAL PERCEPCIONES';
  memPercepciones.FieldByName('Nombre').AsString := 'TOTAL DE PERCEPCIONES';
  memPercepciones.FieldByName('Modo').AsString := 'PER-MEMORIA';
  memPercepciones.FieldByName('Importe').AsString := FloatToStr(TotalPercepciones);
  try
    NombreRango := 'TOTPER';
    ExcelM.Range[NombreRango].Select;
    Valor := memPercepciones.FieldByName('Importe').AsString;
    ExcelM.Selection.Value := Valor;
  except
    Valor := '';
    ;
  end;
  memPercepciones.Post;

  Valores.SetValue('NOMINA.TOTDED', TotalDeducciones, 'TOTDED,TOTDED,TOTAL DEDUCCIONES,TOTAL DE DEDUCCIONES,DED-MEMORIA,,No');
  memDeducciones.Append;
  memDeducciones.FieldByName('IdPersonal').AsInteger := IdPersonal;
  memDeducciones.FieldByName('CodigoConcepto').AsString := 'TOTDED';
  memDeducciones.FieldByName('Titulo').AsString := 'TOTAL DEDUCCIONES';
  memDeducciones.FieldByName('Nombre').AsString := 'TOTAL DE DEDUCCIONES';
  memDeducciones.FieldByName('Modo').AsString := 'DED-MEMORIA';
  memDeducciones.FieldByName('Importe').AsString := FloatToStr(TotalDeducciones);
  try
    NombreRango := 'TOTDED';
    ExcelM.Range[NombreRango].Select;
    Valor := memDeducciones.FieldByName('Importe').AsString;
    ExcelM.Selection.Value := Valor;
  except
    Valor := '';
    ;
  end;
  memDeducciones.Post;

  Valores.SetValue('NOMINA.NETO', TotalPercepciones - TotalDeducciones, 'NETO,NETO,NETO,NETO,MEMORIA,,No');
  memDeducciones.Append;
  memDeducciones.FieldByName('IdPersonal').AsInteger := IdPersonal;
  memDeducciones.FieldByName('CodigoConcepto').AsString := 'NETO';
  memDeducciones.FieldByName('Titulo').AsString := 'NETO';
  memDeducciones.FieldByName('Nombre').AsString := 'NETO';
  memDeducciones.FieldByName('Modo').AsString := 'MEMORIA';
  memDeducciones.FieldByName('Importe').AsString := FloatToStr(TotalPercepciones - TotalDeducciones);
  importeNOmina := (TotalPercepciones - TotalDeducciones);
  try
    NombreRango := 'NETO';
    ExcelM.Range[NombreRango].Select;
    Valor := VarToStr(importeNOmina);
    ExcelM.Selection.Value := Valor;
  except
    Valor := '';
    ;
  end;
  memDeducciones.Post;
end;

procedure CalcularNominaEmpleado(DataSet, cdPersonalNomina, cdExcepciones,
  cdPersonal, cdConcepto, cdConceptoExtra, cdSumaConcepto, memPercepciones,
  memDeducciones: TClientDataSet; Panel_Progress: TPanel = Nil;
  EliminarConjuntos: Boolean = True;
  Ocultar: Boolean = True; LibroExcel: String = '');
var
  Cursor: TCursor;
  GenLabel: TLabel;
  i, j: Integer;
  Lista: TStringList;
  Acceso: TClientDataSet;
  TotalPercepciones,
  TotalDeducciones, Valor: Real;
  Fecha, FechaTermino: TDate;
  Anio, Semanas, Mes, TerminoSemana: Word;
  NumDias: TStringList;
  PadreOriginal: TWinControl;
  parametros: TParamFilter;
  dsueldo: String;
  cdPlantilla: TClientDataSet;
  RutaArchivo: string;
  Modo: string;
  ModoInsercion: string;
  TieneValor: Boolean;
  ListaTamCol: TStringList;

begin
  Cursor := Screen.Cursor;

  Try
    Screen.Cursor := crAppStart;

    cdDetalle.Open;
    cdDetalle.EmptyDataSet;

    // Crear la lista de los conceptos de n�mina


    Valores := TValores.Create;

  Finally
    Screen.Cursor := Cursor;
  End;

  Try
    // Generar el conjunton de datos de los ajustes a la n�mina
    if Not Assigned(cdAjusteNomina) then
    begin
      cdAjusteNomina := TClientDataSet.Create(nil);

      if Not CrearConjunto(cdajusteNomina, 'nom_ajustenomina', ccCatalog) then
        raise InteligentException.CreateByCode(5, ['Ajuste N�mina']);

      if not CargarDatosFiltrados(cdajusteNomina, 'IdNomina', [DataSet.FieldByName('IdNomina').AsInteger]) then
        raise InteligentException.CreateByCode(6, ['Ajustes N�mina', DataSet.FieldByName('IdNomina').AsInteger, 'IdNomina']);

      if cdajusteNomina.Active then
        cdajusteNomina.Refresh
      else
        cdajusteNomina.Open;
    end;
    {$REGION 'REVISAR'}
{    // Verificar si ya se ha cargado el salario minimo del DF
    if SMGVDF = 0 then
    begin
      Try
        //Acceso := TClientDataSet.Create(Screen.ActiveForm);
        Acceso := TClientDataSet.Create(Nil);

        // Obtener el salario m�nimo del D.F.
        if Not CrearConjunto(Acceso, 'rhu_salario', ccCatalog) then
          raise InteligentException.CreateByCode(5, ['Cat�logo de Salarios']);

        if Not CargarDatosFiltrados(Acceso, 'TipoSalario', ['SMVDF']) then
          raise InteligentException.CreateByCode(6, ['Catalogo de Salarios', ClientModule1.cdOrganizacion.FieldByName('IdSalario').AsInteger, 'IdLlave']);
        Acceso.Open;

        if Acceso.RecordCount = 0 then
          raise InteligentException.CreateByCode(1, ['No existe el Salario M�nimo para el D.F.']);

        SMGVDF := StrToFloat(Acceso.FieldByName('Salario').AsString);

        Acceso.Close;
      Finally
        if Assigned(Acceso) then
        begin
          if Acceso.Active then
            Acceso.Close;

          EliminarConjunto(Acceso);
        end;
      End;
    end;}
    {$ENDREGION 'REVISAR' }
    // Determinar las variables de c�lculo
    Valor := DaysInMonth(MonthOf(DataSet.FieldByName('FechaNomina').AsDateTime));
    Valores.SetValue('EMPLEADO.DiasMesInicio', Valor, 'DiasMesInicio,DiasMesInicio,N�mero_de_dias_del_mes_al_inicio_de_N�mina,N�mero de d�as en el mes de Inicio de la N�mina,MEMORIA,Nil,No');

    Valor := DaysInMonth(MonthOf(DataSet.FieldByName('FechaTerminoNomina').AsDateTime));
    Valores.SetValue('EMPLEADO.DiasMesTermino', Valor, 'DiasMesTermino,DiasMesTermino,N�mero_de_dias_del_mes_al_termino_de_N�mina,N�mero de d�as en el mes de T�rmino de la N�mina,MEMORIA,Nil,No');

    Valor := DaysInMonth(MonthOf(IncMonth(DataSet.FieldByName('FechaNomina').AsDateTime, -1)));
    Valores.SetValue('EMPLEADO.DiasMesAntes', Valor, 'DiasMesAntes,DiasMesAntes,DiasMesAntes,N�mero de d�as en el mes anterior al Inicio de la N�mina,MEMORIA,Nil,No');

    Valor := DaysInMonth(MonthOf(IncMonth(DataSet.FieldByName('FechaTerminoNomina').AsDateTime, 1)));
    Valores.SetValue('EMPLEADO.DiasMesDespues', Valor, 'DiasMesDespues,DiasMesDespues,DiasMesDespues,N�mero de d�as en el mes posterior al Inicio de la N�mina,MEMORIA,Nil,No');

    // Contar los d�as en el bimestre de Inicio de N�mina
    Valor := DaysInMonth(MonthOf(DataSet.FieldByName('FechaNomina').AsDateTime));
    Valor := Valor + DaysInMonth(MonthOf(IncMonth(DataSet.FieldByName('FechaNomina').AsDateTime)));
    Valores.SetValue('EMPLEADO.NumeroDiasBimestreInicio', Valor, 'NumeroDiasBimestreInicio,NumeroDiasBimestreInicio,NumeroDiasBimestreInicio,N�mero de d�as en el bimestre de inicio de la N�mina,MEMORIA,Nil,No');

    // Contar los d�as en el bimestre de T�rmino de N�mina
    Valor := DaysInMonth(MonthOf(DataSet.FieldByName('FechaTerminoNomina').AsDateTime));
    Valor := Valor + DaysInMonth(MonthOf(IncMonth(DataSet.FieldByName('FechaTerminoNomina').AsDateTime)));
    Valores.SetValue('EMPLEADO.NumeroDiasBimestreTermino', Valor, 'NumeroDiasBimestreTermino,NumeroDiasBimestreTermino,NumeroDiasBimestreTermino,N�mero de d�as en el bimestre de Termino de la N�mina,MEMORIA,Nil,No');

    Try
      NumDias := TStringList.Create;
      NumDias.Clear;
      NumDias.CommaText := 'DOMINGO,LUNES,MARTES,MIERCOLES,JUEVES,VIERNES,SABADO';

      Fecha := EncodeDate(YearOf(DataSet.FieldByName('FechaNomina').AsDateTime), MonthOf(DataSet.FieldByName('FechaNomina').AsDateTime), 1);
      Semanas := 0;
      Mes := MonthOf(Fecha);
      TerminoSemana := NumDias.IndexOf(DataSet.FieldByName('InicioSemana').AsString);
      if TerminoSemana < 1 then
        TerminoSemana := 7;

      while MonthOf(Fecha) = Mes do
      begin
        if DayOfWeek(Fecha) = TerminoSemana then
          Inc(Semanas);

        Fecha := IncDay(Fecha);
      end;

      Valor := Semanas;
      Valores.SetValue('EMPLEADO.NumeroSemanasInicio', Valor, 'NumeroSemanasInicio,NumeroSemanasInicio,NumeroSemanasInicio,N�mero de semanas en el mes de Inicio de la N�mina,MEMORIA,Nil,No');

      FechaTermino := EncodeDate(YearOf(DataSet.FieldByName('FechaTerminoNomina').AsDateTime), MonthOf(DataSet.FieldByName('FechaTerminoNomina').AsDateTime), 1);

      if MonthOf(FechaTermino) <> Mes then
      begin
        Mes := MonthOf(FechaTermino);
        Semanas := 0;
        while MonthOf(FechaTermino) = Mes do
        begin
          if DayOfWeek(FechaTermino) = TerminoSemana then
            Inc(Semanas);

          FechaTermino := IncDay(FechaTermino);
        end;
      end;

      Valor := Semanas;
      Valores.SetValue('EMPLEADO.NumeroSemanasTermino', Valor, 'NumeroSemanasTermino,NumeroSemanasTermino,NumeroSemanasTermino,N�mero de semanas en el mes de Termino de la N�mina,MEMORIA,Nil,No');

      // Contar las semanas en el bimestre de inicio de N�mina
      Fecha := EncodeDate(YearOf(DataSet.FieldByName('FechaNomina').AsDateTime), MonthOf(DataSet.FieldByName('FechaNomina').AsDateTime), 1);
      if MonthOf(Fecha) Mod 2 = 0 then
        Fecha := IncMonth(Fecha, -1);

      FechaTermino := IncDay(IncMonth(Fecha,2), -1);
      Semanas := 0;

      while Fecha <= FechaTermino do
      begin
        if DayOfWeek(Fecha) = TerminoSemana then
          Inc(Semanas);

        Fecha := IncDay(Fecha);
      end;

      Valor := Semanas;
      Valores.SetValue('EMPLEADO.NumeroSemanasBimestreInicio', Valor, 'NumeroSemanasBimestreInicio,NumeroSemanasBimestreInicio,NumeroSemanasBimestreInicio,N�mero de semanas en el bimestre de inicio de la N�mina,MEMORIA,Nil,No');

      // Contar las semanas en el bimestre de t�rmino de N�mina
      Fecha := EncodeDate(YearOf(DataSet.FieldByName('FechaTerminoNomina').AsDateTime), MonthOf(DataSet.FieldByName('FechaTerminoNomina').AsDateTime), 1);
      if MonthOf(Fecha) Mod 2 = 0 then
        Fecha := IncMonth(Fecha, -1);

      FechaTermino := IncDay(IncMonth(Fecha,2), -1);
      Semanas := 0;

      while Fecha <= FechaTermino do
      begin
        if DayOfWeek(Fecha) = TerminoSemana then
          Inc(Semanas);

        Fecha := IncDay(Fecha);
      end;

      Valor := Semanas;
      Valores.SetValue('EMPLEADO.NumeroSemanasBimestreTermino', Valor, 'NumeroSemanasBimestreTermino,NumeroSemanasBimestreTermino,NumeroSemanasBimestreTermino,N�mero de semanas en el bimestre de t�rmino de la N�mina,MEMORIA,Nil,No');
    Finally
      NumDias.Clear;
      NumDias.Free;
    End;

    TotalPercepciones := 0;
    TotalDeducciones := 0;


    if cdDetalleSave.ProviderName <> '' then
    begin
      if Not CargarDatosFiltrados(cdDetalleSave, 'IdPersonal,IdNomina', [-9, -9]) then
        raise InteligentException.CreateByCode(28, ['No se pudo leer la estructura de la tabla del detalle de N�mina']);
      if cdDetalleSave.Active then
        cdDetalleSave.Refresh
      else
        cdDetalleSave.Open;
    end;

    Cursor := Screen.Cursor;
    Try
      Screen.Cursor := crAppStart;
      Try
        if (Not Assigned(gcForma)) and (Assigned(Panel_Progress)) then
        begin
          gcForma := TForm.Create(Screen.ActiveForm);
          gcForma.Height := 133 + GetSystemMetrics(SM_CYCaption) + 6;
          gcForma.Width := 632 + 6;
          gcForma.Position := poOwnerFormCenter;
        end;

        if (Assigned(gcForma)) and (Assigned(Panel_Progress)) then
        begin
          PadreOriginal := Panel_Progress.Parent;
          Panel_Progress.Parent := gcForma;
          Panel_Progress.Align := alClient;
          Panel_Progress.Visible := True;
        end;

        {if (Not Ocultar) and (Assigned(gcForma)) and (Assigned(Panel_Progress)) then
        begin
          if (Panel_Progress.Controls[3].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[3]).Controls[0].ClassType = TProgressBar) then
            TProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Position := 0;

          if (Panel_Progress.Controls[4].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[4]).Controls[0].ClassType = TProgressBar) then
            TProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Position := 0;
        end;}

        if Assigned(Panel_Progress) and (Panel_Progress.Visible) and (Panel_Progress.ControlCount > 0) then
        begin
          if (Panel_Progress.Controls[3].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[3]).Controls[0].ClassType = TcxProgressBar) then
          begin
            TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Position := 0;
            TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Properties.Max := cdPersonalNomina.FieldDefs.Count + cdConcepto.RecordCount;
          end;

          if (Panel_Progress.Controls[4].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[4]).Controls[0].ClassType = TcxProgressBar) then
          begin
            TcxProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Position := 0;
            TcxProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Properties.Max := TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Properties.Max * cdPersonalNomina.RecordCount;
          end;

          if Panel_Progress.Controls[0].ClassType = TJvLabel then
            TJvLabel(Panel_Progress.Controls[0]).Caption := 'Iniciando C�lculo de N�mina...';

          if Panel_Progress.Controls[1].ClassType = TJvLabel then
            TJvLabel(Panel_Progress.Controls[1]).Caption := '';

          if Panel_Progress.Controls[2].ClassType = TJvLabel then
            TJvLabel(Panel_Progress.Controls[2]).Caption := '';

          Panel_Progress.Repaint;
          TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Repaint;
        end;

        if Assigned(gcForma) then
        begin
          gcForma.Show;
        end;

        // Cada vez que inicio el c�lculo de la n�mina, verificar si los objetos de acumdetalle EST�N CREADOS
        Try
          if Assigned(dsAcumDetalle) and Assigned(dsAcumDetalle.DataSet) and (TClientDataSet(dsAcumDetalle.DataSet).ProviderName <> '') then
            EliminarConjunto(TClientDataSet(dsAcumDetalle.DataSet));
        Except
          ;
        End;

        Try
          if Assigned(dsAcumDetalle) and Assigned(dsAcumDetalle.DataSet) then
          begin
            dsAcumDetalle.DataSet.Destroy;
            dsAcumDetalle.DataSet := Nil;
          end;
        Except
          Try
            dsAcumDetalle.DataSet := Nil;
          Except
            ;
          End;
        End;

        Try
          if Assigned(dsAcumDetalle) then
          begin
            dsAcumDetalle.Destroy;
            dsAcumDetalle := Nil;
          end;
        Except
          Try
            dsAcumDetalle := Nil;
          Except
            ;
          End;
        End;

        //Cargar y descargar a disco la plantilla
        if (Length(Trim(LibroExcel)) > 0)  and ((Not Assigned(cdPlantilla))) then
        begin
          cdPlantilla := TClientDataSet.Create(nil);

          if Not CrearConjunto(cdPlantilla, 'nom_machotetiponomina', ccCatalog) then
            raise InteligentException.CreateByCode(5, ['Tipo N�mina']);

          if not CargarDatosFiltrados(cdPlantilla, 'idTipoNomina,IdMachoteTipoNomina', [DataSet.FieldByName('IdTipoNomina').AsInteger, LibroExcel]) then
            raise InteligentException.CreateByCode(6, ['Tipos N�mina', DataSet.FieldByName('IdTipoNomina').AsInteger, 'IdTipoNomina']);

          if cdPlantilla.Active then
            cdPlantilla.Refresh
          else
            cdPlantilla.Open;

        end;
        if (Length(Trim(LibroExcel)) > 0) and (cdPlantilla.ProviderName <> '') and (cdPlantilla.Active) and (cdPlantilla.RecordCount > 0) and
           (cdPlantilla.FieldByName('Machote').IsBlob) and (NOt cdPlantilla.FieldByName('Machote').IsNull) then
        begin
          RutaArchivo := DescargarPlantilla(cdPlantilla, '_tmp', '\Plantilla Calculo\');
          ExcelM := CreateOleObject('Excel.Application');
          try
            ExcelM.Visible:= True;
            ExcelM.Workbooks.Open(RutaArchivo);
            ListaTamCol := TStringList.Create;
            CoordenadasXY := VarToStr(ExcelM.Range['A1'].value); // obtener valores de las coordenadas de la regi�n a utilizar para descomponerlas
            ModoInsercion := VarToStr(ExcelM.Range['B1'].Value); //Valor del Modo inserci�n [0=Sustituci�n, 1=INSERCCION RENGLONES]
            CoordIniXY := varToStr(ExcelM.Range['B3'].Value); // Obtener valores de las coordenadas Iniciales
            //Datos para recorrer el excel
            ColY := StrToInt(Copy(CoordenadasXY, 0, Pos(',',CoordenadasXY)-1));
            RowX := StrToInt(Copy(CoordenadasXY, Pos(',', CoordenadasXY) + 1, Length(CoordenadasXY)));
            //Datos donde inicias los datos con los que se va a trabajar
            RowIni := StrToInt(Copy(CoordIniXY, Pos(',', CoordIniXY) + 1, length(CoordIniXY)));
            ColIni := StrToInt(Copy(CoordIniXY, 0, Pos(',', CoordIniXY) - 1));
            //Obtener el ancho de las columnas para poder ajustar las copias a un tamano est�ndar
            for j := 1 to ColY do
              ListaTamCol.Add(ExcelM.Columns[LetraColumna(j) + ':' + LetraColumna(j)].ColumnWidth);
          Except
            ExcelM.Quit;
            ExcelM := Null;
            ExcelM.Disconnect;
            ;
          end;
        end;

        ListaMemoria := TStringList.Create;
        ListaMemoria.Clear;

        TieneValor := False;
        cdPersonalNomina.First;
        while Not cdPersonalNomina.Eof do
        begin
          ProcesarMensajes;

          if Assigned(Panel_Progress) and (Panel_Progress.Visible) and (Panel_Progress.ControlCount > 0) and (Panel_Progress.Controls[3].ClassType = TPanel) and (TPanel(Panel_Progress.Controls[3]).Controls[0].ClassType = TcxProgressBar) then
            TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Position := 0;

          if NuevoTitulo = '' then
            gcForma.Caption := IntToStr(cdPersonalNomina.RecNo) + '/' + IntToStr(cdPersonalNomina.RecordCount) + ' : ' + cdPersonalNomina.FieldByName('CodigoPersonal').AsString + ' - ' + cdPersonalNomina.FieldByName('NombreCompleto').AsString
          else
            gcForma.Caption := NuevoTitulo;

          if cdPersonalNomina.FieldByName('IdFormaPago').IsNull then
          begin
            Valores.ListaValor.Clear;
            cdDetalle.EmptyDataSet;

            Valores.SetValue('EMPLEADO.SalMinDF', SMGVDF, 'SMGVDF,SMGVDF,Salario_Minimo_D.F.,SALARIO MINIMO GENERAL VIGENTE DEL D.F.,MEMORIA,Nil,No');    // Guardar en la memoria el valor del salario m�nimo general vigente para el D.F.

            IdPersonal := cdPersonalNomina.FieldByName('IdPersonal').AsInteger;
            IdOrganizacion := cdPersonalNomina.FieldByName('IdOrganizacion').AsInteger;
            IdNomina := DataSet.FieldByName('IdNomina').AsInteger;
            IdCargo := cdPersonalNomina.FieldByname('IdCargo').AsInteger;
            IdDepartamento := cdPersonalNomina.FieldByname('IdDepartamento').AsInteger;

            // Cargar los datos generales del Empleado
            CalcularDatosGeneralesEmpleado(cdPersonalNomina, Valores, Panel_Progress);

            // Verificar si se deben cargar las excepciones a los conceptos generales
            if Assigned(cdExcepciones) then
              CargarExcepcionesConceptosGenerales(IdPersonal, cdExcepciones);

            // Calcular los conceptos de N�mina
            CalcularConceptosNomina(cdConcepto, cdConceptoExtra, cdSumaConcepto, DataSet, Valores, memPercepciones, memDeducciones, TotalPercepciones, TotalDeducciones, DataSet.FieldByName('IdTipoTablaISPT').AsInteger, DataSet.FieldByName('Periodicidad').AsInteger, Panel_Progress); // Calcular todos los conceptos de n�mina

            if (Length(Trim(LibroExcel)) > 0) and (cdPlantilla.ProviderName <> '') and (cdPlantilla.Active) and (cdPlantilla.RecordCount > 0) and
               (cdPlantilla.FieldByName('Machote').IsBlob) and (NOt cdPlantilla.FieldByName('Machote').IsNull) then
            begin
              //Una vez asignado los valores dentro del excel, tiene que generar un copia para limpiar los valores para el nuevo empleado
              try
                Try
                  ExcelM.Range['Consecutivo'].Select;
                  if cdPersonalNomina.RecNo <= cdPersonalNomina.RecordCount - 1  then
                    ExcelM.selection.value := CdPersonalNomina.RecNo + 1
                  else
                    ExcelM.Selection.Value := 1;
                Except
                  ;
                End;
                Modo := VarToStr(ExcelM.Range['A3'].value);
                if compareText(ModoInsercion, '1') = 0  then
                  ExcelM.Range[LetraColumna(ColIni-1) + IntToStr(RowIni) + ':'+ LetraColumna(ColY -1) + IntToStr(RowIni)].select
                else
                  ExcelM.Range[LetraColumna(ColIni-1) + IntToStr(RowIni) + ':'+ LetraColumna(ColY -1) + IntToStr(RowX)].select;
                ExcelM.Selection.Copy;
              except
                ;
              end;
              //OJo: Necesito Saber si se expanden en columnas o renglones
              if TieneValor = false then  //Para que no me est� chingando a cada rato el mensaje
              begin
                try
                  if Length(Trim(Modo)) = 0 then
                    raise inteligentException.CreateByCode(24, ['No es posible continuar con el proceso, debido a que en la celda [A3] debe contener un valor necesario para el sistema.']);

                  //Pegamos en Rango de Celdas copiadas
                  if cdPersonalNomina.RecNo <=  cdPersonalNomina.RecordCount -1 then
                  begin
                    try
                      if CompareText(LowerCase(Modo),'a') = 0 then   //Se exapande por Columnas
                      begin
                        ExcelM.Range[LetraColumna(ColY * CdPersonalNomina.RecNo ) + IntToStr(1)].Select;
                        ExcelM.ActiveSheet.Paste;

                        for i := 1 to ColY do  //Autoajustar las Columnas al tamano del machote
                          ExcelM.Columns[LetraColumna(ColY * CdPersonalNomina.RecNo + i ) + ':' + LetraColumna(ColY * CdPersonalNomina.RecNo + i )].ColumnWidth :=  ListaTamCol[i-1];
                      end;
                      if CompareText(LowerCase(Modo),'b') = 0 then   //Se exapande por Renglones
                      begin
                        if CompareText(ModoInsercion, '1') = 0 then
                        begin
                          ExcelM.Rows[IntToStr(RowIni + cdPersonalNomina.RecNo) + ':' + IntToStr(RowIni + cdPersonalNomina.RecNo)].Select;
                          ExcelM.Selection.Insert[-4121];
                          ExcelM.Application.CutCopyMode := False;
                        end
                        else
                        begin
                          ExcelM.Range[LetraColumna(ColIni-1) + IntToStr(RowX * cdPersonalNomina.RecNo + 1)].Select;
                          ExcelM.ActiveSheet.Paste;

                          for i := 1 to ColY do  //Autoajustar las Columnas al tamano del machote
                            ExcelM.Columns[LetraColumna(ColIni-1) + ':' + LetraColumna(ColY * CdPersonalNomina.RecNo + i )].ColumnWidth :=  (ListaTamCol[i-1]);
                        end;
                      end;
                      if CompareText(LowerCase(Modo), 'd') = 0 then  //Se generan en nuevas cejas
                      begin
                        ExcelM.sheets.Add;
                        ExcelM.ActiveSheet.Paste;
                        ExcelM.ActiveSheet.Name := LeftStr(cdPersonalNomina.FieldByName('NombreCompleto').AsString, 31);

                        for i := 1 to ColY do  //Autoajustar las Columnas al tamano del machote
                          ExcelM.ActiveSheet.Columns[(LetraColumna(i) + ':' + LetraColumna(i))].ColumnWidth := (ListaTamCol[i-1]);
                        ExcelM.Sheets['PLANTILLA'].select;
                      end;
                    Except
                      ;
                    end;
                  end;
                except
                  on e: InteligentException do
                  begin
                    TieneValor := True;
                    InteliDialog.ShowModal(e.Title, e.Message, e.MsgType, [mbOK], 0);
                  end;
                end;
              end;
            end;
            if cdDetalleSave.ProviderName <> '' then
              gcForma.Caption := gcForma.Caption + '  [Grabando...]';

            TotalDeducciones := TotalDeducciones + Valores.Elemento('NOMINA.CUOTAIMSS-Obrero').AsFloat;
            Try
              // Concentrar todos los datos del empleado en elementos multivaluados
              Lista := TStringList.Create;
              Lista.Clear;

              for i := 0 to cdDetalleSave.FieldDefs.Count -1 do
                Lista.Add('');

              Lista[0] := cdDetalle.FieldByName('IdDetalleNomina').AsString;
              Lista[1] := cdDetalle.FieldByName('IdOrganizacion').AsString;
              Lista[2] := cdDetalle.FieldByName('IdPersonal').AsString;
              Lista[3] := cdDetalle.FieldByName('IdNomina').AsString;
              Lista[4] := cdDetalle.FieldByName('IdCargo').AsString;
              Lista[5] := cdDetalle.FieldByName('IdDepartamento').AsString;
              Lista[6] := '';   // Poner la forma de pago en autom�tico a nula

              cdDetalle.First;
              while not cdDetalle.Eof do
              begin
                //if CompareText(cdDetalle.FieldByName('Modo').AsString, 'MEMORIA') <> 0 then
                begin
                  for i := 7 to cdDetalle.FieldDefs.Count -1 do
                    Lista[i] := Lista[i] + cdDetalle.FieldByName(cdDetalle.FieldDefs.Items[i].Name).AsString + '|';
                end;

                cdDetalle.Next;
              end;

              Try
                if cdDetalleSave.ProviderName <> '' then
                begin
                  cdDetalleSave.Append;
                  for i := 0 to cdDetalleSave.FieldDefs.Count -1 do
                    cdDetalleSave.FieldByName(cdDetalleSave.FieldDefs.Items[i].Name).AsString := Reemplazar(Lista[i], '_', ' ');

                  CambiarVaciosANull(cdDetalleSave);

                  cdDetalleSave.Post;
                  if cdDetalleSave.ProviderName <> '' then
                    cdDetalleSave.ApplyUpdates(-1);
                end;
              Finally
                if (cdDetalleSave.ProviderName <> '') and (cdDetalleSave.State = dsInsert) then
                  cdDetalleSave.Cancel;
              End;
            Finally
              Lista.Free;
            End;
          end;
          cdPersonalNomina.Next;
        End;

        if EnTransaccion then
          ConcretarTransaccion;
      Finally
        if (Length(Trim(LibroExcel)) > 0) and (cdPlantilla.ProviderName <> '') and (cdPlantilla.Active) and (cdPlantilla.RecordCount > 0) and
           (cdPlantilla.FieldByName('Machote').IsBlob) and (NOt cdPlantilla.FieldByName('Machote').IsNull) and (Length(Trim(RutaArchivo)) > 0) then
        begin
          ExcelM.ActiveWorkbook.Save;
          ExcelM.ActiveWorkBook.Close;
          ExcelM.Quit;
          ExcelM := Unassigned;
          if Length(Trim(RutaArchivo)) > 0 then
            ShellExecute(Application.MainForm.Handle, nil, PChar(RutaArchivo), '','', SW_SHOWNORMAL);
        end;
        if Assigned(cdPlantilla) then
          cdPlantilla.Destroy;

        if EnTransaccion then
          CancelarTransaccion;

        Screen.Cursor := Cursor;
        if (Ocultar) and (Assigned(gcForma)) then
        begin
          Panel_Progress.Visible := False;
          Panel_Progress.Align := alNone;
          Panel_Progress.Parent := PadreOriginal;
          gcForma.Free;
          gcForma := Nil;
          //gcForma.Hide;
        end;
      End;
    Except
      on e:InteligentConnection do
        Raise;

      on e:InteligentException do
        InteliDialog.ShowModal(e.Title, e.Message + ' Clase: ' + e.classname , e.MsgType, [mbOk], 0);

      on e:InteligentWarning do
        raise;

      on e:Exception do
        InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema: ' + e.Message, mtError, [mbOk], 0);
    End;
  Finally
    if Assigned(cdAjusteNomina) then
    begin
      Try
        if cdAjusteNomina.ProviderName <> '' then
          EliminarConjunto(cdAjusteNomina);

        cdAjusteNomina.Destroy;
        cdAjusteNomina := Nil;
      Except
        on e:Exception do
          ShowMessage(e.Message);
      End;
    end;
  End;
end;

function Reemplazar(Cadena, Buscar, Cambiar: String): String;
var
  i: Integer;
  Cad2: String;
begin
  i := 0;
  Cad2 := '';
  for i := 1 to Length(Cadena) do
    if Cadena[i] = '_' then
      Cad2 := Cad2 + ' '
    else
      Cad2 := Cad2 + Cadena[i];

  Result := Cad2;
end;

procedure GenerarCalculoVirtual(FormaPadre: TForm;
                                Limite: Real;

                                IdOrganizacion: Integer;
                                FactorPrimaDominical,
                                FactorPrimaVacacional,
                                SalMinGenDF,
                                SalMinGenZona,
                                SeguroVidaINFONAVIT: Real;
                                DiasExcentoPrimaVacacional,
                                DiasExcentoAguinaldo,
                                DiasTopeIntegrado: Integer;

                                IdTipoNomina,
                                DiasTrabajados,
                                DiasDescanso: Integer;

                                DiasFestivos: Integer;
                                Domingos: Integer;

                                Jornada: Integer;

                                InicioSemana: String;
                                IdTipoTablaISPT: Integer;
                                Periodicidad: Real;
                                SalarioDiario: Real;
                                SalarioIntegrado: Real;
                                Fechainicio: TDate;
                                FechaTermino: TDate;
                                Antiguedad: Integer;
                                Var memPercepciones: TClientDataSet;
                                Var memDeducciones: TClientDataSet;
                                Var NewSalario: Real;
                                Var NewSalarioIntegrado: Real;
                                Var NewAguinaldo: Real;
                                Var NewVacaciones: Real;
                                Var NewPrimaVacacional: Real;
                                Ocultar: Boolean = True);
var
  cdNomina,
  cdPersonalNomina,
  cdPersonal,
  cdConceptoExtra,
  cdSumaConcepto: TClientDataSet;
  Forma: TForm;
  Cursor: TCursor;
  dsDetalle: TDataSource;
  AproxSalario,
  FactorIntegracion,
  AproxSalarioIntegrado,
  TotalPercepciones,
  TotalDeducciones,
  Neto, Neto1: Extended;
  DiasVacaciones,
  DiasAguinaldo,
  CuentaCiclo: Integer;
  cdBuscar: TClientDataSet;
  Termina: Boolean;
  Panel_Progress: TPanel;
  pSMGVDF: Real;

begin
  TerminarProceso := False;

  // Crear el panel de avance de c�lculo
  if Assigned(FormaPadre) then
  begin
    Panel_Progress := TPanel.Create(FormaPadre);
    Panel_Progress.Height := 138;
    Panel_Progress.Width := 279;

    Panel_Progress.InsertControl(TJvLabel.Create(Panel_Progress));
    TJvLabel(Panel_Progress.Controls[0]).Caption := 'lblLeyenda1';
    TJvLabel(Panel_Progress.Controls[0]).Height := 13;
    TJvLabel(Panel_Progress.Controls[0]).Left := 21;
    TJvLabel(Panel_Progress.Controls[0]).Top := 35;
    TJvLabel(Panel_Progress.Controls[0]).Width := 59;

    Panel_Progress.InsertControl(TJvLabel.Create(Panel_Progress));
    TJvLabel(Panel_Progress.Controls[1]).Caption := 'lblLeyenda2';
    TJvLabel(Panel_Progress.Controls[1]).Height := 13;
    TJvLabel(Panel_Progress.Controls[1]).Left := 21;
    TJvLabel(Panel_Progress.Controls[1]).Top := 54;
    TJvLabel(Panel_Progress.Controls[1]).Width := 59;

    Panel_Progress.InsertControl(TJvLabel.Create(Panel_Progress));
    TJvLabel(Panel_Progress.Controls[2]).Caption := 'lblTitulo';
    TJvLabel(Panel_Progress.Controls[2]).Height := 16;
    TJvLabel(Panel_Progress.Controls[2]).Left := 21;
    TJvLabel(Panel_Progress.Controls[2]).Top := 13;
    TJvLabel(Panel_Progress.Controls[2]).Width := 51;

    Panel_Progress.InsertControl(TPanel.Create(Panel_Progress));
    TPanel(Panel_Progress.Controls[3]).Align := alBottom;
    TPanel(Panel_Progress.Controls[3]).BevelOuter := bvNone;
    TPanel(Panel_Progress.Controls[3]).Caption := '';
    TPanel(Panel_Progress.Controls[3]).Height := 25;
    TPanel(Panel_Progress.Controls[3]).Left := 1;
    TPanel(Panel_Progress.Controls[3]).Padding.Bottom := 8;
    TPanel(Panel_Progress.Controls[3]).Padding.Left := 10;
    TPanel(Panel_Progress.Controls[3]).Padding.Right := 8;
    TPanel(Panel_Progress.Controls[3]).Padding.Top := 0;
    TPanel(Panel_Progress.Controls[3]).Top := 112;
    TPanel(Panel_Progress.Controls[3]).Width := 277;

    TPanel(Panel_Progress.Controls[3]).InsertControl(TcxProgressBar.Create(Panel_Progress.Controls[3]));
    TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Align := alClient;
    TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Height := 17;
    TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Left := 10;
    TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Top := 0;
    TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Width := 259;
    TcxProgressBar(TPanel(Panel_Progress.Controls[3]).Controls[0]).Style.LookAndFeel.SkinName := 'Office2010Blue';

    Panel_Progress.InsertControl(TPanel.Create(Panel_Progress));
    TPanel(Panel_Progress.Controls[4]).Align := alBottom;
    TPanel(Panel_Progress.Controls[4]).BevelOuter := bvNone;
    TPanel(Panel_Progress.Controls[4]).Caption := '';
    TPanel(Panel_Progress.Controls[4]).Height := 25;
    TPanel(Panel_Progress.Controls[4]).Left := 1;
    TPanel(Panel_Progress.Controls[4]).Padding.Bottom := 8;
    TPanel(Panel_Progress.Controls[4]).Padding.Left := 10;
    TPanel(Panel_Progress.Controls[4]).Padding.Right := 8;
    TPanel(Panel_Progress.Controls[4]).Padding.Top := 0;
    TPanel(Panel_Progress.Controls[4]).Top := 87;
    TPanel(Panel_Progress.Controls[4]).Width := 277;

    TPanel(Panel_Progress.Controls[4]).InsertControl(TcxProgressBar.Create(Panel_Progress.Controls[4]));
    TcxProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Align := alClient;
    TcxProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Height := 17;
    TcxProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Left := 10;
    TcxProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Top := 0;
    TcxProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Width := 259;
    TcxProgressBar(TPanel(Panel_Progress.Controls[4]).Controls[0]).Style.LookAndFeel.SkinName := 'Office2010Blue';

    Panel_Progress.InsertControl(TAdvGlowButton.Create(Panel_Progress));
    TAdvGlowButton(Panel_Progress.Controls[5]).Caption := '&Cancelar';
    TAdvGlowButton(Panel_Progress.Controls[5]).Height := 26;
    TAdvGlowButton(Panel_Progress.Controls[5]).Left := 463;
    TAdvGlowButton(Panel_Progress.Controls[5]).TabOrder := 2;
    TAdvGlowButton(Panel_Progress.Controls[5]).Top := 36;
    TAdvGlowButton(Panel_Progress.Controls[5]).Width := 121;
    TAdvGlowButton(Panel_Progress.Controls[5]).OnClick := myPrueba.OnClickCancel;
  end;

  // Definir un periodo de n�mina l�gico
  Try
    Try
      Cursor := Screen.Cursor;
      ProcesarMensajes;

      Try
        Screen.Cursor := crSQLWait;

        AproxSalario := Round(Limite / ((DiasTrabajados + DiasFestivos) / 100)) / 100;

        // Obtener los datos del tipo de n�mina
        Try
          cdBuscar := TClientDataSet.Create(Nil);
          CrearConjunto(cdBuscar, 'nomina_factorintegracion', ccSelect);
          CargarDatosFiltrados(cdBuscar, 'IdOrganizacion,IdTipoNomina,Aplicacion,Anios', [IdOrganizacion, IdTipoNomina, FechaACadena(Now), Antiguedad]);
          cdBuscar.Open;
          if Not cdBuscar.FieldByName('Factor').IsNull then
          begin
            FactorIntegracion := cdBuscar.FieldByName('Factor').AsFloat;
            DiasVacaciones := cdBuscar.FieldByName('DiasVacaciones').AsInteger;
            DiasAguinaldo := cdBuscar.FieldByName('DiasAguinaldo').AsInteger;
          end
          else
          begin
            FactorIntegracion := 1;
            DiasVacaciones := 0;
            DiasAguinaldo := 0;
          end;
          cdBuscar.Close;
        Finally
          if cdBuscar.ProviderName <> '' then
            EliminarConjunto(cdBuscar);
        End;

        AproxSalarioIntegrado := Round((AproxSalario * FactorIntegracion) * 100) / 100;
        if AproxSalarioIntegrado > (Trunc((SalMinGenDF * 25) * 100) / 100) then
          AproxSalarioIntegrado := (Trunc((SalMinGenDF * 25) * 100) / 100);

        CrearConjuntoDatosProyeccion(cdNomina,
                                     cdPersonalNomina,
                                     cdPersonal,
                                     cdgcConcepto,
                                     cdConceptoExtra,
                                     cdSumaConcepto,
                                     memPercepciones,
                                     memDeducciones,
                                     IdTipoNomina,
                                     DiasTrabajados,
                                     DiasDescanso,
                                     InicioSemana,
                                     IdTipoTablaISPT,
                                     Periodicidad,
                                     AproxSalario,
                                     AproxSalarioIntegrado,
                                     SalMinGenDF,
                                     SalMinGenZona,
                                     DiasVacaciones,
                                     DiasAguinaldo,
                                     FactorPrimaDominical,
                                     FactorPrimaVacacional,
                                     DiasExcentoPrimaVacacional,
                                     DiasExcentoAguinaldo,
                                     SeguroVidaINFONAVIT,
                                     DiasFestivos,
                                     Jornada,
                                     Limite,
                                     SalarioDiario,
                                     SalarioIntegrado,
                                     FechaInicio,
                                     FechaTermino);

          (*if (mPercepciones <> nil) and (mDeducciones <> nil) then
          begin
            //mPercepciones := TClientDataSet.Create(Nil);
            mPercepciones.FieldDefs.Add('IdPersonal', ftInteger, 0, False);
            mPercepciones.FieldDefs.Add('CodigoConcepto', ftString, 6, False);
            mPercepciones.FieldDefs.Add('Titulo', ftString, 20, False);
            mPercepciones.FieldDefs.Add('Nombre', ftString, 80, False);
            mPercepciones.FieldDefs.Add('Modo', ftString, 20, False);
            mPercepciones.FieldDefs.Add('Importe', ftFloat, 0, False);
            mPercepciones.CreateDataSet;
            mPercepciones.Open;

            //mDeducciones := TClientDataSet.Create(Nil);
            mDeducciones.FieldDefs.Add('IdPersonal', ftInteger, 0, False);
            mDeducciones.FieldDefs.Add('CodigoConcepto', ftString, 6, False);
            mDeducciones.FieldDefs.Add('Titulo', ftString, 20, False);
            mDeducciones.FieldDefs.Add('Nombre', ftString, 80, False);
            mDeducciones.FieldDefs.Add('Modo', ftString, 20, False);
            mDeducciones.FieldDefs.Add('Importe', ftFloat, 0, False);
            mDeducciones.CreateDataSet;
            mDeducciones.Open;
          end;*)
      Finally
        Screen.Cursor := Cursor;
      End;

      ProcesarMensajes;

      dsDetalle := TDataSource.Create(Nil);
      dsDetalle.DataSet := cdDetalle;

      Termina := False;
      NuevoTitulo := 'Calculando salario diario para: ' + FloatToStrF(AproxSalario, ffCurrency, 16, 2);
      Neto1 := 0;
      CuentaCiclo := 0;
      NewSalario := 0;
      NewSalarioIntegrado := 0;
      NewAguinaldo := 0;
      NewVacaciones := 0;
      NewPrimaVacacional := 0;

      while Not Termina do
      begin
        if limite <> -1 then
          if AproxSalario < SalMinGenZona then
            raise InteligentWarning.CreateByCode(24, ['Debe agregar una cantidad mayor a $' + FloatToStr(Limite) + ' para poder proceder con el c�lculo.' + #10 + #10 + 'Esto se debe a que el salario diario no puede ser menor a $' + FloatToStr(SalMinGenZona)+'.']);

        ProcesarMensajes;

        CalcularNominaEmpleado(cdNomina, cdPersonalNomina, Nil, cdPersonal, cdgcConcepto, cdConceptoExtra, cdSumaConcepto, memPercepciones, memDeducciones, Panel_Progress, False, Ocultar);
        ProcesarMensajes;

        //Si el Limite recibe un parametro de -1, no se ejecuta nada de esto
        //Debido a que solo es una proyeccion de N�mina no un c�lculo de Salario
        if Limite <> -1 then
        begin
          // verificar  que  el salario diario  no este por debajo del salario
          //m�nimo de zona
          if AproxSalario < SalMinGenZona then
            raise InteligentWarning.CreateByCode(24, ['Debe agregar una cantidad mayor a $' + FloatToStr(Limite) + ' para poder proceder con el c�lculo.' + #10 + #10 + 'Esto se debe a que el salario diario no puede ser menor a $' + FloatToStr(SalMinGenZona)+'.']);

          // Sumar percepciones y deducciones
          memPercepciones.First;
          TotalPercepciones := 0;
          while not memPercepciones.Eof do
          begin
            if memPercepciones.FieldByName('Modo').AsString = 'PERCEPCION' then
              TotalPercepciones := TotalPercepciones + StrToFloat(memPercepciones.FieldByName('Importe').AsString);

            if memPercepciones.FieldByName('CodigoConcepto').AsString = '19' then
              NewVacaciones := StrToFloat(memPercepciones.FieldByName('Importe').AsString);

            if memPercepciones.FieldByName('CodigoConcepto').AsString = '22' then
              NewPrimaVacacional := StrToFloat(memPercepciones.FieldByName('Importe').AsString);

            if memPercepciones.FieldByName('CodigoConcepto').AsString = '24' then
              NewAguinaldo := StrToFloat(memPercepciones.FieldByName('Importe').AsString);

            memPercepciones.Next;
          end;

          memDeducciones.First;
          TotalDeducciones := 0;
          while not memDeducciones.Eof do
          begin
            if memDeducciones.FieldByName('Modo').AsString = 'DEDUCCION' then
              TotalDeducciones := TotalDeducciones + StrToFloat(memDeducciones.FieldByName('Importe').AsString);

            memDeducciones.Next;
          end;

          Neto := TotalPercepciones - TotalDeducciones;

          // Se debe terminar en los siguiente casos:
          //   1.- Cuando se haya alcanzado el mismo Neto buscado
          //   2.- Cuando se haya superado el Neto buscado despu�s de venir de abajo
          //   3.- Cuando se haya ciclado el proceso y haya dado 3 ciclos de m�s y estemos por arriba del Limite

          Termina := (FloatToStrF(Neto, ffFixed, 16, 2) = FloatToStrF(Limite, ffFixed, 16, 2)) or
                     ((Trunc(Neto * 100) > Trunc(Limite * 100)) and (Neto1 > 0) and (Trunc(Neto * 100) > Trunc(Neto1 * 100))) or
                     ((CuentaCiclo > 2) and (Trunc(Neto * 100) > Trunc(Limite * 100)));

          // Verificar si ya se cicl� este pedo
          if (Trunc(Neto * 100) > Trunc(Limite * 100)) and (Trunc(Neto1 * 100) < Trunc(Neto * 100)) then
            Inc(CuentaCiclo);

          // Registrar el Neto anterior
          Neto1 := Neto;
          //Termina := Limite = -1;

          if Not Termina then
          begin
            if Neto < Limite then
            begin
              if (Round((AproxSalario + (((Limite - Neto) / (DiasTrabajados + DiasFestivos)) / 1)) * 100) / 100) = AproxSalario then
                AproxSalario := AproxSalario + 0.01
              else
                AproxSalario := Round((AproxSalario + (((Limite - Neto) / (DiasTrabajados + DiasFestivos)) / 1)) * 100) / 100;

              AproxSalarioIntegrado := Round((AproxSalario * FactorIntegracion) * 100) / 100;
            end;

            if Neto > Limite then
            begin
              if (Round((AproxSalario + (((Limite - Neto) / (DiasTrabajados + DiasFestivos)) / 1)) * 100) / 100) = AproxSalario then
                AproxSalario := AproxSalario - 0.01
              else
                AproxSalario := Round((AproxSalario + (((Limite - Neto) / (DiasTrabajados + DiasFestivos)) / 1)) * 100) / 100;

              AproxSalarioIntegrado := Round((AproxSalario * FactorIntegracion) * 100) / 100;
            end;

            if Not Termina then
            begin
              if AproxSalarioIntegrado > (Trunc((SalMinGenDF * 25) * 100) / 100) then
                AproxSalarioIntegrado := (Trunc((SalMinGenDF * 25) * 100) / 100);

              cdPersonalNomina.Edit;
              cdPersonalNomina.FieldByName('Salario').AsFloat := AproxSalario;
              cdPersonalNomina.FieldByName('SalarioIntegrado').AsFloat := AproxSalarioIntegrado;
              cdPersonalNomina.Post;

              cdPersonal.Edit;
              cdPersonal.FieldByName('salario').AsFloat := AproxSalario;
              cdPersonal.Post;
            end;
          end;

        end
        else
          Termina := true;

        if Termina then
        begin
          NuevoTitulo := 'Salario diario determinado: ' + FloatToStrF(AproxSalario, ffCurrency, 16, 2) + ' - Neto alcanzado: ' + FloatToStrF(Neto, ffCurrency, 16, 2);
          gcForma.Caption := NuevoTitulo;
          gcForma.Repaint;
        end
        else
          NuevoTitulo := 'Calculando salario diario para: ' + FloatToStrF(AproxSalario, ffCurrency, 16, 2) + ' - �ltimo neto alcanzado: ' + FloatToStrF(Neto, ffCurrency, 16, 2);
      end;

      NewSalario := AproxSalario;
      NewSalarioIntegrado := AproxSalarioIntegrado;
    Except
      on e:InteligentConnection do
        Raise;

      on e:InteligentWarning do
        InteliDialog.ShowModal('Cancelado', e.Message, mtInformation, [mbOk], 0);

      on e:Exception do
        InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + #10 + #10 + e.Message, mtError, [mbOk], 0);
    End;
  Finally
    if Assigned(cdConceptoExtra) then
      Try
        EliminarConjunto(cdConceptoExtra);
      Except
        ;
      End;

    cdNomina.Free;
    cdPersonalNomina.Free;
    cdPersonal.Free;
    //Foco Rojo

    if Assigned(cdDetalleSave) then
    begin
      cdDetalleSave.free;
    end;
  End;
end;

procedure EliminarTodosConjuntos;
begin
  Try
    if Assigned(cdgcConcepto) then
      EliminarConjunto(cdgcConcepto);
  Except
    ;
  End;
  Try
    cdgcConcepto.Destroy;
  Except
    ;
  End;

  Try
    FreeAndNil(cdgcConcepto);
  Except
    ;
  End;
end;

procedure ProcesarMensajes;
begin
  Application.ProcessMessages;
  if TerminarProceso then
    if InteliDialog.ShowModal('Cancelar proceso', 'Si cancela el proceso en este momento, todos los cambios realizados se perder�n.' + #10 + #10 + '�Est� seguro que desea detener el proceso en este momento?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      raise InteligentConnection.Create('***')
    else
      TerminarProceso := False;
end;

procedure CargarExcepcionesConceptosGenerales(IdPersonal: Integer;
  DataSet: TClientDataSet);
var
  NewValue: Variant;
  OrValor, myNewValor: Integer;
begin
  // Cargar las excepciones de los empleados
  Try
    DataSet.Filtered := False;
    DataSet.Filter := 'IdPersonal = ' + IntToStr(IdPersonal);
    DataSet.Filtered := True;

    DataSet.First;
    while not DataSet.Eof do
    begin
      Try
        NewValue := DataSet.FieldByName('Cantidad').AsFloat;
        if CompareText(DataSet.FieldByName('TipoExcepcion').AsString, 'Resta') = 0 then
          NewValue := NewValue * -1;
      Except
        NewValue := DataSet.FieldByName('Cantidad').AsString;
      End;

      if (CompareText(DataSet.FieldByName('ClaveConcepto').AsString, 'DiaFestivo') = 0) and (Valores.Elemento('EMPLEADO.CobraFestivos').AsInteger = 0) then
      begin
        // Si esta persona no cobra festivos regularmente, se deber� agregar solamente el valor que se captur� en la excepci�n
        OrValor := Valores.Elemento('EMPLEADO.DiaFestivo').AsInteger;
        NewValue := (OrValor * -1) + NewValue;

        Valores.ResetValue('CobraFestivos', 1); // Indicar que se deben cobrar los festivos cuando exista una exepcion de este tipo
      end;

      // Sumar o restar (seg�n sea el caso) la cantidad de d�as festivos que considera la excepci�n
      Valores.ResetValue(DataSet.FieldByName('ClaveConcepto').AsString, NewValue);
      if CompareText(DataSet.FieldByName('ClaveConcepto').AsString, 'DIAST') = 0 then
        Valores.ResetValue('DiasEfectivos', NewValue);

{      if (CompareText(DataSet.FieldByName('ClaveConcepto').AsString, 'DiasFestivos') = 0) and (Valores.Elemento('EMPLEADO.CobraFestivos').AsInteger = 0) then
        Valores.ResetValue('CobraFestivos', 1);}

      DataSet.Next;
    end;
    Valores.ResetValue('SUELDO', '-20000');
  Finally
    DataSet.Filtered := False;
  End;
end;

procedure CrearConjuntoDatosProyeccion(var cdNomina: TClientDataSet;
                                       var cdPersonalNomina: TClientDataSet;
                                       var cdPersonal: TClientDataSet;
                                       var cdgcConcepto: TClientDataSet;
                                       var cdConceptoExtra: TClientDataSet;
                                       var cdSumaConcepto: TClientDataSet;
                                       var memPercepciones: TClientDataSet;
                                       var memDeducciones: TClientDataSet;
                                           IdTipoNomina: Integer;
                                           DiasTrabajados: Integer;
                                           DiasDescanso: Integer;
                                           InicioSemana: String;
                                           IdTipoTablaISPT: Integer;
                                           Periodicidad: Real;
                                           AproxSalario: Real;
                                           AproxSalarioIntegrado: Real;
                                           SalMinGenDF: Real;
                                           SalMinGenZona: Real;
                                           DiasVacaciones: Integer;
                                           DiasAguinaldo: Integer;
                                           FactorPrimaDominical: Real;
                                           FactorPrimaVacacional: Real;
                                           DiasExcentoPrimaVacacional: Integer;
                                           DiasExcentoAguinaldo: Integer;
                                           SeguroVidaINFONAVIT: Real;
                                           DiasFestivos: Integer;
                                           Jornada: Integer;
                                           Limite: Real;
                                           SalarioDiario: Real;
                                           SalarioIntegrado: Real;
                                           Fechainicio: TDate;
                                           FechaTermino: TDate);
var
  Cursor: TCursor;
begin
  Cursor := Screen.Cursor;

  Try
    Cursor := crHourGlass;

    if Not Assigned(cdNomina) then
    begin
      cdNomina := TClientDataSet.Create(Nil);
      cdNomina.FieldDefs.Add('IdNomina', ftInteger);
      cdNomina.FieldDefs.Add('IdTipoNomina', ftInteger);
      cdNomina.FieldDefs.Add('IdGuardia', ftInteger);
      cdNomina.FieldDefs.Add('IdPeriodosGuardia', ftInteger);
      cdNomina.FieldDefs.Add('Titulo', ftString, 200);
      cdNomina.FieldDefs.Add('FechaNomina', ftDate);
      cdNomina.FieldDefs.Add('Estado', ftString, 40);
      cdNomina.FieldDefs.Add('FechaTerminoNomina', ftDate);
      cdNomina.FieldDefs.Add('Dias', ftInteger);
      cdNomina.FieldDefs.Add('TituloGeneral', ftString, 200);
      cdNomina.FieldDefs.Add('IdFormaPago', ftInteger);
      cdNomina.FieldDefs.Add('Descripcion', ftString, 200);
      cdNomina.FieldDefs.Add('DiasTrabajados', ftInteger);
      cdNomina.FieldDefs.Add('DiasDescanso', ftInteger);
      cdNomina.FieldDefs.Add('InicioSemana', ftString, 12);
      cdNomina.FieldDefs.Add('IdTipoTablaISPT', ftInteger);
      cdNomina.FieldDefs.Add('Periodicidad', ftFloat);
      cdNomina.CreateDataSet;
    end;

    cdNomina.Open;
    cdNomina.Append;
    cdNomina.FieldByName('IdNomina').AsInteger := 1;
    cdNomina.FieldByName('IdTipoNomina').AsInteger := IdTipoNomina;
    cdNomina.FieldByName('IdGuardia').AsInteger := 1;
    cdNomina.FieldByName('IdPeriodosGuardia').AsInteger := 1;
    cdNomina.FieldByName('Titulo').AsString := '*';
    cdNomina.FieldByName('FechaNomina').AsDateTime := Now;
    cdNomina.FieldByName('Estado').AsString := 'Abierta';
    cdNomina.FieldByName('FechaTerminoNomina').AsDateTime := Now + DiasTrabajados -1;
    cdNomina.FieldByName('Dias').AsInteger := DiasTrabajados;
    cdNomina.FieldByName('TituloGeneral').AsString := '*';
    cdNomina.FieldByName('Descripcion').AsString := '*';
    cdNomina.FieldByName('DiasTrabajados').AsInteger := DiasTrabajados;
    cdNomina.FieldByName('DiasDescanso').AsInteger := DiasDescanso;
    cdNomina.FieldByName('InicioSemana').AsString := InicioSemana;
    cdNomina.FieldByName('IdTipoTablaISPT').AsInteger := IdTipoTablaISPT;
    cdNomina.FieldByName('Periodicidad').AsFloat := Periodicidad;
    cdNomina.Post;

    if Not Assigned(cdPersonalNomina) then
    begin
      cdPersonalNomina := TClientDataSet.Create(Nil);
      cdPersonalNomina.FieldDefs.Add('IdOrganizacion', ftInteger);
      cdPersonalNomina.FieldDefs.Add('FechaNomina', ftDate);
      cdPersonalNomina.FieldDefs.Add('Fecha', ftDate);
      cdPersonalNomina.FieldDefs.Add('IdPersonal', ftInteger);
      cdPersonalNomina.FieldDefs.Add('CodigoPersonal', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('RegPatIMSS', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('NumeroSeguroSocial', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('NombreCompleto', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('IdPlazaDetalle', ftInteger);
      cdPersonalNomina.FieldDefs.Add('Infonavit', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('NumeroInfonavit', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('FactorInfonavit', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('TituloCargo', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('Titulo', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('Descripcion', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('DiasTrabajados', ftInteger);
      cdPersonalNomina.FieldDefs.Add('IdDepartamento', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('CodigoDepartamento', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('TituloDepartamento', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('Salario', ftFloat);
      cdPersonalNomina.FieldDefs.Add('TituloSalario', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('SalarioIntegrado', ftFloat);
      cdPersonalNomina.FieldDefs.Add('IdCargo', ftInteger);
      cdPersonalNomina.FieldDefs.Add('CodigoCargo', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('TituloMoneda', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('SalMinDF', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('SalMinGenZona', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('FechaReingreso', ftDate);
      cdPersonalNomina.FieldDefs.Add('DiasVacaciones', ftInteger);
      cdPersonalNomina.FieldDefs.Add('DiasAguinaldo', ftInteger);
      cdPersonalNomina.FieldDefs.Add('FactorPrimaDominical', ftFloat);
      cdPersonalNomina.FieldDefs.Add('FactorPrimaVacacional', ftFloat);
      cdPersonalNomina.FieldDefs.Add('DiasExcentoPrimaVacacional', ftInteger);
      cdPersonalNomina.FieldDefs.Add('DiasExcentoAguinaldo', ftInteger);
      cdPersonalNomina.FieldDefs.Add('SeguroVidaINFONAVIT', ftFloat);
      cdPersonalNomina.FieldDefs.Add('FechaInicio', ftDate);
      cdPersonalNomina.FieldDefs.Add('FechaTermino', ftDate);
      cdPersonalNomina.FieldDefs.Add('DIAST', ftInteger);
      cdPersonalNomina.FieldDefs.Add('DIASTIMSS', ftInteger);
      cdPersonalNomina.FieldDefs.Add('Inasistencias', ftInteger);
      cdPersonalNomina.FieldDefs.Add('InasistenciasAguinaldo', ftInteger);
      cdPersonalNomina.FieldDefs.Add('InasistenciasVacaciones', ftInteger);
      cdPersonalNomina.FieldDefs.Add('HorasExtra', ftFloat);
      cdPersonalNomina.FieldDefs.Add('Periodo', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('EstadoPersonal', ftString, 10);
      cdPersonalNomina.FieldDefs.Add('FechaBaja', ftDate);
      cdPersonalNomina.FieldDefs.Add('DiaFestivo', ftInteger);
      cdPersonalNomina.FieldDefs.Add('Jornada', ftInteger);
      cdPersonalNomina.FieldDefs.Add('IdFormaPago', ftInteger);
      cdPersonalNomina.CreateDataSet;
    end;

    cdPersonalNomina.Append;
    cdPersonalNomina.FieldByName('IdOrganizacion').AsInteger := IdOrganizacion;
    cdPersonalNomina.FieldByName('FechaNomina').AsDateTime := Now;
    cdPersonalNomina.FieldByName('fecha').AsDateTime := Now;
    cdPersonalNomina.FieldByName('IdPersonal').AsInteger := -9;
    cdPersonalNomina.FieldByName('CodigoPersonal').AsString := '*';
    cdPersonalNomina.FieldByName('RegPatIMSS').AsString := '*';
    cdPersonalNomina.FieldByName('NumeroSeguroSocial').AsString := '*';
    cdPersonalNomina.FieldByName('NombreCompleto').AsString := '*';
    cdPersonalNomina.FieldByName('IdPlazaDetalle').AsInteger := 1;
    cdPersonalNomina.FieldByName('Infonavit').AsString := '*';
    cdPersonalNomina.FieldByName('NumeroInfonavit').AsString := '*';
    cdPersonalNomina.FieldByName('FactorInfonavit').AsFloat := 0;
    cdPersonalNomina.FieldByName('TituloCargo').AsString := '*';
    cdPersonalNomina.FieldByName('Titulo').AsString := '*';
    cdPersonalNomina.FieldByName('Descripcion').AsString := '*';
    cdPersonalNomina.FieldByName('DiasTrabajados').AsInteger := DiasTrabajados;
    cdPersonalNomina.FieldByName('IdDepartamento').AsInteger := 1;
    cdPersonalNomina.FieldByName('CodigoDepartamento').AsString := '*';
    cdPersonalNomina.FieldByName('TituloDepartamento').AsString := '*';
    if limite = -1  then
    begin
      cdPersonalNomina.FieldByName('Salario').AsFloat := SalarioDiario;
      cdPersonalNomina.FieldByName('SalarioIntegrado').AsFloat := SalarioIntegrado;
      cdPersonalNomina.FieldByName('FechaBaja').AsDateTime := FechaTermino;
      cdPersonalNomina.FieldByName('FechaReingreso').AsDateTime := Fechainicio ;
      cdPersonalNomina.FieldByName('DIAST').AsInteger := DaysBetween(Fechainicio,IncDay(FechaTermino,1));
      cdPersonalNomina.FieldByName('DIASTIMSS').AsInteger := DaysBetween(Fechainicio,incDay(FechaTermino,1));
      cdPersonalNomina.FieldByName('Jornada').AsInteger := Jornada;
    end
    else
    begin
      cdPersonalNomina.FieldByName('Salario').AsFloat := AproxSalario;
      cdPersonalNomina.FieldByName('SalarioIntegrado').AsFloat := AproxSalarioIntegrado;
      cdPersonalNomina.FieldByName('FechaBaja').AsDateTime := Now + DiasTrabajados -1;
      cdPersonalNomina.FieldByName('FechaReingreso').AsDateTime := Now;
      cdPersonalNomina.FieldByName('DIAST').AsInteger := DiasTrabajados;
      cdPersonalNomina.FieldByName('DIASTIMSS').AsInteger := DiasTrabajados;
      cdPersonalNomina.FieldByName('Jornada').AsInteger := Jornada;

    end;
    cdPersonalNomina.FieldByName('TituloSalario').AsString := '*';
    cdPersonalNomina.FieldByName('IdCargo').AsInteger := 1;
    cdPersonalNomina.FieldByName('CodigoCargo').AsString := '*';
    cdPersonalNomina.FieldByName('TituloMoneda').AsString := '*';
    cdPersonalNomina.FieldByName('SalMinDF').AsFloat := SalMinGenDF;;
    cdPersonalNomina.FieldByName('SalMinGenZona').AsFloat := SalMinGenZona;
    cdPersonalNomina.FieldByName('DiasVacaciones').AsInteger := DiasVacaciones;
    cdPersonalNomina.FieldByName('DiasAguinaldo').AsInteger := DiasAguinaldo;
    cdPersonalNomina.FieldByName('FactorPrimaDominical').AsFloat := FactorPrimaDominical;
    cdPersonalNomina.FieldByName('FactorPrimaVacacional').AsFloat := FactorPrimaVacacional;
    cdPersonalNomina.FieldByName('DiasExcentoPrimaVacacional').AsInteger := DiasExcentoPrimaVacacional;
    cdPersonalNomina.FieldByName('DiasExcentoAguinaldo').AsInteger := DiasExcentoAguinaldo;
    cdPersonalNomina.FieldByName('SeguroVidaINFONAVIT').AsFloat := SeguroVidaINFONAVIT;
    cdPersonalNomina.FieldByName('FechaInicio').AsDateTime := Now;
    cdPersonalNomina.FieldByName('FechaTermino').AsDateTime := Now + DiasTrabajados -1;

    cdPersonalNomina.FieldByName('Inasistencias').AsInteger := 0;
    cdPersonalNomina.FieldByName('InasistenciasAguinaldo').AsInteger := 0;
    cdPersonalNomina.FieldByName('InasistenciasVacaciones').AsInteger := 0;
    cdPersonalNomina.FieldByName('HorasExtra').AsFloat := 0;
    cdPersonalNomina.FieldByName('Periodo').AsString := '';
    cdPersonalNomina.FieldByName('EstadoPersonal').AsString := 'Activo';
    cdPersonalNomina.FieldByName('DiaFestivo').AsInteger := DiasFestivos;
    cdPersonalNomina.Post;

    if Not Assigned(cdPersonal) then
    begin
      cdPersonal := TClientDataSet.Create(Nil);
      cdPersonal.FieldDefs.Add('Activo', ftString, 20);
      cdPersonal.FieldDefs.Add('CodigoPersonal', ftString, 10);
      cdPersonal.FieldDefs.Add('Nombres', ftString, 10);
      cdPersonal.FieldDefs.Add('APaterno', ftString, 10);
      cdPersonal.FieldDefs.Add('AMaterno', ftString, 10);
      cdPersonal.FieldDefs.Add('NombreCompleto', ftString, 10);
      cdPersonal.FieldDefs.Add('curp', ftString, 10);
      cdPersonal.FieldDefs.Add('descripcion', ftString, 10);
      cdPersonal.FieldDefs.Add('correo', ftString, 10);
      cdPersonal.FieldDefs.Add('idpersonal', ftInteger);
      cdPersonal.FieldDefs.Add('imagenpersonal', ftString, 10);
      cdPersonal.FieldDefs.Add('Numerosegurosocial', ftString, 10);
      cdPersonal.FieldDefs.Add('fechaalta', ftDate);
      cdPersonal.FieldDefs.Add('Gruposanguineo', ftString, 10);
      cdPersonal.FieldDefs.Add('rfc', ftString, 10);
      cdPersonal.FieldDefs.Add('telefono', ftString, 10);
      cdPersonal.FieldDefs.Add('contacto', ftString, 10);
      cdPersonal.FieldDefs.Add('idpostulante', ftString, 10);
      cdPersonal.FieldDefs.Add('telefonocontacto', ftString, 10);
      cdPersonal.FieldDefs.Add('doccontratacion', ftString, 10);
      cdPersonal.FieldDefs.Add('infonavit', ftString, 10);
      cdPersonal.FieldDefs.Add('NumeroInfonavit', ftString, 10);
      cdPersonal.FieldDefs.Add('FactorInfonavit', ftString, 10);
      cdPersonal.FieldDefs.Add('Estado', ftString, 10);
      cdPersonal.FieldDefs.Add('EstadoCivil', ftString, 10);
      cdPersonal.FieldDefs.Add('estadonacimiento', ftString, 10);
      cdPersonal.FieldDefs.Add('sexo', ftString, 10);
      cdPersonal.FieldDefs.Add('nacionalidad', ftString, 10);
      cdPersonal.FieldDefs.Add('Municipio', ftString, 10);
      cdPersonal.FieldDefs.Add('Calle', ftString, 10);
      cdPersonal.FieldDefs.Add('Numero', ftString, 10);
      cdPersonal.FieldDefs.Add('Colonia', ftString, 10);
      cdPersonal.FieldDefs.Add('fechanacimiento', ftString, 10);
      cdPersonal.FieldDefs.Add('delegacion', ftString, 10);
      cdPersonal.FieldDefs.Add('nombremadre', ftString, 10);
      cdPersonal.FieldDefs.Add('nombrepadre', ftString, 10);
      cdPersonal.FieldDefs.Add('CP', ftString, 10);
      cdPersonal.FieldDefs.Add('FechaReingreso', ftString, 10);
      cdPersonal.FieldDefs.Add('IdPlazaDetalle', ftInteger);
      cdPersonal.FieldDefs.Add('IdCargo', ftInteger);
      cdPersonal.FieldDefs.Add('IdTipoNomina', ftInteger);
      cdPersonal.FieldDefs.Add('CodigoCargo', ftString, 10);
      cdPersonal.FieldDefs.Add('TituloCargo', ftString, 10);
      cdPersonal.FieldDefs.Add('IdDepartamento', ftInteger);
      cdPersonal.FieldDefs.Add('CodigoDepartamento', ftString, 10);
      cdPersonal.FieldDefs.Add('TituloDepartamento', ftString, 10);
      cdPersonal.FieldDefs.Add('DescripcionDepartamento', ftString, 10);
      cdPersonal.FieldDefs.Add('Nivel', ftString, 10);
      cdPersonal.FieldDefs.Add('IdSalario', ftInteger);
      cdPersonal.FieldDefs.Add('CodigoSalario', ftString, 10);
      cdPersonal.FieldDefs.Add('TituloSalario', ftString, 10);
      cdPersonal.FieldDefs.Add('salario', ftFloat);
      cdPersonal.FieldDefs.Add('IdMoneda', ftString, 10);
      cdPersonal.FieldDefs.Add('codigomoneda', ftString, 10);
      cdPersonal.FieldDefs.Add('TituloMoneda', ftString, 10);
      cdPersonal.CreateDataSet;
    end;

    cdPersonal.Append;
    cdPersonal.FieldByName('Activo').AsString := 'Si';
    cdPersonal.FieldByName('CodigoPersonal').AsString := '*';
    cdPersonal.FieldByName('Nombres').AsString := '*';
    cdPersonal.FieldByName('APaterno').AsString := '*';
    cdPersonal.FieldByName('AMaterno').AsString := '*';
    cdPersonal.FieldByName('NombreCompleto').AsString := '*';
    cdPersonal.FieldByName('codigopersonal').AsString := '*';
    cdPersonal.FieldByName('curp').AsString := '*';
    cdPersonal.FieldByName('descripcion').AsString := '*';
    cdPersonal.FieldByName('correo').AsString := '*';
    cdPersonal.FieldByName('idpersonal').AsInteger := -9;
    cdPersonal.FieldByName('imagenpersonal').AsString := '';
    cdPersonal.FieldByName('Numerosegurosocial').AsString := '*';
    cdPersonal.FieldByName('fechaalta').AsDateTime := Now;
    cdPersonal.FieldByName('Gruposanguineo').AsString := '*';
    cdPersonal.FieldByName('rfc').AsString := '*';
    cdPersonal.FieldByName('telefono').AsString := '*';
    cdPersonal.FieldByName('contacto').AsString := '*';
    cdPersonal.FieldByName('idpostulante').AsInteger := 1;
    cdPersonal.FieldByName('telefonocontacto').AsString := '*';
    cdPersonal.FieldByName('doccontratacion').AsString := '*';
    cdPersonal.FieldByName('infonavit').AsString := '*';
    cdPersonal.FieldByName('NumeroInfonavit').AsString := '*';
    cdPersonal.FieldByName('FactorInfonavit').AsFloat := 0;
    cdPersonal.FieldByName('Estado').AsString := '*';
    cdPersonal.FieldByName('EstadoCivil').AsString := '*';
    cdPersonal.FieldByName('estadonacimiento').AsString := '*';
    cdPersonal.FieldByName('numerosegurosocial').AsString := '*';
    cdPersonal.FieldByName('sexo').AsString := '*';
    cdPersonal.FieldByName('nacionalidad').AsString := '*';
    cdPersonal.FieldByName('Municipio').AsString := '*';
    cdPersonal.FieldByName('Calle').AsString := '*';
    cdPersonal.FieldByName('Numero').AsString := '*';
    cdPersonal.FieldByName('Colonia').AsString := '*';
    cdPersonal.FieldByName('fechanacimiento').AsString := '*';
    cdPersonal.FieldByName('delegacion').AsString := '*';
    cdPersonal.FieldByName('nombremadre').AsString := '*';
    cdPersonal.FieldByName('nombrepadre').AsString := '*';
    cdPersonal.FieldByName('CP').AsString := '*';
    cdPersonal.FieldByName('Correo').AsString := '*';
    cdPersonal.FieldByName('FechaReingreso').AsString := '*';
    cdPersonal.FieldByName('IdPlazaDetalle').AsInteger := 1;
    cdPersonal.FieldByName('IdCargo').AsInteger := 1;
    cdPersonal.FieldByName('IdTipoNomina').AsInteger := 1;
    cdPersonal.FieldByName('CodigoCargo').AsString := '*';
    cdPersonal.FieldByName('TituloCargo').AsString := '*';
    cdPersonal.FieldByName('IdDepartamento').AsInteger := 1;
    cdPersonal.FieldByName('CodigoDepartamento').AsString := '*';
    cdPersonal.FieldByName('TituloDepartamento').AsString := '*';
    cdPersonal.FieldByName('DescripcionDepartamento').AsString := '*';
    cdPersonal.FieldByName('Nivel').AsString := '*';
    cdPersonal.FieldByName('IdSalario').AsInteger := 1;
    cdPersonal.FieldByName('CodigoSalario').AsString := '*';
    cdPersonal.FieldByName('TituloSalario').AsString := '*';
    cdPersonal.FieldByName('salario').AsFloat := AproxSalario;
    cdPersonal.FieldByName('IdMoneda').AsInteger := 1;
    cdPersonal.FieldByName('codigomoneda').AsString := '*';
    cdPersonal.FieldByName('TituloMoneda').AsString := '*';
    cdPersonal.Post;

    if Not Assigned(cdgcConcepto) then
    begin
      cdgcConcepto := TClientDataSet.Create(Nil);
      CrearConjunto(cdgcConcepto, 'nom_concepto', ccCatalog);
    end;

    if Assigned(cdgcConcepto) and (cdgcConcepto.ProviderName <> '') and ((Not cdgcConcepto.Active) or ((cdgcConcepto.Active) and (cdgcConcepto.FieldByName('IdTipoNomina').AsInteger <> IdTipoNomina))) then
    begin
      CargarDatosFiltrados(cdgcConcepto, 'IdTipoNomina', [IdTipoNomina]);
      if cdgcConcepto.Active then
        cdgcConcepto.Refresh
      else
        cdgcConcepto.Open;
    end;

    cdConceptoExtra := TClientDataSet.Create(Nil);
    Try
      CrearConjunto(cdConceptoExtra, 'nom_conceptosextraxempleado', ccCatalog);
      CargarDatosFiltrados(cdConceptoExtra, 'IdPersonal', [-9]);
      cdConceptoExtra.Open; // Traerse la estructura
    Finally
      cdConceptoExtra.Close;
      EliminarConjunto(cdConceptoExtra);
      cdConceptoExtra.ProviderName := '';
      cdConceptoExtra.CreateDataSet;
      cdConceptoExtra.Open;
    End;

    cdSumaConcepto := TClientDataSet.Create(Nil);
    CrearConjunto(cdSumaConcepto, 'nom_detallenomina_suma', ccCatalog);
    if Assigned(memPercepciones) then
    begin
      memPercepciones := TClientDataSet.Create(Nil);
      memPercepciones.FieldDefs.Add('IdPersonal', ftInteger, 0, False);
      memPercepciones.FieldDefs.Add('CodigoConcepto', ftString, 6, False);
      memPercepciones.FieldDefs.Add('Titulo', ftString, 20, False);
      memPercepciones.FieldDefs.Add('Nombre', ftString, 80, False);
      memPercepciones.FieldDefs.Add('Modo', ftString, 20, False);
      memPercepciones.FieldDefs.Add('Importe', ftFloat, 0, False);
      memPercepciones.CreateDataSet;
      memPercepciones.Open;
    end;


    if Assigned(memDeducciones) then
    begin
      memDeducciones := TClientDataSet.Create(Nil);
      memDeducciones.FieldDefs.Add('IdPersonal', ftInteger, 0, False);
      memDeducciones.FieldDefs.Add('CodigoConcepto', ftString, 6, False);
      memDeducciones.FieldDefs.Add('Titulo', ftString, 20, False);
      memDeducciones.FieldDefs.Add('Nombre', ftString, 80, False);
      memDeducciones.FieldDefs.Add('Modo', ftString, 20, False);
      memDeducciones.FieldDefs.Add('Importe', ftFloat, 0, False);
      memDeducciones.CreateDataSet;
      memDeducciones.Open;
    end;

    //Foco Rojo
    cdDetalleSave := TClientDataSet.Create(Nil);
    cdDetalleSave.Name := 'CdDetalleSaveX';
    Try
      if Not CrearConjunto(cdDetalleSave, 'nom_detallenomina', ccUpdate) then
        raise InteligentException.CreateByCode(5, ['Detalle de N�mina']);

      if Not CargarDatosFiltrados(cdDetalleSave, 'IdPersonal', [-9]) then
        raise InteligentException.CreateByCode(21, ['Detalle de N�mina']);

      cdDetalleSave.Open;   // Traer la estructura de la tabla
    Finally
      cdDetalleSave.Close;
      EliminarConjunto(cdDetalleSave);
      cdDetalleSave.ProviderName := '';
      cdDetalleSave.CreateDataSet;
      cdDetalleSave.Open;
    End;

    cdDetalle := TClientDataSet.Create(Nil);
    cdDetalle.FieldDefs.Add('IdDetalleNomina', ftInteger);
    cdDetalle.FieldDefs.Add('IdOrganizacion', ftInteger);
    cdDetalle.FieldDefs.Add('IdPersonal', ftInteger);
    cdDetalle.FieldDefs.Add('IdNomina', ftInteger);
    cdDetalle.FieldDefs.Add('IdCargo', ftInteger);
    cdDetalle.FieldDefs.Add('IdDepartamento', ftInteger);
    cdDetalle.FieldDefs.Add('IdFormaPago', ftInteger);
    cdDetalle.FieldDefs.Add('CodigoConcepto', ftString, 100);
    cdDetalle.FieldDefs.Add('IdGrupoConcepto', ftInteger);
    cdDetalle.FieldDefs.Add('Clave', ftString, 100);
    cdDetalle.FieldDefs.Add('Titulo', ftString, 100);
    cdDetalle.FieldDefs.Add('Descripcion', ftString, 100);
    cdDetalle.FieldDefs.Add('Modo', ftString, 100);
    cdDetalle.FieldDefs.Add('Imprime', ftString, 2);
    cdDetalle.FieldDefs.Add('Valor', ftString, 100);
    cdDetalle.FieldDefs.Add('Cargo', ftString, 100);

    cdDetalle.CreateDataSet;

    if Not Assigned(memPercepciones) then
    begin
      memPercepciones := TClientDataSet.Create(Nil);
      memPercepciones.FieldDefs.Add('IdPersonal', ftInteger, 0, False);
      memPercepciones.FieldDefs.Add('CodigoConcepto', ftString, 6, False);
      memPercepciones.FieldDefs.Add('Titulo', ftString, 20, False);
      memPercepciones.FieldDefs.Add('Nombre', ftString, 80, False);
      memPercepciones.FieldDefs.Add('Modo', ftString, 20, False);
      memPercepciones.FieldDefs.Add('Importe', ftFloat, 0, False);
      memPercepciones.CreateDataSet;
      memPercepciones.Open;
    end;

    if Not Assigned(memDeducciones) then
    begin
      memDeducciones := TClientDataSet.Create(Nil);
      memDeducciones.FieldDefs.Add('IdPersonal', ftInteger, 0, False);
      memDeducciones.FieldDefs.Add('CodigoConcepto', ftString, 6, False);
      memDeducciones.FieldDefs.Add('Titulo', ftString, 20, False);
      memDeducciones.FieldDefs.Add('Nombre', ftString, 80, False);
      memDeducciones.FieldDefs.Add('Modo', ftString, 20, False);
      memDeducciones.FieldDefs.Add('Importe', ftFloat, 0, False);
      memDeducciones.CreateDataSet;
      memDeducciones.Open;
    end;
  Finally
    Screen.Cursor := Cursor;
  End;
end;
function DescargarPlantilla(var DatasetPlantilla: TClientDataSet; postfijo: String; Ruta: String): String;
var
  NombreArchivo: string;
  Stream: TStream;
  StreamHead: TStringStream;
  PosicionStr: Int64;
begin
  //generando el nombre del archivo, encaso de no existir directorio crearlo
  NombreArchivo := ExtractFilePath(Application.ExeName) + 'Temp';
  if not DirectoryExists(NombreArchivo) then
    MkDir(NombreArchivo);

  NombreArchivo := Nombrearchivo + Ruta;

  if not DirectoryExists(NombreArchivo) then
    MkDir(NombreArchivo);

  NombreArchivo:= NombreArchivo + DatasetPlantilla.FieldByName('NombreMachote').AsString + '_' + postfijo + '.xls';
  stream := DatasetPlantilla.CreateBlobStream(DatasetPlantilla.FieldByName('Machote'), bmRead);
  PosicionStr := stream.Position;
  try
    //Si el archivo existe verificar fecha y cargarlo
    if (FileExists(NombreArchivo)) then
    begin
      TBlobField(DatasetPlantilla.FieldByName('Machote')).SaveToFile(NombreArchivo);
    end
    else
    begin
      //Preguntar a Rangel que hacer en ambos casos
      TBlobField(DatasetPlantilla.FieldByName('Machote')).SaveToFile(NombreArchivo);
    end;
    Result := NombreArchivo;
  except
    on e:exception do
    begin
      InteliDialog.ShowModal('Ha ocurrido un error inesperado', 'Informe de lo siguiente al administrador del sistema:' + #10 + #10 + e.Message, mtError, [mbOk], 0);
    end;
  end;
end;

procedure pLocalImprimeReporte(cdDatos: TclientDataSet; RCount : Integer; SCount : Integer; ModuloPantalla: String);
var
 CdImprimir: Tclientdataset;
 opc: integer;
begin
  try
    if (length(trim(Reporte)) > 0) and (CompReporte <> nil) and (CompDatasetReporte <> nil) then
    begin
      if CdDatos.State <> dsBrowse then
        raise InteligentWarning.CreateByCode(26, [ModuloPantalla]);

      if RCount < 1 Then
        raise InteligentWarning.CreateByCode(22, [ModuloPantalla]);

      if SCount > 1 Then
        raise InteligentWarning.CreateByCode(25, [ModuloPantalla]);

      if not ClientModule1.LeePermisos(ModuloPantalla,'IMPRIMIR') then
        Exit;

      //si se esta usando la paginacion en el formulario entonces se debe
      //preguntar al usuario si se decea incluir todos los registros, si es necesario
      //se crea otra consulta para el puro reporte y traer todos los registros
      //en caso contrario se trabaja con el dataset creado para llenar el grid
      if (UsePaginacion) and (PBPaginacion.Position < 100)  then
      begin
        opc := InteliDialog.ShowModal('Usted est� viendo s�lo el '+inttostr(PBPaginacion.Position)+'% del total de los registros.', '�Des�a usted que el reporte incluya el '+inttostr(100-PBPaginacion.Position)+'% restante de la informaci�n (puede que esto tome algunos minutos)?', mtInformation, [mbYes, mbNo, mbCancel], 0);
        case opc of
          mrYes :
            begin
              CdImprimir := TClientDataSet.Create(nil);
              try
                if not CrearConjunto(CdImprimir,entityName,ccCatalog) then
                  raise InteligentConnection.CreateByCode(5, [ModuloPantalla]);

                try
                  CdImprimir.Open;
                  CompDatasetReporte.DataSet := CdImprimir;
                  ClientModule1.ImprimeReporte(Reporte,CompReporte);
                finally
                  EliminarConjunto(CdImprimir);
                end;

              finally
                FreeAndNil(CdImprimir);
              end;
            end;
          mrNo :
            begin
              CompDatasetReporte.DataSet := cdDatos;
              ClientModule1.ImprimeReporte(Reporte, CompReporte);
            end;
          mrCancel:
            begin
              ;
            end;
        end;
      end
      else
      begin
        CompDatasetReporte.DataSet := cdDatos;
        ClientModule1.ImprimeReporte(Reporte, CompReporte);
      end;
    end;
  except
    on e:exception do
      InteliDialog.ShowModal('No se puede imprimir por el siguiente motivo: ',e.message, mtInformation, [mbOk], 0);
  end;
end;

procedure LocalImprimeReporte(cdDatos: TclientDataSet; Grid: TNextDBGrid; ModuloPantalla: String); overload;
begin
  pLocalImprimeReporte(cdDatos, cdDatos.RecordCount, Grid.SelectedCount, ModuloPantalla);
end;

procedure LocalImprimeReporte(cdDatos: TclientDataSet; Grid: TcxDBPivotGrid; ModuloPantalla: String); overload;
begin
  pLocalImprimeReporte(cdDatos, cdDatos.RecordCount, Grid.DataController.GetSelectedCount, ModuloPantalla);
end;

procedure LocalImprimeReporte(cdDatos: TclientDataSet; Grid: TcxGridDBTableView; ModuloPantalla: String); overload;
begin
  pLocalImprimeReporte(cdDatos, cdDatos.RecordCount, Grid.DataController.GetSelectedCount, ModuloPantalla);
end;

procedure LocalImprimeReporte(cdDatos: TclientDataSet; Grid: TDBGrid; ModuloPantalla: String); overload;
begin
  pLocalImprimeReporte(cdDatos, cdDatos.RecordCount, Grid.SelectedRows.Count , ModuloPantalla);
end;

procedure LocalImprimeReporte(cdDatos: TclientDataSet; Grid: TcxGridDBCardView; ModuloPantalla: String); overload;
begin
  pLocalImprimeReporte(cdDatos, cdDatos.RecordCount, Grid.DataController.GetSelectedCount , ModuloPantalla);
end;

end.
