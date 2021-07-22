//
// Created by the DataSnap proxy generator.
// 21.07.2021 21:55:12
//

unit ClientClassesUnit1;

interface

uses System.JSON, Datasnap.DSProxyRest, Datasnap.DSClientRest, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type

  IDSRestCachedTStringList = interface;

  TServerMethods1Client = class(TDSAdminRestClient)
  private
    FEchoStringCommand: TDSRestCommand;
    FReverseStringCommand: TDSRestCommand;
    FupdatefilemCommand: TDSRestCommand;
    FSendPartStreamCommand: TDSRestCommand;
    FStartSendFileCommand: TDSRestCommand;
    FStopStreamCommand: TDSRestCommand;
    FCompareFileCommand: TDSRestCommand;
    FConnectCommand: TDSRestCommand;
    FGetFileListCommand: TDSRestCommand;
    FGetFileListCommand_Cache: TDSRestCommand;
    FLoadFileCommand: TDSRestCommand;
    FLoadFileCommand_Cache: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function EchoString(Value: string; const ARequestFilter: string = ''): string;
    function ReverseString(Value: string; const ARequestFilter: string = ''): string;
    function updatefilem(ajsO: TJSONObject; const ARequestFilter: string = ''): Boolean;
    function SendPartStream(aName: string; Stream: TStream; inSize: Integer; const ARequestFilter: string = ''): Boolean;
    function StartSendFile(aName: string; const ARequestFilter: string = ''): Boolean;
    function StopStream(aName: string; const ARequestFilter: string = ''): Boolean;
    function CompareFile(aName: string; ahash: string; const ARequestFilter: string = ''): Integer;
    function Connect(const ARequestFilter: string = ''): Boolean;
    function GetFileList(const ARequestFilter: string = ''): TStringList;
    function GetFileList_Cache(const ARequestFilter: string = ''): IDSRestCachedTStringList;
    function LoadFile(aName: string; const ARequestFilter: string = ''): TStream;
    function LoadFile_Cache(aName: string; const ARequestFilter: string = ''): IDSRestCachedStream;
  end;

  IDSRestCachedTStringList = interface(IDSRestCachedObject<TStringList>)
  end;

  TDSRestCachedTStringList = class(TDSRestCachedObject<TStringList>, IDSRestCachedTStringList, IDSRestCachedCommand)
  end;

const
  TServerMethods1_EchoString: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_ReverseString: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_updatefilem: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'ajsO'; Direction: 1; DBXType: 37; TypeName: 'TJSONObject'),
    (Name: ''; Direction: 4; DBXType: 4; TypeName: 'Boolean')
  );

  TServerMethods1_SendPartStream: array [0..3] of TDSRestParameterMetaData =
  (
    (Name: 'aName'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'Stream'; Direction: 1; DBXType: 33; TypeName: 'TStream'),
    (Name: 'inSize'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 4; TypeName: 'Boolean')
  );

  TServerMethods1_StartSendFile: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'aName'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 4; TypeName: 'Boolean')
  );

  TServerMethods1_StopStream: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'aName'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 4; TypeName: 'Boolean')
  );

  TServerMethods1_CompareFile: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'aName'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ahash'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 6; TypeName: 'Integer')
  );

  TServerMethods1_Connect: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 4; TypeName: 'Boolean')
  );

  TServerMethods1_GetFileList: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 37; TypeName: 'TStringList')
  );

  TServerMethods1_GetFileList_Cache: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

  TServerMethods1_LoadFile: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'aName'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 33; TypeName: 'TStream')
  );

  TServerMethods1_LoadFile_Cache: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'aName'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'String')
  );

implementation

function TServerMethods1Client.EchoString(Value: string; const ARequestFilter: string): string;
begin
  if FEchoStringCommand = nil then
  begin
    FEchoStringCommand := FConnection.CreateCommand;
    FEchoStringCommand.RequestType := 'GET';
    FEchoStringCommand.Text := 'TServerMethods1.EchoString';
    FEchoStringCommand.Prepare(TServerMethods1_EchoString);
  end;
  FEchoStringCommand.Parameters[0].Value.SetWideString(Value);
  FEchoStringCommand.Execute(ARequestFilter);
  Result := FEchoStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.ReverseString(Value: string; const ARequestFilter: string): string;
