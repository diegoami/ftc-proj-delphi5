unit Logger;

interface
const logFile = 'ftclog.txt';

procedure Log(S : String);
implementation

var F :Text;

procedure Log(S : String);
begin
  WriteLn(F,S);
end;

initialization
  AssignFile(F, logFIle);
  Rewrite(F);








end.
 