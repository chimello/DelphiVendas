inherited frmProEntradaEstoque: TfrmProEntradaEstoque
  Caption = 'Entrada de Estoque'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlRodape: TPanel
    inherited btnNavigator: TDBNavigator
      Hints.Strings = ()
    end
  end
  inherited pgcPrincipal: TPageControl
    inherited tabListagem: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 1047
      ExplicitHeight = 471
      inherited grdListagem: TDBGrid
        DataSource = dtsListagem
        Columns = <
          item
            Expanded = False
            FieldName = 'codiestoque'
            Width = 88
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nome'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dataEntrada'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ValorTotal'
            Visible = True
          end>
      end
    end
    inherited tabManutencao: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 1047
      ExplicitHeight = 471
      object lblFornecedor: TLabel
        Left = 152
        Top = 29
        Width = 55
        Height = 13
        Caption = 'Fornecedor'
      end
      object Label3: TLabel
        Left = 907
        Top = 29
        Width = 64
        Height = 13
        Caption = 'Data Entrada'
      end
      object edtDataEntrada: TDateEdit
        Left = 907
        Top = 48
        Width = 121
        Height = 21
        ClickKey = 114
        DialogTitle = 'Selecione a Data'
        NumGlyphs = 2
        CalendarStyle = csDialog
        TabOrder = 0
      end
      object lkpFornecedor: TDBLookupComboBox
        Left = 152
        Top = 48
        Width = 649
        Height = 21
        KeyField = 'clienteId'
        ListField = 'nome'
        ListSource = DTMEntradaEstoque.dtsFornecedor
        TabOrder = 1
      end
      object edtVendaId: TLabeledEdit
        Tag = 1
        Left = 3
        Top = 48
        Width = 121
        Height = 21
        EditLabel.Width = 78
        EditLabel.Height = 13
        EditLabel.Caption = 'N'#250'mero Entrada'
        MaxLength = 10
        NumbersOnly = True
        TabOrder = 2
      end
    end
  end
  inherited qryListagem: TZQuery
    SQL.Strings = (
      'SELECT '
      #9'ee.codiestoque,'
      #9'c.nome, '
      #9'ee.dataEntrada,'
      #9'ee.ValorTotal '
      'from entradaEstoque ee'
      'inner join clientes c on ee.clienteId = c.clienteId')
    Left = 528
    Top = 65528
    object qryListagemcodiestoque: TIntegerField
      DisplayLabel = 'C'#243'digo Entrada'
      FieldName = 'codiestoque'
      Required = True
    end
    object qryListagemnome: TWideStringField
      DisplayLabel = 'Fornecedor'
      FieldName = 'nome'
      Size = 60
    end
    object qryListagemdataEntrada: TDateTimeField
      DisplayLabel = 'Data da Entrada'
      FieldName = 'dataEntrada'
    end
    object qryListagemValorTotal: TFloatField
      DisplayLabel = 'Valor Total'
      FieldName = 'ValorTotal'
    end
  end
  inherited dtsListagem: TDataSource
    Left = 464
    Top = 65528
  end
end
