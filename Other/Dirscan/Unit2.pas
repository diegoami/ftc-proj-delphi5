unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, uDADirScan, uDADirScanTreeView, ComCtrls, 
  uDaDirScanListView;

type
  TForm2 = class(TForm)
    DADirScan1: TDADirScan;
    Memo1: TMemo;
    Button1: TButton;
    TreeView1: TTreeView;
    DADirScanTreeView1: TDADirScanTreeView;
    DADirScanListView1: TDADirScanListView;
    ListView1: TListView;
    Button2: TButton;
    procedure DADirScan1DirFound(Sender: TObject; DirName: String);
    procedure DADirScan1FileFound(Sender: TObject; FileName: String);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DADirScan1DirEnd(Sender: TObject; DirName: String;
      FilesFound: Integer);
    procedure TreeView1Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure ListView1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.DADirScan1DirFound(Sender: TObject; DirName: String);
begin
  Memo1.Lines.Add('Found dir at '+DirName);
end;

procedure TForm2.DADirScan1FileFound(Sender: TObject; FileName: String);
begin
  Memo1.Lines.Add('Found Valid File :'+FileName);
end;

procedure TForm2.FormShow(Sender: TObject);
begin
//  DADirScan1.ScanDirectory('C:\');
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  //DaDirScan1.ScanDirectory('C:\Programme\Borland\Delphi\Miei\');
  DaDirScanTreeView1.Directory := 'C:\';
  //Treeview1.FullExpand;
end;

procedure TForm2.DADirScan1DirEnd(Sender: TObject; DirName: String;
  FilesFound: Integer);
begin
  Memo1.Lines.Add('Found '+IntToStr(FilesFound)+' valid files in ' + Dirname);
end;

procedure TForm2.TreeView1Expanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var DirString : String;
begin
  DirString := String(Node.Data);
  DaDirScanTreeView1.FillNode(Node,DirString);


end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  DaDirScanListView1.Directory := 'C:\';
end;

procedure TForm2.TreeView1Change(Sender: TObject; Node: TTreeNode);
var Name : String;
begin
  Name := String(Node.Data);
  if TDaDirScan.IsADir(Name) then
    DaDirScanListView1.Directory := Name;
end;

procedure TForm2.ListView1DblClick(Sender: TObject);

  var Name : String;
begin
  if ListView1.Selected <> nil then begin
    Name := String(ListView1.Selected.Data);
    if TDaDirScan.IsADir(Name) then
      DaDirScanListView1.Directory := Name;
  end;

end;

end.
