object OptionsDlg: TOptionsDlg
  Left = 180
  Top = 111
  BorderStyle = bsDialog
  Caption = 'Deployment Options'
  ClientHeight = 484
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = -8
    Top = -24
    Width = 513
    Height = 417
    Shape = bsFrame
  end
  object OKBtn: TBitBtn
    Left = 88
    Top = 432
    Width = 114
    Height = 29
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000010000000000000000000
      BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777888777777
      777777770000774448877777777777770000772244887777777777770000A222
      22488777777777770000A22222248877777777770000A2222222488777777777
      0000A22222222488777777770000A22222222248877777770000A22248A22224
      887777770000A222488A2222488777770000A2224887A2224488777700007A22
      48877A222488777700007A22477777A222488777000077777777777A22244877
      0000777777777777A222488700007777777777777A2224870000777777777777
      77A224480000777777777777777A224800007777777777777777A24800007777
      7777777777777A270000}
  end
  object CancelBtn: TBitBtn
    Left = 359
    Top = 436
    Width = 106
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = CancelBtnClick
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000010000000000000000000
      BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777888877777
      8877777700007770888777778887777700007911088877910888777700007911
      0088879100888777000079111008891110087777000079911108911111007777
      0000779111101111110777770000777911111111077777770000777991111111
      8777777700007777991111108877777700007777791111108887777700007777
      7911111088877777000077777911111108887777000077779111991100888777
      0000777911108991100888770000777911187799110088870000777111187779
      1110888700007771110777779111087700007779997777777991777700007777
      77777777779977770000}
  end
  object DirectoryStaticText: TStaticText
    Left = 40
    Top = 40
    Width = 105
    Height = 17
    Caption = 'Deployment Directory'
    TabOrder = 2
  end
  object MainHtmlStaticText: TStaticText
    Left = 40
    Top = 112
    Width = 113
    Height = 17
    Caption = 'Name of Main Html File'
    TabOrder = 3
  end
  object JavascriptStaticText: TStaticText
    Left = 40
    Top = 176
    Width = 68
    Height = 17
    Caption = 'Javascript file'
    TabOrder = 4
  end
  object LeftFrameFileName: TStaticText
    Left = 40
    Top = 248
    Width = 104
    Height = 17
    Caption = 'Left Frame File Name'
    TabOrder = 5
  end
  object RightFrameStaticText: TStaticText
    Left = 40
    Top = 320
    Width = 128
    Height = 17
    Caption = 'File in Right Frame at Start'
    TabOrder = 6
  end
  object DirectoryEdit: TDirectoryEdit
    Left = 40
    Top = 72
    Width = 449
    Height = 21
    DialogKind = dkWin32
    NumGlyphs = 1
    TabOrder = 7
  end
  object MainHtmlEdit: TFilenameEdit
    Left = 40
    Top = 144
    Width = 449
    Height = 25
    Filter = 'HTML files (*.htm)|*.htm|HTML files  (*.html)| *.html'
    NumGlyphs = 1
    TabOrder = 8
  end
  object JSEdit: TFilenameEdit
    Left = 40
    Top = 208
    Width = 449
    Height = 21
    Filter = 'JAVASCRIPT files (*.js)|*.js'
    NumGlyphs = 1
    TabOrder = 9
  end
  object LeftFrameEdit: TFilenameEdit
    Left = 40
    Top = 280
    Width = 449
    Height = 21
    Filter = 'HTML files (*.html)|*.html|HTML files (*.htm)|*.htm'
    NumGlyphs = 1
    TabOrder = 10
  end
  object RightFrameEdit: TFilenameEdit
    Left = 40
    Top = 352
    Width = 449
    Height = 21
    Filter = 'HTML files (*.html)|*.html|HTML files (*.htm)|*.htm'
    NumGlyphs = 1
    TabOrder = 11
  end
  object NavigateAddingCheckBox: TCheckBox
    Left = 144
    Top = 392
    Width = 233
    Height = 17
    Caption = 'Navigate while adding nodes'
    TabOrder = 12
  end
end
