unit uLinkFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, dcstdctl, URLFiller, uDaUrlLink, Buttons,
  dccommon;

type

    TOnUrlLinkChanged = procedure(Sender : TObject; Link : TDAUrlLink) of object;
    TOnUrlConfirmed = procedure(Sender : TObject; URL : String) of object;



  TLinkFrame = class(TFrame)
    UrlTitleSplitter: TDCSplitter;
    NotesTitlesplitter: TDCSplitter;
    TitlePanel: TPanel;
    TitleSplitter: TSplitter;
    TitleMemo: TMemo;
    UrlPanel: TPanel;
    NotesPanel: TPanel;
    URLMemo: TMemo;
    NotesMemo: TMemo;
    MemoSplitter: TSplitter;
    URLSplitter: TSplitter;
    URLLabel: TLabel;
    TitleLabel: TLabel;
    Notes: TLabel;
    OpenDialog1: TOpenDialog;
    OpenBtn: TBitBtn;
    SHOComboBox: TComboBox;
    WebBtn: TBitBtn;
    NewWindowCheckBox: TCheckBox;
    procedure URLMemoChange(Sender: TObject);
    procedure TitleMemoChange(Sender: TObject);
    procedure NotesMemoChange(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure ShellWindowObserver1ChangedNumber(Sender: TObject;
      Number: Integer);
    procedure SHOComboBoxChange(Sender: TObject);

    procedure FrameResize(Sender: TObject);
    procedure URLMemoExit(Sender: TObject);
    procedure URLMemoKeyPress(Sender: TObject; var Key: Char);
    procedure NewWindowCheckBoxClick(Sender: TObject);
    procedure NewWindowCheckBoxMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure NewWindowCheckBoxMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FOnUrlLinkChanged : TOnUrlLinkChanged;
    FOnUrlConfirmed : TOnUrlConfirmed;

    CurrUrlLink : TDAUrlLink;
    procedure FillComboBox;
    procedure SetLocalType(Link : TDaURLLink);

  public
    procedure SetFileName(FIleName : String);
    procedure SetUrl(Url : String);
    procedure SetTitle(Title : String);
    procedure SetUrlLink(Link : TDaUrlLink);
    function GetUrlLink : TDaUrlLink;
    procedure Clear;
    function NewUrlLink : TDaUrlLInk;
    property UrlLink : TDAUrlLink read GetUrlLInk write SetUrlLink;
    property OnUrlLinkChanged : TOnUrlLinkChanged read FOnUrlLInkChanged write FOnUrlLInkChanged;
    property OnUrlConfirmed : TOnUrlConfirmed read FOnUrlConfirmed write FOnUrlConfirmed;

  end;


  ELinkFrameException = class(Exception);
function MyRelativePath(const BaseName, DestName : String) : String;
function IsARemote(URLName : String) : boolean;

implementation

uses uFTCCOntroller, FileCtrl;
function IsARemote(URLName : String) : boolean;
begin
  result :=  ((Pos('http',URLName ) > 0)
    or (Pos('www.',URLName ) > 0)
    or (Pos('web.',URLName ) > 0)
    or (Pos('ftp.',URLName ) > 0)
     )
    and (Pos('\', URLName ) = 0);
end;

function MyRelativePath(const BaseName, DestName : String) : String;
var ADDP, AFP : String;
   BDDP, BFP : String;
   ADP,BDP :Char;
begin
  ProcessPath(BaseName,BDP,BDDP,BFP);
  ProcessPath(DestName,ADP,ADDP,AFP);
  result := ExtractRelativePath(BDDP+'\'+BFP, ADDP+'\'+AFP)
end;


{
   try to set this link to the type local, after checking its name
}

procedure TLinkFrame.SetLocalType(Link : TDaURLLink);
begin
  if (Link = nil) then
    exit;
  if not IsARemote(Link.URL) then
    CurrUrlLink.LocationType := Local;
end;

{
  changes link frame URL Link
}

procedure TLinkFrame.SetUrlLink(Link : TDaUrlLink);
begin
  CurrUrlLink := Link;
  with CurrUrlLink do begin
    URLMemo.Lines.Text :=  URL;
    TitleMemo.Lines.Text :=  Title;
    NotesMemo.Lines.Text := Description;
    NewWindowCheckBox.Checked := LocationType = ToBrowser;
  end;
end;

function TLinkFrame.GetUrlLink : TDaUrlLink;
begin
  result := CurrUrlLink;
end;

procedure TLinkFrame.Clear;
begin
  CurrUrlLink := nil;
  URLMemo.Lines.Clear;
  TitleMemo.Lines.Clear;
  NotesMemo.Lines.Clear;
  NewWindowCheckBox.Checked := False;
end;
{
  creates new URL Link and copies stuff from
}

function TLinkFrame.NewUrlLink : TDaUrlLink;
var OldUrlLink : TDaUrlLInk;
begin
// Clear;
  OldUrlLink := CurrUrlLInk;
  CurrUrlLink := TDaUrlLink.Create;
  if OldUrlLink <> nil then begin
    CurrUrlLink.Url := OldUrlLink.Url;
    CurrUrlLink.Title := OldUrlLink.Title;
    CurrUrlLink.Description := OldUrlLink.Description;
    CurrUrlLink.LocationType := OldUrlLink.LocationType;
  end;
  with CurrUrlLink do begin
    Url := Trim(UrlMemo.Lines.Text);
    Title := TitleMemo.Lines.Text;
    Description := NotesMemo.Lines.Text;
  end;
  SetLocalType(CurrUrlLink);
  result := CurrUrlLink;
end;


{$R *.DFM}

procedure TLinkFrame.URLMemoChange(Sender: TObject);
begin
  if (CurrUrlLink = nil) then
    raise ELinkFrameException.Create('TLinkFrame.URLMemoChange called while CurrUrl link is nil');
  CurrUrlLink.URL := Trim(URLMemo.Lines.Text);
  SetLocalType(CurrUrlLink);
  if Assigned(FOnUrlLinkChanged) then
    FOnUrlLinkChanged(Self,CurrUrlLink);
end;

procedure TLinkFrame.TitleMemoChange(Sender: TObject);
begin
  if (CurrUrlLink = nil) then
    raise ELinkFrameException.Create('TLinkFrame.TitleMemoChange called while CurrUrl link is nil');
  CurrUrlLink.Title := TitleMemo.Lines.Text;
  if Assigned(FOnUrlLinkChanged) then
    FOnUrlLinkChanged(Self,CurrUrlLink);
end;

procedure TLinkFrame.NotesMemoChange(Sender: TObject);
begin
  if (CurrUrlLink = nil) then
    raise ELinkFrameException.Create('TLinkFrame.NotesMemoChange called while CurrUrl link is nil');
  CurrUrlLink.Description := NotesMemo.Lines.Text;
  if Assigned(FOnUrlLinkChanged) then
    FOnUrlLinkChanged(Self,CurrUrlLink);
end;

{
  called when trying to change the Url Link stuff after clicking the botton to open a file
}

procedure TLinkFrame.OpenBtnClick(Sender: TObject);
begin
  if (OpenDialog1.Execute) and (CurrUrlLink <> nil) then
    SetFileName(OpenDialog1.FileName);
end;

{
  called when trying to change the Url Link stuff after clicking the botton to open a file
}

procedure TLinkFrame.SetFileName(FIleName : String);
var DeployDir, RelativePath : String;
begin
  if (CurrUrlLink = nil) then
    raise ELinkFrameException.Create('TLinkFrame.SetFileName called while CurrUrl link is nil');

  DeployDir := JSController.DeployDir+'\';
  CurrUrlLink.RealPath := FileName;

  RelativePath  := ExtractRelativePath(DeployDir, FileName);
  CurrUrlLink.LocationType := LOCAL;
  UrlMemo.Lines.Text := RelativePath
end;

procedure TLinkFrame.ShellWindowObserver1ChangedNumber(Sender: TObject;
  Number: Integer);
begin
  FillCombobox;
end;

procedure TLinkFrame.FillComboBox;
begin
//  SHOComboBox.Items.Assign(ShellWindowObserver1.LinkList)
end;

procedure TLinkFrame.SHOComboBoxChange(Sender: TObject);
begin
  URLMemo.Text := SHOComboBox.Items[SHOComboBox.ItemIndex];
end;

procedure TLinkFrame.SetUrl(Url : String);
begin
  UrlMemo.Lines.Text := Url;
  if CurrUrlLink <> nil then begin
    CurrUrlLink.Url := Url;
    SetLocalType(CurrUrlLink);
  end;
end;


procedure TLinkFrame.SetTitle(Title : String);
begin
  if CurrUrlLink <> nil then
    raise ELinkFrameException.Create('TLinkFrame.SetTitle called while CurrUrlLink is nil');
  TitleMemo.Lines.Text := Title;
  CurrUrlLink.Title := Title;
end;

procedure TLinkFrame.FrameResize(Sender: TObject);
var RH : integer;
begin
  RH := Height - 20;
  URLPanel.Height := RH div 3;
  NotesPanel.Height := RH div 3;
end;

procedure TLinkFrame.URLMemoExit(Sender: TObject);
begin
  if Assigned(FOnUrlConfirmed) then
    FOnUrlCOnfirmed(Sender, URlMemo.Lines.Text);
end;

procedure TLinkFrame.URLMemoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(13) then begin
    if Assigned(FOnUrlConfirmed) then
      FOnUrlConfirmed(self, UrlMemo.Lines.Text)
  end;
end;

procedure TLinkFrame.NewWindowCheckBoxClick(Sender: TObject);
begin
  SetLocalType(CurrUrlLink);
end;

procedure TLinkFrame.NewWindowCheckBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetLocalType(CurrUrlLink);
end;

procedure TLinkFrame.NewWindowCheckBoxMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetLocalType(CurrUrlLink);
end;

end.



