program Project1;

uses
  Forms,
  Unit2 in 'Unit2.pas' {Form2},
  htmlmisc in 'HTMLMisc.pas',
  HTMLParser in 'HTMLParser.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
