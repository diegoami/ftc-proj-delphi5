unit Main;

{ ----------------------------------------------------------------------------

  01/27/00  RP  - Added TableForm back in to support display of Table contents
                - Removed GetTagsForm...display in local TMemo
  03/04/00  RP  - Better Column Count checking in DisplayTable              

  ---------------------------------------------------------------------------- }


interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, HTMLMisc, Misc, HTMLParser, ExtCtrls,
  GetURL, Menus, TableForm, StringTable, HTMLParserSupt;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    ImageList1: TImageList;
    HTMLParser1: THTMLParser;
    Panel1: TPanel;
    pbURL: TButton;
    Panel2: TPanel;
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    Edit1: TEdit;
    GetURL1: TWIGetURL;
    pbHTML: TButton;
    pbGetTags: TButton;
    Edit2: TEdit;
    pbGetLinks: TButton;
    pumTreeView: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    Tag1: TMenuItem;
    Text1: TMenuItem;
    Comment1: TMenuItem;
    pbFile: TButton;
    SaveDialog1: TSaveDialog;
    Panel7: TPanel;
    Label4: TLabel;
    Memo1: TMemo;
    Splitter3: TSplitter;
    Panel6: TPanel;
    Label2: TLabel;
    ListView1: TListView;
    ExpandAll1: TMenuItem;
    DisplayTable1: TMenuItem;
    procedure pbURLClick(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure pbHTMLClick(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GetURL1Status(Sender: TObject; Status: Integer;
      StatusInformation: Pointer; StatusInformationLength: Integer);
    procedure pbGetTagsClick(Sender: TObject);
    procedure pbGetLinksClick(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure pbFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HTMLParser1SyntaxWarning(Sender: TObject; Text: String);
    procedure ExpandAll1Click(Sender: TObject);
    procedure pumTreeViewPopup(Sender: TObject);
    procedure DisplayTable1Click(Sender: TObject);
  private
    _Nodes : TTagNodeList;
    SyntaxErrors : TStrings;

    procedure DisplayTags(Tags : TTagNode);
    procedure DisplayTag(Node: TTagNode);
    procedure FetchURL(URL: string);
    procedure DisplayTable(Table : TStringTable);
    procedure DisplayTableNode(Node: TTagNode);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.pbURLClick(Sender: TObject);

// Load up, parse and display HTML file

begin
  FetchURL(Edit1.Text);

end;

procedure TForm1.FetchURL(URL : string);
// Retrieve URL, parse and display

begin
  Screen.Cursor := crHourglass;
  Application.ProcessMessages;

  GetURL1.URL := URL;
  SyntaxErrors.Clear;

  If GetURL1.GetURL = wiSuccess then
    begin
      StatusBar1.Panels[0].Text := 'Parsing';
      Application.ProcessMessages;

      HTMLParser1.Parse(GetURL1.Text);

      HTMLParser1.Tree.GetTags('*',_Nodes);
      DisplayTags(HTMLParser1.Tree);

      If SyntaxErrors.Count > 0 then
        Memo1.Lines.Assign(SyntaxErrors);

    end
  else
    ShowMessage('Unable to display URL');

  StatusBar1.Panels[0].Text := '';
  Screen.Cursor := crDefault;

end;

procedure TForm1.DisplayTags(Tags : TTagNode);

// Place the tags from the HTMLParser's tree into a treeview

var
  RootNode : TTreeNode;
  Counter : integer;

// ----------------

procedure AddTags(Node : TTreeNode; Tag : TTagNode);

var
  Counter : integer;
  NewNode : TTreeNode;

begin
  If (Tag.NodeType = ntePCData) and (Trim(Tag.Text) = '') then
    Exit;

// Add tags

  If Node = nil then
    NewNode := TreeView1.Items.Add(nil,Tag.Caption)
  else
    NewNode := TreeView1.Items.AddChild(Node,Tag.Caption);

  NewNode.Data := Tag;

  case Tag.NodeType of
    ntePCData : NewNode.ImageIndex := 4;
    nteNone,
    nteComment,
    nteDTDItem : NewNode.ImageIndex := 1;
    else
      begin
        If CompareText(NewNode.Text,'table') = 0 then
          NewNode.ImageIndex := 2
        else
          If CompareText(NewNode.Text,'form') = 0 then
            NewNode.ImageIndex := 3
          else
            NewNode.ImageIndex := 5;

      end;

  end;  {  Case }

  NewNode.SelectedIndex := NewNode.ImageIndex;

  for Counter := 0 to Tag.ChildCount - 1 do
    AddTags(NewNode,Tag.Children[Counter]);

end;

// ----------------

begin
// Fill in TreeView

  TreeView1.Items.BeginUpdate;
  Application.ProcessMessages;

  TreeView1.Items.Clear;

  RootNode := TreeView1.Items.Add(nil,'Document');
  RootNode.ImageIndex := 0;
  RootNode.SelectedIndex := 0;
  RootNode.Data := Tags;

  for Counter := 0 to Tags.ChildCount - 1 do
    AddTags(RootNode,Tags.Children[Counter]);

  TreeView1.Items.EndUpdate;

  Application.ProcessMessages;

  RootNode.Expand(False);
  TreeView1.TopItem := RootNode;

end;

procedure TForm1.TreeView1Click(Sender: TObject);

begin
  If TreeView1.Selected <> nil then
    If Assigned(TreeView1.Selected.Data) then
      DisplayTag(TTagNode(TreeView1.Selected.Data));

end;

procedure TForm1.DisplayTag(Node : TTagNode);

// Display the Parameters and/or Text for a Tag

var
  NewItem : TListItem;
  _Index,
  Counter : integer;
  TempStr : string;

begin
  ListView1.Items.BeginUpdate;
  ListView1.Items.Clear;
  Memo1.Clear;

// Display text

  If Node.NodeType = nteElement then
    try
      TempStr := HTMLDecode(Node.GetPCData);
      Memo1.Lines.Text := TempStr;
    except
      Memo1.Lines.Text := '<text to large to display>';
    end

  else
    Memo1.Lines.Text := Node.Text;

// Display params

  with Node do
    for Counter := 0 to Params.Count - 1 do
      begin
        NewItem := ListView1.Items.Add;

        TempStr := Params[Counter];
        _Index := Pos('=',TempStr);

        If _Index > 0 then
          begin
            NewItem.Caption := Copy(TempStr,1,_Index - 1);
            NewItem.SubItems.Add(Copy(TempStr,_Index + 1,Length(TempStr)));
          end
        else
          NewItem.Caption := TempStr;

      end;

  ListView1.Items.EndUpdate;

// Display location info

  _Index := _Nodes.Occurence(Node);
  StatusBar1.Panels[0].Text := 'Index: ' + IntToStr(_Index);

end;

procedure TForm1.pbHTMLClick(Sender: TObject);

// Render the contents of the HTMLParser's tree out to an HTML file

var
  OutFile : textfile;

begin
  If SaveDialog1.Execute then
    begin
      AssignFile(OutFile,SaveDialog1.Filename);
      ReWrite(OutFile);
      Write(OutFile,HTMLParser1.Tree.Render);
      CloseFile(OutFile);
    end;  

end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    vk_Return :
      begin
        FetchURL(Edit1.Text);
      end;

    else
      Inherited;

  end;

end;

procedure TForm1.GetURL1Status(Sender: TObject; Status: Integer;
  StatusInformation: Pointer; StatusInformationLength: Integer);

// Display the status messages provided from the HTTP process

begin
  StatusBar1.Panels.Items[0].Text := GetURL1.GetStatusCodeText(Status);
  Application.ProcessMessages;

end;

procedure TForm1.pbGetTagsClick(Sender: TObject);

var
  Nodes : TTagNodeList;
  Counter : integer;

begin
  If TreeView1.Selected <> nil then
    If Edit2.Text <> '' then
      begin
        Memo1.Clear;

        Nodes := TTagNodeList.Create;
        TTagNode(TreeView1.Selected.Data).GetTags(Edit2.Text,Nodes);

        for Counter := 0 to Nodes.Count - 1 do
          Memo1.Lines.Add(ConvertParamsToTag(Nodes[Counter].Caption,Nodes[Counter].Params));

        Nodes.Free;

      end
    else
      begin
        MessageBeep(mb_IconAsterisk);
        ShowMessage('No tag entered');
      end

  else
    begin
      MessageBeep(mb_IconAsterisk);
      ShowMessage('No tag selected');
    end;

end;

procedure TForm1.pbGetLinksClick(Sender: TObject);

// Return a list of links (<a href=""> tags)

var
  Counter : integer;
  Href,
  Description : string;
  Node : TTagNode;
  Links : TTagNodeList;

begin
  If TreeView1.Selected <> nil then
    begin
      Links := TTagNodeList.Create;
      TTagNode(TreeView1.Selected.Data).GetTags('a',Links);

      Memo1.Clear;

      for Counter := 0 to Links.Count - 1 do
        begin
          Node := Links[Counter];

          If Assigned(Node) then
            begin
              Href := Node.Params.Values['href'];

              If Href <> '' then
                begin
                  Description := Trim(HTMLDecode(RemoveCRLFs(Node.GetPCData)));

                  If Description <> '' then
                    Memo1.Lines.Add(Description  + ' => ' + Href);

                end;

            end;

        end;

      Links.Free;

    end
  else
    begin
      MessageBeep(mb_IconAsterisk);
      ShowMessage('No tag selected');
    end;

end;

procedure TForm1.Delete1Click(Sender: TObject);

// Delete item from Parser's tree and the TreeView

begin
  with TreeView1 do
    If Selected <> nil then
      If MessageDlg('Delete ' + Selected.Text + '?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
        begin
          TTagNode(Selected.Data).Free;
          Selected.Delete;
        end;

end;

procedure TForm1.pbFileClick(Sender: TObject);

// Load up, parse and display HTML file

var
  Stuff : TStrings;

begin
  If OpenDialog1.Execute then
    begin
      Stuff := TStringList.Create;

      Stuff.LoadFromFile(OpenDialog1.Filename);
      HTMLParser1.Parse(Stuff.Text);

      Stuff.Free;


      HTMLParser1.Tree.GetTags('*',_Nodes);
      DisplayTags(HTMLParser1.Tree);

    end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  _Nodes := TTagNodeList.Create;
  SyntaxErrors := TStringList.Create;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SyntaxErrors.Free;
  _Nodes.Free;

end;

procedure TForm1.HTMLParser1SyntaxWarning(Sender: TObject; Text: String);
begin
  SyntaxErrors.Add(Text);
  
end;

procedure TForm1.ExpandAll1Click(Sender: TObject);
begin
  If TreeView1.Selected <> nil then
    TreeView1.Selected.Expand(True);

end;

procedure TForm1.DisplayTableNode(Node : TTagNode);

var
  Table : TStringTable;

begin
  If TreeView1.Selected <> nil then
    begin
      Table := TStringTable.Create;

      GetTable(Node,Table);
      DisplayTable(Table);

      Table.Free;

    end;

end;

procedure TForm1.DisplayTable(Table : TStringTable);

var
  TableForm : TTableFrm;
  Row,
  Col : integer;

begin
  If Table.RowCount > 0 then
    begin
      TableForm := TTableFrm.Create(nil);

      TableForm.Grid1.RowCount := Table.RowCount + 1;
      TableForm.Grid1.ColCount := Table.ColCount;

      for Col := 0 to Table.ColCount - 1 do
        TableForm.Grid1.Cells[Col,0] := Table.Headers[Col];

      for Row := 0 to Table.RowCount - 1 do
        for Col := 0 to Table.ColCount - 1 do
          TableForm.Grid1.Cells[Col,Row + 1] := Table.Cells[Col,Row];

      TableForm.ShowModal;
      TableForm.Free;

    end;

end;

procedure TForm1.pumTreeViewPopup(Sender: TObject);
begin
  If TreeView1.Selected <> nil then
    DisplayTable1.Enabled := (CompareText(TreeView1.Selected.Text,'table') = 0);

end;

procedure TForm1.DisplayTable1Click(Sender: TObject);
begin
  DisplayTableNode(TTagNode(TreeView1.Selected.Data));

end;

end.
