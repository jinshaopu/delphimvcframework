unit MyController2U;

interface

uses
  System.Generics.Collections,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  MVCFramework.Serializer.Commons,
  MVCFramework.Middleware.Authentication.RoleBasedAuthHandler;

type
  [MVCNameCase(ncLowerCase)]
  TAddress = class
  private
    FStreet: string;
    FNumber: Integer;
    FCity: string;
  public
    property Street: string read FStreet write FStreet;
    property Number: Integer read FNumber write FNumber;
    property City: string read FCity write FCity;
  end;

  [MVCNameCase(ncLowerCase)]
  TPhone = class
  private
    FDescription: string;
    FNumber: string;
  public
    property Description: string read FDescription write FDescription;
    property Number: string read FNumber write FNumber;
  end;


  [MVCNameCase(ncLowerCase)]
  TPerson = class
  private
    FName: string;
    FAge: Integer;
    FCountry: string;
    FCode: Integer;
    FAddress: TAddress;
    FPhones: TObjectList<TPhone>;
  public
    constructor Create;
    destructor Destroy; override;

    [MVCSwagJsonSchemaField(stInteger, 'code', 'person id', True, False)]
    property Code: Integer read FCode write FCode;
    [MVCSwagJsonSchemaField('name', 'person name', True, False)]
    property Name: string read FName write FName;
    [MVCSwagJsonSchemaField('age', 'person age', True, False)]
    property Age: Integer read FAge write FAge;
    [MVCSwagJsonSchemaField('country', 'Nationality of the person', True, False)]
    property Country: string read FCountry write FCountry;
    [MVCSwagJsonSchemaField(stObject, 'address', 'Address')]
    property Address: TAddress read FAddress write FAddress;
    [MVCSwagJsonSchemaField(stArray, 'phones', 'Contact phones of the person', False, True)]
    property Phones: TObjectList<TPhone> read FPhones write FPhones;
  end;

  [MVCPath('/person')]
  [MVCSwagAuthentication(atBasic)]
  TMyController2 = class(TMVCController)
  public
    [MVCPath('')]
    [MVCHTTPMethod([httpGET])]
    [MVCSwagSummary('Person', 'List all persons')]
    [MVCSwagParam(plQuery, 'per_page', 'Items per page', ptInteger)]
    [MVCSwagResponses(200, 'Success', TPerson, True)]
    [MVCSwagResponses(500, 'Internal Server Error')]
    procedure GetAllPerson;

    [MVCPath('/($Id)')]
    [MVCHTTPMethod([httpGET])]
    [MVCSwagSummary('Person', 'List Persons by Id', '66e83aa7-d170-44a7-a502-8f25ddd2a18a')]
    [MVCSwagParam(plPath, 'Id', 'Person id', ptInteger)]
    [MVCSwagResponses(200, 'Success', TPerson)]
    [MVCSwagResponses(500, 'Internal Server Error')]
    procedure GetPerson(const Id: Integer);

    [MVCPath('')]
    [MVCHTTPMethod([httpPOST])]
    [MVCSwagSummary('Person', 'Insert Person')]
    [MVCSwagParam(plBody, 'entity', 'Person object', TPerson)]
    [MVCSwagResponses(201, 'Created')]
    [MVCSwagResponses(401, 'Requires Authentication')]
    [MVCSwagResponses(500, 'Internal Server Error')]
    [MVCConsumes(TMVCMediaType.APPLICATION_JSON)]
    procedure InsertPerson;
  end;

implementation

uses
  MVCFramework.Controllers.Register;

{ TMyController2 }

procedure TMyController2.GetAllPerson;
var
  LPerson: TPerson;
  LPersons: TObjectList<TPerson>;
begin
  LPersons := TObjectList<TPerson>.Create;
  LPerson := TPerson.Create;
  LPerson.Code := 1;
  LPerson.Name := 'Jo�o Ant�nio Duarte';
  LPerson.Age := 26;
  LPerson.Country := 'Brasil';
  LPersons.Add(LPerson);

  Render<TPerson>(LPersons);
end;

procedure TMyController2.GetPerson(const Id: Integer);
var
  LPerson: TPerson;
begin
  LPerson := TPerson.Create;
  LPerson.Code := Id;
  LPerson.Name := 'Jo�o Ant�nio Duarte';
  LPerson.Age := 26;
  LPerson.Country := 'Brasil';
  Render(LPerson);
end;

procedure TMyController2.InsertPerson;
var
  LPerson: TPerson;
begin
  LPerson := Context.Request.BodyAs<TPerson>;
  Render(LPerson);
  ResponseStatus(201, 'Created');
end;

{ TPerson }

constructor TPerson.Create;
begin
  inherited;
  FAddress := TAddress.Create;
  FPhones := TObjectList<TPhone>.Create;
end;

destructor TPerson.Destroy;
begin
  FAddress.Free;
  FPhones.Free;
  inherited;
end;

initialization

TControllersRegister.Instance.RegisterController(TMyController2, 'MyServerName');

end.
