unit GetURL;

{ ============================================================================

  Copyright (c) 1997,1998,1999,2000 by Richard Phillips

  07/15/97  RP  - Added OpenOptions, OpenURLOptions properties
                - Added ParameterizeTag Method
  07/17/97  RP  - Added BufferSize property, changed default size to 16k from 2k
  07/18/97  RP  - Fixed some IMG tag parsing problems (replaced "<img " w/ "<img")
                - Added URLSite Property
  07/23/97  RP  - Added BodyParams Property
                - Added SetBodyParams Method (private)
                - Added routines to fix image refs in <body> tag
  07/27/97  RP  - Changed FixImageTags to allow path to be specified
  08/06/97  RP  - Added code to undo line breaks inside tags.
                  NOTE: This will change contents of doc
  08/08/97  RP  - Added GetAllTags
                - Added Comments property
  10/17/97  RP  - Split GetURL into another object as well (THTMLDocParser)
                - Added Root and URLSite assignments when URL is set
  12/16/97  RP  - Added BytesRead property to WIGetURL
  01/15/98  RP  - Added new GetURL function to incorporate more detailed Wininet
                  routines.  Now we get better StatusCode definition (404's).
  01/16/98  RP  - Combined GetRoot, GetSite, GetDocument into SetURL (Faster)
  03/07/98  RP  - Allow TWIGetURL.Text to be writable
  09/02/98  RP  - Changes to compile under 4.0
  10/13/98  RP  - Changed Headers property to RawHeaders
                - Added Headers property to send headers in to HTTP request
  10/28/98  RP  - Added THTMLDocParser.FormItems property
  11/03/98  RP  - Slight code cleanup in GetFormItems
  06/15/99  RP  - Fixed bug in GetParam
  06/28/99  RP  - Work on .SetURL to be a little more efficient and handle urls
                  without leading 'http://' correctly
                - Combined GetURL and FetchToFile code bases into Get method
  07/12/99  RP  - Split HTMLDocParser out to HtmlDocParser.pas
  07/18/99  RP  - Stubbed out call to CleanUpBody, commented out CleanUpBody
  01/11/99  RP  - Added Post method and FormData property
  01/13/99  RP  - Fixed Post so that it actually works
                - Default application name to 'http generic'

  ===========================================================================  }

interface

uses
  Classes, WinInet, Windows, SysUtils, Misc;

const
  wiSuccess = 0;
  wiFailed = 1;
  cReadBufferSize = 16384;        // Set Default read buffer size to 16K

type
  TOpenOptions = (ooPreconfig, ooDirect, ooGatewayInternetAccess, ooProxy,
    ooPreConfigInternetAccess, ooLocalInternetAccess, ooCernProxyInternetAccess);

  TOpenURLOptionStyle = (ouReload, ouRawData, ouExistingConnect, ouAsync, ouPassive,
    ouNoCacheWrite, ouDontCache, ouMakePersistent, ouOffline, ouSecure,
    ouKeepConnection, ouNoAutoRedirect, ouNoReadPrefetch, ouIgnoreCertCNInvalid,
    ouIgnoreCertDateInvalid, ouIgnoreRedirectToHTTPS, ouIgnoreRedirectToHTTP);

  TOpenURLOptions = set of TOpenURLOptionStyle;

  TInternetStatusEvent = procedure(Sender : TObject; Status : integer; StatusInformation : pointer;
    StatusInformationLength : integer) of object;

  THeaderReceivedEvent = procedure(Sender : TObject; RequestHandle : pointer; StatusCode : integer;
    var RetrieveDoc : boolean) of object;

  TWIGetURL = class(TComponent)
    private
      OpenURLOption,
      OpenOption : dword;

      FHeaders,
      FRawHeaders,
      FRequestHeaders,
      FApplicationName,
      FURL,
      FErrorMessage,
      FRoot,
      FSite,
      FDocument,
      FFormData,
      FTotalSize,

      FText : string;
      FErrorCode,
      FStatus : integer;
      FTotalBytesRead,
      FBufferSize,
      FBytesRead: dword;
      FOnStatus : TInternetStatusEvent;
      FOnHeaderReceived : THeaderReceivedEvent;
      FOnIdle : TNotifyEvent;
      FOpenOptions : TOpenOptions;
      FOpenURLOptions : TOpenURLOptions;

      procedure SetStatus(TheStatus : integer; Msg : string);

      function Get(Filename : string) : integer;
      procedure SetURL(AURL : string);
      procedure DoIdle;
      procedure DoStatus(InternetSession : hInternet; InternetStatus : integer;
        StatusInformation : pointer; StatusInformationLength : integer);
      procedure SetOpenOptions(Value : TOpenOptions);
      procedure SetOpenURLOptions(Value : TOpenURLOptions);

    public
      constructor Create(AOwner : TComponent); override;

      procedure Clear;
      function GetURL : integer;
      function Post: integer;
      procedure SaveToFile(Filename : string);
      function FetchToFile(Filename : string) : integer;
      function GetQueryInfo(RequestHandle : pointer; var Value : string; InfoLevel : dword) : boolean;
      function GetStatusCodeText(StatusCode : integer) : string;

      property Text : string read FText write FText;
      property Status : integer read FStatus;
      property ErrorCode : integer read FErrorCode;
      property BytesReceived : dword read FTotalBytesRead;
      property Size : dword read FTotalBytesRead;
      property TotalSize : string read FTotalSize;
      property ErrorMessage : string read FErrorMessage;
      property FormData : string read FFormData write FFormData;
      property Root : string read FRoot;
      property Site : string read FSite;
      property Document : string read FDocument;
      property Headers : string read FHeaders write FHeaders;
      property RawHeaders : string read FRawHeaders write FRawHeaders;
      property RequestHeaders : string read FRequestHeaders write FRequestHeaders;

    published
      property ApplicationName : string read FApplicationName write FApplicationName;
      property URL : string read FURL write SetURL;
      property BufferSize : dword read FBufferSize write FBufferSize default cReadBufferSize;
      property OpenOptions : TOpenOptions read FOpenOptions write SetOpenOptions default ooPreconfig;
      property OpenURLOptions : TOpenURLOptions read FOpenURLOptions write SetOpenURLOptions default [ouDontCache,ouReload];
      property OnIdle : TNotifyEvent read FOnIdle write FOnIdle;
      property OnHeaderReceived : THeaderReceivedEvent read FOnHeaderReceived write FOnHeaderReceived;
      property OnStatus : TInternetStatusEvent read FOnStatus write FOnStatus;

  end;

procedure Register;

implementation

{$R geturl.res}

{ ---------------------------------------------------------------------------- }

procedure Register;

begin  RegisterComponents('Custom', [TWIGetURL]);end;
// ----------------------------------------------------------------------------

procedure GetURLStatusCallback(InternetSession : hInternet; Context, InternetStatus : dword;
  StatusInformation : pointer; StatusInformationLength : dword); stdcall;

// Nasty hack to hook us back into TWIGetURL's DoStatus Event processing code

begin
  with TWIGetURL(Context) do
    DoStatus(InternetSession,InternetStatus,StatusInformation,StatusInformationLength);

end;

// ----------------------------------------------------------------------------

constructor TWIGetURL.Create(AOwner : TComponent);

begin
  Inherited Create(AOwner);

  FApplicationName := 'http generic';

  Clear;

end;

procedure TWIGetURL.Clear;

// Initialize properties that receive data

begin
  FText := '';
  FErrorMessage := '';
  FErrorCode := 0;
  FStatus := wiSuccess;
  FTotalBytesRead := 0;

  OpenOption := INTERNET_OPEN_TYPE_PRECONFIG;
  OpenURLOption := INTERNET_FLAG_DONT_CACHE + INTERNET_FLAG_RELOAD;

  FOpenOptions := ooPreconfig;
  FOpenURLOptions := [ouDontCache,ouReload];

  FBufferSize := cReadBufferSize;

end;

function TWIGetURL.GetQueryInfo(RequestHandle : pointer; var Value : string; InfoLevel : dword) : boolean;

// Fetch the Query Response Info specified by InfoLevel (i.e. HTTP_QUERY_STATUS_CODE)

const
  cQueryBufferLen = 1024;

var
  Reserved,
  BufferLen : dword;
  Buffer : PChar;
  BuffStr : string;

begin
  Reserved := 0;

  BufferLen := cQueryBufferLen;
  GetMem(Buffer,cQueryBufferLen);

  Result := HttpQueryInfo(RequestHandle,InfoLevel,Buffer,BufferLen,Reserved);

  If not Result and (BufferLen > cQueryBufferLen) then    // Query failed due to too little buffer space
    begin                                                 // ReAllocate buffer, try again
      FreeMem(Buffer);
      GetMem(Buffer,BufferLen);

      Result := HttpQueryInfo(RequestHandle,InfoLevel,Buffer,BufferLen,Reserved);

    end;

  If Result then                                          // If got one, convert to Pascal string
    begin
      BuffStr := Buffer;
      Value := Copy(BuffStr,1,BufferLen);
    end
  else
    Value := '';

  FreeMem(Buffer);

end;

function TWIGetURL.GetURL : integer;

// Wrapper for Get that puts HTML file in Text property

begin
  Result := Get('');

end;

function TWIGetURL.FetchToFile(Filename : string) : integer;

// Wrapper for Get that puts HTML file in file specified by Filename

begin
  Result := Get(Filename);

end;

function TWIGetURL.Get(Filename : string) : integer;

// Internal method called by GetURL and FetchToFile.  If Filename is specified,
// we write to the file otherwise, we put the file in the Text property.

var
  InternetSession,
  InternetConnection,
  RequestHandle : HINTERNET;
  TempStr,
  BuffStr : String;
  RetrieveDoc,
  RC : boolean;
  Buffer   : PChar;
  StatusCode : integer;
  OutFile : file of byte;

begin
  Clear;

  FErrorCode := 0;
  Result := wiFailed;

// Open link to internet

  InternetSession := InternetOpen(PChar(ApplicationName),OpenOption,nil,nil,0);
  InternetSetStatusCallBack(InternetSession,@GetURLStatusCallBack);  // Register Callback function

  If InternetSession <> nil then       // If link to internet successful, connect to server
    begin
      InternetConnection := InternetConnect(InternetSession,PChar(FSite),INTERNET_DEFAULT_HTTP_PORT,
        nil,nil,INTERNET_SERVICE_HTTP,0,dword(Self));

      If InternetConnection <> nil then     // If connected to server...
        begin
          RequestHandle := HttpOpenRequest(InternetConnection,'GET',PChar(FDocument),'HTTP/1.0',
            nil,nil,OpenURLOption,dword(Self));

          If RequestHandle <> nil then
            begin
              If HttpSendRequest(RequestHandle,PChar(FHeaders),Length(FHeaders),nil,dword(Self)) then
                begin
                  GetQueryInfo(RequestHandle,FRawHeaders,HTTP_QUERY_RAW_HEADERS_CRLF);
                  GetQueryInfo(RequestHandle,FRequestHeaders,HTTP_QUERY_FLAG_REQUEST_HEADERS + HTTP_QUERY_RAW_HEADERS_CRLF);
                  GetQueryInfo(RequestHandle,TempStr,HTTP_QUERY_STATUS_CODE);
                  GetQueryInfo(RequestHandle, FTotalSize, HTTP_QUERY_CONTENT_LENGTH  );


                  StatusCode := StrToInt(TempStr);

// We're about to call the HeaderReceived Event.  User can halt progress here
//  by setting RetrieveDoc False in the event handle.

                  RetrieveDoc := True;

                  If Assigned(FOnHeaderReceived) then
                    FOnHeaderReceived(Self,RequestHandle,StatusCode,RetrieveDoc);

                  If (StatusCode >= 200) and (StatusCode < 300) then
                    begin
                      If RetrieveDoc then
                        begin
                          FBytesRead := 0;
                          GetMem(Buffer,FBufferSize);

                          If Filename <> '' then
                            begin
                              AssignFile(OutFile,Filename);
                              ReWrite(OutFile);
                            end;

                          repeat
                            rc := InternetReadFile(RequestHandle,Buffer,FBufferSize,FBytesRead);

                            FTotalBytesRead := FTotalBytesRead + FBytesRead;

                            If RC and (FBytesRead <> 0) then
                              If Filename = '' then
                                begin
                                  BuffStr := Buffer;
                                  FText := FText + Copy(BuffStr,1,FBytesRead);
                                  Sleep(0);
                                end
                              else
                                BlockWrite(OutFile,Buffer^,FBytesRead);

                            DoIdle;

                          until not RC or (FBytesRead = 0);

                          FreeMem(Buffer);

                          If Filename <> '' then
                            CloseFile(OutFile);

                          If RC and (FBytesRead = 0) then
                            begin
                              Result := wiSuccess;
                              SetStatus(wiSuccess,'');
                            end
                          else
                            SetStatus(wiFailed,'Retrieval Interrupted');

                        end
                      else
                        SetStatus(wiSuccess,'Retrieval Denied');

                    end
                  else
                    begin
                      FErrorCode := StatusCode;
                      GetQueryInfo(RequestHandle,TempStr,HTTP_QUERY_STATUS_TEXT);
                      SetStatus(wiFailed,TempStr);
                    end;

                end
              else
                begin
                  FErrorCode := GetLastError;
                  SetStatus(wiFailed,'Unable to Send HTTP Request');
                end;

              InternetCloseHandle(RequestHandle);

            end
          else
            begin
              FErrorCode := GetLastError;
              SetStatus(wiFailed,'Unable to Open HTTP Request');
            end;

          InternetCloseHandle(InternetConnection);

        end
      else
        begin
          FErrorCode := GetLastError;
          SetStatus(wiFailed,'Unable to Open Internet Connection');
        end;

      InternetCloseHandle(InternetSession);

    end
  else
    begin
      FErrorCode := GetLastError;
      SetStatus(wiFailed,'Unable to Open Internet Session');
    end;

end;

function TWIGetURL.Post : integer;

// Post a data to specified URL.  Note that Headers must be set and the parameters
// should be specified in the FormData property.
//
// Example
//
//   GetURL.URL := 'us.imdb.com/Find';
//   GetURL.FormData := UrlEncode('select=All&for=' + Edit1.Text + '&Go=Go');
//   GetURL.Headers := 'Content-Type: application/x-www-form-urlencoded'#13#10#13#10;
//
//   If GetURL.Post = wiSuccess then
//     begin
//       ...
//     end;

var
  InternetSession,
  InternetConnection,
  RequestHandle : HINTERNET;
  TempStr,
  BuffStr : String;
  RetrieveDoc,
  RC : boolean;
  Buffer   : PChar;
  StatusCode : integer;

begin
  Clear;

  FErrorCode := 0;
  Result := wiFailed;

// Open link to internet

  InternetSession := InternetOpen(PChar(ApplicationName),OpenOption,nil,nil,0);
  InternetSetStatusCallBack(InternetSession,@GetURLStatusCallBack);  // Register Callback function

  If InternetSession <> nil then       // If link to internet successful, connect to server
    begin
      InternetConnection := InternetConnect(InternetSession,PChar(FSite),INTERNET_DEFAULT_HTTP_PORT,
        nil,'HTTP/1.0',INTERNET_SERVICE_HTTP,0,dword(Self));

      If InternetConnection <> nil then     // If connected to server...
        begin
          RequestHandle := HttpOpenRequest(InternetConnection,'POST',PChar(FDocument),'HTTP/1.0',
            nil,nil,OpenURLOption,dword(Self));

          If RequestHandle <> nil then
            begin
              If HttpSendRequest(RequestHandle,PChar(FHeaders),Length(FHeaders),PChar(FFormData),Length(FFormData)) then
                begin
                  GetQueryInfo(RequestHandle,FRawHeaders,HTTP_QUERY_RAW_HEADERS_CRLF);
                  GetQueryInfo(RequestHandle,FRequestHeaders,HTTP_QUERY_FLAG_REQUEST_HEADERS + HTTP_QUERY_RAW_HEADERS_CRLF);
                  GetQueryInfo(RequestHandle,TempStr,HTTP_QUERY_STATUS_CODE);

                  StatusCode := StrToInt(TempStr);

// We're about to call the HeaderReceived Event.  User can halt progress here
//  by setting RetrieveDoc False in the event handle.

                  RetrieveDoc := True;

                  If Assigned(FOnHeaderReceived) then
                    FOnHeaderReceived(Self,RequestHandle,StatusCode,RetrieveDoc);

                  If (StatusCode >= 200) and (StatusCode < 300) then
                    begin
                      If RetrieveDoc then
                        begin
                          FBytesRead := 0;
                          GetMem(Buffer,FBufferSize);

                          repeat
                            rc := InternetReadFile(RequestHandle,Buffer,FBufferSize,FBytesRead);

                            FTotalBytesRead := FTotalBytesRead + FBytesRead;

                            If RC and (FBytesRead <> 0) then
                              begin
                                BuffStr := Buffer;
                                FText := FText + Copy(BuffStr,1,FBytesRead);
                                Sleep(0);
                              end;

                            DoIdle;

                          until not RC or (FBytesRead = 0);

                          FreeMem(Buffer);

                          If RC and (FBytesRead = 0) then
                            begin
                              Result := wiSuccess;
                              SetStatus(wiSuccess,'');
                            end
                          else
                            SetStatus(wiFailed,'Retrieval Interrupted');

                        end
                      else
                        SetStatus(wiSuccess,'Retrieval Denied');

                    end
                  else
                    begin
                      FErrorCode := StatusCode;
                      GetQueryInfo(RequestHandle,TempStr,HTTP_QUERY_STATUS_TEXT);
                      SetStatus(wiFailed,TempStr);
                    end;

                end
              else
                begin
                  FErrorCode := GetLastError;
                  SetStatus(wiFailed,'Unable to Send HTTP Request');
                end;

              InternetCloseHandle(RequestHandle);

            end
          else
            begin
              FErrorCode := GetLastError;
              SetStatus(wiFailed,'Unable to Open HTTP Request');
            end;

          InternetCloseHandle(InternetConnection);

        end
      else
        begin
          FErrorCode := GetLastError;
          SetStatus(wiFailed,'Unable to Open Internet Connection');
        end;

      InternetCloseHandle(InternetSession);

    end
  else
    begin
      FErrorCode := GetLastError;
      SetStatus(wiFailed,'Unable to Open Internet Session');
    end;


end;

procedure TWIGetURL.SetStatus(TheStatus : integer; Msg : string);

begin
  FStatus := TheStatus;
  FErrorMessage := Msg;

end;

procedure TWIGetURL.SaveToFile(Filename : string);

// Save text of document to file.  Note that no exceptions are handled here.

var
  OutFile : textfile;

begin
  AssignFile(OutFile,Filename);
  ReWrite(OutFile);
  WriteLn(OutFile,FText);
  CloseFile(OutFile);

end;

procedure TWIGetURL.SetURL(AURL : string);

// Parse URL out into constituent components (Site, Root, Document Name)

var
  TempStr : string;
  Index   : integer;

begin
  FURL := AURL;
  FSite := '';
  FDocument := '';
  FRoot := '';

  TempStr := FURL;

  If LowerCase(Copy(TempStr,1,7)) = 'http://' then         // Remove 'http://'
    Delete(TempStr,1,7);

  If TempStr <> '' then
    begin
      If TempStr[Length(TempStr)] = '/' then                     // Remove trailing '/'
        Delete(TempStr,Length(TempStr),1);

      Index := Pos('/',TempStr);

      If Index > 0 then
        begin
          FSite := Copy(TempStr,1,Index - 1);
          FDocument := Copy(TempStr,Index + 1,Length(TempStr));

          Index := Pos('/',FDocument);

          If Index > 0 then                            // Must trim doc name from path
            begin
              Index := Length(FDocument);

              while (Index > 0) and (FDocument[Index] <> '/') do
                Dec(Index);

              If Index > 0 then
                FRoot := FSite + '/' + Copy(FDocument,1,Index - 1);

            end
          else
            FRoot := FSite;

          FDocument := '/' + FDocument;           // Documents start at the root

        end
      else
        begin
          FSite := Copy(TempStr,1,Length(TempStr));     // Only site is specified
          FRoot := FSite;
        end;

    end;

end;

(*
procedure TWIGetURL.CleanupBody;

// Make sure no lines in body of doc break in the middle of a tag

{ * Work on algorithm to see if we can add checking to make sure lines don't get too long }

var
  Lines   : TStringList;
  Index,
  Counter : integer;
  TempStr : string;

begin
  Lines := TStringList.Create;
  Lines.Text := FText;

  Counter := 0;

  while Counter < Lines.Count do
    begin
      TempStr := Lines[Counter];

      Index := Pos('<',TempStr);

      If Index > 0 then
        begin
          While Index > 0 do
            begin
              Delete(TempStr,1,Index);
              Index := Pos('<',TempStr);
            end;

          If Pos('>',TempStr) <= 0 then
            begin
              If Counter < Lines.Count - 1 then
                begin
                  Lines[Counter] := TrimRight(Lines[Counter]) + ' ' + TrimLeft(Lines[Counter + 1]);

                  Lines.Delete(Counter + 1);

                end;

            end
          else
            Inc(Counter);   // This is odd, but we want to force a recheck of corrected lines

        end
      else
        Inc(Counter);   // This is odd, but we want to force a recheck of corrected lines

    end;

  FText := Lines.Text;

  Lines.Free;

end;
*)
procedure TWIGetURL.DoIdle;

begin
  If Assigned(FOnIdle) then
    FOnIdle(Self);

end;

procedure TWIGetURL.DoStatus(InternetSession : hInternet; InternetStatus : integer;
  StatusInformation : pointer; StatusInformationLength : integer);

begin
  If Assigned(FOnStatus) then
    FOnStatus(Self,InternetStatus,StatusInformation,StatusInformationLength);

end;

procedure TWIGetURL.SetOpenOptions(Value : TOpenOptions);

begin
  case Value of
    ooPreconfig,
    ooPreConfigInternetAccess : OpenOption := INTERNET_OPEN_TYPE_PRECONFIG;

    ooDirect,
    ooLocalInternetAccess : OpenOption := INTERNET_OPEN_TYPE_DIRECT;

    ooGatewayInternetAccess : OpenOption := GATEWAY_INTERNET_ACCESS;

    ooProxy,
    ooCernProxyInternetAccess : OpenOption := INTERNET_OPEN_TYPE_PROXY;

  end;

end;

procedure TWIGetURL.SetOpenURLOptions(Value : TOpenURLOptions);

const
  cOpenURLOptionList : array[ouReload..ouIgnoreRedirectToHTTP] of dword =
    (INTERNET_FLAG_RELOAD,
    INTERNET_FLAG_RAW_DATA,
    INTERNET_FLAG_EXISTING_CONNECT,
    INTERNET_FLAG_ASYNC,
    INTERNET_FLAG_PASSIVE,
    INTERNET_FLAG_NO_CACHE_WRITE,
    INTERNET_FLAG_DONT_CACHE,
    INTERNET_FLAG_MAKE_PERSISTENT,
    INTERNET_FLAG_OFFLINE,
    INTERNET_FLAG_SECURE,
    INTERNET_FLAG_KEEP_CONNECTION,
    INTERNET_FLAG_NO_AUTO_REDIRECT,
    INTERNET_FLAG_READ_PREFETCH,
    INTERNET_FLAG_IGNORE_CERT_CN_INVALID,
    INTERNET_FLAG_IGNORE_CERT_DATE_INVALID,
    INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS,
    INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP
    );

var
  Option : TOpenURLOptionStyle;

begin
  OpenURLOption := 0;

  for Option := ouReload to ouIgnoreRedirectToHTTP do
    If Option in Value then
      OpenURLOption := OpenURLOption + cOpenURLOptionList[Option];

end;

function TWIGetURL.GetStatusCodeText(StatusCode : integer) : string;

// Return text description for specified StatusCode

begin
  case StatusCode of
    INTERNET_STATUS_RESOLVING_NAME        : Result := 'Resolving Name';
    INTERNET_STATUS_NAME_RESOLVED         : Result := 'Name Resolved';
    INTERNET_STATUS_CONNECTING_TO_SERVER  : Result := 'Connecting to Server';
    INTERNET_STATUS_CONNECTED_TO_SERVER   : Result := 'Connected to Server';
    INTERNET_STATUS_SENDING_REQUEST       : Result := 'Sending Request';
    INTERNET_STATUS_REQUEST_SENT          : Result := 'Request Sent';
    INTERNET_STATUS_RECEIVING_RESPONSE    : Result := 'Receiving Response';
    INTERNET_STATUS_RESPONSE_RECEIVED     : Result := 'Response Received';
    INTERNET_STATUS_CTL_RESPONSE_RECEIVED : Result := 'CTL Response Recieved';
    INTERNET_STATUS_PREFETCH              : Result := 'Prefetch';
    INTERNET_STATUS_CLOSING_CONNECTION    : Result := 'Closing Connection';
    INTERNET_STATUS_CONNECTION_CLOSED     : Result := 'Connection Closed';
    INTERNET_STATUS_HANDLE_CREATED        : Result := 'Handle Closed';
    INTERNET_STATUS_HANDLE_CLOSING        : Result := 'Handle Closing';
    INTERNET_STATUS_REQUEST_COMPLETE      : Result := 'Request Complete';
    INTERNET_STATUS_REDIRECT              : Result := 'Redirect';

    else
      Result := 'Unknown StatusCode';

  end;

end;

end.

