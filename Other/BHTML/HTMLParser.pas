unit HTMLParser;

{ ============================================================================

  Copyright (c) 1997,1998,1999,2000 by Richard Phillips (richardp@dallas.net)

  All rights reserved.  Free for *non-commercial* use.  Feel free to contact
    me if you would like to make use of the components in a commercial
    application.


  07/07/99  RP  - Added nte (Node Type Element) Constants and support thereof
  07/12/99  RP  - Added ceEmptyElements constant
                - Added nteCloseTag constant and support for holding close tags
  07/13/99  RP  - Added IsEmptyElement method
                - Converted IsContainer's to Not IsEmptyElement's
  07/18/99  RP  - Fixed ConvertParamsToTag to handle Values that contain ' or "
  07/19/99  RP  - Re-fixed ConvertParamsToTag to correctly handle ' or "
                - Added handling for multiple Params with same name to
                    ConvertParamsToTag
  07/21/99  RP  - Commented out IsContainer (to stop warnings)
  07/23/99  RP  - Minor Tuning in GetPCData, GetForm
  07/27/99  RP  - Moved ConvertParamsToTag out to HTMLMisc (from Render method)
                - Converted GetTags, GetForm to return results in THierarchyNodeList
                - Added GetChildrenAsList method
  07/30/99  RP  - Added IndexOf method
                - Added Occurence method
                - GetForm, GetTags now clear Items list prior to adding elements
  08/30/99  RP  - Added '?' XML Item handling
                - Added support for XML '/' empty element marker
  09/14/99  RP  - Added TTagNode and TTagNodeList classes
                - Moved Render,GetTags,GetPCData from THTMLParser to TTagNode
                - Altered GetTags to return all children if tag = '' or '*'
                - Moved Occurence method from THTMLParser to TTagNodeList
                - Deleted IndexOf method from THTMLParser
  09/15/99  RP  - Moved GetTagCount and FindTagByIndex to TTagNodeList
                   from THTMLParser
                - Moved GetTable and GetForm from THTMLParser to THTMLEngine
  09/16/99  RP  - Moved some nested proc's outside (based on tuning
                   recommendations)
  09/22/99  RP  - Debugging in .Sort method
  10/08/99  RP  - Added OnSyntaxWarning event
  10/20/99  RP  - Changed nteTag to nteElement
                - Changed cOther (state) to cDTD, added cDTDComment state
  10/27/99  RP  - Added checking for ambiguous tags when closing if found
                    matching tag to last tag in .Parse method
                - Added tracking of LineNum and CharPos for Debugging
                - Updated ceAmbiguous constant with all ambiguous elements
  10/28/99  RP  - Check for <P> and IsBlockElement in parse (instead of ceAmbiguous)
  11/16/99  RP  - Tuning to Parse method (using BuffStart and BuffLen)
  11/23/99  RP  - Bug fix for missed parsing case in '<'
  12/28/99  RP  - Bug fix for TTagNode.GetParent (doh! removed FParent var)
  01/09/00  RP  - Handling for '[' char in DTD items (CDATA and raw internal DTD's)
                - Added new CData node type and supporting node creation code
  01/29/00  RP  - Added TTagNode.GetTagsByType method
  01/31/00  RP  - Added TTagNode.Pedigree property
  03/02/00  RP  - Added TTagNode.GetTagsByParam method

  ============================================================================ }

interface

uses
  SysUtils, Classes, Hierarchy, HTMLMisc, Windows;

const
  nteNone = 0;
  nteElement = 1;
  ntePCData = 2;
  nteComment = 3;
  nteDTDItem = 4;
  nteCData = 5;
  cePCData = 'PCDATA';                           // Constants to represent HTML 4.0 DTD
                      ceHeaders = 'h1|h2|h3|h4|h5|h6';
  ceLists = 'ul|ol|dir|menu';
  ceFontStyles = 'tt|i|b|u|s|strike|big|small';
  cePhrases = 'em|strong|dfn|code|samp|kbd|var|cite|abbr|acronym';
  ceDeprecated = 'font';
  ceBlock = '|p|' + ceHeaders + ceLists + '|pre|dl|div|center|noscript|noframes|' +
    'blockquote|form|isindex|hr|table|fieldset|address|';
  ceAmbiguous = '|p|dt|dd|li|option|thead|tfoot|colgroup|tr|th|td|body|html|head|';
  ceEmptyElements = '|basefont|br|area|link|img|param|hr|input|col|frame|isindex|base|meta|';


