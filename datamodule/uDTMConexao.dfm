object dtmPrincipal: TdtmPrincipal
  OldCreateOrder = False
  Height = 304
  Width = 632
  object conexaoDB: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = ''
    Connected = True
    SQLHourGlass = True
    HostName = '.\SERVERCURSO'
    Port = 1433
    Database = 'VENDAS'
    User = 'sa'
    Password = '124565'
    Protocol = 'mssql'
    LibraryLocation = 'D:\000_Projetos_Delphi\Projetos\ProjetoDelphi\ntwdblib.dll'
    Left = 72
    Top = 40
  end
  object qryScriptCategorias: TZQuery
    Connection = conexaoDB
    SQL.Strings = (
      'IF OBJECT_ID ('#39'categorias'#39') is null'
      'begin'
      '  CREATE TABLE CATEGORIAS ('
      #9'  CATEGORIAID INTEGER NOT NULL identity PRIMARY KEY,'
      #9'  DESCRICAO VARCHAR(30) NULL'
      ')'
      'end')
    Params = <>
    Left = 160
    Top = 40
  end
  object qryScriptClientes: TZQuery
    Connection = conexaoDB
    SQL.Strings = (
      'IF OBJECT_ID ('#39'clientes'#39') is null'
      'begin'
      '   CREATE TABLE clientes('
      #9#9'clienteId int IDENTITY(1,1) NOT NULL,'
      #9#9'nome varchar(60) NULL,'
      #9#9'endereco varchar(60) null,'
      #9#9'cidade varchar(50) null,'
      #9#9'bairro varchar(40) null,'
      #9#9'estado varchar(2) null,'
      #9#9'cep varchar(10) null,'
      #9#9'telefone varchar(14) null,'
      #9#9'email varchar(100) null,'
      #9#9'dataNascimento datetime null,'
      '    tipoCliente char(4)'
      #9#9'PRIMARY KEY (clienteId),'
      #9')'
      'end')
    Params = <>
    Left = 264
    Top = 40
  end
  object qryScriptProdutos: TZQuery
    Connection = conexaoDB
    SQL.Strings = (
      'IF OBJECT_ID ('#39'produtos'#39') is null'
      'begin'
      '   CREATE TABLE produtos('
      #9#9'produtoId int IDENTITY(1,1) NOT NULL,'
      #9#9'nome varchar(60) NULL,'
      #9#9'descricao varchar(255) null,'
      #9#9'valor decimal(18,5) default 0.00000 null,'
      #9#9'quantidade decimal(18,5) default 0.00000 null,'
      #9#9'categoriaId int null,'
      #9#9'PRIMARY KEY (produtoId),'
      #9#9'CONSTRAINT FK_ProdutosCategorias'
      #9#9'FOREIGN KEY (categoriaId) references categorias(categoriaId)'
      #9')'
      'end')
    Params = <>
    Left = 352
    Top = 40
  end
  object qryScriptVendas: TZQuery
    Connection = conexaoDB
    SQL.Strings = (
      'IF OBJECT_ID ('#39'vendas'#39') IS NULL'
      'BEGIN'
      '   create table VENDAS ('
      #9'vendaId int identity(1,1) not null,'
      #9'clienteId int not null,'
      #9'dataVenda datetime default getdate(),'
      #9'totalVenda decimal(18,5) default 0.00000,'
      ''
      #9'primary key (vendaId),'
      
        #9'constraint FK_VendasClientes FOREIGN KEY (clienteId) references' +
        ' clientes(clienteId)'
      ')'
      'END')
    Params = <>
    Left = 440
    Top = 40
  end
  object qryScriptItensVendas: TZQuery
    Connection = conexaoDB
    SQL.Strings = (
      'IF OBJECT_ID ('#39'vendasitens'#39') IS NULL'
      'BEGIN'
      '   create table vendasItens ('
      #9'vendaId int not null,'
      #9'produtoId int not null,'
      #9'dataVenda datetime default getdate(),'
      #9'valorUnitario decimal (18,5) default 0.00000,'
      #9'quantidade decimal (18,5) default 0.00000,'
      #9'totalProduto decimal (18,5) default 0.00000,'
      #9'primary key (vendaId, produtoId),'
      
        #9'constraint FK_VendasItensProdutos foreign key (produtoId) refer' +
        'ences produtos(produtoId)'
      ')'
      'END')
    Params = <>
    Left = 536
    Top = 40
  end
end