begin
  if FReverseStringCommand = nil then
  begin
    FReverseStringCommand := FConnection.CreateCommand;
    FReverseStringCommand.RequestType := 'GET';
    FReverseStringCommand.Text := 'TServerMethods1.ReverseString';
    FReverseStringCommand.Prepare(TServerMethods1_ReverseString);
  end;
  FReverseStringCommand.Parameters[0].Value.SetWideString(Value);
  FReverseStringCommand.Execute(ARequestFilter);
  Result := FReverseStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.updatefilem(ajsO: TJSONObject; const ARequestFilter: string): Boolean;
begin
  if FupdatefilemCommand = nil then
  begin
    FupdatefilemCommand := FConnection.CreateCommand;
    FupdatefilemCommand.RequestType := 'POST';
    FupdatefilemCommand.Text := 'TServerMethods1."updatefilem"';
    FupdatefilemCommand.Prepare(TServerMethods1_updatefilem);
  end;
  FupdatefilemCommand.Parameters[0].Value.SetJSONValue(ajsO, FInstanceOwner);
  FupdatefilemCommand.Execute(ARequestFilter);
  Result := FupdatefilemCommand.Parameters[1].Value.GetBoolean;
end;

function TServerMethods1Client.SendPartStream(aName: string; Stream: TStream; inSize: Integer; const ARequestFilter: string): Boolean;
begin
  if FSendPartStreamCommand = nil then
  begin
    FSendPartStreamCommand := FConnection.CreateCommand;
    FSendPartStreamCommand.RequestType := 'POST';
    FSendPartStreamCommand.Text := 'TServerMethods1."SendPartStream"';
    FSendPartStreamCommand.Prepare(TServerMethods1_SendPartStream);
  end;
  FSendPartStreamCommand.Parameters[0].Value.SetWideString(aName);
  FSendPartStreamCommand.Parameters[1].Value.SetStream(Stream, FInstanceOwner);
  FSendPartStreamCommand.Parameters[2].Value.SetInt32(inSize);
  FSendPartStreamCommand.Execute(ARequestFilter);
  Result := FSendPartStreamCommand.Parameters[3].Value.GetBoolean;
end;

function TServerMethods1Client.StartSendFile(aName: string; const ARequestFilter: string): Boolean;
begin
  if FStartSendFileCommand = nil then
  begin
    FStartSendFileCommand := FConnection.CreateCommand;
    FStartSendFileCommand.RequestType := 'GET';
    FStartSendFileCommand.Text := 'TServerMethods1.StartSendFile';
    FStartSendFileCommand.Prepare(TServerMethods1_StartSendFile);
  end;
  FStartSendFileCommand.Parameters[0].Value.SetWideString(aName);
  FStartSendFileCommand.Execute(ARequestFilter);
  Result := FStartSendFileCommand.Parameters[1].Value.GetBoolean;
end;

function TServerMethods1Client.StopStream(aName: string; const ARequestFilter: string): Boolean;
begin
  if FStopStreamCommand = nil then
  begin
    FStopStreamCommand := FConnection.CreateCommand;
    FStopStreamCommand.RequestType := 'GET';
    FStopStreamCommand.Text := 'TServerMethods1.StopStream';
    FStopStreamCommand.Prepare(TServerMethods1_StopStream);
  end;
  FStopStreamCommand.Parameters[0].Value.SetWideString(aName);
  FStopStreamCommand.Execute(ARequestFilter);
  Result := FStopStreamCommand.Parameters[1].Value.GetBoolean;
end;

function TServerMethods1Client.CompareFile(aName: string; ahash: string; const ARequestFilter: string): Integer;
begin
  if FCompareFileCommand = nil then
  begin
    FCompareFileCommand := FConnection.CreateCommand;
    FCompareFileCommand.RequestType := 'GET';
    FCompareFileCommand.Text := 'TServerMethods1.CompareFile';
    FCompareFileCommand.Prepare(TServerMethods1_CompareFile);
  end;
  FCompareFileCommand.Parameters[0].Value.SetWideString(aName);
  FCompareFileCommand.Parameters[1].Value.SetWideString(ahash);
  FCompareFileCommand.Execute(ARequestFilter);
  Result := FCompareFileCommand.Parameters[2].Value.GetInt32;
