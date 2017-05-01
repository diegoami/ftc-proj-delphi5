object Frame2: TFrame2
  Left = 0
  Top = 0
  Width = 665
  Height = 433
  TabOrder = 0
  object DCSplitter1: TDCSplitter
    Left = 313
    Top = 0
    Width = 3
    Height = 433
    Cursor = crHSplit
  end
  object LinkTreeView: TDCTreeView
    Left = 0
    Top = 0
    Width = 313
    Height = 433
    Options = [toProcessInsKey, toProcessDelKey, toCanEdit, toProcessEnterKey, toTrackInsert, toConfirmDelete, toCheckChild]
    Indent = 19
    Align = alLeft
    ParentColor = False
    TabOrder = 0
    TabStop = True
    MultiSelect = False
    CheckBoxes = False
    AutoScroll = False
    ExpandOnDrag = True
    DragExpandDelay = 100
    SelectOnlySiblings = False
    DrawData = {}
  end
  object DADirScanDCTreeView1: TDADirScanDCTreeView
    Levels = 15
    RecursiveScan = True
    AcceptedFiles.Strings = (
      '*.HTM'
      '*.HTML')
    CompleteData = False
    EmptyDirs = True
    TreeView = LinkTreeView
    Left = 448
    Top = 24
  end
end
