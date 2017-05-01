{*****************************************************************************
 *
 *  Main.pas - Demo for Directory Scanning Components
 *
 *  Copyright (c) 2000 Diego Amicabile
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


unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, uDADirScan, uDADirScanTreeView, ComCtrls, ExtCtrls,
  Buttons, uDaDirScanListView, uDADirScanDreamTreeView, dcDTree, DCGen,
  dctslite, dctsrc;

type
  TMainForm = class(TForm)
    PageControl: TPageControl;
    TreeViewTabSheet: TTabSheet;
    ListViewTabSheet: TTabSheet;
    TreeViewPanel: TPanel;
    TreeSplitter: TSplitter;
    TreeOptionsPanel: TPanel;
    DriveComboBox: TDriveComboBox;
    ControlPanel: TPanel;
    UpSpeedButton: TSpeedButton;
    SelectSpeedButton: TSpeedButton;
    ReloadSpeedButton: TSpeedButton;
    AcceptedEdit: TEdit;
    AcceptListBox: TListBox;
    EmptyDirCheckBox: TCheckBox;
    ContainLabel: TCheckBox;
    DeleteButton: TButton;
    Button1: TButton;
    ParseEdit: TEdit;
    StarLabel: TLabel;
    Edit1: TEdit;
    LevelsEdit: TEdit;
    LevelsLabel: TLabel;
    ListViewTopPanel: TPanel;
    DemoListView: TListView;
    DADirScanListView: TDADirScanListView;
    ListDriveComboBox: TDriveComboBox;
    ListUpSpeedButton: TSpeedButton;
    LargeIconsSpeedButton: TSpeedButton;
    IconSpeedButton: TSpeedButton;
    OptionsCheckBox: TCheckBox;
    ListReloadSpeedButton: TSpeedButton;
    ListSpeedButton: TSpeedButton;
    DCTreeViewSource1: TDCTreeViewSource;
    DemoTreeView: TDCMSTreeView;
    DemoDADirScanTreeView: TDADirScanDreamTreeView;
    procedure DriveComboBoxChange(Sender: TObject);
    procedure DemoTreeViewExpanding(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure FormShow(Sender: TObject);
    procedure AcceptListBoxClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AcceptedEditChange(Sender: TObject);
    procedure DemoTreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure SelectSpeedButtonClick(Sender: TObject);
    procedure ListUpSpeedButtonClick(Sender: TObject);
    procedure UpSpeedButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure ReloadSpeedButtonClick(Sender: TObject);
    procedure EmptyDirCheckBoxClick(Sender: TObject);
    procedure DemoDADirScanTreeViewFileFound(Sender: TObject;
      FileName: String; var CanAdd: Boolean);
    procedure ListReloadSpeedButtonClick(Sender: TObject);

    procedure LevelsEditChange(Sender: TObject);
    procedure ListDriveComboBoxChange(Sender: TObject);
    procedure DemoListViewDblClick(Sender: TObject);
    procedure ReportSpeedButtonClick(Sender: TObject);
    procedure LargeIconsSpeedButtonClick(Sender: TObject);
    procedure SmallIconsSpeedButtonClick(Sender: TObject);
    procedure IconSpeedButtonClick(Sender: TObject);
    procedure OptionsCheckBoxClick(Sender: TObject);
    procedure DADirScanListViewFileFound(Sender: TObject; FileName: String;
      var CanAdd: Boolean);
    procedure ListSpeedButtonClick(Sender: TObject);
    procedure DADirScanListViewAddingSubItems(Sender: TObject;
      Item: TListItem; SRC: TSearchRecClass);
  private
    procedure CopyOptions;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.DriveComboBoxChange(Sender: TObject);
begin
  DemoDADirScanTreeView.Directory := DriveComboBox.Drive+':\';
end;

procedure TMainForm.DemoTreeViewExpanding(Sender: TObject;
  Node: TTreeNode; var AllowCollapse: Boolean);
var DataString : String;
begin
  DataString := DemoDADirScanTreeView.GetFileNameAtNode(Node);
  DemoDADirScanTreeView.FillNode(Node, DataString);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  DemoDADirScanTreeView.AcceptedFiles := AcceptListBox.Items;
  DemoDADirScanTreeView.Directory := DriveComboBox.Drive+':\';
end;

procedure TMainForm.AcceptListBoxClick(Sender: TObject);
begin
  AcceptedEdit.Text := AcceptListBox.Items[AcceptListBox.ItemIndex];

end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  AcceptListBox.ItemIndex := AcceptListBox.Items.Add(AcceptedEdit.Text);
  DemoDADirScanTreeView.AcceptedFiles := AcceptListBox.Items;
end;

procedure TMainForm.AcceptedEditChange(Sender: TObject);
begin
  if AcceptListBox.ItemIndex <> -1 then
    AcceptListBox.Items[AcceptListBox.ItemIndex] := AcceptedEdit.Text;
  DemoDADirScanTreeView.AcceptedFiles := AcceptListBox.Items;
end;

procedure TMainForm.DemoTreeViewChange(Sender: TObject; Node: TTreeNode);

begin
  //Edit1.Text := DemoDADirScanTreeView.GetFileNameAtNode(Node)
end;

procedure TMainForm.SelectSpeedButtonClick(Sender: TObject);
var S : String;
begin
  if DemoTreeView.Selected <> nil then begin
    S := DemoDADirScanTreeView.GetFileNameAtNode(DemoTreeView.Selected);
    if (DemoDADirScanTreeView.IsADir(S)) then
      DemoDADirScanTreeView.Directory := S;
  end;
end;

procedure TMainForm.ListUpSpeedButtonClick(Sender: TObject);
var S : STring;
begin
  S := TDADirScan.GetFirstDir(DADirScanListView.Directory);
  DADirScanListView.Directory := S;

end;

procedure TMainForm.UpSpeedButtonClick(Sender: TObject);
var S : STring;
begin
  S := TDADirScan.GetFirstDir(DemoDADirScanTreeView.Directory);
  DemoDADirScanTreeView.Directory := S;

end;



procedure TMainForm.DeleteButtonClick(Sender: TObject);
begin
  if AcceptListBox.ItemIndex <> -1 then
    AcceptListBox.Items.Delete(AcceptListBox.ItemIndex);
  DemoDADirScanTreeView.AcceptedFiles := AcceptListBox.Items;

end;

procedure TMainForm.ReloadSpeedButtonClick(Sender: TObject);
begin
  DemoDADirScanTreeView.Reload;
end;

procedure TMainForm.ListReloadSpeedButtonClick(Sender: TObject);
begin
  if OptionsCheckBox.Checked then
    CopyOptions;
  DADirScanListView.Reload;
end;

procedure TMainForm.CopyOptions;
begin
  DADirScanListView.AcceptedFiles := AcceptListBox.Items;
end;

procedure TMainForm.EmptyDirCheckBoxClick(Sender: TObject);
begin
  DemoDADirScanTreeView.EmptyDirs := EmptyDirCheckBox.Checked;
end;

procedure TMainForm.DemoDADirScanTreeViewFileFound(Sender: TObject;
  FileName: String; var CanAdd: Boolean);
begin
  CanAdd := (Pos(ParseEdit.Text,FileName) > 0) or (not ContainLabel.Checked);
end;

procedure TMainForm.LevelsEditChange(Sender: TObject);
begin
  DemoDADirScanTreeView.Levels := StrToInt(LevelsEdit.Text);

end;

procedure TMainForm.ListDriveComboBoxChange(Sender: TObject);
begin
  DADirScanListView.Directory := ListDriveComboBox.Drive+':\';
end;

procedure TMainForm.DemoListViewDblClick(Sender: TObject);
begin
  if (DemoListView.Selected <> nil)  and
    DADirScanListView.IsADir(DADirScanListView.GetFileNameForItem(DemoListView.Selected)) then
      DADirScanListView.Directory := DADirScanListView.GetFileNameForItem(DemoListView.Selected);
end;

procedure TMainForm.ReportSpeedButtonClick(Sender: TObject);
begin
  DemoListView.ViewStyle := vsReport;
end;

procedure TMainForm.LargeIconsSpeedButtonClick(Sender: TObject);
begin
  DemoListView.ViewStyle := vsList;
end;

procedure TMainForm.SmallIconsSpeedButtonClick(Sender: TObject);
begin
  DemoListView.ViewStyle := vsSmallIcon;
end;

procedure TMainForm.IconSpeedButtonClick(Sender: TObject);
begin
  DemoListView.ViewStyle := vsIcon;
end;

procedure TMainForm.OptionsCheckBoxClick(Sender: TObject);
begin
  if OptionsCheckbox.Checked then
    CopyOptions;
    

end;

procedure TMainForm.DADirScanListViewFileFound(Sender: TObject;
  FileName: String; var CanAdd: Boolean);
begin
  CanAdd := (Pos(ParseEdit.Text,FileName) > 0) or
      (not ContainLabel.Checked)  or
      (not OPtionsCheckBox.Checked);

end;

procedure TMainForm.ListSpeedButtonClick(Sender: TObject);
begin
  DemoListView.ViewStyle := vsReport;
end;

procedure TMainForm.DADirScanListViewAddingSubItems(Sender: TObject;
  Item: TListItem; SRC: TSearchRecClass);
begin
  if SRC <> nil then begin
    Item.SubItems.Add(IntToStr(SRC.Size));
    Item.SubItems.Add(DateTimeToSTr(FileDateToDateTime(SRC.Time)));
  end;

end;

end.
