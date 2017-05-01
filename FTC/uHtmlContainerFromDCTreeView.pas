unit uHtmlContainerFromDCTreeView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    IHTML4, URLTreeViewFiller, comctrls, extctrls, dcdtree, uDaUrlLink, stringfns, Misc;

type
  THtmlContainerFromDCTreeView = class(THtmlContainer)
  private
    FJSStrings : TStrings;
    FFileName : String;
    SS : TStrings;
    mainList : THtmlLIst;
    Lists : Array[0..10] of THtmlContainer;
  protected
    procedure CreateLink(UrlLInk : TDaURLLink; Level : Integer);
    procedure CreateHeader(Node : TTreeNode; Level : integer);
    procedure AddHr;
    procedure AddOpenNodes(FTreeView : TDCMSTreeView);
  public
    procedure ReadAndFill(FTreeView : TDCMSTreeView; ParNode : TTreeNode = nil);

    constructor Create;
    property JSStrings : TStrings read FJSStrings write FJSSTrings;

  published
    property FileName : String read FFileName write FFIleName;
  end;


implementation

function Spaces(n : integer) : String;
var i : integer;
begin
  SetLength(result,n);
  for i := 1 to n do
    result[i]:= ' ';
end; { Spaces }



procedure THtmlContainerFromDCTreeView.ReadAndFill(FTreeView : TDCMSTreeView; ParNode : TTreeNode = nil);
var  CurrUrlLink : TDAUrlLink;

  procedure ParseSubTree(Node : TTreeNode; Level : integer); forward;

  procedure ParseNode(Node : TTreeNode; Level : Integer);
  begin
    if Node.HasChildren then
      CreateHeader(Node,Level)
    else if Node.Data <> nil then begin
      CurrUrlLink := TDAUrlLink(Node.Data);
      CreateLink(CurrUrlLink,Level)
    end;
    ParseSubTree(Node,Level+1);
  end;


  procedure ParseSubTree(Node : TTreeNode; Level : integer);
  var i : integer;
    CurrNode : TTreeNode;

  begin
    for i := 0 to Node.Count-1 do begin
      CurrNode := Node.Item[i];
      ParseNode(CurrNode,Level);

    end;
    if Node.Count > 0 then
      AddHr;
  end;

var i : integer;
  CNode : TTreeNode;


begin
  Clear;
  FJSStrings.Clear;
  if Assigned(FtreeView) and (FTreeView.Items.Count > 0) then begin
    //CreateHeader(FFileName,0);
    for i := 0 to FTreeView.Items.Count-1 do begin
      CNode := FTreeView.Items[i];
      if CNode.Parent = ParNode then begin
         ParseNode(CNode,1)
      end
    end

  end;
  SS.Text := AsHTML;
  if FileName <> '' then
    SS.SaveToFile(FileName);
  AddOpenNodes(FTreeView);
end;

procedure THtmlContainerFromDCTreeView.AddOpenNodes(FTreeView : TDCMSTreeView);
var Node : TTreeNode;
    i : integer;
begin
  JSStrings.Add('initializeDocument()');
  for i := 1 to FTreeView.Items.Count-1 do begin
    Node := FTreeView.Items[i];
    if Node.Expanded then
      JSStrings.Add('clickOnNode('+IntToStr(i)+')');
  end
end;

constructor THtmlContainerFromDCTreeView.Create;
var i : integer;
begin
  inherited;
  for i := 0 to 10 do
    Lists[i] := self;
  mainList := THtmlList.Create(ltGlossary);
  SS := TStringList.Create;
  FJSStrings := TStringList.Create;
end;


procedure THtmlContainerFromDCTreeView.AddHr;
begin
  //Add(Lists[Level]);
  //Dec(Level);
  //Add(THTMLHorizRule.Create);
end;

function RemoveHttp(S : String) : String;
var P : Integer;
    RS : String;
