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

<title>[TAE-YOUNG JEONG] PROJECT</title>

<!-- Bootstrap core CSS -->
<!-- <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet"> -->
<link href="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom fonts for this template -->
<link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet">

<!-- Custom styles for this template -->
<link href="${pageContext.request.contextPath}/resources/bootstraps/template/css/one-page-wonder.min.css" rel="stylesheet">

<style type="text/css">
	.shadow{
		box-shadow: 2px 2px 0px 1px #ccc !important;
		margin-bottom: 15px;
		margin-right: 25px;
		margin-left: 25px;
	}
	
	.spacing{
		margin-bottom: 20px;
		text-align: center;
	}
</style>

<!-- Bootstrap core JavaScript -->
<script src="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

</head>

<body>
 	<c:if test="${empty member_id}">
	 	<jsp:include page="include/navigation.jsp" />
 	</c:if>
 	<c:if test="${!empty member_id}">
	 	<jsp:include page="include/navigation.jsp?member_id=${member_id}" />
 	</c:if>
	<!-- 본문 내용  -->
    <header class="masthead text-center text-white">
      <div class="masthead-content">
        <div class="container">
          <h1 class="masthead-heading mb-0">Welcome to Taeyoung's Project</h1>
          <%-- <a href="#" class="btn btn-primary btn-xl rounded-pill mt-5">Learn More</a> --%>
        </div>
      </div>
      <div class="bg-circle-1 bg-circle"></div>
      <div class="bg-circle-2 bg-circle"></div>
      <div class="bg-circle-3 bg-circle"></div>
      <div class="bg-circle-4 bg-circle"></div>
    </header>

    <section>
      <div class="container">
        <div class="row align-items-center">
         
       	<div class="col-lg-6"> 
            <div class="p-5">
            <img class="img-fluid rounded" 
            src="resources/images/JeongTaeYoung.jpg" alt="Jeong_img" 
            style="margin-left: 25%">
            </div>
        </div>
        
        <div class="col-lg-6">
			<div class="p-5">
	            <h2 class="display-4">환영합니다.</h2>
	            <br>
	            <div>- CRUD 기능을 목적으로 간단한 게시판을 제작했습니다.</div>
				<div>- 제작기간:&nbsp; 3주</div>
				<div>- 참여인원:&nbsp; 1명(본인)</div>
				<br>				
				<div>- 테스트 아이디:&nbsp; <strong>visitor</strong></div>
				<div>- 테스트 비밀번호:&nbsp;  <strong>v1</strong></div>
          	</div>
        </div>
        
        </div>
      </div>
    </section>
    
	<hr style="margin-bottom: 10px; border: 1px solid rgba(0,0,0,.1); ">    
	
    <div class="container">
		
    	<!-- Three columns of text below the carousel -->
        <div class="row">

          <div class="col-lg-12 spacing">
			
			<p style="text-align: center; font-size: 15px; margin-bottom: 20px; "><b style="font-size: 20px;">프로젝트</b>를 만들면서 사용한 언어 및 툴 등</p>
            <img class="rounded-circle shadow" src="resources/external_image/PLanguage_img/Java.png" alt="java_img">
        
            <img class="rounded-circle shadow" src="resources/external_image/PLanguage_img/JS.png" alt="" >
        
            <img class="rounded-circle shadow" src="resources/external_image/PLanguage_img/spring.png" alt="" ><br>
        
            <img class="rounded-circle shadow" src="resources/external_image/PLanguage_img/Mybatis2.jpg" alt="" style="width: 75px; height: 75px;" >
        
            <img class="rounded-circle shadow" src="resources/external_image/PLanguage_img/oracle3.png" alt="" style="width:75px;" >
        
            <img class="rounded-circle shadow" src="resources/external_image/PLanguage_img/tomcat.png" alt="" ><br>

            <img class="rounded-circle shadow" src="resources/external_image/PLanguage_img/jqeury.png" alt="" style="width: 75px; height: 75px;" >

            <img class="rounded-circle shadow" src="resources/external_image/PLanguage_img/bootstrap.jpg" alt="" >

            <img class="rounded-circle shadow" src="resources/external_image/PLanguage_img/ajax.jpg" alt=""  >
          </div>
        </div>
      </div>
	
    <!-- Footer -->
	<jsp:include page="include/footer.jsp" />
	<br>
</body>
</html>
