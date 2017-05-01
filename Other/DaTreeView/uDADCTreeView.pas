{*****************************************************************************
 *
 *  DADCTreeView.pas - My TreeView
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

unit uDADCTreeView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, dcdtree;

type
  TOnDragNodeEvent = procedure(Sender : TObject; Source, Destination : TTreeNode) of object;

  TDADCTreeView = class(TDCMSTreeView)
  private
    FOnDeleteNode : TTVChangedEvent;
    FCutNode : TTreeNode;
    FCutNodes : TList;
    FOnDragNodeEvent : TOnDragNodeEvent;
    FDragDropEnabled : Boolean;
    FCustomDragDrop : Boolean;
    NodDrag : TTreeNode;
    isLoaded : boolean;
  protected
    OldOnMouseDown : TMouseEvent;
    OldOnDragOver : TDragOverEvent;
    OldOnDragDrop : TDragDropEvent;
    procedure InternalMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure InternalDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
    procedure InternalDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DeleteNodeContent(Node : TTreeNode);
  public
    procedure DeleteNode(Node : TTreeNode);
    procedure Loaded; override;
    procedure ClearAll;
    constructor Create(AOwner : TComponent); override;
procedure CutNodes(Nodes : TList);
    procedure CutNode(Node : TTreeNode);
    procedure PasteNodeAt(Node : TTreeNode);
  published
    property DragDropEnabled : Boolean read FDragDropEnabled write FDragDropEnabled;
    property CustomDragDrop : Boolean read FCustomDragDrop write FCustomDragDrop;
    property OnDeleteNode : TTVChangedEvent read FOnDeleteNode write FOnDeleteNode;
    property OnDragNodeEvent : TOnDragNodeEvent read FOnDragNodeEvent write FOnDragNodeEvent;
  end;

procedure Register;

implementation

constructor TDADCTreeView.Create(AOwner : TComponent);
begin
  inherited;

  IsLoaded := False;
end;

procedure TDADCTreeView.DeleteNode(Node : TTreeNode);
var i : integer;
  DelNode : TTreeNode;
begin

  for i := Node.Count - 1 downto 0 do begin
    DelNode := Node.Item[i];
    DeleteNode(DelNode);
  end;
  DeleteNodeContent(Node);

  Items.Delete(Node);

  Node := nil;


end;

procedure TDADCTreeView.ClearAll;
var i : integer;
begin
  for i := Items.Count-1 downto 0 do
    DeleteNode(Items[i]);
  Items.Clear;
end;


procedure TDADCTreeView.DeleteNodeContent(Node : TTreeNode);
begin
  if Assigned(FOnDeleteNode) then
    FOnDeleteNode(Self,Node);
end;

procedure TDADCTreeView.CutNodes(Nodes : TList);
var i : integer;
    Node : TTreeNode;
begin
  if (Nodes <> nil) then begin
    for i := 0 to Nodes.Count-1 do begin
      Node := TTreeNode(Nodes.Items[i]);
      Node.Cut := False;
    end;
  end;
  FCutNodes := Nodes;
  for i := 0 to Nodes.Count-1 do begin
      Node := TTreeNode(Nodes.Items[i]);
      Node.Cut := True;
  end;

end;



procedure TDADCTreeView.CutNode(Node : TTreeNode);
begin
  if (FCutNode <> nil) and (FCutNode.Owner <> nil) and (FCutNode.Parent <> nil) and (FCutNode.TreeView <> nil) then
    FCutNode.Cut := False;

  FCutNode := Node;
  FCutNode.Cut := True;
end;


procedure TDADCTreeView.PasteNodeAt(Node : TTreeNode);

  procedure PasteNodeRoutine(FromNode, ToNode : TTreeNode);
  var i : integer;
      NewNode : TTreeNode;

  begin
    NewNode := Items.AddChildObject(ToNode, FromNode.Text, FromNode.Data);
    NewNode.ImageIndex := FromNode.ImageIndex;
    NewNode.SelectedIndex := FromNode.SelectedIndex;
    for i := 0 to FromNode.Count-1 do
      PasteNodeRoutine(FromNode.Item[i],NewNode)
  end;

var i : integer;
     TempNode : TTreeNode;
begin
  if (FCutNode <> nil) and (FCutNode <> Node) then begin
          FCutNode.Cut := false;

        PasteNodeRoutine(FCutNode,Node);
        DeleteNode(FCutNode);
        FCutNode := nil;

  end else begin
    for i := 0 to FCutNodes.Count-1 do begin
      TempNode := TTreeNode(FCutNodes.Items[i]);
      PasteNodeRoutine(TempNode,Node);
      DeleteNode(TempNode);

    end;
    FCutnodes := nil;
  end;

end;


procedure TDADCTreeView.InternalDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var NodX : TTreeNode;
    HT : THitTests;
begin
  if Source is TDCMSTreeView then begin
    HT := GetHitTestInfoAt(X, Y);
    NodX := TDCMSTreeView(Source).GetNodeAt(X,Y);
    if (NodX <> nil) and (HT - [htOnIcon,htOnItem, htOnLabel] <> HT) then
      if (FCustomDragDrop) and (Assigned(FOnDragNodeEvent)) then
        FOnDragNodeEvent(Self,NodDrag, NodX)
      else begin
        CutNode(NodDrag);
        PasteNodeAt(Nodx);
      end;

  end;
  if Assigned(OldOnDragDrop) then
    OldOnDragDrop(Sender, Source, X, Y);
end;



procedure TDADCTreeView.InternalDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var OldAccept : Boolean;
begin
  if Assigned(OldOnDragOver) then begin
    OldOnDragOver(Sender, Source, X,Y,State,OldAccept);
  end;
  Accept := OldAccept or ((Source is TDCMSTreeView) and DragDropEnabled);

end;

procedure TDADCTreeView.InternalMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
 var HT : THitTests;
begin

  if Assigned(OldOnMouseDown) then
    OldOnMouseDown(Sender, Button, Shift, X, Y);
  if Button = mbLeft then begin

    nodDrag := GetNodeAt(X,Y);
    HT := GetHitTestInfoAt(X, Y);

   if (nodDrag <> nil) and (DragDropEnabled) and (HT - [htOnIcon] <> HT) then
       BeginDrag(false, Mouse.DragThreshold+2);
  end;

end;



procedure TDADCTreeView.Loaded;
begin
  inherited;
  if isLoaded then exit;
  OldOnDragOver := OnDragOver;
  OnDragOver := InternalDragOver;
  OldOnDragDrop := OnDragDrop;
  OnDragDrop := InternalDragDrop;
  OldOnMouseDown := OnMouseDown;
  OnMouseDown := InternalMouseDown;
  isLoaded := True;
end;

procedure Register;
begin
  RegisterComponents('Diego Amicabile', [TDADCTreeView]);
end;

end.