end;

function TServerMethods1Client.Connect(const ARequestFilter: string): Boolean;
begin
  if FConnectCommand = nil then
  begin
    FConnectCommand := FConnection.CreateCommand;
    FConnectCommand.RequestType := 'GET';
    FConnectCommand.Text := 'TServerMethods1.Connect';
    FConnectCommand.Prepare(TServerMethods1_Connect);
  end;
  FConnectCommand.Execute(ARequestFilter);
  Result := FConnectCommand.Parameters[0].Value.GetBoolean;
end;

function TServerMethods1Client.GetFileList(const ARequestFilter: string): TStringList;
begin
  if FGetFileListCommand = nil then
  begin
    FGetFileListCommand := FConnection.CreateCommand;
    FGetFileListCommand.RequestType := 'GET';
    FGetFileListCommand.Text := 'TServerMethods1.GetFileList';
    FGetFileListCommand.Prepare(TServerMethods1_GetFileList);
  end;
  FGetFileListCommand.Execute(ARequestFilter);
  if not FGetFileListCommand.Parameters[0].Value.IsNull then
  begin
    FUnMarshal := TDSRestCommand(FGetFileListCommand.Parameters[0].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TStringList(FUnMarshal.UnMarshal(FGetFileListCommand.Parameters[0].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FGetFileListCommand.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.GetFileList_Cache(const ARequestFilter: string): IDSRestCachedTStringList;
begin
  if FGetFileListCommand_Cache = nil then
  begin
    FGetFileListCommand_Cache := FConnection.CreateCommand;
    FGetFileListCommand_Cache.RequestType := 'GET';
    FGetFileListCommand_Cache.Text := 'TServerMethods1.GetFileList';
    FGetFileListCommand_Cache.Prepare(TServerMethods1_GetFileList_Cache);
  end;
  FGetFileListCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedTStringList.Create(FGetFileListCommand_Cache.Parameters[0].Value.GetString);
end;

function TServerMethods1Client.LoadFile(aName: string; const ARequestFilter: string): TStream;
begin
  if FLoadFileCommand = nil then
  begin
    FLoadFileCommand := FConnection.CreateCommand;
    FLoadFileCommand.RequestType := 'GET';
    FLoadFileCommand.Text := 'TServerMethods1.LoadFile';
    FLoadFileCommand.Prepare(TServerMethods1_LoadFile);
  end;
  FLoadFileCommand.Parameters[0].Value.SetWideString(aName);
  FLoadFileCommand.Execute(ARequestFilter);
  Result := FLoadFileCommand.Parameters[1].Value.GetStream(FInstanceOwner);
end;

function TServerMethods1Client.LoadFile_Cache(aName: string; const ARequestFilter: string): IDSRestCachedStream;
begin
  if FLoadFileCommand_Cache = nil then
  begin
    FLoadFileCommand_Cache := FConnection.CreateCommand;
    FLoadFileCommand_Cache.RequestType := 'GET';
    FLoadFileCommand_Cache.Text := 'TServerMethods1.LoadFile';
    FLoadFileCommand_Cache.Prepare(TServerMethods1_LoadFile_Cache);
  end;
  FLoadFileCommand_Cache.Parameters[0].Value.SetWideString(aName);
  FLoadFileCommand_Cache.ExecuteCache(ARequestFilter);
  Result := TDSRestCachedStream.Create(FLoadFileCommand_Cache.Parameters[1].Value.GetString);
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection);
begin
  inherited Create(ARestConnection);
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ARestConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  FEchoStringCommand.DisposeOf;
  FReverseStringCommand.DisposeOf;
  FupdatefilemCommand.DisposeOf;
  FSendPartStreamCommand.DisposeOf;
  FStartSendFileCommand.DisposeOf;
  FStopStreamCommand.DisposeOf;
  FCompareFileCommand.DisposeOf;
  FConnectCommand.DisposeOf;
  FGetFileListCommand.DisposeOf;
  FGetFileListCommand_Cache.DisposeOf;
  FLoadFileCommand.DisposeOf;
  FLoadFileCommand_Cache.DisposeOf;
  inherited;
end;

end.

