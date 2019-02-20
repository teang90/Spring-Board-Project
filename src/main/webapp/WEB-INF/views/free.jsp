<%@page import="com.ict.controller.Controller"%>
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
<%-- 
<meta property="og:type" content="website" >
<meta property="og:url" content="http://localhost:8090/controller/" >
<meta property="og:title" content="스프링 게시판 홈페이지" >
<meta property="og:description" content="스프링은 봄을 마음으로 봄" >
<meta property="og:image" content="${pageContext.request.contextPath}/resources/images/boundary.jpg" >
 --%>
<title>[TAE-YOUNG JEONG] PROJECT</title>

<!-- Bootstrap core CSS -->
<!-- <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet"> -->
<link href="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom fonts for this template -->
<link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet">

<!-- Bootstrap core JavaScript -->
<%-- <script src="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/jquery/jquery.min.js"></script> 
<script src="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/js/bootstrap.bundle.min.js"></script> 
--%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-3.3.1.js"></script>

<style type="text/css">
.h3_spacing{
	margin-top: 100px;
}
body{
	background-color: #eee;
}
.upper-gap{
	margin-bottom: 50px;
}
table{
	text-align: center;
}
.gap_lower{
	margin: 5px 0px;
}
.noname{
	margin: auto;
}

#todayWeather {position: relative; width: 340px; height: 210px; top: 50px;  margin:0 auto; padding:0; overflow: hidden;}
#todayWeather ul {position: absolute; margin: 0px; padding:0; list-style: none; }
#todayWeather ul li {float: left; width: 340px; height: 210px; margin:0; padding:0;}

</style>

