object ExtsForm: TExtsForm
  Left = 114
  Top = 47
  Width = 439
  Height = 269
  Caption = 'Choose Extensions Form'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 264
    Top = 32
    Width = 135
    Height = 60
    Caption = 'Select extensions '#13#10'which must be '#13#10'in the directory tree'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object AcceptListBox: TListBox
    Left = 72
    Top = 32
    Width = 65
    Height = 113
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    ItemHeight = 20
    Items.Strings = (
      'HTM'
      'HTML'
      'XML'
      '')
    ParentFont = False
    TabOrder = 0
    OnClick = AcceptListBoxClick
  end
  object AcceptedEdit: TEdit
    Left = 144
    Top = 40
    Width = 81
    Height = 28
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    MaxLength = 4
    ParentFont = False
    TabOrder = 1
    OnChange = AcceptedEditChange
  end
  object Button1: TButton
    Left = 152
    Top = 80
    Width = 81
    Height = 25
    Caption = 'Add'
    TabOrder = 2
    OnClick = Button1Click
  end
  object DeleteButton: TButton
    Left = 152
    Top = 120
    Width = 81
    Height = 25
    Caption = 'Delete'
    TabOrder = 3
    OnClick = DeleteButtonClick
  end
  object OkBitBtn: TBitBtn
    Left = 64
    Top = 176
    Width = 113
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = OkBitBtnClick
  end
  object CancelBitBtn: TBitBtn
    Left = 296
    Top = 176
    Width = 105
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = CancelBitBtnClick
  end
end
