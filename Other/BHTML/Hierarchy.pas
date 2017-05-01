unit hierarchy;

{ ============================================================================

  Copyright (c) 1997,1998,1999,2000 by Richard Phillips (richardp@dallas.net)

  All rights reserved.  Free for *non-commercial* use.  Feel free to contact
    me if you would like to make use of the components in a commercial
    application.

  07/08/99  RP  - Removed FNodeType = 0 statement from THierarchyNode.Create
  07/20/99  RP  - Removed Items property (whoa...was it slow to create)
                - THierarchyNode no longer inherits from TComponent (too slow to create)
                - Commented out THierarchyItem and THierarchyItemList
                - Removed dependency on TPairList
  07/23/99  RP  - ClearChildren now Free's the children as well
                - Optimisation in Find method (CompareText)
                - Deleted HadChildren function
                - Added Index property
                - Added InsertChild method
  07/27/99  RP  - Cleaned up and re-exposed THierarchyItemList as THierarchyNodeList
  08/03/99  RP  - Added IndexOf method of THierarchyItemList
                - Deleted Owner property of THierarchyItemList
  09/14/99  RP  - Exposed some methods of THierarchyNode via protected
  01/27/00  RP  - Removed reference to hierarchy.res (no longer a component)              

  ============================================================================ }

// * Use CompareText in SortChildren method

interface

uses Classes, SysUtils;

type
  THierarchyNode = class;

  THierarchyEvent = procedure(Sender : TObject; ANode : THierarchyNode) of object;

  THierarchyNode = class
      FChildren : TList;

    private
      FCaption,
      FText : string;
      FData : TObject;
      FParams : TStringList;
      FNodeType : integer;
      FParent : THierarchyNode;
      FOnEach : THierarchyEvent;

      function GetChildCount : integer;
      function GetLevel : integer;
      procedure DoEach(ANode : THierarchyNode);
      procedure _AddChild(ANode : THierarchyNode);
      procedure _DeleteChild(ANode : THierarchyNode);
      function GetIndex: integer;
      procedure SetIndex(const Value: integer);

    protected
      function GetParent : THierarchyNode; virtual;
      procedure SetParent(AParent : THierarchyNode); virtual;
      function GetChild(const Index : integer) : THierarchyNode; virtual;

    public
      constructor Create; virtual;
      destructor Destroy; override;

      procedure Clear;
      procedure ClearChildren;

      procedure AddChild(ANode : THierarchyNode); virtual;
      procedure InsertChild(Index : integer; ANode : THierarchyNode); virtual;
      function CreateChild(AText : string; AObject : TObject) : THierarchyNode; virtual;
      procedure DeleteChild(ANode : THierarchyNode); virtual;
      function Find(const FindText : string) : integer;
      procedure ApplyToEach(ANode : THierarchyNode);
      function ForEach : boolean;
      procedure SortChildren;

      property NodeType : integer read FNodeType write FNodeType;
      property Index : integer read GetIndex write SetIndex;
      property Data : TObject read FData write FData;
      property Parent : THierarchyNode read FParent write SetParent;
      property ChildCount : integer read GetChildCount;
      property Children[const Index : integer] : THierarchyNode read GetChild; default;
      property Params : TStringList read FParams write FParams;
      property Level : integer read GetLevel;
      property Caption : string read FCaption write FCaption;
      property Text : string read FText write FText;
      property OnEach : THierarchyEvent read FOnEach write FOnEach;

  end;

  THierarchyNodeList = class
    private
      FItems : TList;

      function GetItem(const Index : integer) : THierarchyNode;
      function GetString(const Index : integer) : string;
      procedure SetString(const Index : integer; Value : string);
      function GetCount : integer;

    public
      constructor Create;
      destructor Destroy; override;

      function Add(Item : THierarchyNode) : integer;
      procedure Clear;
      procedure Delete(Index : integer);
      procedure Insert(Index : integer; Item : THierarchyNode);
      procedure Sort;
      function IndexOf(Item : THierarchyNode) : integer;

      property Count : integer read GetCount;
      property Items[const Index : integer] : THierarchyNode read GetItem; default;
      property Strings[const Index : integer] : string read GetString write SetString;

  end;