<script type="text/javascript">
	var id = '${member_id}';
	function newboard() {
		if (id == "" || id == null) {
			var confirm_alert = confirm("로그인이 필요합니다. 로그인 하시겠습니까?");
			if (confirm_alert) {
				location.href="login.do";
			}
			return ;
		}
		location.href="go_makingBoard.do";
	}
	
	function search() {
		
		var keyword =  document.getElementsByName("keyword")[0].value;
		var legend = document.getElementsByName("legend")[0].value;
		if (keyword == "") {
			alert("검색어를 입력해주십시오");
			return ;
		}
		$.ajax({
			url: "searchKeyword.do",
			data: {
				"board_keyword" : keyword,
				"board_legend" : legend
			},
			dataType: "json",
			type: "post",
			success: function(data) {
				$("#table").empty();
				var table ="";
				if (Object.keys(data).length > 0) {
				$.each(data, function(index, data) {
					table += "<tr>";
					table += "<td>"+(index+1)+"</td>";
					table += "<td>"+this["board_category"]+"</td>";
					table += "<td>"+this["board_id"]+"</td>";
					table += "<td><a href='oneBoard.do?board_pk="+this["board_pk"]+"&cPage=${pg.cPage}"+"'>"
							+this["board_title"]+"</a></td>";
					table += "<td>"+this["board_hit"]+"</td>";
					table += "<td>"+this["board_recommendation"]+"</td>";
					table += "<td>"+"-"+"</td>"
					table += "<td>"+this["board_date"]+"</td>";
					table += "</tr>";
				});
					$("#table").append(table);
				}else{
					$("#table").append("<tr><td colspan='8'><b>검색어와 연관된 결과가 없습니다.</b></td></tr>");
				}
			},
			error: function(error) {
				alert("실패");
			}
		});
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
 	<h3 class="h3_spacing" style="text-align: center;">게시판</h3>
 	<hr class="upper-gap">
 	
	<div class="container">
 	
			<div class="d-flex bd-highlight mb-3">
				<div class="mr-auto p-2 bd-highlight"><button class="btn btn-primary gap_lower" onclick="newboard()" >글쓰기</button></div>

				<div class="p-2 bd-highlight">
				  <select class="custom-select" style="width: 130px;" name="legend">
				  	<option value="all">글쓴이+내용+제목</option>
				  	<option value="writer">글쓴이</option>
				  	<option value="content">내용</option>
				  	<option value="title">제목</option>
				  </select>
				</div>
				
				<div class="p-2 bd-highlight"><input type="search" name="keyword" class="form-control marginleft" style="width: 200px;"></div>
				<div class="p-2 bd-highlight"><input type="button" value="검색" onclick="search()" class="btn btn-outline-primary marginleft"></div>
			</div>

	<c:if test="${empty board_list}">
		<p style="text-align: center;">작성된 게시글이 없습니다.</p>
	</c:if>
	<c:if test="${!empty board_list}">
		<table class="table table-hover">
			<thead>
				<tr>
					<!--관리자 로그인시 체크박스로 삭제시키기 <th><input type="checkbox" name="delcheckbox"></th> -->
					<th width="5%">No</th>
					<th width="16%">게시글 항목</th>
					<th width="15%">작성자</th>
					<th width="20%">제목</th>
					<th width="8%">조회</th>
					<th width="8%">추천</th>
					<th width="8%">답글</th>
					<th width="20%">작성일</th>
				</tr>
			</thead>
			<tbody  id="table">
				<c:forEach var="k" items="${board_list}" varStatus="vs" >
					<tr>
						<td>
						${pg.totalRecord - (pg.cPage - 1)*(pg.numPerPage) - vs.count + 1}
						</td>
						
						<td>${k.board_category}</td>
						<td><b>${k.board_id}</b></td>
						<td>
							<strong><a href="oneBoard.do?board_pk=${k.board_pk}&cPage=${pg.cPage}">${k.board_title}</a></strong>
						</td>
						<td>${k.board_hit}</td>
						<td>${k.board_recommendation}</td>
						<td>
						<c:set var="cnt" value="0" />
						<c:forEach var="answer_list" items="${boardAnswer_list}">
							<c:forEach var="t" items="${answer_list}">
								<c:if test="${t.answer_bd_pk == k.board_pk}">
									<c:set var="cnt" value="${cnt+1}"  />
								</c:if>
							</c:forEach>
						</c:forEach>
						<c:out value="${cnt}" />
						</td>
						<td>${k.board_date}</td>
					</tr>
				</c:forEach>					
			</tbody>
		</table>
	</c:if>

			<div class="mr-auto p-2 bd-highlight">
				<button class="btn btn-primary gap_lower" onclick="newboard()" >글쓰기</button>
			</div>

			<!-- 페이지 처리 -->
			<div class="noname">
			<ul class="pagination justify-content-center">
				
				<c:if test="${pg.cPage != 1}">
					<li class="page-item"><a class="page-link" href="free.do?cPage=${1}" tabindex="-1">First</a></li>		
				</c:if>
				<c:if test="${pg.cPage == 1}">
					<li class="page-item disabled"><a class="page-link" tabindex="-1">First</a></li>		
				</c:if>
				<c:choose>
					<c:when test="${pg.beginPage > pg.pagePerBlock}">
						<li class="page-item"><a class="page-link" href="free.do?cPage=${pg.cPage - pg.pagePerBlock}" tabindex="-1">Prev</a></li>		
					</c:when>
					<c:otherwise>
						<li class="page-item disabled"><a class="page-link" href="#" tabindex="-1">Prev</a></li>		
					</c:otherwise>
				</c:choose>
				
				<c:forEach var="k"  begin="${pg.beginPage}" end="${pg.endPage}" step="1">
					<c:if test="${k == pg.cPage}">
						<li class="page-item active"><a class="page-link" href="free.do?cPage=${k}">${k}</a></li>
					</c:if>
					<c:if test="${k != pg.cPage}">
						<li class="page-item"><a class="page-link" href="free.do?cPage=${k}">${k}</a></li>
					</c:if>
				</c:forEach>
				
				<c:choose>
					<c:when test="${pg.endPage < pg.totalPage}">
							<li class="page-item"><a class="page-link" href="free.do?cPage=${pg.beginPage + pg.pagePerBlock}" tabindex="-1">Next</a></li>		
					</c:when>
					<c:otherwise>
							<li class="page-item disabled"><a class="page-link" href="#" tabindex="-1">Next</a></li>		
					</c:otherwise>
				</c:choose>
				
				<c:if test="${pg.cPage != pg.totalPage}">
					<li class="page-item"><a class="page-link" href="free.do?cPage=${pg.totalPage}" tabindex="-1">Last</a></li>		
				</c:if>
				<c:if test="${pg.cPage == pg.totalPage}">
					<li class="page-item disabled"><a class="page-link" tabindex="-1">Last</a></li>		
				</c:if>
			</ul>
			</div>
	</div>
   
    <!-- Footer -->
	<jsp:include page="include/footer.jsp" />
	<br>
	
</body>
</html>
