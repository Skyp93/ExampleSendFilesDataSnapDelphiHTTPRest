unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
  DataSnap.DSProviderDataModuleAdapter,
  DataSnap.DSServer, DataSnap.DSAuth, System.NetEncoding, serverconst1,
  System.Generics.Collections, System.ioutils, System.hash, System.types;

type
  TListStream = class
  public
    FStream: TMemoryStream;
    FNameFile: string;
    FCountSize: integer;
  end;

  TServerMethods1 = class(TDSServerModule)
  private
    FsrvCatalog: string;
    FStreamList: TList<TListStream>;
    function GetMyStream(aName: string): TListStream;
    { Private declarations }
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function updatefilem(ajsO: TJSONObject): boolean;
    property Srvcatalog: string read FsrvCatalog write FsrvCatalog;
    function SendPartStream(aName: string; Stream: TStream;
      inSize: integer): boolean;
    function StartSendFile(aName: string): boolean;
    function StopStream(aName: string): boolean;
    function CompareFile(aName, ahash: string): integer;
    function Connect: boolean;
    function GetFileList: TStringList;
    function LoadFile(aName: string): TStream;
  end;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

uses System.StrUtils;

function TServerMethods1.GetFileList: TStringList;
var
  sda: Tstringdynarray;
  li: integer;
begin
  result := nil;
  sda := TDirectory.GetFiles(ServerFileCatalog + PathDelim);
  for li := low(sda) to High(sda) do
  begin
    if not Assigned(result) then
      result := TStringList.Create;
    result.Add(ExtractFileName(sda[li]));
  end;

end;

function TServerMethods1.GetMyStream(aName: string): TListStream;
var
  li: integer;
begin
  if not Assigned(FStreamList) then
    FStreamList := TList<TListStream>.Create;
  for li := 0 to FStreamList.Count - 1 do
    if FStreamList[li].FNameFile = aName then
      Exit(FStreamList[li]);

end;

function TServerMethods1.LoadFile(aName: string): TStream;

begin
  result := nil;
  if TFile.Exists(ServerFileCatalog + PathDelim + aName) then
  begin
    result := TMemoryStream.Create;
    TMemoryStream(result).LoadFromFile(ServerFileCatalog + PathDelim + aName);
  end;

end;

// FS is a file stream
function TServerMethods1.SendPartStream(aName: string; Stream: TStream;
  inSize: integer): boolean;
var
  fs: TFileStream;
begin

  if not Assigned(fs) then
    Exit;
  if TFile.Exists(ServerFileCatalog + PathDelim + aName) then
  begin
    fs := TFileStream.Create(ServerFileCatalog + PathDelim + aName,
      fmOpenWrite);
  end
  else
    fs := TFileStream.Create(ServerFileCatalog + PathDelim + aName, fmCreate);
  fs.Seek(0, soFromEnd);
  fs.CopyFrom(Stream, inSize);
  fs.Destroy;
  result := true;
end;

function TServerMethods1.CompareFile(aName, ahash: string): integer;
var
  fs: TFileStream;
  flName: string;
begin
  if aName.IsEmpty or ahash.IsEmpty then
    Exit(0);
  flName := ServerFileCatalog + PathDelim + aName;
  if TFile.Exists(flName) then
  begin
    if THashMD5.GetHashStringFromFile(flName) = ahash then
      Exit(-1)
    else
    begin
      fs := TFileStream.Create(flName, fmOpenRead);
      result := fs.Size div (1024 * 30);
      fs.Destroy;
      Exit;
    end;
  end
  else
    result := 0;

end;

function TServerMethods1.Connect: boolean;
begin
  result := true;
end;

function TServerMethods1.EchoString(Value: string): string;
begin
  result := Value;
end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  result := System.StrUtils.ReverseString(Value);
end;

function TServerMethods1.StartSendFile(aName: string): boolean;
var
  llistStream: TListStream;
begin
  if aName.IsEmpty then
    Exit;
  if not Assigned(FStreamList) then
    FStreamList := TList<TListStream>.Create;
  llistStream := TListStream.Create;
  llistStream.FNameFile := aName;
  if TFile.Exists(ServerFileCatalog + PathDelim + aName) then
    TFile.Delete(ServerFileCatalog + PathDelim + aName);
  llistStream.FStream := TMemoryStream.Create;
  FStreamList.Add(llistStream);
end;

function TServerMethods1.StopStream(aName: string): boolean;
var
  ls: TListStream;
begin
  Writeln('[' + datetimetostr(now()) + ']' + ' Файл: "' + aName + '" получен');
  Writeln(cArrow);
end;

function TServerMethods1.updatefilem(ajsO: TJSONObject): boolean;
var
  linstream: TStringStream;
  loutStream: TMemoryStream;
  lfName: string;
begin
  result := False;
  lfName := TNetEncoding.URL.decode(ajsO.GetValue('name').Value);
  linstream := TStringStream.Create(ajsO.GetValue('file').Value);
  linstream.position := 0;
  loutStream := TMemoryStream.Create;
  TNetEncoding.Base64.decode(linstream, loutStream);
  loutStream.position := 0;
  Randomize;
  if lfName.IsEmpty then
    lfName := Random(32).ToString + Random(48).ToString;
  Writeln('[' + datetimetostr(now()) + ']' + ' Файл: "' + lfName + '" получен');
  loutStream.SaveToFile(ServerFileCatalog + PathDelim + lfName);
  Writeln(cArrow);
  result := true;
end;

end.
