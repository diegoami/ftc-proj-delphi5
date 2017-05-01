object Form1: TForm1
  Left = 474
  Top = 430
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 176
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object DCFileOperation1: TDCFileOperation
    SourceFiles.Strings = (
      'c:\MPS\MultiCiv\Algeria\*.*')
    DestFolder = 'c:\MPs\MultiCiv\Algeria2'
    Operation = foCopy
    Options = [ffAllowUndo, ffFilesOnly, ffRenameCollision]
    Left = 352
    Top = 88
  end
end
