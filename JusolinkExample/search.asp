<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="../Example.css" media="screen" />
		<title>주소 API SDK ASP Example.</title>
	</head>
	<body>
		<div id="content">
			<p class="heading1">주소 API SDK ASP Example.</p>
			<br/>

			<fieldset class="fieldset1">
				<legend>주소찾기</legend>
					<div class ="fieldset4">
						<input class= "txtZipcode left" type="text" placeholder="우편번호" id="txtZipcode"/>
						<input class= "txtZipcode left" type="text" placeholder="새우편번호" id="txtSectionNum" />
						<a href=javascript:openNewWindow("zipcode_search.asp")><p class="find_btn find_btn01 hand">주소찾기</p></a>
						<input class= "txtAddr" type="text" placeholder="주소" id="txtAddr" name="txtAddr">
					</div>
			</fieldset>
			<br />
		 </div>

		<script type="text/javascript">
			function openNewWindow(window) {
				window_width = 500;
				window_height = 600;

				screen_width = screen.width;
				screen_height = screen.height;

				open_x = (screen_width - window_width)/2;
				open_y = (screen_height - window_height)/2;
				
				open(window,"NewWindow","left="+open_x+", top="+open_y+", toolbar=no, location=no, status=no, resizable=yes, width="+window_width+", height="+window_height);
			}
			
			function putAddr(zipcode, sectionNum, addrTxt){
				document.getElementById('txtZipcode').value = zipcode;
				document.getElementById('txtSectionNum').value = sectionNum;
				document.getElementById('txtAddr').value = addrTxt;
			}

		</script>
	</body>
</html>
