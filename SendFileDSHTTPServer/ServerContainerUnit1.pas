unit ServerContainerUnit1;

interface

uses System.SysUtils, System.Classes,
  Datasnap.DSServer, Datasnap.DSCommonServer,
  Datasnap.DSClientMetadata, Datasnap.DSHTTPServiceProxyDispatcher,
  Datasnap.DSProxyJavaAndroid, Datasnap.DSProxyJavaBlackBerry,
  Datasnap.DSProxyObjectiveCiOS, Datasnap.DSProxyCsharpSilverlight,
  Datasnap.DSProxyFreePascal_iOS,
  IPPeerServer, IPPeerAPI, Datasnap.DSAuth, DbxCompressionFilter,
  Datasnap.DSHTTP;

type
  TSContM = class(TDataModule)
    DSServer: TDSServer;
    DSServerClass: TDSServerClass;
    DSHTTPService1: TDSHTTPService;

    procedure DSServerClassGetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DSServerConnect(DSConnectEventObject: TDSConnectEventObject);
  private
    FClientList: TStringList;
    function getClient(astr: string): Boolean;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

function DSServer: TDSServer;
function DsServicehttp: TDSHTTPService;

var
  FModule: TComponent;
  FDSServer: TDSServer;
  FDsHttpService: TDSHTTPService;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

uses
  ServerMethodsUnit1;

function DsServicehttp: TDSHTTPService;
begin
  result := FDsHttpService;
end;

function DSServer: TDSServer;
begin
  result := FDSServer;

end;

constructor TSContM.Create(AOwner: TComponent);
begin
  inherited;
  FDSServer := DSServer;
  FDsHttpService := DSHTTPService1;
end;

destructor TSContM.Destroy;
begin
  inherited;
  FDSServer := nil;
end;

procedure TSContM.DSServerClassGetClass(DSServerClass: TDSServerClass;
  var PersistentClass: TPersistentClass);
begin
  PersistentClass := ServerMethodsUnit1.TServerMethods1;
end;

procedure TSContM.DSServerConnect(DSConnectEventObject: TDSConnectEventObject);
begin
  if not Assigned(FClientList) then
    FClientList := TStringList.Create;
  if not getClient(DSConnectEventObject.ChannelInfo.Info) then
  begin
    FClientList.Add(DSConnectEventObject.ChannelInfo.Info);
    writeln('[' + datetimetostr(now()) + ']' + '[Connect client] ',
      DSConnectEventObject.ChannelInfo.Info);
    writeln('IP:' + DSConnectEventObject.ChannelInfo.ClientInfo.IpAddress);
    writeln('Protocol:' + DSConnectEventObject.ChannelInfo.ClientInfo.
      ClientPort);
    writeln('AppName:' + DSConnectEventObject.ChannelInfo.ClientInfo.AppName);
  end;
end;

function TSContM.getClient(astr: string): Boolean;
var
  li: Integer;
begin
  result := False;
  for li := 0 to FClientList.Count - 1 do
    if FClientList[li] = astr then
      Exit(true);
end;

initialization

FModule := TSContM.Create(nil);

finalization

FModule.Free;

end.
