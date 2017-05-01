{*****************************************************************************
 *
 *  uDADirScanListView.pas - Directory scanning - ListView filling component
 *
 *  Copyright (c) 2000 Diego Amicabile
 *
 *  Author:     Diego Amicabile
 *  E-mail:     diegoami@yahoo.it
 *  Homepage:   http://www.geocities.com/diegoami
 *
 *  This component is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation;
 *
 *  This component is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this component; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA
 *
 *****************************************************************************}

unit uDaDirScanListView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uDADirScan, ComCtrls;

type
  TOnAddingSubItems = procedure (Sender : TObject; Item : TListItem; SRC : TSearchRecClass) of object;
  TDADirScanListView = class(TDADirScan)
  private
    FOnAddingSubItems : TOnAddingSubItems;
    FListView : TListView;
    CurrListItem : TListItem;
  protected
    procedure AddFile(Dirname, Filename : String; Sr : TSearchREc); override;
    procedure AddDir(Dirname : String; Sr : TSearchREc); override;
    procedure ClearTarget; override;
    procedure SetDirectory(Dir : String); override;
  public
    function GetFileNameForItem(ListItem : TListItem) : String;
    procedure ClearAll; override;
  published
    property ListView : TListView read FListView write FListView;
    property OnAddingSubItems : TOnAddingSubItems read FOnAddingSubItems write FOnAddingSubItems ;
  end;

procedure Register;

implementation

{$R DADIRSCANLISTVIEW.DCR}

procedure TDADirScanListView.ClearAll;
var i :integer;
begin
  if FListView = nil then exit;
  for i := 0 to FListView.Items.Count-1 do
    TSearchRecClass(FListView.Items[i]).Free
end;


procedure TDADirScanListView.ClearTarget;
begin
  if Assigned(FListView) then begin
    with FListView do begin
      ITems.Clear;

      SmallImages := FIlist;
      LargeImages := FIBigList
    end
  end;
  ClearAll;
end;

function TDADirScanListView.GetFileNameForItem(ListItem : TListItem) : String;
begin
  result := TSearchRecClass(LIstItem.Data).FullName;
end;

procedure TDADirScanListView.SetDirectory(Dir : String);
begin
  if Assigned(FListView) then begin
    FListView.Items.BeginUpdate;
    inherited;
    FListView.Items.EndUpdate;
  end
end;


procedure TDADirScanListView.AddDir(Dirname : String; Sr : TSearchRec);
var LastDir : String;
   SRC : TSearchRecClass;
begin
  inherited;
  SRC := AddSearchRec(SR, Dirname);
  if Assigned(FListView) then begin
    LastDir := GetLAstDir(DirName);
    CurrListItem := FListView.Items.Add;
    with CurrListItem do begin
      CAption := GetLastDir(DirName);
      Data := SRC;
      if FListView.ViewStyle = vsIcon then
        ImageIndex := fiFolN
      else
        ImageIndex := fiBigFolN;
    end;
  end;
  if Assigned(FOnAddingSubItems) then
    FOnAddingSubItems(Self, CurrListItem, SRC);
end;

procedure TDADirScanListView.AddFile(Dirname, Filename : String;  Sr : TSearchRec);
var SRC : TSearchRecClass;
begin
  inherited;
  SRC := AddSearchRec(sr, DirName);
  if Assigned(FListView) then begin
    CurrListItem := FListView.Items.Add;
    with CurrListItem do begin
      Caption := FileName;
      Data := SRC;

      ImageIndex := GetIndexOfImage(DirName+FileName,FListView.ViewStyle = vsIcon);
    end;
  end;
  if Assigned(FOnAddingSubItems) then
    FOnAddingSubItems(Self, CurrListItem, SRC);

end;

procedure Register;
begin
  RegisterComponents('Diego Amicabile', [TDADirScanListView]);
end;

end.
