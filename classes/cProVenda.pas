unit cProVenda;

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
 Tvenda = class
   private
   ConexaoDB      :TZConnection;
   F_vendaId      :Integer;
   F_clienteid    :Integer;
   F_dataVenda    :TDateTime;
   F_totalVenda   :Double;
    function InserirItens(cds: TClientDataSet; IdVenda: Integer): Boolean;
    function ApagaItens(cds: TClientDataSet): Boolean;
    function InNot(cds: TClientDataSet): string;
    function ExisteItemVenda(vendaId, produtoId: Integer): Boolean;
    function AtualizarItem(cds: TClientDataSet): Boolean;
    procedure RetornarEstoque(sCodigo: string; Acao: TAcaoExcluirEstoque);
    procedure BaixaEstoque(ProdutoId: Integer; Quantidade: Double);
    procedure RetornaEstoqueTotalVenda(sCodigoVenda: String; Acao:TAcaoExcluirEstoque);

   public
    constructor Create(aconexao:TZConnection);
    destructor Destroy; override;
    function Inserir(cds:TClientDataSet):Boolean;
    function Atualizar(cds:TClientDataSet):Boolean;
    function Apagar:Boolean;
    function Selecionar(id:Integer; var cds:TClientDataSet):Boolean;

   published
    property VendaId      :Integer    read F_vendaId      write F_vendaId;
    property clienteid    :Integer    read F_clienteid    write F_clienteid;
    property dataVenda    :TDateTime  read F_dataVenda    write F_dataVenda;
    property totalVenda   :Double     read F_totalVenda   write F_totalVenda;
 end;

implementation

{ Tvenda }

{$region 'Constructor and Destructor'}
constructor Tvenda.Create(aConexao:TZConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor Tvenda.Destroy;
begin
  inherited;
end;
{$endRegion}

{$REGION 'CRUD'}
function Tvenda.Selecionar(id: Integer; var cds:TClientDataSet): Boolean;
var Qry:TZQuery;
begin
  try
    Result := True;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT vendaId, ' +
                'clienteid, ' +
                'datavenda, '+
                'totalvenda ' +
                'FROM vendas ' +
                'WHERE vendaId=:vendaId');
    Qry.ParamByName('vendaId').AsInteger:=id;
    try
      Qry.Open;
      Self.F_vendaid    := Qry.FieldByName('vendaId').AsInteger;
      Self.F_clienteid  := Qry.FieldByName('clienteid').AsInteger;
      Self.F_dataVenda  := Qry.FieldByName('dataVenda').AsDateTime;
      Self.F_totalVenda := Qry.FieldByName('totalVenda').AsFloat;

      {$REGION 'Selecionar na tabela VendasItens'}
      //apaga o clietdataset se estiver com registro
      cds.First;
      while not cds.Eof do
      begin
        cds.Delete;
      end;

      //seleciona os itens do banco de dados com a propriedade F_vendaid
      Qry.Close;
      Qry.SQL.Clear;
      Qry.SQL.Add('SELECT VendasItens.ProdutoId, ' +
                  'Produtos.nome, ' +
                  'VendasItens.ValorUnitario, ' +
                  'VendasItens.Quantidade, ' +
                  'VendasItens.TotalProduto ' +
                  'FROM VendasItens ' +
                  'INNER JOIN produtos ON Produtos.produtoId = VendasItens.ProdutoId ' +
                  'WHERE VendasItens.vendaID = :VendaId');
      Qry.ParamByName('VendaId').AsInteger := Self.F_vendaId;
      Qry.Open;

      //l? da query(qry) e coloca no ClientDataSet
      Qry.First;
      while not Qry.Eof do
      begin
        cds.Append;
        cds.FieldByName('produtoId').AsInteger        := Qry.FieldByName('produtoid').AsInteger;
        cds.FieldByName('nomeProduto').AsString       := Qry.FieldByName('nome').AsString;
        cds.FieldByName('Quantidade').AsFloat         := Qry.FieldByName('quantidade').AsFloat;
        cds.FieldByName('valorUnitario').AsFloat      := Qry.FieldByName('valorunitario').AsFloat;
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
function Tvenda.Inserir(cds:TClientDataSet): Boolean;
var Qry:TZQuery;
    idVendaGerado:Integer;
