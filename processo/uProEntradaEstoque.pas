unit uProEntradaEstoque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  RxToolEdit, uDTMConexao, uDTMEntradaEstoque, uEnum;

type
  TfrmProEntradaEstoque = class(TfrmTelaHeranca)
    qryListagemcodiestoque: TIntegerField;
    qryListagemnome: TWideStringField;
    qryListagemdataEntrada: TDateTimeField;
    qryListagemValorTotal: TFloatField;
    edtDataEntrada: TDateEdit;
    lkpFornecedor: TDBLookupComboBox;
    edtVendaId: TLabeledEdit;
    lblFornecedor: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNovoClick(Sender: TObject);
  private
    { Private declarations }
    uDTMEntradaEstoque :TDTMEntradaEstoque;
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

procedure TfrmProEntradaEstoque.btnNovoClick(Sender: TObject);
begin
  inherited;
  edtDataEntrada.Date := Date;
  lkpFornecedor.SetFocus;
end;

procedure TfrmProEntradaEstoque.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Assigned(DTMEntradaEstoque) then
  begin
    FreeAndNil(DTMEntradaEstoque);
  end;
end;

procedure TfrmProEntradaEstoque.FormCreate(Sender: TObject);
begin
  inherited;
  DTMEntradaEstoque:=TDTMEntradaEstoque.Create(Self);
  IndiceAtual := 'codiestoque';
end;

end.
