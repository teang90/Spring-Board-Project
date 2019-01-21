<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>회원가입</title>
<link href="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet"> -->
<!-- <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet"> -->
<style type="text/css">
	body{
	background-color: #eee;
	}
	.h3{margin-top: 5%;}
	/* .form-control{width: 500px !important;} */
	
	body{
		text-align: center;
	}
	.center{
		
	}
	
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-3.3.1.js"></script>
<script type="text/javascript">
	
	/* function idDuplicate() { */

	var idch= 0 ;

	$(function() {
		$("#idcheck").click(function() {
			$.ajax({
				url: "idcheck.do",
				data: $("#member_id").val(),
				type: "post",
				dataType: "text",
				contentType: "application/text; charset=utf-8", //이거 필요한가? 모르겠네? 일단 넣기
				success: function(data) { //data는 스트링임...
					if (data=='1') {
						alert($("#member_id").val()+"는 이미 존재하는 아이디입니다.\n다른 아이디를 입력하십시오.");
						$("#member_id").val("");
						$("#member_id").focus();
						idch = 0;
					}else{
						alert("사용가능한 아이디입니다.");
						idch = 1;
					}
				},
				error: function(error) {
					alert("no");
					alert(error);
				}
			});
		});
	});
	
	function sign(f) {
		if (idch == '0') {
			alert("아이디 [중복체크]를 클릭하여, 사용가능한 아이디인지 확인하십시오.");	
			return ;
		}
		if(f.member_pwd.value ==""){
			alert("비밀번호를 입력하십시오");
			return ;
		}
		if(f.member_pwd.value != f.member_pwd2.value){
			alert("비밀번호가 일치하지 않습니다.");
			return ;
		}
			
		f.action="signin_member.do";
		f.submit();
	}
	
</script>
</head>
<body class="bg-light">
<jsp:include page="include/navigation.jsp" />
    
      <div class="text-center mb-4">
        <!-- <img class="mb-4" src="../../assets/brand/bootstrap-solid.svg" alt="" width="72" height="72"> -->
        <h1 class="h3 mb-3 font-weight-normal">회원가입</h1>
        <hr>
      </div>
    
	<div class="container">
    <form class="form-signin" method="post" >
		 
		 <div class="form-row align-items-center mb-4">
        	<label class="col-sm-1 col-form-label">아이디</label>
		    <div class="col-auto my-1">
        	<input type="text" class="form-control" name="member_id" id="member_id" placeholder="아이디를 입력하세요" required autofocus style="width: 400px">
		    </div>
		    <div class="col-auto my-1"><button class="btn btn-primary" id="idcheck">중복검사</button></div>
		    <!-- onclick="idDuplicate()"  -->
		 </div>
		  
		  
		 <div class="form-group row mb-4">
		    <label class="col-sm-1 col-form-label">비밀번호</label>
		    <div class="col-sm-2">
		      <input type="password" class="form-control" name="member_pwd" placeholder="비밀번호를 입력하세요" style="width: 500px" required>
		      <input type="password" class="form-control" name="member_pwd2" placeholder="비밀번호를 다시 한번 입력하세요" style="width: 500px" required>
		    </div>
		  </div>
		  
		 <div class="form-group row mb-4">
		    <label class="col-sm-1 col-form-label">이름</label>
		    <div class="col-sm-2">
		      <input type="text" class="form-control" name="member_name" placeholder="이름을 입력하십시오" style="width: 500px" required>
		    </div>
		  </div>
		  
		 <div class="form-group row mb-4">
		    <label class="col-sm-1 col-form-label">이메일</label>
		    <div class="col-sm-2">
		      <input type="email" class="form-control" name="member_email" placeholder="your-email@example.com" style="width: 500px" required>
		    </div>
		 </div>
		  
		<!--  <div class="form-group row mb-8">
		    <label class="col-sm-1 col-form-label">회원 이미지</label>
		    <div class="col-sm-2">
	        <input type="file" class="form-control"  name="member_img" placeholder="회원이미지는 가로 150px, 세로 180px을 권장합니다." style="width: 500px">
		    </div>
		 </div> -->


     <!--  <div class="checkbox mb-3">
        <label>
          <input type="checkbox" value="remember-me"> Remember me
        </label>
      </div> -->
      <input type="button" class="btn btn-lg btn-primary btn-block" value="가입하기" style="width: 595px"  onclick="sign(this.form)">
      <p class="mt-5 mb-3 text-muted text-center">&copy; 2017-2018</p>
    </form>
    </div>
  </body>
</html>