unit uFTCForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, umainFrame, ExtCtrls, Menus, ActnList, ImgList,
  ExtDlgs, dcapi, Favorites,  dccommon, comctrls, Placemnt, FileMenuHdl;

type
  TFTCForm = class(TForm)
    mainFrame1: TmainFrame;
    MainMenu: TMainMenu;
    FileMenuItem: TMenuItem;
    NewMenuItem: TMenuItem;
    LoadMenuItem: TMenuItem;
    SaveMenuItem: TMenuItem;
    ExitMenuItem: TMenuItem;
    EditMenuItem: TMenuItem;
    AddLinkMenuItem: TMenuItem;
    AddFolderMenuItem: TMenuItem;
    N1: TMenuItem;
    CutMenuItem: TMenuItem;
    PasteMenuItem: TMenuItem;
    N2: TMenuItem;
    DeploymentMenuItem: TMenuItem;
    HelpMenuItem: TMenuItem;
    ContentsMenuItem: TMenuItem;
    AboutMenuItem: TMenuItem;
    TopPanel: TPanel;
    NewSpeedButton: TSpeedButton;
    OpenSpeedButton: TSpeedButton;
    SaveSpeedButton: TSpeedButton;
    PreviewSpeedButton: TSpeedButton;
    ExitSpeedButton: TSpeedButton;
    LinkSpeedButton: TSpeedButton;
    FolderSpeedButton: TSpeedButton;
    ChangeSpeedButton: TSpeedButton;
    CutSpeedButton: TSpeedButton;
    PasteSpeedButton: TSpeedButton;
    DeploymentSpeedButton: TSpeedButton;
    ContentsSpeedButton: TSpeedButton;
    AboutSpeedButton: TSpeedButton;
    ActionList: TActionList;
    ActionImageList: TImageList;
    ActionNew: TAction;
    ActionOpen: TAction;
    ActionSave: TAction;
    ActionPreview: TAction;
    ActionNewLink: TAction;
    ActionNewFolder: TAction;
    ActionChange: TAction;
    ActionUndo: TAction;
    ActionCut: TAction;
    ActionPaste: TAction;
    ActionPublish: TAction;
    ActionHelp: TAction;
    ActionAbout: TAction;
    ActionExit: TAction;
    HTMLOpenDialog: TOpenDialog;
    HTMLSaveDialog: TSaveDialog;
    ActionScan: TAction;
    DCPathDialog1: TDCPathDialog;
    SpeedButton1: TSpeedButton;
    Favorites1: TFavorites;
    MainPopupMenu: TPopupMenu;
    ActionSaveNode: TAction;
    N4: TMenuItem;
    ActionReadFromFile: TAction;
    SaveToFile1: TMenuItem;
    ActionSaveToFile: TAction;
    Scandir1: TMenuItem;
    N5: TMenuItem;
    Scandir2: TMenuItem;
    Readfromfile1: TMenuItem;
    ActionDelete: TAction;
    Delete1: TMenuItem;
    ActionSpeedButton: TSpeedButton;
    N6: TMenuItem;
    N7: TMenuItem;
    Paste1: TMenuItem;
    ActionDelete1: TMenuItem;
    N8: TMenuItem;
    NewFolder1: TMenuItem;
    N9: TMenuItem;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    N3: TMenuItem;
    FormPlacement1: TFormPlacement;
    ActionRegister: TAction;
    Register1: TMenuItem;
    SpeedButton4: TSpeedButton;
    Options: TMenuItem;
    ActionSaveDef: TAction;
    Save1: TMenuItem;
    ActionRename: TAction;
    ActionRename1: TMenuItem;
    Savetofile2: TMenuItem;
    FileMenuHandler1: TFileMenuHandler;



    procedure FormCreate(Sender: TObject);
    procedure ActionNewExecute(Sender: TObject);
    procedure ActionOpenExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionNewLinkExecute(Sender: TObject);
    procedure ActionNewFolderExecute(Sender: TObject);
    procedure ActionChangeExecute(Sender: TObject);
    procedure ActionPublishExecute(Sender: TObject);
    procedure ActionScanExecute(Sender: TObject);
    procedure ActionCutExecute(Sender: TObject);
    procedure ActionExitExecute(Sender: TObject);
    procedure ActionPreviewExecute(Sender: TObject);
    procedure mainFrame1DADirScanDreamTreeView1DirAdded(Sender: TObject;
      DirName: String);
    procedure mainFrame1DADirScanDreamTreeView1FileAdded(Sender: TObject;
      FileName: String);
    procedure FormShow(Sender: TObject);
    procedure ActionNewSessionExecute(Sender: TObject);
    procedure Favorites1Navigate(Sender: TObject; Url: WideString;
      var Allow: Boolean);
    procedure ActionSaveNodeExecute(Sender: TObject);
    procedure ActionReadFromFileExecute(Sender: TObject);
    procedure mainFrame1BackSpeedButtonClick(Sender: TObject);
    procedure ActionPasteExecute(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure mainFrame1DADirScanDreamTreeView1DirFound(Sender: TObject;
      DirName: String; var CanAdd: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPlacement1RestorePlacement(Sender: TObject);
    procedure mainFrame1FormStorage1SavePlacement(Sender: TObject);
    procedure mainFrame1DCPropStore1LoadChanges(Sender: TObject;
      var processed: Boolean);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ActionRegisterExecute(Sender: TObject);
    procedure LinkFrameWebBtnClick(Sender: TObject);
    procedure ActionHelpExecute(Sender: TObject);
    procedure ActionAboutExecute(Sender: TObject);
    procedure ActionSaveDefExecute(Sender: TObject);
    procedure ActionRenameExecute(Sender: TObject);
   
    procedure mainFrame1LinkTreeViewChange(Sender: TObject;
      Node: TTreeNode);
    procedure MainPopupMenuPopup(Sender: TObject);
  private
    hasFavourites : Boolean;
    AlreadyDone : boolean;
  public
    { Public declarations }
  end;

var
  FTCForm: TFTCForm;
  FTCForm2 : TFTCForm;



implementation

uses UOptionsDialog, uFTCController, uExtsForm, stringfns, uScanningUnit,
  uRegisterForm, uFTCAbout, AmReg, Registry;
var AReg : TAMreg;
{$R *.DFM}




procedure TFTCForm.FormCreate(Sender: TObject);
begin
  mainFrame1.SetEvents;
  AlreadyDone := false;
  //Favorites1.WebBrowser := Mainframe1.WebBrowser;
  with Areg do begin
      Active := True;
      mainFrame1.LinkTreeView.Width := RSInteger('Forms','LinkTreeViewWidth', mainFrame1.LinkTreeView.Width);

      mainFrame1.LinkFrame.UrlPanel.Height := RSInteger('Forms','UrlPanelHeight', mainFrame1.LinkFrame.UrlPanel.Height);
      mainFrame1.LinkFrame.TitlePanel.Height := RSInteger('Forms','TitlePanelHeight', mainFrame1.LinkFrame.TitlePanel.Height);

      mainFrame1.LinkFrame.NotesPanel.Height := RSInteger('Forms','NotesPanelHeight', mainFrame1.LinkFrame.NotesPanel.Height);
      mainFrame1.LinkFrame.Height := RSInteger('Forms','LinkFrameHeight', mainFrame1.LinkFrame.Height);
      HasFavourites := RSBool('','Favourites', true);
      HTMLOPenDialog.FileName := RSString('','Filename','');
      HTMLSaveDialog.FileName := RSString('','SaveFilename','');

      Active := False
  end;

  if HTMLOPenDialog.FileName <> '' then
    MainFrame1.ReadFromFile(HTMLOpenDialog.FileName);
  if (not HasFavourites) then
    Favorites1.CreateMenu;
  mainFrame1.NewFile;
  if ParamCount > 0 then
    mainFrame1.ReadFromFile(ParamStr(1));
end;

procedure TFTCForm.ActionNewExecute(Sender: TObject);
begin
  mainFrame1.NewFile;
end;

procedure TFTCForm.ActionOpenExecute(Sender: TObject);
begin
  if HTMLOpenDialog.Execute then begin
    MainFrame1.ReadFromFile(HTMLOpenDialog.FileName);
    HTMLSaveDialog.FileName := HTMLOpenDialog.Filename
  end;
end;

procedure TFTCForm.ActionSaveExecute(Sender: TObject);
var FileName : String;
begin
  if HTMLSaveDialog.Execute then begin
    FileName := HTMLSaveDialog.FileName;
    if (ExtractFileExt(FileName) = '') and  (Application.MessageBox(
        'Do you want to add the .htm extension?',

        'Confirmation',
        MB_OKCANCEL ) = IDOK ) then
        FileName := Filename + '.htm';

    MainFrame1.GenerateAndSave(FileName);
    HTMLOpenDialog.Filename := FileName
  end;


end;

procedure TFTCForm.ActionNewLinkExecute(Sender: TObject);
begin
  MainFrame1.AddBookMark;
end;

procedure TFTCForm.ActionNewFolderExecute(Sender: TObject);
begin
  MainFrame1.AddFolder;
end;

procedure TFTCForm.ActionChangeExecute(Sender: TObject);
begin
  OptionsDlg.ShowModal;
  MainFrame1.SetRelativePath(JSController.DeployDir+'\', JsController.OldDeployDir);

end;

procedure TFTCForm.ActionPublishExecute(Sender: TObject);
var SourceDir : String;
begin
  if RegisterForm.UseEnabled = false then
    ShowMessage('Function disabled. Please register')
  else begin
    SourceDir := ExtractFilePath(Application.Exename)+'ftcimages';
    if (not RegisterForm.Registered) and (not alreadyDone) then begin
      inc(RegisterForm.Times);
      alreadyDone := true;
    end;
  //MainFrame1.GenerateAndSave(JSController.HomeFileName);
    MainFrame1.DeployJS(SourceDir, JSController.DeployDir, JSController.HomeFileName)
  end;
end;

procedure TFTCForm.ActionScanExecute(Sender: TObject);
var  SDir: String;
begin
  if RegisterForm.UseEnabled = false then
    ShowMessage('Function disabled. Please register')
  else begin
    if DCPathDialog1.Execute then
      SDir := DCPathDialog1.SelectedItem;
    ExtsForm.ShowModal;
    Application.ProcessMessages;
    if ExtsForm.MustScan then begin
      ScanningForm.Show;
      MainFrame1.DoScan(SDir);
      ScanningForm.Close
    end;
  end;
end;

procedure TFTCForm.ActionCutExecute(Sender: TObject);
begin
  //MainFrame1.Delete;
  MainFrame1.Cut;
 ActionPaste.Enabled := True;

end;

procedure TFTCForm.ActionExitExecute(Sender: TObject);
begin
if Application.MessageBox('Are you sure you want to leave?', 'Confirmation', MB_OKCANCEL)
    = ID_OK then Close
end;

procedure TFTCForm.ActionPreviewExecute(Sender: TObject);
begin
  ActionPublish.Execute;
  MainFrame1.NavigateToPage
end;

procedure TFTCForm.mainFrame1DADirScanDreamTreeView1DirAdded(
  Sender: TObject; DirName: String);
begin
  mainFrame1.DADirScanDreamTreeView1DirAdded(Sender, DirName);

end;

procedure TFTCForm.mainFrame1DADirScanDreamTreeView1FileAdded(
  Sender: TObject; FileName: String);
begin
  mainFrame1.DADirScanDreamTreeView1FileAdded(Sender, FileName);

end;

procedure TFTCForm.FormShow(Sender: TObject);
begin
  ExtsForm.DADirScan := MainFrame1.DADirScanDreamTreeView1;
  RegisterForm.CheckRegister;
  if RegisterForm.Registered then
    Caption := 'Folder Tree Creator '
  else
    Caption := 'Folder Tree Creator - Evaluation version. ';

  if HTMLOpenDialog.Filename <> '' then

     MainFrame1.ReadFromFile(HTMLOpenDialog.FileName);
//  MainFrame1.FormStorage1.RestoreFormPlacement;
end;

procedure TFTCForm.ActionNewSessionExecute(Sender: TObject);
begin
  Application.CreateForm( TFTCForm, FTCForm2);
  FTCForm2.SHow
end;

procedure TFTCForm.Favorites1Navigate(Sender: TObject; Url: WideString;
  var Allow: Boolean);
begin
//  Allow := False;
  MainFrame1.SetUrl(Url);
end;

procedure TFTCForm.ActionSaveNodeExecute(Sender: TObject);
begin
  if HTMLSaveDialog.Execute then
    MainFrame1.GenerateAndSaveSelected(HTMLSaveDialog.FileName);
end;

procedure TFTCForm.ActionReadFromFileExecute(Sender: TObject);
begin
  if HTMLOpenDialog.Execute then
    MainFrame1.ReadFromFileToNode(HTMLOpenDialog.FileName);


end;

procedure TFTCForm.mainFrame1BackSpeedButtonClick(Sender: TObject);
begin
  mainFrame1.BackSpeedButtonClick(Sender);

end;

procedure TFTCForm.ActionPasteExecute(Sender: TObject);
begin
  if (MainFrame1.Paste) then
    ActionPaste.Enabled := False;
end;

procedure TFTCForm.ActionDeleteExecute(Sender: TObject);
begin
  MainFrame1.Delete;
end;

procedure TFTCForm.mainFrame1DADirScanDreamTreeView1DirFound(
  Sender: TObject; DirName: String; var CanAdd: Boolean);
begin
  ScanningForm.DirLabel.Caption := DirName;
  Application.ProcessMessages;
end;

procedure TFTCForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //mainFrame1.FormStorage1.SaveFormPlacement;
//  DCPropStore1.Save;
 with AReg do begin
      Active := True;
      WSInteger('Forms','LinkTreeViewWidth', mainFrame1.LinkTreeView.Width);
      WSInteger('Forms','LinkFrameHeight', mainFrame1.LinkFrame.Height);
      WSInteger('Forms','UrlPanelHeight', mainFrame1.LinkFrame.UrlPanel.Height);
      WSInteger('Forms','TitlePanelHeight', mainFrame1.LinkFrame.TitlePanel.Height);
      WSInteger('Forms','NotesPanelHeight', mainFrame1.LinkFrame.NotesPanel.Height);

      WSString('','Filename',HTMLOpenDialog.Filename);
      WSString('','SaveFilename',HTMLSaveDialog.Filename);


      Active := False
  end;
 {
  mainFrame1.DCPropStore1.Save;
  mainFrame1.LinkFrame.DCPropStore1.Save;}
  RegisterForm.DoLeave;
end;

procedure TFTCForm.FormPlacement1RestorePlacement(Sender: TObject);
var A : Integer;
begin
  A := 0;

end;

procedure TFTCForm.mainFrame1FormStorage1SavePlacement(Sender: TObject);
var A : Integer;
begin
  A := 0;

end;

procedure TFTCForm.mainFrame1DCPropStore1LoadChanges(Sender: TObject;
  var processed: Boolean);
begin
  //mainFrame1.DCPropStore1LoadChanges(Sender, processed);

end;

procedure TFTCForm.SpeedButton4Click(Sender: TObject);
begin
  RegisterForm.Show;
end;

procedure TFTCForm.ActionRegisterExecute(Sender: TObject);
begin
  RegisterForm.ShowModal;
  if RegisterForm.Registered then
    Caption := 'Folder Tree Creator';
end;

procedure TFTCForm.LinkFrameWebBtnClick(Sender: TObject);
begin
  mainFrame1.LinkFrameWebBtnClick(Sender);

end;

procedure TFTCForm.ActionHelpExecute(Sender: TObject);
begin
  ShowWebPage(ExtractFilePath(Application.Exename)+'ftc.chm');
end;

procedure TFTCForm.ActionAboutExecute(Sender: TObject);
begin
  FTCAboutBox.Show;
end;

procedure TFTCForm.ActionSaveDefExecute(Sender: TObject);
begin
  if HTMLSaveDialog.Filename <> '' then
    MainFrame1.GenerateAndSave(HTMLSaveDialog.FileName)
  else
    ActionSaveExecute(Self);
end;


procedure TFTCForm.ActionRenameExecute(Sender: TObject);
begin
  mainFrame1.LinkTreeView.Selected.EditText;
end;


procedure TFTCForm.mainFrame1LinkTreeViewChange(Sender: TObject;
  Node: TTreeNode);

begin
  mainFrame1.LinkTreeViewChange(Sender, Node);
  MainPopupMenu.Items.Find('Scan Dir').Enabled := MainFrame1.CanScan;
  SpeedButton1.Enabled :=  MainFrame1.CanScan;
  ActionReadFromFile.Enabled := mainFrame1.IsOnAFolder;
  ActionSaveNode.Enabled := mainFrame1.IsOnAFolder;
  ActionCut.Enabled := not mainFrame1.IsOnFirstNode;
  ActionDelete.Enabled := not mainFrame1.IsOnFirstNode;



end;

procedure TFTCForm.MainPopupMenuPopup(Sender: TObject);
begin
 ActionReadFromFile.Enabled := mainFrame1.IsOnAFolder;
 ActionSaveNode.Enabled := mainFrame1.IsOnAFolder;


end;

initialization
  AReg := TAmReg.Create(nil);
  with AReg do begin
    Rootkey := HKeyLocalMachine;
    Group := 'Software';
    Company := 'Click It';
    Application := 'Folder Tree Creator';
    Reg := TRegistry.Create;
  end;
finalization
  AReg.Free;



end.
