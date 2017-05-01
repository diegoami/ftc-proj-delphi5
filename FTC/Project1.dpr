program Project1;

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
  uExtsForm in 'uExtsForm.pas' {ExtsForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFTCForm, FTCForm);
  Application.CreateForm(TOptionsDlg, OptionsDlg);
  Application.CreateForm(TExtsForm, ExtsForm);
  Application.Run;
end.
