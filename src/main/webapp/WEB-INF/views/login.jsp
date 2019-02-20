<%@page import="java.math.BigInteger"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
	<%
    String clientId = "NUjBHsvxCTjUTS1ileL9";//애플리케이션 클라이언트 아이디값";
    String redirectURI = URLEncoder.encode("http://localhost:8090/getNaverToken.do", "UTF-8");
    SecureRandom random = new SecureRandom();
    String state = new BigInteger(130, random).toString();
    String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
    apiURL += "&client_id=" + clientId;
    apiURL += "&redirect_uri=" + redirectURI;
    apiURL += "&state=" + state;
    session.setAttribute("state", state);
	%>
	
	
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>로그인</title>
<link href="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet"> -->
<!-- <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet"> -->
<style type="text/css">
	body{
	background-color: #eee;
	}
	.input-width{
		width: 500px;
	}
	.center{
		width: 800px;
		margin-top: 6%;
	}
	.upperspacing{
		margin-top: 100px;
	}
	.centerGo{
		text-align: center;
		
		margin: 0px 30%;
	}
</style>
<!-- 카카오 sdk설정 -->
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>

<!-- 네이버 로그인 -->
 <script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>


</head>
<!-- <body class="bg-light"> -->

<body class="text-center">

<jsp:include page="include/navigation.jsp" />

    <form class="form-signin" method="post" action="login_member.do">
      
	<div class="container center">
	    <h1 class="h3 mb-3 font-weight-normal">로그인</h1><hr>
    </div>
    
	<div class="upperspacing" >
		<div class="nav justify-content-center">
			<input type="text" class="form-control" name="member_id" placeholder="아이디를 입력하세요." style="width:300px;" required autofocus >
		</div>
		<div class="nav justify-content-center">
			<input type="password" class="form-control" name="member_pwd" placeholder="비밀번호를 입력하세요" style="width:300px;" required >
		</div>
	</div>
			
    <div class="upperspacing">
	    <button class="btn btn-lg btn-primary btn-block" type="submit" style="width:300px; margin-left : auto; margin-right:auto;" >로그인</button>
	    <a class="btn btn-lg btn-primary btn-block " href="signin.do" style="width:300px;  margin-left : auto; margin-right:auto;">회원가입</a>
	    <%--
		이메일 서비스
	    <a class="btn btn-lg btn-primary btn-block " href="findId.do" style="width:300px; margin-left:auto; margin-right:auto;">아이디 찾기</a>
	    <a class="btn btn-lg btn-primary btn-block" href="findPwd.do" style="width:300px; margin-left:auto; margin-right:auto;">비밀번호 찾기</a>
	 	--%>
	    <a id="custom-login-btn" href="javascript:loginWithKakao()" class="btn-block" style="display: inline!important; ">
	    <img src="//k.kakaocdn.net/14/dn/btqbjxsO6vP/KPiGpdnsubSq3a0PHEGUK1/o.jpg" width="300px" style="margin-top: 10px;"/></a>
	
		<!-- <div id="naver_id_login" onclick="naverlogin()"> 네이버 로그인 </div> -->
		<div>
			<a href="<%=apiURL%>"><img height="50" src="resources/external_image/Naver/NaverLoginButton_perfect.PNG" style="width: 300px; margin-top: 10px;" /></a>
		</div>

	</div>
      
  
    </form>
    
    
    
<script type="text/javascript">

	// 사용할 앱의 JavaScript 키를 설정해 주세요.
	Kakao.init('00b835d4bad0b5e92756a8aa2bfab97c');

	//카카오 로그인 버튼 생성
	function loginWithKakao() {
		if (Kakao.Auth.getAccessToken() != null) {

			Kakao.Auth.loginForm({
				success: function(authObj) {
		    		alert("api Request1");
					kakaoApiRequest();
					
				},
				fail: function(errorObj) {
					alert("errorObj : "+JSON.stringify(errorObj));
				}
			});
			
		}else{
			
			Kakao.Auth.login({
				success: function(authObj) {
		    		alert("api Request2");
					kakaoApiRequest();
				},
				fail: function(err) {
		    		$("#noti").text("실패 : "+JSON.stringify(err));
				}
			});
		}
	}
	
	function kakaoApiRequest() {
		Kakao.API.request({
			url: '/v2/user/me',
			success: function(res) {

				$.ajax({
					url: "kakaoLogin.do",
					async:false,
					data: {
						"id" : res.id,
						"name" : res.properties.nickname,
						"email" : res.kakao_account.email
					},
					type: "post",
					success: function(data) {
						location.href="kaoGoHome.do?id="+data;
					},
					error: function(error) {
						alert(error);
					}
				});

			},
			fail: function(error) {
				$("#returnRequest").text("카카오 로그인 후 리턴 실패 : "+JSON.stringify(error));
			}
		});
	}
	

</script>

</body>
</html>
