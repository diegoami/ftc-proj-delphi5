unit HTMLParserSupt;

{ ============================================================================

  Copyright (c) 1997,1998,1999,2000 by Richard Phillips (richardp@dallas.net)

  All rights reserved.  Free for *non-commercial* use.  Feel free to contact
    me if you would like to make use of the components in a commercial
    application.

  ============================================================================ }

interface

uses
  SysUtils, HTMLParser, StringTable;

procedure GetForm(Node: TTagNode; Items : TTagNodeList);
procedure GetTable(TableNode: TTagNode; Table: TStringTable);

implementation

const
  cFormElements = '|input|textarea|select|label|button|';

procedure GetForm(Node: TTagNode; Items : TTagNodeList);

// Return Node's contents in TTagNodeList

// -=-=-=-=-=-

procedure GetFormElements(ANode : TTagNode);

var
  Counter : integer;

begin
  If ANode.NodeType = nteElement then
    If Pos('|' + LowerCase(ANode.Caption) + '|',cFormElements) > 0 then
      Items.Add(ANode);

  for Counter := 0 to ANode.ChildCount - 1 do
    GetFormElements(ANode.Children[Counter]);

end;

// -=-=-=-=-=-

begin
  If Assigned(Items) then
    begin
      Items.Clear;

      If CompareText(Node.Caption,'form') = 0 then
        GetFormElements(Node);

    end;

end;

procedure GetTable(TableNode: TTagNode; Table: TStringTable);

// Return TableNode's contents in Table

{ * Need to add code to handle rowspan and colspan }

var
  RowCtr,
  DataCtr : integer;
  Node,
  RowNode : TTagNode;

begin
  Table.Clear;

  If CompareText(TableNode.Caption,'table') = 0 then
    begin
      for RowCtr := 0 to TableNode.ChildCount - 1 do
        begin
          RowNode := TableNode.Children[RowCtr];

          If RowNode.NodeType = nteElement then
            If CompareText(RowNode.Caption,'tr') = 0 then
              begin
                Table.NewRow;

                for DataCtr := 0 to RowNode.ChildCount - 1 do
                  begin
                    Node := RowNode.Children[DataCtr];

                    If Node.NodeType = nteElement then
                      If CompareText(Node.Caption,'td') = 0 then
                        Table.AddColumnObject(Node.GetPCData,Node)
                      else
                        If CompareText(Node.Caption,'th') = 0 then
                          Table.AddHeader(Node.GetPCData);

                  end;

                If Table.Row[Table.RowCount - 1].Count <= 0 then
                  Table.DeleteRow(Table.RowCount - 1);

              end;

        end;

    end;

end;

end.
