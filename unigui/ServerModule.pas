unit ServerModule;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IniFiles,
  uniGUIServer,
  uniGUITypes,
  uniGUIApplication;

type
  TUniServerModule = class(TUniGUIServerModule)
    procedure UniGUIServerModuleBeforeInit(Sender: TObject);
    procedure UniGUIServerModuleControlPanelLogin(ASession: TUniGUISession;
      const Auser, APassword: string; var LoginValid: Boolean;
      LoginAttempt: Integer);
  private
    { Private declarations }
    FUser: string;
    FPassword: string;

    procedure LoadConfigIni();
  protected
    procedure FirstInit; override;
  public
    { Public declarations }
    v1, v2: Integer;
  end;

function UniServerModule: TUniServerModule;

implementation

{$R *.dfm}

{
SessionTimeout
1s  - 1000
1m  - 60000
5m  - 300000
20m - 1200000
}

uses
  UniGUIVars, uniGUIDialogs, uniGUIClasses, UniFSCommon;

function UniServerModule: TUniServerModule;
begin
  Result := TUniServerModule(UniGUIServerInstance);
end;

procedure TUniServerModule.FirstInit;
begin
  InitServerModule(Self);
end;

procedure TUniServerModule.LoadConfigIni;
var
  IniFile: TIniFile;
  vArqIni: string;
begin
  try
    vArqIni := ExtractFilePath(StartPath) + '\config.ini';

    if not(FileExists(vArqIni)) then
      Exit;

    IniFile := TIniFile.Create(vArqIni);
    try
      FUser := IniFile.ReadString('SERVER', 'USER', '');
      FPassword := IniFile.ReadString('SERVER', 'PASSWORD', '');
    finally
      FreeAndNil(IniFile);
    end;
  except
    on e: Exception do
      raise Exception.Create('LoadConfigIni '+ e.Message);
  end;
end;

procedure TUniServerModule.UniGUIServerModuleBeforeInit(Sender: TObject);
begin
  {$IFDEF DEBUG}
  SuppressErrors := [];
  {$ELSE}
  SuppressErrors := [errObjectNotFound];
  {$ENDIF}

  LoadConfigIni;

  {$REGION 'Habilitando os MimeTypes (Arquivos permitidos)'}
  MimeTable.AddMimeType('ttf', 'application/font', False);
  MimeTable.AddMimeType('woff', 'application/x-font-woff', False);
  MimeTable.AddMimeType('woff2', 'application/font', False);
  MimeTable.AddMimeType('eot', 'application/font', False);
  MimeTable.AddMimeType('svg', 'application/font', False);
  {$ENDREGION}
  {$REGION 'Carregando Custom Meta'}
  with CustomMeta do
  begin
    Add('<meta name="Author" content="Marlon Nardi">');
    Add('<meta name="copyright" content="'+FormatDateTime('YYYY',Now)+' Falcon Sistemas">');
    Add('<meta name="keywords" content="json, delphi, pascal, convert, generate, json to delphi, json to pascal, json to delphi object, json to delphi class">');
    Add('<meta name="description" content="generate delphi classes from a json."/>');

    Add('<meta property="og:url" content="https://www.jsontodelphi.com">');
    Add('<meta property="og:title" content="generate delphi classes from a json.">');
    Add('<meta property="og:site_name" content="Json To Delphi Class">');
    Add('<meta property="og:description" content="generate delphi classes from a json.">');
    Add('<meta property="og:image" content="https://www.jsontodelphi.com/imagens/json.png">');
    Add('<meta property="og:image:type" content="image/png">');
  end;
  {$ENDREGION}
  {$REGION 'Carregando JS e CSS'}
  UniAddCSSLibrary(CDN+'falcon/css/style/financas.css?v=1', CDNENABLED, [upoFolderUni, upoPlatformBoth]);

  UniAddJSLibrary('https://www.googletagmanager.com/gtag/js?id=G-VSH6WJS3B3', True, [upoFolderUni, upoPlatformBoth]);
  UniAddJSLibrary(CDN+'falcon/js/jsontodelphi_google_ga4.js', CDNENABLED, [upoFolderUni, upoPlatformBoth]);
  {$ENDREGION}
end;

procedure TUniServerModule.UniGUIServerModuleControlPanelLogin(
  ASession: TUniGUISession; const Auser, APassword: string;
  var LoginValid: Boolean; LoginAttempt: Integer);
begin
  LoginValid := (Auser = FUser) and (APassword = FPassword);
end;

initialization
  RegisterServerModuleClass(TUniServerModule);

end.
