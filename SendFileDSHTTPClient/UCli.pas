unit UCli;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListBox,
  FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns,
  System.ioutils, System.json, System.netencoding, rest.utils, rest.Types,
  rest.Client, Data.Bind.Components, Data.Bind.ObjectScope, FMX.EditBox,
  FMX.NumberBox, FMX.Edit, ClientClassesUnit1, ClientModuleUnit1,
  FMX.DialogService, Data.DB, Datasnap.DBClient, Datasnap.DSConnect,
  System.hash, System.threading, System.permissions, FMX.Ani{$IFDEF ANDROID},
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os
{$ENDIF};

type
  TfrmMain = class(TForm)
    BtnSelFile: TButton;
    LaySelFilemob: TLayout;
    btnGal: TButton;
    BtnSend: TButton;
    lbFiles: TListBox;
    Label1: TLabel;
    Od: TOpenDialog;
    Alist: TActionList;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    btnCam: TButton;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    LaysendFile: TLayout;
    ToolBar1: TToolBar;
    sBSendFile: TSpeedButton;
    layCap: TLayout;
    lbCap: TLabel;
    btnExit: TButton;
    Layout1: TLayout;
    Layout2: TLayout;
    Label2: TLabel;
    Esrv: TEdit;
    LayPort: TLayout;
    Label3: TLabel;
    NBPort: TNumberBox;
    btnCon: TButton;
    LayContent: TLayout;
    btnclear: TButton;
    StyleBook1: TStyleBook;
    ClearEditButton1: TClearEditButton;
    BtnGetFiles: TSpeedButton;
    LayGetFiles: TLayout;
    LBFileList: TListBox;
    BtnDownloadFiles: TButton;
    BtnRefreshList: TButton;
    laywait: TLayout;
    LayMain: TLayout;
    pnlWait: TPanel;
    Aind: TAniIndicator;
    FlOpacity: TFloatAnimation;
    FlOpacity2: TFloatAnimation;
    LCapWait: TLabel;
    Label4: TLabel;

    procedure FormCreate(Sender: TObject);

    procedure BtnSelFileClick(Sender: TObject);
    procedure btnGalClick(Sender: TObject);
    procedure sBSendFileClick(Sender: TObject);
    procedure btnCamClick(Sender: TObject);
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
    function searchfile(aFileName: string): Boolean;
    procedure DelDubl;
    procedure btnExitClick(Sender: TObject);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
    procedure BtnSendClick(Sender: TObject);
    procedure btnConClick(Sender: TObject);
    procedure btnclearClick(Sender: TObject);
    procedure EsrvKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ShowHideWaitLay(aShow: Boolean);
    procedure FlOpacity2Finish(Sender: TObject);
    procedure BtnGetFilesClick(Sender: TObject);
    procedure BtnRefreshListClick(Sender: TObject);
    procedure BtnDownloadFilesClick(Sender: TObject);
    procedure RefreshList;

    procedure PermissionRequestResult(Sender: TObject;
      const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>);
    procedure DisplayRationale(Sender: TObject;
      const APermissions: TArray<string>; const APostRationaleProc: TProc);
    procedure PermissionRequestResult2(Sender: TObject;
      const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>);
  private
    fclModule: TServerMethods1Client;
    fCount: integer;
    Ftsk, FtskDow: ITask;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.iPhone55in.fmx IOS}

procedure TfrmMain.PermissionRequestResult2(Sender: TObject;
  const APermissions: TArray<string>;
  const AGrantResults: TArray<TPermissionStatus>);
begin
  // 3 permission involved
  if ((Length(AGrantResults) = 3) and
    (AGrantResults[0] = TPermissionStatus.Granted) and
    (AGrantResults[1] = TPermissionStatus.Granted) and
    (AGrantResults[2] = TPermissionStatus.Granted)) then
  else
  begin
    ShowMessage('Доступ не предоставлен');
    abort;
  end;
end;

procedure TfrmMain.DisplayRationale(Sender: TObject;
  const APermissions: TArray<string>; const APostRationaleProc: TProc);
begin
  TDialogService.ShowMessage('Необходим доступ к камере и накопителю',
    procedure(const AResult: TModalResult)
    begin
      APostRationaleProc;
    end);

end;

procedure TfrmMain.PermissionRequestResult(Sender: TObject;
const APermissions: TArray<string>;
const AGrantResults: TArray<TPermissionStatus>);
begin
  // 3 permission involved
  if (Length(AGrantResults) = 3) and
    (AGrantResults[0] = TPermissionStatus.Granted) and
    (AGrantResults[1] = TPermissionStatus.Granted) and
    (AGrantResults[2] = TPermissionStatus.Granted) then
  else
    ShowMessage('Доступ не предоставлен');