begin
  P := Pos('http://',S);
  if P > 0 then
    RS := Copy(S,P+7,Length(S)-P-6)
  else
    RS := S;
  result := RS
end;


procedure THtmlContainerFromDCTreeView.CreateLink(UrlLInk : TDaURLLink; Level : Integer);
var VarParString, VarString : String;
  OutString, UrlLinkURL : String;
  cs : THtmlContainer;
begin
  if ((POs('http',UrlLink.Url) > 0) or (POs('www',UrlLink.Url) > 0) or (POs('web',UrlLink.Url) > 0)) and (urlLink.LocationType = Local) then begin
    urlLink.LocationType := ToBrowser;
  end;
  VarParString :=  'aux'+IntToStr(level-2);
  VarString :='aux'+IntToStr(level-1);
  if Level <= 2 then
      VarParString := 'foldersTree';
  UrlLinkUrl := RemoveCRLFs(URLLINK.Url);
  UrlLinkUrl := Trim(URLLINKUrl);
  UrlLinkUrl := ReplaceStr(URLLINKUrl,'\','/');
  UrlLinkUrl := RemoveHttp(URLLINKUrl);

  OutString :=Spaces(level*3)+'insDoc('+VarParString+',gLnk('+IntToStr(Ord(URLLINK.locationtype))+',"'+URLLINK.Title+'","'+URLLINKUrl+'"))';
  FJSSTrings.Add(OutString);

  if (UrlLink <> nil) and (UrlLink.URL <> '') and (UrlLink.Title <> '') then begin
    cs := THTMLListItem.Create(liTerm,'');

    cs.Add(THTMLAnchor.Create(UrlLink.URL, UrlLink.Title));
    cs.Add(THTMLParagraph.Create(UrlLink.Description));
    Lists[Level-1].add(CS);
  end;
end;

procedure THtmlContainerFromDCTreeView.CreateHeader(Node : TTreeNode; Level : integer);
var VarParString, VarString, S, LString : String;
  OutString : String;
  UrlLink : TDaUrlLink;
begin

  S := NOde.TExt;
  if Node.Data <> nil then begin
    UrlLink := TDaUrlLink(Node.Data);
    if (POs('http',UrlLink.Url) > 0) or (POs('www',UrlLink.Url) > 0) or (POs('web',UrlLink.Url) > 0) and (urlLink.LocationType = Local) then begin
       urlLink.LocationType := ToBrowser;
  end;

    try
      LString := RemoveHttp(ReplaceStr(Trim(RemoveCRLFs(UrlLink.URL)),'\','/'));
    except on Exception do
      LString := ''
    end;
  end else
    LString := '';
  VarParString :=  'aux'+IntToStr(level-2);
  VarString :='aux'+IntToStr(level-1);
  if Level = 1 then begin
    VarString := 'foldersTree';
    OutString := 'foldersTree = gFld("'+S+'","'+FFileName+'")'
  end else begin
    if Level = 2 then begin
      VarParString := 'foldersTree';
      VarString := 'aux1'
    end;
    OutString :=Spaces(level*3)+VarString+' = insFld('+VarParString+', gFld("'+S+'","'+LString+'"))';
  end;
  FJSSTrings.Add(OutString);
  if LString <> '' then
    S := THtmlAnchor.Create(LString,S).AsHTML;

  if Level = 1 then begin
    Lists[Level] := THTMLList.Create(ltGlossary);
    Add(THTMLHeading.Create(Level, S));
    Add(Lists[Level]);
    if UrlLink <> nil then
      Add(THTMLParagraph.Create(UrlLink.Description));

  end else begin
    Lists[Level] := THTMLList.Create(ltGlossary);
    Lists[Level-1].Add(THTMLHeading.Create(Level, S));
    Lists[Level-1].Add(Lists[Level]);
    if UrlLink <> nil then
      Lists[Level-1].Add(THTMLParagraph.Create(UrlLink.Description));
  end;

end;

end.