begin
  try
    Result := True;
    ConexaoDB.StartTransaction;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    //faz a inclus?o no banco de dados
    Qry.SQL.Clear;
    Qry.SQL.Add('INSERT INTO vendas (clienteid, dataVenda, totalVenda) ' +
                'VALUES (:clienteid, :datavenda, :totalvenda )');
    Qry.ParamByName('clienteid').AsInteger    := Self.F_clienteid;
    Qry.ParamByName('datavenda').AsDateTime   := Self.F_dataVenda;
    Qry.ParamByName('totalvenda').AsFloat     := Self.F_totalVenda;

    try
      Qry.ExecSQL;
      //recupera o ID gerado no insert
      Qry.SQL.Clear;
      Qry.SQL.Add('SELECT SCOPE_IDENTITY() AS ID');
      Qry.Open;
      // ID da tabela master
      idVendaGerado := Qry.FieldByName('ID').AsInteger;
      {$REGION 'Gravar na tabela de itens'}

      cds.First;
      while not (cds.Eof) do
      begin
        InserirItens(cds, IdVendaGerado);
        cds.Next;
      end;


      {$ENDREGION}
      ConexaoDB.Commit;
    except
      ConexaoDB.Rollback;
      Result := False;
    end;

  finally
    if Assigned(Qry) then
    begin
      FreeAndNil(Qry);
    end;

  end;

end;

function Tvenda.InserirItens(cds:TClientDataSet; IdVenda:Integer):Boolean;
var Qry:TZQuery;
begin
  Try
    Result := True;
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('INSERT INTO VendasItens (VENDAID, PRODUTOID, VALORUNITARIO, QUANTIDADE, TOTALPRODUTO) ' +
                '                         VALUES (:VendaID, :ProdutoID, :ValorUnitario, :Quantidade, :TotalProduto)');
    Qry.ParamByName('VendaId').AsInteger      := IdVenda;
    Qry.ParamByName('ProdutoId').AsInteger    := cds.FieldByName('produtoId').AsInteger;
    Qry.ParamByName('ValorUnitario').AsFloat  := cds.FieldByName('valorUnitario').AsFloat;
    Qry.ParamByName('Quantidade').AsFloat     := cds.FieldByName('Quantidade').AsFloat;
    Qry.ParamByName('TotalProduto').AsFloat   := cds.FieldByName('valorTotalProduto').AsFloat;
    try
      Qry.ExecSQL;
      BaixaEstoque(cds.FieldByName('produtoId').AsInteger, cds.FieldByName('quantidade').AsFloat);
    except
    Result := False;
    end;
    
  Finally
    if Assigned(Qry) then
    begin
      FreeAndNil(Qry);
    end;
  End;
end;

function TVenda.Atualizar(cds:TClientDataSet): Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    ConexaoDB.StartTransaction;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE vendas '+
                '   SET clienteid      =:clienteid '+
                '       ,dataVenda     =:dataVenda '+
                '       ,totalVenda    =:totalVenda '+
                ' WHERE vendaid=:vendaId ');
    Qry.ParamByName('vendaId').AsInteger      :=Self.F_vendaid;
    Qry.ParamByName('clienteid').AsInteger    :=Self.F_clienteId;
    Qry.ParamByName('dataVenda').AsDateTime    :=Self.F_dataVenda;
    Qry.ParamByName('totalVenda').AsFloat      :=Self.F_totalVenda;

    Try
      //update vendas
      Qry.ExecSQL;

      //apagar itens no banco que foram removidos da tela
      ApagaItens(cds);

      cds.First;
      while not cds.Eof do
      begin
        if (ExisteItemVenda(Self.F_vendaId, cds.FieldByName('produtoid').AsInteger)) then
        begin
          AtualizarItem(cds);
        end
        else
        begin
          InserirItens(cds, Self.VendaId);
        end;

        cds.Next;
      end;
      
      

      
    Except
      ConexaoDB.Rollback;
      Result:=false;
    End;
    ConexaoDB.Commit;    
  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function Tvenda.AtualizarItem(cds:TClientDataSet): Boolean;
