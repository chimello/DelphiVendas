object dtmVenda: TdtmVenda
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 256
  Width = 552
  object qryCliente: TZQuery
    Connection = dtmPrincipal.conexaoDB
    SQL.Strings = (
      'SELECT clienteId,'
      '       nome'
      'FROM clientes'
      'where tipoCliente = '#39'CLIE'#39)
    Params = <>
    Left = 24
    Top = 24
    object qryClienteclienteId: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'clienteId'
      ReadOnly = True
    end
    object qryClientenome: TWideStringField
      DisplayLabel = 'Nome'
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
  object cdsItensVenda: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 488
    Top = 8
    object cdsItensVendaprodutoid: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'produtoId'
    end
    object cdsItensVendaNomeProduto: TStringField
      DisplayLabel = 'Nome do Produto'
      FieldName = 'NomeProduto'
    end
    object cdsItensVendaQuantidade: TFloatField
      FieldName = 'Quantidade'
    end
    object cdsItensVendavalorUnitario: TFloatField
      DisplayLabel = 'Valor Unitario'
      FieldName = 'valorUnitario'
    end
    object cdsItensVendaValorTotalProduto: TFloatField
      DisplayLabel = 'Valor Total do Produto'
      FieldName = 'ValorTotalProduto'
    end
  end
  object dtsCliente: TDataSource
    DataSet = qryCliente
    Left = 24
    Top = 80
  end
  object dtsProdutos: TDataSource
    DataSet = qryProdutos
    Left = 112
    Top = 80
  end
  object dtsItensVendas: TDataSource
    DataSet = cdsItensVenda
    Left = 488
    Top = 72
  end
end
