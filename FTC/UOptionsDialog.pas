unit UOptionsDialog;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, inifiles, Mask, ToolEdit;

type
  TOptionsDlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    DirectoryStaticText: TStaticText;
    MainHtmlStaticText: TStaticText;
    JavascriptStaticText: TStaticText;
    LeftFrameFileName: TStaticText;
    RightFrameStaticText: TStaticText;
    DirectoryEdit: TDirectoryEdit;
    MainHtmlEdit: TFilenameEdit;
    JSEdit: TFilenameEdit;
    LeftFrameEdit: TFilenameEdit;
    RightFrameEdit: TFilenameEdit;
    NavigateAddingCheckBox: TCheckBox;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptionsDlg: TOptionsDlg;


implementation

uses uFTCController;

{$R *.DFM}

procedure TOptionsDlg.OKBtnClick(Sender: TObject);
begin
    with JSController do begin
      DeployDir := DirectoryEdit.Text;
      MainHtml := MainhtmlEdit.Text;
      JSFile := JSEdit.Text;
      LFFileName := LeftFrameEdit.Text;
      HomeFileName := RightFrameEdit.Text;
      NavigateWhileAdding := NavigateAddingCheckbox.Checked;
  end;
  Close;
end;

procedure TOptionsDlg.CancelBtnClick(Sender: TObject);
begin
    Close;
end;

procedure TOptionsDlg.FormShow(Sender: TObject);
begin
    with JSController do begin
      DirectoryEdit.Text := DeployDir;
      MainhtmlEdit.Text  := MainHtml;
      JSEdit.Text        := JSFile;
      LeftFrameEdit.Text := LFFileName;
      RightFrameEdit.Text:= HomeFileName;
      NavigateAddingCheckbox.Checked :=  NavigateWhileAdding;
  end;

end;

end.
