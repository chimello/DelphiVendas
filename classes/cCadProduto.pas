unit cCadProduto;

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
     System.SysUtils;

type
  Tproduto = class
    private
    ConexaoDB     :TZConnection;
    F_produtoId   :Integer;
    F_nome        :string;
    F_descricao   :string;
    F_valor       :Double;
    F_quantidade  :Double;
    F_categoriaid :Integer;

    public
    constructor Create(aConexao:TZConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:Integer):Boolean;
    published
    property codigo       :integer  read F_produtoId    write F_produtoId;
    property nome         :String   read F_nome         write F_nome;
    property descricao    :String   read F_descricao    write F_descricao;
    property valor        :Double   read F_valor        write F_valor;
    property quantidade   :Double   read F_quantidade   write F_quantidade;
    property categoriaid  :integer  read F_categoriaid  write F_categoriaid;

  end;

implementation

{$REGION 'Constructor e destructor'}

constructor Tproduto.Create(aConexao: TZConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor Tproduto.Destroy;
begin
  inherited;
end;

{$ENDREGION}

{$REGION 'Manipula Dados'}

function Tproduto.Selecionar(id: Integer): Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT produtoid, '+
                '       nome, '+
                '       descricao, '+
                '       valor, '+
                '       quantidade, '+
                '       categoriaid ' +
                '  FROM produtos '+
                ' WHERE produtoid=:produtoid');
    Qry.ParamByName('produtoid').AsInteger:=id;
    Try
      Qry.Open;

      Self.F_produtoId      := Qry.FieldByName('produtoid').AsInteger;
      Self.F_nome           := Qry.FieldByName('nome').AsString;
      Self.F_descricao      := Qry.FieldByName('descricao').AsString;
      Self.F_valor          := Qry.FieldByName('valor').AsFloat;
      Self.F_quantidade     := Qry.FieldByName('quantidade').AsFloat;
      Self.F_categoriaid    := Qry.FieldByName('categoriaid').AsInteger;

    Except
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function Tproduto.Atualizar: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE produtos '+
                '   SET nome            =:nome '+
                '       ,descricao      =:descricao '+
                '       ,valor          =:valor '+
                '       ,quantidade     =:quantidade '+
                '       ,categoriaid    =:categoriaid '+
                ' WHERE produtoid=:produtoid ');
    Qry.ParamByName('produtoid').AsInteger           :=Self.F_produtoId;
    Qry.ParamByName('nome').AsString                 :=Self.F_nome;
    Qry.ParamByName('descricao').AsString            :=Self.F_descricao;
    Qry.ParamByName('valor').AsFloat                 :=Self.F_valor;
    Qry.ParamByName('quantidade').AsFloat            :=Self.F_quantidade;
    Qry.ParamByName('categoriaid').AsInteger         :=Self.F_categoriaid;

    Try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    Except
      ConexaoDB.Rollback;
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function Tproduto.Inserir: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('INSERT INTO produtos (nome, '+
                '                      descricao, '+
                '                      valor,  '+
                '                      quantidade,  '+
                '                      categoriaid) '+
                ' VALUES              (:nome, '+
                '                      :descricao, '+
                '                      :valor,  '+
                '                      :quantidade,  '+
                '                      :categoriaid) ' );

    Qry.ParamByName('nome').AsString               :=Self.F_nome;
    Qry.ParamByName('descricao').AsString          :=Self.F_descricao;
    Qry.ParamByName('valor').AsFloat               :=Self.F_valor;
    Qry.ParamByName('quantidade').AsFloat          :=Self.F_quantidade;
    Qry.ParamByName('categoriaid').AsInteger       :=Self.F_categoriaid;

    Try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    Except
      ConexaoDB.Rollback;
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function Tproduto.Apagar;
var Qry:TZQuery;
var newID:Integer;
var Qryseq:string;
begin
  if MessageDlg('Apagar o Registro: '+#13+#13+
                'C?digo: '+IntToStr(F_produtoId)+#13+
                'Descri??o: '+F_nome,mtConfirmation,[mbYes, mbNo],0)=mrNo then begin
     Result:=false;
     abort;
  end;

  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('DELETE FROM produtos '+
                ' WHERE produtoid=:produtoid ');
    Qry.ParamByName('produtoid').AsInteger :=F_produtoId;
    Try
      ConexaoDB.StartTransaction;
      Qry.ExecSQL;
      ConexaoDB.Commit;
    Except
      ConexaoDB.Rollback;
      Result:=false;
    End;

    Try
    Qry.ExecSQL;
    try
      Qry.SQL.Clear;
      Qry.sql.Add('SELECT MAX(produtoid) AS ' + 'newID' +
                  ' from produtos ');
      Qry.Open;
      newID:=Qry.FieldByName('newID').AsInteger;
      Qry.SQL.Clear;
      QrySeq:= ('dbcc checkident (produtos, reseed, ' + newID.ToString + ')');
      Qry.SQL.Add(QrySeq);
      Qry.ExecSQL;
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

end.
