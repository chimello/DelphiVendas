unit cControleEstoque;

interface

uses
  System.Classes,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Dialogs,
  ZAbstractConnection,
  ZConnection,
  ZAbstractRODataset,
  ZAbstractDataset,
  ZDataset,
  System.SysUtils,
  Data.DB,
  Datasnap.DBClient;

type
  TControleEstoque = class
  private
    ConexaoDB:TZConnection;
    F_ProdutoId:Integer;
    F_Quantidade:Double;
  public
    constructor Create(aConexao: TZConnection);
    destructor Destroy; override;
    function BaixaEstoque: Boolean;
    function RetornaEstoque: Boolean;
    function AdicionarEstoque: Boolean;
  published
    property produtoId    :Integer  read F_ProdutoId  write F_ProdutoId;
    property quantidade   :Double   read F_Quantidade write F_Quantidade;
  end;

implementation

{$REGION 'Constructor e Destructor'}
constructor TControleEstoque.Create(aConexao: TZConnection);
begin
  ConexaoDB := aConexao;
end;

destructor TControleEstoque.Destroy;
begin

  inherited;
end;
{$ENDREGION}

{$REGION 'Controla Estoque'}
function TControleEstoque.RetornaEstoque: Boolean;
var Qry: TZQuery;
begin
  try
   Result := True;
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConexaoDB;
    Qry.SQL.Clear;

    Qry.SQL.Add('UPDATE produtos ' +
                'SET quantidade = quantidade + :qtdeRetorno ' +
                'WHERE produtoId =:produtoId ');
    Qry.ParamByName('produtoId').AsInteger := produtoId;
    Qry.ParamByName('qtdeRetorno').AsFloat := quantidade;
    try
      Qry.ExecSQL;
    except
      Result := False;
    end;
  finally
    if Assigned(Qry) then
    begin
      FreeAndNil(Qry);
    end;
  end;
end;

function TControleEstoque.BaixaEstoque: Boolean;
var Qry: TZQuery;
begin
  try
    Result := True;
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConexaoDB;
    Qry.SQL.Clear;

    Qry.SQL.Add('UPDATE produtos ' +
                'SET quantidade = quantidade - :qtdeBaixa ' +
                'WHERE produtoId =:produtoId ');
    Qry.ParamByName('produtoId').AsInteger := produtoId;
    Qry.ParamByName('qtdeBaixa').AsFloat := quantidade;
    try
      Qry.ExecSQL;
    except
      Result := False;
    end;
  finally
    if Assigned(Qry) then
    begin
      FreeAndNil(Qry);
    end;
  end;
end;

function TControleEstoque.AdicionarEstoque: Boolean;
var Qry: TZQuery;
begin
  try
   Result := True;
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConexaoDB;
    Qry.SQL.Clear;

    Qry.SQL.Add('UPDATE produtos ' +
                'SET quantidade = quantidade + :qtdeRetorno ' +
                'WHERE produtoId =:produtoId ');
    Qry.ParamByName('produtoId').AsInteger := produtoId;
    Qry.ParamByName('qtdeRetorno').AsFloat := quantidade;
    try
      Qry.ExecSQL;
    except
      Result := False;
    end;
  finally
    if Assigned(Qry) then
    begin
      FreeAndNil(Qry);
    end;
  end;
end;


{$ENDREGION}

end.