var Qry : TZQuery;
begin
  Try
  Result := True;
  RetornarEstoque(cds.FieldByName('produtoId').AsString, aeeAlterar);
  Qry := TZQuery.Create(nil);
  Qry.Connection := ConexaoDB;
  Qry.SQL.Clear;
  Qry.SQL.Add('UPDATE vendasItens set ' +
              'valorUnitario = :valorUnitario, ' +
              'Quantidade = :quantidade, ' +
              'TotalProduto = :TotalProduto ' +
              'WHERE vendaId =:vendaId AND produtoId =:produtoId ');
  Qry.ParamByName('vendaId').AsInteger        := Self.F_vendaId;
  Qry.ParamByName('produtoId').AsInteger      := cds.FieldByName('produtoId').AsInteger;
  Qry.ParamByName('Valorunitario').AsFloat    := cds.FieldByName('valorUnitario').AsFloat;
  Qry.ParamByName('Quantidade').AsFloat       := cds.FieldByName('quantidade').AsFloat;
  Qry.ParamByName('TotalProduto').AsFloat     := cds.FieldByName('ValorTotalProduto').AsFloat;

  try
    Qry.ExecSQL;
    BaixaEstoque(cds.FieldByName('produtoId').AsInteger, cds.FieldByName('quantidade').AsFloat);
  except
    Result := False;
  end;
  Finally
    if Assigned(Qry) then
    begin
      FreeAndNil(Qry);
    end;
  End;
end;

function Tvenda.ExisteItemVenda(vendaId:Integer; produtoId:Integer): Boolean;
var Qry : TZQuery;
begin
  Qry := TZQuery.Create(nil);
  Qry.Connection := ConexaoDB;
  Qry.SQL.Clear;
  Qry.SQL.Add('SELECT Count(vendaId) as Qtde ' +
              'FROM VendasItens ' +
              'WHERE vendaId =:vendaId AND produtoId =:produtoId ');
  Qry.ParamByName('vendaId').AsInteger := vendaId;
  Qry.ParamByName('produtoId').AsInteger := produtoId;
  try
    Qry.Open;

    if (Qry.FieldByName('Qtde').AsInteger > 0) then
    begin
      Result := True;
    end
    else
    begin
      Result := False;
    end;
    
  finally

  end;
end;

function Tvenda.ApagaItens(cds:TClientDataSet):Boolean;
var Qry:TZQuery;
var sCodNocds:string;
begin
  try
    Result := True;
    sCodNocds := InNot(cds);
    RetornarEstoque(sCodNocds, aeeApagar);
    Qry := TZQuery.Create(nil);
    Qry.Connection := ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('DELETE FROM vendasitens WHERE VendaId = :VendaId ' +
                'AND produtoId NOT IN ( ' + sCodNocds+' ) ');
    Qry.ParamByName('vendaId').AsInteger := Self.VendaId;
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

function Tvenda.InNot(cds:TClientDataSet):string;
var sInNot:string;
begin
  sInNot := EmptyStr;
  cds.First;
  while not cds.Eof do
  begin
    if sInNot = EmptyStr then
    begin
      sInNot := cds.FieldByName('produtoId').AsString;
    end
    else
    begin
      sInNot := sInNot + ',' + cds.FieldByName('produtoId').AsString;
    end;
    cds.Next;    
  end;
  Result := sInNot;
  
end;

function Tvenda.Apagar: Boolean;
var Qry:TZQuery;
var newID:Integer;
var Qryseq:string;
var sCodNocds:string;
codVendaExcluir: string;
begin
  if MessageDlg('Apagar o Registro: '+#13+#13+
                'Venda Nro: '+IntToStr(VendaId),mtConfirmation, [mbYes, mbNo],0)=mrNo then
  begin
     Result:=false;
     abort;
  end;

  try
    Result:=true;
    ConexaoDB.StartTransaction;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    {
    Qry.SQL.Add('DELETE FROM vendasItens '+
                ' WHERE vendaId=:vendaId '); }
    codVendaExcluir := IntToStr(VendaId);
    //Qry.ParamByName('vendaId').AsInteger :=vendaid;

    Try
      {Qry.ExecSQL;
      Qry.SQL.Clear;}
      RetornaEstoqueTotalVenda(codVendaExcluir, aeeApagar);
      Qry.SQL.Add('DELETE FROM vendasItens '+
                ' WHERE vendaId=:vendaId ');
      Qry.ParamByName('vendaId').AsInteger :=vendaid;

      Qry.SQL.Add('DELETE FROM VENDAS ' +
                  ' WHERE vendaid=:vendaId ');
      Qry.ParamByName('vendaid').AsInteger := VendaId;
      Qry.ExecSQL;
      Qry.SQL.Clear;
      //ConexaoDB.Commit;
    Except
      ConexaoDB.Rollback;
      Result:=false;
    End;

    Try
      try
        Qry.SQL.Clear;
        Qry.sql.Add('SELECT MAX(vendaid) AS ' + 'newID' +
                    ' from vendas ');
        Qry.Open;
        newID:=Qry.FieldByName('newID').AsInteger;
        Qry.SQL.Clear;
        QrySeq:= ('dbcc checkident (vendas, reseed, ' + newID.ToString + ')');
        Qry.SQL.Add(QrySeq);
        Qry.ExecSQL;
        ConexaoDB.Commit;
      finally
        Qry.Close
      end;
  except
    Result:=False;
  end;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Estoque'}
