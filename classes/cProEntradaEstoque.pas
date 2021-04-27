unit cProEntradaEstoque;

interface

uses System.Classes,
     Vcl.Controls,
     Vcl.ExtCtrls,
     Vcl.Dialogs,
     ZAbstractConnection,
     ZConnection,
     ZAbstractRODataset,
     ZAbstractDataset,
     ZDataset,
     Data.DB,
     Datasnap.DBClient,
     System.SysUtils,
     uEnum,
     cControleEstoque;

type
TEntradaEstoque = class
  private
  ConexaoDB       :TZConnection;
  F_codiestoque   :Integer;
  F_fornecedorId  :Integer;
  F_dataEntrada   :TDateTime;
  F_totalEntrada  :Double;
  F_historico     :string;

  public
    constructor Create(aconexao:TZConnection);
    destructor Destroy; override;
    {function Inserir(cds:TClientDataSet):Boolean;
    function Atualizar(cds:TClientDataSet):Boolean;
    function Apagar:Boolean;}
    function Selecionar(id:Integer; var cds:TClientDataSet):Boolean;

  published
    property codiestoque    :integer    read F_codiestoque    write F_codiestoque;
    property fornecedorId   :Integer    read F_fornecedorId   write F_fornecedorId;
    property dataEntrada    :TDateTime  read F_dataEntrada    write F_dataEntrada;
    property ValorTotal     :Double     read F_totalEntrada   write F_totalEntrada;
    property historico      :string     read F_historico      write F_historico;
end;

implementation

{ TEntradaEstoque }

{$region 'Constructor and Destructor'}
constructor TEntradaEstoque.Create(aConexao:TZConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TEntradaEstoque.Destroy;
begin
  inherited;
end;
{$endRegion}

{$REGION 'CRUD'}

function TEntradaEstoque.Selecionar(id: Integer; var cds:TClientDataSet): Boolean;
var Qry:TZQuery;
begin
  try
    Result := True;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT codiestoque, ' +
                'clienteid, ' +
                'dataEntrada, '+
                'ValorTotal, ' +
                'historico ' +
                'FROM entradaEstoque ' +
                'WHERE codiestoque=:codiestoque');
    Qry.ParamByName('codiestoque').AsInteger:=id;
    try
      Qry.Open;
      Self.F_codiestoque    := Qry.FieldByName('codiestoque').AsInteger;
      Self.F_fornecedorId   := Qry.FieldByName('clienteid').AsInteger;
      Self.F_dataEntrada    := Qry.FieldByName('dataEntrada').AsDateTime;
      Self.F_totalEntrada   := Qry.FieldByName('ValorTotal').AsFloat;
      Self.F_historico      := Qry.FieldByName('historico').AsString;

      {$REGION 'Selecionar na tabela entradaItensEstoque'}
      //apaga o clietdataset se estiver com registro
      cds.First;
      while not cds.Eof do
      begin
        cds.Delete;
      end;

      //seleciona os itens do banco de dados com a propriedade F_codiestoque
      Qry.Close;
      Qry.SQL.Clear;
      Qry.SQL.Add('SELECT entradaItensEstoque.ProdutoId, ' +
                  'Produtos.nome, ' +
                  'entradaItensEstoque.ValorUnitario, ' +
                  'entradaItensEstoque.Quantidade, ' +
                  'entradaItensEstoque.TotalProduto ' +
                  'FROM entradaItensEstoque ' +
                  'INNER JOIN produtos ON Produtos.produtoId = entradaItensEstoque.ProdutoId ' +
                  'WHERE entradaItensEstoque.codiestoque = :codiestoque');
      Qry.ParamByName('codiestoque').AsInteger := Self.F_codiestoque;
      Qry.Open;

      //lê da query(qry) e coloca no ClientDataSet
      Qry.First;
      while not Qry.Eof do
      begin
        cds.Append;
        cds.FieldByName('produtoId').AsInteger        := Qry.FieldByName('produtoid').AsInteger;
        cds.FieldByName('NomeProduto').AsString       := Qry.FieldByName('nome').AsString;
        cds.FieldByName('valorUnitario').AsFloat      := Qry.FieldByName('valorunitario').AsFloat;
        cds.FieldByName('Quantidade').AsFloat         := Qry.FieldByName('quantidade').AsFloat;
        cds.FieldByName('valorTotalProduto').AsFloat  := Qry.FieldByName('totalproduto').AsFloat;
        cds.Post;
        Qry.Next;
      end;
      cds.First;
      {$ENDREGION}
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
