<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="../Example.css" media="screen" />
		<title>�ּ� API SDK ASP Example.</title>
	</head>
	<!--#include file="common.asp"--> 
	<%
		Dim IndexWord
		Dim PageNum
		Dim PerPage
		Dim noDiffer
		Dim noSuggest

		'�˻���
		IndexWord = request.QueryString("IndexWord")

		'��������ȣ
		PageNum = request.QueryString("PageNum")

		'������ ��ϰ���, �ִ� 100��
		PerPage = 20

		noDiffer = False	'����˻� ����, �⺻�� False
		noSuggest = False	'�������þ� ����, �⺻��  False

		If IndexWord <> "" Then
			On Error Resume Next

			Set result = m_JusolinkService.search(IndexWord, PageNum, PerPage, noDiffer, noSuggest)
			
			If Err.Number <> 0 then
				code = Err.Number
				message =  Err.Description
				Err.Clears
			End If
			On Error GoTo 0
		End if
	%>	
	<body class="body_width">	
		<div id="content_result">
				<p class="heading1">�ּҰ˻� Example</p>
				<br/>
				<fieldset class="fieldset5 left">
					<legend>�ּҰ˻�</legend>
							<form method = "GET" id="zipcode_form" action="zipcode_search.asp">
								<% 
									If IsEmpty(result) Then
								%>
									<input class= "txtIndexWord left" type="text" id="IndexWord" name="IndexWord" tabindex=1 onKeyPress="indexSearch()" placeholder="��) ������� 517, �Ƽ�Ÿ��, �Ｚ�� 159"/>
								<%
									Else 
								%>
									<input class= "txtIndexWord left" type="text" id="IndexWord" name="IndexWord" value="<%=result.searches%>" tabindex=1  onKeyPress="indexSearch()"placeholder="��) ������� 517, �Ƽ�Ÿ��, �Ｚ�� 159"/>
								<%
									End if
								%>

								<input type="hidden" type="text" id="PageNum" name="PageNum"/>
								<input type="hidden" type="text" id="PerPage" name="PerPage"/>
								<p class="find_btn find_btn01 hand" onclick="search();" tabindex=2> �˻� </P>
							</form>
							<%
								If Not IsEmpty(result) Then
							%>
								<div class="result_box">				
									<p class="example left">�˻���� : <%=result.numFound%> ��</p>
								<% 
									If Not IsEmpty(result.suggest) Then
								%>
									<p class="example left">�˻��� ���� : <span class="suggest hand" onclick='suggest_search("<%=result.suggest%>")'><%=result.suggest%> �˻���� ����</span></p>
								<%
									End if
								%>
								</div>
							<%
								End if
							%>
				</fieldset>
				<br />
			 </div>
	
			<div id="content_juso">
			<%
				If Not IsEmpty(result) Then 
					If uBound(result.jusoList) > 0 then
					For i=0 To uBound(result.jusoList) -1 
			%>

					<fieldset class="fieldset6 left">
						<p> <span class="zipcode" id="zipcode"><%=result.jusoList(i).zipcode%></span> <span>(<%= result.jusoList(i).sectionNum%>)</span></p>

						<p class="hand" onclick='detail("roadAddr", "<%=result.jusoList(i).zipcode%>", "<%=result.jusoList(i).sectionNum%>", "<%=result.jusoList(i).roadAddr1%>", "<%= result.jusoList(i).roadAddr2%>", "<%= result.jusoList(i).jibunAddr%>")'>
							<img class="imgAlign" src="../image/juso_icon_01.gif"/> <%= result.jusoList(i).roadAddr1 %>&nbsp;<%= result.jusoList(i).roadAddr2%>
						</p>
						<p class="hand" onclick='detail("jibunAddr", "<%=result.jusoList(i).zipcode%>", "<%=result.jusoList(i).sectionNum%>", "<%= result.jusoList(i).roadAddr1%>", "<%= result.jusoList(i).roadAddr2%>", "<%=result.jusoList(i).jibunAddr%>")'>
							<img class="imgAlign" src="../image/juso_icon_02.gif"/> <%=result.jusoList(i).jibunAddr%>
						</p>
						
						<%	
							If uBound(result.jusoList(i).relatedJibun) > 0  Then
								Dim relatedJibunStr
								For j=0 To uBound(result.jusoList(i).relatedJibun) -1
									relatedJibunStr = relatedJibun + result.jusoList(i).relatedJibun(j) + " "
								Next
						%>
								<p> <img class="imgAlign" src="../image/juso_icon_03.gif"/> <%=relatedJibunStr%></p>
						<%
							End if
						%>		
						
					</fieldset>
					<%
						Next
						
					%>		
					<div class="page_num">
						<img class="hand" onclick='prevPage();' alt="����" src="../image/juso_btn_prev.png">
							<span class="current" id="current_page"><%=result.page%></span>
							&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;
							<span class="end" id="end_page"><%=result.totalPage%></span>
						<img class="hand" onclick='nextPage();' alt="����" src="../image/juso_btn_next.png">
					</div>

					<%
						End If 
						
					End If 
				%>
				</div>

				<div id="content_detail">
					<p class="heading1">���ּ� �Է�</p>
					<br/>
					<fieldset class="fieldset6 left">
						<div class ="select_box">
							<ul>
								<li>�Ʒ��� �ּҸ� Ȯ���Ͻð� �����Ͻ� �� Ȯ�ι�ư�� ��������. </li>
								<li>��Ȯ�� ���� �߼��� ���� ǥ��ȭ ���θ��ּ� ����� �����մϴ�.</li>
							</ul>
						
						
							<div class="road_type">
								<input class="hand" id="road" name="Type" onfocus="roadRadioSelect()" type="radio" tabindex=1>
								<label class="hand" for="road">ǥ��ȭ ���θ��ּ�</label>
								<table>
									<colgroup>
										<col width = "74">
										<col>
									</colgroup>

									<tbody>
										<tr class="code">
											<th>�����ȣ</th>
											<td>
												<span class="zipcode" id="road_zipcode"></span>
												<span class="sectionNum" id="road_sectionNum"></span>
											</td>
										</tr>
										<tr class="addr">
											<th>�⺻�ּ�</th>
											<td>
												<span id="roadAddr1"></span>&nbsp;<span id="roadAddr2"></span>
											</td>
										</tr>

										<tr class="addr_detail">
										<th>���ּ�</th>
										<td>
											<input class="on" id="road_detail" onKeyPress="selectAddr()" onfocus="roadDetailSelect()" type="text" tabindex=2/>
										</td>
										</tr>
									</tbody>
								</table>
							</div>

							<div class="jibun_type">
								<input class="hand" id="jibun" name="Type" onfocus="jibunRadioSelect()" type="radio" tabindex=3>
								<label class="hand" for="jibun">ǥ��ȭ �����ּ�</label>
								<table>
									<colgroup>
										<col width = "74">
										<col>
									</colgroup>

									<tbody>
										<tr class="code">
											<th>�����ȣ</th>
											<td>
												<span class="zipcode" id="jibun_zipcode"></span>
												<span class="sectionNum" id="jibun_sectionNum"></span>
											</td>
										</tr>
										<tr class="addr">
											<th>�⺻�ּ�</th>
											<td>
												<span id="jibunAddr"></span>
											</td>
										</tr>

										<tr class="addr_detail">
										<th>���ּ�</th>
										<td>
											<input class="on" id="jibun_detail" onKeyPress="selectAddr()" onfocus="jibunDetailSelect()" type="text" tabindex=4/>
										</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="btn_list">
								<p class="btn_ok hand" onclick="inputAddr();" tabindex=5>Ȯ��</p>
								<a href="zipcode_search.asp"><p class="btn_reset hand" tabindex=6>�ٽð˻�</p></a>
							</div>
						</div>
					
					</fieldset>
				<br />
			</div>
	
		<script type="text/javascript">
			window.onload=function(){

				// �⺻�˻� ȭ��
				document.getElementById('content_juso').style.display="none";
				document.getElementById('content_detail').style.display="none";
				
				//�˻���� ����Ʈ
				if(document.getElementById('zipcode') != null){
					document.getElementById('content_juso').style.display='';
				}
				document.getElementById('IndexWord').focus();
			};

			function processForm(e) {
				if (e.preventDefault) e.preventDefault();
				return false;
			}

			//�˻��� �ؽ�Ʈ �̺�Ʈ
			function indexSearch(){
				if (event.keyCode==13){ 
					search();
					event.returnValue=false
				}
			}

			//���ּ� �ؽ�Ʈ �̺�Ʈ
			function selectAddr(){
				if (event.keyCode==13){ 
					inputAddr();
					event.returnValue=false
				}
			}
			
			// �ּҰ˻�
			function search(){
				var index = document.getElementById('IndexWord').value;
				document.getElementById('PageNum').value = 1;

				if(index.length != 0) {
					document.getElementById('zipcode_form').submit();
				}else {
					alert('�˻�� �Է��Ͽ� �ּ���');
					return false;
				}
			}

			// �������þ�� �˻�
			function suggest_search(indexWord){
				document.getElementById('IndexWord').value = indexWord;
				document.getElementById('PageNum').value = 1;
				document.getElementById('zipcode_form').submit();
			}

			// ����������
			function nextPage(){
				currentPage = document.getElementById('current_page').innerText*1;
				totalPage = document.getElementById('end_page').innerText*1;
				
				if (currentPage < totalPage)
				{

					document.getElementById('PageNum').value = currentPage*1 + 1;				
					document.getElementById('zipcode_form').submit();
				}
			}
			
			// ����������
			function prevPage(){
				currentPage = document.getElementById('current_page').innerText*1 ;

				if(currentPage  > 1){
					document.getElementById('PageNum').value = currentPage*1 -1;			
					document.getElementById('zipcode_form').submit();
				}
			}


			// ���ּ� �Է��� ȣ��
			function detail(type, zipcode, sectionNum, roadAddr1, roadAddr2, jibunAddr){
				document.getElementById('content_result').style.display="none";
				document.getElementById('content_juso').style.display="none";
				document.getElementById('content_detail').style.display='';
				
				if(type == "roadAddr"){
					document.getElementById('road').checked = true;
					document.getElementById('road_detail').focus();
				}else {
					document.getElementById('jibun').checked = true;
					document.getElementById('jibun_detail').focus();
				}

				document.getElementById('road_zipcode').innerHTML = zipcode;
				document.getElementById('road_zipcode').value = zipcode;
				document.getElementById('road_sectionNum').innerHTML = "("+sectionNum+")";
				document.getElementById('road_sectionNum').value = sectionNum;
				document.getElementById('roadAddr1').innerHTML = roadAddr1;
				document.getElementById('roadAddr1').value = roadAddr1;
				document.getElementById('roadAddr2').innerHTML = roadAddr2;
				document.getElementById('roadAddr2').value = roadAddr2;

				document.getElementById('jibun_zipcode').innerHTML = zipcode;
				document.getElementById('jibun_zipcode').value = zipcode;
				document.getElementById('jibun_sectionNum').innerHTML = "("+sectionNum+")";
				document.getElementById('jibun_sectionNum').value = sectionNum;
				document.getElementById('jibunAddr').value = jibunAddr;
				document.getElementById('jibunAddr').innerHTML = jibunAddr;
			}

			// �θ� �������� �����ȣ, �������ȣ, �ּ� ����	
			function inputAddr(){
					
				// ���θ��ּ� ����
				if(document.getElementById('road').checked){
					zipcode = document.getElementById('road_zipcode').value;
					sectionNum = document.getElementById('road_sectionNum').value;
					roadAddr1 = document.getElementById('roadAddr1').value;
					roadAddr2 = document.getElementById('roadAddr2').value;
					roadAddrDetail = document.getElementById('road_detail').value;
					if (roadAddrDetail != ''){
						addrResult = roadAddr1 +", "+ roadAddrDetail +" "+roadAddr2;
					} else {
						addrResult = roadAddr1 +" "+roadAddr2;
					}
					// �����ּ� ����
					} else {
						zipcode = document.getElementById('jibun_zipcode').value;
						sectionNum = document.getElementById('jibun_sectionNum').value;
						addrResult = document.getElementById('jibunAddr').value;
						detail = document.getElementById('jibun_detail').value;
						if(detail != ''){
							addrResult += ', '+ detail;
						}
					}
					window.opener.putAddr(zipcode, sectionNum, addrResult);
					self.close();
			}

			function roadDetailSelect(){
				document.getElementById('road').checked = true;	
			}
			
			function jibunDetailSelect(){
				document.getElementById('jibun').checked = true;
			}
			
			function roadRadioSelect(){
				document.getElementById('road_detail').focus();	
			}
			
			function jibunRadioSelect(){
				document.getElementById('jibun_detail').focus();	
			}


		</script>
	</body>
</html>
