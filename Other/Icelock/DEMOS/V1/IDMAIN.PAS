unit idmain;

interface

uses
{$IFDEF WIN32}
  Windows,
{$ELSE}
 Wintypes, WinProcs,
{$ENDIF}
 Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IceLock, ExtCtrls;

type
  TForm1 = class(TForm)
    IceLock1: tIceLock;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    NameEdit: TEdit;
    Label4: TLabel;
    PermCheck: TCheckBox;
    Button1: TButton;
    KeyLabel: TLabel;
    Label6: TLabel;
    Button2: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure PermCheckClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  Result : integer;
begin
  Result := Icelock1.LoadKeyFile;
  if Result = ieOkay then
  begin
    if IceLock1.IsRegistered then
    begin
      Label1.Caption := 'Registered to: ' + Icelock1.GetName;
      Label2.Caption := 'Key: ' + Icelock1.GetKey;
      Label3.Caption := 'Expires: ' + DateTimeToStr(IceLock1.ExpirationDate);
    end;
  end
  else begin
    if Result = ieInvalidKey then Label1.Caption := 'Invalid Key'
    else if Result = ieFileError then label1.Caption := 'File Error'
    else if Result = ieNotSameHD then label1.Caption := 'Not Same System'
    else if Result = ieExpired then Label1.Caption := 'Expired Key!';
  end;
end;

procedure TForm1.PermCheckClick(Sender: TObject);
begin
  if PermCheck.Checked then IceLock1.DemoLicense := false
    else IceLock1.DemoLicense := true;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  KeyLabel.Caption := IceLock1.BuildUserKey(NameEdit.Text,Icelock1.DemoLicense);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Icelock1.PutKey(NameEdit.Text,KeyLabel.Caption) = ieOkay then
    Icelock1.SaveKeyFile
  else KeyLabel.Caption := 'ERROR';
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Result : integer;
begin
  Result := Icelock1.LoadKeyFile;
  if Result = ieOkay then
  begin
    if IceLock1.IsRegistered then
    begin
      Label1.Caption := 'Registered to: ' + Icelock1.GetName;
      Label2.Caption := 'Key: ' + Icelock1.GetKey;
      Label3.Caption := 'Expires: ' + DateTimeToStr(IceLock1.ExpirationDate);
    end;
  end
  else begin
    if Result = ieInvalidKey then Label1.Caption := 'Invalid Key'
    else if Result = ieFileError then label1.Caption := 'File Error'
    else if Result = ieNotSameHD then label1.Caption := 'Not Same System'
    else if Result = ieExpired then Label1.Caption := 'Expired Key!';
  end;
end;

end.
