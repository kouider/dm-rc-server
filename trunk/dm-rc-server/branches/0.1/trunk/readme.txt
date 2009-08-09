� ������ ����� ��������� ������/������ ��������� ������� ��� Download Master-a
� ���� � ����������� ���������� ������� ������������ ��� �������������� �������
� ����������.

DMPluginIntf.pas - ���� ���������� �����������;
dmtest_plugin.dpr - ���� ������� ������� (�� Delphi);
dmtest_pluginImpl.pas - ���������� ��������� �������.

	�������� ���������� ��������� ������� Download Master (DMPluginIntf.pas)

	� ���������� ������������� 2 �������� ������� ��� ���������� 
�������������� � ���������� EventRaised � DoAction, � ���� ������� ��� ����������� ���� 
�������� ������ ������� PluginConfigure, ������� ��� ���� ���������� 
����������� ��������������. ���������� ��������� ������� ��������� ��� ���� 
�������� � ����� ���� ����� �� �������.

======function DoAction(action: WideString; parameters: WideString): WideString; stdcall;
//��������� �����-���� �������� � ��

 	action = 'AddingURL' - ���������� ���-� �� �������.
	parameters = '<url>http://www.westbyte.com/plugin</url> <sectionslimit>2</sectionslimit>';
		���������� ����� ����������:
		'url', 'referer', 'description', 'savepath', 'filename', 'user', 'password', 'sectionslimit', 'priority', 'cookies', 'post', 'hidden', 'start', 'mirror1', 'mirror2', 'mirror3', 'mirror4', 'mirror5'
   
	��������: DoAction('AddingURL', '<url>http://www.westbyte.com/plugin</url> <hidden>1</hidden>')
		- ��������� ������� http://www.westbyte.com/plugin ��� �������� ���� ���������� ������� (hidden=1)

     ��������� �������� ���������� (� �������: (action: WideString; parameters: WideString)):
        ('AddingURL', '<url>http://www.westbyte.com/plugin</url> <hidden>1</hidden>') - ���������� �� ������� ���������� ���-� ��� �������� ���� ���������� �������;
        ('GetDownloadInfoByID', IntToStr(ID)) - ���������� ���������� (� XML �������) � ������� � ��������� ID;
        ('GetMaxSectionsByID', IntToStr(ID)) - ���������� ������������ �-�� ������ ������� ����� ���� ������� �������� � ��������� ID;
        ('GetDownloadIDsList', '') - �������� ������ ID (����������� ���������) ���� ������� �� ������. � �������� ��������� ����� ���� ������� ��������� ������� ��� �������� ������ ������� ������� ��������� � ���� ��������� ('GetDownloadIDsList', IntToStr(State));
	                ��������: ('GetDownloadIDsList', '3') - ���������� ������ ID ��� ���������� � ������ ������ ������� (dsDownloading = 3).  
			��������� �������� ��������� ��������� - (dsPause = 0, dsPausing = 1, dsDownloaded = 2, dsDownloading = 3, dsError = 4, dsErroring = 5, dsQueue = 6);

	('GetTempDir', '') - �������� ���� � ����� ��� ��������� ��������� �����
	('GetPluginDir', '') - �������� ���� � ����� ��� ���������� �������
	('GetListDir', '') - �������� ���� � ����� ��� ��������� ����� �������
	('GetProgramDir', '') - �������� ���� � ����� ��� ���������� ���������
	('GetLanguage', '') - �������� ������� ������������ ����
	('GetProgramName', '') - �������� �������� ��������� �������
	('GetCategoriesList', '') - �������� � ������� stringlist-a ������ ���������
	('GetSpeedsList', '') - �������� � ������� stringlist-a ������ ���������
	('GetConnectionsList', '') - �������� � ������� stringlist-a ������ ���������� RAS
	('GetLogDir', '') - �������� ���� � ����� ��� ��������� ����� �����

        ('StartSheduled', '') - ���������� ��� ��������������� �������;
        ('StopSheduled', '') - ���������� ��� ��������������� �������;
        ('StartAll', '') - ���������� ��� ������������� �������;
        ('StopAll', '') - ���������� ��� �������;
        ('StartNode', IntToStr(NodeID)) - ���������� ��� ������������� �� ������������ ��������� (������������ ���������� ������ ���� � ������ ��������� ������� ��������� "���������� ������� �� ������������");
        ('StopNode', IntToStr(NodeID)) - ���������� ��� � ��������� ��������� (������������ ���������� ������ ���� � ������ ��������� ������� ��������� "���������� ������� �� ������������");
        ('StartDownloads', IntToStr(ID)) - ����������/(��������� � �������) �������(�) � ���������(�) ID (���� ������� ���������, �� ID ����������� ����� ������, ��������: ('StartDownloads', '21 456 20'));
        ('StopDownloads', IntToStr(ID)) - ���������� �������(�) � ���������(�) ID (���� ������� ���������, �� ID ����������� ����� ������, ��������: ('StopDownloads', '13 2527'));
        ('ChangeSpeed', IntToStr(SpeedMode)) - �������� ��������;
        ('RunApp', '<app>'+RunStr+'</app>'+'<param>'+RunParamStr+'</param>') - ��������� ���������� � ���������� �����������;
        ('ConnectRAS', '<connection>'+ConnectionName+'</connection><attempts>'+IntToStr(_Task.ConnectionAttempts)+'</attempts><period>'+IntToStr(_Task.ConnectionPeriod)+'</period>') - ���������� ���������� � ���������� �����������;
        ('DisconnectRAS', ConnectionName) - ��������� ��������� ����������, ���� ���������� �� �������, �� ����������� ��� �������� � ������ ������;
        ('ShutDown', '') - ��������� ��;
        ('HibernateMode', '') - ������� � ������ �����;
        ('StandByMode', '') - ������� � ������ �����;
        ('Exit', '') - ����� �� ���������
        ('ChangeMaxDownloads', IntToStr(MaxDownloads)) - �������� ������������ �-�� ������������� �������;
        ('AddStringToLog', '<id>'+IntToStr(ID)+'</id>'+'<type>'+IntToStr(Type)+'</type>'+'<logstring>Log String</logstring>') - �������� � ��� ������� � ��������� ID ������ Log String, ���� Type (0 - Out, 1 - In, 2 - Info (��-���������), 3 - Error);