type
  TNodeType = nteNone..nteCData;
  TNodeTypes = set of TNodeType;

  TTagNodeList = class;

  TTagNode = class(THierarchyNode)
  private
    FIsEmptyElement : boolean;

    procedure _GetTags(ANode: TTagNode; const Tag: string; Items: TTagNodeList);
    procedure _GetTagsByType(ANode: TTagNode; const Tag: string; Items: TTagNodeList; NodeTypes : TNodeTypes);
    procedure _GetPCData(var PCData: string);
    function GetPedigree : string;
    procedure _GetTagsByParam(ANode: TTagNode; const Tag: string;
      Items: TTagNodeList; const ParamName, ParamValue: string);

  protected
    function GetParent : TTagNode; //reintroduce;
    procedure SetParent(AParent : TTagNode); //reintroduce;
    function GetChild(const Index : integer) : TTagNode;// reintroduce;

  public
    procedure AddChild(ANode : TTagNode); //reintroduce;
    procedure InsertChild(Index : integer; ANode : TTagNode); //reintroduce;
    function CreateChild(AText : string; AObject : TObject) : TTagNode; //reintroduce;
    procedure DeleteChild(ANode : TTagNode); //reintroduce;
    function Render : string;
    function GetPCData : string;
    function GetPCDataLength: integer;
    function Find(const Tag : string) : integer;// reintroduce;
    procedure GetTags(const Tag: string; Items: TTagNodeList);
    procedure GetTagsByType(const Tag: string; Items: TTagNodeList; NodeTypes : TNodeTypes);
    procedure GetTagsByParam(const Tag: string; Items: TTagNodeList; const ParamName, ParamValue : string);

    property Parent : TTagNode read GetParent write SetParent;
    property Children[const Index : integer] : TTagNode read GetChild; default;
    property IsEmptyElement : boolean read FIsEmptyElement write FIsEmptyElement;
    property Pedigree : string read GetPedigree;

  end;

  TTagNodeList = class
  private
    FItems : TList;

    function GetItem(const Index : integer) : TTagNode;
    function GetString(const Index : integer) : string;
    procedure SetString(const Index : integer; Value : string);
    function GetCount : integer;
    procedure SortList(L, R: Integer);

  public
    constructor Create;
    destructor Destroy; override;

    function Add(Item : TTagNode) : integer;
    procedure Clear;
    procedure Delete(Index : integer);
    procedure Insert(Index : integer; Item : TTagNode);
    procedure Sort;
    function IndexOf(Item : TTagNode) : integer;
    function Occurence(Node: TTagNode): integer;
    function GetTagCount(const Tag: string): integer;
    function FindTagByIndex(const Tag: string; const Index: integer): TTagNode;

    property Count : integer read GetCount;
    property Items[const Index : integer] : TTagNode read GetItem; default;
    property Strings[const Index : integer] : string read GetString write SetString;

  end;

  THTMLTagNotifyEvent = procedure(Sender : TObject; ANode : TTagNode) of object;
  TSyntaxNotifyEvent = procedure(Sender : TObject; Text : string) of object;

  THTMLParser = class(TComponent)
  private
    Parsing : boolean;

    FTree : TTagNode;
    FOnHTMLTag : THTMLTagNotifyEvent;
    FOnSyntaxWarning : TSyntaxNotifyEvent;

    function IsEmptyElement(const TagName: string): boolean;
    function IsBlockElement(const TagName: string): boolean;
    function IsAmbiguous(const TagName: string): boolean;
    function BuildPCData(const Data: string): TTagNode;
    function BuildComment(const Data: string): TTagNode;
    function BuildDTDItem(const Data: string): TTagNode;
    procedure DoHTMLTag(ANode : TTagNode);
    procedure DoSyntaxWarning(const Text : string);

  protected
    { Protected declarations }

  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    procedure Parse(const Text : string);
    procedure Clear;

    property Tree : TTagNode read FTree;

  published
    property OnHTMLTag : THTMLTagNotifyEvent read FOnHTMLTag write FOnHTMLTag;
    property OnSyntaxWarning : TSyntaxNotifyEvent read FOnSyntaxWarning write FOnSyntaxWarning;

  end;

