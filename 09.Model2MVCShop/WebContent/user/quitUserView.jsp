<%@ page contentType="text/html; charset=euc-kr"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
<title>ȸ��Ż��</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script type="text/javascript">
<!--
function fncQuitCheck() {
	var radio = document.detailForm.reason;
	var chkCnt = 0;
	var chkValue ="";
	
	for(var i=0; i<radio.length; i++){
		if(radio[i].checked==true){
			chkCnt++;
			chkValue += radio[i].value;
		}
	}
	
	if( chkCnt==0 || (chkValue=='��Ÿ'&&document.detailForm.reasonText.value=="") ){
		alert("������ �ݵ�� �Է����ֽñ� �ٶ��ϴ�.");
	}else{
		if(chkValue=='��Ÿ') { chkValue = document.detailForm.reasonText.value; }
		
		document.detailForm.action='/user/quitUser?userId=${user.userId}&reason='+chkValue;
	    document.detailForm.submit();
	    
	    top.opener.location="/user/loginView.jsp"
	    window.close();
	    
	}
	
}
-->
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

	<form name="detailForm" method="post">
		<h4>
			���� Ż���Ͻðڽ��ϱ�?
			</h2>
			Ż����� : <br>
			<input type="radio" name="reason" value="�������� ������"><font size="2">�������� ������</font><br>
			<input type="radio" name="reason" value="������ ��� ��ǰ�� ���"><font size="2">������ ��� ��ǰ�� ���</font><br>
			<input type="radio" name="reason" value="��Ÿ"><font size="2">��Ÿ</font>&nbsp;<input type="text" name="reasonText"><br>
			<br>
			<input type="button" value="Ȯ��" onclick="javascript:fncQuitCheck();">
			<input type="button" value="���" onclick="javascript:window.close();">
	</form>

</body>
</html>