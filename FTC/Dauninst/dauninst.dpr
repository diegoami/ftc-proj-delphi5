program dauninst;

uses

  uDaUnInstaller in 'uDaUnInstaller.pas';


var DaUnInstaller : TDAUninstaller;

begin

  DaUnInstaller := TDaUninstaller.Create;
  if ParamCount < 1 then exit;
  DaUninstaller.ApplicationName := 'Folder Tree Creator';
  DaUninstaller.Execute;

end.
