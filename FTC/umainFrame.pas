unit umainFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uDADirScan, uDADirScanDCTreeView, ComCtrls, dcDTree, ExtCtrls,
  dcstdctl, dccommon, OleCtrls,  uLinkFrame, ImgList, uDaUrlLink,
  uDADCTreeView, uHtmlContainerFromDCTreeView, HTMLParser, URLFiller,
  URLDCMSTreeViewFiller, DCGen, uJSDeployer, uDADirScanDreamTreeView,
  SHDocVw,stringfns, Buttons, StdCtrls;

type
  TmainFrame = class(TFrame)
    VertSplitter: TDCSplitter;
    DCSplitter: TDCSplitter;
    WebBrowser: TWebBrowser;

    LinkTreeView: TDADCTreeView;
    LeftPanel: TDCFormPanel;
    LinkFrame: TLinkFrame;
    ImageList1: TImageList;
    HTMLParser: THTMLDCMSTreeViewParser;
    JSDeployer: TJSDeployer;
    DADirScanDreamTreeView1: TDADirScanDreamTreeView;
    WebPanel: TPanel;
    Edit1: TEdit;
    BackSpeedButton: TSpeedButton;
    ForwardSpeedButton: TSpeedButton;
    TopPanel: TPanel;
    procedure LinkTreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure LinkTreeViewDragNodeEvent(Sender: TObject; Source,
      Destination: TTreeNode);
    procedure LinkTreeViewDeleteNode(Sender: TObject; Node: TTreeNode);
    procedure DADirScanDreamTreeView1FileAdded(Sender: TObject;
      FileName: String);
    procedure DADirScanDreamTreeView1DirAdded(Sender: TObject;
      DirName: String);
    procedure LinkTreeViewSelectionChanged(Sender: TObject;
      Node: TTreeNode);
    procedure LinkFrameSHOComboBoxChange(Sender: TObject);
    procedure LinkFrameWebBtnClick(Sender: TObject);
    procedure BackSpeedButtonClick(Sender: TObject);
    procedure ForwardSpeedButtonClick(Sender: TObject);
    procedure WebBrowserBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowserNavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure LinkFrameNewWindowCheckBoxClick(Sender: TObject);
    procedure LinkFrameNewWindowCheckBoxMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LinkTreeViewChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure LinkFrameURLMemoChange(Sender: TObject);
    procedure LinkTreeViewEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure DADirScanDreamTreeView1DirEnd(Sender: TObject;
      DirName: String; FilesFound: Integer);
  private
    FSelectedUrl : TDaUrlLInk;
    FCutNode : TTreeNode;
    function IsAFolder(Node : TTreeNode) : boolean;
    procedure DoNavigate(Node : TDaUrlLink);
  protected
    Container : THtmlContainerFromDCTreeView;
    procedure UrlConfirmed(Sender : TObject; URL : String);

    procedure LinkChanged(Sender : TObject; Link : TDAUrlLink);
    function NewUrlLink : TDaUrlLink;
    function GetWhereToAdd(Node : TTreeNode) : TTreeNode;
    procedure UpdateUrlLink;
  public
    procedure Cut;
    function IsOnAFolder : Boolean;
    function IsOnFirstNode : Boolean;

    procedure ReadFromFileToNode(FileName : String);
    procedure Delete;
    procedure NavigateToPage;
    procedure DeployJS(SourceDir, DestDir : String; HomeFile : string);
    procedure SetRelativePath(WhichDir : String; OldDir :String);
    procedure ReadFromFile(FileName : String; Node : TTreeNode = nil);
    constructor Create(AOwner : TComponent); override;
    function AddFolder(Name : String = 'New Folder') : TTreeNode;
    function AddBookMark : TTreeNode;
    procedure SetSelectedUrl(DaUrlLink : TDaUrlLinK);
    function GetSelectedUrl : TDaUrlLink;
    procedure GenerateAndSave(FileName : String; Node : TTreeNode = nil);
    procedure GenerateAndSaveSelected(FileName : String);
    function Paste : boolean;
    function CanScan : Boolean;

    procedure NewFile;
    procedure SetEvents;
    procedure DoScan(DirName : String);
    procedure SetUrl(UrL : STring);
  end;

  EMainFrameException = class(Exception);
implementation




uses uFTCController, Logger, math;
{
  checks if the treeview pointer is on the first node,
  returns true if so
}




function TmainFrame.IsOnFirstNode : Boolean;
begin
  if (LinkTreeView.Selected = nil) then begin

    raise ETreeViewError.Create('TMainFrame.IsOnFirstNode called while LinkTreeView.Selected was null');
    result := false
  end else begin
    result := LinkTreeView.Selected.AbsoluteIndex = 0
  end;

