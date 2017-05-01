unit DADirScanListView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uDADirScan, ComCtrls;

type
  TDADirScanListView = class(TDADirScan)
  private

    FListView : TListView;
    CurrListItem : TListItem;
  protected
    procedure AddFile(Dirname, Filename : String); override;
    procedure AddDir(Dirname : String); override;
    procedure ClearTarget; override;
  public

  published
    property ListView : TListView read FListView write FListView;
  end;

procedure Register;

implementation

{$R DADIRSCANLISTVIEW.DCR}

procedure TDADirScanListView.ClearTarget;
begin
  if Assigned(FListView) then begin
    with FListView do begin
      ITems.Clear;
      SmallImages := FIlist;
      LargeImages := FIBigList
    end
  end;
end;

procedure TDADirScanListView.AddDir(Dirname : String);
var LastDir : String;
begin
  if Assigned(FListView) then begin
    LastDir := GetLAstDir(DirName);
    CurrListItem := FListView.Items.Add;
    with CurrListItem do begin
      CAption := GetLastDir(DirName);
      Data := PChar(AllStrings.Strings[AllStrings.Add(DirName)]);

      if FListView.ViewStyle = vsIcon then
        ImageIndex := fiFolN
      else
        ImageIndex := fiBigFolN;
    end;
  end;
  inherited;
end;

procedure TDADirScanListView.AddFile(Dirname, Filename : String);
begin
  inherited;
  if Assigned(FListView) then begin
    CurrListItem := FListView.Items.Add;
    with CurrListItem do begin
      Caption := FileName;
      Data := PChar(AllStrings.Strings[AllStrings.Add(DirName+FileName)]);
      ImageIndex := GetIndexOfImage(DirName+FileName,FListView.ViewStyle = vsIcon);
    end;
  end;
end;

procedure Register;
begin
  RegisterComponents('Diego Amicabile', [TDADirScanListView]);
end;

end.
