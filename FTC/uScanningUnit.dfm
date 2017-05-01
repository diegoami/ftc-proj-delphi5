object ScanningForm: TScanningForm
  Left = 357
  Top = 264
  Width = 684
  Height = 122
  Caption = 'ScanningForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ScanningLabel: TLabel
    Left = 168
    Top = 8
    Width = 152
    Height = 24
    Caption = 'Now Scanning Dir'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object DirLabel: TLabel
    Left = 176
    Top = 48
    Width = 3
    Height = 13
  end
  object CancelButton: TButton
    Left = 528
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = CancelButtonClick
  end
end
