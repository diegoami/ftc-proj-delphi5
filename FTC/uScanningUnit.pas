unit uScanningUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TScanningForm = class(TForm)
    ScanningLabel: TLabel;
    DirLabel: TLabel;
    CancelButton: TButton;
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ScanningForm: TScanningForm;

implementation

{$R *.DFM}

procedure TScanningForm.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

end.
