program renders;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  IdHTTPWebBrokerBridge,
  MVCFramework.Commons,
  Web.WebReq,
  Web.WebBroker,
  WebModuleU in 'WebModuleU.pas' {WebModule1: TWebModule} ,
  RenderSampleControllerU in 'RenderSampleControllerU.pas',
  BusinessObjectsU in '..\commons\BusinessObjectsU.pas',
  MyDataModuleU in 'MyDataModuleU.pas' {MyDataModule: TDataModule};

{$R *.res}

procedure RunServer(APort: Integer);
var
  LServer: TIdHTTPWebBrokerBridge;
begin
  Writeln(Format('Starting HTTP Server or port %d', [APort]));
  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.DefaultPort := APort;
    LServer.Active := True;
    Writeln('DMVCFRAMEWORK VERSION: ', DMVCFRAMEWORK_VERSION);
    Writeln('Press RETURN to stop the server');
    ReadLn;
    Writeln('Stopping...');
  finally
    LServer.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    RunServer(8080);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end

end.