procedure Register;

implementation

{$R HtmlParser.res}


type
  TStack = class(TStringList)     // Special stringlist to wrap up 'stack'-like behaviours
    private
      function GetLastTag : string;
      function GetLastNode : TTagNode;

    public
      function Pop : string;
      function ContainsTag(const Tag : string) : boolean;

      property LastTag : string read GetLastTag;
      property LastNode : TTagNode read GetLastNode;

  end;

// ----------------------------------------------------------------------------

procedure Register;
begin
  RegisterComponents('Custom', [THTMLParser]);
end;

// ----------------------------------------------------------------------------

{ TTagNode }

procedure TTagNode.AddChild(ANode: TTagNode);
begin
  Inherited AddChild(ANode);

end;

function TTagNode.CreateChild(AText: string; AObject: TObject): TTagNode;
begin
  Result := TTagNode(Inherited CreateChild(AText,AObject));

end;

procedure TTagNode.DeleteChild(ANode: TTagNode);
begin
  Inherited DeleteChild(ANode);

end;

function TTagNode.GetChild(const Index: integer): TTagNode;
begin
  Result := TTagNode(Inherited GetChild(Index));

end;

function TTagNode.GetParent: TTagNode;
begin
  Result := TTagNode(Inherited GetParent);

end;

procedure TTagNode.InsertChild(Index: integer; ANode: TTagNode);
begin
  Inherited InsertChild(Index,ANode);

end;

procedure TTagNode.SetParent(AParent: TTagNode);
begin
  Inherited SetParent(AParent);

end;

function TTagNode.Render : string;

// Generate HTML representation of tree

var
  Counter : integer;

// -=-=-=-=-=-=-

procedure RenderNode(const Node : TTagNode);

// Write out individual node

var
  Counter : integer;

begin
  case Node.NodeType of
    nteElement : Result := Result + ConvertParamsToTag(Node.Caption,Node.Params);   // If it's an element...
    nteDTDItem : Result := Result + '<' + Node.Caption + ' ' + Node.Text + '>';     // If it's a DTD Item...
    nteComment : Result := Result + '<!-- ' + Node.Text + '-->';                    // If it's a comment...
    nteCData : Result := Result + '<![CDATA[' + Node.Text + ']]>';                  // If it's a CData section...
    else
      Result := Result + Node.Text;                                                 // Otherwise it's just text...

  end;

  for Counter := 0 to Node.ChildCount - 1 do
    RenderNode(Node.Children[Counter]);

  If Node.NodeType = nteElement then
    If not Node.IsEmptyElement then
      Result := Result + '</' + Node.Caption + '>';

end;

// -=-=-=-=-=-=-

begin
  Result := '';

  for Counter := 0 to ChildCount - 1 do
    RenderNode(Children[Counter]);

end;

function TTagNode.GetPCDataLength : integer;

var
  Counter : integer;

begin
  If NodeType = ntePCDATA then
    Result := Length(Text)
  else
    begin
      Result := 0;

      for Counter := 0 to ChildCount - 1 do
        Result := Result + Children[Counter].GetPCDataLength;

    end;

end;

procedure TTagNode._GetPCData(var PCData : string);

var
  Counter : integer;

begin
  If NodeType = ntePCDATA then
    PCData := PCData + Text
  else
    for Counter := 0 to ChildCount - 1 do
      Children[Counter]._GetPCData(PCData);

