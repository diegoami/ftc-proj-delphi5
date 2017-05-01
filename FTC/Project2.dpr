program Project2;

uses
  Forms,
  uLinkFrame in 'uLinkFrame.pas' {LinkFrame: TFrame},
  umainFrame in 'umainFrame.pas' {mainFrame: TFrame},
  uFTCForm in 'uFTCForm.pas' {FTCForm},
  uJSDeployer in 'uJSDeployer.pas',
  DsgnIntf in '..\..\Source\Toolsapi\dsgnintf.pas',
  uFTCController in 'uFTCController.pas',
  UOptionsDialog in 'UOptionsDialog.pas' {OptionsDlg},
  uHtmlContainerFromDCTreeView in 'uHtmlContainerFromDCTreeView.pas',
  uShellWindowObserver in '..\Shell Window Observer\uShellWindowObserver.pas',
  uDADirScanDreamTreeView in '..\..\Dirscan\uDADirscanDreamTreeView.pas',
  uExtsForm in 'uExtsForm.pas' {ExtsForm},
  Favorites in '..\..\IECOmm\Favorites.pas',
  Unit8 in 'Unit8.pas' {Frame1: TFrame},
  Unit9 in 'Unit9.pas' {Form1},
  uDADCTreeView in '..\..\DaTrView\uDADCTreeView.pas',
  uScanningUnit in 'uScanningUnit.pas' {ScanningForm},
  uRegisterForm in 'uRegisterForm.pas' {RegisterForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFTCForm, FTCForm);
  Application.CreateForm(TOptionsDlg, OptionsDlg);
  Application.CreateForm(TExtsForm, ExtsForm);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TScanningForm, ScanningForm);
  Application.CreateForm(TRegisterForm, RegisterForm);
  Application.Run;
end.
