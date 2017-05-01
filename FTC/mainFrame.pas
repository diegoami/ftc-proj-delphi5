unit mainFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uDADirScan, uDADirScanDCTreeView, ComCtrls, dcDTree, DcTree, ExtCtrls,
  dcstdctl;

type
  TFrame2 = class(TFrame)
    DCSplitter1: TDCSplitter;
    LinkTreeView: TDCTreeView;
    DADirScanDCTreeView1: TDADirScanDCTreeView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