end;

function TTagNode.GetPCData : string;

// Return all of the PCData for a node as one string

begin
  Result := '';
  _GetPCData(Result);

end;

procedure TTagNode._GetTags(ANode : TTagNode; const Tag : string; Items : TTagNodeList);

// Return all instances of Tag from ANode's children in the Items collection.

var
  Counter : integer;

begin
  If Assigned(ANode) then
    for Counter := 0 to ANode.ChildCount - 1 do
      begin
        If (Tag = '') or (Tag = '*') or (CompareText(ANode[Counter].Caption,Tag) = 0) then
          Items.Add(ANode[Counter]);

        _GetTags(ANode[Counter],Tag,Items);

      end;

end;

procedure TTagNode.GetTags(const Tag: string; Items: TTagNodeList);

// Wrapper for _GetTags recursive call

begin
  If Assigned(Items) then
    begin
      Items.Clear;
      _GetTags(Self,Tag,Items);
    end;

end;

procedure TTagNode._GetTagsByType(ANode: TTagNode; const Tag: string; Items: TTagNodeList; NodeTypes: TNodeTypes);

// Return all instances of Tag from ANode's children in the Items collection.

var
  Counter : integer;

begin
  If Assigned(ANode) then
    for Counter := 0 to ANode.ChildCount - 1 do
      begin
        If (ANode[Counter].NodeType in NodeTypes) and
          ((Tag = '') or (Tag = '*') or (CompareText(ANode[Counter].Caption,Tag) = 0)) then
            Items.Add(ANode[Counter]);

        _GetTagsByType(ANode[Counter],Tag,Items,NodeTypes);

      end;

end;

procedure TTagNode.GetTagsByType(const Tag: string; Items: TTagNodeList; NodeTypes: TNodeTypes);

// Wrapper for _GetTags recursive call

begin
  If Assigned(Items) then
    begin
      Items.Clear;
      _GetTagsByType(Self,Tag,Items,NodeTypes);
    end;

end;

function TTagNode.Find(const Tag: string): integer;

begin
  for Result := 0 to ChildCount - 1 do
    If CompareText(Children[Result].Caption,Tag) = 0 then
      Break;

  Result := -1;

end;

function TTagNode.GetPedigree: string;

var
  TempNode : TTagNode;

begin
  Result := Caption;
  TempNode := Self;

  while TempNode.Parent <> nil do
    begin
      TempNode := TempNode.Parent;
      Result := TempNode.Caption + '/' + Result;
    end;

end;

procedure TTagNode._GetTagsByParam(ANode: TTagNode; const Tag: string; Items: TTagNodeList; const ParamName, ParamValue : string);

// Return all instances of Tag from ANode's children in the Items collection.

var
  Counter : integer;

begin
  If Assigned(ANode) then
    for Counter := 0 to ANode.ChildCount - 1 do
      begin
        If ((Tag = '') or (Tag = '*') or (CompareText(ANode[Counter].Caption,Tag) = 0)) then
          If CompareText(ANode[Counter].Params.Values[ParamName],ParamValue) = 0 then
            Items.Add(ANode[Counter]);

        _GetTagsByParam(ANode[Counter],Tag,Items,ParamName,ParamValue);

      end;

end;

procedure TTagNode.GetTagsByParam(const Tag: string; Items: TTagNodeList;
  const ParamName, ParamValue: string);
begin
  If Assigned(Items) then
    begin
      Items.Clear;
      _GetTagsByParam(Self,Tag,Items,ParamName,ParamValue);
    end;

end;

// ----------------------------------------------------------------------------

{ TTagNodeList }

constructor TTagNodeList.Create;

begin
  Inherited Create;

  FItems := TList.Create;

end;

destructor TTagNodeList.Destroy;

begin
  FItems.Free;

  Inherited;

end;

procedure TTagNodeList.Clear;

var
  Counter : integer;

begin
  for Counter := FItems.Count - 1 downto 0 do
    Delete(Counter);