//utilizar no Update e no Delete
procedure Tvenda.RetornarEstoque(sCodigo:string; Acao:TAcaoExcluirEstoque);
var Qry: TZQuery;
var oControleEstoque:TControleEstoque;
begin
  Qry := TZQuery.Create(nil);
  Qry.Connection := ConexaoDB;
  Qry.SQL.Clear;

  Qry.SQL.Add('SELECT produtoId, quantidade ' +
              'FROM VendasItens ' +
              'WHERE VendaId =:vendaId ');
  if (Acao=aeeApagar) then
  begin
    Qry.SQL.Add(' AND produtoId NOT IN ( ' + sCodigo + ') ');
  end
  else if (Acao = aeeAlterar) then       
  begin
    Qry.SQL.Add(' AND produtoId IN (' + sCodigo + ') ');
  end
  else
  begin
    ShowMessage('Erro desconhecido, Contate o Suporte!');
  end;

  Qry.ParamByName('vendaId').AsInteger := Self.F_vendaId;
  try
    oControleEstoque := TControleEstoque.Create(ConexaoDB);
    Qry.Open;
    Qry.First;
    while not Qry.Eof do
    begin
      oControleEstoque.produtoId := Qry.FieldByName('produtoId').AsInteger;
      oControleEstoque.quantidade := Qry.FieldByName('quantidade').AsFloat;
      oControleEstoque.RetornaEstoque;
      Qry.Next;
    end;    
  finally
  if Assigned(oControleEstoque) then
  begin
    FreeAndNil(oControleEstoque);
  end;

  end;
  
end;

procedure Tvenda.RetornaEstoqueTotalVenda(sCodigoVenda:String; Acao:TAcaoExcluirEstoque);
var Qry: TZQuery;
var QryUpdate: TZQuery;
var idProduto: Integer;
var quantidadeVenda: Double;
begin
  Qry := TZQuery.Create(nil);
  ConexaoDB.StartTransaction;
  Qry.Connection := ConexaoDB;
  Qry.SQL.Clear;

  QryUpdate := TZQuery.Create(nil);
  QryUpdate.Connection := ConexaoDB;
  QryUpdate.SQL.Clear;

  Qry.SQL.Add('SELECT produtoId, quantidade ' +
              'FROM vendasItens WHERE vendaId = ' + scodigoVenda );
  Qry.Open;
  Qry.First;
  Try
  while not Qry.Eof do
  begin
    idProduto         := Qry.FieldByName('produtoId').AsInteger;
    quantidadeVenda   := Qry.FieldByName('quantidade').AsFloat;
    QryUpdate.SQL.Clear;
    QryUpdate.SQL.Add('UPDATE produtos SET produtos.quantidade ' +
                      ' = produtos.quantidade + :quantidadeVenda ' +
                          'WHERE produtoId =:produtoId ');
    QryUpdate.ParamByName('produtoId').AsInteger := idProduto;
    QryUpdate.ParamByName('quantidadeVenda').AsFloat := quantidadeVenda;
    Try
      QryUpdate.ExecSQL;
      Qry.Next;
    except
      ConexaoDB.Rollback;
    End;
  end;
    ConexaoDB.Commit;
  Finally
    //Qry.Close;
    if ((Assigned(Qry)) or (Assigned(QryUpdate)))  then
      begin
      FreeAndNil(Qry);
      FreeAndNil(QryUpdate);
    end;
    End;
end;

//Ao inserir
procedure Tvenda.BaixaEstoque(ProdutoId:Integer; Quantidade:Double);
var oControleEstoque:TControleEstoque;
begin
  try
    oControleEstoque := TControleEstoque.Create(ConexaoDB);
    oControleEstoque.produtoId := ProdutoId;
    oControleEstoque.quantidade := Quantidade;
    oControleEstoque.BaixaEstoque;
  finally
  if Assigned(oControleEstoque) then
  begin
    FreeAndNil(oControleEstoque);
  end;

  end;
end;
{$ENDREGION}

end.
