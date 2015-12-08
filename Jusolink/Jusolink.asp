<!--#include file="Linkhub/Linkhub.asp"--> 
<%
Application("LINKHUB_TOKEN_SCOPE_JUSOLINK") = Array("200")
Const ServiceID= "JUSOLINK"
Const ServiceURL = "https://juso.linkhub.co.kr"
Const APIVersion = "1.0"
Const adTypeBinary = 1
Const adTypeText = 2

Class Jusolink

Private m_TokenDic
Private m_Linkhub

Public Sub Class_Initialize
	On Error Resume next
	If  Not(JUSOLINK_TOKEN_CACHE Is Nothing) Then
		Set m_TokenDic = JUSOLINK_TOKEN_CACHE
	Else
		Set m_TokenDic = server.CreateObject("Scripting.Dictionary")
	End If
	On Error GoTo 0

	If isEmpty(m_TokenDic) Then
		Set m_TokenDic = server.CreateObject("Scripting.Dictionary")
	End If

	Set m_Linkhub = New Linkhub
End Sub

Private Property Get m_scope
	m_scope = Application("LINKHUB_TOKEN_SCOPE_JUSOLINK")
End Property

Public Sub Initialize(linkID, SecretKey )
    m_Linkhub.LinkID = linkID
    m_Linkhub.SecretKey = SecretKey
End Sub

Public Function getSession_token()
    refresh = False
    Set m_Token = Nothing
	
	If m_TokenDic.Exists("token") Then 
		Set m_Token = m_TokenDic.Item("token")
	End If
	
    If m_Token Is Nothing Then
        refresh = True
    Else
		'CheckScope
		For Each scope In m_scope
			If InStr(m_Token.strScope,scope) = 0 Then
				refresh = True
				Exit for
			End if
		Next
		If refresh = False then
			Dim utcnow
			utcnow = m_Linkhub.UTCTime
			refresh = CDate(Replace(left(m_Token.expiration,19),"T" , " " )) < utcnow
		End if
    End If
    
    If refresh Then
		If m_TokenDic.Exists("token") Then m_TokenDic.remove "token"
        Set m_Token = m_Linkhub.getToken(ServiceID, null, m_scope)
		m_Token.set "strScope", Join(m_scope,"|")
		m_TokenDic.Add "token", m_Token
	End If
    
    getSession_token = m_Token.session_token

End Function

'회원잔액조회
Public Function GetBalance()
    GetBalance = m_Linkhub.GetPartnerBalance(getSession_token(), ServiceID)
End Function

'검색단가조회
Public Function GetUnitCost()
	Set result = httpGET("/Search/UnitCost", getSession_token(), null)
	GetUnitCost = result.unitCost
End Function 

'주소검색
Public Function Search(Index, PageNum, PerPage, noDiff, noSuggest)
	Dim url

	If PerPage <> 0 Then
		If PerPage < 0 Then PerPage = 20
		If PerPage > 100 Then PerPage = 100
	End If

	url = "/Search?Searches=" + Index

	If PageNum <> 0 Then url = url + "&PageNum=" + CStr(PageNum)
	If PerPage <> 0 Then url = url + "&PerPage=" + CStr(PerPage)
	If noDiff Then url = url + "&noDifferential=true"
	If noSuggest Then url = url + "&noSuggest=true"

	Set result = New SearchResult

	Set tmp = httpGET(url, getSession_token(), null)

	result.fromJsonInfo tmp

	Set Search = result
End Function 

'Private Functions
Public Function httpGET(url, BearerToken, UserID)
    
    Set winhttp1 = CreateObject("WinHttp.WinHttpRequest.5.1")
    Call winhttp1.Open("GET", ServiceURL + url)
    
    Call winhttp1.setRequestHeader("Authorization", "Bearer " + BearerToken)
    Call winhttp1.setRequestHeader("x-api-version", APIVersion)
    
    winhttp1.Send
    winhttp1.WaitForResponse
    result = winhttp1.responseText
       
    If winhttp1.Status <> 200 Then
		Set winhttp1 = Nothing
        Set parsedDic = m_Linkhub.parse(result)
        Err.Raise parsedDic.code, "JUSOLINK", parsedDic.message
    End If
    
    Set winhttp1 = Nothing
    
    Set httpGET = m_Linkhub.parse(result)

End Function

Private Function StringToBytes(Str)
  Dim Stream : Set Stream = Server.CreateObject("ADODB.Stream")
  Stream.Type = adTypeText
  Stream.Charset = "UTF-8"
  Stream.Open
  Stream.WriteText Str
  Stream.Flush
  Stream.Position = 0
  Stream.Type = adTypeBinary
  buffer= Stream.Read
  Stream.Close
  'Remove BOM.
  Set Stream = Server.CreateObject("ADODB.Stream")
  Stream.Type = adTypeBinary
  Stream.Open
  Stream.write buffer
  Stream.Flush
  Stream.Position = 3
  StringToBytes= Stream.Read
  Stream.Close
  Set Stream = Nothing
 
End Function

Private Function IIf(condition , trueState,falseState)
	If condition Then 
		IIf = trueState
	Else
		IIf = falseState
	End if
End Function
public Function toString(object)
	toString = m_Linkhub.toString(object)
End Function

Public Function parse(jsonString)
	Set parse = m_Linkhub.parse(jsonString)
End Function
End Class


