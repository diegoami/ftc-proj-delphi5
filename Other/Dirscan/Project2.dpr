program Project2;

uses
  Forms,
  Unit3 in 'Unit3.pas' {Form1},
  uDADirScanTreeView in 'uDADirScanTreeView.pas',
  uDADirScan in 'uDADirScan.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.ShowHint := False;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
