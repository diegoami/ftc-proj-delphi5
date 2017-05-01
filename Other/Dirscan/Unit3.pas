unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, uDADirScan, uDADirScanTreeView;

type
  TForm1 = class(TForm)
    DADirScanTreeView1: TDADirScanTreeView;
    TreeView1: TTreeView;
    procedure FormShow(Sender: TObject);
    procedure TreeView1Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormShow(Sender: TObject);
begin
  DADirScanTreeView1.Directory := 'C:\';
end;

procedure TForm1.TreeView1Expanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  DADirScanTreeView1.FillNode(Node,String(Node.Data));
end;

end.
