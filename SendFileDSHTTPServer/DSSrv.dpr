program DSSrv;
{$APPTYPE CONSOLE}
{$R *.dres}

uses
  System.SysUtils,
  System.Types,
  IPPeerServer,
  IPPeerAPI,
  IdHTTPWebBrokerBridge,
  Web.WebReq,
  Web.WebBroker,
  Datasnap.DSSession,
  ServerMethodsUnit1
    in 'ServerMethodsUnit1.pas' {ServerMethods1: TDSServerModule} ,
  ServerContainerUnit1 in 'ServerContainerUnit1.pas' {SContM: TDataModule} ,
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WModule: TWebModule} ,
  ServerConst1 in 'ServerConst1.pas',
  System.ioUtils;

{$R *.res}

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

function BindPort(APort: Integer): Boolean;
var
  LTestServer: IIPTestServer;
begin
  Result := True;
  try
    LTestServer := PeerFactory.CreatePeer('', IIPTestServer) as IIPTestServer;
    LTestServer.TestOpenPort(APort, nil);
  except
    Result := False;
  end;
end;

function CheckPort(APort: Integer): Integer;
begin
  if BindPort(APort) then
    Result := APort
  else
    Result := 0;
end;

procedure SetEncPort;
var
  lport: string;
begin
  writeln('-Port: ');
  Read(lport);
  if CheckPort(lport.ToInteger) > 0 then
  begin
    writeln('-Enc Port ' + lport + ' setup');
    DsServicehttp.HttpPort := lport.ToInteger;
  end
  else
    writeln(Format(sPortInUse, [lport]));
end;

procedure SetCatalog(aCatalog: string = '');
begin
  if aCatalog.ToUpper.Equals('SET PATH') then
  begin
    writeln('- Catalog: ');
    Read(aCatalog);
    if trim(aCatalog).IsEmpty then
      ServerFileCatalog := TPath.GetPublicPath + PathDelim + 'srvds' +
        PathDelim + 'file'
    else
      ServerFileCatalog := aCatalog;
  end
  else
  begin
    if aCatalog.IsEmpty then
      ServerFileCatalog := TPath.GetPublicPath + PathDelim + 'srvds' +
        PathDelim + 'file'
    else
      ServerFileCatalog := aCatalog;
  end;
  try
    ForceDirectories(ServerFileCatalog);
    writeln('Setup Catalog: "' + ServerFileCatalog + '"');

  except
    on E: exception do
      writeln('Invalid catalog: ' + E.Message + ' Pls try again other catalog');
  end;

end;

procedure SetPort(const AServer: TIdHTTPWebBrokerBridge; APort: String);
begin
  if not AServer.Active then
  begin
    APort := APort.Replace(cCommandSetPort, '').trim;
    if CheckPort(APort.ToInteger) > 0 then
    begin
      AServer.DefaultPort := APort.ToInteger;
      writeln(Format(sPortSet, [APort]));
    end
    else
      writeln(Format(sPortInUse, [APort]));
  end
  else
    writeln(sServerRunning);
  Write(cArrow);
end;

procedure StartServer(const AServer: TIdHTTPWebBrokerBridge);
begin
  if not AServer.Active then
  begin
    if CheckPort(AServer.DefaultPort) > 0 then
    begin
      writeln(Format(sStartingServer, [AServer.DefaultPort,DsServicehttp.httpport.tostring]));
      AServer.Bindings.Clear;
      AServer.Active := True;
    end
    else
      writeln(Format(sPortInUse, [AServer.DefaultPort.ToString]));
  end
  else
    writeln(sServerRunning);
  Write(cArrow);
end;

procedure StopServer(const AServer: TIdHTTPWebBrokerBridge);
begin
  if AServer.Active then
  begin
    writeln(sStoppingServer);
    TerminateThreads;
    AServer.Active := False;
    AServer.Bindings.Clear;
    writeln(sServerStopped);
  end
  else
    writeln(sServerNotRunning);
  Write(cArrow);
end;

procedure WriteCommands;
begin
  writeln(sCommands);
  Write(cArrow);
end;

procedure WriteStatus(const AServer: TIdHTTPWebBrokerBridge);
begin
  writeln(sIndyVersion + AServer.SessionList.Version);
  writeln(sActive + AServer.Active.ToString(TUseBoolStrs.True));
  writeln(sPort + AServer.DefaultPort.ToString);
  writeln(sEncPort + DsServicehttp.HttpPort.ToString);
  writeln(sPath + ServerFileCatalog);
  writeln(sSessionID + AServer.SessionIDCookieName);
  Write(cArrow);
end;

procedure RunServer(APort: Integer);
var
  LServer: TIdHTTPWebBrokerBridge;
  LResponse: string;
begin
  SetCatalog(EmptyStr);

  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.DefaultPort := APort;

    LServer.KeepAlive := True;
    writeln(Format(sPorts, [LServer.DefaultPort.ToString,
      DsServicehttp.HttpPort.ToString]));
    WriteCommands;
    while True do
    begin
      Readln(LResponse);
      LResponse := LowerCase(LResponse).trim;
      if LResponse.StartsWith(cCommandSetPort) then
        SetPort(LServer, LResponse)
      else if sametext(LResponse, cCommandStart) then
        StartServer(LServer)
      else if sametext(LResponse, cCommandStatus) then
        WriteStatus(LServer)
      else if sametext(LResponse, cCommandStop) then
        StopServer(LServer)
      else if sametext(LResponse, cCommandHelp) then
        WriteCommands
      else if sametext(LResponse.ToUpper, cCommandsetcatalog.ToUpper) then
        SetCatalog(LResponse)
      else if sametext(LResponse.ToUpper, cCommandSetEncPort.ToUpper) then
      begin
        SetEncPort;
        writeln(Format(sPorts, [LServer.DefaultPort.ToString,
          DsServicehttp.HttpPort.ToString]));
      end
      else if sametext(LResponse.ToUpper, cCommandExit.ToUpper) then
        if LServer.Active then
        begin
          StopServer(LServer);
          break
        end
        else
          break

      else
      begin
        if not LResponse.IsEmpty then
          writeln(sInvalidCommand);
        Write(cArrow);
      end;
    end;
    TerminateThreads();
  finally
    LServer.Free;
  end;
end;

begin
  try

    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    RunServer(8081);
  except
    on E: exception do
      writeln(E.ClassName, ': ', E.Message);
  end

end.
