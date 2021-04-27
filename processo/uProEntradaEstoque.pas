unit uProEntradaEstoque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  RxToolEdit, uDTMConexao, uDTMEntradaEstoque, uEnum, RxCurrEdit, cProEntradaEstoque;

type
  TfrmProEntradaEstoque = class(TfrmTelaHeranca)
    qryListagemcodiestoque: TIntegerField;
    qryListagemnome: TWideStringField;
    qryListagemdataEntrada: TDateTimeField;
    qryListagemValorTotal: TFloatField;
    edtDataEntrada: TDateEdit;
    lkpFornecedor: TDBLookupComboBox;
    edtCodiEstoque: TLabeledEdit;
    lblFornecedor: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    lkpProduto: TDBLookupComboBox;
    Label1: TLabel;
    lblQuantidade: TLabel;
    edtQuantidade: TCurrencyEdit;
    edtUnitario: TCurrencyEdit;
    Label2: TLabel;
    edtValorTotalProduto: TCurrencyEdit;
    Label4: TLabel;
    btnAdicionarProduto: TBitBtn;
    btnRemoverProduto: TBitBtn;
    Panel3: TPanel;
    dbGridItensEntradaEstoque: TDBGrid;
    edtHistoricoEntrada: TMemo;
    lblValor: TLabel;
    edtValorTotalEntrada: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnAdicionarProdutoClick(Sender: TObject);
    procedure lkpProdutoExit(Sender: TObject);
    procedure edtQuantidadeExit(Sender: TObject);
    procedure edtUnitarioChange(Sender: TObject);
    procedure btnRemoverProdutoClick(Sender: TObject);
    procedure dbGridItensEntradaEstoqueDblClick(Sender: TObject);
    procedure dbGridItensEntradaEstoqueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    uDTMEntradaEstoque :TDTMEntradaEstoque;
    oEntradaEstoque : TEntradaEstoque;
    procedure LimpaCds;
    function TotalizarProduto(ValorUnitario, Quantidade: Double): Double;
    function TotalizarEntrada: Double;
    procedure LimparComponenteItem;
    procedure carregarRegistroSelecionado;
    {function Gravar(EstadoDoCadastro:TEstadoDoCadastro):Boolean; override;
    function Apagar:Boolean; override;
    function TotalizarProduto(ValorUnitario, Quantidade: Double): Double;
    procedure LimparComponenteItem;
    procedure LimpaCds;
    procedure carregarRegistroSelecionado;
    function TotalizarEntrada: Double;}
  public
    { Public declarations }
  end;

var
  frmProEntradaEstoque: TfrmProEntradaEstoque;

implementation

{$R *.dfm}

procedure TfrmProEntradaEstoque.btnAdicionarProdutoClick(Sender: TObject);
begin
  inherited;
  if (lkpProduto.KeyValue = null) then
  begin
    MessageDlg('Produto é um campo obrigatório', mtConfirmation, [mbOK],0);
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
    MessageDlg('Valor unitário deve ser maior que zero', mtInformation, [mbOK],0);
    edtUnitario.SetFocus;
    Abort;
  end;

  if (DTMEntradaEstoque.cdsItensEntrada.Locate('produtoId', lkpProduto.KeyValue, [])) then
  begin
    MessageDlg('Este produto já foi selecionado', mtInformation, [mbOK],0);
    lkpProduto.SetFocus;
    Abort;
  end;
  edtValorTotalProduto.Value := TotalizarProduto(edtUnitario.Value, edtQuantidade.Value);

  if (DTMEntradaEstoque.qryProdutos.FieldByName('valor').Value <> edtUnitario.Value) then
  begin
    case MessageDlg('Valor unitário diferente do Cadastrado, continuar?',
              mtConfirmation, [mbYes, mbNo],0) of
    mrNo :
      begin
    edtUnitario.Value := DTMEntradaEstoque.qryProdutos.FieldByName('valor').AsFloat;
    Abort;
      end;
    end;
  end;

  DTMEntradaEstoque.cdsItensEntrada.Append;
  DTMEntradaEstoque.cdsItensEntrada.FieldByName('produtoId').AsString := lkpProduto.KeyValue;
  DTMEntradaEstoque.cdsItensEntrada.FieldByName('nomeProduto').AsString := DTMEntradaEstoque.qryProdutos.FieldByName('nome').AsString;
  DTMEntradaEstoque.cdsItensEntrada.FieldByName('quantidade').AsFloat := edtQuantidade.Value;
  DTMEntradaEstoque.cdsItensEntrada.FieldByName('valorUnitario').AsFloat := edtUnitario.Value;
  DTMEntradaEstoque.cdsItensEntrada.FieldByName('valorTotalProduto').AsFloat := edtValorTotalProduto.Value;
  DTMEntradaEstoque.cdsItensEntrada.Post;
  edtValorTotalEntrada.Value := TotalizarEntrada;
  LimparComponenteItem;
  lkpProduto.SetFocus;
end;

procedure TfrmProEntradaEstoque.LimparComponenteItem;
begin
  lkpProduto.KeyValue := null;
  edtQuantidade.Value := 0;
  edtUnitario.Value := 0;
  edtValorTotalProduto.Value := 0;
end;