end;

{
   while adding a folder or  node I have to find out where I have to
   add the new node
}

function TmainFrame.GetWhereToAdd(Node : TTreeNode) : TTreeNode;
begin
  if (Node = nil) then begin
  
    raise ETreeViewError.Create('TMainFrame.IsOnFirstNode called while LinkTreeView.Selected was null');
    result := nil
  end else begin
    if IsAfolder(Node) then
      result := NOde
    else
      result := NOde.Parent;
  end;
end;

procedure TmainFrame.Cut;
var i : integer;
    Node : TTreeNode;
begin
  for i := LinkTreeView.ItemsSelected.Count-1 downto 0 do begin
    Node := LinkTreeView.ItemsSelected.Items[i];
    if (Node= nil) or (Node.AbsoluteIndex = 0) then
      exit
  end;
  LinkTreeView.CutNodes(LinkTreeView.ItemsSelected);
end;

procedure TmainFrame.Delete;

var i : integer;
    Node : TTreeNode;
begin


  for i := LinkTreeView.ItemsSelected.Count-1 downto 0 do begin
    Node := LinkTreeView.ItemsSelected.Items[i];
    if (Node <> nil) and (Node.AbsoluteIndex <> 0) then  begin
      if Node.Cut then
        Node.Cut := false;
      LinkTreeView.DeleteNode(Node)
    end;
  end;
end;



procedure TmainFrame.NewFile;
begin
  LinkTreeView.ClearAll;
  if (HtmlParser = nil) then
    raise EMainFrameException.Create('TmainFrame.NewFile - HtmlParser = nil');
  HTMLParser.Clear;
  LinkFrame.Clear;
  AddFolder('Folder Tree');
end;

constructor TmainFrame.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  SetEvents;
  Container := THtmlContainerFromDCTreeView.Create;


end;


function TmainFrame.GetSelectedUrl : TDaUrlLink;
begin
  result := FSelectedUrl;
end;

{
  called if link for selected is changed
}

procedure TmainFrame.LinkChanged(Sender : TObject; Link : TDAUrlLink);
begin
  if (Link = nil) then
    raise EInvalidArgument.Create('TmainFrame.LinkChanged called with Link argument = nil');

  if LinkTreeView.Selected <> nil then begin
    LinkTreeView.Selected.Data := Link;
    LinkTreeView.Selected.Text := Link.Title
  end;
  FSelectedUrl := Link;

end;



procedure TmainFrame.SetSelectedUrl(DaUrlLink : TDaUrlLinK);
begin
  if (DaUrlLink = nil) then
    raise EInvalidArgument.Create('TMainFrame.SetSelectedUrl called with DaUrlLink argument = nil');
  FSelectedUrl := DaUrlLink;
  LinkFrame.SetUrlLink(DaUrlLink);
  DoNavigate(DaUrlLink);

end;

procedure TmainFrame.SetUrl(UrL : STring);
begin
  WebBrowser.OnNavigateComplete2 := WebBrowserNavigateComplete2;
  LinkFrame.SetUrl(Url);
end;

function TMainFrame.IsAFolder(Node : TTreeNode) : boolean;
begin
  if (node = nil) then
    raise EInvalidArgument.Create('TMainFrame.IsAFolder called with Node argument = nil');

  result := (Node = nil) or (Node.ImageIndex = 0);
end;

function  TmainFrame.NewUrlLink : TDaUrlLink;
begin
  FSelectedUrl := LinkFrame.NewUrlLink;
  DoNavigate(FSelectedUrl);
  result := FSelectedUrl;
end;

function TMainFrame.AddBookMark  : TTreeNode;
var NewNode : TTreeNode;
    OldNode : TTreeNode;
    UrlLink : TDaUrlLink;
begin
  UrlLink := LinkFrame.NewUrlLink;
  if (UrlLink = nil) then
    raise EMainFrameException.Create('EMainFrame.AddBookmark trying to add a null empty UrlLink to Bookmark ');
  if (LinkTreeView.Selected = nil) then
    OldNode := nil
  else
    OldNode := GetWhereToADD(LinkTreeView.Selected);

  with LinkTreeView do begin
    //UrlLink.URL := 'http://';

    Newnode  := Items.AddChildObject(OldNode, UrlLInk.Title, UrlLink) ;
    Newnode.ImageIndex     :=  2 ;
    Newnode.SelectedIndex  :=  2 ;
    Selected := Newnode;
  end;      
  result := NewNode;
end;

