unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, HTMLParser, HTMLMisc, Misc;

type
  TForm2 = class(TForm)
    HTMLParser1: THTMLParser;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    procedure HTMLParser1HTMLTag(Sender: TObject; ANode: TTagNode);
    procedure FormShow(Sender: TObject);

  private
    procedure DisplayTags(Tags : TTagNode);
    procedure DisplayHEaders(Tags : TTagNode);

  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.HTMLParser1HTMLTag(Sender: TObject; ANode: TTagNode);
var S : String;
begin
  {S := ANOde.Caption;
//  Memo1.Lines.Add(ANode.Caption);

  If ANode.NodeType = nteElement then
    If CompareText(ANode.Caption,'a') = 0 then
      S := S + ANode.Params.Values['href'];
  Memo1.Lines.Add(S);}
end;


procedure TForm2.DisplayTags(Tags : TTagNode);

var

  Counter : integer;

// ----------------

procedure AddTags(Spaces : String; Tag : TTagNode);

var
  Counter : integer;
  SS : String;

begin


  If (Tag.NodeType = ntePCData) and (Trim(Tag.Text) = '') then
    Exit;

// Add tags
  SS := Spaces+Tag.Caption+' '+Tag.Text;
  for Counter := 0 to Tag.Params.Count - 1 do
    SS := SS + ' '+Tag.Params.Strings[Counter];

  Memo1.Lines.Add(SS);



  for Counter := 0 to Tag.ChildCount - 1 do
    AddTags(Spaces+' ',Tag.Children[Counter]);

end;

begin
// Fill in TreeView



  Memo1.Lines.Add('Document');

  for Counter := 0 to Tags.ChildCount - 1 do
    AddTags('',Tags.Children[Counter]);



end;


procedure TForm2.DisplayHEaders(Tags : TTagNode);

var

  Counter : integer;

// ----------------

procedure AddTags( Tag : TTagNode; var Str : String);

var
  Counter : integer;
  SS : STring;

begin
  SS := Str;

  If (Tag.NodeType = ntePCData) then begin
    if Trim(Tag.Text) = '' then begin
      exit
    end else
      SS := SS + Tag.Text;
  end;

  if Pos(LowerCase(Tag.Caption),ceHeaders) >0 then begin
//    SS := '';
//    for Counter := 0 to Tag.ChildCount - 1 do
//      AddTags(Tag.Children[Counter], SS);
    Memo1.Lines.Add(Tag.Caption+' '+Trim(HTMLDecode(RemoveCRLFs(Tag.GetPCData))))

  end else
    If Tag.NodeType = nteElement then begin
      If CompareText(Tag.Caption,'a') = 0 then
        Memo1.Lines.Add(Tag.Params.Values['href']+'='+Trim(HTMLDecode(RemoveCRLFs(Tag.GetPCData))))
  end;
    for Counter := 0 to Tag.ChildCount - 1 do
      AddTags(Tag.Children[Counter], SS);
  Str := SS;
end;
var SS : String;

begin
// Fill in TreeView



  Memo1.Lines.Add('Document');

  for Counter := 0 to Tags.ChildCount - 1 do
    AddTags(Tags.Children[Counter], SS);



end;


procedure TForm2.FormShow(Sender: TObject);
var
  HTML : TStringList;
  SS : String;

begin
  SS := '';
  HTML := TStringList.Create;
  if OpenDialog1.Execute then
    HTML.LoadFromFile(OpenDialog1.Filename)
  else
    exit;

  HTMLParser1.Parse(HTML.Text);

  HTML.Free;
  DisplayHeaders(HTMLParser1.Tree);
end;



end.
