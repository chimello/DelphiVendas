unit uDTMEntradaEstoque;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient,
  ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  TDTMEntradaEstoque = class(TDataModule)
    qryFornecedor: TZQuery;
    qryProdutos: TZQuery;
    qryProdutosprodutoid: TIntegerField;
    qryProdutosnome: TWideStringField;
    qryProdutosvalor: TFloatField;
    qryProdutosquantidade: TFloatField;
    cdsItensEntrada: TClientDataSet;
    cdsItensEntradaprodutoid: TIntegerField;
    cdsItensEntradaNomeProduto: TStringField;
    cdsItensEntradaQuantidade: TFloatField;
    cdsItensEntradavalorUnitario: TFloatField;
    cdsItensEntradaValorTotalProduto: TFloatField;
    dtsFornecedor: TDataSource;
    dtsProdutos: TDataSource;
    dtsItensEntradas: TDataSource;
    qryFornecedorclienteId: TIntegerField;
    qryFornecedornome: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DTMEntradaEstoque: TDTMEntradaEstoque;

implementation

uses
  uDTMConexao;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

{ TDataModule1 }

procedure TDTMEntradaEstoque.DataModuleCreate(Sender: TObject);
begin
  cdsItensEntrada.CreateDataSet;

  qryFornecedor.Open;
  qryProdutos.Open;
end;

procedure TDTMEntradaEstoque.DataModuleDestroy(Sender: TObject);
begin
  cdsItensEntrada.Close;
  qryFornecedor.Close;
  qryProdutos.Close;
end;

end.
