unit uDaUnInstaller;

{*****************************************************************************
 *
 *  uDAUnInstaller.pas - unInstaller Object
 * Based on the TAppexec component from  Patrick Brisacier and Jean-Fabien Connault.
 *
 *  Copyright (c) 2000-1 Diego Amicabile
 *
 *  Author:     Diego Amicabile
 *  E-mail:     diegoami@yahoo.it
 *  Homepage:   http://www.geocities.com/diegoami
 *
 *  This component is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation;
 *
 *  This component is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this component; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA
 *
 *****************************************************************************}

interface

uses
  Windows,  SysUtils, registry;

type

  ENoApplicationName = class(Exception);
  EAppNotInstalled = class(Exception);
  ECouldNotUnInstallException = class(Exception);


  TDAUninstaller = class
  private
    FApplicationName: String;
  protected
    procedure AppExecute(AppString : STring);
  public
    procedure Execute;
    procedure Uninstall(AppName : String);

  published
    property ApplicationName : String read FApplicationName write FApplicationName;
  end;


implementation

procedure   TDAUninstaller.Execute;
begin
  Uninstall(FApplicationName)
end;

procedure   TDAUninstaller.UnInstall(AppName : String);
var Reg : TRegistry;
    Key1, Key2 : String;
    AppString : String;
begin
  if AppName = '' then begin
    raise ENoApplicationName.Create('No Application Name defined');
    exit;
  end;
  Reg := TRegistry.Create;
  Reg.RootKey:=HKEY_LOCAL_MACHINE;
  Key1:= 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'+AppName;
  Key2:= 'SOFTWARE\Microsoft\Windows\Current Version\Uninstall\'+AppName;


  try
    Reg.OpenKey(Key1,false);
    AppString := Reg.ReadString('UninstallString');


  except

    on ERegistryException do
      try
        Reg.OpenKey(Key2,false);
        AppString := Reg.ReadString('UninstallString');
      except on ERegistryException do
        raise EAppNotInstalled.Create('Application was not installed on this computer');
      end;

  end;
  AppExecute(AppString);
end;


procedure   TDAUninstaller.AppExecute(AppString : String);
var
  InstanceID : THandle;
  buffer: array[0..511] of Char;
  TmpStr: String;
  i: Integer;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
begin
  TmpStr := AppString;
  StrPCopy(buffer,TmpStr);
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := SW_SHOWNORMAL;
  if not CreateProcess(nil,
    buffer,                        { pointer to command line string }
    nil,                           { pointer to process security attributes }
    nil,                           { pointer to thread security attributes }
    false,                         { handle inheritance flag }
    CREATE_NEW_CONSOLE or          { creation flags }
    NORMAL_PRIORITY_CLASS,
    nil,                           { pointer to new environment block }
    nil,                           { pointer to current directory name }
    StartupInfo,                   { pointer to STARTUPINFO }
    ProcessInfo) then begin        { pointer to PROCESS_INF }
    raise ECouldNotUnInstallException.Create('Could not uninstall');
  end else begin
    WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
    { GetExitCodeProcess(ProcessInfo.hProcess, ErrNo); }
  
  end;
end;

end.
