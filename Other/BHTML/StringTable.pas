unit StringTable;

{ ============================================================================

  Copyright (c) 1997,1998,1999,2000 by Richard Phillips

  02/24/98  RP  - Added SaveToFile, LoadFromFile methods
                - Added AddRow method
                - Added DeleteColumn method
  02/27/98  RP  - Added Objects property (and associated methods)
                - Changed NumRows and NumColumns to match grid (ColCount, RowCount)
  04/13/98  RP  - Added checking for valid row data (by column count) in LoadFromFile
  05/15/98  RP  - Added CellsByName property
  07/20/98  RP  - Added RowLimit property
  11/03/98  RP  - Some basic cleanup in LoadFromFile.  Re-enabled rowlimit prop
  11/11/98  RP  - More bug fixes in rowlimit property
  03/30/99  RP  - Replaced CSVToList with more robust " handling
  07/04/99  RP  - Added AddHeader method
  07/30/99  RP  - Added AddColumnObject method
  09/08/99  RP  - Added FirstLineIsHeaders method
  09/22/99  RP  - Added Sort and Find methods
  11/17/99  RP  - Tuned CSVToList sub-function in LoadFromFile
  01/27/99  RP  - General cleanup
  03/04/99  RP  - Added better ColCount support (handle irregular row widths)
                  Deleted GetNumCols

  ============================================================================ }

interface

uses
  Classes, SysUtils, Misc;

type
  TStringTable = class
    private
      FColCount,
      FRowLimit : integer;
      FDelimiter : string;
      Data : TList;
      FHeaders : TStringList;
      FFirstLineIsHeaders,
      FIncludeQuotes : boolean;

      function GetCell(ACol,ARow : integer) : string;
      procedure SetCell(ACol,ARow : integer; Value : string);
      function GetNumRows : integer;
      function GetRow(const Index : integer) : TStringList;
      function GetHeader(const Index : integer) : string;
      procedure SetHeader(const Index : integer; Value : String);
      function GetObject(ACol,ARow : integer) : pointer;
      procedure SetObject(ACol,ARow : integer; Value : pointer);
      function GetColByName(const Value : string) : integer;
      function GetCellByName(ACol : string; ARow : integer) : string;
      procedure SetCellByName(ACol : string; ARow : integer; Value : string);
      procedure SortList(L, R, ColNum: Integer);

    public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure NewRow;
      procedure AddRow(RowData : TStrings);
      procedure AddColumn(Item : string);
      procedure AddColumnObject(Item: string; AObject: TObject);
      procedure AddHeader(Header : string);
      procedure DeleteColumn(ACol : integer);
      procedure DeleteRow(ARow : integer);
      procedure Sort(ACol : integer);
      function Find(Text : string; Col : integer) : integer;

      procedure SaveToFile(Filename : string);
      procedure LoadFromFile(Filename : string);

      property Cells[ACol, ARow : Integer] : string read GetCell write SetCell;
      property CellsByName[AColName : string; ARow : integer] : string read GetCellByName write SetCellByName;
      property ColCount : integer read FColCount;
      property RowCount : integer read GetNumRows;
      property RowLimit : integer read FRowLimit write FRowLimit;
      property Row[const Index : integer] : TStringList read GetRow;
      property Headers[const Index : integer] : string read GetHeader write SetHeader;
      property Objects[ACol,ARow : integer] : pointer read GetObject write SetObject;
      property Delimiter : string read FDelimiter write FDelimiter;
      property IncludeQuotes : boolean read FIncludeQuotes write FIncludeQuotes;
      property FirstLineIsHeaders : boolean read FFirstLineIsHeaders write FFirstLineIsHeaders;

  end;

implementation

{ ---------------------------------------------------------------------------- }

constructor TStringTable.Create;

begin
  Inherited;

  Data := TList.Create;
  FHeaders := TStringList.Create;
  FDelimiter := ',';

end;

destructor TStringTable.Destroy;

begin
  FHeaders.Free;

  Clear;
  Data.Free;

  Inherited;

end;

procedure TStringTable.Clear;

var
  Counter : integer;

begin
  for Counter := Data.Count - 1 downto 0 do
    DeleteRow(Counter);

  FColCount := 0;  

end;

function TStringTable.GetCell(ACol,ARow : integer) : string;

begin
  Result := '';

  If ARow < Data.Count then
    with TStringList(Data[ARow]) do
      If ACol < Count then
        Result := Strings[ACol];

end;

procedure TStringTable.SetCell(ACol,ARow : integer; Value : string);

var
  Counter,
  Cols    : integer;