implementation

// ----------------------------------------------------------------------------

constructor THierarchyNode.Create;

begin
  Inherited;

  FChildren := TList.Create;
  FParams := TStringList.Create;

end;

destructor THierarchyNode.Destroy;

begin
  SetParent(nil);

  ClearChildren;

  FParams.Free;
  FChildren.Free;

  Inherited;

end;

procedure THierarchyNode.Clear;

begin
  ClearChildren;

  FParams.Clear;
  FText := '';
  FNodeType := 0;
  FParent := nil;
  FData := nil;

end;

procedure THierarchyNode.ClearChildren;

// Free (destroy) all of the children that this node owns

var
  Counter : integer;

begin
  for Counter := FChildren.Count - 1 downto 0 do
    Children[Counter].Free;

end;

procedure THierarchyNode.AddChild(ANode : THierarchyNode);

// Note that this will cause the parent to add this node to its child list.
// See SetParent.

begin
  ANode.Parent := Self;

end;

procedure THierarchyNode.InsertChild(Index: integer; ANode: THierarchyNode);

begin
  AddChild(ANode);
  ANode.Index := Index;

end;

procedure THierarchyNode.DeleteChild(ANode : THierarchyNode);

// Note that this will cause the parent to remove this node from its child list.
// See SetParent.

begin
  ANode.Parent := nil;

end;

procedure THierarchyNode._AddChild(ANode : THierarchyNode);

begin
  FChildren.Add(ANode);
  ANode.FParent := Self;

end;

procedure THierarchyNode._DeleteChild(ANode : THierarchyNode);

var
  Index : integer;

begin
  try
    Index := FChildren.IndexOf(ANode);

    If Index >= 0 then
      FChildren.Delete(Index);

    ANode.FParent := nil;

  except

  end;

end;

function THierarchyNode.GetParent: THierarchyNode;
begin
  Result := FParent;
  
end;

procedure THierarchyNode.SetParent(AParent : THierarchyNode);

begin
  If (FParent <> AParent) and (AParent <> Self) then
    begin
      if FParent <> nil then
        FParent._DeleteChild(Self);

      if AParent <> nil then
        AParent._AddChild(Self);

    end;

end;

function THierarchyNode.GetChild(const Index : integer) : THierarchyNode;

begin
  Result := THierarchyNode(FChildren[Index]);

end;

function THierarchyNode.GetChildCount : integer;

begin
  Result := FChildren.Count;

end;

function THierarchyNode.Find(const FindText : string) : integer;

var
  Counter : integer;

begin
  Result := -1;

  for Counter := 0 to ChildCount - 1 do
    If CompareText(Children[Counter].Text,FindText) = 0 then
      begin
        Result := Counter;
        Break;
      end;

end;

procedure THierarchyNode.ApplyToEach(ANode : THierarchyNode);

var
  NumChildren,
  Counter : integer;
  ChildNode : THierarchyNode;

begin
  DoEach(ANode);

  NumChildren := ANode.ChildCount;

  for Counter := 0 to NumChildren - 1 do
    begin
      ChildNode := ANode.Children[Counter];

      If ChildNode <> nil then
        ApplyToEach(ChildNode);

    end;

end;

function THierarchyNode.ForEach : boolean;

begin
  Result := True;

  ApplyToEach(Self)

end;

function THierarchyNode.GetLevel : integer;

var
  ParentNode : THierarchyNode;

begin
  Result := 0;

  ParentNode := FParent;

  while ParentNode <> nil do
    begin
      Inc(Result);
      ParentNode := ParentNode.Parent;
    end;

end;

procedure THierarchyNode.DoEach(ANode : THierarchyNode);

begin
  If Assigned(FOnEach) then
    FOnEach(Self,ANode);

end;

procedure THierarchyNode.SortChildren;