function TMainFrame.AddFolder(Name : String = 'New Folder') : TTreeNode;
var NewNode : TTreeNode;
    OldNode : TTreeNode;
    UrlLink : TDaUrlLink;
begin
  UrlLink := NewUrlLink;
  if (UrlLink = nil) then
    raise EMainFrameException.Create('EMainFrame.AddBookmark trying to add a null empty UrlLink to Bookmark ');

  UrlLink.Title := Name;

    if (LinkTreeView.Selected = nil) then
      OldNode := nil
    else
      OldNode := GetWhereToADD(LinkTreeView.Selected);
    Newnode  := LinkTreeView.Items.AddChildObject(OldNode, Name, UrlLink);
    Newnode.ImageIndex    := 0;
    Newnode.SelectedIndex := 1;
    LinkTreeView.Selected := Newnode;
    Result := Newnode;
end;

{$R *.DFM}

procedure TmainFrame.SetEvents;
begin
  if (LinkFrame = nil) then
    raise EMainFrameException.Create('EMainFrame.SetEvents trying to access an empty LinkFrame ');

  LinkFrame.OnUrlLInkChanged := LinkChanged;
  LinkFrame.OnUrlConfirmed := UrlConfirmed
end;

procedure TmainFrame.UrlConfirmed(Sender : TObject; URL : String);
begin

   WebBrowser.Navigate(Trim(URL))
end;


procedure TmainFrame.LinkTreeViewChange(Sender: TObject; Node: TTreeNode);
var CurrUrl : TDaUrlLink;
begin
  if (Node <> nil) and (Node.Data <> nil) then begin
    CurrUrl := TDaUrlLink(Node.Data);
    SetSelectedUrl(CurrUrl);
  end else if (Node = nil) then
    raise EInvalidArgument.Create('TMainFrame.LinkTreeViewChange has Node = null');
end;

procedure TmainFrame.LinkTreeViewDragNodeEvent(Sender: TObject; Source,
  Destination: TTreeNode);
begin
  with LinkTreeView do begin
    CutNode(source);
    PasteNodeAt(GetWhereToAdd(Destination));
  end;
end;

function TmainFrame.Paste : boolean;
var Node : TTreeNode;
    UrlLink : TDAURLLink;
begin
  result := false;
  if (LinkTreeView.Selected <> nil) and (Isafolder(LinkTreeView.selected)) then begin
    LinkTreeView.PasteNodeAt(LinkTreeView.Selected);
    result := true;
  end;
end;



procedure TmainFrame.GenerateAndSave(FileName : String; Node : TTreeNode = nil);
begin
  if (Container = nil) then
    raise EMAinFrameException.Create('TMainFrame.GenerateAndSave called while Container was null');
  Container.FileName := FileName;
  Container.ReadAndFill(LinkTreeView, Node);
  WebBrowser.Navigate(FileName);
end;

procedure TmainFrame.GenerateAndSaveSelected(FileName : String);

begin
  GenerateAndSave(FIleName,LinkTreeView.Selected);
  if FSelectedUrl = nil then
    FSelectedUrl := NewUrlLink;
  LinkFrame.SetFileName(FileName);
end;



