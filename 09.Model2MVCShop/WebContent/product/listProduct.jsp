<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
<title>상품관리 / 상품 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	function fncGetList(currentPage) {
		$("#currentPage").val(currentPage);
		$("form").attr("method","POST").attr("action","/product/listProduct?menu=${param.menu=='manage'?'manage':'search'}").submit();
	}
	
	$(function(){
		$("td.ct_btn01:contains('검색')").on("click", function(){
			fncGetUserList(1);
		});
		
		$("input[name='delSubmit']").on("click", function(){
			 stateSubmit();
		})
		
		$("#prodName_under").on("click", function(){
			self.location = "/product/listProduct?sort=prod_name+desc&menu=${param.menu}";
		})
		
		$("#prodName_high").on("click", function(){
			self.location = "/product/listProduct?sort=prod_name+asc&menu=${param.menu}";
		})
		
		$("#price_under").on("click", function(){
			self.location = "/product/listProduct?sort=price+desc&menu=${param.menu}";
		})
		
		$("#price_high").on("click", function(){
			self.location = "/product/listProduct?sort=price+asc&menu=${param.menu}";
		})
				
		//$(".ct_list_pop td:nth-child(4n)" ).css("background-color" , "whitesmoke");
	})
	
	// 전체체크
	function allChk(obj){ 
		var chkObj = $("input[name='prodList']");
		var rowCnt = chkObj.length-1;
		var check = obj.checked;
		if(check){
			for(var i=0; i<=rowCnt; i++){
				if(chkObj[i].type=="checkbox"){
					chkObj[i].checked=true;
				}
			}
		}else{
			for(var i=0;i<=rowCnt;i++){
				if(chkObj[i].type=="checkbox"){
					chkObj[i].checked=false;
				}
			}
		}
	}
	
	// 배송 일괄처리
	function stateSubmit(){
		//상품목록 체크
		var chkProd = $("input[name='prodList']");
		var prodNoAndTranCode = "";
		for(var i=0;i<chkProd.length;i++){
			if(chkProd[i].checked==true){
				if(prodNoAndTranCode=="") {
					prodNoAndTranCode += chkProd[i].value;
				}else {
					prodNoAndTranCode += ","+chkProd[i].value;
				}
			}
		}
	
	//여러제품 선택했을 때 각 제품의 tranCode값을 tran(String)변수에 담는다
	var prodList = "";
	var prodNo = "";
	var tranCode = "";
	if(prodNoAndTranCode.indexOf(",")!=-1){
		prodList = prodNoAndTranCode.split(",");
		for(var i=0; i<prodList.length; i++){
			tranCode += "#"+prodList[i].split("+")[1];
			if(i==0) { prodNo += prodList[i].split("+")[0]; }
			else { prodNo += ","+prodList[i].split("+")[0]; }
		}
		ListChk = "true";
	}else{ //제품을 하나만 선택했을 때
		prodList = prodNoAndTranCode.split("+")[0];
		prodNo = prodList;
		tranCode = prodNoAndTranCode.split("+")[1];
	}
	
	//배송상태 체크
	var stateIndex = $(".condition:selected").val();
	var state = $(".condition").val();
	
	if(prodList==""){
		alert("상품을 선택 후 처리해주세요.");
	}else{
		var conChk = confirm(prodNo+" 상품을 "+state+"처리 하시겠습니까?");
		if(conChk){	
			switch(stateIndex){
				case 0 : //배송중처리
					if(tranCode.indexOf("1")==-1) { alert("배송중 처리가 불가합니다."); break; } //유효성 체크
					$("form").attr("method","POST").attr("action","/purchase/updateTranCodeByProd?prodNo='"+prodNo+"'&tranCode=2'").submit();
					alert("처리되었습니다.");
					break;
				case 1 : //반품
					if(tranCode!=-2) { alert("반품처리가 불가합니다."); break; } //유효성 체크
					$("form").attr("method","POST").attr("action","/purchase/updateTranCodeByProd?prodNo='"+prodNo+"'&tranCode=-3'").submit();
					alert("처리되었습니다.");
					break;
				case 2 : //반품거절
					if(tranCode!=-2) { alert("반품거절처리가 불가합니다."); break; } //유효성 체크
					$("form").attr("method","POST").attr("action","/purchase/updateTranCodeByProd?prodNo='"+prodNo+"'&tranCode=${sessionScope.tranCodeTemp}'").submit();
					sessionScope.removeAttribute("tranCodeTemp");
					alert("처리되었습니다.");
					break;
				}
		}
	}
	
}

