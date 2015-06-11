<!--#include virtual="/Jusolink/Jusolink.asp"--> 
<%
	'연동상담시 발급받은 링크아이디 
	LinkID = "TESTER_JUSO"
	'연동상담시 발급받은 비밀키, 유출에 주의
	SecretKey ="FjaRgAfVUPvSDHTrdd/uw/dt/Cdo3GgSFKyE1+NQ+bc="
	set m_JusolinkService = new Jusolink
	m_JusolinkService.Initialize LinkID, SecretKey
%>