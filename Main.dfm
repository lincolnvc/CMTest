object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Avalia'#231#227'o de Desenvolvedores'
  ClientHeight = 470
  ClientWidth = 700
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 700
    Height = 57
    Align = alTop
    TabOrder = 0
    object lblTop: TLabel
      Left = 4
      Top = 6
      Width = 513
      Height = 45
      Alignment = taCenter
      AutoSize = False
      Caption = 
        'CASA MAGALH'#195'ES'#13#10'Avalia'#231#227'o T'#233'cnica 3 para Desenvolvedor'#13#10'Equipe S' +
        'ysPDV'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Button1: TButton
      Left = 608
      Top = 5
      Width = 81
      Height = 46
      Caption = 'Sair'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object pgMain: TPageControl
    Left = 0
    Top = 57
    Width = 700
    Height = 413
    ActivePage = tsBusca
    Align = alClient
    TabOrder = 1
    object tsBusca: TTabSheet
      Caption = 'Busca Perform'#225'tica'
      object pnBusca: TPanel
        Left = 0
        Top = 0
        Width = 692
        Height = 385
        Align = alClient
        BevelInner = bvLowered
        TabOrder = 0
        ExplicitLeft = 144
        ExplicitTop = 96
        ExplicitWidth = 185
        ExplicitHeight = 41
        object lblEstimativa: TLabel
          Left = 28
          Top = 42
          Width = 121
          Height = 13
          Caption = '~ 2 minutos 15 segundos'
        end
        object btnGerar: TButton
          Left = 12
          Top = 16
          Width = 153
          Height = 25
          Caption = 'Gerar e Carregar Lista'
          TabOrder = 0
          OnClick = btnGerarClick
        end
        object mmBusca: TMemo
          Left = 175
          Top = 18
          Width = 497
          Height = 351
          ScrollBars = ssVertical
          TabOrder = 1
        end
        object btnProcurar: TButton
          Left = 12
          Top = 143
          Width = 153
          Height = 25
          Caption = 'Pesquisar C'#243'digo do Produto'
          TabOrder = 2
          OnClick = btnProcurarClick
        end
        object edtPesquisa: TEdit
          Left = 12
          Top = 120
          Width = 152
          Height = 21
          TabOrder = 3
          OnKeyPress = edtPesquisaKeyPress
        end
      end
    end
    object tsJSON: TTabSheet
      Caption = 'Convers'#227'o de Objeto'
      ImageIndex = 1
      object pnJSON: TPanel
        Left = 0
        Top = 0
        Width = 692
        Height = 385
        Align = alClient
        BevelInner = bvLowered
        TabOrder = 0
        ExplicitLeft = 144
        ExplicitTop = 96
        ExplicitWidth = 185
        ExplicitHeight = 41
        object lblCodigo: TLabeledEdit
          Left = 14
          Top = 24
          Width = 43
          Height = 21
          EditLabel.Width = 33
          EditLabel.Height = 13
          EditLabel.Caption = 'C'#243'digo'
          TabOrder = 0
          Text = '1'
          OnKeyPress = lblCodigoKeyPress
        end
        object lblNome: TLabeledEdit
          Left = 14
          Top = 67
          Width = 147
          Height = 21
          EditLabel.Width = 27
          EditLabel.Height = 13
          EditLabel.Caption = 'Nome'
          TabOrder = 1
          Text = 'David'
        end
        object lblPeso: TLabeledEdit
          Left = 14
          Top = 114
          Width = 59
          Height = 21
          EditLabel.Width = 47
          EditLabel.Height = 13
          EditLabel.Caption = 'Peso (KG)'
          TabOrder = 2
          Text = '125,62'
          OnKeyPress = lblPesoKeyPress
        end
        object lblNascimento: TLabeledEdit
          Left = 14
          Top = 162
          Width = 107
          Height = 21
          EditLabel.Width = 96
          EditLabel.Height = 13
          EditLabel.Caption = 'Data de Nascimento'
          TabOrder = 3
          Text = '04/12/1973'
          OnKeyPress = lblNascimentoKeyPress
        end
        object chkCasado: TCheckBox
          Left = 16
          Top = 199
          Width = 97
          Height = 17
          Caption = 'Casado'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object btnJSON: TButton
          Left = 16
          Top = 232
          Width = 145
          Height = 25
          Caption = 'Gerar JSON'
          TabOrder = 5
          OnClick = btnJSONClick
        end
        object mmJSON: TMemo
          Left = 183
          Top = 16
          Width = 497
          Height = 241
          ScrollBars = ssVertical
          TabOrder = 6
        end
      end
    end
    object tsThread: TTabSheet
      Caption = 'Recurso Multi-thread'
      ImageIndex = 2
      object pnThread: TPanel
        Left = 0
        Top = 0
        Width = 692
        Height = 385
        Align = alClient
        BevelInner = bvLowered
        TabOrder = 0
        ExplicitLeft = 144
        ExplicitTop = 96
        ExplicitWidth = 185
        ExplicitHeight = 41
        object btnThread: TButton
          Left = 16
          Top = 16
          Width = 201
          Height = 25
          Caption = 'Grava e Carrega Listas'
          TabOrder = 0
          OnClick = btnThreadClick
        end
        object mmThread: TMemo
          Left = 16
          Top = 47
          Width = 313
          Height = 330
          ScrollBars = ssVertical
          TabOrder = 1
        end
        object mmThread1: TMemo
          Left = 346
          Top = 47
          Width = 313
          Height = 98
          ScrollBars = ssVertical
          TabOrder = 2
        end
        object mmThread2: TMemo
          Left = 346
          Top = 164
          Width = 313
          Height = 98
          ScrollBars = ssVertical
          TabOrder = 3
        end
        object mmThread3: TMemo
          Left = 346
          Top = 279
          Width = 313
          Height = 98
          ScrollBars = ssVertical
          TabOrder = 4
        end
      end
    end
  end
end