end;

function TTagNodeList.GetItem(const Index : integer) : TTagNode;

begin
  If (Index >= 0) and (Index < FItems.Count) then
    Result := TTagNode(FItems[Index])
  else
    Result := nil;

end;

function TTagNodeList.GetString(const Index : integer) : string;

begin
  If (Index >= 0) and (Index < FItems.Count) then
    Result :=  Items[Index].Caption
  else
    Result := '';

end;

procedure TTagNodeList.SetString(const Index : integer; Value : string);

begin
  If (Index >= 0) and (Index < FItems.Count) then
    Items[Index].Caption := Value;

end;

function TTagNodeList.GetCount : integer;

begin
  Result := FItems.Count;

end;

function TTagNodeList.Add(Item : TTagNode) : integer;

begin
  Result := FItems.Add(Item);

end;

procedure TTagNodeList.Delete(Index : integer);

begin
  If (Index >= 0) and (Index < FItems.Count) then
    begin
//      Items[Index].Free;
      FItems.Delete(Index);
    end;

end;

procedure TTagNodeList.SortList(L, R: Integer);

var
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
        until CompareText(Strings[I],Strings[R]) >= 0;

        repeat
          Dec(J);
        until (CompareText(Strings[J],Strings[R]) <= 0) or (J = 0);

        if J <= I then
          Break;

        FItems.Exchange(I,J);

      until False;

      FItems.Exchange(I,R);

      SortList(L,I - 1);
      SortList(I + 1,R);

    end;

end;

procedure TTagNodeList.Sort;

// Wrapper for internal SortList routine

begin
  SortList(0,FItems.Count - 1);

end;

procedure TTagNodeList.Insert(Index: integer; Item: TTagNode);
begin
  FItems.Insert(Index,Item);

end;

function TTagNodeList.IndexOf(Item: TTagNode): integer;

// Return Index of Item in the FItems list

begin
  Result := FItems.IndexOf(Item);

end;

function TTagNodeList.Occurence(Node: TTagNode): integer;

// Return the count of Node.Caption (also know as Tag name) upto and including
//  this one.  Note that the occurence is 0 based (1st occurence is 0)

var
  Counter : integer;

begin
  Result := -1;

  for Counter := 0 to FItems.Count - 1 do
    If CompareText(Node.Caption,Items[Counter].Caption) = 0 then
      begin
        Inc(Result);

        If Items[Counter] = Node then
          Break;

      end;

end;

function TTagNodeList.GetTagCount(const Tag : string) : integer;

// Return # of occurences of Tag

var
  Counter : integer;

begin
  Result := 0;

  for Counter := 0 to FItems.Count - 1 do
    If CompareText(Items[Counter].Caption,Tag) = 0 then
      Inc(Result);

end;

function TTagNodeList.FindTagByIndex(const Tag : string; const Index : integer) : TTagNode;

// Locate the Index'th occurence of the specified Tag (0 indexed)

var
  Num,
  Counter : integer;

begin
  Result := nil;
  Num := 0;

  for Counter := 0 to FItems.Count - 1 do
    If CompareText(Items[Counter].Caption,Tag) = 0 then
      If Num = Index then
        begin
          Result := Items[Counter];
          Break;
        end
      else
        Inc(Num);

end;

// ----------------------------------------------------------------------------

{ THTMLParser }

constructor THTMLParser.Create(AOwner: TComponent);
begin
  Inherited;

  FTree := TTagNode.Create;

end;

destructor THTMLParser.Destroy;
begin
  FTree.Free;

  Inherited;

end;

function THTMLParser.IsBlockElement(const TagName : string) : boolean;

// Return true if TagName is a block element (per HTML 4.0 spec)

begin
  If Pos('|' + TagName + '|',ceBlock) > 0 then
    Result := True
  else
    Result := False;

end;

function THTMLParser.IsAmbiguous(const TagName : string) : boolean;

// Return true if TagName is a ambiguous (like <p> or <li>)

