(***************************************************************************
                               IceLock, v2.0b
                               ==============

                       Copyright 1996,97 -  B. Walker
                          IceBrakr@ix.netcom.com


  See the end of this section for history information, and new features!

  Well folks, here it is, finally, the new version! This is the easiest way to
handle registration of your delphi applications.  Or, at least, the easiest
for me.  Oh, and legal stuff, this component is FreeWare, I make no
guarantees, or warranties of any kind, you use this at your own risk.  And
I definately do not guarantee it is secure.  I, and others, have tried to
hack using this, with no success...so It's probably "pretty good
protection"...nothing is perfect..

On to usage...

First, customize IceLock:

modify the following Constants:

        UserPad
        ProgPad
        MasterKey (this is an array of values for masking the record, when
                    written to a file)

** The defaults will work just fine, but, if you use the defaults, anybody
with this component can create valid keys for your applications!!. **

In the Create method modify the variable initialization for:

        fSeedVal1 { These can also be set at design time }
        fSeedVal2
        Seed { Set in the Create Method, because it's Private! }
    And any others you may wish to modify...

  This will make your copy of IceLock, ** much ** different from anybody
elses.  If you are really worried about hackers, read further into the
source, there are plenty of notes for further obfuscating the keys/files.

  Next, install this component in your component palette, it automatically
installs into the 'Samples' page.  Now, to use it, drop on your main form,
modify the properties (most particularly IceString1 and IceString2..
possibly also the KeyFileName).  And you are affectively done, for a
minimum install...call LoadKeyFile then either check the result of
LoadKeyFile, or check the IsRegistered variable to see if it's registered.

  A better example of usage is in the IceReg application, included with
version 1.0.  This application is a fully functional database, for
tracking users/applications and keys...  Make sure that you re-build this
application, using the copy of IceLock that you have modified/installed
into delphi...otherwise, the keys created will be invalid!.

** The Most important thing to remember!!  When you create keys for users, the
** fProgKey1 and fProgKey2 must be the same when you check the key!!!  This
** is why I suggest modifying the above mentioned const/variables, and then
** specify unique IceStrings for each application, this is the easiest way to
** go...(unless you find an easier way...)

  Last bit, have fun with this...  All I ask is that you give credit where
it is due....and if you come up with cool enhancements, please send them to
me, so I can keep track of modifications, and re-release with a new version
number...  If you find a hole, that you cannot plug, let me know, again, I
can probably plug it..and re-release.


History
-------

v1.0 - Initial release, with a few buggies.  After receiving a lot of
questions and suggestions ....requests for feature, and a new version
of the source code from Jorge Cue (Thanks!), we are now at....

v2.0 - Fixed the bugs (I hope), fixed the source code to compile under
Delphi version 1, 2 AND 3!!  Added the following files, so you do not
have to recompile the library everytime you switch from different versions
of Delphi.  Note: There may still be a problem using it in Delphi1, if you
first install in 2/3, If you get Unit file format error, just erase
ICELOCK.DCU, and Delphi will rebuild it:

       ilock16.pas  : Delphi 1 component.
       ilock32.pas  : Delphi 2 component.
       ilock332.pas : Delphi 3 component.

     - All version will support the same key! (assuming your program is
     using the same IceString1 and IceString2.  Also, now the ProgramKeys
     should calculate the same for all versions.  NOTE: The key files are
     transportable in both 32-bit versions, but the 32-bit keys will not
     work in 16-bit (see below)
     - Jorge Cue had added a HDSerialNumber to the registration record.
     problem is, he had to use ASM to get the HD Serial.  This works when
     compiled using D1, but only under Win95 (or something like that).  I
     modified his GetHdSerialNumber to be a little more portable, if not
     as secure under Win3.1.  For 16-bit apps, I use GetWinFlags to get a
     longint with information about the current version and operating mode
     of windows.  Under Win32 I use the Win32 API function GetVolumeInformation
     to actually get the HD serial number.  These procedures will require
     a user to re-enter his/her Registered Name and Key if the environment/
     HD serial number changes.
     - The last change Jorge Cue implemented was, Licensetype.  In the
     code he sent me, he used an enumerated type, I changed it to a
     boolean property "DemoLicense".  This will be set to true when a user
     enters a key you have generated with DemoLicense set to true.  I also
     added a TrialDays property, that lets you select the number of days
     a trial license is good for.  This way, when a user enters their key,
     and it happens to be a demo key, the systems automatically generates
     an expiration date, and includes it in the key.  This requires that
     you program not allow them to enter the key again!  Of course,
     users could just delete the key and start again...of course you
     could modify the program to put the key somewhere strange (or even the
     registry), and maybe mark it read-only/hidden....on and on...sorry, I'm
     rambling.
     - Now LoadKey will return ieExpired or ieNotSameHD if the license
     is expired, or the environment/HDserial changes.  See error constants
     for the rest.
     - New (cheezy...and much smaller) demo program.  Very basic.  For a more
     detailed demo, get Icelock 1.0
     - Oh, and last, but not least, the source code is not as heavily
     commented as v1.0.  Sorry, but I lack the ambition to comment it again
     with all the changes.

Thanks again to Jorge Cue, and all the other folks who have given
me feedback on this (and in one case sent me a license to a spiffy
Delphi 1.0 expert!)

****************************************************************************)

unit IceLock;

interface

uses
  Classes;

const
(** Error Constants **)
  ieOkay        = 0; { Everything Okay }
  ieInvalidKey  = 1; { Key is invalide }
  ieFileError   = 2; { Some file error occurred, check LastIoResult for }
                     { error code                                       }
  ieNotSameHD   = 3; {+++ This KeyFile was not make on this Hard Disk   }
  ieExpired     = 4; {+++ Temporary License Has Expired                 }

(** Feel free to change these to mind fuck others, this allows an
 added level of security against other programers who have this code **)
  UserPad       = #42;
  ProgPad       = #42;

{$I CRCTAB.INC } { The CRC Lookup Table.. You're best bet is to NOT MUCK  }
                 { WITH THIS!!  If you do, it could affect the security   }
                 { of the keys..                                          }

type
  {$IFDEF WIN32}
  sstring = ShortString;
  {$ELSE}
  sstring = string;
  {$ENDIF}

  { String for holding Keys }
  KeyString   = String[9];

  { String for holding Names }
  NameString  = String[50];


  rIceRecord  = record
    Name          : NameString;
    Key           : KeyString;
    HDSerialNo    : LongInt;       {+++ New field to hold HD Serial Number }
    DemoLicense   : Boolean;  {+++ Keep License Type As Required      }
    ExpirationDate: TDateTime;     {+++ Date ltTemporary license is over   }
  end;

  { This is a Record and it's associated pointer, which is used to
    "encrypt/decrypt" the IceRecord, before storage in a file...
    Note that it will adjust to any changes made to rIceRecord.. }
  aIceArray = Array[1..SizeOf(rIceRecord)] of Byte;
  pIceArray = ^aIceArray;

  { Buffer for calculating CRC values }
  CRCBuffType = ARRAY[0..70] OF BYTE;

(**************************************************************************)
(***                                                                    ***)
(*** Here it is!!!  The tIceLock Component!!                            ***)
(***                                                                    ***)
(**************************************************************************)
  tIceLock = class(TComponent)
  private
(** The following fields are available for design time modification, via
    the object inspector.  Note that they are all read directly from the
    variable, but written using the appropriate Set procedure            **)

{ Ice1/Ice2, these two are character strings used to build the
  corresponding ProgKeys, which identify the program that the key belongs
  to.  These allow you to create keys for specific application.
  Note that these keys will be truncated to 70 characters.                 }
    fIce1 : sstring;
    fIce2 : sstring;

{ Created, based on Ice1/Ice2, also the user can override these values
  via the object inspector or the corresponding Properties.  This allows
  ANOTHER level of security, in that you could define them anywhere in
  your code, multiple times...etc... BUT!!!  You must make sure that they
  are the same when you generate keys for your registered users!!
  Otherwise, you'll be giving them bogus keys!!!!                         }
    fProgKey1 : LongInt;
    fProgKey2 : LongInt;

{ Another level of security, these are the seed values, used to create
  the ProgKeys, based on Ice, you can changes these also..             }
    fSeedVal1 : LongInt;
    fSeedVal2 : LongInt;

{ Kind of obvious, this hold the file name for your keys, again allows
  different key names for different applications }
    fKeyFileName : sstring;

(** The following Private fields/procedure, are really private!, ie: no
    direct access at all                                                 *)
    Seed          : LongInt;       { Set in Create                 }
    UserName      : NameString;    { Set by LoadKeyFile, or PutKey }
    UserKey       : KeyString;     { Set by LoadKeyFile, or PutKey }
    fDemoLicense  : Boolean;       {+++ Set by LoadKeyFile }
    fExpirationDate: TDateTime;    {+++ Set by LoadKeyFile or SetExpirationDate }
    fTrialDays : Integer; { Number of days for demo license }

    { Procedures used to set Private variables }
    procedure SetIce1(s : sstring);
    procedure SetIce2(s : sstring);
    procedure SetProgKey1(l : LongInt);
    procedure SetProgKey2(l : LongInt);
    procedure SetSeedVal1(l : LongInt);
    procedure SetSeedVal2(l : LongInt);
    procedure SetKeyFileName(fn : sstring);

    { Procedures used internally only ! }
    procedure EncryptRecord(p : Pointer);
    function  CalcCRCBuffer(CRC_Value: LONGINT;
                            cBuffer: CRCBuffType ): LONGINT;
    function  HexLongInt(L : LongInt) : KeyString;
    procedure InitProgramKeys;
    {+++ This function gets the Hard Disk Serial Number }
    function GetHDSerialNumber: LongInt;
    procedure SetExpirationDate(ed: TDateTime);

    function GetExpirationDate: TDateTime;
    { End Private declarations }
  protected
    { End Protected declarations }
  public
    LastIoResult  : integer; { Holds the last ioresult from save/loadkeyfile }
    IsRegistered  : boolean; { nuff said }

    { Creates a key, based on ProgKey1/ProgKey2/Name, returns KeyString }
    function BuildUserKey(Name : NameString; IsDemo : boolean) : KeyString;

    { Checks a Name/Key combination, returns boolean result }
    Function CheckKey(n : NameString;k : KeyString) : boolean;

    { Get's the current value of UserName or UserKey }
    function GetKey  : KeyString;
    function GetName : NameString;

    { PutKey attempts to put Name/key into Username/Userkey, returns
      result ieOkay if successful, ieInvalidKey for invalid key,
      If the key is invalid Username/Userkey are not change          }
    function PutKey(name : NameString; Key : KeyString) : integer;

    { These two functions save/load current key to the currently selected
      fKeyFileName Property..                                             }
    function SaveKeyFile : Integer;
    function LoadKeyFile : Integer;


    { The obvious create/destroy thingies....}
    constructor Create(AOwner: TComponent); override;
    { End Public declarations }
  published
    { Note: IceString1, IceString2, IceSeed1, IceSeed2 Must be alphabetically
    less that ProgramKey1 and ProgramKey2!!  Delphi sets these values, from
    information created at design time, in the Object Inspector, in Alpha Order.
    ....anytime you set any Ice value, the component re-initializes the
    Program Keys....so if they came first (alpha-wise), any changes you
    made during design time, would not stick!!  This should keep things
    properly synchronised..}

    property IceString1  : sstring read fIce1 write SetIce1;
    property IceString2  : sstring read fIce2 write SetIce2;
    property IceSeed1    : LongInt read fSeedVal1 write SetSeedVal1;
    property IceSeed2    : LongInt read fSeedVal2 write SetSeedVal2;
    property ProgramKey1 : LongInt read fProgKey1 write SetProgKey1;
    property ProgramKey2 : LongInt read fProgKey2 write SetProgKey2;
    property KeyFile     : sstring read fKeyFileName write SetKeyFileName;
    property TrialDays   : integer read fTrialDays write fTrialDays;
    property DemoLicense : Boolean read fDemoLicense write fDemoLicense;
    property ExpirationDate : tDateTime read GetExpirationDate write SetExpirationDate;
    { End Published declarations }
  end;


implementation

uses
  SysUtils, {+++ Date }
  WinProcs; {+++ DOS3Call }



{==============================

   >>  procedure tIceLock.SetIce1(s : string);

    >  Description : Set's value for fIce1, then re-inits the
                     program keys based on the new value.
                     Truncates passed string to 70 Characters.

 ==============================}
procedure tIceLock.SetIce1(s : sstring);
begin
  if length(s) < 71 then fIce1 := s
    else fIce1 := copy(s,1,70);
  InitProgramKeys;
end;

{==============================

   >>  procedure tIceLock.SetIce2(s : string);

    >  Description : See SetIce1

 ==============================}
procedure tIceLock.SetIce2(s : sstring);
begin
  if length(s) < 71 then fIce2 := s
    else fIce2 := copy(s,1,70);
  InitProgramKeys;
end;

{==============================

   >>  procedure tIceLock.SetProgKey1(l : LongInt);

    >  Description : This allows the programmer to set an absolute
                     value for the Program keys.  Note, if you
                     do this, you MUST make sure to create keys
                     using this ProgramKey..otherwise you'lL be
                     creating useless keys!!

                     Also, if you change either Ice or SeedVal's
                     (which call InitProgramKeys), your changes
                     will be erased!  This may be usefull to
                     confound hackers...maybe set values a few
                     times, then change an IceString....  This
                     could be very frustrating, hacking the ASM
                     code...

 ==============================}
procedure tIceLock.SetProgKey1(l : LongInt);
begin
  fProgKey1 := l;
end;


{==============================

   >>  procedure tIceLock.SetProgKey2(l : LongInt);

    >  Description : see SetProgKey1

 ==============================}
procedure tIceLock.SetProgKey2(l : LongInt);
begin
  fProgKey2 := l;
end;

{==============================

   >>  procedure tIceLock.SetSeedVal1(l : LongInt);

    >  Description : This value is used to seed the CRC creation
                     process with a unique value.. Also re-inits
                     the ProgramKeys using the new value.

 ==============================}
procedure tIceLock.SetSeedVal1(l : LongInt);
begin
  fSeedVal1 := l;
  InitProgramKeys;
end;

{==============================

   >>  procedure tIceLock.SetSeedVal2(l : LongInt);

    >  Description : see SetSeedVal1

 ==============================}
procedure tIceLock.SetSeedVal2(l : LongInt);
begin
  fSeedVal2 := l;
  InitProgramKeys;
end;

{==============================

   >>  procedure tIceLock.SetKeyFileName(fn : string);

    >  Description : Sets the value for the KeyFileName.  Should
                     be set once at design-time... Remember when
                     you create registration keys, the filename
                     must match!

 ==============================}
procedure tIceLock.SetKeyFileName(fn : sstring);
begin
  fKeyFileName := fn;
end;


{==============================

   >>  procedure tIceLock.EncryptRecord(p : Pointer);

    >  Description : Encrypts (masks) the record, before saving
                     to a file.  You may very well wish to change
                     the values in MasterKey, for added security

    >  Input       : pointer to an IceArray

    >  Output      : Nothing, it directly modified the data via
                     'p'.

 ==============================}
procedure tIceLock.EncryptRecord(p : Pointer);
const
  MasterKey : array[0..7] of byte = {+++ Bug (x mod 8) ranges from 0 to 7 }
            (( 89),( 66),(128),(231),( 18),( 43),(113),( 67));

var
  pr : pIceArray;
  x  : byte;
begin
  pr := p;
  for x := 1 to sizeof(rIceRecord) do
  begin
    pr^[x] := pr^[x] xor masterkey[x mod 8];
  end;
end;



{==============================

   >>  function tIceLock.CalcCRCBuffer(CRC_Value: LONGINT;

    >  Description : Calculates a CRC value, for a CRC buffer.

    >  Input       : CRC_Value - This seed value for gen. CRC's
                     cBuffer   - the buffer to calculate

    >  Output      : Returns a longint CRC value.

 ==============================}
function tIceLock.CalcCRCBuffer(CRC_Value: LONGINT;
                                cBuffer: CRCBuffType ): LONGINT;
VAR
  nTemp1, nTemp2: LONGINT;
  i: byte;
BEGIN
  FOR i := 0 TO 70 DO
  BEGIN
    nTemp1 := (CRC_Value SHR 8) AND $00FFFFFF;
    nTemp2 := CRCtable[ (CRC_Value XOR cBuffer[i]) AND $FF ];
    CRC_Value := nTemp1 XOR nTemp2;
  END;
  CalcCRCBuffer := CRC_Value;
END;


{==============================

   >>  function tIceLock.HexLongInt(L : LongInt) : KeyString;

    >  Description : Convert a longint to a KeyString

    >  Input       : LongInteger

    >  Output      : KeyString ($ABFF...etc)

 ==============================}
function tIceLock.HexLongInt(L : LongInt) : KeyString;
const
  HexDigits : ARRAY[0..15] OF Char = '0123456789ABCDEF';

VAR Temp : KeyString;
BEGIN
  Temp := '';
  Temp := Temp + '$';
  Temp := Temp + HexDigits[(L SHR 28) and $F];
  Temp := Temp + HexDigits[(L SHR 24) AND $F];
  Temp := Temp + HexDigits[(L SHR 20) AND $F];
  Temp := Temp + HexDigits[(L SHR 16) AND $F];
  Temp := Temp + HexDigits[(L SHR 12) AND $F];
  Temp := Temp + HexDigits[(L SHR 8) AND $F];
  Temp := Temp + HexDigits[(L SHR 4) AND $F];
  Temp := Temp + HexDigits[L AND $F];
  HexLongInt := Temp;
END;

{==============================

   >>  function tIceLock.BuildUserKey(Name : NameString) : KeyString;

    >  Description : Creates a Key from the passed Name.  If DemoLicense
                   : then a temporary key is created.

    >  Input       : Name - the users name

    >  Output      : a Key

 ==============================}
function tIceLock.BuildUserKey(Name : NameString; IsDemo : boolean) : KeyString;
var
  Buff : CRCBuffType;
  bs   : ^String;
  x    : integer;
  temp : KeyString;
begin
  for x := Length(Name) + 1 to 50 do Name[x] := UserPad;
  bs := @Buff;
  Temp := HexLongInt(fProgKey1);
  for x := 0 to 9 do Buff[x] := ord(Temp[x]);
  for x := 0 to 50 do Buff[x + 10] := ord(Name[x]);
  Temp := HexLongInt(fProgKey2);
  if IsDemo then
    for x := 0 to 9 do Buff[x + 61] := Ord(Temp[x]) - 1
  else
    for x := 0 to 9 do Buff[x + 61] := Ord(Temp[x]);
  BuildUserKey := HexLongInt(CalcCRCBuffer(Seed, Buff));
end;

{==============================

   >>  procedure tIceLock.InitProgramKeys;

    >  Description : Initializes program keys, based on the values of Ice1/
                     progkey1 and Ice2/Progkey2

    >  Input       : None works only on object properties

 ==============================}
procedure tIceLock.InitProgramKeys;
var
  x : integer;
  Buffer : CRCBuffType;
begin
  for x := Length(fIce1) + 1 to 70 do fIce1[x] := ProgPad;
  for x := 0 to 70 do Buffer[x] := ord(fIce1[x]);
  fProgKey1 := CalcCRCBuffer(fSeedVal1,Buffer);
  for x := Length(fIce2) + 1 to 70 do fIce2[x] := ProgPad;
  for x := 0 to 70 do Buffer[x] := ord(fIce2[x]);
  fProgKey2 := CalcCRCBuffer(fSeedVal2,Buffer);
end;


{==============================

   >>  Function tIceLock.CheckKey(n : NameString;k : KeyString) : boolean;

    >  Description : Verified that the key (k) is valid for name (n)

    >  Input       : a name and key

    >  Output      : Boolean result, true if good key
                   : Also Sets DemoLicense
                   : depending on which matches.  If ltTemporary, then
                   : the TrialDays property is used to determine the
                   : expiration date.

 ==============================}
Function tIceLock.CheckKey(n : NameString;k : KeyString) : boolean;
begin
  fDemoLicense := false;
  Result := BuildUserKey(N,fDemoLicense) = k;
  if Result = False then
  begin
    fDemoLicense := true;
    Result := BuildUserKey(N,fDemoLicense) = k;
    if Result = true then fDemoLicense := true;
  end;
end;


{==============================

   >>  function tIceLock.GetKey  : KeyString;

    >  Description : Gets the current key stored in UserKey

 ==============================}
function tIceLock.GetKey  : KeyString;
begin
  GetKey := UserKey;
end;

{==============================

   >>  function tIceLock.GetName : NameString;

    >  Description : Gets the current name in UserName

 ==============================}
function tIceLock.GetName : NameString;
begin
  GetName := UserName;
end;


{==============================

   >>  function tIceLock.PutKey(name : NameString; Key : KeyString) : integer;

    >  Description : Attempts to store name and Key in UserName and Userkey

    >  Input       : a name and key..

    >  Output      : Returns error code ieOkay if successful, ieInvalid for
                     invalid keys.

 ==============================}
function tIceLock.PutKey(name : NameString; Key : KeyString) : integer;
var
  x : integer;
begin
  for x := Length(Name) + 1 to 50 do Name[x] := UserPad;
  if CheckKey(Name,Key) then
  begin
    PutKey := ieOkay;
    UserName := Name;
    UserKey  := Key;
    IsRegistered := true;
    if fDemoLicense then
      fExpirationDate := Date + fTrialDays
    else fExpirationDate := 0;
  end
    else begin
      PutKey := ieInvalidKey;
      IsRegistered := false;
    end;
end;


{==============================

   >>  function tIceLock.SaveKeyFile : Integer;

    >  Description : Attempt to save the current key to a file.

    >  Input       : none

    >  Output      : Returns ieOkay for success, ieInvalid for invalid key, or
                     ieFileError if there is some problem creating/writting to
                     file.  If the result if ieFileError, your program can check
                     the value of LastIoResult to get the error code.

 ==============================}
function tIceLock.SaveKeyFile : Integer;
var
  r  : rIceRecord;
  pa : pIceArray;
  f  : file of aIceArray;
begin
  if CheckKey(UserName, UserKey) then
  begin
    assignFile(f,fKeyFileName);
    {$I-}
    rewrite(f);
    {$I+}
    LastIoResult := IoResult;
    if LastIoResult = 0 then
    begin
      r.Name           := UserName;
      r.Key            := UserKey;
      r.HDSerialNo     := GetHDSerialNumber; {+++ Keep HD Serial Number }
      r.DemoLicense    := fDemoLicense;      {+++ Keep Demo License     }
      r.ExpirationDate := fExpirationDate;   {+++ Keep Expiration Date  }
      pa := @r;
      EncryptRecord(@r);
      write(f,pa^);
      SaveKeyFile := ieOkay;
      closefile(f);
    end
      else SaveKeyFile := ieFileError;
  end
    else SaveKeyFile := ieInvalidKey;
end;

{==============================

   >>  function tIceLock.LoadKeyFile : Integer;

    >  Description : Attempts to load the current key to a file.

    >  Input       : none

    >  Output      : Returns ieOkay for success, ieInvalid for invalid key,
                     ieFileError if there is some problem creating/reading the
                     file or ieNotSameHD if this key file was copied from
                     somewhere. If the result if ieFileError, your program can
                     check the value of LastIoResult to get the error code.

 ==============================}
function tIceLock.LoadKeyFile : Integer;
var
  r  : rIceRecord;
  pa : pIceArray;
  f  : file of aIceArray;
begin
  IsRegistered := false;
  AssignFile(f,fKeyFileName);
  {$I-}
  reset(f);
  {$I+}
  LastIoResult := IoResult;
  if LastIoResult = 0 then
  begin
    pa := @r;
    {$I-}
    read(f,pa^);
    {$I+}
    LastIoResult := IoResult;
    if LastIoResult = 0 then
    begin
      EncryptRecord(@r);
      if r.HDSerialNo <> GetHDSerialNumber then
      {+++ Current HDserialNo must be same as the one where KeyFile was
           Saved, if not, this is an invalid copy.
      }
        LoadKeyFile := ieNotSameHD
      else
      if (r.DemoLicense) and (Date > r.ExpirationDate) then
      {+++ If License type is temporary and current date is after expiration
           date, this license is over.
      }
        LoadKeyFile := ieExpired
      else
      if CheckKey(r.Name,r.Key) then
      begin
        UserName := r.Name;
        UserKey  := r.Key;
        {+++}
        fDemoLicense := r.DemoLicense;
        fExpirationDate := r.ExpirationDate;
        {+++}
        LoadKeyFile := ieOkay;
        IsRegistered := true;
      end
        else LoadKeyFile := ieInvalidKey;
    end
      else LoadKeyFile := ieFileError;
    closefile(f);
  end
    else LoadKeyFile := ieFileError;
end;

{+++==============================

   >> function tIceLock.GetHDSerialNumber: LongInt;

    >  Description : Get the Serial Number of the Hard Disk where the Key File
                     lives.

    >  Input       : none

    >  Output      : Returns Serial Number of disk where is fKeyFileName
                     if success or -1 on error.

    > Notes        : This only returns SerialNumber under Win 95/NT, for
                   : win 3.1, I am using GetWinFlags which returns a LongInt
                   : that contains CPU and Mode information.  Not as good, but
                   : far more reliable than trying to query the HD information
                   : from Win 3.1

 ==============================}
function tIceLock.GetHDSerialNumber: LongInt;
{$IFDEF WIN32}
var
  pdw : pDWord;
  mc, fl : dword;
{$ENDIF}
begin
  {$IfDef WIN32}
  New(pdw);
  GetVolumeInformation(nil,nil,0,pdw,mc,fl,nil,0);
  Result := pdw^;
  dispose(pdw);
  {$ELSE}
  Result := GetWinFlags;
  {$ENDIF}
end;


{+++==============================

   >>  procedure tIceLock.SetExpirationDate(ed: TDateTime);

    >  Description : Allows user to specify an expiration date, sets LicenseType
       to ltTemporary.

 ==============================}
procedure tIceLock.SetExpirationDate(ed: TDateTime);
begin
  fExpirationDate := ed;
  if fExpirationDate = 0 then
    fDemoLicense := false
  else
    fDemoLicense := True;
end;


{+++==============================

   >>  function tIceLock.GetExpirationDate: TDateTime;

    >  Description : Allows user to recover expiration date.

 ==============================}
function tIceLock.GetExpirationDate: TDateTime;
begin
  Result := fExpirationDate;
end;

{==============================

   >>  constructor tIceLock.Create(AOwner: TComponent);

    >  Description : Called when tIceLock component is created, initializes
                     variables.

 ==============================}
constructor tIceLock.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  { Initialize all variables }
  fIce1           := 'IceLock v1.0';
  fIce2           := 'IceLock !!!!!';
  fProgKey1       := 32767;
  fProgKey2       := 65535;
  fSeedVal1       := $EFCA99;
  fSeedVal2       := $CA99FF;
  fKeyFileName    := 'REGISTER.KEY';
  Seed            := $ABCDEF;
  UserName        := 'UNREGISTERED';
  UserKey         := '$FFFFFFFF';
  LastIoResult    := 0;
  IsRegistered    := False;
  fDemoLicense    := False; {+++}
  fExpirationDate := 0;           {+++}
  fTrialDays := 60;
  InitProgramKeys;
end;

end.



