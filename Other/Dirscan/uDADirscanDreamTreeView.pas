 {*****************************************************************************
 *
 *  uDADirScanTreeView.pas - Directory scanning - TreeView filling component
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


unit uDADirScanDreamTreeView;

interface



uses
 uDaDirScan, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, comctrls,dcdTree
 ;

type
  TDADirScanDreamTreeView = class(TDADirScan)
  private
    FTreeView : TDCMSTreeView;

    FEmptyDirs : boolean;

    Nodes : array[0..MAXLEVELS] of  TTreeNode;
  protected
    procedure DeleteCurrentDir; override;
    procedure ScanDirectory(Dir : String; var FilesInThisDir : integer); override;
    procedure EndOfDir(DirName : String; MustDec : Boolean; FilesFound : integer); override;
    procedure AddFile(Dirname, Filename : String; Sr : TSearchRec); override;
    procedure ClearTarget; override;
    procedure SetDirectory(Dir : String); override;
  public
    CurrNode : TTreeNode;
    destructor Destroy; override;
    procedure SetImages(Node : TTreeNode; FileName : String);

    procedure AddDir(Dirname : String; Sr : TSearchRec); override;
//    function AddNode(Dirname : String);

    function GetFileNameAtNode(Node : TTreeNode) : String;
    procedure FillNode(Node : TTreeNode; DirName : String);
    constructor Create(AOwner : TComponent); override;
    procedure SetAllImages;
  published
    property OnDirEnd;
    property EmptyDirs : boolean read FEmptyDirs write FEmptyDirs;
    property TreeView : TDCMSTreeView read FTreeView write FTreeView;
  end;

procedure Register;

implementation


procedure TDaDirScanDreamTreeView.SetDirectory(Dir : String);
begin
  if Assigned(FTreeView) then begin
    FTreeView.Items.BeginUpdate;
    inherited;
    FTreeView.Items.EndUpdate;
  end;
end;

procedure TDaDirScanDreamTreeView.ScanDirectory(Dir : String; var FilesInThisDir : Integer);
begin
 // if AssigneD(FTreeView) then begin
 //   FTreeView.Items.BeginUpdate;
    inherited;
  //  FTreeView.Items.EndUpdate;
 // end;
{  if Assigned(FTreeView) then
    FTreeView.AlphaSort;}
end;

function TDaDirScanDreamTreeView.GetFileNameAtNode(Node : TTreeNode) : String;
begin

  if (Node.Data <> nil) then
    result := TSearchRecClass(Node.Data).FullName;
end;

procedure TDaDirScanDreamTreeView.AddFile(Dirname, Filename : String; Sr : TSearchRec);
var SRC : TSearchRecClass;
begin
  SRC := AddSearchRec(SR,Dirname);

  if Assigned(FTreeView) then begin

    CurrNode := FTreeView.Items.AddChild(Nodes[CurrentLevel],FileName);
    CurrNode.ImageIndex    := GetIndexOfImage(DirName+FileName,false);
    CurrNode.SelectedIndex    := GetIndexOfImage(DirName+FileName,false );
    //CurrNode.Data := TObject(AllStrings.Strings[AllStrings.AddObject(DirName+FileName, AddSearchRec(sr))]);
//    CurrNode.Data := TObject(AddString(DirName+FileName,SRC));
    if (CompleteData) then
      CurrNode.Data := SRC;
  end;

end;

procedure TDaDirScanDreamTreeView.DeleteCurrentDir;
//not used
var i : integer;
begin
  inherited;
   if  not Currnode.Haschildren then
     CurrNode.Delete;
end;

constructor TDaDirScanDreamTreeView.Create(AOwner : TComponent);
begin
  inherited;
  if Assigned(FTreeView) then begin
    FTreeView.Images := fIList;
    FTreeView.Items.Clear;
  end;
end;

destructor TDaDirScanDreamTreeView.Destroy;
var i : integer;
begin
  inherited;
end;


procedure TDaDirScanDreamTreeView.EndOfDir(DirName : String; MUstDec : Boolean; FIlesFound : Integer);
begin
  inherited;

  if (CurrNode <> nil) {and  IsaDir(GetFileNameAtNode(CurrNode))  }then begin
    if (FilesFound = 0) then begin
      CurrNode.HasChildren := HasSubDirs(DirName)  ;
      if not ((CurrNode.HasChildren and (FilesFound > 0)) or FEmptyDirs ) then
        FTreeView.Items.Delete(CurrNode);
    end;
    CurrNode := Nodes[CurrentLevel];
  end;
end;

procedure TDaDirScanDreamTreeView.AddDir(Dirname : String; Sr : TSearchRec);
var LastDir : String;
  SRC : TSearchRecClass;
begin
  if (CompleteData) then
    SRC := AddSearchRec(SR,Dirname);

  if Assigned(FTreeView) then begin
    LastDir := GetLAstDir(DirName);
    Nodes[CurrentLevel+1] := FTreeView.Items.AddChild(Nodes[CurrentLevel],LastDir);
    CurrNode := Nodes[CurrentLevel+1];
    CurrNode.ImageIndex    := GetIndexOfImage(DirName,false);
    CurrNode.SelectedIndex    := GetIndexOfImage(DirName,false );
    if (CompleteData) then

      CurrNode.Data := SRC;
//    CurrNode.Data := TObject(AllStrings.Strings[AllStrings.AddObject(DirName, AddSearchRec(sr))]);
//   CurrNode.Data := TObject(AddString(DirName,SRC));


  end;
  inherited;
end;

procedure TDaDirScanDreamTreeView.SetImages(Node : TTreeNode; FileName : String);
begin
    Node.ImageIndex    := GetIndexOfImage(FileName,false);
    Node.SelectedIndex    := GetIndexOfImage(FileName,false );
end;
 {
function AddNode(Dirname : String) : TTreeNode;
begin
  if Assigned(FTreeView) then begin
    LastDir := GetLAstDir(DirName);
    Nodes[CurrentLevel+1] := FTreeView.Items.AddChild(Nodes[CurrentLevel],LastDir);
    CurrNode := Nodes[CurrentLevel+1];
    CurrNode.ImageIndex    := GetIndexOfImage(DirName,false);
    CurrNode.SelectedIndex    := GetIndexOfImage(DirName,false );

  end;

end;

}
procedure TDaDirScanDreamTreeView.FillNode(Node : TTreeNode; DirName : String);
var FilesInDir : Integer;
begin
  if Assigned(FTreeView) then begin
    FTreeView.Images := fIList;
    FTreeView.Items.BeginUpdate;

    FilesInDir := 0;
    CurrentLevel := Node.Level+1;
    FLevels := FLevels+Node.Level;
    CurrNode := Node;
    Nodes[CurrentLevel] := CurrNode;
    ScanDirectory(DirName, FilesInDir);
    FTreeView.Items.EndUpdate;
  end;
end;

procedure TDaDirScanDreamTreeView.ClearTarget;
var i : integer;
begin
  inherited;
  if Assigned(FTreeView) then begin
    FTreeView.Items.Clear;
    FTreeView.Images := fIList
  end;
  //ClearAll;

  CurrNode := Nil;

  for i := 0 to MAXLEVELS do
    Nodes[i] := nil;
end;

procedure Register;
begin
  RegisterComponents('Diego Amicabile', [TDADirScanDreamTreeView]);
end;

function GetStringFromTreeNode(Node : TTreeNode) : String;
var TotalString : string;
  LocalNode : TTreeNode;
begin
  LocalNode := Node;
  TotalString := LocalNode.Text;
  while LocalNode.Parent <> nil do begin
    LocalNode:= LocalNode.Parent;
    TotalString := LocalNode.Text+'\'+TotalString;



  end;
  if (node.HasChildren) then
    TotalString := TotalString+'\';
  result := TotalString;
end;


procedure TDaDirScanDreamTreeView.SetAllImages;
var I : integer;
  TotalString : String;
begin

  FTreeView.Images := fIList;
  FTreeView.Items.BeginUpdate;
  if Assigned(FTreeView) then begin

    for i := 0 to FTreeView.Items.Count-1 do begin
      TotalString := GetStringFromTreeNode(FTreeView.Items[i]);
      SetImages(FTreeView.Items[i],TotalString);

    end;
  end;
   FTreeView.Items.EndUpdate;
end;

end.