end;

procedure TfrmMain.btnCamClick(Sender: TObject);
begin
  TakePhotoFromCameraAction1.Execute;
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.btnGalClick(Sender: TObject);
begin
  TakePhotoFromLibraryAction1.Execute;
end;

procedure TfrmMain.BtnGetFilesClick(Sender: TObject);
begin
  LaysendFile.Visible := False;
  LayGetFiles.Visible := True;
  ShowHideWaitLay(True);
  TThread.CreateAnonymousThread(
    procedure()
    begin

      BtnRefreshListClick(Sender);
      TThread.Synchronize(nil,
        procedure()
        begin
          ShowHideWaitLay(False);
        end);
    end).Start;

end;

procedure TfrmMain.BtnRefreshListClick(Sender: TObject);
begin
  if Sender <> nil then
  begin
    ShowHideWaitLay(True);
    TThread.CreateAnonymousThread(
      procedure()
      begin
        TThread.Synchronize(nil,
          procedure()
          begin
            RefreshList;
            ShowHideWaitLay(False);
          end);
      end).Start;
  end
  else
    RefreshList;

end;

procedure TfrmMain.BtnSelFileClick(Sender: TObject);
var
  li, lj: integer;
  lres: Boolean;
begin
{$IFDEF MSWINDOWS}
  if (Od.Execute) then
    if Od.Files.Count > 0 then
    begin
      lbFiles.BeginUpdate;
      lres := False;
      for li := 0 to Od.Files.Count - 1 do
      begin
        lres := False;
        for lj := 0 to lbFiles.Items.Count - 1 do
          if (Od.Files[li].ToUpper = lbFiles.Items[lj].ToUpper) then
            lres := True;
        if not lres then
        begin
          lbFiles.Items.Add(Od.Files[li]);
        end;
      end;
      lbFiles.EndUpdate;
    end
    else
      exit;

{$ELSE}   {$IFDEF MACOS}
  if (Od.Execute) then
    if Od.Files.Count > 0 then
    begin
      lbFiles.BeginUpdate;
      for li := 0 to Od.Files.Count - 1 do
      begin
        lres := False;
        for lj := 0 to lbFiles.Items.Count - 1 do
          if (Od.Files[li].ToUpper = lbFiles.Items[lj].ToUpper) then
            lres := True;
        if not lres then
        begin
          lbFiles.Items.Add(Od.Files[li]);
        end;
      end;
      lbFiles.EndUpdate;
    end
    else
      exit;
  // DelDubl;
{$ENDIF}
{$ENDIF}
end;

