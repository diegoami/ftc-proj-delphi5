unit uJSDeployer;

interface

uses DCGen, classes;

type
  TJSDeployer = class(TDCFileOperation)
     private
       FIndexFileName : String;
       FJSStrings : TStrings;
       FLFFileName : String;
       FRFFileName : String;
       FFTFileName : String;
       FHomeFileName : String;
       FNavigateWhileAdding : boolean;

     protected
       procedure WriteLF(Directory,LeftFrame : String);
       procedure WriteIndex(Directory, MainHtml : String);
       procedure WriteJSStrings(FJSStrings : TStrings; DestFolder,JSFileName : String);

     public
       constructor Create(AOwner : TComponent); override;
       procedure Deploy;


     published
       property IndexFileName : String read FIndexFileName write FIndexFileName;
       property HomeFileName : String read FHomeFileName write FHomeFileName;

       property LFFileName : String read FLFFileName write FLFFileName;
       property FTFileName : String read FFTFileName write FFTFileName;
       property NavigateWhileAdding : boolean read FNavigateWhileAdding write FNavigateWhileAdding;



       property JSStrings : TStrings read FJSStrings write FJSStrings;

     end;

procedure Register;


implementation

uses sysutils;


procedure TJSDeployer.Deploy;
begin
  {if FIndeXfileName <> '' then begin
    SourceFiles.Add(FHomeFileName);
    FRFFileName := ExtractFileName(FHomeFileName)
  end;}
  Copy;
  WriteLf(DestFolder,LfFileName);
  WriteIndex(DestFolder,FIndexFileName);
  WriteJSStrings(FJSStrings, DestFolder,FTFileName);
end;





constructor TJSDeployer.Create(AOwner : TComponent);
begin
  inherited;
  FJSStrings := TStringList.Create;
  FNavigateWhileAdding := false;
  FIndexFileName := 'index.html';
  LFFileName := 'leftframe.html';
  FRFFileName := 'home.html';
  FFTFileName := 'tree.js';
end;

procedure TJSDeployer.WriteJSStrings(FJSStrings : TStrings; DestFolder,JSFileName : String);
begin
  FJSStrings.SaveToFile(DestFolder+'\'+FFTFileName);
end;


procedure TJSDeployer.WriteLF(Directory,LeftFrame : String);
var HandleFile : TextFile;
begin
  AssignFile(HandleFile,Directory+'\'+LeftFrame);
  Rewrite(HandleFile);
  Writeln(HandleFile,'<html><head></head>');
  Writeln(HandleFile,'<script src="ftiens4.js"></script>');
  Writeln(HandleFile,'<script src="'+FFTFileName+'"></script><script>');
//  Writeln(HandleFile,'initializeDocument()');
  Writeln(HandleFile,'</script></body></html>');
  CloseFile(HandleFile);
end;

procedure TJSDeployer.WriteIndex(Directory, MainHtml : String);
var HandleFile : TextFile;
begin
  AssignFile(HandleFile,Directory+'\'+MainHtml);
  Rewrite(HandleFile);
  Writeln(HandleFile,'<html><head></head>');
  Writeln(HandleFile,'<FRAMESET cols="200,*">');
  Writeln(HandleFile,'<FRAME src="'+FLFFileName+'" name="treeframe" >');
  Writeln(HandleFile,'<FRAME SRC="'+FRFFileName+'" name="basefrm">');
  Writeln(HandleFile,'</FRAMESET></HTML>');
  CloseFile(HandleFile);
end; { WriteIndex }




procedure Register;
begin
  RegisterComponents('Diego Amicabile', [TJSDeployer]);
end;



end.