begin
  If ARow >= Data.Count then
    repeat
      NewRow;
    until Data.Count > ARow;

  Cols := Row[ARow].Count;

  If ACol = Cols then
    Row[ARow].Add(Value)
  else
    If ACol > Cols then
      begin
        for Counter := Cols to ACol - 1 do
          Row[ARow].Add('');

        Row[ARow].Add(Value);

      end
    else
      Row[ARow][ACol] := Value;

  If FColCount <= ACol then
    FColCount := ACol + 1;

end;

function TStringTable.GetCellByName(ACol : string; ARow : integer) : string;

var
  Index : integer;

begin
  Index := GetColByName(ACol);

  If Index < 0 then
    Result := ''
  else
    If (ARow < RowCount) and (ARow >= 0) then
      Result := GetCell(Index,ARow)
    else
      Result := '';

end;

procedure TStringTable.SetCellByName(ACol : string; ARow : integer; Value : string);

var
  Index : integer;

begin
  Index := GetColByName(ACol);

  If Index < 0 then
    Index := FHeaders.Add(ACol);

  SetCell(Index,ARow,Value);  

end;

function TStringTable.GetNumRows : integer;

begin
  Result := Data.Count;

end;

function TStringTable.GetRow(const Index : integer) : TStringList;

begin
  If (Index >= 0) and (Index < Data.Count) then
    Result := TStringList(Data[Index])
  else
    Result := nil;

end;

procedure TStringTable.NewRow;

// Add (empty) new row at end of table

var
  NewList : TStringList;

begin
  NewList := TStringList.Create;
  Data.Add(NewList);

end;

procedure TStringTable.AddColumn(Item : string);

// Add Item at the end of the last row of the table

begin
  If Data.Count <= 0 then
    NewRow;

  with Row[Data.Count - 1] do
    begin
      Add(Item);

      If Count > FColCount then
        FColCount := Count;

    end;

end;

procedure TStringTable.AddColumnObject(Item : string; AObject : TObject);

// Add Item and object at the end of the last row of the table

begin
  If Data.Count <= 0 then
    NewRow;

  with Row[Data.Count - 1] do
    begin
      AddObject(Item,AObject);

      If Count > FColCount then
        FColCount := Count;

    end;

end;

procedure TStringTable.DeleteColumn(ACol : integer);

// Delete column ACol from each row in table

var
  Counter : integer;
  TempRow : TStringList;

begin
  for Counter := 0 to RowCount - 1 do
    begin
      TempRow := Row[Counter];

      If Assigned(TempRow) then
        If ACol < TempRow.Count then
          TempRow.Delete(ACol);

    end;

  Dec(FColCount);

end;

procedure TStringTable.DeleteRow(ARow : integer);

// Delete ARow'th line of data from table

begin
  TStringList(Data[ARow]).Free;
  Data.Delete(ARow);

end;

function TStringTable.GetHeader(const Index : integer) : string;

begin
  If (Index >= 0) and (Index < FHeaders.Count) then
    Result := FHeaders[Index]
  else
    Result := '';

end;

procedure TStringTable.SetHeader(const Index : integer; Value : String);

begin
  while Index >= FHeaders.Count do
    FHeaders.Add('');

  FHeaders[Index] := Value;

end;

procedure TStringTable.AddRow(RowData : TStrings);

// Add an entire Row (TStrings) to table at once.

var
  NewList : TStringList;

begin
  NewList := TStringList.Create;
  NewList.Assign(RowData);
  Data.Add(NewList);

end;

procedure TStringTable.SaveToFile(Filename : string);

// Store table to file in CSV format

var
  OutFile : textfile;
  RowCtr  : integer;
  TempRow : TStringList;

// ----------------------------------

function ListToCSV(List : TStrings) : string;

// Return List as CSV formatted line, i.e. "Test1","Test2","Test3"

var
  Counter : integer;

begin
  Result := '';

  for Counter := 0 to List.Count - 1 do
    begin
      If Counter > 0 then
        Result := Result + FDelimiter;

      If FIncludeQuotes then
        Result := Result + '"' + List[Counter] + '"'
      else
        Result := Result + List[Counter];

    end;

end;

// ----------------------------------

begin
  AssignFile(OutFile,Filename);
  ReWrite(OutFile);

  If (FHeaders.Count > 0) and FirstLineIsHeaders then
    Writeln(OutFile,ListToCSV(FHeaders));

  for RowCtr := 0 to RowCount - 1 do
    begin
      TempRow := Row[RowCtr];

      If Assigned(TempRow) then
        Writeln(OutFile,ListToCSV(TempRow));

    end;

  CloseFile(OutFile);

