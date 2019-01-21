<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<meta property="og:type" content="website" >
<meta property="og:url" content="http://localhost:8090/controller/" >
<meta property="og:title" content="스프링 게시판 홈페이지" >
<meta property="og:description" content="스프링은 봄을 마음으로 봄" >
<meta property="og:image" content="${pageContext.request.contextPath}/resources/images/boundary.jpg" >

<title>[TAE-YOUNG JEONG] PROJECT</title>

<!-- Bootstrap core CSS -->
<!-- <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet"> -->
<link href="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom fonts for this template -->
<link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet">

<!-- Custom styles for this template -->
<%-- <link href="${pageContext.request.contextPath}/resources/bootstraps/template/css/one-page-wonder.min.css" rel="stylesheet"> --%>

<!-- Bootstrap core JavaScript -->
<script src="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<style type="text/css">
.h3_spacing{
	margin-top: 5%;
}
body{
	background-color: #eee;
}
.upper-gap{
	margin:5% 0px;
}
.a_tag{
display: block;
}
table{
	text-align: center;
}

.gap_lower{
	margin: 5px 0px;
}
</style>
<script type="text/javascript">
	function newboard() {
		location.href="go_makingBoard.do";
	}

</script>
</head>
<body>
 	<c:if test="${empty member_id}">
	 	<jsp:include page="include/navigation.jsp" />
 	</c:if>
 	<c:if test="${!empty member_id}">
	 	<jsp:include page="include/navigation.jsp?member_id=${member_id}" />
 	</c:if>
 	<h3 class="h3_spacing" style="text-align: center;">기상 게시판</h3>
 	<hr>
 	
	<!-- 본문 내용  -->
	<div class="upper-gap container">
			
	</div>
	
	<!-- 하단 부에  추천수 높은 인기글을 목록화 할거임 
	1. 카테고리 상관없이 조회수 높은 녀석들을 가져오자(추천수 30개 이상)
	
	-->
	<div class="container">
	<button class="btn btn-primary gap_lower" onclick="newboard()" >글쓰기</button>
	<c:if test="${empty board_list}">
		<p style="text-align: center;">작성된 게시글이 없습니다.</p>
	</c:if>
	<c:if test="${!empty board_list}">
		<table class="table table-hover">
			<thead>
				<tr>
					<!--관리자 로그인시 체크박스로 삭제시키기 <th><input type="checkbox" name="delcheckbox"></th> -->
					<th>No</th>
					<th>게시글 항목</th>
					<th>작성자</th>
					<th>제목</th>
					<th>조회</th>
					<th>추천</th>
					<th>작성일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="k" items="${board_list}" varStatus="vs">
					<tr>
						<td>${board_list.size()-vs.index}</td>
						<td>${k.board_category}</td>
						<td><b>${k.board_id}</b></td>
						<%-- 하나의 글 상세보기할때 복합키로 카테고리와 다른 키를 같이 보내거나 아님 기본키(+@) 보내거나... 일단 기본키 보내기로... --%>
						<td><strong><a class="a-tag" onmouseup="mouseUp()" href="oneBoard.do?board_pk=${k.board_pk}">${k.board_title}</a></strong></td>
						<td>${k.board_hit}</td>
						<td>${k.board_recommendation}</td>
						<td>${k.board_date}</td>
					</tr>
				</c:forEach>					
			</tbody>	
		</table>
	</c:if>
	<button class="btn btn-primary gap_lower" onclick="newboard()" >글쓰기</button>
	</div>
	<div class="upper-gap container">
	</div>
   
   
    <!-- Footer -->
	<jsp:include page="include/footer.jsp" />
	<br>
</body>
</html>