begin
  If Pos('|' + TagName + '|',ceAmbiguous) > 0 then
    Result := True
  else
    Result := False;

end;

function THTMLParser.IsEmptyElement(const TagName : string) : boolean;

// Return true if TagName is an empty element (like <br> and <hr>)

begin
  If Pos('|' + TagName + '|',ceEmptyElements) > 0 then
    Result := True
  else
    Result := False;

end;

function THTMLParser.BuildPCData(const Data : string) : TTagNode;

// Construct node from PCData

begin
  Result := TTagNode.Create;
  Result.Caption := cePCData;
  Result.Text := Data;
  Result.NodeType := ntePCData;

end;

function THTMLParser.BuildComment(const Data : string) : TTagNode;

// Construct node from comment

var
  TempStr : string;

begin
  Result := TTagNode.Create;
  Result.NodeType := nteComment;
  TempStr := Trim(Data);

  If Copy(TempStr,1,2) = '--' then
    begin
      Result.Caption := '!';
      Delete(TempStr,1,2);

      If Copy(TempStr,Length(TempStr) - 1,2) = '--' then
        Delete(TempStr,Length(TempStr) - 1,2);

      Result.Text := Trim(TempStr);

    end;

end;

function THTMLParser.BuildDTDItem(const Data : string) : TTagNode;

// Construct node from 'DTD' tag starting with ! such as !DOCTYPE

var
  Index : integer;
  TempStr : string;

begin
  Result := TTagNode.Create;

  TempStr := Trim(Data);

  If TempStr <> '' then
    If Copy(TempStr,1,6) = '[CDATA' then
      begin
        Result.NodeType := nteCData;
        Result.Caption := 'CDATA';

        Delete(TempStr,1,6);                     // Remove '[CDATA'
        Delete(TempStr,Length(TempStr) - 1,2);   // Remove ']>'

        TempStr := Trim(TempStr);                // Scrape off any whitespace

        If TempStr <> '' then
          Result.Text := Copy(TempStr,2,Length(TempStr) - 1);

      end
    else
      begin
        Result.NodeType := nteDTDItem;

        Index := Pos(' ',TempStr);

        If Index > 0 then
          begin
            Result.Caption := '!' + Copy(TempStr,1,Index - 1);
            Result.Text := Copy(TempStr,Index + 1,Length(TempStr));
          end
        else
          begin
            Result.Caption := '!' + TempStr;
          end;

      end;

end;

procedure THTMLParser.Parse(const Text : string);

// Parse out Text into individual containers within Tree

const
  cNone = 0;
  cStarting = 1;
  cReading = 2;
  cEnding = 3;
  cCommenting = 4;
  cDTD = 5;
  cDTDComment = 6;
  cDTDBracket = 7;

var
  CurrentTags : TStack;
  BuffStart,
  BuffLen,
  TextLen,
  LineNum,
  CharPos,
  State,
  Index : integer;
  LastTag,
  TagName,
  Data : string;
  NewNode : TTagNode;
  Done : boolean;
  LastCh : char;

// -=-=-=-=-=-

procedure AddNode(Node : TTagNode);

// Add child node to last element in tree

begin
  If CurrentTags.Count <= 0 then
    Tree.AddChild(Node)
  else
    CurrentTags.LastNode.AddChild(Node);

end;

function NextText(const Count : integer) : string;

// Return next Count chars from Text

begin
  Result := Copy(Text,Index + 1,Count);

end;

procedure StartBuffer;

begin
  BuffStart := Index + 1;
  BuffLen := 0;
end;

function GetBuffer : string;

begin
  Result := Copy(Text,BuffStart,BuffLen);
  BuffStart := Index + 1;
  BuffLen := 0;
end;

// -=-=-=-=-=-

