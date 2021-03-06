unit uTelaHeranca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB,
  Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, uDTMConexao, uEnum,
  RxToolEdit, RxCurrEdit;

type
  TfrmTelaHeranca = class(TForm)
    pnlRodape: TPanel;
    pgcPrincipal: TPageControl;
    tabListagem: TTabSheet;
    tabManutencao: TTabSheet;
    pnlListagemTopo: TPanel;
    mskPesquisar: TMaskEdit;
    btnPesquisar: TBitBtn;
    grdListagem: TDBGrid;
    btnNovo: TBitBtn;
    btnAlterar: TBitBtn;
    btnCancelar: TBitBtn;
    btnGravar: TBitBtn;
    btnApagar: TBitBtn;
    btnFechar: TBitBtn;
    btnNavigator: TDBNavigator;
    qryListagem: TZQuery;
    dtsListagem: TDataSource;
    lblIndice: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdListagemTitleClick(Column: TColumn);
    procedure mskPesquisarChange(Sender: TObject);
    procedure grdListagemDblClick(Sender: TObject);
    procedure grdListagemKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }


    procedure ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar,
      btnApagar: TBitBtn; Navegador: TDBNavigator; pgcPrincipal: TPageControl;
      flag: Boolean);

    procedure ControlarIndiceTAB(pgPrincipal: TPageControl; indice: integer);
    function RetornarCampoTraduzido(Campo: String): string;
    procedure ExibirLabelIndice(Campo: String; aLabel: TLabel);
    function ExisteCampoObrigatorio: Boolean;
    procedure DesabilitarEditPK;
    procedure LimparEdits;
  public
    { Public declarations }
    IndiceAtual: string;
    EstadoDoCadastro: TEstadoDoCadastro;
    function Apagar: Boolean; virtual;
    function Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean; virtual;
    procedure BloqueiaCTRL_DEL_DBGrid(var Key: Word; Shift: TShiftState);
  end;

var
  frmTelaHeranca: TfrmTelaHeranca;

implementation

{$R *.dfm}
{$REGION 'OBSERVA??ES'}
// Tag:1 = Chave Primaria
// Tag:2 = Campo Obrigat?rios

{$ENDREGION}

procedure TfrmTelaHeranca.btnNovoClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar,
    btnNavigator, pgcPrincipal, false);
  EstadoDoCadastro := ECInserir;
  LimparEdits;
  pgcPrincipal.Pages[1].TabVisible := true;
end;

procedure TfrmTelaHeranca.btnAlterarClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar,
    btnNavigator, pgcPrincipal, false);
  EstadoDoCadastro := ECAlterar;
  pgcPrincipal.Pages[1].TabVisible := true;
end;

procedure TfrmTelaHeranca.btnApagarClick(Sender: TObject);
begin
  Try
    if (Apagar) then
    begin
      ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar,
        btnNavigator, pgcPrincipal, true);
      ControlarIndiceTAB(pgcPrincipal, 0);
      LimparEdits;
      qryListagem.Refresh;
    end
    else
    begin
      MessageDlg('Erro na Exclus?o', mtError, [mbOK], 0);
    end;
  Finally
    EstadoDoCadastro := ECNenhum;
  End;
end;

procedure TfrmTelaHeranca.btnCancelarClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar,
    btnNavigator, pgcPrincipal, true);
  ControlarIndiceTAB(pgcPrincipal, 0);
  EstadoDoCadastro := ECNenhum;
  LimparEdits;
  pgcPrincipal.Pages[1].TabVisible := false;
end;

procedure TfrmTelaHeranca.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTelaHeranca.btnGravarClick(Sender: TObject);
begin
  if (ExisteCampoObrigatorio) then
  begin
    Abort;
  end;

  Try

    if (Gravar(EstadoDoCadastro)) then
    begin
      ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar,
        btnNavigator, pgcPrincipal, true);
      ControlarIndiceTAB(pgcPrincipal, 0);
      EstadoDoCadastro := ECNenhum;
      LimparEdits;
      qryListagem.Refresh;
    end
    else
    begin
      MessageDlg('Erro na Grava??o', mtError, [mbOK], 0);
    end;
  Finally

  End;
  pgcPrincipal.Pages[1].TabVisible := false;
end;

procedure TfrmTelaHeranca.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  qryListagem.Close;
end;

procedure TfrmTelaHeranca.FormCreate(Sender: TObject);
begin
  qryListagem.Connection := dtmPrincipal.conexaoDB;
  dtsListagem.DataSet := qryListagem;
  grdListagem.DataSource := dtsListagem;
  btnNavigator.DataSource := dtsListagem;
  grdListagem.Options := [dgTitles, dgIndicator, dgColumnResize, dgColLines,
    dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit,
    dgTitleClick, dgTitleHotTrack];
end;

procedure TfrmTelaHeranca.FormShow(Sender: TObject);
begin
  if (qryListagem.SQL.Text <> EmptyStr) then
  begin
    qryListagem.IndexFieldNames := IndiceAtual;
    ExibirLabelIndice(IndiceAtual, lblIndice);
    qryListagem.Open;
  end;
  ControlarIndiceTAB(pgcPrincipal, 0);
  DesabilitarEditPK;
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar,
  btnNavigator, pgcPrincipal, true);
  pgcPrincipal.Pages[1].TabVisible := false;
