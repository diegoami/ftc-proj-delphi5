unit uExtsForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,uDaDirScan;

type
  TExtsForm = class(TForm)
    AcceptListBox: TListBox;
    AcceptedEdit: TEdit;
    Button1: TButton;
    DeleteButton: TButton;
    OkBitBtn: TBitBtn;
    CancelBitBtn: TBitBtn;
    Label1: TLabel;
    procedure AcceptedEditChange(Sender: TObject);
    procedure AcceptListBoxClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure OkBitBtnClick(Sender: TObject);
    procedure CancelBitBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    DADirScan : TDaDirScan;
    MustScan : boolean;

  end;

var
  ExtsForm: TExtsForm;

implementation

{$R *.DFM}

procedure TExtsForm.AcceptedEditChange(Sender: TObject);
begin
  if AcceptListBox.ItemIndex <> -1 then
    AcceptListBox.Items[AcceptListBox.ItemIndex] := AcceptedEdit.Text;
end;

procedure TExtsForm.AcceptListBoxClick(Sender: TObject);
begin
  AcceptedEdit.Text := AcceptListBox.Items[AcceptListBox.ItemIndex];

end;

procedure TExtsForm.Button1Click(Sender: TObject);
begin
  AcceptListBox.ItemIndex := AcceptListBox.Items.Add(AcceptedEdit.Text);
end;

procedure TExtsForm.DeleteButtonClick(Sender: TObject);
begin
  if AcceptListBox.ItemIndex <> -1 then
    AcceptListBox.Items.Delete(AcceptListBox.ItemIndex);

end;

procedure TExtsForm.OkBitBtnClick(Sender: TObject);
begin
    DADirScan.AcceptedFiles := AcceptListBox.Items;
    MustScan := True;
    Close;
end;

procedure TExtsForm.CancelBitBtnClick(Sender: TObject);
begin
  MustScan := False;
  Close;
end;

end.
