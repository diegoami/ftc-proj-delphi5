unit uFTCAbout;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, stringfns;

type             
  TFTCAboutBox = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
    ProductName: TLabel;
    Copyright: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    procedure OKButtonClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FTCAboutBox: TFTCAboutBox;

implementation

{$R *.DFM}

procedure TFTCAboutBox.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFTCAboutBox.Label2Click(Sender: TObject);
begin
  ShowWebPage('mailto:diegoami@yahoo.it');
end;

procedure TFTCAboutBox.Label1Click(Sender: TObject);
begin
  ShowWebPage('http://clickit.pair.com');
end;

procedure TFTCAboutBox.BitBtn1Click(Sender: TObject);
begin
  Close
end;

end.

