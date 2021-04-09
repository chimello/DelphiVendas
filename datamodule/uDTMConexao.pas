unit uDTMConexao;

interface

uses
  System.SysUtils, System.Classes, ZAbstractConnection, ZConnection, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  TdtmPrincipal = class(TDataModule)
    conexaoDB: TZConnection;
    qryScriptCategorias: TZQuery;
    qryScriptClientes: TZQuery;
    qryScriptProdutos: TZQuery;
    qryScriptVendas: TZQuery;
    qryScriptItensVendas: TZQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmPrincipal: TdtmPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
