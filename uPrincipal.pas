unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, uDTMConexao, Enter,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, ZAbstractConnection, ZConnection,
  Vcl.StdCtrls, Vcl.Mask, RxToolEdit, uFrmAtualizaDB, Data.FMTBcd,
  Datasnap.Provider, Data.DB, Data.SqlExpr, Datasnap.DBClient, RxCtrls, RLReport;

type
  TfrmPrincipal = class(TForm)
    mainPrincipal: TMainMenu;
    Cadastro1: TMenuItem;
    Movimentao1: TMenuItem;
    Relatrio1: TMenuItem;
    Cliente1: TMenuItem;
    N1: TMenuItem;
    Categoria1: TMenuItem;
    Produto1: TMenuItem;
    N2: TMenuItem;
    mnuFechar: TMenuItem;
    Vendas1: TMenuItem;
    Cliente2: TMenuItem;
    N3: TMenuItem;
    Produto2: TMenuItem;
    N4: TMenuItem;
    VendaporData1: TMenuItem;
    imgPrincipal: TImage;
    Estoque1: TMenuItem;
    Entradas1: TMenuItem;
    N5: TMenuItem;
    Sadas1: TMenuItem;
    Fornecedores1: TMenuItem;
    MovimentaodeEstoque1: TMenuItem;
    Sobre1: TMenuItem;
    SobreoSistema1: TMenuItem;
    procedure mnuFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Categoria1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Cliente1Click(Sender: TObject);
    procedure Produto1Click(Sender: TObject);
    procedure Vendas1Click(Sender: TObject);
    procedure Entradas1Click(Sender: TObject);
    procedure SobreoSistema1Click(Sender: TObject);
  private
    { Private declarations }
    TeclaEnter: TMREnter;
    procedure AtualizacaoBancoDados(aForm: TfrmAtualizaDB);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses uCadCategoria, uCadCliente, uCadProduto, uProVendas, uProEntradaEstoque, uSobreOSistema;

procedure TfrmPrincipal.Categoria1Click(Sender: TObject);
begin
  frmCadCategoria := TfrmCadCategoria.Create(Self);
  frmCadCategoria.ShowModal;
  frmCadCategoria.Release;
end;

procedure TfrmPrincipal.Cliente1Click(Sender: TObject);
begin
  frmCadCliente := TfrmCadCliente.Create(Self);
  frmCadCliente.ShowModal;
  frmCadCliente.Release;
end;

procedure TfrmPrincipal.Entradas1Click(Sender: TObject);
begin
  frmProEntradaEstoque := TfrmProEntradaEstoque.Create(Self);
  frmProEntradaEstoque.ShowModal;
  frmProEntradaEstoque.Release;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(TeclaEnter);
  FreeAndNil(dtmPrincipal);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var vConexao : TZConnection;
begin
  frmAtualizaDB:=TfrmAtualizaDB.Create(Self);
  frmAtualizaDB.Show;
  frmAtualizaDB.Refresh;
  dtmPrincipal := TdtmPrincipal.Create(Self);
  vConexao:= dtmPrincipal.ConexaoDB;
  vConexao.SQLHourGlass := True;
  vConexao.Protocol := 'mssql';
  vConexao.LibraryLocation :=
    'D:\000_Projetos_Delphi\Projetos\ProjetoDelphi\ntwdblib.dll';
  vConexao.HostName := '.\SERVERCURSO';
  vConexao.Port := 1433;
  vConexao.User := 'sa';
  vConexao.Password := '124565';
  vConexao.Database := 'VENDAS';
  vConexao.Connected := True;

  AtualizacaoBancoDados(frmAtualizaDB);
  frmAtualizaDB.Free;

  TeclaEnter := TMREnter.Create(Self);
  TeclaEnter.FocusEnabled := True;
  TeclaEnter.FocusColor:=clInfoBk;

end;

procedure TfrmPrincipal.mnuFecharClick(Sender: TObject);
begin
  // Close;
  Application.Terminate;
end;

procedure TfrmPrincipal.Produto1Click(Sender: TObject);
begin
  frmCadProduto := TfrmCadProduto.Create(Self);
  frmCadProduto.ShowModal;
  frmCadProduto.Release;
end;

procedure TfrmPrincipal.SobreoSistema1Click(Sender: TObject);
begin
  frmSobreOSistema := TfrmSobreOSistema.Create(Self);
  frmSobreOSistema.ShowModal;
  frmSobreOSistema.Release;
end;

procedure TfrmPrincipal.Vendas1Click(Sender: TObject);
begin
  frmProVenda := TfrmProVenda.Create(Self);
  frmProVenda.ShowModal;
  frmProVenda.Release;
end;

procedure TfrmPrincipal.AtualizacaoBancoDados(aForm:TfrmAtualizaDB);
begin
  aForm.chkConexao.Checked := True;
  aForm.Refresh;
  Sleep(20);

  dtmPrincipal.qryScriptCategorias.ExecSQL;
  aForm.chkCategoria.Checked := True;
  aForm.Refresh;
  Sleep(20);

  dtmPrincipal.qryScriptProdutos.ExecSQL;
  aForm.chkProduto.Checked := True;
  aForm.Refresh;
  Sleep(20);

  dtmPrincipal.qryScriptClientes.ExecSQL;
  aForm.chkCliente.Checked := True;
  aForm.Refresh;
  Sleep(20);

  dtmPrincipal.qryScriptVendas.ExecSQL;
  aForm.chkVendas.Checked := True;
  aForm.Refresh;
  Sleep(20);

  dtmPrincipal.qryScriptItensVendas.ExecSQL;
  aForm.chkItensVendas.Checked := True;
  aForm.Refresh;
  Sleep(20);

end;

end.
