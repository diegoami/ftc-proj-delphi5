program FTC2;

uses
  ExcMagic,
  Forms,
  uLinkFrame in 'uLinkFrame.pas' {LinkFrame: TFrame},
  umainFrame in 'umainFrame.pas' {mainFrame: TFrame},
  uJSDeployer in 'uJSDeployer.pas',
  uFTCController in 'uFTCController.pas',
  UOptionsDialog in 'UOptionsDialog.pas' {OptionsDlg},
  uHtmlContainerFromDCTreeView in 'uHtmlContainerFromDCTreeView.pas',
  uExtsForm in 'uExtsForm.pas' {ExtsForm},
  uScanningUnit in 'uScanningUnit.pas' {ScanningForm},
  uRegisterForm in 'uRegisterForm.pas' {RegisterForm},
  uFTCAbout in 'uFTCAbout.pas' {FTCAboutBox},
  uFTCForm in 'uFTCForm.pas' {FTCForm},
  uDADirScanDreamTreeView in '..\Mylibs\Dirscan\uDADirscanDreamTreeView.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFTCForm, FTCForm);
  Application.CreateForm(TOptionsDlg, OptionsDlg);
  Application.CreateForm(TExtsForm, ExtsForm);
  Application.CreateForm(TScanningForm, ScanningForm);
  Application.CreateForm(TRegisterForm, RegisterForm);
  Application.CreateForm(TFTCAboutBox, FTCAboutBox);
  Application.Run;
end.
