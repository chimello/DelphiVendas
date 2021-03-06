unit uProVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  uDTMConexao, uDTMVenda, RxToolEdit, RxCurrEdit, uEnum, cProVenda;

type
  TfrmProVenda = class(TfrmTelaHeranca)
    qryListagemvendaId: TIntegerField;
    qryListagemclienteId: TIntegerField;
    qryListagemnome: TWideStringField;
    qryListagemdataVenda: TDateTimeField;
    qryListagemtotalVenda: TFloatField;
    edtVendaId: TLabeledEdit;
    lblCategoria: TLabel;
    lkpCliente: TDBLookupComboBox;
    edtDataVenda: TDateEdit;
    Label3: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    edtValorTotal: TCurrencyEdit;
    lblValor: TLabel;
    dbGridItensVendas: TDBGrid;
    lkpProduto: TDBLookupComboBox;
    Label1: TLabel;
    edtQuantidade: TCurrencyEdit;
    lblQuantidade: TLabel;
    Label2: TLabel;
    edtUnitario: TCurrencyEdit;
    edtValorTotalProduto: TCurrencyEdit;
    Label4: TLabel;
    btnAdicionarProduto: TBitBtn;
    btnRemoverProduto: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbGridItensVendasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdListagemKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAdicionarProdutoClick(Sender: TObject);
    procedure edtUnitarioExit(Sender: TObject);
    procedure edtQuantidadeExit(Sender: TObject);
    procedure lkpProdutoExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnRemoverProdutoClick(Sender: TObject);
    procedure dbGridItensVendasDblClick(Sender: TObject);
  private
    { Private declarations }
    uDTMVenda: TdtmVenda;
    oVenda:Tvenda;
    function Gravar(EstadoDoCadastro:TEstadoDoCadastro):Boolean; override;
    function Apagar:Boolean; override;
    function TotalizarProduto(ValorUnitario, Quantidade: Double): Double;
    procedure LimparComponenteItem;
    procedure LimpaCds;
    procedure carregarRegistroSelecionado;
    function TotalizarVenda: Double;
  public
    { Public declarations }
  end;

var
  frmProVenda: TfrmProVenda;

implementation

{$R *.dfm}

{$REGION 'Override'}

function TfrmProVenda.Apagar:Boolean;
begin
  if (oVenda.Selecionar(qryListagem.FieldByName('vendaid').AsInteger, dtmVenda.cdsItensVenda)) then
  begin
    Result:=oVenda.Apagar;
  end;
end;

function TfrmProVenda.Gravar(EstadoDoCadastro: TEstadoDoCadastro):Boolean;
begin
  if edtVendaId.Text<>EmptyStr then
  begin
    oVenda.VendaId:=StrToInt(edtVendaId.Text);
  end
  else
  begin
    oVenda.VendaId:=0;
  end;
  oVenda.clienteid := lkpCliente.KeyValue;
  oVenda.dataVenda := edtDataVenda.Date;
  oVenda.totalVenda := edtValorTotal.Value;

  if (dtmVenda.cdsItensVenda.IsEmpty) then
  begin
    MessageDlg('N?o ? poss?vel salvar uma venda sem produtos!', mtConfirmation, [mbOk],0);
    lkpProduto.SetFocus;
    Abort;
  end;

  if (EstadoDoCadastro=ECInserir) then
  begin
    Result:=oVenda.Inserir(dtmVenda.cdsItensVenda);
  end
  else if (EstadoDoCadastro=ECAlterar) then
  begin
    Result:=oVenda.Atualizar(dtmVenda.cdsItensVenda);
  end; 
  end;

{$ENDREGION}

procedure TfrmProVenda.btnAdicionarProdutoClick(Sender: TObject);
begin
  inherited;
  if (lkpProduto.KeyValue = null) then
  begin
    MessageDlg('Produto ? um campo obrigat?rio', mtConfirmation, [mbOK],0);
    lkpProduto.SetFocus;
    Abort;
  end;

  if (edtQuantidade.Value <= 0) then
  begin
    MessageDlg('Quantidade deve ser maior que zero', mtInformation, [mbOK],0);
    edtQuantidade.SetFocus;
    Abort;
  end;

  if (edtUnitario.Value <= 0) then
  begin
    MessageDlg('Valor unit?rio deve ser maior que zero', mtInformation, [mbOK],0);
    edtUnitario.SetFocus;
    Abort;
  end;

  if (dtmVenda.cdsItensVenda.Locate('produtoId', lkpProduto.KeyValue, [])) then
  begin
    MessageDlg('Este produto j? foi selecionado', mtInformation, [mbOK],0);
    lkpProduto.SetFocus;
    Abort;
  end;
  edtValorTotalProduto.Value := TotalizarProduto(edtUnitario.Value, edtQuantidade.Value);

  if (dtmVenda.qryProdutos.FieldByName('valor').Value <> edtUnitario.Value) then
  begin
    case MessageDlg('Valor unit?rio diferente do Cadastrado, continuar?',
              mtConfirmation, [mbYes, mbNo],0) of
    mrNo :
      begin
    edtUnitario.Value := dtmVenda.qryProdutos.FieldByName('valor').AsFloat;
    Abort;
      end;
    end;
  end;

  dtmVenda.cdsItensVenda.Append;
  dtmVenda.cdsItensVenda.FieldByName('produtoId').AsString := lkpProduto.KeyValue;
  dtmVenda.cdsItensVenda.FieldByName('nomeProduto').AsString := dtmVenda.qryProdutos.FieldByName('nome').AsString;
  dtmVenda.cdsItensVenda.FieldByName('quantidade').AsFloat := edtQuantidade.Value;
  dtmVenda.cdsItensVenda.FieldByName('valorUnitario').AsFloat := edtUnitario.Value;
  dtmVenda.cdsItensVenda.FieldByName('valorTotalProduto').AsFloat := edtValorTotalProduto.Value;
  dtmVenda.cdsItensVenda.Post;
  edtValorTotal.Value := TotalizarVenda;
  LimparComponenteItem;
  lkpProduto.SetFocus;
