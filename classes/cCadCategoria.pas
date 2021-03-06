unit cCadCategoria;

interface

uses System.Classes,Vcl.Controls, Vcl.ExtCtrls, Vcl.Dialogs,
ZAbstractConnection, ZConnection, ZAbstractRODataset, ZAbstractDataset,
ZDataset, System.SysUtils; // Lista de Units

type
  Tcategoria = class //Declaração do tipo da classe.
  private
  ConexaoDb: TZConnection;
  F_categoriaId:Integer;  //int
  F_descricao:String;  //varchar

    function getCodigo: Integer;
    function getDescricao: string;
    procedure setCodigo(const Value: Integer);
    procedure setDescricao(const Value: string);

  public
    constructor Create(aConexao:TZConnection);  //construtor de classe
    destructor Destroy; override; //destroi a classe usar o overrride por causa
                                    //de sobreescrever
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Seleciona(id:Integer):Boolean;
      // variaveis publicas que poodem ser trabalhada fora da classe

    published
      //variaveis publicas utilizadas para propriedas da classe
      // para fornecer informações em runtime
      property codigo:Integer read getCodigo write setCodigo;
      property descricao:string read getDescricao write setDescricao;
  end;

implementation

{ Tcategoria }

{$REGION 'Constructor e Destructor'}
constructor Tcategoria.Create(aConexao:TZConnection);
begin
  ConexaoDb:=aConexao;
end;

destructor Tcategoria.Destroy;
begin

  inherited;
end;

{$endRegion}

{$region 'Getters e setters'}

function Tcategoria.getCodigo: Integer;
begin
  Result := Self.F_categoriaId;
end;

function Tcategoria.getDescricao: string;
begin
  Result := Self.F_descricao;
end;

procedure Tcategoria.setCodigo(const Value: Integer);
begin
  Self.F_categoriaId:=Value;
end;

procedure Tcategoria.setDescricao(const Value: string);
begin
  Self.F_descricao:=Value;
end;

{$endRegion}

{$region 'Manipula Dados (CRUDs)'}

function Tcategoria.Seleciona(id: Integer): Boolean;
var Qry:TZQuery;
begin
  Try
    Result:=True;
    Qry:=TZQuery.Create(Nil);
    Qry.Connection:=ConexaoDb;
    Qry.SQL.Clear;
    Qry.sql.Add('SELECT categoriaId, ' +
                ' descricao ' +
                ' from categorias ' +
                ' where categoriaid=:categoriaid');
    Qry.ParamByName('categoriaid').AsInteger:=ID;
    Try
    Qry.Open;

    Self.F_categoriaId := Qry.FieldByName('categoriaid').AsInteger;
    self.F_descricao := Qry.FieldByName('descricao').AsString;
    except
      Result:=False;
    end;

  finally
    if (Assigned(Qry)) then
    begin
      FreeAndNil(Qry);
    end;
  
  end;
end;

function Tcategoria.Atualizar: Boolean;
var   Qry:TZQuery;
begin
  Try
  Result:=True;
  Qry:=TZQuery.Create(Nil);
  Qry.Connection:=ConexaoDb;
  Qry.SQL.Clear;
  Qry.sql.Add('UPDATE categorias ' +
              ' SET descricao=:descricao ' +
              ' where categoriaid=:categoriaid');
  Qry.ParamByName('categoriaid').AsInteger:=Self.F_categoriaId;
  Qry.ParamByName('descricao').AsString:=Self.F_descricao;
  Try
    Qry.ExecSQL;
  except
    Result:=False;
  end;

finally
  if (Assigned(Qry)) then
  begin
    FreeAndNil(Qry);
  end;
  
end;
end;

function Tcategoria.Inserir: Boolean;
var Qry:TZQuery;
begin
  try
  Result:= True;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDb;
    Qry.SQL.Clear;
    Qry.SQL.Add('INSERT INTO CATEGORIAS (DESCRICAO) VALUES (:descricao)');
    Qry.ParamByName('descricao').AsString:=Self.F_descricao;
    try
      Qry.ExecSQL;    
    except
      Result:=False;
    end;

  finally
    if (Assigned(Qry)) then
    begin
      FreeAndNil(Qry);
    end;
    
  end;
end;

function Tcategoria.Apagar: Boolean;
var Qry:TZQuery;
var newID:Integer;
var QrySeq:string;
begin

  if (MessageDlg('Apagar o Registro: '+#13+#13+
                  'Código: '+IntToStr(F_categoriaId)+#13+
                  'Descrição: '+F_descricao,mtConfirmation, [mbYes, mbNo],0)=mrNo) then
  begin
    Result:=False;
    Abort;
  end;
     
  Try
  Result:=True;
  Qry:=TZQuery.Create(Nil);
  Qry.Connection:=ConexaoDb;
  Qry.SQL.Clear;
  Qry.sql.Add('DELETE FROM categorias '  +
              ' where categoriaid=:categoriaid');
  Qry.ParamByName('categoriaid').AsInteger:=F_categoriaId;
  Try
    Qry.ExecSQL;
    try
      Qry.SQL.Clear;
      Qry.sql.Add('SELECT MAX(categoriaId) AS ' + 'newID' +
                  ' from categorias ');
      Qry.Open;                                         
      newID:=Qry.FieldByName('newID').AsInteger;
      Qry.SQL.Clear;
      QrySeq:= ('dbcc checkident (Categorias, reseed, ' + newID.ToString + ')');
      Qry.SQL.Add(QrySeq);
      Qry.ExecSQL;
    finally
      Qry.Close                                                  
    end;
  except
    Result:=False;
  end;

finally
  if (Assigned(Qry)) then
  begin
    FreeAndNil(Qry);
  end;
  
end;
end;

{$endRegion}
end.