Class JusoInfo
	Public roadAddr1
	Public roadAddr2
	Public jibunAddr
	Public zipcode
	Public sectionNum
	Public detailBuildingName()
	Public relatedJibun()
	Public dongCode
	Public streetCode

	Public Sub Class_Initialize
		ReDim detailBuildingName(-1)
		ReDim relatedJibun(-1)
	End Sub
	
	Public Sub fromJsonInfo(jsonInfo)
			On Error Resume Next
			roadAddr1 = jsonInfo.roadAddr1
			roadADdr2 = jsonInfo.roadAddr2
			jibunAddr = jsonInfo.jibunAddr
			zipcode = jsonInfo.zipcode
			sectionNum = jsonInfo.sectionNum
			dongCode = jsonInfo.dongCode
			streetCode = jsonInfo.streetCode

			If Not IsEmpty(jsonInfo.relatedJibun) Then
				ReDim relatedJibun(jsonInfo.relatedJibun.length)
				For i = 0 To jsonInfo.relatedJibun.length-1
					relatedJibun(i) = jsonInfo.relatedJibun.Get(i)
				Next
			End If

			If Not (jsonInfo.detailBuildingName) Then
				ReDim detailBuildingName(jsonInfo.detailBuildingName.length)
				For i = 0 To jsonInfo.detailBuildingName.length-1
					detailBuildingName(i) = jsonInfo.detailBuildingName.Get(i)
				Next
			End If
			On Error GoTo 0
	End Sub
End Class

Class SearchResult
	Public searches
	Public deletedWord()
	Public suggest
	Public numFound
	Public listSize
	Public totalPage
	Public page
	Public chargeYN
	Public jusoList()
	Public sidoCount

	Public Sub Class_Initialize
		ReDim jusoList(-1)
		ReDim deletedWord(-1)
	End Sub

	Public Sub fromJsonInfo(jsonInfo)
		On Error Resume Next
			searches = jsonInfo.searches	
			numFound = jsonInfo.numFound
			listSize = jsonInfo.listSize
			totalPage = jsonInfo.totalPage
			page = jsonInfo.page		

			If Not isEmpty(jsonInfo.chargYN) Then
				chargeYN = jsonInfo.chargeYN
			End If 

			If Not isEmpty(jsonInfo.suggest) Then
				suggest = jsonInfo.suggest
			End if

			If IsEmpty(jsonInfo.sidoCount) = False Then
				Set tmpSido = New Sido
				tmpSido.fromJsonInfo jsonInfo.sidoCount
				Set sidoCount = tmpSido
			End If

			If IsEmpty(jsonInfo.deletedWord) = False Then
				ReDim deletedWord(jsonInfo.deletedWord.length)
				For i = 0 To jsonInfo.deletedWord.length-1
					deletedWord(i) = jsonInfo.deletedWord.Get(i)
				Next
			End If
			
			ReDim jusoList(jsonInfo.juso.length)
			For i = 0 To jsonInfo.juso.length-1
				Set tmpJuso = New JusoInfo
				tmpJuso.fromJsonInfo jsonInfo.juso.Get(i)
				Set jusoList(i) = tmpJuso
			Next
		On Error GoTo 0
	End Sub
	
End Class

Class Sido
	Public GYEONGGI
	Public GYEONGSANGBUK
	Public GYEONGSANGNAM
	Public SEOUL
	Public JEOLLANAM
	Public CHUNGCHEONGNAM
	Public JEOLLABUK
	Public BUSAN
	Public GANGWON
	Public CHUNGCHEONGBUK
	Public DAEGU
	Public INCHEON
	Public GWANGJU
	Public JEJU
	Public DAEJEON
	Public ULSAN
	Public SEJONG

	Public Sub fromJsonInfo(jsonInfo)
		On Error Resume Next
			If IsEmpty(jsonInfo.GYEONGGI) = False Then GYEONGGI = jsonInfo.GYEONGGI
			If IsEmpty(jsonInfo.GYEONGSANGBUK) = False Then GYEONGSANGBUK = jsonInfo.GYEONGSANGBUK
			If IsEmpty(jsonInfo.GYEONGSANGNAM) = False Then GYEONGSANGNAM = jsonInfo.GYEONGSANGNAM
			If IsEmpty(jsonInfo.SEOUL) = False Then SEOUL = jsonInfo.SEOUL
			If IsEmpty(jsonInfo.JEOLLANAM) = False Then JEOLLANAM = jsonInfo.JEOLLANAM
			If IsEmpty(jsonInfo.CHUNGCHEONGNAM) = False Then CHUNGCHEONGNAM = jsonInfo.CHUNGCHEONGNAM
			If IsEmpty(jsonInfo.JEOLLABUK) = False Then JEOLLABUK = jsonInfo.JEOLLABUK
			If IsEmpty(jsonInfo.BUSAN) = False Then BUSAN = jsonInfo.BUSAN
			If IsEmpty(jsonInfo.GANGWON) = False Then GANGWON = jsonInfo.GANGWON
			If IsEmpty(jsonInfo.CHUNGCHEONGBUK) = False Then CHUNGCHEONGBUK = jsonInfo.CHUNGCHEONGBUK
			If IsEmpty(jsonInfo.DAEGU) = False Then DAEGU = jsonInfo.DAEGU
			If IsEmpty(jsonInfo.INCHEON) = False Then INCHEON = jsonInfo.INCHEON
			If IsEmpty(jsonInfo.GWANGJU) = False Then GWANGJU = jsonInfo.GWANGJU
			If IsEmpty(jsonInfo.JEJU) = False Then JEJU = jsonInfo.JEJU
			If IsEmpty(jsonInfo.DAEJEON) = False Then DAEJEON = jsonInfo.DAEJEON
			If IsEmpty(jsonInfo.ULSAN) = False Then ULSAN = jsonInfo.ULSAN
			If IsEmpty(jsonInfo.SEJONG) = False Then SEJONG = jsonInfo.SEJONG
		On Error GoTo 0
	End Sub
End Class

%>