procedure TfrmMain.BtnSendClick(Sender: TObject);
begin

  if not LayContent.Enabled then
    exit;
  if lbFiles.Count <= 0 then
  begin
    TDialogService.MessageDialog('Файлов для передачи не выбрано',
      TMsgDlgType.mtInformation, [tmsgdlgbtn.mbOK], tmsgdlgbtn.mbOK, 0, nil);
    exit;
  end;
  ShowHideWaitLay(True);
  if Assigned(Ftsk) then
    Ftsk := nil;
  Ftsk := ttask.Create(
    procedure()
    begin
      TParallel.For(0, lbFiles.Items.Count - 1,
        procedure(li: integer)
        var
          lmemstream: TFileStream;
          lstrStream: TStringStream;
          ljsofile: tjsonobject;
          resulthash, lj: integer;
          lfname, lhash: string;
          lcountpart, cursize, lstartsize, lsizes: integer;
          lCountStream: TMemoryStream;
          lSrvMeth: TServerMethods1Client;
        begin
          lfname := lbFiles.Items[li];
          if not TFile.Exists(lfname) then
            exit;
          lhash := THashMD5.GetHashStringFromFile(lfname);
          lmemstream := TFileStream.Create(lfname, fmOpenRead or
            fmShareDenyWrite);
          lmemstream.Position := 0;
          lstartsize := lmemstream.Size;
          lSrvMeth := TServerMethods1Client.Create
            (ClientModule1.DSRestConnection1);
          resulthash := lSrvMeth.CompareFile(ExtractFileName(lfname), lhash);
          lSrvMeth.Free;
          if resulthash = -1 then
            exit;
          lsizes := (1024 * 30);
          // fclModule.st
          /// fclModule.StartSendFile(ExtractFileName(lbFiles.Items[li]));
          if lmemstream.Size <= lsizes then
          begin
            lCountStream := TMemoryStream.Create;
            lCountStream.LoadFromStream(lmemstream);
            try
              lSrvMeth.SendPartStream(ExtractFileName(lfname), lCountStream,
                lCountStream.Size);
            except

            end;
          end
          else
          begin
            lcountpart := (lmemstream.Size div lsizes);
            if (lmemstream.Size mod lsizes) <> 0 then
              inc(lcountpart);
            for lj := 0 to lcountpart - 1 do
            begin
              if resulthash <> 0 then
                if lj < resulthash then
                  Continue;
              /// докачка
              if lj = 0 then
                lmemstream.Position := 0
              else
                lmemstream.Position := lj * lsizes;
              lCountStream := TMemoryStream.Create;

              if lj = (lcountpart - 1) then
                lCountStream.CopyFrom(lmemstream,
                  lstartsize - ((lcountpart - 1) * lsizes))
              else
                lCountStream.CopyFrom(lmemstream, lsizes);

              lSrvMeth := TServerMethods1Client.Create
                (ClientModule1.DSRestConnection1);
              lSrvMeth.SendPartStream(ExtractFileName(lfname), lCountStream,
                lCountStream.Size);

              lSrvMeth.Free;
            end;
            lSrvMeth := TServerMethods1Client.Create
              (ClientModule1.DSRestConnection1);
            lSrvMeth.StopStream(ExtractFileName(lfname));
            if Assigned(lSrvMeth) then
            begin
              lSrvMeth.Free;
            end;
          end;
          lmemstream.Destroy;
          lmemstream := nil;
        end);

      TThread.Synchronize(nil,
        procedure()
        begin
          if lbFiles.Items.Count > 0 then
          begin
            ShowHideWaitLay(False);
            TDialogService.MessageDialog('Все файлы были отправлены ',
              TMsgDlgType.mtInformation, [tmsgdlgbtn.mbOK],
              tmsgdlgbtn.mbOK, 0, nil);
            lbFiles.Clear;

          end;
        end);
    end);
  Ftsk.Start;
end;

procedure TfrmMain.btnclearClick(Sender: TObject);
var
  li: integer;
  lpath: string;
begin
  lbFiles.Clear;
{$IFDEF ANDROID}
  for li := 0 to fCount do
  begin
    lpath := TPath.GetPublicPath + PathDelim + 'snap' + li.ToString + '.png';
    if TFile.Exists(lpath) then
      TFile.Delete(lpath);
    fCount := 0;
    lbFiles.ItemIndex := fCount;
  end;
{$ENDIF}
{$IFDEF IOS}
  for li := 0 to fCount do
  begin
    lpath := TPath.GetPublicPath + PathDelim + 'snap' + li.ToString + '.png';
    if TFile.Exists(lpath) then
      TFile.Delete(lpath);
    fCount := 0;
    lbFiles.ItemIndex := fCount;
  end;
{$ENDIF}
end;

procedure TfrmMain.btnConClick(Sender: TObject);
begin
  Esrv.Text := StringReplace(Esrv.Text, ' ', '', [rfReplaceAll]);
  if TButton(Sender).Text = 'Отключиться' then
  begin
    Esrv.Enabled := True;
    NBPort.Enabled := True;
    LayContent.Enabled := False;
    lbFiles.Clear;
    TButton(Sender).Text := 'Подключиться';
    laywait.Visible := False;
    LBFileList.Clear;
    // fclModule.free;
    exit;
  end;
  ClientModule1.DSRestConnection1.Host := Esrv.Text;
  ClientModule1.DSRestConnection1.Port := NBPort.Text.ToInteger;
  ShowHideWaitLay(True);
  TThread.CreateAnonymousThread(
    procedure()
    begin
      fclModule := TServerMethods1Client.Create
        (ClientModule1.DSRestConnection1);

      try
        if fclModule.Connect then
        begin
          Esrv.Enabled := False;
          NBPort.Enabled := False;
          LayContent.Enabled := True;
          TButton(Sender).Text := 'Отключиться';
        end;
        fclModule.Free;
        TThread.Synchronize(nil,
          procedure()
          begin
            ShowHideWaitLay(False);
          end);
      except
        on E: exception do
        begin
          TThread.Synchronize(nil,
            procedure()
            begin
              TDialogService.MessageDialog('Не удалось подключиться к серверу '
                + Esrv.Text + ' по порту ' + NBPort.Text + sLineBreak +
                E.Message, TMsgDlgType.mtError, [tmsgdlgbtn.mbOK],
                tmsgdlgbtn.mbOK, 0, nil);
              Esrv.Enabled := True;
              NBPort.Enabled := True;
              LayContent.Enabled := False;
              ShowHideWaitLay(False);
              fclModule.Free;
            end);
        end;
      end;
    end).Start;
