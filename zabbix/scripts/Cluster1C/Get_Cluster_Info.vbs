Option Explicit

' ������� ��������� ������� � �������� 1�
Dim ServerName                ' ��� �������� 1�:�����������
Dim ClusterAdmin            ' ��� ������ ��������, ���� ����
Dim ClusterAdminPassword    ' ������ ������ ��������, ���� ����.

ServerName = "CLUSTER01"
ClusterAdmin = ""
ClusterAdminPassword = ""

' ������� ���� � ������� ������
Const strBasesListFileName                 = "C:\zabbix\scripts\Cluster1C\Bases_List.txt"
Const strInformationBasesCountFileName     = "C:\zabbix\scripts\Cluster1C\Information_Bases_Count.txt"
Const strUsersCountFileName             = "C:\zabbix\scripts\Cluster1C\Users_Count.txt"
Const strWorkingProcessesCountFileName    = "C:\zabbix\scripts\Cluster1C\Working_Processes_Count.txt"

' ������ ����������
Dim intInformationBasesCount            ' ���������� �������������� ��� � �������� 1�
Dim intUsersCount                        ' ����� ���������� ������� �� �������� 1�
Dim intWorkingProcessesCount            ' ���������� ������� ��������� � �������� 1�
Dim strBasesList                        ' ������ ���

Dim Connector
Dim AgentConnection
Dim Cluster
Dim Clusters
Dim WorkingProcesses
Dim IBB
Dim IBBl
Dim Sessions
Dim SessionsActiv
Dim MyBaseName
Dim MyBaseDescr
Dim MyBaseConnectionHost
Dim SessionsActivConnection
Dim UC
Dim BC
Dim BN

'********************************************************************
'*
'*  ���������   : WriteToFile
'*  ��������    : ����������/�������������� � ���� ��������� ����������
'*  ����        : strFileName - ��� �����, � ������� ����� ������ ����������
'*                strString   - ������������ ����������
'*
'********************************************************************
Sub WriteToFile (ByVal strFileName, ByVal strString)

' ������ ��������� ��� ������ � ���������� �������
Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8

Dim fso, f

    Err.Clear
    On Error Resume Next

    Set fso = CreateObject("Scripting.FileSystemObject")
        Set f = fso.OpenTextFile(strFileName, ForWriting, True)
            f.WriteLine strString
            f.Close
        Set f = Nothing
    Set fso = Nothing

End Sub

' ������ ���������

intUsersCount = 0

strBasesList =  "{"
strBasesList = strBasesList & vbCrLf & "    ""data"": ["

Set Connector = CreateObject("V83.COMConnector")
    Set AgentConnection = Connector.ConnectAgent(ServerName)
        Clusters = AgentConnection.GetClusters()

        For Each Cluster In Clusters
            AgentConnection.Authenticate Cluster, ClusterAdmin,ClusterAdminPassword
            WorkingProcesses = AgentConnection.GetWorkingProcesses(Cluster)
            intWorkingProcessesCount =  UBound(WorkingProcesses) + 1                ' ���������� ���������� ������� ���������
            IBB = AgentConnection.GetInfoBases(Cluster)
                intInformationBasesCount = UBound(IBB) + 1                            ' ���������� ���������� ���
                BC = UBound(IBB)
                BN = 0
                For Each IBBl In IBB
                    UC = 0
                    MyBaseDescr = IBBl.Descr
                    Sessions = AgentConnection.GetInfoBaseSessions (Cluster,IBBl)
                    For Each SessionsActiv In Sessions
                        If not ((SessionsActiv.AppID = "COMConsole") or (SessionsActiv.AppID = "BackgroundJob")) Then
                            UC = UC + 1
                            intUsersCount = intUsersCount + 1                        ' ������� ������������� � �����
                        End if
                    Next
                    MyBaseDescr = Replace(IBBl.Descr,""""," ")
                    If BN = BC Then
                            strBasesList = strBasesList & vbCrLf & "        {""{#IBDNAME}"": """ & IBBl.Name & """, ""{#IBDDESCR}"": """ & MyBaseDescr & """, ""{#IBDUSERCOUNT}"": """ & UC & """}"
                    Else
                            strBasesList = strBasesList & vbCrLf & "        {""{#IBDNAME}"": """ & IBBl.Name & """, ""{#IBDDESCR}"": """ & MyBaseDescr & """, ""{#IBDUSERCOUNT}"": """ & UC & """},"
                    End If
                    BN = BN +1
                Next
        Next
    Set AgentConnection = nothing
Set Connector = Nothing

strBasesList = strBasesList & vbCrLf & "    ]"
strBasesList = strBasesList & vbCrLf & "}"

' ������� �� ����� ���������� ������
' WScript.Echo "intUsersCount =" & intUsersCount
' WScript.Echo "intInformationBasesCount =" & intInformationBasesCount
' WScript.Echo "intWorkingProcessesCount =" & intWorkingProcessesCount
WScript.Echo strBasesList

' ���������� �� ������ ���������� ������
'WriteToFile strBasesListFileName, strBasesList
WriteToFile strInformationBasesCountFileName, intInformationBasesCount
WriteToFile strUsersCountFileName, intUsersCount
WriteToFile strWorkingProcessesCountFileName, intWorkingProcessesCount
