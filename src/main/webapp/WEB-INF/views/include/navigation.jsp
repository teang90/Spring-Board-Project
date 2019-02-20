<%@page import="com.ict.mybatis.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	<%
		String member_id = request.getParameter("member_id");
		session.setAttribute("member_id", member_id);
	%> 
	
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>[Tae-young Jeong] SPRING PROJECT</title>

<!-- Bootstrap core CSS -->
<!-- <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet"> -->
<link href="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">


<!-- Custom fonts for this template -->
<link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet">

<!-- Custom styles for this template -->
<link href="${pageContext.request.contextPath}/resources/bootstraps/template/css/one-page-wonder.min.css" rel="stylesheet">

<style type="text/css">
	.logout{
		cursor: pointer;
	}
	
</style>
<!-- Bootstrap core JavaScript -->
<script	src="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- 네이버 js -->
<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
<!-- 카카오js -->
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>

<script type="text/javascript" src="resources/js/jquery-3.3.1.js"></script>
</head>
<body>
	<!-- Navigation -->
	<nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
		<div class="container">
			<c:if test="${empty member_id}">
				<a class="navbar-brand" href="/">Home</a>
			</c:if>
			<c:if test="${!empty member_id}">
				<a class="navbar-brand" href="reloadHome.do?member_id=${member_id}">Home</a>
			</c:if>
			<button class="navbar-toggler" type="button" data-toggle="collapse"
				 data-target="#navbarResponsive"
				 aria-controls="navbarResponsive"
				 aria-expanded="false"
				 aria-label="Toggle navigation">
				 <span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarResponsive">
				<ul class="navbar-nav ml-auto">
					<li class="nav-item">
						<a class="nav-link" href="free.do">자유 게시판</a>
					</li>
					<c:if test="${empty member_id}">
						<li class="nav-item">
							<a class="nav-link" href="login.do">로그인</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" href="signin.do">회원가입</a>
						</li>
					</c:if>
					<c:if test="${!empty member_id}">
						<li class="nav-item">
							<a class="nav-link logout" onclick="javascript:logout()" >로그아웃</a>
						</li>
					</c:if>
				</ul>
			</div>
		</div>
	</nav>
	
	<script type="text/javascript">
	
	var naverToken = null;
	
	function NaverLogout() {
		$.ajax({
			async: false,
			url: "ajaxlogout.do",
			success: function() {
				location.href="http://nid.naver.com/nidlogin.logout";
			}
		});
	}
	
	function logout() {
		getNaverToken();
	 	location.href="logout.do?member_id=${member_id}";
	}
	
 	function getNaverToken() {
		$.ajax({
			url: "returnNaverAccess_token.do",
			async: false,
			success: function(token) {
				if (token == 'success') {
					alert("success token : "+token);
					naverToken = "success";
				}
			},
			error: function(error) {
				alert("실패");
			}
		});
	} 
	
	</script>
</body>
</html>
