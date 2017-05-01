program Project1;

uses
  Forms,
  Unit2 in 'Unit2.pas' {Form2},
  uLogger in '..\CommonForms\uLogger.pas';

{$R *.RES}

begin
  Application.Initialize;
  
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
