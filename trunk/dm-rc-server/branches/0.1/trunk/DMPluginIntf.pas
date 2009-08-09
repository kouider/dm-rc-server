unit DMPluginIntf;

//�������� ��. � readme.txt

interface

type
  { IDMInterface }
  IDMInterface = interface(IUnknown)
  ['{B412B405-0578-4B99-BB06-368CDA0B2F8C}']
    function DoAction(action: WideString; parameters: WideString): WideString; stdcall;//��������� �����-���� �������� � ��
  end;

  { IDMPlugIn }
  IDMPlugIn = interface(IUnknown)
  ['{959CD0D3-83FD-40F7-A75A-E5C6500B58DF}']
    function getID: WideString; stdcall;
    //-----info
    function GetName: WideString; stdcall;//�������� ���� � �������
    function GetVersion: WideString; stdcall;//�������� ���� � �������
    function GetDescription(language: WideString): WideString; stdcall;//�������� ���� � �������
    function GetEmail: WideString; stdcall;//�������� ���� � �������
    function GetHomepage: WideString; stdcall;//�������� ���� � �������
    function GetCopyright: WideString; stdcall;//�������� ���� � �������
    function GetMinAppVersion: WideString; stdcall;//�������� ����������� ������ ��-� � ������� ����� �������� ������

    //------
    procedure PluginInit(_IDmInterface: IDmInterface); stdcall;//������������� ������� � �������� ���������� ��� ������� � ��
    procedure PluginConfigure(params: WideString); stdcall;//����� ���� ������������ �������
    procedure BeforeUnload; stdcall;

    function EventRaised(eventType: WideString; eventData: WideString): WideString; stdcall;//���������� �� ��-�� ��� ������������� ������ ���� �������
    { ������������� ������� }
    property ID: WideString read getID;
  end;

implementation

end.
