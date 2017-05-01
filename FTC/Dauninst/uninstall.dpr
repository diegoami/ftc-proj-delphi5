program uninstall;

uses
  uDaUnInstaller in 'uDaUnInstaller.pas',
  Unit1 in 'Unit1.pas' {Form1};

var DaUnInstaller : TDAUninstaller;

begin

  DaUnInstaller := TDaUninstaller.Create;
  if ParamCount < 1 then exit;
  DaUninstaller.ApplicationName := 'Folder Tree Creator';
  DaUninstaller.Execute;

end.
