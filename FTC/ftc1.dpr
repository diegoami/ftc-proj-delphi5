program ftc1;

uses
  Forms,
  URLDCMSTreeViewFiller in '..\Filler\URLDCMSTreeViewFiller.pas',
  uDaUrlLink in '..\Filler\uDaUrlLink.pas',
  uDADCTreeView in '..\..\DaTrView\uDADCTreeView.pas',
  uFTCController in '..\uFTCController.pas',
  UOptionsDialog in 'UOptionsDialog.pas' {OptionsDlg},
  DsgnIntf in '..\..\Source\Toolsapi\dsgnintf.pas',
  ToolEdit in '..\..\Rx\Units\Tooledit.pas',
  uJSDeployer in 'uJSDeployer.pas',
  uFTCForm in 'uFTCForm.pas',

  umainFrame in 'umainFrame.pas',
  uLinkFrame in 'uLinkFrame.pas' {LinkFrame: TFrame};

{$R *.RES}

begin
  Application.Initialize;

  Application.CreateForm(TOptionsDlg, OptionsDlg);
  Application.Run;
end.