end;

procedure TfrmMain.BtnDownloadFilesClick(Sender: TObject);
  function checkFiles: Boolean;
  var
    li: integer;
  begin
    result := False;
    for li := 0 to LBFileList.Count - 1 do
      if LBFileList.ItemByIndex(li).TagObject is TCheckBox then
        if TCheckBox(LBFileList.ItemByIndex(li).TagObject).IsChecked then
          exit(True);

  end;

begin
  if LBFileList.Count <= 0 then
  begin
    TDialogService.MessageDialog('Для начала нужно получить список файлов',
      TMsgDlgType.mtInformation, [tmsgdlgbtn.mbOK], tmsgdlgbtn.mbOK, 0, nil);
    exit;
  end;
  if not checkFiles then
  begin
    TDialogService.MessageDialog('Не один файл не выбран',
      TMsgDlgType.mtInformation, [tmsgdlgbtn.mbOK], tmsgdlgbtn.mbOK, 0, nil);
    exit;
  end;
  ShowHideWaitLay(True);
  FtskDow := nil;

  FtskDow := ttask.Create(
    procedure()
    begin
      TParallel.For(0, LBFileList.Count - 1,
        procedure(i: integer)
        var
          lmes: TServerMethods1Client;
          lstrm: TMemoryStream;
          lpath, lfname: string;
        begin
          if (LBFileList.ItemByIndex(i).TagObject is TCheckBox) and
            TCheckBox(LBFileList.ItemByIndex(i).TagObject).IsChecked then
          begin
            lpath := TPath.GetSharedDownloadsPath + PathDelim;

            lmes := TServerMethods1Client.Create
              (ClientModule1.DSRestConnection1);
            try
              lfname := TCheckBox(LBFileList.ItemByIndex(i).TagObject).Text;
              lstrm := TMemoryStream(lmes.LoadFile(lfname));
              if TFile.Exists(lpath + lfname) then
                lfname := StringReplace(lfname, ExtractFileExt(lfname),
                  StringReplace('(' + StringReplace(DateTimeToStr(now()) + ')',
                  ':', '', [rfReplaceAll]), '.', '', [rfReplaceAll]),
                  [rfReplaceAll]) + ExtractFileExt(lfname);
              lstrm.SaveToFile(lpath + lfname);

            finally
              lmes.Free;
            end;
          end;

        end);
      TThread.Synchronize(nil,
        procedure()
        begin
          BtnRefreshListClick(nil);
          ShowHideWaitLay(False);
          TDialogService.MessageDialog('Выбранные файлы сохранены в каталог "' +
            TPath.GetSharedDownloadsPath + PathDelim + '"',
            TMsgDlgType.mtInformation, [tmsgdlgbtn.mbOK],
            tmsgdlgbtn.mbOK, 0, nil);

        end);
    end);
  FtskDow.Start;
end;

procedure TfrmMain.DelDubl;
var
  li, lj: integer;
begin

  for li := lbFiles.Items.Count - 1 downto 0 do
    for lj := lbFiles.Items.Count - 1 downto 0 do
      if (lbFiles.Items[li] = lbFiles.Items[lj]) and (li <> lj) then
        lbFiles.ItemByIndex(lj).Destroy;
end;

procedure TfrmMain.EsrvKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
Shift: TShiftState);
begin
  if Key = 13 then
    btnConClick(btnCon);

end;