procedure TMainFrame.NavigateToPage;
begin
  with JSDeployer do
   ShowWebPage(DestFolder+'\'+IndexFileName);
end;

{
  if the argument Node is nil,
  the html page is parsed since the root node
}
procedure TMainFrame.ReadFromFile(FileName : String; Node : TTreeNode = nil);
var SS : TStrings;
    i : integer;
    FormatString : PChar;
begin
  SS := TStringList.Create;
  try
    SS.LoadFromFile(FileName);
    if (HtmlParser = nil) then
      raise EMaiNFrameException.Create('TMainFrame.ReadFromFile called while HTMLParser was null');
    HTMLParser.ParseAndFillTreeView(SS.Text, Node);
    with LinkTreeView do begin
      for i := 0 to Items.Count-1 do
        if Items[i].HasChildren then begin
          Items[i].SelectedIndex := 1;
          Items[i].ImageIndex := 0;
        end else begin
          Items[i].SelectedIndex := 2;
          Items[i].ImageIndex := 2;
       end;


    end;
  except
    on EFOpenError do begin

      FormatString := PChar(Format('Could not find the file %s',[FileName]));
      Application.MessageBox(FormatString, 'Warning', ID_OK);
    end;
  end;
  SS.Free;
end;


procedure TMainFrame.ReadFromFileToNode(FileName : String);
var SS : TStrings;
    i : integer;
begin

  ReadFromFile(FileName,LinkTreeView.Selected);
  if (LinkTreeView.Selected) <> nil then
    LinkFrame.SetFileName(FIleName);

end;

{
  routine to call the JSDeployer which generates our files
}

procedure TMainFrame.DeployJS(SourceDir, DestDir : String; HomeFile : string);
begin
  GenerateAndSave(DestDir+'\'+HomeFile);
  JSDeployer.JSStrings := Container.JSStrings;
  JSDeployer.SourceFiles.Add(Chr(34)+SourceDir+'\*.*'+Chr(34));
  JSDeployer.DestFolder := DestDir;
  JSDeployer.HomeFileName := HomeFile;
  JSDeployer.Deploy;
end;

{
  scans all directories looking for all stuff which has to change directory
}

procedure TMainFrame.SetRelativePath(WhichDir : String; OldDir :String);
var
  CurrentUrlLink : TDaUrlLink;
  CurrentNode : TTreeNode;
  i : integer;
  RealPath : STring;
  foundEmpty : boolean;
  OldChDir : String;

begin
  foundEmpty := false;
  GetDir(0,OldChDir); // saves old directory
  ChDir(OldDir);
  if (OldDir <> WhichDir) then begin
    for i := 0 to LinkTreeView.Items.Count-1 do begin
      CurrentNode := LinkTreeView.Items[i];
      if CurrentNode.Data <> nil then begin
        CurrentUrlLink := TDaUrlLink(CurrentNode.Data);
        RealPath := CurrentUrlLink.RealPath;
        if (CurrentUrlLink.LocationType = Local) then begin
          if (Length(RealPath) = 0) then begin

            RealPath := ExpandFileName(CurrentUrlLink.URL);
                // expands file names according to the directory we are in

          end;
          // changes the property CurrentUrlLink
          CurrentUrlLink.URL := ExtractRelativePath(WhichDir, RealPath)
        end else if (CurrentUrlLink.LocationType = Local) then
          foundEmpty := true;
      end
    end;
  end;
  Chdir(OldChDir);
  if (foundEmpty) then
    Application.MessageBox('Some local files could not be assigned to the right relative directory. Scan the directories again for these files','Warning',0);
  UpdateUrlLink

end;

{
  if some node is selected, updates stuff
}
procedure TMainFrame.UpdateUrlLink;
begin
  if LinkTreeView.Selected <> nil then begin

    FSelectedUrl  := TDaUrlLink(LinkTreeView.Selected.Data);
    if FSelectedUrl <> nil then
      LinkFrame.UrlLink := FSelectedUrl
  end
end;


procedure TmainFrame.LinkTreeViewDeleteNode(Sender: TObject;
  Node: TTreeNode);
begin
  if ((Node <> nil) and (Node.Data <> nil) )then
    TDaUrlLink(Node.Data).Free;
end;

{  found a directory while scanning }

procedure TmainFrame.DADirScanDreamTreeView1FileAdded(Sender: TObject;
  FileName: String);
var Node : TTreeNode;
   DaUrlLink : TDaUrlLink;
begin
  // CurrNode is the public
  NOde := DADirScanDreamTreeView1.CurrNode;
  if Node=nil then
    raise EMainFrameException.CreateFmt(
        'DADirScanDreamTreeView1FileAdded method got a nil node from the dir scanner while trying to add filename %s',
        [fileName]);


  Node.ImageIndex := 2;
  Node.SelectedIndex := 2;
  DaUrlLink := TDaUrlLink.Create;
  DaUrlLink.RealPath  := FileName;
  DaUrlLink.Title := ExtractFileName(FileName);
  DaUrlLink.LocationType := LOCAL;
  DaUrlLink.Url := ExtractRelativePath(JSController.DeployDir+'\', FileName);
  Node.Data := DaUrlLink
end;

procedure TmainFrame.DoScan(DirName : String);
var Node : TTreeNode;
begin
  Node := LinkTreeView.Selected;
  if (Node = nil) then
    Application.MessageBox('Select a node on the tree before scanning', 'Warning', 0)


  else if (not IsAFolder(Node)) then
    Application.MessageBox('Cannot scan on a leaf','Warning',0)
  else if (Node.HasChildren) then
    Application.MessageBox('Scanning must be done on empty folders', 'Warning',0)

  else
    DaDirScanDreamTreeView1.FillNode(Node,DirName+'\')
end;

{
  you can start scanning if the selected node is a folder and has not children
}


function TmainFrame.CanScan : Boolean;
var Node : TTreeNode;
begin
  Node := LinkTreeView.Selected;
  result := (NOde <> nil ) and (IsAFolder(Node)) and (not Node.HasChildren);
end;



procedure TmainFrame.DADirScanDreamTreeView1DirAdded(Sender: TObject;
  DirName: String);
var Node : TTreeNode;
begin
  Node := DaDirScanDreamTreeView1.CurrNode;
  if Node=nil then
    raise EMainFrameException.CreateFmt(
        'DADirScanDreamTreeView1DirAdded method got a nil node from the dir scanner while trying to add filename %s',
        [DirName]);

  Node.ImageIndex := 0;
  Node.SelectedIndex := 1;
  Node.Data := nil
end;

{ true
  if selected node on a folder
}

function TmainFrame.IsOnAFolder : Boolean;
begin

  result := (LinkTreeView.Selected <> nil) and (IsAfolder(LinkTreeView.Selected))

end;

procedure TmainFrame.LinkTreeViewSelectionChanged(Sender: TObject;
  Node: TTreeNode);
var
   STOP : String;
begin
  if (Node = nil)
    then exit;
  if (Node.Data <> nil) then begin
    FSelectedUrL := TDaUrlLink(Node.Data);
    DoNavigate(FSelectedUrL)
  end

end;

procedure TmainFrame.LinkFrameSHOComboBoxChange(Sender: TObject);
begin
  LinkFrame.SHOComboBoxChange(Sender);

end;

procedure TmainFrame.LinkFrameWebBtnClick(Sender: TObject);
begin

  LinkFrame.SetUrl(Edit1.Text);

end;

procedure TmainFrame.BackSpeedButtonClick(Sender: TObject);
begin
  WebBrowser.GoBack;
end;

procedure TmainFrame.ForwardSpeedButtonClick(Sender: TObject);
begin
  WebBrowser.GoForward;
end;

procedure TmainFrame.WebBrowserBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  Edit1.Text := URL;
end;

procedure TmainFrame.WebBrowserNavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  LinkFrame.setTitle(WebBrowser.LocationName);
  WebBrowser.OnNavigateComplete2 := nil
end;

procedure TmainFrame.LinkFrameNewWindowCheckBoxClick(Sender: TObject);
begin
  LinkFrame.NewWindowCheckBoxClick(Sender);

end;

procedure TmainFrame.LinkFrameNewWindowCheckBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LinkFrame.NewWindowCheckBoxMouseDown(Sender, Button, Shift, X, Y);

end;

procedure TmainFrame.LinkTreeViewChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
  if LInkTreeView.Selected = nil then exit;
  FSelectedUrl := TDaUrlLink(LinkTreeView.Selected.Data);
  if FSelectedUrl <> nil then begin
    if IsARemote(FSelectedUrl.URL) then
      if LinkFrame.NewWindowCheckBox.Checked then // java script will have to open a new window
        FSelectedUrl.LocationType := ToBrowser else
        FSelectedUrl.LocationType := ToFrame;
  end;
end;

procedure TmainFrame.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(13) then
    WebBrowser.Navigate(Edit1.Text);
end;

procedure TmainFrame.DoNavigate(Node : TDaurlLink);

var Stop : String;

begin
  if (not JsController.NavigateWhileAdding) then
    exit;
  STOP := ''; // web page to browse to
  FSelectedUrl := Node;
    if Length(FSelectedUrl.URL) = 0 then exit;
    if IsARemote(FSelectedUrl.URL) then begin
      LinkFrame.NewWindowCheckBox.Checked := FSelectedUrl.LocationType = ToBrowser;
      if (Pos('http',FSelectedUrl.URL) = 0) then
        FSelectedUrl.URL := 'http://'+ FSelectedUrl.URL;
    end;

    if (FSelectedUrl.LocationType = Local) then
      STOP := JSController.DeployDir+'\'+FSelectedUrl.Url
    else
      STOP := FSelectedUrl.Url;
  if Stop <> '' then
    WebBrowser.Navigate(Trim(stop));
end;



procedure TmainFrame.LinkFrameURLMemoChange(Sender: TObject);
begin
  LinkFrame.URLMemoChange(Sender);

end;

procedure TmainFrame.LinkTreeViewEdited(Sender: TObject; Node: TTreeNode;
  var S: String);
begin
  if (FSelectedUrl <> nil) then begin
    FSelectedUrl.Title := S;
    LinkFrame.TitleMemo.Lines.Text := S; // changes only stuff in
  end;
end;

procedure TmainFrame.DADirScanDreamTreeView1DirEnd(Sender: TObject;
  DirName: String; FilesFound: Integer);
begin
  // stuff for the + sign on the left of the node
  if (not IsAFolder(DADirScanDreamTreeView1.CurrNode)) then
    DADirScanDreamTreeView1.CurrNode.HasChildren := False;
end;

end.
