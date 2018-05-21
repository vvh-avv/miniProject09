<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	$(function(){
		$("#guest").on("click", function(){
			alert("로그인 후 구매해주시길 바랍니다.");
		})
		
		$("#user").on("click", function(){
			self.location="/purchase/addPurchase?prod_no=${product.prodNo}";
		})
		
		$("#before").on("click", function(){
			history.go(-1);
		})
		
		$("#submit").on("click", function(){
			$("form").attr("method", "POST").attr("action", "/product/listProduct?menu=${param.menu=='manage'?'manage':'search'}").submit();
		})
	})
	
</script>

<title>상품상세조회</title>
</head>

<body bgcolor="#ffffff" text="#000000">

	<form name="detailForm">

		<table width="100%" height="37" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="15" height="37"><img src="/images/ct_ttl_img01.gif" width="15" height="37"></td>
				<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="93%" class="ct_ttl01">상품상세조회</td>
							<td width="20%" align="right">&nbsp;</td>
						</tr>
					</table>
				</td>
				<td width="12" height="37"><img src="/images/ct_ttl_img03.gif" width="12" height="37" /></td>
			</tr>
		</table>

		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 13px;">
			<tr>
				<td height="1" colspan="3" bgcolor="D6D6D6"></td>
			</tr>
			<tr>
				<td width="104" class="ct_write">상품번호 <img src="/images/ct_icon_red.gif" width="3" height="3" align="absmiddle" /> </td>
				<td bgcolor="D6D6D6" width="1"></td>
				<td class="ct_write01">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="105">${product.prodNo}</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td height="1" colspan="3" bgcolor="D6D6D6"></td>
			</tr>
			<tr>
				<td width="104" class="ct_write">상품명 <img src="/images/ct_icon_red.gif" width="3" height="3" align="absmiddle" /> </td>
				<td bgcolor="D6D6D6" width="1"></td>
				<td class="ct_write01">${product.prodName}</td>
			</tr>
			<tr>
				<td height="1" colspan="3" bgcolor="D6D6D6"></td>
			</tr>
			<tr>
				<td width="104" class="ct_write">상품이미지 <img src="/images/ct_icon_red.gif" width="3" height="3" align="absmiddle" /> </td>
				<td bgcolor="D6D6D6" width="1"></td>
				<td class="ct_write01">
				
					<!-- 파일명 확인 <c:out value="*${product.fileName}*"/> -->
					<c:choose>
					
						<c:when test="${!empty product.fileName && product.fileName!=' '}">
							<!-- 복수파일 처리 -->
							<c:if test="${product.fileName.contains(',')}">
								<img src = "/images/uploadFiles/${product.fileName.split(',')[0]}"><br>
								<img src = "/images/uploadFiles/${product.fileName.split(',')[1]}">
							</c:if>
							<c:if test="${!product.fileName.contains(',')}">
								<img src = "/images/uploadFiles/${product.fileName}">
							</c:if>
						</c:when>
						
						<c:otherwise>
							<img src = "/images/empty.GIF">
						</c:otherwise>
						
					</c:choose>
					
				</td>
			</tr>
			<tr>
				<td height="1" colspan="3" bgcolor="D6D6D6"></td>
			</tr>
			<tr>
				<td width="104" class="ct_write">상품상세정보<img src="/images/ct_icon_red.gif" width="3" height="3" align="absmiddle" /> </td>
				<td bgcolor="D6D6D6" width="1"></td>
				<td class="ct_write01">${product.prodDetail}</td>
			</tr>
			<tr>
				<td height="1" colspan="3" bgcolor="D6D6D6"></td>
			</tr>
			<tr>
				<td width="104" class="ct_write">제조일자</td>
				<td bgcolor="D6D6D6" width="1"></td>
				<td class="ct_write01">${product.manuDate}</td>
			</tr>
			<tr>
				<td height="1" colspan="3" bgcolor="D6D6D6"></td>
			</tr>
			<tr>
				<td width="104" class="ct_write">가격</td>
				<td bgcolor="D6D6D6" width="1"></td>
				<td class="ct_write01">${product.price}</td>
			</tr>
			<tr>
				<td height="1" colspan="3" bgcolor="D6D6D6"></td>
			</tr>
			<tr>
				<td width="104" class="ct_write">등록일자</td>
				<td bgcolor="D6D6D6" width="1"></td>
				<td class="ct_write01">${product.regDate}</td>
			</tr>
			<tr>
				<td height="1" colspan="3" bgcolor="D6D6D6"></td>
			</tr>
		</table>

		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
			<tr>
				<td width="53%"></td>
				<td align="right">

					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<!-- 판매중 상품으로 파라미터값이 넘어왔으면 -->
							<c:if test="${!empty param.status}">
								<td width="17" height="23"><img src="/images/ct_btnbg01.gif" width="17" height="23" /></td>
								<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top: 3px;">
									<c:if test="${empty sessionScope.user}">
										<span id="guest">구매</span>
									</c:if>
									<c:if test="${!empty sessionScope.user}">
										<span id="user">구매</span>
									</c:if>
								</td>
								<td width="14" height="23"><img src="/images/ct_btnbg03.gif" width="14" height="23"></td>
								<td width="30"></td>
							</c:if>

							<td width="17" height="23"><img src="/images/ct_btnbg01.gif" width="17" height="23" /></td>
							<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top: 3px;">
								<c:if test="${empty product}">
									<span id="before">이전</span>
								</c:if>
								<c:if test="${!empty product}">
									<span id="submit">확인</span>
								</c:if>
							</td> 
							<td width="14" height="23"><img src="/images/ct_btnbg03.gif" width="14" height="23" /></td>
						</tr>
					</table>

				</td>
			</tr>
		</table>
	</form>

</body>
</html>