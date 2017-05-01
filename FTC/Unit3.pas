unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, umainFrame, ExtCtrls, Menus, ActnList, ImgList,
  ExtDlgs;

type
  TFTCForm = class(TForm)
    mainFrame1: TmainFrame;
    MainMenu: TMainMenu;
    FileMenuItem: TMenuItem;
    NewMenuItem: TMenuItem;
    LoadMenuItem: TMenuItem;
    SaveMenuItem: TMenuItem;
    PreviewMenuItem: TMenuItem;
    ExitMenuItem: TMenuItem;
    EditMenuItem: TMenuItem;
    AddLinkMenuItem: TMenuItem;
    AddFolderMenuItem: TMenuItem;
    ClearMenuItem: TMenuItem;
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
    UndoSpeedButton: TSpeedButton;
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



    procedure FormCreate(Sender: TObject);
    procedure ActionNewExecute(Sender: TObject);
    procedure ActionOpenExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionNewLinkExecute(Sender: TObject);
    procedure ActionNewFolderExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FTCForm: TFTCForm;

implementation

{$R *.DFM}


procedure TFTCForm.FormCreate(Sender: TObject);
begin
  mainFrame1.SetEvents;
end;



procedure TFTCForm.ActionNewExecute(Sender: TObject);
begin
  mainFrame1.NewFile;
end;

procedure TFTCForm.ActionOpenExecute(Sender: TObject);
begin
  if HTMLOpenDialog.Execute then
    MainFrame1.ReadFromFile(HTMLOpenDialog.FileName);
end;

procedure TFTCForm.ActionSaveExecute(Sender: TObject);
begin
  if HTMLOpenDialog.Execute then
    MainFrame1.GenerateAndSave(HTMLOpenDialog.FileName);

end;

procedure TFTCForm.ActionNewLinkExecute(Sender: TObject);
begin
  MainFrame1.AddBookMark;
end;

procedure TFTCForm.ActionNewFolderExecute(Sender: TObject);
begin
  MainFrame1.AddFolder;
end;

end.
