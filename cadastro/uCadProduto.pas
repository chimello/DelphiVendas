unit uCadProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  RxToolEdit, RxCurrEdit, cCadProduto, uDTMConexao, uEnum;

type
  TfrmCadProduto = class(TfrmTelaHeranca)
    qryListagemPRODUTOID: TIntegerField;
    qryListagemNOME: TWideStringField;
    qryListagemDESCRICAO: TWideStringField;
    qryListagemVALOR: TFloatField;
    qryListagemQUANTIDADE: TFloatField;
    qryListagemCATEGORIAID: TIntegerField;
    qryListagemDESCRICAOCATEGORIA: TWideStringField;
    edtProdutoId: TLabeledEdit;
    edtNome: TLabeledEdit;
    edtDescricao: TMemo;
    lblDescricao: TLabel;
    edtValor: TCurrencyEdit;
    edtQuantidade: TCurrencyEdit;
    lblValor: TLabel;
    lblQuantidade: TLabel;
    lkpCategoria: TDBLookupComboBox;
    qryCategoria: TZQuery;
    dtsCategoria: TDataSource;
    qryCategoriacategoriaid: TIntegerField;
    qryCategoriadescricao: TWideStringField;
    lblCategoria: TLabel;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtValorChange(Sender: TObject);
  private
    { Private declarations }
    oProduto:Tproduto;
    function Apagar:Boolean; override;
    function Gravar(EstadoDoCadastro:TEstadoDoCadastro):Boolean; override;
  public
    { Public declarations }
  end;

var
  frmCadProduto: TfrmCadProduto;

implementation

{$R *.dfm}

{ TfrmCadProduto }

{$region 'Override'}

function TfrmCadProduto.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  if (edtProdutoId.Text<>EmptyStr) then
  begin
    oProduto.codigo := StrToInt(edtProdutoId.Text);
  end
  else
  begin
    oProduto.codigo:=0;
  end;

  oProduto.nome:=edtNome.Text;
  oProduto.descricao:=edtNome.Text;
  oProduto.valor:=edtValor.Value;
  oProduto.quantidade:=edtQuantidade.Value;
  oProduto.categoriaid:=lkpCategoria.KeyValue;


  if (EstadoDoCadastro=ECInserir) then
  begin
    Result:=oProduto.Inserir;
  end
  else if (EstadoDoCadastro=ECAlterar) then
  begin
    Result:= oProduto.Atualizar;
  end;


end;

function TfrmCadProduto.Apagar: Boolean;
begin
if (oProduto.Selecionar(qryListagem.FieldByName('produtoid').AsInteger)) then
begin
  Result:=oProduto.Apagar;
end;
end;
{$endRegion}

{$REGION 'Bot?es'}

procedure TfrmCadProduto.btnAlterarClick(Sender: TObject);
begin
  inherited;
  if (oProduto.Selecionar(qryListagem.FieldByName('produtoid').AsInteger)) then
  begin
    edtProdutoId.Text       := IntToStr(oProduto.codigo);
    edtNome.Text            := oProduto.nome;
    edtDescricao.Text       := oProduto.descricao;
    edtValor.Value          := oProduto.valor;
    edtQuantidade.Value     := oProduto.quantidade;
    lkpCategoria.KeyValue   := oProduto.categoriaid;
  end
  else
  begin
    btnCancelar.Click;
    Abort;
  end;
  inherited;
  (Screen.ActiveForm.FindComponent('edtDescricao') as TWinControl).SetFocus;
end;



procedure TfrmCadProduto.btnNovoClick(Sender: TObject);
begin
  inherited;
  (Screen.ActiveForm.FindComponent('edtnome') as TWinControl).SetFocus;
end;

procedure TfrmCadProduto.edtValorChange(Sender: TObject);
begin
  inherited;

end;

{$ENDREGION}

{$REGION 'Forms'}

procedure TfrmCadProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  qryCategoria.Close;
  if (Assigned(oProduto)) then
  begin
    FreeAndNil(oProduto);
  end;

end;

procedure TfrmCadProduto.FormCreate(Sender: TObject);
begin
  inherited;
  oProduto:=Tproduto.Create(dtmPrincipal.conexaoDB);
  IndiceAtual:= 'nome';
end;

procedure TfrmCadProduto.FormShow(Sender: TObject);
begin
  inherited;
  qryCategoria.Open;
end;

{$ENDREGION}
end.