procedure TfrmProEntradaEstoque.lkpProdutoExit(Sender: TObject);
begin
  inherited;
  if (TDBLookupComboBox(Sender).KeyValue <> null) then
  begin
    edtUnitario.Value          := DTMEntradaEstoque.qryProdutos.FieldByName('valor').AsFloat;
    edtQuantidade.Value        := 1;
    edtValorTotalProduto.Value := TotalizarProduto(edtUnitario.Value, edtQuantidade.Value);
  end;
end;

function TfrmProEntradaEstoque.TotalizarEntrada:Double;
begin
Result := 0;
  DTMEntradaEstoque.cdsItensEntrada.First;
  while not(DTMEntradaEstoque.cdsItensEntrada.Eof) do begin
    Result := Result + DTMEntradaEstoque.cdsItensEntrada.FieldByName('valorTotalProduto').AsFloat;
    DTMEntradaEstoque.cdsItensEntrada.Next;
  end;
end;

function TfrmProEntradaEstoque.TotalizarProduto(ValorUnitario, Quantidade:Double):Double;
begin
  Result := ValorUnitario * Quantidade;
end;

procedure TfrmProEntradaEstoque.btnAlterarClick(Sender: TObject);
begin
  if (oEntradaEstoque.Selecionar(qryListagem.FieldByName('codiestoque').AsInteger,DTMEntradaEstoque.cdsItensEntrada)) then
  begin
    edtCodiEstoque.Text           := IntToStr(oEntradaEstoque.codiestoque);
    lkpFornecedor.KeyValue        := oEntradaEstoque.fornecedorId;
    edtDataEntrada.Date           := oEntradaEstoque.dataEntrada;
    edtValorTotalEntrada.Value    := oEntradaEstoque.ValorTotal;
    edtHistoricoEntrada.Text      := oEntradaEstoque.historico;
  end
  else
  begin
    btnCancelar.Click;
    Abort;
  end;
  inherited;

end;

procedure TfrmProEntradaEstoque.btnCancelarClick(Sender: TObject);
begin
  inherited;
  LimpaCds;
end;

procedure TfrmProEntradaEstoque.btnGravarClick(Sender: TObject);
begin
  inherited;
  LimpaCds;
end;

procedure TfrmProEntradaEstoque.btnNovoClick(Sender: TObject);
begin
  inherited;
  edtDataEntrada.Date := Date;
  lkpFornecedor.SetFocus;
  LimpaCds;
end;

procedure TfrmProEntradaEstoque.btnRemoverProdutoClick(Sender: TObject);
begin
  inherited;
  if (lkpProduto.KeyValue = null) then
  begin
    MessageDlg('Duplo clique no produto a ser removido', mtConfirmation, [mbOK],0);
    dbGridItensEntradaEstoque.SetFocus;
    Abort;
  end;

  if (DTMEntradaEstoque.cdsItensEntrada.Locate('produtoid', lkpProduto.KeyValue, [])) then
  begin
    DTMEntradaEstoque.cdsItensEntrada.Delete;
    edtValorTotalEntrada.Value :=  TotalizarEntrada;
    LimparComponenteItem;
  end;
end;

procedure TfrmProEntradaEstoque.carregarRegistroSelecionado();
begin
  lkpProduto.KeyValue        := DTMEntradaEstoque.cdsItensEntrada.FieldByName('produtoid').AsString;
  edtQuantidade.Value        := DTMEntradaEstoque.cdsItensEntrada.FieldByName('quantidade').AsFloat;
  edtUnitario.Value          := DTMEntradaEstoque.cdsItensEntrada.FieldByName('valorUnitario').AsFloat;
  edtValorTotalProduto.Value := DTMEntradaEstoque.cdsItensEntrada.FieldByName('valortotalProduto').AsFloat;
end;


procedure TfrmProEntradaEstoque.dbGridItensEntradaEstoqueDblClick(
  Sender: TObject);
begin
  inherited;
  carregarRegistroSelecionado;
end;

procedure TfrmProEntradaEstoque.dbGridItensEntradaEstoqueKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  BloqueiaCTRL_DEL_DBGrid(Key, Shift);
end;

procedure TfrmProEntradaEstoque.edtQuantidadeExit(Sender: TObject);
begin
  inherited;
  edtValorTotalProduto.Value := TotalizarProduto(edtUnitario.Value, edtQuantidade.Value);
end;

procedure TfrmProEntradaEstoque.edtUnitarioChange(Sender: TObject);
begin
  inherited;
  edtValorTotalProduto.Value := TotalizarProduto(edtUnitario.Value, edtQuantidade.Value);
end;

procedure TfrmProEntradaEstoque.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Assigned(DTMEntradaEstoque) then
  begin
    FreeAndNil(DTMEntradaEstoque);
  end;
  if Assigned(oEntradaEstoque) then
  begin
    FreeAndNil(oEntradaEstoque);
  end;
end;

procedure TfrmProEntradaEstoque.FormCreate(Sender: TObject);
begin
  inherited;
  DTMEntradaEstoque:=TDTMEntradaEstoque.Create(Self);
  DTMEntradaEstoque.qryFornecedor.Open;
  DTMEntradaEstoque.qryProdutos.Open;
  oEntradaEstoque := TEntradaEstoque.Create(dtmPrincipal.conexaoDB);
  IndiceAtual := 'codiestoque';
end;

procedure TfrmProEntradaEstoque.LimpaCds;
begin
  DTMEntradaEstoque.cdsItensEntrada.First;
  while not(DTMEntradaEstoque.cdsItensEntrada.Eof) do
  begin
  DTMEntradaEstoque.cdsItensEntrada.Delete;
  end;
end;

end.
