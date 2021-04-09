inherited frmCadCategoria: TfrmCadCategoria
  Caption = 'Manuten'#231#227'o de Categorias'
  ClientHeight = 537
  ClientWidth = 1046
  ExplicitWidth = 1062
  ExplicitHeight = 576
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlRodape: TPanel
    Top = 496
    Width = 1046
    ExplicitTop = 496
    ExplicitWidth = 1046
    inherited btnFechar: TBitBtn
      Left = 967
      ExplicitLeft = 967
    end
    inherited btnNavigator: TDBNavigator
      Hints.Strings = ()
    end
  end
  inherited pgcPrincipal: TPageControl
    Width = 1046
    Height = 496
    ExplicitWidth = 1046
    ExplicitHeight = 496
    inherited tabListagem: TTabSheet
      ExplicitWidth = 1038
      ExplicitHeight = 468
      inherited pnlListagemTopo: TPanel
        Width = 1038
        ExplicitWidth = 1038
        inherited btnPesquisar: TBitBtn
          Left = 396
          ExplicitLeft = 396
        end
      end
      inherited grdListagem: TDBGrid
        Width = 1038
        Height = 417
        DataSource = dtsListagem
        Columns = <
          item
            Expanded = False
            FieldName = 'CATEGORIAID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESCRICAO'
            Visible = True
          end>
      end
    end
    inherited tabManutencao: TTabSheet
      ExplicitWidth = 1038
      ExplicitHeight = 468
      object edtCategoriaID: TLabeledEdit
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
      object edtDescricao: TLabeledEdit
        Tag = 2
        Left = 11
        Top = 104
        Width = 414
        Height = 21
        EditLabel.Width = 46
        EditLabel.Height = 13
        EditLabel.Caption = 'Descri'#231#227'o'
        MaxLength = 30
        TabOrder = 1
      end
    end
  end
  inherited qryListagem: TZQuery
    SQL.Strings = (
      'select CATEGORIAID, DESCRICAO'
      'from CATEGORIAS order by CATEGORIAID ASC')
    object qryListagemCATEGORIAID: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'CATEGORIAID'
      ReadOnly = True
    end
    object qryListagemDESCRICAO: TWideStringField
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'DESCRICAO'
      Size = 30
    end
  end
  inherited dtsListagem: TDataSource
    Top = 32
  end
end
