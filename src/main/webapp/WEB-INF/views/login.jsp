<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	margin-top: 13%;
	}
	
</style>
<script type="text/javascript">
</script>
</head>
<!-- <body class="bg-light"> -->

<body class="text-center">
<jsp:include page="include/navigation.jsp" />

    <form class="form-signin" method="post" action="login_member.do">
      
	<div class="container center">
    <h1 class="h3 mb-3 font-weight-normal">로그인</h1><hr>
		
	<div class="upperspacing">
		    
      <label class="sr-only">아이디</label>
      <input type="text" class="form-control" name="member_id" placeholder="아이디를 입력하세요." required autofocus>
      
      <label class="sr-only">비밀번호</label>
      <input type="password" class="form-control" name="member_pwd" placeholder="비밀번호를 입력하세요" required>
      <div class="checkbox mb-3">
        <label>
          <input type="checkbox" value="remember-me"> Remember me
        </label>
      </div>
      
      <div class="upperspacing">
	    <button class="btn btn-lg btn-primary btn-block" type="submit">로그인</button>
	    <a class="btn btn-lg btn-primary btn-block" href="signin.do">회원가입</a>
	    <a class="btn btn-lg btn-primary btn-block" href="">아이디 찾기</a>
	    <a class="btn btn-lg btn-primary btn-block" href="">비밀번호 찾기</a>
		<p class="mt-5 mb-3 text-muted">&copy; 2017-2018</p>
      </div>
    </div>
    </div>
    </form>
  </body>
</html>
