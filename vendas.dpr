program vendas;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uDTMConexao in 'datamodule\uDTMConexao.pas' {dtmPrincipal: TDataModule},
  uTelaHeranca in 'heranca\uTelaHeranca.pas' {frmTelaHeranca},
  uCadCategoria in 'cadastro\uCadCategoria.pas' {frmCadCategoria},
  Enter in 'terceiros\Enter.pas',
  uEnum in 'heranca\uEnum.pas',
  cCadCategoria in 'classes\cCadCategoria.pas',
  uCadCliente in 'cadastro\uCadCliente.pas' {frmCadCliente},
  cCadCliente in 'classes\cCadCliente.pas',
  uCadProduto in 'cadastro\uCadProduto.pas' {frmCadProduto},
  cCadProduto in 'classes\cCadProduto.pas',
  uFrmAtualizaDB in 'datamodule\uFrmAtualizaDB.pas' {frmAtualizaDB},
  uDTMVenda in 'datamodule\uDTMVenda.pas' {dtmVenda: TDataModule},
  uProVendas in 'processo\uProVendas.pas' {frmProVenda},
  cProVenda in 'classes\cProVenda.pas',
  cControleEstoque in 'classes\cControleEstoque.pas' {$R *.res},
  uProEntradaEstoque in 'processo\uProEntradaEstoque.pas' {frmProEntradaEstoque},
  uSobreOSistema in 'informacoes\uSobreOSistema.pas' {frmSobreOSistema},
  uDTMEntradaEstoque in 'datamodule\uDTMEntradaEstoque.pas' {DTMEntradaEstoque: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDTMEntradaEstoque, DTMEntradaEstoque);
  Application.Run;
end.
