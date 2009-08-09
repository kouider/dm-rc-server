unit dmtest_pluginImpl;

interface

uses DMPluginIntf, Classes, Dialogs, OverbyteIcsWSocket, OverbyteIcsWSocketS,
  OverbyteIcsWndControl, StrUtils, splitfns, IniFiles;
const
  //������� ����� ���������� � ����� �������
  myPluginID = '{F78D5E99-7CC4-4E5C-8839-50BEEF99884D}';//����������� ������� ���� ���������� ����� ������� (����������� Ctrl+Shift+G ��� ���������)
  myPluginName = 'Download Master Remote Control Server';//�������� ������� �� ���������� �����
  myPluginVersion = '0.1';
  myPluginEmail = 'andrew_my@inbox.ru';
  myPluginHomePage = 'none';
  myPluginCopyRight = chr(169)+'2008 Andrew++';
  myMinNeedAppVersion = '5.0.2';//������ ����������� ��� �����
  //�������� �������. ������ ���� ������������ �� ������� � ���������� ������. ����� ��������� ��������� ���������� �� ����������� ��������.
  myPluginDescription = 'Download Master Remote Control Server';
  myPluginDescriptionRussian = '������ Download Master Remote Control';

  IniFileName: string = 'DM_RC_Svr.ini';

type
  TDMTestPlugIn = class(TInterfacedObject, IDMPlugIn)
    private
      myIDmInterface: IDmInterface;
      WSocketServer: TWSocketServer;
      Ini: TMemIniFile;
    protected

    public
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
      procedure PluginConfigure(params: WideString); stdcall;//����� ���� ������������ ������� (���� ������������ ����������� ���� ��������������)
      procedure BeforeUnload; stdcall;//���������� ����� ��������� �������

      function EventRaised(eventType: WideString; eventData: WideString): WideString; stdcall;//���������� �� ��-�� ��� ������������� ������ ���� �������
      { ������������� ������� }
      property ID: WideString read getID;

      //------
      procedure ClientDataAvailable(Sender: TObject; Error: Word);//�������� ���������� �� �������
      procedure ClientConnect(Sender: TObject; Client: TWSocketClient; Error: Word);//����������� ������
      procedure TranslateMsg(const Msg: string);//�������� ��������� ���� ������������ ��������
      procedure DoAction(const Cmd, Params: string);//��������� �������
      function GetInfo(DownloadId: string): string;
      function GetShortInfo(DownloadId: string): string;
    published
  end;
  
  //TState = (dsPause, dsPausing, dsDownloaded, dsDownloading, dsError, dsErroring, dsQueue);

implementation

uses SysUtils;
//------------------------------------------------------------------------------
function TDMTestPlugIn.GetName: WideString;//�������� ���� � �������
begin
  Result := myPluginName;
end;
//------------------------------------------------------------------------------
function TDMTestPlugIn.GetVersion: WideString;//�������� ���� � �������
begin
  Result := myPluginVersion;
end;
//------------------------------------------------------------------------------
function TDMTestPlugIn.GetDescription(language: WideString): WideString;//�������� ���� � �������
begin
  if (language = 'russian') or (language = 'ukrainian') or (language = 'belarusian') then
    Result := myPluginDescriptionRussian
  else
    Result := myPluginDescription;
end;
//------------------------------------------------------------------------------
function TDMTestPlugIn.getID: WideString; stdcall;
begin
  Result:= myPluginID;
end;
//------------------------------------------------------------------------------
procedure TDMTestPlugIn.TranslateMsg(const Msg: string);
var
  i: integer;