end;

procedure TfrmTelaHeranca.grdListagemDblClick(Sender: TObject);
begin
  btnAlterar.Click;
end;

procedure TfrmTelaHeranca.grdListagemKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BloqueiaCTRL_DEL_DBGrid(Key, Shift);
end;

procedure TfrmTelaHeranca.grdListagemTitleClick(Column: TColumn);
begin
  IndiceAtual := Column.FieldName;
  qryListagem.IndexFieldNames := IndiceAtual;
  ExibirLabelIndice(IndiceAtual, lblIndice);
end;

procedure TfrmTelaHeranca.mskPesquisarChange(Sender: TObject);
begin
  QryListagem.Locate(IndiceAtual, TMaskEdit(Sender).Text, [loCaseInsensitive, loPartialKey]);
end;

// procedimento de controle de tela
procedure TfrmTelaHeranca.ControlarBotoes(btnNovo, btnAlterar, btnCancelar,
  btnGravar, btnApagar: TBitBtn; Navegador: TDBNavigator;
  pgcPrincipal: TPageControl; flag: Boolean);
begin
  btnNovo.Enabled := flag;
  btnApagar.Enabled := flag;
  btnAlterar.Enabled := flag;
  Navegador.Enabled := flag;
  pgcPrincipal.Pages[0].TabVisible := flag;
  btnCancelar.Enabled := not(flag);
  btnGravar.Enabled := not(flag);
end;

procedure TfrmTelaHeranca.ControlarIndiceTAB(pgPrincipal: TPageControl;
  indice: integer);
begin
  if (pgcPrincipal.Pages[indice].TabVisible) then
  begin
    pgcPrincipal.TabIndex := indice;
  end;

end;

function TfrmTelaHeranca.RetornarCampoTraduzido(Campo: String): string;
var
  i: integer;
begin
  for i := 0 to qryListagem.Fields.Count - 1 do
  begin
    if (LowerCase(qryListagem.Fields[i].FieldName) = LowerCase(Campo)) then
    begin
      Result := qryListagem.Fields[i].DisplayLabel;
      Break;
    end;

  end;

end;

function TfrmTelaHeranca.Apagar: Boolean;
begin
  ShowMessage('Deletado');
end;

function TfrmTelaHeranca.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  if (EstadoDoCadastro = ECInserir) then
  begin
    ShowMessage('Inserir');
  end
  else if (EstadoDoCadastro = ECAlterar) then
  begin
    ShowMessage('Alterado');
  end;
  Result := true;
end;

procedure TfrmTelaHeranca.ExibirLabelIndice(Campo: String; aLabel: TLabel);
begin
  aLabel.Caption := RetornarCampoTraduzido(Campo);
end;

function TfrmTelaHeranca.ExisteCampoObrigatorio: Boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TLabeledEdit) then
    begin
      if ((TLabeledEdit(Components[i]).Tag = 2) and
        (TLabeledEdit(Components[i]).Text = EmptyStr)) then
      begin
        MessageDlg(TLabeledEdit(Components[i]).EditLabel.Caption +
          ' ? um campo obrigat?rio', mtInformation, [mbOK], 0);
        TLabeledEdit(Components[i]).SetFocus;
        Result := true;
        Break;
      end;
    end;
  end;
end;

procedure TfrmTelaHeranca.DesabilitarEditPK;
var
  i: integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TLabeledEdit) then
    begin
      if ((TLabeledEdit(Components[i]).Tag = 1)) then
      begin
        TLabeledEdit(Components[i]).Enabled := false;
        Break;
      end;
    end;
  end;
end;

procedure TfrmTelaHeranca.LimparEdits;
var
  i: integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TLabeledEdit) then
      begin
        TLabeledEdit(Components[i]).Text:= EmptyStr;
      end
      else if (Components[i] is TEdit) then
      begin
        TEdit(Components[i]).Text:= EmptyStr;
      end
      else if (Components[i] is TMaskEdit) then
      begin
        TMaskEdit(Components[i]).Text := EmptyStr;
      end
      else if (Components[i] is TDateEdit) then
      begin
        TDateEdit(Components[i]).Text := EmptyStr;
      end
      else if (Components[i] is TMemo) then
      begin
        TMemo(Components[i]).Text := EmptyStr;
      end
      else if (Components[i] is TDBLookupComboBox) then
      begin
        TDBLookupComboBox(Components[i]).KeyValue := null;
      end
      else if (Components[i] is TCurrencyEdit) then
      begin
        TCurrencyEdit(Components[i]).Value := 0.00;
      end
      else if (Components[i] is TRadioButton) then
      begin
        TRadioButton(Components[i]).Checked := False;
      end;
  end;

end;

procedure TfrmTelaHeranca.BloqueiaCTRL_DEL_DBGrid(var Key: Word; Shift: TShiftState);
begin
  // Bloqueia o CTRL + DEL
  if ((Shift = [ssCtrl]) and (Key = 46)) then
  begin
    Key := 0;
  end;

end;

end.
