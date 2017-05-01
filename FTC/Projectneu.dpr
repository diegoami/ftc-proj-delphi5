program Projectneu;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uLinkFrame in 'uLinkFrame.pas' {LinkFrame: TFrame},
  umainFrame in 'umainFrame.pas' {mainFrame: TFrame},
  uFTCForm in 'uFTCForm.pas' {FTCForm},
  uExtsForm in 'uExtsForm.pas' {ExtsForm},
  Logger in 'Logger.pas',
  uFTCAbout in 'uFTCAbout.pas' {FTCAboutBox},
  uFTCController in 'uFTCController.pas',
  uHtmlContainerFromDCTreeView in 'uHtmlContainerFromDCTreeView.pas',
  UOptionsDialog in 'UOptionsDialog.pas' {OptionsDlg},
  uRegisterForm in 'uRegisterForm.pas' {RegisterForm},
  uRegisterParm in 'uRegisterParm.pas',
  uScanningUnit in 'uScanningUnit.pas' {ScanningForm},
  HtmlContainerFromTreeView in '..\Mylibs\Filler\HtmlContainerFromTreeView.pas',
  uDaUrlLink in '..\Mylibs\Filler\uDaUrlLink.pas',
  URLDCMSTreeViewFiller in '..\Mylibs\Filler\URLDCMSTreeViewFiller.pas',
  URLFiller in '..\Mylibs\Filler\URLFiller.pas',
  URLTreeViewFiller in '..\Mylibs\Filler\URLTreeViewFiller.pas',
  GetURL in '..\Mylibs\BHTML\GetURL.pas',
  htmlmisc in '..\Mylibs\BHTML\HTMLMisc.pas',
  HTMLParser in '..\Mylibs\BHTML\HTMLParser.pas',
  HTMLParserSupt in '..\Mylibs\BHTML\HTMLParserSupt.pas',
  hierarchy in '..\Mylibs\BHTML\Hierarchy.pas',
  StringTable in '..\Mylibs\BHTML\StringTable.pas',
  TableForm in '..\Mylibs\BHTML\TableForm.pas' {TableFrm},
  Misc in '..\Mylibs\BHTML\Misc.pas',
  uJSDeployer in 'uJSDeployer.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFTCForm, FTCForm);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TExtsForm, ExtsForm);
  Application.CreateForm(TFTCAboutBox, FTCAboutBox);
  Application.CreateForm(TOptionsDlg, OptionsDlg);
  Application.CreateForm(TRegisterForm, RegisterForm);
  Application.CreateForm(TScanningForm, ScanningForm);
  Application.CreateForm(TTableFrm, TableFrm);
  Application.Run;
end.
