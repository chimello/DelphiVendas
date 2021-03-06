inherited frmCadProduto: TfrmCadProduto
  Caption = 'Manuten'#231#227'o de Produtos'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlRodape: TPanel
    inherited btnNavigator: TDBNavigator
      Hints.Strings = ()
    end
  end
  inherited pgcPrincipal: TPageControl
    ActivePage = tabManutencao
    inherited tabListagem: TTabSheet
      inherited grdListagem: TDBGrid
        DataSource = dtsListagem
        Columns = <
          item
            Expanded = False
            FieldName = 'PRODUTOID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOME'
            Width = 235
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VALOR'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'QUANTIDADE'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESCRICAOCATEGORIA'
            Visible = True
          end>
      end
    end
    inherited tabManutencao: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 1047
      ExplicitHeight = 471
      object lblDescricao: TLabel
        Left = 11
        Top = 144
        Width = 46
        Height = 13
        Caption = 'Descri'#231#227'o'
      end
      object lblValor: TLabel
        Left = 11
        Top = 413
        Width = 24
        Height = 13
        Caption = 'Valor'
      end
      object lblQuantidade: TLabel
        Left = 151
        Top = 413
        Width = 74
        Height = 13
        Caption = 'Quantidade'
      end
      object lblCategoria: TLabel
        Left = 440
        Top = 85
        Width = 47
        Height = 13
        Caption = 'Categoria'
      end
      object edtProdutoId: TLabeledEdit
        Tag = 1
        Left = 11
        Top = 48
        Width = 121
        Height = 21
        EditLabel.Width = 33
        EditLabel.Height = 13
        EditLabel.Caption = 'C'#243'digo'
        MaxLength = 10
        NumbersOnly = True
        TabOrder = 0
      end
      object edtNome: TLabeledEdit
        Tag = 2
        Left = 11
        Top = 104
        Width = 414
        Height = 21
        EditLabel.Width = 27
        EditLabel.Height = 13
        EditLabel.Caption = 'Nome'
        MaxLength = 60
        TabOrder = 1
      end
      object edtQuantidade: TCurrencyEdit
        Left = 151
        Top = 432
        Width = 121
        Height = 21
        DisplayFormat = ' ,0.00;- ,0.00'
        TabOrder = 5
      end
      object edtDescricao: TMemo
        Left = 11
        Top = 163
        Width = 1017
        Height = 81
        Lines.Strings = (
          'edtDescricao')
        MaxLength = 255
        TabOrder = 3
      end
      object edtValor: TCurrencyEdit
        Left = 11
        Top = 432
        Width = 121
        Height = 21
        TabOrder = 4
        OnChange = edtValorChange
      end
      object lkpCategoria: TDBLookupComboBox
        Left = 440
        Top = 104
        Width = 217
        Height = 21
        KeyField = 'categoriaid'
        ListField = 'descricao'
        ListSource = dtsCategoria
        TabOrder = 2
      end
    end
  end
  inherited qryListagem: TZQuery
    SQL.Strings = (
      'SELECT P.PRODUTOID,'
      'P.NOME,'
      'P.DESCRICAO,'
      'P.VALOR,'
      'P.QUANTIDADE,'
      'P.CATEGORIAID,'
      'C.DESCRICAO AS DESCRICAOCATEGORIA'
      'FROM PRODUTOS AS P'
      'LEFT JOIN CATEGORIAS AS C ON C.CATEGORIAID = P.CATEGORIAID')
    object qryListagemPRODUTOID: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'PRODUTOID'
      ReadOnly = True
    end
    object qryListagemNOME: TWideStringField
      DisplayLabel = 'Nome'
      FieldName = 'NOME'
      Size = 60
    end
    object qryListagemDESCRICAO: TWideStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'DESCRICAO'
      Size = 255
    end
    object qryListagemVALOR: TFloatField
      DisplayLabel = 'Valor'
      FieldName = 'VALOR'
    end
    object qryListagemQUANTIDADE: TFloatField
      DisplayLabel = 'Quantidade'
      FieldName = 'QUANTIDADE'
    end
    object qryListagemCATEGORIAID: TIntegerField
      DisplayLabel = 'C'#243'digo Categoria'
      FieldName = 'CATEGORIAID'
    end
    object qryListagemDESCRICAOCATEGORIA: TWideStringField
      DisplayLabel = 'Descri'#231#227'o Categoria'
      FieldName = 'DESCRICAOCATEGORIA'
      Size = 30
    end
  end
  object qryCategoria: TZQuery
    Connection = dtmPrincipal.conexaoDB
    SQL.Strings = (
      'select'
      'categoriaid,'
      'descricao'
      'from categorias')
    Params = <>
    Left = 688
    Top = 128
    object qryCategoriacategoriaid: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'categoriaid'
      ReadOnly = True
    end
    object qryCategoriadescricao: TWideStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descricao'
      Size = 30
    end
  end
  object dtsCategoria: TDataSource
    DataSet = qryCategoria
    Left = 752
    Top = 128
  end
end
