program Demo;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  uDADirScanTreeView in '..\uDADirScanTreeView.pas',
  uDaDirScanListView in '..\uDaDirScanListView.pas',
  uDADirScan in '..\uDADirScan.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.ShowHint := False;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
