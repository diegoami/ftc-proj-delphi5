object Form1: TForm1
  Left = 82
  Top = 219
  Width = 544
  Height = 375
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
  object TreeView1: TTreeView
    Left = 272
    Top = 0
    Width = 257
    Height = 337
    Indent = 19
    TabOrder = 0
  end
  object Button1: TButton
    Left = 80
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object HTMLTreeViewPArser1: THTMLTreeViewPArser
    TReeView = TreeView1
    Left = 152
    Top = 32
  end
  object OpenDialog1: TOpenDialog
    Left = 200
    Top = 88
  end
end