begin
  If Parsing then                      // Make sure we don't re-enter
    Exit
  else
    Parsing := True;

  Clear;
  CurrentTags := TStack.Create;

  LastCh := #0;
  Index := 1;
  State := cNone;
  LineNum := 1;
  CharPos := 1;
  TextLen := Length(Text);
  BuffStart := 1;
  BuffLen := 0;

  while Index < TextLen do
    begin
      case Text[Index] of
        '!' : If (State = cStarting) and (LastCh = '<') then    // If we just started a tag...
                If NextText(2) = '--' then                      // If it's a comment...
                  begin
                    State := cCommenting;                       // We're starting a comment
                    StartBuffer;
                  end
                else
                  begin                                         //  otherwise...
                    State := cDTD;                              // Must be a DTD item of some sort (like DOCTYPE)
                    StartBuffer;
                  end
              else                                              //  otherwise...
                Inc(BuffLen);                                   // It's just a bang (!)

        '-' : begin                                             // This is here to handle comments
                If State = cDTD then                            //  within DTD's
                  begin
                    If (LastCh in [' ',#13,#10,#9]) and (NextText(1) = '-') then    // Start comment
                      State := cDTDComment;

                  end
                else
                  If State = cDTDComment then                                       // End comment
                    If NextText(1) = '-' then
                      State := cDTD;

                Inc(BuffLen);

              end;

        '/' : If State = cStarting then                         // If we think we're in a start tag...
                If LastCh = '<' then                            // If we really just started an end tag...
                  begin
                    State := cEnding;                           // We're done now...has to be an end tag
                    StartBuffer;
                  end
                else
                  If NextText(1) = '>' then                     // If this is an XML empty element...
                    begin end                                   // Just eat the slash (/),
                  else
                    Inc(BuffLen)                                // It's just a slash (/)

              else                                              // otherwise...
                Inc(BuffLen);                                   // It's just a slash (/)

        '<' :
          begin
            case State of
              cCommenting, cDTDComment, cDTDBracket :
                begin
                  Inc(BuffLen);

                end;

              cStarting :
                begin
                  DoSyntaxWarning('Unexpected "<" encountered [Row:' + IntToStr(LineNum) +
                    ',Col:' + IntToStr(CharPos) + ']');

                end;

              else
                begin
                  If BuffLen > 0 then
                    begin
                      NewNode := BuildPCData(GetBuffer);
                      AddNode(NewNode);
                    end
                  else
                    BuffStart := Index + 1;

                  State := cStarting;

                end;

            end;  {  Case  }

          end;

        '>' :
          begin
            case State of
              cStarting :
                begin
                  NewNode := TTagNode.Create;
                  NewNode.NodeType := nteElement;

                  NewNode.Caption := ParameterizeTag(GetBuffer,NewNode.Params);

                  TagName := LowerCase(NewNode.Caption);
                  LastTag := CurrentTags.LastTag;

// Ack! Here we go with the weird heuristics for ambiguous elements:
//
//  1) If the current tag = the last tag, then we terminate the last tag
//  2) If the current tag is a block element and last tag was <p>, terminate the last tag

                  If ((TagName = LastTag) and IsAmbiguous(LastTag)) or
                     ((LastTag = 'p') and (IsBlockElement(TagName))) then
                      CurrentTags.Pop;

// Add current tag to hierarchy...at root if no container available yet

                  AddNode(NewNode);

// If current tag is a container, add it to the stack

                  If not IsEmptyElement(TagName) and (LastCh <> '/') then
                    CurrentTags.AddObject(TagName,NewNode)
                  else
                    begin
                      NewNode.IsEmptyElement := True;
                      DoHTMLTag(NewNode);
                    end;

                  State := cNone;

                end;

              cEnding :
                begin

// Pop the stack.  It's possible that ambiguous tags like <p> have contaminated
// the stack so we have to backtrack to make sure we clean'em all out.  Note that
// if an end tag doesn't cause closure, it's just ignored (stack isn't affected).

                  TagName := LowerCase(GetBuffer);

                  If CurrentTags.ContainsTag(TagName) then
                    begin
                      Done := False;

                      while not Done do
                        begin
                          If (CurrentTags.LastTag = TagName) or (CurrentTags.Count <= 1) then
                            Done := True;

                          If CurrentTags.Count > 0 then
                            DoHTMLTag(CurrentTags.LastNode);

                          CurrentTags.Pop;

                        end;

                    end
                  else
                    DoSyntaxWarning('End tag found without matching start tag: ' + Data + ' [Row:' + IntToStr(LineNum) +
                    ',Col:' + IntToStr(CharPos) + ']');

                  State := cNone;

                end;

              cCommenting :
                begin
                  Data := Copy(Text,BuffStart,BuffLen);    // Peek at the buffer

// If we find --> (or -- >), then terminate comment...otherwise keep on parsing

                  If Copy(Data,Length(TrimRight(Data)) - 1,2) = '--' then
                    begin
                      NewNode := BuildComment(GetBuffer);
                      AddNode(NewNode);
                      State := cNone;
                    end
                  else
                    Inc(BuffLen);

                end;

              cDTD :
                begin
                  NewNode := BuildDTDItem(GetBuffer);
                  AddNode(NewNode);
                  State := cNone;
                end;

              cDTDBracket :
                begin
                  Inc(BuffLen);
                end;

              else
                begin
                  DoSyntaxWarning('Unexpected ">" encountered [Row:' + IntToStr(LineNum) +
                    ',Col:' + IntToStr(CharPos) + ']');

                end;

            end;  {  Case  }

          end;

        '?' : If (State = cStarting) and (LastCh = '<') then    // If we just started a tag...
                begin
                  State := cDTD;                                // Must be a DTD item of some sort (like DOCTYPE)
                  StartBuffer;
                end
              else                                              //  otherwise...
                Inc(BuffLen);                                   // It's just a question mark (?)

         '[' : begin                                       // See if we're starting XML DTD stuff...
                 If State = cDTD then
                   State := cDTDBracket;

                 Inc(BuffLen);

               end;

         ']' : begin
                 If State = cDTDBracket then
                   If NextText(1) = '>' then
                     State := cDTD;

                 Inc(BuffLen);

               end;

        else
          begin
            Inc(BuffLen);
          end;

      end;  {  Case  }

      LastCh := Text[Index];
      Inc(Index);

      If (LastCh = #10) or (CharPos > 256) then             // Track position in text for debugging
        begin
          Inc(LineNum);
          CharPos := 1;
        end
      else
        Inc(CharPos);

    end;

  CurrentTags.Free;
  Parsing := False;

end;

procedure THTMLParser.Clear;

// Dispose of the contents of the Tree and Items collections

begin
  Tree.Clear;

end;

procedure THTMLParser.DoHTMLTag(ANode: TTagNode);
begin
  If Assigned(FOnHTMLTag) then
    FOnHTMLTag(Self,ANode);

end;

procedure THTMLParser.DoSyntaxWarning(const Text: string);

begin
  If Assigned(FOnSyntaxWarning) then
    FOnSyntaxWarning(Self,Text);

end;

{ TStack } // -----------------------------------------------------------------

function TStack.ContainsTag(const Tag: string): boolean;

// Returns true if stack contains an instance of Tag

var
  Counter : integer;
  TempStr : string;

begin
  Result := False;
  TempStr := LowerCase(Tag);

  for Counter := Count - 1 downto 0 do      // Run the search backwards assuming
    If TempStr = Strings[Counter] then      //  that Tag is expected to be nearer
      begin                                 //  to the top of the stack.
        Result := True;
        Break;
      end;

end;

function TStack.GetLastNode: TTagNode;

// Return node associated with last tag on the stack

begin
  If Count > 0 then
    Result := TTagNode(Objects[Count - 1])
  else
    Result := nil;

end;

function TStack.GetLastTag: string;

// Returns last tag from stack (don't pop)

begin
  If Count > 0 then
    Result := Strings[Count - 1]
  else
    Result := '';

end;

function TStack.Pop: string;

// Pop last entry from stack - return name of item popped from stack

begin
  If Count > 0 then
    begin
      Result := Strings[Count - 1];
      Delete(Count - 1);
    end
  else
    Result := '';

end;

end.
