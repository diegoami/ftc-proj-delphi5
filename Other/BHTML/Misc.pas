unit Misc;

{ Copyright (c) 1993 - 2000 Richard Phillips (richardp@dallas.net)
{   with Respect to Gerald Rice, Tore Bellis, Chuck Kincy

  All rights reserved.  Free for *non-commercial* use.  Feel free to contact
    me if you would like to make use of the source in a commercial
    application.
                                                                             }

{ -------------------------------------------------------------------------- }
{ 12/03/94 - Changed to support Delphi                                       }
{ 04/26/95 - Cleaned out all C string routines I could                       }
{ 03/02/96 - Fixes to support Delphi 2.0                                     }
{          - Removed CleanStr, updated FillStr, BackFill                     }
{          - Stubbed out wait code on ExecAndWait till I can understand      }
{ 09/11/96 - Added ApplicationCmdShow function (grr)                         }
{ 11/11/96 - Added LogStrings (rp)                                           }
{          - Added DelphiToUNIXTime (rp for ck)                              }
{ 12/13/96 - Added ItemFromList, StringToStringList (rp)                     }
{          - Added ItemsInList (rp)                                          }
{ 12/30/96 - Updated LeapYear function to somewhat cleaner code (rp)         }
{          - Added DaysPerMonth function (rp)                                }
{ 01/06/97 - Add BuildListFromStringList, BuildStringListFromList (rp)       }
{ 02/06/97 - Added UnixToDelphiTime (rp)                                     }
{ 04/03/97 - Added GetComboBoxText (gr)                                      }
{ 04/09/97 - Fixed LogStrings to accept TStrings instead of TStringList (rp) }
{ 04/09/97 - Commented out DayOfWeek (it's in SysUtils now) (rp)             }
{ 04/10/97 - Removed Duplicate String routines (rp)                          }
{          - Commented out GetComboBoxText (rp)                              }
{          - Removed DateFactor routine (rp)                                 }
{ 11/11/97 - Added DirExists function (rp)                                   }
{ 12/24/97 - Added MatchFileAttributes (rp)                                  }
{ 12/25/97 - Added CreateDirectoryStructure (rp)                             }
{ 12/31/97 - Added GetToken (rp)                                             }
{          - Removed BuildStringListFromList [duplicate proc] (rp)           }
{          - Changed Delimiter param to char from string in StringToList     }
{ 08/04/98 - Added '-' to seperator chars in UpperLower (rp)                 }
{ 08/06/98 - Added TokenCount function (rp)                                  }
{ 08/25/98 - Added RemoveCRLFs (rp)                                          }
{ 08/26/98 - Added RemoveExtension (rp)                                      }
{ 09/07/98 - Various changes to remove warnings due to 4.0 upgrade (rp)      }
{          - Added GetEmailAddress, GetEmailName (rp)                        }
{ 09/24/98 - Corrected minor problem with ItemsInList (grr)                  }
{ 10/13/98 - Removed check for . before string scan in RemoveExtension (rp)  }
{ 11/06/98 - Fixed bug in RemoveCRLFs (rp)                                   }
{ 11/13/98 - Changed GetIniFilePath to use SysUtil's ChangeFileExt  (trb)    }
{ 11/20/98 - Changed RemoveCRLFs to replace CRLF with space (rp)             }
{ 03/24/99 - Added PosInList function (rp)                                   }
{ 11/12/99 - Tuning to GetToken (rp)                                         }
{          - Cleanup of TokenCount (rp)                                      }
{ 02/18/00 - Added FileTimeToDateTime (rp)                                   }

interface

uses
  Classes, Windows;

function RemoveSpaces(TempStr : string) : string;
function RemoveChar(TempStr : string; Ch : char) : string;
function FillStr(TempStr : string; Ch : char; Cnt : byte) : string;
function BackFill(TempStr : string; Ch : char; Count : byte) : string;
function UpperLower(StrToChange : string) : string;
function ParseName(Name : string) : string;
function LeapYear(Year : word) : boolean;
function DaysPerMonth(AYear, AMonth: Integer): Integer;
function JulianDay(Month,Day,Year : word) : word;
function SwapByte(B : byte) : byte;
function CopyFile(FromFile,ToFile : string) : word;
function ExecuteAndWait(CmdPath,ErrorMsg : string; CmdShow : word) : longint;
function GetExecutablePath : string;
function AddTrailingSlash(Path : string) : string;
function IToHex(Num : longint) : string;
function HexToI(TempStr : string) : longint;
function GetIniFilePath : string;
function GetEnvVar(EnvVar : string) : string;
function ExecuteApp(CmdPath : string; CmdShow : word) : longint;
function ConvertChar(TempStr : string; FromCh, ToCh : Char) : string;
function Unique83FileName(Extension : string) : string;
function ApplicationCmdShow : word;
function DelphiToUnixTime( DelphiTime: TDateTime ) : Comp;
function UnixToDelphiTime(UnixTime : Comp) : TDateTime;
function ItemFromList(ItemStr, Delimiter : string; ItemIndex : integer) : string;
function ItemsInList(ItemStr, Delimiter : string) : integer;
function PosInList(SearchStr, ItemStr, Delimiter : string) : integer;
function BuildListFromStringList(Delimiter : string; List : TStrings) : string;
function CountFilesInDir(const sDirectory, sFileSpec : string) : integer;
function DirExists(DirName : string) : boolean;
function MatchFileAttributes(Filename1,Filename2 : string) : integer;
function GetToken(var TokenList : string; Delimiter : char) : string;
function TokenCount(ItemStr : string; Delimiter : char) : integer;
function RemoveCRLFs(const OldStr : string) : string;
function RemoveExtension(Filename : string) : string;
function GetEmailName(Address : string) : string;
function GetEmailAddress(Address : string) : string;
function GetEmailDateTime(EmailDateTime : string) : TDateTime;
function CreateUniqueFilename(Basename,Extension : string) : string;
function FileTimeToDateTime(Time: TFileTime): TDateTime;

procedure DeleteDirectory(DirToDelete : string; DoYield : boolean);
procedure DeleteFiles(DirToDelete : string; DoYield : boolean);
procedure ViewFile(FileName,DefaultViewer,ErrorMsg : string);
procedure Delay(NumSecs : dword);
procedure MSDelay(NumMSecs : dword);
procedure DeleteIniField(Section,Field,IniFile : string);
procedure Log(LogFile, Msg : string);
procedure LogStrings(LogFile : string; LogText : TStrings);
procedure StringToStringList(ItemStr : string; Delimiter : char; Items : TStrings);
procedure CreateDirectoryStructure(Path : string);
procedure QuickSortSingle(List: TList);

implementation

uses
  SysUtils, Forms, StdCtrls, Dialogs, ShellAPI;


{ -------------------------------------------------------------------- }

function RemoveSpaces(TempStr : string) : string;

{ Return a string with all spaces removed }

begin
  while Pos(' ',TempStr) > 0 do             { Loop until all spaces removed }
    Delete(TempStr,Pos(' ',TempStr),1);

  RemoveSpaces := TempStr;
                                            { Return cleaned string }
end;  {  RemoveSpaces  }

{ -------------------------------------------------------------------- }

function RemoveChar(TempStr : string; Ch : char) : string;

{ Return a string with all Ch's removed }

begin
  while Pos(Ch,TempStr) > 0 do
    Delete(TempStr,Pos(Ch,TempStr),1);

  Result := TempStr;

end; 

{ -------------------------------------------------------------------- }

function FillStr(TempStr : string; Ch : char; Cnt : byte) : string;

{ Add spaces to the end of TempStr until its length equals Count }

begin
    If Cnt > Length(TempStr) then
      TempStr := TempStr + StringOfChar(Ch,Cnt - Length(TempStr));

    Result := TempStr;

end;  {  FillString  }

{ -------------------------------------------------------------------- }

function BackFill(TempStr : string; Ch : char; Count : byte) : string;

{ Add Ch to the front of TempStr until its length equals count }

begin
    If Count > Length(TempStr) then
      Insert(StringOfChar(Ch,Count - Length(TempStr)),TempStr,1);

    Result := TempStr;

end;  {  BackFill }


{ ------------------------------------------------------------ }

function UpperLower(StrToChange : string) : string;

{  Coverts a string to Upper and Lower case letters  }

var
  Temp    : byte;
  TempStr : string;

begin

{ * Clean this up }
{ * Fix bug in routine below (see the '+ 32') }

  TempStr := UpperCase(StrToChange);
  Temp    := 2;

  Repeat
    Case TempStr[Temp] of

      'A'..'Z' : TempStr[Temp] := Chr(Ord(TempStr[Temp]) + 32);

      #32,'_'  : Inc(Temp);

    end;  { Case }

    Inc(Temp);

  Until Temp > Length(StrToChange);

  Result := TempStr;

end;  {  UpperLower  }

{------------------------------------------------------------}

function ParseName(Name : string) : string;

{  Parses out the ',' in a name and put in order of First Last }

var
  Temp     : byte;
  TempName : string;

begin
  TempName := Trim(Name);

  Temp := POS(',', TempName);

  If  Temp <> 0 then
    TempName := Copy(TempName, Temp + 2, Length(TempName)) + ' ' +
                 Copy(TempName, 1, Temp - 1);

  Result := UpperLower(Trim(TempName));

end;  {  ParseName  }

{ ---------------------------------------------------------- }

function LeapYear(Year : word) : boolean;

{ Return True if Year is a leap year, false otherwise }

begin
  Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));

end;  {  LeapYear  }

{ ---------------------------------------------------------- }

function DaysPerMonth(AYear, AMonth: Integer): Integer;

{ Return integer specifying # of days in month indicated by AYear, AMonth }

const
  DaysInMonth: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

begin
  Result := DaysInMonth[AMonth];

  if (AMonth = 2) and LeapYear(AYear) then     { Leap-year Feb is special }
     Inc(Result);

end;

{ ---------------------------------------------------------- }

function JulianDay(Month,Day,Year : word) : word;

{ Return Julian Day for Month Day Year }

const
  Months : array [1..12] of word = (0,31,59,90,120,151,181,212,243,273,304,334);

begin
    If (Month > 2) and LeapYear(Year) then
      Result := Day + Succ(Months[Month])
    else
      Result := Day + Months[Month];

end;  {  JulianDay  }

{ ---------------------------------------------------------- }

function SwapByte(B : byte) : byte;  Assembler;

{ Swap Hi and Lo order nibbles of a byte }
{ Courtesy of Neil J. Rubenkind          }

ASM
    MOV AL, B           { byte in AL                }
    MOV AH, AL          { now in AH too             }
    MOV CL, 4           { set up to shift           }
    SHL AL, CL          { AL has low nibble -> high }
    SHR AH, CL          { AH has high nibble -> low }
    ADD AL, AH          { combine them 							}

end;  {  SwapByte  }

{ ---------------------------------------------------------- }

procedure DeleteDirectory(DirToDelete : string; DoYield : boolean);

{ Erase all files in directory and remove directory }

var
  DirInfo : TSearchRec;
  TempFile,
  TempDir : string;
  RCode   : integer;

begin
  TempDir := DirToDelete;

  If TempDir[Length(TempDir)] <> '\' then
    TempDir := TempDir + '\';

  RCode := FindFirst(TempDir + '*.*',faAnyFile - faDirectory,DirInfo);

  while RCode = 0 do
    begin
      TempFile := TempDir + DirInfo.Name;
      SysUtils.DeleteFile(TempFile);
      RCode := FindNext(DirInfo);

      If DoYield then
        Application.ProcessMessages;

    end;

  SysUtils.FindClose(DirInfo);

  Delete(TempDir,Length(TempDir),1);
  RmDir(DirToDelete);

end;  {  DeleteDirectory  }

procedure DeleteFiles(DirToDelete : string; DoYield : boolean);

{ Erase all files in directory }

var
  DirInfo : TSearchRec;
  TempFile,
  TempDir : string;
  RCode   : integer;

begin
  TempDir := DirToDelete;

  If TempDir[Length(TempDir)] <> '\' then
    TempDir := TempDir + '\';

  RCode := FindFirst(TempDir + '*.*',faAnyFile - faDirectory,DirInfo);

  If RCode = 0 then               // This is to handle the weird NT40 bug
    begin
      while RCode = 0 do
        begin
          TempFile := TempDir + DirInfo.Name;
          SysUtils.DeleteFile(TempFile);
          RCode := FindNext(DirInfo);

          If DoYield then
            Application.ProcessMessages;

        end;

      SysUtils.FindClose(DirInfo);

    end;

end;  {  DeleteFiles  }

{ ---------------------------------------------------------- }

function CopyFile(FromFile,ToFile : string) : word;

{ Copy FromFile to ToFile }

{ Returns: 0 if successful               }
{          1 if FromFile does not exist  }
{          2 if ToFile does exist        }
{          3 if FileSize of file is <= 0 }

var
  BytesRead,
  BytesWritten,
  SizeOfBuff   : longint;
  FFile,
  TFile        : file;
  Buffer       : pointer;

begin
  If FileExists(FromFile) then
    If not FileExists(ToFile) then
      begin
        AssignFile(FFile,FromFile);
        FileMode := 34;                      { Open file in shared mode - W Denied }
        Reset(FFile,1);

        SizeOfBuff := FileSize(FFile);

        If SizeOfBuff > 0 then
          begin
            If SizeOfBuff > 65528 then
              SizeOfBuff := 65528;

            GetMem(Buffer,SizeOfBuff);

            AssignFile(TFile,ToFile);
            FileMode := 18;                      { Open file in shared mode - R/W Denied }
            ReWrite(TFile,1);

            FileMode := 2;                       { Return filemode to default setting }

            repeat
              BlockRead(FFile,Buffer^,SizeOfBuff,BytesRead);
              BlockWrite(TFile,Buffer^,BytesRead,BytesWritten);
            until (BytesRead <= 0) or (BytesRead <> BytesWritten);

            FreeMem(Buffer,SizeOfBuff);
            CloseFile(TFile);
            Result := 0;

          end
        else
          Result := 3;

        CloseFile(FFile);

      end
    else
      Result := 2

  else
    Result := 1;

end;  {  CopyFile  }

{ ---------------------------------------------------------- }

function GetExecutablePath : string;

{ Return the path of the executable specified by Module  }

var
  PathStr : string;

begin
  PathStr := ExtractFilePath(Application.ExeName);

  If PathStr[Length(PathStr)] <> '\' then             { Handle different responses from }
    PathStr := PathStr + '\';                         { different versions of windows   }

  Result := PathStr;

end;  {  GetExecutablePath  }


{ ---------------------------------------------------------- }

function ExecuteAndWait(CmdPath,ErrorMsg : string; CmdShow : word) : longint;

{ Execute the CmdPath and wait for the task to end }

var
  IH       : word;
  CCmdPath : array [0..255] of char;

begin
  Result := 0;                              { Assume successful return }

  StrPCopy(CCmdPath,CmdPath);
  IH := WinExec(CCmdPath,CmdShow);          { Execute the unzip command string }

  If IH <= 32 then                          { If the execute didn't start successfully... }
    begin
      ShowMessage(ErrorMsg);
      Result := -1;                         { Execute failed, let caller know }
    end;

{ * The following code is stubbed out till I can resolve using 'CreateProcess' }

//  else
//    Repeat                                  { Hang out here until task returns }
//      Application.ProcessMessages;
//    Until GetModuleUsage(IH) = 0;

end;  {  ExecuteAndWait  }

{ ---------------------------------------------------------- }

function ExecuteApp(CmdPath : string; CmdShow : word) : longint;

{ Execute the CmdPath }

var
  IH        : word;
  CCmdPath  : array [0..255] of char;

begin
  Result := 0;                              { Assume successful return }

  StrPCopy(CCmdPath,CmdPath);
  IH := WinExec(CCmdPath,CmdShow);          { Execute the unzip command string }

  If IH <= 32 then                          { If the execute didn't start successfully... }
    Result := -1;                           { Execute failed, let caller know }

end;  {  ExecuteApp  }

{ ---------------------------------------------------------- }

function GetIniFilePath : string;

var
  TempStr  : array [0..255] of char;
  PathStr,
  FileName : string;

begin
  PathStr := ExtractFilePath(Application.ExeName);
  FileName := ExtractFileName(Application.ExeName);

  If PathStr[Length(PathStr)] = '\' then              { Handle different responses from }
    Delete(PathStr,Length(PathStr),1);                { different versions of windows   }

  Filename := ChangeFileExt(FileName,'.ini');

  If not FileExists(PathStr + '\' + FileName) then
    begin
      GetWindowsDirectory(TempStr,255);     { Build inifile path as if the file was  }

      If not FileExists(StrPas(TempStr) + '\' + FileName) then  { If it's in the windows directory...    }
        Result := PathStr + '\' + FileName
      else
        Result := StrPas(TempStr) + '\' + FileName;

    end
  else
    Result := PathStr + '\' + FileName;

end;

{ ---------------------------------------------------------- }

function AddTrailingSlash(Path : string) : string;

begin
  If Length(Path) > 0 then
    If Path[Length(Path)] <> '\' then
      Result := Path + '\'
    else
      Result := Path
  else
    Result := '\';  

end;  {  AddTrailingSlash  }

{ ---------------------------------------------------------- }

function IToHex(Num : longint) : string;

{ Convert Num to a hex number }

var
  Temp    : longint;
  TempStr : string;

begin
  If Num = 0 then                      { If 0 was passed in... }
    Result := '0'                      { Return '0'            }
  else
    begin
      while Num > 0 do                 { While digits remain... }
        begin
          Temp := Num and $F;          { Get a digit }
          Num := Num shr 4;            { Slide that digit off the end }

          If Temp >= 10 then           { Convert to char and insert in string }
            Insert(Chr(Temp - 10 + Ord('A')),TempStr,1)
          else
            Insert(Chr(Temp + Ord('0')),TempStr,1);

        end;

      Result := TempStr;               { Return hex string }

    end;

end;  {  IToHex  }

{ ---------------------------------------------------------- }

function HexToI(TempStr : string) : longint;

{ Convert TempStr from Hex to a longint }

var
  I,
  Temp : longint;

begin
  Temp := 0;                                     { Start with 0 }

  for I := 1 to Length(TempStr) do               { For each hex digit... }
    begin
      Temp := (Temp shl 4) + Ord(TempStr[I]);    { Shift temp, add digit }

      If Ord(TempStr[I]) >= Ord('A') then        { Remove ascii adjustment }
        Temp := Temp - Ord('A') + 10
      else
        Temp := Temp - Ord('0');

    end;

  Result := Temp;                                { Return the value }

end;  {  HexToI  }

{ ---------------------------------------------------------- }

procedure ViewFile(FileName,DefaultViewer,ErrorMsg : string);

var
  IH        : THandle;
  TempStr   : string;
  TempCStr  : array [0..255] of char;

begin
  StrPCopy(TempCStr,FileName);

  IH := ShellExecute(Application.Handle,nil,TempCStr,nil,nil,SW_SHOWNORMAL);

  If IH = 31 then
    begin
      If (DefaultViewer <> '') and FileExists(DefaultViewer) then
        begin
          StrPCopy(TempCStr,DefaultViewer + ' ' + FileName);
          IH := WinExec(TempCStr,SW_SHOWNORMAL);

          If IH <= 32 then
            begin
              TempStr := ErrorMsg + #13'Error [' + IntToStr(IH) + ']';
              StrPCopy(TempCStr,TempStr);
              MessageBeep(mb_IconStop);
              Application.MessageBox(TempCStr,'Error',mb_Ok or mb_IconStop);
            end;

        end
      else
        begin
          MessageBeep(mb_IconStop);
          Application.MessageBox('Specified default viewer path does not exist',
            'Error',mb_Ok or mb_IconStop);
        end;

    end
  else
    If IH <= 30 then
      begin
        TempStr := ErrorMsg + #13'Error [' + IntToStr(IH) + ']';
        StrPCopy(TempCStr,TempStr);
        MessageBeep(mb_IconStop);
        Application.MessageBox(TempCStr,'Error',mb_Ok or mb_IconStop);
      end;

end;

{ ---------------------------------------------------------- }

procedure Delay(NumSecs : dword);

var
  Finish : dword;

begin
  Finish := GetTickCount + Trunc(NumSecs * 1000);

  repeat
    Application.ProcessMessages;
  until GetTickCount > Finish;

end;

{ ---------------------------------------------------------- }

procedure MSDelay(NumMSecs : dword);

var
  Finish : dword;

begin
  Finish := GetTickCount + NumMSecs;

  repeat
    Application.ProcessMessages;
  until GetTickCount > Finish;

end;

{ ---------------------------------------------------------- }

function GetEnvVar(EnvVar : string) : string;

var
  TempEnvVar,
  Buffer     : array [0..255] of char;

begin
  StrPCopy(TempEnvVar,EnvVar);

  If GetEnvironmentVariable(TempEnvVar,Buffer,SizeOf(Buffer)) > 0 then
    Result := StrPas(Buffer)
  else
    Result := '';

end;

{ ---------------------------------------------------------- }

procedure DeleteIniField(Section,Field,IniFile : string);

{ Delete specified field entry from an ini file }

var
  cIniFile,
  cSection,
  cField : array [0..255] of char;

begin
  StrPCopy(cIniFile,IniFile);
  StrPCopy(cSection,Section);
  StrPCopy(cField,Field);

  WritePrivateProfileString(cSection,cField,NIL,cIniFile);

end;

{ ---------------------------------------------------------- }

function ConvertChar(TempStr : string; FromCh, ToCh : Char) : string;

var
  Counter : integer;

begin
  Result := TempStr;

  for Counter := 1 to Length(Result) do
    If Result[Counter] = FromCh then
      Result[Counter] := ToCh;

end;

{ ---------------------------------------------------------- }

function Unique83FileName(Extension : string) : string;

var
  TempStr : string;

begin
  TempStr := IntToStr(GetTickCount);

  If Length(TempStr) > 8 then
    Delete(TempStr,1,Length(TempStr) - 8);

  Result := TempStr + '.' + Extension;

end;

{ ---------------------------------------------------------- }

procedure Log(LogFile, Msg : string);

{ Dump string to log file.  Insert data/time stamp. }

{ * Needs retries to handle multitasking environment. }

var
  OutFile : textfile;

begin
  If LogFile <> '' then
    begin
      AssignFile(OutFile,LogFile);

      try
        If SysUtils.FileExists(LogFile) then
          Append(OutFile)
        else
          ReWrite(OutFile);

        Writeln(OutFile,FormatDateTime('MM-DD-YY HH:MM',Now) + '  ' + Msg);

        Close(OutFile);
      except
        begin

{ * Should we handle this }

        end;
      end;

    end;

end;


{------------------------------------------------------------------------------
  Name:         ApplicationCmdShow

  Description:  Returns a value of cmdShow that was passed to the application.
                Under Delphi 2.x, there is a bug in which the value of the
                global variable cmdShow is not initialized correctly.  If you
                want the correct value, use this function.

                Example:    // place this in your Form's OnCreate method
                            ShowWindow(Handle, ApplicationCmdShow);

                (This is extremely nice if you want your app to be able to
                 be launched minimized).

  Parameters:   n/a

  Return Value: word - the value of cmdShow

  Comments:     none

  Revisions:    Date     By  Description
                -------- --- -------------------------------------------------
                09/11/96 grr Implemented.

 -----------------------------------------------------------------------------}

function ApplicationCmdShow : word;

var
  lpStartupInfo : TStartUpInfo;

begin
  GetStartUpInfo(lpStartUpInfo);
  Result := lpStartUpInfo.wShowWindow;

end;

{ ---------------------------------------------------------- }

procedure LogStrings(LogFile : string; LogText : TStrings);

{ Dump strings contained in LogText to LogFile. May be called with logfile }
{ not specified (I do it all the time -rp). Clear list when done.          }
{                                                                          }
{ * Needs retries added to handle multi-tasking environment better.        }

var
  OutFile    : textfile;
  Counter    : integer;

begin
  If LogFile <> '' then
    begin
      AssignFile(OutFile,LogFile);

      try
        If FileExists(LogFile) then
          Append(OutFile)
        else
          ReWrite(OutFile);

        for Counter := 0 to LogText.Count - 1 do
          Writeln(OutFile,LogText[Counter]);

        CloseFile(OutFile);

        LogText.Clear;

      except
        begin

{ * Should we do something to handle this? }

        end;

      end;

    end;

end;

{ ---------------------------------------------------------- }

function DelphiToUnixTime(DelphiTime : TDateTime) : Comp;

{ Delphi time is days since 12/31/1899 (e.g. 1/1/1900 = 1.0), while  Unix time }
{ is seconds since 1/1/1970.                                                   }

begin
  Result := ( DelphiTime - 25569.0 ) * 86400;

end;

{ ---------------------------------------------------------- }

function UnixToDelphiTime(UnixTime : Comp) : TDateTime;

{ Delphi time is days since 12/31/1899 (e.g. 1/1/1900 = 1.0), while  Unix time }
{ is seconds since 1/1/1970.                                                   }

begin
  Result := (UnixTime / 86400) + 25569.0;

end;

{ ---------------------------------------------------------- }

procedure StringToStringList(ItemStr : string; Delimiter : char; Items : TStrings);

{ Move items in ItemStr (delimited by Delimiter) into Items stringlist }

begin
  while Length(ItemStr) > 0 do
    Items.Add(GetToken(ItemStr,Delimiter));

end;

{ ---------------------------------------------------------- }

function ItemFromList(ItemStr, Delimiter : string; ItemIndex : integer) : string;

{ Return ItemIndex'th item from ItemStr list.  ItemStr should be delimeted with }
{ Delimiter.  Ex: ItemFromList('Oranges|Apples|Cranberries','|',2) would return }
{ 'Cranberries'.                                                                }

var
  Counter,
  Index   : integer;
  TempStr : string;

begin
  Result := '';

  Counter := 0;

  while Length(ItemStr) > 0 do
    begin
      Index := Pos(Delimiter,ItemStr);

      If Index > 0 then
        begin
          TempStr := Copy(ItemStr,1,Index - 1);
          System.Delete(ItemStr,1,Index);
        end
      else
        begin
          TempStr := ItemStr;
          ItemStr := '';
        end;

      If ItemIndex = Counter then
        begin
          Result := TempStr;
          Exit;
        end;

      Inc(Counter);

    end;

end;

{ ---------------------------------------------------------- }

function ItemsInList(ItemStr, Delimiter : string) : integer;

{ Returns count of instances of Delimiter in ItemStr + 1 }

var
  Counter,
  Index   : integer;

begin
  Counter := 0;

  // if the input string ends with the delimiter, go ahead
  // and increment the counter. ('Hi|' should have 2 tokens)
  if (Copy(ItemStr,Length(ItemStr),1) = Delimiter) then
    Inc(Counter);

  while Length(ItemStr) > 0 do
    begin
      Index := Pos(Delimiter,ItemStr);

      If Index > 0 then
        System.Delete(ItemStr,1,Index)
      else
        ItemStr := '';

      Inc(Counter);

    end;

  Result := Counter;

end;

{ ---------------------------------------------------------- }

// Returns index of SearchStr in ItemStr or -1 if it isn't there

function PosInList(SearchStr, ItemStr, Delimiter : string) : integer;

var
  Counter : integer;

begin
  Result := -1;

  If (Length(Delimiter) > 0) and (SearchStr <> '') then
    begin
      Counter := 0;

      while ItemStr <> '' do
        begin
          If SearchStr = GetToken(ItemStr,Delimiter[1]) then
            begin
              Result := Counter;
              Break;
            end;

          Inc(Counter);

        end;

    end;

end;

{ ---------------------------------------------------------- }

function BuildListFromStringList(Delimiter : string; List : TStrings) : string;

{ Build and return string by concatenating items from list delimited by Delimiter }

var
  Counter : integer;

begin
  Result := '';

  for Counter := 0 to List.Count - 1 do
    If Length(Result) <= 0 then
      Result := List[Counter]
    else
      Result := Result + Delimiter + List[Counter];

end;

{ ---------------------------------------------------------- }

function CountFilesInDir(const sDirectory, sFileSpec : string) : integer;

var
  SearchRec  : TSearchRec;
  sTempDir   : string;
  iRC        : longint;
  iFileCount : integer;

begin
  iFileCount  := 0;
  sTempDir    := AddTrailingSlash(sDirectory);

  try
    iRC := FindFirst(sTempDir + sFileSpec, faAnyFile, SearchRec);
    while (iRC = 0) do
    begin
      inc(iFileCount);
      iRC := FindNext(SearchRec);
    end;
  except
    iFileCount := 0;
  end;

  SysUtils.FindClose(SearchRec);
  result := iFileCount;

end;

{ ---------------------------------------------------------- }

procedure QuickSortSingle(List: TList);

{ Sort items in a TList by their handles }

procedure Sort(L,R: Integer);

var
  V : Single;
  I,
  J : Integer;

begin
  if L < R then
    begin
      with List do
        begin
          V:=Single(Items[R]);
          I:=Pred(L);
          J:=R;

          repeat
            repeat
              Inc(I);
            until Single(Items[I]) >= V;

            repeat
              Dec(J);
            until Single(Items[J]) <= V;

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
  Sort(0,List.Count - 1);

end;

{ ---------------------------------------------------------- }

function DirExists(DirName : string) : boolean;

{ Return True if DirName exists, false otherwise.  Note: Dirname must be a directory. }

var
  SearchRec : TSearchRec;
  RC        : integer;

begin
  If DirName[Length(DirName)] = '\' then    // Get rid of trailing '\' character
    Delete(DirName,Length(DirName),1);

  RC := SysUtils.FindFirst(DirName,faDirectory,SearchRec);

  If (RC = 0) and (SearchRec.Attr and faDirectory > 0) then
    Result := True
  else
    Result := False;

  SysUtils.FindClose(SearchRec);

end;

{ ---------------------------------------------------------- }

function MatchFileAttributes(Filename1,Filename2 : string) : integer;

// Set attributes on Filename2 to match those of Filename1. Return status code.

var
  Attributes : integer;
  FileDate,
  FileHandle1,
  FileHandle2 : Integer;

begin
  Result := -1;

  If FileExists(Filename1) and FileExists(Filename2) then
    begin
      FileHandle1 := FileOpen(FileName1,fmOpenRead or fmShareDenyNone);

      if FileHandle1 > 0 then
        begin
          FileHandle2 := FileOpen(FileName2,fmOpenWrite or fmShareDenyNone);

          if FileHandle2 > 0 then
            begin
              FileDate := FileGetDate(FileHandle1);
              FileSetDate(FileHandle2,FileDate);

              FileClose(FileHandle2);
            end;

          FileClose(FileHandle1);
        end
      else
        Exit;

      Attributes := FileGetAttr(Filename1);
      Result := FileSetAttr(Filename2,Attributes);

    end;

end;

{ ---------------------------------------------------------- }

procedure CreateDirectoryStructure(Path : string);

// Take Path, break into list of directories.  Validate each, creating
//  if it doesn't exist.
// This code assumes an explicit path: either driveletter:path or UNC based.

var
  CurrPath,
  Root,
  TempStr : string;
  Index : integer;

begin
  If Pos('\',Path) > 0 then
    begin
      TempStr := ExtractFilePath(Path);

      If TempStr[2] = ':' then                   // Normal path, i.e. C:\blah
        begin
          Root := Copy(TempStr,1,3);
          Delete(TempStr,1,3);
        end
      else
        If Copy(TempStr,1,2) = '\\' then        // UNC path, i.e. \\server\share\blah
          begin
            Delete(TempStr,1,2);

            Index := Pos('\',TempStr);

            If Index > 0 then
              begin
                Root := '\\' + Copy(TempStr,1,Index);
                Delete(TempStr,1,Index);

                Index := Pos('\',TempStr);

                If Index > 0 then
                  begin
                    Root := Root + Copy(TempStr,1,Index);
                    Delete(TempStr,1,Index);
                  end;

              end;

          end;

      If Root <> '' then                         // Here's the actual loop to
        begin                                    //  handle the path building
          Currpath := '';

          Index := Pos('\',TempStr);

          while Index > 0 do
            begin
              If CurrPath <> '' then
                CurrPath := CurrPath + '\';

              CurrPath := CurrPath + Copy(TempStr,1,Index - 1);
              Delete(TempStr,1,Index);

              If not DirExists(Root + CurrPath) then
                CreateDir(Root + CurrPath);

              Index := Pos('\',TempStr);

            end;

        end;

    end;

end;

{ ---------------------------------------------------------- }

function GetToken(var TokenList : string; Delimiter : char) : string;

{ Return next token from token list where delimited by Delimiter. }
{   Ex: GetToken('orange|apple|pear','|')  returns 'orange'       }
{                                                                 }
{ Note: TokenList will be modified to remove the returned token.  }

var
  Counter : integer;

begin
  for Counter := 1 to Length(TokenList) do
    If TokenList[Counter] = Delimiter then
      begin
        Result := Copy(TokenList,1,Counter - 1);
        Delete(TokenList,1,Counter);
        Exit;
      end;

  Result := TokenList;
  TokenList := '';

end;

{ ---------------------------------------------------------- }

function TokenCount(ItemStr : string; Delimiter : char) : integer;

{ Returns count of instances of Delimiter in ItemStr + 1 }

var
  Counter : integer;

begin
  Result := 1;

  for Counter := 1 to Length(ItemStr) do
    If ItemStr[Counter] = Delimiter then
      Inc(Result);

end;

{ ---------------------------------------------------------- }

function RemoveCRLFs(const OldStr : string) : string;

// Replace all CRLF pairs in string with ' '

var
  Index : integer;

begin
  Result := OldStr;

  for Index := Length(Result) - 1 downto 1 do
    If Result[Index] = #13 then
      If Copy(Result,Index + 1,1) = #10 then
        begin
          Delete(Result,Index,1);
          Result[Index] := ' ';
        end;

end;

{ ---------------------------------------------------------- }

function RemoveExtension(Filename : string) : string;

// Return filename (and path) minus extension

var
  Counter : integer;

begin
  Result := Filename;

  for Counter := Length(Filename) downto 1 do
    If Filename[Counter] = '.' then
      begin
        Delete(Filename,Counter,Length(Filename));
        Result := Filename;
        Break;
      end;

end;

{ ---------------------------------------------------------- }

function GetEmailName(Address : string) : string;

// Return Name portion of email address
//
//  Ex #1:
//    GetEmailName('"Richard Phillips" <richardp@dallas.net>') = 'Richard Phillips'
//
//  Ex #2:
//    GetEmailName('richardp@dallas.net (Richard Phillips)') = 'Richard Phillips'
//
//  Ex #3:
//    GetEmailName('richardp@dallas.net') = 'richardp@dallas.net'

var
  Index : integer;

begin
  Address := RemoveChar(Address,'"');

  Index := Pos('<',Address);

  If Index > 1 then
    begin
      Delete(Address,Index,Length(Address));
    end
  else
    If Index = 1 then
      begin
        Address := Copy(Address,2,Length(Address));

        Index := Pos('>',Address);

        If Index > 0 then
          Delete(Address,Index,Length(Address));

      end
    else
      begin
        Index := Pos('(',Address);

        If Index > 0 then
          begin
            Address := Copy(Address,Index + 1,Length(Address));

            Index := Pos(')',Address);

            If Index > 0 then
              Delete(Address,Index,Length(Address));

          end;

      end;

  Result := Trim(Address);

end;

{ ---------------------------------------------------------- }

function GetEmailAddress(Address : string) : string;

// Return Address portion of email address
//
//  Ex:
//    GetEmailName('"Richard Phillips" <richardp@dallas.net>') = 'richardp@dallas.net'

var
  Index : integer;

begin
  Index := Pos('<',Address);

  If Index > 0 then
    begin
      Address := Copy(Address,Index + 1,Length(Address));

      Index := Pos('>',Address);

      If Index > 0 then
        Delete(Address,Index,Length(Address));

    end;

  Result := Trim(Address);

end;

{ ---------------------------------------------------------- }

function GetEmailDateTime(EmailDateTime : string) : TDateTime;

const
  cMonths : array [1..12] of string = ('Jan','Feb','Mar','Apr','May','Jun',
                                       'Jul','Aug','Sep','Oct','Nov','Dec');

var
  TempStr2,
  TempStr : string;
  Index : integer;
  TempTime,
  Modifier : TDateTime;

// - - - - - - - -

function MonthToNum(Month : string) : string;

var
  Counter : integer;

begin
  Result := '12';

  for Counter := 1 to 11 do
    If Month = cMonths[Counter] then
      begin
        Result := IntToStr(Counter);
        Break;
      end;

end;

// - - - - - - - -

begin
  If EmailDateTime <> '' then
    begin
      Index := Pos(',',EmailDateTime);

      If Index > 0 then                         // Remove leading 'Mon' if necessary
        Delete(EmailDateTime,1,Index);

      EmailDateTime := Trim(EmailDateTime);

      TempStr := GetToken(EmailDateTime,' ');                                    // Day
      TempStr := MonthToNum(GetToken(EmailDateTime,' ')) + '/' + TempStr + '/';  // Month

      TempStr2 :=GetToken(EmailDateTime,' ');                                    // Year

      If Length(TempStr2) = 4 then
        TempStr := TempStr + Copy(TempStr2,3,2)
      else
        TempStr := TempStr + TempStr2;

      TempTime := StrToTime(GetToken(EmailDateTime,' '));

      Application.ProcessMessages;

      If Length(EmailDateTime) = 5 then                                          // Delta from GMT
        begin
          Modifier := StrToTime(Copy(EmailDateTime,2,2) + ':' + Copy(EmailDateTime,4,2) + ':00');

          If EmailDateTime[1] = '-' then
            Modifier := Modifier * -1;

          TempTime := TempTime + Modifier;

        end;

      TempStr := TempStr + ' ' + TimeToStr(TempTime);                            // Time

      Result := StrToDateTime(TempStr);

    end
  else
    Result := Now;

end;

{ ---------------------------------------------------------- }

function CreateUniqueFilename(Basename,Extension : string) : string;

// Create a unique filename (by adding integers on) from Basename and Extension

var
  Counter : integer;

begin
  Counter := 0;

  Result := BaseName + '.' + Extension;

  while FileExists(Result) do
    begin
      Result := BaseName + IntToStr(Counter) + '.' + Extension;
      Inc(Counter);
    end;

end;

{ ---------------------------------------------------------- }

function FileTimeToDateTime(Time: TFileTime): TDateTime;

begin
  Result := (Time.dwLowDateTime / 86400.0E7) +
   (Time.dwHighDateTime * 65536.0 * 65536.0 / 86400.0E7) - 109205;

end;

{ ---------------------------------------------------------- }

end.
