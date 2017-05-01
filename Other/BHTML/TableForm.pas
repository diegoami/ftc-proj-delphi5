unit TableForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ComCtrls, ExtCtrls;

type
  TTableFrm = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Grid1: TStringGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TableFrm: TTableFrm;

implementation

{$R *.DFM}

end.