end;

procedure TStringTable.LoadFromFile(Filename : string);

var
  Counter : integer;
  InFile : textfile;
  TempStr : string;
  TempRow : TStringList;
  Done : boolean;

// ----------------------------------

function CSVToList(const Line : string; List : TStrings) : integer;

// Convert CSV formatted line to StringList

var
  StartPos,
  LineLen,
  Index : integer;
  InQuotes : boolean;
  _Delimiter : char;

begin
  List.Clear;

  If FDelimiter <> '' then
    _Delimiter := FDelimiter[1]
  else
    _Delimiter := ',';

  InQuotes := False;
  StartPos := 1;
  LineLen := Length(Line);

  for Index := 1 to LineLen do
    If (Line[Index] = _Delimiter) and not InQuotes then
      begin
        List.Add(Copy(Line,StartPos,Index - StartPos));
        StartPos := Index + 1;
      end
    else
      If Line[Index] = '"' then
        InQuotes := not InQuotes
      else
        If (Index = LineLen) and (Index > StartPos) then
          List.Add(Copy(Line,StartPos,LineLen));


  Result := List.Count;

end;

// ----------------------------------

begin
  If FileExists(Filename) then
    begin
      TempRow := TStringList.Create;

      Counter := 0;                    // Used for RowLimit

      AssignFile(InFile,Filename);
      Reset(InFile);

      If not Eof(InFile) and FirstLineIsHeaders then          // Get Headers
        begin
          Readln(InFile,TempStr);
          CSVToList(TempStr,FHeaders);
        end;

      Done := False;

      while not Eof(InFile) and not Done do      // Get Data
        begin
          Inc(Counter);

          Readln(InFile,TempStr);
          CSVToList(TempStr,TempRow);

          If TempRow.Count >= ColCount then
            If (Counter > RowLimit) and (RowLimit > 0) then
              Done := True
            else
              AddRow(TempRow);

        end;

      CloseFile(InFile);

      TempRow.Free;

    end;

end;

function TStringTable.GetObject(ACol,ARow : integer) : pointer;

begin
  Result := nil;

  If ARow < Data.Count then
    with TStringList(Data[ARow]) do
      If ACol < Count then
        Result := Objects[ACol];

end;

procedure TStringTable.SetObject(ACol,ARow : integer; Value : pointer);

var
  Counter,
  Cols    : integer;

begin
  If ARow >= Data.Count then
    repeat
      NewRow;
    until Data.Count > ARow;

  Cols := Row[ARow].Count;

  If ACol = Cols then
    Row[ARow].AddObject('',Value)
  else
    If ACol > Cols then
      begin
        for Counter := Cols to ACol - 1 do
          Row[ARow].Add('');

        Row[ARow].AddObject('',Value);

      end
    else
      Row[ARow].Objects[ACol] := Value;

  If FColCount <= ACol then
    FColCount := ACol + 1;

end;

function TStringTable.GetColByName(const Value : string) : integer;

var
  TempStr : string;

begin
  TempStr := LowerCase(Value);

  for Result := 0 to FHeaders.Count - 1 do
    If CompareText(TempStr,LowerCase(Headers[Result])) = 0 then
      Exit;

  Result := -1;

end;

procedure TStringTable.AddHeader(Header: string);
begin
  FHeaders.Add(Header);

end;

procedure TStringTable.SortList(L, R, ColNum: Integer);

var
  TempStr : string;
  I,
  J : Integer;

begin
  if L < R then
    begin
      TempStr := Cells[ColNum,R];

      I := Pred(L);
      J := R;

      repeat
        repeat
          Inc(I);
        until CompareText(Cells[ColNum,I],TempStr) >= 0;

        repeat
          Dec(J);
        until (CompareText(Cells[ColNum,J],TempStr) <= 0) or (J = 0);

        if J <= I then
          Break;

        Data.Exchange(I,J);

      until False;

      Data.Exchange(I,R);

      SortList(L,I - 1,ColNum);
      SortList(I + 1,R,ColNum);

    end;

end;

procedure TStringTable.Sort(ACol: integer);

// Sort string table using column # ACol

begin
  SortList(0,RowCount - 1,ACol);

end;

function TStringTable.Find(Text: string; Col: integer): integer;

// Return the index of the first row contain a match for Text in the Col'th position

begin
  for Result := 0 to RowCount - 1 do
    If CompareText(Cells[Col,Result],Text) = 0 then
      Exit;

  Result := -1;

end;

end.