procedure Sort(L,R: Integer);

var
  TempStr : string;
  I,
  J : Integer;

begin
  if L < R then
    begin
      with FChildren do
        begin
          with THierarchyNode(FChildren.Items[R]) do
            TempStr := LowerCase(Text);

          I := Pred(L);
          J := R;

          repeat
            repeat
              Inc(I);
            until LowerCase(THierarchyNode(FChildren.Items[I]).Text) >= TempStr;

            repeat
              Dec(J);
            until (LowerCase(THierarchyNode(FChildren.Items[J]).Text) <= TempStr) or (J = 0);

            if J <= I then
              Break;

            Exchange(I,J);

          until False;

          Exchange(I,R);

        end;

      Sort(L,I - 1);
      Sort(I + 1,R);

    end;

end;

begin
  Sort(0,FChildren.Count - 1);

end;

function THierarchyNode.CreateChild(AText : string; AObject : TObject) : THierarchyNode;

var
  NewNode : THierarchyNode;

begin
  NewNode := THierarchyNode.Create;
  NewNode.Text := AText;
  NewNode.Data := AObject;

  AddChild(NewNode);

  Result := NewNode;

end;

function THierarchyNode.GetIndex: integer;

// Return this node's index in it's parent's child list

begin
  If FParent <> nil then
    Result := FParent.FChildren.IndexOf(Self)
  else
    Result := -1;

end;

procedure THierarchyNode.SetIndex(const Value: integer);

// Move this node from current position to new position

var
  Index : integer;

begin
  If FParent <> nil then
    begin
      Index := GetIndex;

      If Index <> Value then
        FParent.FChildren.Move(Index,Value);

    end;

end;

// ----------------------------------------------------------------------------

{ THierarchyNodeList }

constructor THierarchyNodeList.Create;

begin
  Inherited Create;

  FItems := TList.Create;

end;

destructor THierarchyNodeList.Destroy;

begin
  FItems.Free;

  Inherited;

end;

procedure THierarchyNodeList.Clear;

var
  Counter : integer;

begin
  for Counter := FItems.Count - 1 downto 0 do
    Delete(Counter);

end;

function THierarchyNodeList.GetItem(const Index : integer) : THierarchyNode;

begin
  Result := THierarchyNode(FItems[Index]);

end;

function THierarchyNodeList.GetString(const Index : integer) : string;

begin
  Result :=  THierarchyNode(FItems[Index]).Caption;

end;

procedure THierarchyNodeList.SetString(const Index : integer; Value : string);

begin
  THierarchyNode(FItems[Index]).Caption := Value;

end;

function THierarchyNodeList.GetCount : integer;

begin
  Result := FItems.Count;

end;

function THierarchyNodeList.Add(Item : THierarchyNode) : integer;

begin
  Result := FItems.Add(Item);

end;

procedure THierarchyNodeList.Delete(Index : integer);

begin
  THierarchyNode(FItems[Index]).Free;
  FItems.Delete(Index);

end;

procedure THierarchyNodeList.Sort;

procedure SortList(L, R: Integer);

var
  TempStr : string;
  I,
  J : Integer;

begin
  if L < R then
    begin
      I := Pred(L);
      J := R;

      repeat
        repeat
          Inc(I);
        until CompareText(Strings[I],TempStr) >= 0;

        repeat
          Dec(J);
        until (CompareText(Strings[J],TempStr) <= 0) or (J = 0);

        if J <= I then
          Break;

        FItems.Exchange(I,J);

      until False;

      FItems.Exchange(I,R);

      SortList(L,I - 1);
      SortList(I + 1,R);

    end;

end;

begin
  SortList(0,FItems.Count - 1);

end;

procedure THierarchyNodeList.Insert(Index: integer; Item: THierarchyNode);
begin
  FItems.Insert(Index,Item);

end;

function THierarchyNodeList.IndexOf(Item: THierarchyNode): integer;

// Return Index of Item in the FItems list

begin
  Result := FItems.IndexOf(Item);

end;

end.
