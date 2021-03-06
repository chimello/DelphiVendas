unit cCadCliente;

interface

uses System.Classes,Vcl.Controls, Vcl.ExtCtrls, Vcl.Dialogs,
ZAbstractConnection, ZConnection, ZAbstractRODataset, ZAbstractDataset,
ZDataset, System.SysUtils; // Lista de Units


type
  TCliente = class
  private
  ConexaoDB:TZConnection;
  F_clienteid:Integer;
  F_nome:String;
  F_endereco:String;
  F_cidade:String;
  F_bairro:String;
  F_estado:String;
  F_cep:string;
  F_telefone:string;
  F_email:string;
  F_dataNascimento:TDateTime;
  F_tipoCliente:string;

  public
    constructor Create(aconexao:TZConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:Integer):Boolean;

  published
  property codigo         :integer    read F_clienteid        write F_clienteid;
  property nome           :String     read F_nome             write F_nome;
  property endereco       :String     read F_endereco         write F_endereco;
  property cidade         :String     read F_cidade           write F_cidade;
  property bairro         :String     read F_bairro           write F_bairro;
  property estado         :String     read F_estado           write F_estado;
  property cep            :String     read F_cep              write F_cep;
  property telefone       :String     read F_telefone         write F_telefone;
  property email          :String     read F_email            write F_email;
  property dataNascimento :TDateTime  read F_dataNascimento   write F_dataNascimento;
  property tipoCliente    :string     read F_tipoCliente      write F_tipoCliente;
  end;

implementation

{$region 'Constructor and Destructor'}
constructor TCliente.Create(aConexao:TZConnection);
begin
  ConexaoDB:=aConexao;
end;

destructor TCliente.Destroy;
begin
  inherited;
end;
{$endRegion}

{$region 'Manipula Dados'}

function TCliente.Selecionar(id: Integer): Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT clienteId,'+
                '       nome, '+
                '       endereco, '+
                '       cidade, '+
                '       bairro, '+
                '       estado, '+
                '       cep, '+
                '       telefone, '+
                '       email, '+
                '       datanascimento, '+
                '       tipoCliente ' +
                '  FROM clientes '+
                ' WHERE clienteId=:clienteId');
    Qry.ParamByName('clienteId').AsInteger:=id;
    Try
      Qry.Open;

      Self.F_clienteId     := Qry.FieldByName('clienteId').AsInteger;
      Self.F_nome          := Qry.FieldByName('nome').AsString;
      Self.F_endereco      := Qry.FieldByName('endereco').AsString;
      Self.F_cidade        := Qry.FieldByName('cidade').AsString;
      Self.F_bairro        := Qry.FieldByName('bairro').AsString;
      Self.F_estado        := Qry.FieldByName('estado').AsString;
      Self.F_cep           := Qry.FieldByName('cep').AsString;
      Self.F_telefone      := Qry.FieldByName('telefone').AsString;
      Self.F_email         := Qry.FieldByName('email').AsString;
      Self.F_dataNascimento:= Qry.FieldByName('datanascimento').AsDateTime;
      Self.F_tipoCliente   := Qry.FieldByName('tipoCliente').AsString;

    Except
      Result:=false;
    End;

  finally
    if Assigned(Qry) then
       FreeAndNil(Qry);
  end;
end;

function TCliente.Atualizar: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE clientes '+
                '   SET nome            =:nome '+
                '       ,endereco       =:endereco '+
                '       ,cidade         =:cidade '+
                '       ,bairro         =:bairro '+
                '       ,estado         =:estado '+
                '       ,cep            =:cep '+
                '       ,telefone       =:telefone '+
                '       ,email          =:email '+
                '       ,dataNascimento =:dataNascimento '+
                '       ,tipoCliente     =:tipoCliente ' +
                ' WHERE clienteId=:clienteId ');
    Qry.ParamByName('clienteId').AsInteger       :=Self.F_clienteId;
    Qry.ParamByName('nome').AsString             :=Self.F_nome;
    Qry.ParamByName('endereco').AsString         :=Self.F_endereco;
    Qry.ParamByName('cidade').AsString           :=Self.F_cidade;
    Qry.ParamByName('bairro').AsString           :=Self.F_bairro;
    Qry.ParamByName('estado').AsString           :=Self.F_estado;
    Qry.ParamByName('cep').AsString              :=Self.F_cep;
    Qry.ParamByName('telefone').AsString         :=Self.F_telefone;
    Qry.ParamByName('email').AsString            :=Self.F_email;
    Qry.ParamByName('dataNascimento').AsDateTime :=Self.F_dataNascimento;
    Qry.ParamByName('tipoCliente').AsString      :=Self.F_tipoCliente;


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

function TCliente.Inserir: Boolean;
var Qry:TZQuery;
begin
  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('INSERT INTO clientes (nome, '+
                '                      endereco, '+
                '                      cidade,  '+
                '                      bairro,  '+
                '                      estado, '+
                '                      cep, '+
                '                      telefone, '+
                '                      email, '+
                '                      datanascimento, ' +
                '                      tipoCliente ) '+
                ' VALUES              (:nome, '+
                '                      :endereco, '+
                '                      :cidade,  '+
                '                      :bairro,  '+
                '                      :estado, '+
                '                      :cep, '+
                '                      :telefone, '+
                '                      :email, '+
                '                      :datanascimento, ' +
                '                      :tipoCliente)' );

    Qry.ParamByName('nome').AsString             :=Self.F_nome;
    Qry.ParamByName('endereco').AsString         :=Self.F_endereco;
    Qry.ParamByName('cidade').AsString           :=Self.F_cidade;
    Qry.ParamByName('bairro').AsString           :=Self.F_bairro;
    Qry.ParamByName('estado').AsString           :=Self.F_estado;
    Qry.ParamByName('cep').AsString              :=Self.F_cep;
    Qry.ParamByName('telefone').AsString         :=Self.F_telefone;
    Qry.ParamByName('email').AsString            :=Self.F_email;
    Qry.ParamByName('dataNascimento').AsDateTime :=Self.F_dataNascimento;
    Qry.ParamByName('tipoCliente').AsString      :=Self.F_tipoCliente;

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

function TCliente.Apagar: Boolean;
var Qry:TZQuery;
var newID:Integer;
var Qryseq:string;
begin
  if MessageDlg('Apagar o Registro: '+#13+#13+
                'C?digo: '+IntToStr(F_clienteId)+#13+
                'Descri??o: '+F_nome,mtConfirmation,[mbYes, mbNo],0)=mrNo then begin
     Result:=false;
     abort;
  end;

  try
    Result:=true;
    Qry:=TZQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('DELETE FROM clientes '+
                ' WHERE clienteId=:clienteId ');
    Qry.ParamByName('clienteId').AsInteger :=F_clienteId;
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
      Qry.sql.Add('SELECT MAX(clienteId) AS ' + 'newID' +
                  ' from clientes ');
      Qry.Open;
      newID:=Qry.FieldByName('newID').AsInteger;
      Qry.SQL.Clear;
      QrySeq:= ('dbcc checkident (clientes, reseed, ' + newID.ToString + ')');
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
{$endregion}

end.
