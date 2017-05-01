object Form2: TForm2
  Left = 267
  Top = 413
  Width = 544
  Height = 375
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 536
    Height = 348
    Align = alClient
    TabOrder = 0
  end
  object HTMLParser1: THTMLParser
    OnHTMLTag = HTMLParser1HTMLTag
    Left = 88
    Top = 96
  end
  object OpenDialog1: TOpenDialog
    Filter = 'HTM|*.htm|HTML|*.html'
    Left = 88
    Top = 40
  end
end
