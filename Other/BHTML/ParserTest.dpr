program ParserTest;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  Misc in 'Misc.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'HTML Parser Test';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
