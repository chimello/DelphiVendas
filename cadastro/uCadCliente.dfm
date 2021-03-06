inherited frmCadCliente: TfrmCadCliente
  Caption = 'Manuten'#231#227'o de Pessoas'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlRodape: TPanel
    inherited btnNavigator: TDBNavigator
      Hints.Strings = ()
    end
  end
  inherited pgcPrincipal: TPageControl
    OnChange = pgcPrincipalChange
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
            FieldName = 'clienteid'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nome'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'tipoCliente'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'endereco'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'cidade'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'bairro'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'estado'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'cep'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'telefone'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'email'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dataNascimento'
            Visible = True
          end>
      end
    end
    inherited tabManutencao: TTabSheet
      object Label1: TLabel
        Left = 438
        Top = 133
        Width = 19
        Height = 13
        Caption = 'CEP'
      end
      object Label2: TLabel
        Left = 438
        Top = 85
        Width = 42
        Height = 13
        Caption = 'Telefone'
      end
      object Label3: TLabel
        Left = 438
        Top = 181
        Width = 96
        Height = 13
        Caption = 'Data de Nascimento'
      end
      object Label4: TLabel
        Left = 150
        Top = 21
        Width = 61
        Height = 13
        Caption = 'Tipo Pessoa:'
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
      object edtClienteId: TLabeledEdit
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
      object edtCEP: TMaskEdit
        Left = 438
        Top = 152
        Width = 78
        Height = 21
        EditMask = '99.999-999;1;_'
        MaxLength = 10
        TabOrder = 4
        Text = '  .   -   '
      end
      object edtEndereco: TLabeledEdit
        Left = 11
        Top = 152
        Width = 414
        Height = 21
        EditLabel.Width = 45
        EditLabel.Height = 13
        EditLabel.Caption = 'Endere'#231'o'
        MaxLength = 60
        TabOrder = 3
      end
      object edtBairro: TLabeledEdit
        Left = 535
        Top = 152
        Width = 234
        Height = 21
        EditLabel.Width = 28
        EditLabel.Height = 13
        EditLabel.Caption = 'Bairro'
        MaxLength = 40
        TabOrder = 5
      end
      object edtCidade: TLabeledEdit
        Left = 787
        Top = 152
        Width = 198
        Height = 21
        EditLabel.Width = 33
        EditLabel.Height = 13
        EditLabel.Caption = 'Cidade'
        MaxLength = 50
        TabOrder = 6
      end
      object edtTelefone: TMaskEdit
        Left = 438
        Top = 104
        Width = 106
        Height = 21
        EditMask = '(99) 9 9999-9999;1;'
        MaxLength = 16
        TabOrder = 2
        Text = '(  )       -    '
      end
      object edtEmail: TLabeledEdit
        Left = 11
        Top = 200
        Width = 414
        Height = 21
        EditLabel.Width = 28
        EditLabel.Height = 13
        EditLabel.Caption = 'E-mail'
        MaxLength = 100
        TabOrder = 7
      end
      object edtdataNascimento: TDateEdit
        Left = 438
        Top = 200
        Width = 121
        Height = 21
        ClickKey = 114
        DialogTitle = 'Selecione a Data'
        NumGlyphs = 2
        CalendarStyle = csDialog
        TabOrder = 8
      end
      object rdgTipoCliente: TRadioGroup
        Left = 150
        Top = 40
        Width = 275
        Height = 41
        TabOrder = 9
      end
      object rbCliente: TRadioButton
        Left = 171
        Top = 50
        Width = 113
        Height = 17
        Caption = 'Cliente'
        TabOrder = 10
      end
      object rbFornecedor: TRadioButton
        Left = 290
        Top = 50
        Width = 113
        Height = 17
        Caption = 'Fornecedor'
        TabOrder = 11
      end
    end
  end
  inherited qryListagem: TZQuery
    SQL.Strings = (
      'select clienteid,'
      #9'   nome,'
      #9'   endereco,'
      #9'   cidade,'
      #9'   bairro,'
      #9'   estado,'
      #9'   cep,'
      #9'   telefone,'
      #9'   email,'
      #9'   dataNascimento,'
      
        '       case tipoCliente when '#39'CLIE'#39' then '#39'Cliente'#39' else '#39'Fornece' +
        'dor'#39' end as tipoCliente'
      'from clientes'
      'order by clienteid asc')
    Left = 912
    object qryListagemclienteid: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'clienteid'
      ReadOnly = True
    end
    object qryListagemnome: TWideStringField
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Size = 60
    end
    object qryListagemendereco: TWideStringField
      DisplayLabel = 'Endere'#231'o'
      FieldName = 'endereco'
      Size = 60
    end
    object qryListagemcidade: TWideStringField
      DisplayLabel = 'Cidade'
      FieldName = 'cidade'
      Size = 50
    end
    object qryListagembairro: TWideStringField
      DisplayLabel = 'Bairro'
      FieldName = 'bairro'
      Size = 40
    end
    object qryListagemestado: TWideStringField
      DisplayLabel = 'Estado'
      FieldName = 'estado'
      Size = 2
    end
    object qryListagemcep: TWideStringField
      DisplayLabel = 'CEP'
      FieldName = 'cep'
      Size = 10
    end
    object qryListagemtelefone: TWideStringField
      DisplayLabel = 'Telefone'
      FieldName = 'telefone'
      Size = 16
    end
    object qryListagememail: TWideStringField
      DisplayLabel = 'E-mail'
      FieldName = 'email'
      Size = 100
    end
    object qryListagemdataNascimento: TDateTimeField
      DisplayLabel = 'Data de Nascimento'
      FieldName = 'dataNascimento'
    end
    object qryListagemtipoCliente: TWideStringField
      DisplayLabel = 'Tipo do Cliente'
      FieldName = 'tipoCliente'
      Size = 4
    end
  end
  inherited dtsListagem: TDataSource
    Left = 976
  end
end