</script>
</head>

<body bgcolor="#ffffff" text="#000000">

	<div style="width: 98%; margin-left: 10px;">

		<form name="detailForm">

			<table width="100%" height="37" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="15" height="37"><img src="/images/ct_ttl_img01.gif" width="15" height="37" /></td>
					<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<c:if test="${param.menu=='manage'}">
									<td width="93%" class="ct_ttl01">상품 관리</td>
								</c:if>
								<c:if test="${param.menu=='search'}">
									<td width="93%" class="ct_ttl01">상품 목록조회</td>
								</c:if>
							</tr>
						</table>
					</td>
					<td width="12" height="37"><img src="/images/ct_ttl_img03.gif" width="12" height="37" /></td>
				</tr>
			</table>


			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
				<tr>

					<!-- 서치할 데이터 입력값이 존재하는 경우 -->
					<c:if test="${!empty search.searchCondition }">
						<td align="right">
						<select name="searchCondition" class="ct_input_g" style="width: 80px">
								<!-- 어드민로 접속했을 경우에만 검색조건에 상품번호를 노출시키겠다  -->
								<c:if test="${!empty user && user.role=='admin'}">
									<option value="-1" ${search.searchCondition=='-1'?"selected":""}>주문번호</option>
									<option value="0" ${search.searchCondition=='0'?"selected":""}>상품번호</option>
								</c:if>
								<option value="1" ${search.searchCondition=='1'?"selected":""}>상품명</option>
								<option value="2" ${search.searchCondition=='2'?"selected":""}>상품가격</option>
						</select>
						<input type="text" name="searchKeyword" onkeypress="javascript:if(event.keyCode==13) fncGetList('1');" class="ct_input_g"
													style="width: 200px; height: 19px" value="${param.searchKeyword}">
						</td>
					</c:if>

					<!-- 서치할 데이터 입력값이 존재하지 않는 경우 -->
					<c:if test="${empty search.searchCondition }">
						<td align="right">
						<select name="searchCondition" class="ct_input_g" style="width: 80px">
								<!-- 어드민로 접속했을 경우에만 검색조건에 상품번호를 노출시키겠다  -->
								<c:if test="${!empty user && user.role=='admin'}">
									<option value="-1">주문번호</option>
									<option value="0">상품번호</option>
								</c:if>
								<option value="1">상품명</option>
								<option value="2">상품가격</option>
						</select>
						<input type="text" name="searchKeyword" class="ct_input_g" style="width: 200px; height: 19px"></td>
					</c:if>

					<td align="right" width="70">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="17" height="23"><img src="/images/ct_btnbg01.gif" width="17" height="23"></td>
								<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top: 3px;">
									검색
								</td>
								<td width="14" height="23"><img src="/images/ct_btnbg03.gif" width="14" height="23"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>


			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
				<tr>
					<td colspan="15">전체 ${resultPage.totalCount} 건수, 현재 ${resultPage.currentPage} 페이지</td>
				</tr>

				<!-- 0420 체크박스 추가 -->
				<c:if test="${!empty sessionScope.user && user.role=='admin'}">
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="15" align="right"> 선택한 상품을
							<select class="condition" name="condition">
								<option value="배송중">배송중</option>
								<option value="반품">반품</option>
								<option value="반품거절">반품거절</option>
							</select> &nbsp;
							<input type="button" name="delSubmit" value="처리">
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</c:if>

				<tr>
					<td class="ct_list_b" width="100">
						<!-- 0420 체크박스 추가 -->
						<c:if test="${!empty sessionScope.user && user.role=='admin' }">
							<input type="checkbox" name="prodListAll" value="prodAll" onclick="allChk(this);">
						</c:if> No
					</td>
					<td class="ct_line02"></td>

					<!-- 리스트에 상품이미지 노출 -->
					<td class="ct_list_b">상품이미지</td>
					<td class="ct_line02"></td>

					<!-- 어드민로 접속했을 경우에만 주문번호를 노출시키겠다  -->
					<c:if test="${!empty user && user.role=='admin'}">
						<td class="ct_list_b" width="100">상품번호</td>
						<td class="ct_line02"></td>
					</c:if>

					<td class="ct_list_b" width="150">상품명
						<c:if test="${requestScope.sort=='prod_no asc' || sort=='prod_name asc' || sort=='price asc' || sort=='price desc'}">
							<span id="prodName_under">↓</span>
						</c:if>
						<c:if test="${requestScope.sort=='prod_name desc'}">
							<span id="prodName_high">↑</span>
						</c:if>
					</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">가격
						<c:if test="${requestScope.sort=='prod_no asc' || sort=='price asc' || sort=='prod_name asc' || sort=='prod_name desc'}">
							<span id="price_under">↓</span>
						</c:if>
						<c:if test="${requestScope.sort=='price desc'}">
							<span id="price_high">↑</span>
						</c:if>

					</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b">등록일</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b">현재상태</td>
				</tr>
				<tr>
					<td colspan="15" bgcolor="808285" height="1"></td>
				</tr>

				<!-- product -->
				<c:set var="i" value="0" />
				<c:forEach var="product" items="${list}">
					<c:set var="i" value="${ i+1 }" />

					<tr class="ct_list_pop">
						<td align="center">
							<!-- 0420 체크박스 추가 -->
							<c:if test="${!empty sessionScope.user && user.role=='admin' }">
								<input type="checkbox" name="prodList" value="${product.prodNo}+${product.proTranCode}">
							</c:if>
							<c:if test="${resultPage.currentPage=='1'}"> ${i} </c:if>
							<c:if test="${resultPage.currentPage!='1'}"> ${(i+resultPage.pageSize*(resultPage.currentPage-1))} </c:if>
						</td>
						<td></td>

						<!-- 리스트에 상품이미지 노출 -->
						<td align="center">
							<a href="#">
								<!-- 이미지가 없는 경우 -->
								<c:if test="${empty product.fileName}"><img src="http://placehold.it/50X50"/></c:if>
								<!-- 이미지가 있는 경우 -->
								<c:if test="${!empty product.fileName}"><img src="/images/uploadFiles/${product.fileName}" width="50" height="50"/></c:if>
							</a>
						</td>
						<td></td>

						<!-- 어드민으로 접속했을 경우에만 상품번호를 노출시키겠다  -->
						<c:if test="${!empty user && user.role=='admin'}">
							<td align="center">${product.prodNo}</td>
							<td></td>
						</c:if>

						<td align="left">
							<!-- 판매중 상품이라면 -->
							<c:if test="${product.proTranCode=='0' || product.proTranCode=='-1'}">
								<a href="${param.menu=='manage'?'/product/updateProduct':'/product/getProduct'}?prodNo=${product.prodNo}&menu=${param.menu}&status=0">${product.prodName}</a>
							</c:if>
							<!-- 판매중 상품이 아니라면 -->
							<c:if test="${product.proTranCode!='0' && product.proTranCode!='-1'}">
								<a href="${param.menu=='manage'?'/product/updateProduct':'/product/getProduct'}?prodNo=${product.prodNo}&menu=${param.menu}">${product.prodName}</a>
							</c:if>
						</td>
						
						<td></td>
						<td align="left">${product.price}</td>
						<td></td>
						<td align="left">${product.regDate}</td>
						<td></td>
						<td align="left">
							<!-- 어드민으로 접속했을 경우 -->
							<c:if test="${!empty user && user.role=='admin'}">
								<c:choose>
									<c:when test="${product.proTranCode=='0' || product.proTranCode=='-1'}">
										판매중
									</c:when>
									<c:when test="${product.proTranCode.trim()=='1'}">
										구매완료
									</c:when>
									<c:when test="${product.proTranCode.trim()=='2'}">
										배송중
									</c:when>
									<c:when test="${product.proTranCode.trim()=='3'}">
										배송완료
									</c:when>
									<c:when test="${product.proTranCode.trim()=='-2'}">
										반품신청					
									</c:when>
									<c:when test="${product.proTranCode.trim()=='-3'}">
										반품완료
									</c:when>
								</c:choose>
							</c:if>
							<!-- 유저로 접속했을 경우 -->
							<c:if test="${empty user || user.role=='user'}">
								<c:choose>
									<c:when test="${product.proTranCode.trim()=='0' || product.proTranCode.trim()=='-1'}">
										판매중
									</c:when>
									<c:when test="${product.proTranCode!='0'}">
										재고없음
									</c:when>
								</c:choose>
							</c:if>

						</td>
					</tr>
					<tr>
						<td colspan="15" bgcolor="D6D7D6" height="1"></td>
					</tr>
				</c:forEach>
			</table>

			<!-- PageNavigation Start... -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
				<tr>
					<td align="center">
						<input type="hidden" id="currentPage" name="currentPage" value="" />
						<jsp:include page="../common/pageNavigator.jsp" />
					</td>
				</tr>
			</table>
			<!-- PageNavigation End... -->

		</form>

	</div>
</body>
</html>