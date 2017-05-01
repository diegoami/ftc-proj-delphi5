unit uFTCController;

interface

type
  TJSController = class


     MainHtml : String;


     JSFile : String;
     OldDeployDir : String;
     LFFileName : String;
     HomeFileName : String;
     NavigateWhileAdding : boolean;
     procedure Save;
     procedure Load;
        private

       FDeployDir : String;
     public
       constructor Create;
       function GetHomePage : String;
       procedure setDeployDir(NewDeployDir : String);
     published
       property DeployDir : String read FDeployDir write setDeployDir;
  end;

var JSController : TJSController;

implementation

uses AmReg, sysutils, forms, registry;
var JSReg : TAmreg;

procedure TJSController.setDeployDir(NewDeployDir : String);
begin
  OldDeployDir := FDeployDir;
  FDeployDir := NewDeployDir;
end;



procedure TJSController.Load;
begin
  with JSReg do begin
    Active := True;
    DeployDir := RSString('JSSettings','DeployDir',DeployDir);
    OldDeployDir := RSString('JSSettings','OldDeployDir',OldDeployDir);
    MainHtml := RSString('JSSettings','MainHtml',MainHtml);
    JSFile := RSString('JSSettings','JSFile',JSFile);
    LFFileName := RSString('JSSettings','LFFileName',LFFileName);
    HomeFileName := RSString('JSSettings','HomeFileName',HomeFileName);
    NavigateWhileAdding := RSBool('JSSettings','NavigateWhileAdding',false);
    Active := False;
  end;


end;



procedure TJSController.Save;
begin
  with JSReg do begin
    Active := True;
    WSSTring('JSSettings','DeployDir',DeployDir);
    WSSTring('JSSettings','OldDeployDir',OldDeployDir);
    WSSTring('JSSettings','MainHtml',MainHtml);
    WSSTring('JSSettings','JSFile',JSFile);
    WSSTring('JSSettings','LFFIleName',LFFileName);
    WSSTring('JSSettings','HomeFileName',HomeFileName);
    WSBool('JSSettings','NavigateWhileAdding',NavigateWhileAdding);
    Active := False;
  end;


end;

constructor TJSController.Create;
begin
  inherited;
  DeployDir := ExtractFilePath(Application.Exename)+'Deployment';
  OldDeployDir := DeployDir;
  MainHtml := 'index.html';
  JSFILE := 'tree.js';
  LFFileName := 'leftframe.html';
  HomeFileName := 'home.html';
end;

function TJSController.GetHomePage : String;
begin
  result := DeployDir+'\'+ HomeFileName
end;





initialization
  JSReg := TAmReg.Create(nil);
  with JSReg do begin
    Rootkey := HKeyLocalMachine;
    Group := 'Software';
    Company := 'Click It';
    Application := 'Folder Tree Creator';
    Reg := TRegistry.Create;
  end;
  JSController := TJSController.Create;
  JSController.Load;

finalization
  JSController.Save;







end.
