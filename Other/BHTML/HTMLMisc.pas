unit htmlmisc;

{ -----------------------------------------------------------------------------

  Copyright (c) 1997,1998,1999,2000 by Richard Phillips (richardp@dallas.net)

  All rights reserved.  Free for *non-commercial* use.  Feel free to contact
    me if you would like to make use of the source in a commercial
    application.

  11/21/97  RP  - Added FindURLs
                - Added IsURL
  11/25/97  RP  - Added QualifyURL
                - Added FindEmailAddresses
  01/27/98  RP  - Changed THTMLTAble._BGColor to not add # to color tag
  02/05/98  RP  - Added Meta Tags property to THTMLDoc
  03/10/98  RP  - Added code to handle '#' char in GetHTMLColor routine
                - Added SaveToFile method to THTMLTable
  03/20/98  RP  - Fixed bug with not adding headers
                - Changed to THTMLTemplate.Display to include CRLF on each line
  12/29/98  RP  - Updated (fixed) IntToRGB
  03/05/99  RP  - Added CellFormat class (for THTMLTable)
                - Added OnRenderCell event to THTMLTable
  03/07/99  RP  - Removed auto-add of '#' to colors in HTMLDoc
                - THTMLTable, THTMLDoc made into components
                - Added '#' to color constants
                - Changed GetHTMLColorIndex to reflect '#' changes above
  03/09/99  RP  - Added ID,Class properties to THTMLCellFormat
  03/10/99  RP  - Added OnRenderHeaderCell event to THTMLTable
                - Added CSS property to THTMLDoc
  03/18/99  RP  - Fixed bug(?) in Parameterize Tag where spaces were being
                  removed from values
  03/22/99  RP  - Converted THTMLTemplate to a component
  03/24/99  RP  - Wrapped timestamp in '<p>' tags in THTMLDoc.GetText
  06/04/99  RP  - Fixed bug in urlDecode routine
  06/08/99  RP  - Added urlDecode support for &#xxx; type tags
                - Added more &xxxx; values to supported list in urlDecode
  06/17/99  RP  - Split urlDecode out into urlDecode and HTMLDecode.  Changed
                    headers thereof to force decisions by users
                - Renamed SoftUrlEncode to HTMLEncode
                - Changed headers of urlEncode, HTMLEncode
  07/12/99  RP  - Moved HTML Generation comps out to HTMLGen.pas
  07/18/99  RP  - Changed ParameterizeTag to return tag name (not in list now)
                - More aggressive parsing in Parameterize Tag (after '=' found)
                - ParameterizeTag now handles " inside of ' (and visa-versa)
  07/27/99  RP  - Replaced ConvertParamsToTag with new one from HTMLParser.Render
                - More funky whitespace handling in ParameterizeTag
  08/20/99  RP  - Altered ParameterizeTag to not add empty params to list
  09/21/99  RP  - Altered HTMLMsg to return HTML doc with message as text
  10/27/99  RP  - Handled yet another bizarre whitespace issue in ParameterizeTag
                - Updated HTMLEncode to handle '&'
                - Basic cleanup (remove commented out old code)
                - Added checking for '/' at then end of a parameter value in
                   ConvertParamsToTag method
  10/28/99  RP  - Changed ConvertParamsToTag to ALWAYS surround param values
                    with Quotes (" or ') since XML and XHTML enforce this. 
  11/16/99  RP  - Tuning to ParameterizeTag method (using BuffStart)

  ---------------------------------------------------------------------------- }

interface

uses
  Classes, SysUtils, Windows, Misc;

const
  cBlack = '#000000';
  cDarkRed = '#800000';
  cDarkGreen = '#008000';
  cDarkYellow = '#808000';
  cDarkBlue = '#000080';
  cDarkMagenta = '#800080';
  cDarkCyan = '#008080';
  cGray = '#808080';
  cLightGray = '#C0C0C0';
  cRed = '#FF0000';
  cGreen = '#00FF00';
  cYellow = '#FFFF00';
  cBlue = '#0000FF';
  cMagenta = '#FF00FF';
  cCyan = '#00FFFF';
  cWhite = '#FFFFFF';

  HTMLColors : array [0..15] of string = (cBlack,cDarkRed,cDarkGreen,cDarkYellow,
                                          cDarkBlue,cDarkMagenta,cDarkCyan,
                                          cGray,cLightGray,cRed,cGreen,cYellow,
                                          cBlue,cMagenta,cCyan,cWhite);

  ColorNames : array[0..15] of string = ('Black','Dark Red','Dark Green','Dark Yellow',
                                         'Dark Blue','Dark Magenta','Dark Cyan',
                                         'Gray','Light Gray','Red','Green','Yellow',
                                         'Blue','Magenta','Cyan','White');

  WindowsColorValues : array [0..15] of integer = ($000000,      { clBlack }
                                                   $000080,      { clMaroon }
                                                   $008000,      { clGreen }
                                                   $008080,      { clOlive }
                                                   $800000,      { clNavy }
                                                   $800080,      { clPurple }
                                                   $808000,      { clTeal }
                                                   $808080,      { clGray }
                                                   $C0C0C0,      { clSilver }
                                                   $0000FF,      { clRed }
                                                   $00FF00,      { clLime }
                                                   $00FFFF,      { clYellow }
                                                   $FF0000,      { clBlue }
                                                   $FF00FF,      { clFuchsia }
                                                   $FFFF00,      { clAqua }
                                                   $FFFFFF);     { clWhite }

function urlEncode(const Text : string) : string;
function HTMLEncode(const Text : string) : string;
function urlDecode(const Text : string) : string;
function HTMLDecode(const Text : string) : string;
procedure GetPairs(Pairs : TStringList);
procedure HTMLErrorMsg(Caption,ErrorMsg : string);
function HTMLMsg(Caption, Msg : string) : string;
procedure DisplayHTMLFile(Filename : string);
procedure DisplayHTMLSegment(Filename : string);
procedure DisplayStatusCode(Status : integer);
function RGBToInt(RGB : string) : longint;
function IntToRGB(Num : longint) : string;
function GetHTMLColorIndex(AColor : string) : integer;
function ParameterizeTag(Tag : string; Params : TStringList) : string;
function ConvertParamsToTag(Name : string; Params : TStringList) : string;
function RemoveTags(InfestedStr : string) : string;
procedure CreateURLFile(Filename, URL : string);
procedure FindURLs(URLs : TStrings; Stuff : string);
function IsURL(TestStr : string) : boolean;
function QualifyURL(URL : string) : string;
function FindEMailAddresses(Addresses : TStrings; Stuff : string) : integer;

implementation

function urlEncode(const Text : string) : string;

begin
  Result := Text;

  while Pos(' ',Result) > 0 do
    begin
      Insert('%20',Result,Pos(' ',Result));
      Delete(Result,Pos(' ',Result),1);
    end;

end;

function HTMLEncode(const Text : string) : string;

// Handle some of the more friendly characters

var
  Counter : integer;

begin
  Result := Text;

  for Counter := Length(Result) downto 0 do
    begin
      case Result[Counter] of
        '<' : Insert('&lt;',Result,Counter + 1);
        '>' : Insert('&gt;',Result,Counter + 1);
        '&' : Insert('&amp;',Result,Counter + 1);
        
        else
          Continue;

      end;  {  Case  }

      Delete(Result,Counter,1);

    end;

end;

function urlDecode(const Text : string) : string;

// Undo encoding in urlStr.  Convert '+' to ' ', %xx to the Chr(xx)

var
  Counter : integer;
  HexDigits : string;

begin
  Counter := 1;
  Result := '';

  while (Counter <= Length(Text)) do
    begin
      If Text[Counter] = '%' then
        begin
          HexDigits := Copy(Text,Counter + 1,2);
          Result := Result + Chr(HexToI(HexDigits));
          Counter := Counter + 2;
        end
      else
        If Text[Counter] = '+' then
          Result := Result + ' ';

      Inc(Counter);

    end;

end;

function HTMLDecode(const Text : string) : string;

// Undo encoding in urlStr.  Convert &xxxx; and &#xxx; to the appropriate
// character (&quot; to " for example).

const
  cCharValidTerminators = [' ','<','>','&','%','+'];
  cCharTerminators = [' '..'"','$'..'/',':'..'@','['..#96,'{'..#255];

  cMaxEncodedChars = 36;
  EncodingMap : array [0..cMaxEncodedChars] of array [0..1] of string =
    (('lt','<'),('gt','>'),('nbsp',' '),('amp','&'),('quot','"'),('tilde','~'),
     ('iexcl',#161),('cent',#162),('pound',#163),('curren',#164),('yen',#165),
     ('brvbar',#166),('sect',#167),('uml',#168),('copy',#169),('ordf',#170),
     ('laquo',#171),('not',#172),('shy',#173),('reg',#174),('macr',#175),
     ('deg',#176),('plusmn',#177),('sup2',#178),('sup3',#179),('acute',#180),
     ('micro',#181),('para',#182),('middot',#183),('ccedil',#184),('sup1',#185),
     ('ordm',#186),('raquo',#187),('frac14',#188),('frac12',#189),('frac34',#190),
     ('times',#215));

var
  Start,
  Counter : integer;

// ----------

function DecodeIt(EncodedStr : string) : string;

var
  Temp,
  Counter : integer;

begin
  Result := EncodedStr;

  If EncodedStr <> '' then
    If EncodedStr[1] = '#' then                         // '&#032;' => ' '
      begin
        Temp := StrToIntDef(Copy(EncodedStr,2,Length(EncodedStr)),0);

        If Temp > 0 then
          Result := Chr(Temp);

      end
    else
      begin
        EncodedStr := LowerCase(EncodedStr);            // '&nbsp;' => ' '

        for Counter := 0 to cMaxEncodedChars do
          If EncodingMap[Counter,0] = EncodedStr then
            begin
              Result := EncodingMap[Counter,1];
              Exit;
            end;

        Result := '&' + Result;

      end;

end;

// ----------

begin
  Counter := 1;
  Result := '';

  while (Counter <= Length(Text)) do
    begin
      If Text[Counter] = '&' then
        begin
          Inc(Counter);
          Start := Counter;

          while (Counter <= Length(Text)) do
            If Text[Counter] = ';' then
              begin
                Result := Result + DecodeIt(Copy(Text,Start,Counter - Start));
                Break;
              end
            else
              If Text[Counter] in cCharValidTerminators then
                begin
                  Result := Result + DecodeIt(Copy(Text,Start,Counter - Start));
                  Counter := Counter - 1;
                  Break;
                end
              else
                If (Text[Counter] in cCharTerminators) or (Counter = Length(Text)) then
                  begin                                       // If it ended unexpectedly...
                    Counter := Start;                         // Just skip the '&' char
                    Break;
                  end
                else
                  Inc(Counter);

        end
      else
        Result := Result + Text[Counter];

      Inc(Counter);

    end;

end;

procedure GetPairs(Pairs : TStringList);

var
  Ch       : char;
  RequestMethod,
  ContentLength,
  TempStr  : string;
  BufLen,
  Counter  : longint;

begin
  RequestMethod := UpperCase(GetEnvVar('REQUEST_METHOD'));

  If RequestMethod = 'POST' then
    begin
      ContentLength := GetEnvVar('CONTENT_LENGTH');

      If ContentLength <> '' then
        BufLen := StrToInt(ContentLength)
      else
        BufLen := 16384;

      Counter := 1;
      TempStr := '';

      try
        while Counter <= BufLen do
          begin
            Read(Ch);

            If Ch = '&' then
              begin
                Pairs.Add(urlDecode(TempStr));
                TempStr := '';
              end
            else
              TempStr := TempStr + Ch;

            Inc(Counter);

          end;

        If TempStr <> '' then
          Pairs.Add(urlDecode(TempStr));

      except

      end;

    end
  else
    If RequestMethod = 'GET' then
      begin
        TempStr := GetEnvVar('QUERY_STRING');

        for Counter := 0 to ItemsInList(TempStr,'&') - 1 do
          Pairs.Add(urlDecode(ItemFromList(TempStr,'&',Counter)));

      end;

end;

procedure HTMLErrorMsg(Caption, ErrorMsg : string);

{ Write HTML with Caption for title/header and ErrorMsg for text/body }

begin
  DisplayStatusCode(200);

  Writeln('<HTML><HEAD><TITLE>' + Caption + '</TITLE></HEAD>');
  Writeln('<BODY>');
  Writeln('<B>' + ErrorMsg + '</B>');
  Writeln('</BODY></HTML>');

end;

function HTMLMsg(Caption, Msg : string) : string;

{ Return HTML with Caption for title/header and Msg for text/body }

begin
  Result := '<HTML><HEAD><TITLE>' + Caption + '</TITLE></HEAD>'#13#10 +
    '<BODY>'#13#10 + Msg + #13#10 + '</BODY></HTML>';

end;

procedure DisplayHTMLSegment(Filename : string);

var
  InFile  : textfile;
  TempStr : string;

begin
  If FileExists(FileName) then
    begin
      AssignFile(InFile,FileName);
      Reset(InFile);

      while not Eof(InFile) do
        begin
          Readln(InFile,TempStr);
          Writeln(TempStr);
        end;

      CloseFile(InFile);
    end;

end;

procedure DisplayHTMLFile(Filename : string);

var
  InFile  : textfile;
  TempStr : string;

begin
  If FileExists(FileName) then
    begin
      DisplayStatusCode(200);

      AssignFile(InFile,FileName);
      Reset(InFile);

      while not Eof(InFile) do
        begin
          Readln(InFile,TempStr);
          Writeln(TempStr);
        end;

      CloseFile(InFile);
    end;

end;

procedure DisplayStatusCode(Status : integer);

begin
  Writeln('Content-type: text/html');
  Writeln('Status: ' + IntToStr(Status));
  Writeln;

end;

function RGBToInt(RGB : string) : longint;

begin
  Result := HexToI(Copy(RGB,5,2) + Copy(RGB,3,2) + Copy(RGB,1,2));

end;

function IntToRGB(Num : longint) : string;

begin
  Result := InttoHex(GetRValue(Num),2) + InttoHex(GetGValue(Num),2) + InttoHex(GetBValue(Num),2);

end;

function GetHTMLColorIndex(AColor : string) : integer;

// Return position in HTMLColors list of AColor

var
  Counter : integer;

begin
  Result := -1;

  If Length(AColor) > 0 then
    begin
      If AColor[1] <> '#' then
        AColor := '#' + AColor;

      AColor := UpperCase(AColor);

      for Counter := 0 to 15 do
        If HTMLColors[Counter] = AColor then
          begin
            Result := Counter;
            Break;
          end;

    end;

end;
function ParameterizeTag(Tag : string; Params : TStringList) : string;

// Break tag out into list of paramaters stored in a stringlist
// Returns tag name (<a href="www.stuff.com"> would return 'a'
//
// Note: This routine does not clear Params before processing.
// Note 2: Params may contain elements that don't have an '=' in'em like NOWRAP

var
  BuffStart,
  Index,
  TagLen : integer;
  TempStr : string;
  InSingleQuotes,
  InQuotes : boolean;

// ~~~~~~~~~~~~~~~~~~~~
procedure AddToBuffer;

begin
  TempStr := TempStr + Copy(Tag,BuffStart,Index - BuffStart);
  BuffStart := Index + 1;
end;
// ~~~~~~~~~~~~~~~~~~~~

begin
  Result := '';

// Remove any leading or trailing <'s or >'s

  If Length(Tag) > 1 then
    If Tag[1] = '<' then
      Delete(Tag,1,1);

  If Length(Tag) > 1 then
    If Tag[Length(Tag)] = '>' then
      Delete(Tag,Length(Tag),1);

// Get Tag Name and see if there are any parameters to handle

  Index := 0;
  BuffStart := 1;
  TagLen := Length(Tag);
  InQuotes := False;
  InSingleQuotes := False;
  TempStr := '';

  While Index < TagLen do
    begin
      Inc(Index);

      case Tag[Index] of
        #9,#13,' ' :
              If not InQuotes and not InSingleQuotes then // Whitespace terminates a param
                begin
                  AddToBuffer;

                  If TempStr <> '' then
                    begin
                      If Result = '' then
                        Result := TempStr
                      else
                        Params.Add(TempStr);

                      TempStr := '';

                    end;

                end;

        #10 : If not InQuotes and not InSingleQuotes then                 // Eat LF's if not in quotes
                AddToBuffer;

        '"' : If not InSingleQuotes then
                begin
                  InQuotes := not InQuotes;
                  AddToBuffer;
                end;

        '''' : If not InQuotes then
                 begin
                   InSingleQuotes := not InSingleQuotes;
                   AddToBuffer;
                 end;

        '=' : If not InQuotes and not InSingleQuotes then
                begin
                  TempStr := TempStr + Copy(Tag,BuffStart,(Index - BuffStart) + 1);

                  while Index < TagLen do
                    If Tag[Index + 1] in [#9,#10,#13,' '] then   // Clean off whitespace after '='
                      Inc(Index)
                    else
                      Break;

                  BuffStart := Index + 1;

              end;

      end;  {  Case  }

    end;

  TempStr := TempStr + Copy(Tag,BuffStart,Length(Tag));

  If TempStr <> '' then
    If Result = '' then
      Result := TempStr
    else
      Params.Add(TempStr);

end;

function ConvertParamsToTag(Name : string; Params : TStringList) : string;

// Return tag string built from Params

var
  Index,
  Counter   : integer;
  TempStr,
  ParamName : string;

begin
  with Params do
    begin
      Result := '<' + Name;                           // Tag must at least contain name

      for Counter := 0 to Params.Count - 1 do         // For each of the parameters...
        begin
          TempStr := Params[Counter];
          Index := Pos('=',TempStr);                  // See if tag contains an '='

          If Index > 0 then                           // If it does contain an '=' ...
            begin
              ParamName := Copy(TempStr,1,Index - 1);
              TempStr := Copy(TempStr,Index + 1,Length(TempStr));

              If Pos('"',TempStr) > 0 then            // If value contains " then must surround value with '
                TempStr := '''' + TempStr + ''''
              else                                    // Otherwise surround value with "
                TempStr := '"' + TempStr + '"';

              Result := Result + ' ' + ParamName + '=' + TempStr;

            end
          else
            Result := Result + ' ' + TempStr;

        end;

      Result := Result + '>';

    end;

end;

function RemoveTags(InfestedStr : string) : string;

// Remove all html tags from string

var
  Index,
  Index2 : integer;

begin
  Index := Pos('<',InfestedStr);

  While Index > 0 do
    begin
      Index2 := Pos('>',InfestedStr);

      If Index2 > Index then
        Delete(InfestedStr,Index,(Index2 - Index) + 1)
      else
        Delete(InfestedStr,1,Index2);

      Index := Pos('<',InfestedStr);

    end;

  Result := InfestedStr;

end;

procedure CreateURLFile(Filename, URL : string);

// Create an Internet Explorer style URL file

var
  URLFile : textfile;

begin
  AssignFile(URLFile,Filename);
  ReWrite(URLFile);

  Writeln(URLFile,'[InternetShortcut]'#13#10'URL=' + URL);

  CloseFile(URLFile);

end;

procedure FindURLs(URLs : TStrings; Stuff : string);

// Parse out each url (http, ftp, and mailto) from Stuff

var
  TruePos,
  LinkLen,
  Index   : integer;
  WorkStr : string;

function FindTagLength(TagStr : string) : integer;

// Return length of the URL in TagStr

const
  cURLTerminators = [' ',',',#13,')'];

var
  Counter : integer;

begin
  Counter := 0;

  repeat
    Inc(Counter);
  until (Counter >= Length(TagStr)) or (TagStr[Counter] in cURLTerminators);

  while (TagStr[Counter] in cURLTerminators + ['.']) and (Counter > 0) do  // Now we check for '.'
    Dec(Counter);

  Result := Counter;

end;

procedure LocateURLs(URLType : string);

begin
  If Stuff <> '' then
    begin
      WorkStr := LowerCase(Stuff);

      TruePos := 0;

      while Length(WorkStr) > 0 do
        begin
          Index := Pos(URLType,WorkStr);

          If Index > 0 then
            begin
              TruePos := TruePos + Index;

              Delete(WorkStr,1,Index - 1);

              LinkLen := FindTagLength(WorkStr);

              If LinkLen > 0 then
                begin
                  URLs.Add(Copy(Stuff,TruePos,LinkLen));
                  Delete(WorkStr,1,LinkLen);
                  TruePos := TruePos + LinkLen - 1;
                end
              else
                WorkStr := '';

            end
          else
            WorkStr := '';

        end;

    end;

end;

begin
  URLs.Clear;

  LocateURLs('http://');
  LocateURLs('ftp://');
  LocateURLs('mailto:');

end;

function IsURL(TestStr : string) : boolean;

// Returns true if TestStr contains a valid URL

const
  cValidURLChars = ['a'..'z','A'..'Z','0'..'9','/','_','-'];

begin
  Result := False;

  TestStr := LowerCase(TestStr);

  If (Copy(TestStr,1,7) = 'http://') or (Copy(TestStr,1,6) = 'ftp://') or
    (Copy(TestStr,1,7) = 'mailto:') or (Copy(TestStr,1,4) = 'ftp.') or
    (Copy(TestStr,1,4) = 'www.') then
      begin
        If TestStr[Length(TestStr)] in cValidURLChars then
          Result := True

      end;

end;

function QualifyURL(URL : string) : string;

// Expand to be complete url

var
  TempStr : string;

begin
  TempStr := LowerCase(Copy(URL,1,4));

  If URL = 'www.' then
    Result := 'http://' + Result
  else
    If URL = 'ftp.' then
      Result := 'ftp://' + Result
    else
      Result := URL;

end;

function FindEMailAddresses(Addresses : TStrings; Stuff : string) : integer;

// Parse out list of email addresses contained in Stuff, return count of those found

{ * Add advanced checking to locate email address name if possible, i.e. }
{    Richard Phillips <richardp@dallas.net>                              }

const
  cInvalidChars = [#0..',','/',':'..'?','['..'^','`','{'..#127];

var
  Address,
  TempStr : string;
  PrePos,
  PostPos,
  Index,
  Counter : integer;
  List    : TStringList;

begin
  List := TStringList.Create;
  List.Text := Stuff;

  for Counter := 0 to List.Count - 1 do
    begin
      TempStr := List[Counter];
      Index := Pos('@',TempStr);

      while Index > 0 do                              // There's an EMail address here somewhere
        begin
          PrePos := Index;                            // Locate start of address

          while (PrePos > 1) do
            If TempStr[PrePos - 1] in cInvalidChars then
              begin
                Break;

              end
            else
              Dec(PrePos);

          PostPos := Index;                            // Locate start of address

          while (PostPos < Length(TempStr)) do
            If TempStr[PostPos + 1] in cInvalidChars then
              begin
                Break;

              end
            else
              Inc(PostPos);

          If (PrePos < Index) and (PostPos > Index) then
            begin
              Address := Copy(TempStr,PrePos,(PostPos - PrePos) + 1);

              If Addresses.IndexOf(Address) < 0 then
                Addresses.Add(Address);

              Delete(TempStr,1,PostPos);
              
            end
          else
            Delete(TempStr,1,Index);             // Handle the case where this ain't email

          Index := Pos('@',TempStr);

        end;

    end;

  List.Free;

  Result := Addresses.Count;

end;

end.
