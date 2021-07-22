program DsCli;

uses
  System.StartUpCopy,
  FMX.Forms,
  UCli in 'UCli.pas' {frmMain},
  ClientClassesUnit1 in 'ClientClassesUnit1.pas',
  ClientModuleUnit1 in 'ClientModuleUnit1.pas' {ClientModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TClientModule1, ClientModule1);
  Application.Run;
end.