begin
  for i := 0 to WSocketServer.ClientCount - 1 do
    (WSocketServer.Client[i] As TWSocketClient).SendStr(Msg + #13#10);
end;
//------------------------------------------------------------------------------
procedure TDMTestPlugIn.ClientDataAvailable(Sender: TObject; Error: Word);
var
  RcvdLine: string;
  IndStart: integer;
  Cmd, Params: string;
begin
  with Sender as TWSocketClient do
  begin
    { We use line mode. We will receive complete lines }
    RcvdLine := ReceiveStr;
    { Remove trailing CR/LF }
    while (Length(RcvdLine) > 0) and
          (RcvdLine[Length(RcvdLine)] in [#13, #10]) do
      RcvdLine := Copy(RcvdLine, 1, Length(RcvdLine) - 1);

    IndStart := AnsiPos(' ', RcvdLine);
    if IndStart = 0 then IndStart := length(RcvdLine) + 1;

    Cmd    := copy(RcvdLine, 0, IndStart-1);
    Params := copy(RcvdLine, IndStart+1, length(RcvdLine));
    DoAction(Cmd, Params);

    //RcvdLine := myIDmInterface.DoAction(Cmd, Params);
    //if Length(RcvdLine) > 0 then TranslateMsg(RcvdLine);
  end;
end;
//------------------------------------------------------------------------------
procedure TDMTestPlugIn.DoAction(const Cmd, Params: string);
var
  Answer: string;
  Lst: TStringList;
  i: integer;
begin
  if CompareText(Cmd, 'help') = 0 then
    TranslateMsg('����������� ��������: starturl <url>, addurl <url>, ls [State], start <ID>, stop <ID>, info <ID>; ��������� �������� �����������')
  else if CompareText(Cmd, 'starturl') = 0 then
    Answer := myIDmInterface.DoAction('AddingURL', '<url>' + Params +
      '</url> <hidden>1</hidden>')
  else if CompareText(Cmd, 'addurl') = 0 then
    Answer := myIDmInterface.DoAction('AddingURL', '<url>' + Params +
      '</url> <hidden>1</hidden> <start>0</start>')
  else if CompareText(Cmd, 'start') = 0 then
    Answer := myIDmInterface.DoAction('StartDownloads', Params)
  else if CompareText(Cmd, 'stop') = 0 then
    Answer := myIDmInterface.DoAction('StopDownloads', Params)
  else if CompareText(Cmd, 'ls') = 0 then
  begin
    Answer := myIDmInterface.DoAction('GetDownloadIDsList', Params);
    Lst    := TStringList.Create;
    Split(Answer, [' '], Lst);
    for i := 0 to Lst.Count - 1 do Lst[i] := GetShortInfo(Lst[i]);
    Answer := Lst.Text;
    Lst.Free;
  end else if CompareText(Cmd, 'info') = 0 then
    Answer := GetInfo(Params)
  else
    Answer := myIDmInterface.DoAction(Cmd, Params);

  if Length(Answer) > 0 then TranslateMsg(Answer);
end;
//------------------------------------------------------------------------------
function TDMTestPlugIn.GetInfo(DownloadId: string): string;
begin
  Result := myIDmInterface.DoAction('GetDownloadInfoByID', DownloadId);
  Result := Format('ID: %sURL: %sSave to: %sState: %s, Downloaded: %s/%s (Speed: %s)',
    [DownloadId + #13,
     GetStringBetween(Result, '<url>', '</url>') + #13,
     GetStringBetween(Result, '<saveto>', '</saveto>') + #13,
     Ini.ReadString('State', GetStringBetween(Result, '<state>', '</state>'), ''),
     GetStringBetween(Result, '<downloadedsize>', '</downloadedsize>'),
     GetStringBetween(Result, '<size>', '</size>'),
     GetStringBetween(Result, '<speed>', '</speed>')]) + #13;
end;
//------------------------------------------------------------------------------
function TDMTestPlugIn.GetShortInfo(DownloadId: string): string;
begin
  Result := myIDmInterface.DoAction('GetDownloadInfoByID', DownloadId);
  Result := Format('ID: %s, URL: %s, State: %s',
    [DownloadId,
     GetStringBetween(Result, '<url>', '</url>'),
     Ini.ReadString('State', GetStringBetween(Result, '<state>', '</state>'), '')]) + #13;
end;
//------------------------------------------------------------------------------
procedure TDMTestPlugIn.ClientConnect(Sender: TObject;
  Client: TWSocketClient; Error: Word);
begin
  Client.LineMode            := TRUE;
  Client.LineEdit            := TRUE;
  Client.OnDataAvailable     := ClientDataAvailable;
  //Client.OnLineLimitExceeded := ClientLineLimitExceeded;
  //Client.OnBgException       := ClientBgException;
end;
//------------------------------------------------------------------------------
procedure TDMTestPlugIn.PluginInit(_IDmInterface: IDmInterface);//������������� ������� � �������� ���������� ��� ������� � ��
begin
  myIDmInterface := _IDmInterface;

  //������ ��� ����
  Ini := TMemIniFile.Create(myIDmInterface.DoAction('GetPluginDir', '') + '/' + IniFileName);

  //������� ������ � ��������� ���
  WSocketServer := TWSocketServer.Create(nil);
  WSocketServer.OnClientConnect := ClientConnect;
  WSocketServer.Banner          := 'Welcome to Download Master Remote Control Server';
  WSocketServer.Proto           := 'tcp';         { Use TCP protocol  }
  WSocketServer.Port            := Ini.ReadString('Connect', 'Port', '10000');
  WSocketServer.Addr            := Ini.ReadString('Connect', 'Addr', '127.0.0.1');
  WSocketServer.ClientClass     := TWSocketClient;{ Use our component }
  WSocketServer.Listen;                           { Start litening    }
end;
//------------------------------------------------------------------------------
procedure TDMTestPlugIn.BeforeUnload;
begin
  myIDmInterface := nil;

  //������� ��� ����
  FreeAndNil(Ini);
  //������� ������
  FreeAndNil(WSocketServer);
end;
//------------------------------------------------------------------------------
procedure TDMTestPlugIn.PluginConfigure(params: WideString);//����� ���� ������������ �������
begin
//
end;
//------------------------------------------------------------------------------
function TDMTestPlugIn.EventRaised(eventType: WideString; eventData: WideString): WideString;//���������� �� ��-�� ��� ������������� ������ ���� �������
var
  IndStart: integer;
  ID, State: string;
begin
  IndStart := AnsiPos(' ', eventData);
  ID       := copy(eventData, 0, IndStart-1);
  State    := copy(eventData, IndStart+1, length(eventData));

  if AnsiStartsText('dm_download', eventType) then
    TranslateMsg(Ini.ReadString('Events', eventType, eventType) + ' ' + ID + ' ' +
      Ini.ReadString('State', State, State));
end;
//------------------------------------------------------------------------------
function TDMTestPlugIn.GetEmail: WideString;//�������� ���� � �������
begin
  Result:= myPluginEmail;
end;
//------------------------------------------------------------------------------
function TDMTestPlugIn.GetHomepage: WideString;//�������� ���� � �������
begin
  Result:= myPluginHomePage;
end;
//------------------------------------------------------------------------------
function TDMTestPlugIn.GetCopyright: WideString;//�������� ���� � �������
begin
  Result:= myPluginCopyright;
end;
//------------------------------------------------------------------------------
function TDMTestPlugIn.GetMinAppVersion: WideString;//�������� ����������� ������ ��-� � ������� ����� �������� ������
begin
  Result:= myMinNeedAppVersion;
end;






end.
