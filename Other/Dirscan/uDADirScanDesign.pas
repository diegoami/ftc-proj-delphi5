unit uDADirScanDesign;

interface

uses Windows,  Classes, SysUtils,
  DsgnIntf, Controls, Graphics, ExtCtrls, Menus, Forms;


{ TDirnameProperty }

TDirnameProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;


implementation

procedure TDirnameProperty.Edit;
var
  FolderName: string;
begin
  FolderName := GetValue;
  if BrowseDirectory(FolderName, ResStr(SSelectDirCap), 0) then
    SetValue(FolderName);
end;

function TDirnameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog , paRevertable ];
end;


end.