end;

procedure TfrmProVenda.LimparComponenteItem;
begin
  lkpProduto.KeyValue := null;
  edtQuantidade.Value := 0;
  edtUnitario.Value := 0;
  edtValorTotalProduto.Value := 0;
end;

function TfrmProVenda.TotalizarProduto(ValorUnitario, Quantidade:Double):Double;
begin
  Result := ValorUnitario * Quantidade;
end;

procedure TfrmProVenda.LimpaCds;
begin
  dtmVenda.cdsItensVenda.First;
  while not(dtmVenda.cdsItensVenda.Eof) do
  begin
  dtmVenda.cdsItensVenda.Delete;
  end;
end;

procedure TfrmProVenda.btnAlterarClick(Sender: TObject);
begin
  if (oVenda.Selecionar(qryListagem.FieldByName('vendaId').AsInteger,dtmVenda.cdsItensVenda)) then
  begin
    edtVendaId.Text         := IntToStr(oVenda.VendaId);
    lkpCliente.KeyValue     := oVenda.clienteid;
    edtDataVenda.Date       := oVenda.dataVenda;
    edtValorTotal.Value     := oVenda.totalVenda;
  end
  else 
  begin
    btnCancelar.Click;
    Abort;
  end;
  inherited;
end;

procedure TfrmProVenda.btnCancelarClick(Sender: TObject);
begin
  inherited;

  LimpaCds;
end;

procedure TfrmProVenda.btnGravarClick(Sender: TObject);
begin
  if (lkpCliente.Text = '') then
  begin
    ShowMessage('Informe um cliente antes de Gravar a venda');
    lkpCliente.SetFocus;
    Abort;
  end;
  inherited;
  LimpaCds;
end;

procedure TfrmProVenda.btnNovoClick(Sender: TObject);
begin
  inherited;
  edtDataVenda.Date := Date;
  lkpCliente.SetFocus;
  LimpaCds;
end;

procedure TfrmProVenda.btnRemoverProdutoClick(Sender: TObject);
begin
  inherited;
  if (lkpProduto.KeyValue = null) then
  begin
    MessageDlg('Duplo clique no produto a ser removido', mtConfirmation, [mbOK],0);
    dbGridItensVendas.SetFocus;
    Abort;
  end;

  if (dtmVenda.cdsItensVenda.Locate('produtoid', lkpProduto.KeyValue, [])) then
  begin
    dtmVenda.cdsItensVenda.Delete;
    edtValorTotal.Value :=  TotalizarVenda;
    LimparComponenteItem;
  end;


end;

procedure TfrmProVenda.dbGridItensVendasDblClick(Sender: TObject);
begin
  inherited;
  carregarRegistroSelecionado;
end;

procedure TfrmProVenda.dbGridItensVendasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  BloqueiaCTRL_DEL_DBGrid(Key, Shift);
end;

procedure TfrmProVenda.edtQuantidadeExit(Sender: TObject);
begin
  inherited;
  edtValorTotalProduto.Value := TotalizarProduto(edtUnitario.Value, edtQuantidade.Value);
end;

procedure TfrmProVenda.edtUnitarioExit(Sender: TObject);
begin
  inherited;
  edtValorTotalProduto.Value := TotalizarProduto(edtUnitario.Value, edtQuantidade.Value);
end;

procedure TfrmProVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned(dtmVenda) then
  begin
    FreeAndNil(dtmVenda);
  end;

  if Assigned(oVenda) then
  begin
    FreeAndNil(oVenda);
  end;

end;

procedure TfrmProVenda.FormCreate(Sender: TObject);
begin
  inherited;
  dtmVenda:=TdtmVenda.Create(Self);
  oVenda := Tvenda.Create(dtmPrincipal.conexaoDB);

  IndiceAtual := 'vendaid';
end;

procedure TfrmProVenda.grdListagemKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  BloqueiaCTRL_DEL_DBGrid(Key, Shift);
end;

procedure TfrmProVenda.lkpProdutoExit(Sender: TObject);
begin
  inherited;
  if (TDBLookupComboBox(Sender).KeyValue <> null) then
  begin
    edtUnitario.Value          := dtmVenda.qryProdutos.FieldByName('valor').AsFloat;
    edtQuantidade.Value        := 1;
    edtValorTotalProduto.Value := TotalizarProduto(edtUnitario.Value, edtQuantidade.Value);
  end;
end;

procedure TfrmProVenda.carregarRegistroSelecionado();
begin
  lkpProduto.KeyValue        := dtmVenda.cdsItensVenda.FieldByName('produtoid').AsString;
  edtQuantidade.Value        := dtmVenda.cdsItensVenda.FieldByName('quantidade').AsFloat;
  edtUnitario.Value          := dtmVenda.cdsItensVenda.FieldByName('valorUnitario').AsFloat;
  edtValorTotalProduto.Value := dtmVenda.cdsItensVenda.FieldByName('valortotalProduto').AsFloat;
end;

function TfrmProVenda.TotalizarVenda:Double;
begin
Result := 0;
  dtmVenda.cdsItensVenda.First;
  while not(dtmVenda.cdsItensVenda.Eof) do begin
    Result := Result + dtmVenda.cdsItensVenda.FieldByName('valorTotalProduto').AsFloat;
    dtmVenda.cdsItensVenda.Next;
  end;
end;

end.