������ ��� ��: slava@westbyte.com ��� ���������� ����������� ��� ��������.

========function EventRaised(eventType: WideString; eventData: WideString): WideString; stdcall;
//���������� �� ��-�� ��� ������������� ������ ���� �������

C������ � ������� (eventType: WideString; eventData: WideString):
	

1. ('plugin_start', '') - �������� ������;
2. ('plugin_stop', '') - ��������� ������;
3. ('dm_timer_60', '') - ��������� ������ 60 ������ 
3.2. ('dm_timer_10', '') - ��������� ������ 10 ������ 
3.3. ('dm_timer_5', '') - ��������� ������ 5 ������ 
	(��� ��������� ����-���� ������ ������);
4. ('dm_download_state', IntToStr(ID)+' '+IntToStr(integer(State))) - 
	��������� ��� ��������� ��������� ������� � ��������� ID.
	State = (dsPause, dsPausing, dsDownloaded, dsDownloading, dsError, dsErroring, dsQueue);
5. ('dm_download_added', IntToStr(ID)) - ��������� ����� ��������� ����� ������� � ��������� ID;
6. ('dm_downloadall', '') - ��������� ����� ��� ������� ���������;
7. ('dm_start', '') - ��������� ����� dm ���������;
8. ('dm_connect', '') - ��������� ����� dm ��������� �����-���� ����������;
9. ('dm_changelanguage', language) - ��������� � ��������� ����� � ��-�
������ ��� ��: slava@westbyte.com ��� ���������� ����������� ��� �������.

=============procedure PluginConfigure(params: WideString); stdcall;
����� �� ��-�� ���� ������������ �������

1. ('<language>VALUE</language>') - ��� VALUE �������� �������� ����� 
	�������������� � ���������.
	��������: ('<language>ukrainian</language>')

	��� ���������� ����������� ���� �������� ��� ������� ��� 2-� ������ 
	�������� � ����������� � �������� �����. ���� ��� ��������� �����.
	������ ����:
	  if (language = 'russian') or (language = 'ukrainian') or (language = 'belarusian') then
	    //������� �� �������
	  else
	    //������� �� ����������

=================================================================================
						(�)2006 �������� �����