procedure TfrmMain.FlOpacity2Finish(Sender: TObject);
begin
  if Sender is TFloatAnimation then
    with TFloatAnimation(Sender) do
    begin
      if StopValue = 0 then
        TControl(Parent).Visible := False;
    end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
{$IFDEF ANDROID}
var
  permCam, permRead, permWrite: string;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  BtnSelFile.Visible := True;
  LaySelFilemob.Visible := False;
{$ELSE}{$IFDEF MACOS}
  BtnSelFile.Visible := True;
  LaySelFilemob.Visible := False;
{$ELSE}
  BtnSelFile.Visible := False;
  LaySelFilemob.Visible := True;
{$ENDIF}
{$ENDIF}
{$IFDEF ANDROID}
  permCam := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  permRead := JStringToString
    (TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
  permWrite := JStringToString
    (TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
  PermissionsService.RequestPermissions([permCam, permRead, permWrite],
    PermissionRequestResult, DisplayRationale);

{$ENDIF}
end;

procedure TfrmMain.RefreshList;

var
  lit: TListBoxItem;
  ls: TStringList;
  li: integer;
  chb: TCheckBox;
begin

  fclModule := TServerMethods1Client.Create(ClientModule1.DSRestConnection1);
  try
    LBFileList.Clear;
    LBFileList.BeginUpdate;
    ls := fclModule.GetFileList;
    for li := 0 to ls.Count - 1 do
    begin
      lit := TListBoxItem.Create(LBFileList);
      lit.Parent := LBFileList;
      lit.Visible := True;
      lit.height := 50;
      chb := TCheckBox.Create(lit);
      chb.Parent := lit;
      chb.Text := ls[li];
      chb.Align := TAlignLayout.Client;
      chb.Visible := True;
      lit.TagObject := chb;
    end;
    LBFileList.EndUpdate;
  finally
    fclModule.Free;
  end;

end;

procedure TfrmMain.sBSendFileClick(Sender: TObject);
begin
  LaysendFile.Visible := True;
  LayGetFiles.Visible := False;
end;

function TfrmMain.searchfile(aFileName: string): Boolean;
var
  litem: string;
  li: integer;
begin
  result := False;
  if aFileName.IsEmpty then
    exit;
  lbFiles.BeginUpdate;
  for li := 0 to lbFiles.Items.Count - 1 do
    if aFileName.ToUpper = lbFiles.Items[li].ToUpper then
    begin
      lbFiles.EndUpdate;
      exit(True);

    end;
  lbFiles.EndUpdate;
end;

procedure TfrmMain.ShowHideWaitLay(aShow: Boolean);
begin
  FlOpacity.Enabled := False;
  FlOpacity2.Enabled := False;

  FlOpacity.Duration := 0.2;
  FlOpacity2.Duration := 0.2;
  FlOpacity.Delay := 0;
  FlOpacity2.Delay := 0;
  if aShow then
  begin
    laywait.Visible := True;
    laywait.Opacity := 0;
    LayMain.Enabled := False;
    FlOpacity2.StartValue := 1;
    FlOpacity2.StopValue := 0;
    FlOpacity.StartValue := 0;
    FlOpacity.StopValue := 1;
    Aind.Enabled := True;

  end
  else
  begin
    LayMain.Visible := True;
    LayMain.Opacity := 0;
    LayMain.Enabled := True;
    FlOpacity2.StartValue := 0;
    FlOpacity2.StopValue := 1;
    FlOpacity.StartValue := 1;
    FlOpacity.StopValue := 0;
    Aind.Enabled := False;

  end;
  FlOpacity.StartFromCurrent := True;
  FlOpacity2.StartFromCurrent := True;
  FlOpacity.Enabled := True;
  FlOpacity2.Enabled := True;
end;

procedure TfrmMain.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);

{$IFDEF ANDROID}
var
  li: TListBoxItem;
  permCam, permRead, permWrite: string;
{$ENDIF}
begin
{$IFDEF ANDROID}
  permCam := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  permRead := JStringToString
    (TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
  permWrite := JStringToString
    (TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
  PermissionsService.RequestPermissions([permCam, permRead, permWrite],
    PermissionRequestResult2, DisplayRationale);
{$ENDIF}
  ShowHideWaitLay(True);
  TThread.CreateAnonymousThread(
    procedure()
    var
      lpath: string;
      li: TListBoxItem;
    begin
      lpath := TPath.GetPublicPath;
      if Assigned(Image) then
      begin
        inc(fCount);
        lpath := lpath + PathDelim + 'snap' + fCount.ToString + '.png';
        Image.SaveToFile(lpath);
        TThread.Synchronize(nil,
          procedure()
          begin
            if not searchfile(lpath) then
            begin
              li := TListBoxItem.Create(lbFiles);
              li.Parent := lbFiles;
              li.Text := lpath;
              li.TextSettings.WordWrap := True;
              li.height := 60;
              li.Visible := True;
              li.Repaint;
             // lbFiles.Items.Add(lpath);
            end;
            ShowHideWaitLay(False);
          end);
      end;
    end).Start;
end;

procedure TfrmMain.TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
begin
  TakePhotoFromCameraAction1DidFinishTaking(Image);
end;

end.
