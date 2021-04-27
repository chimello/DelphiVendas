object DTMEntradaEstoque: TDTMEntradaEstoque
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 286
  Width = 554
  object qryFornecedor: TZQuery
    Connection = dtmPrincipal.conexaoDB
    SQL.Strings = (
      'SELECT clienteId,'
      '       nome'
      'FROM clientes'
      'where tipoCliente = '#39'FORN'#39)
    Params = <>
    Left = 24
    Top = 24
    object qryFornecedorclienteId: TIntegerField
      FieldName = 'clienteId'
      ReadOnly = True
    end
    object qryFornecedornome: TWideStringField
      FieldName = 'nome'
      Size = 60
    end
  end
  object qryProdutos: TZQuery
    Connection = dtmPrincipal.conexaoDB
    SQL.Strings = (
      'SELECT produtoid,'
      '       nome,'
      '       valor,'
      '       quantidade'
      'FROM produtos')
    Params = <>
    Left = 112
    Top = 24
    object qryProdutosprodutoid: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'produtoid'
      ReadOnly = True
    end
    object qryProdutosnome: TWideStringField
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Size = 60
    end
    object qryProdutosvalor: TFloatField
      DisplayLabel = 'Valor'
      FieldName = 'valor'
    end
    object qryProdutosquantidade: TFloatField
      DisplayLabel = 'Quantidade'
      FieldName = 'quantidade'
    end
  end
  object cdsItensEntrada: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 488
    Top = 8
    object cdsItensEntradaprodutoid: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'produtoId'
    end
    object cdsItensEntradaNomeProduto: TStringField
      DisplayLabel = 'Nome do Produto'
      FieldName = 'NomeProduto'
    end
    object cdsItensEntradaQuantidade: TFloatField
      FieldName = 'Quantidade'
    end
    object cdsItensEntradavalorUnitario: TFloatField
      DisplayLabel = 'Valor Unitario'
      FieldName = 'valorUnitario'
    end
    object cdsItensEntradaValorTotalProduto: TFloatField
      DisplayLabel = 'Valor Total do Produto'
      FieldName = 'ValorTotalProduto'
    end
  end
  object dtsFornecedor: TDataSource
    DataSet = qryFornecedor
    Left = 24
    Top = 80
  end
  object dtsProdutos: TDataSource
    DataSet = qryProdutos
    Left = 112
    Top = 80
  end
  object dtsItensEntradas: TDataSource
    DataSet = cdsItensEntrada
    Left = 488
    Top = 72
  end
end
