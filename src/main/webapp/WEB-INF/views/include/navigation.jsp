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

<!-- Bootstrap core JavaScript -->
<script	src="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
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
						<a class="nav-link" href="weather.do">기상게시판</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="music.do">음악게시판</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="freedom.do">자유게시판</a>
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
							<a class="nav-link" href="logout.do?member_id=${member_id}">로그아웃</a>
						</li>
					</c:if>
				</ul>
			</div>
		</div>
	</nav>
</body>
</html>
