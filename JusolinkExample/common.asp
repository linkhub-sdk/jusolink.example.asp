<!--#include virtual="/Jusolink/Jusolink.asp"--> 
<%
	'�������� �߱޹��� ��ũ���̵� 
	LinkID = "TESTER_JUSO"
	'�������� �߱޹��� ���Ű, ���⿡ ����
	SecretKey ="FjaRgAfVUPvSDHTrdd/uw/dt/Cdo3GgSFKyE1+NQ+bc="
	set m_JusolinkService = new Jusolink
	m_JusolinkService.Initialize LinkID, SecretKey
%>