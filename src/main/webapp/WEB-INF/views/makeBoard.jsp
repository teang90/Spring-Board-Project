<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Insert title here</title>
<link href="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/smarteditor2-2.8.2.3/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-3.3.1.js"></script>

<style type="text/css">
body{
background-color: #eee;
}
form{
	margin-bottom: 5%;
}
#h3{
	margin-top: 100px;
	margin-bottom: 25px;
}
#savebutton{
	text-align: center;
}
</style>
<script type="text/javascript">

$(function() {

	
	var editor_object = [];
	
	nhn.husky.EZCreator.createInIFrame({
    	oAppRef: editor_object,
	    elPlaceHolder: "smartEditor",
	    sSkinURI: "${pageContext.request.contextPath}/resources/smarteditor2-2.8.2.3/SmartEditor2Skin.html",
	    htParams: {
	    	//툴바 사용 여부(true: 사용 / false: 사용X)
	    	bUseToolbar : true,
	    	//입력창 크기 조절바 사용 여부(true: 사용 / false: 사용X)
	    	bUseVerticalResizer : false,  
	    	//모드 탭(Editor | HTML | TEXT => true: 사용 / false: 사용X)
	    	bUseModeChanger : false,
	    }
	});

	//전송버튼 클릭 이벤트
	$("#savebutton").click(function() {
		
		if (document.getElementById("category").value == "") {
			alert("작성하려는 글의 게시판을 선택하십시오");
			return;
		}else if (document.getElementById("id").value == "") {
			alert("작성하시는 글의 제목을 입력해주십시오");
			return;
		}
		
		//id가 smarteditor인 textarea에 에디터에서 대입
		editor_object.getById["smartEditor"].exec("UPDATE_CONTENTS_FIELD", []);
		$("#frm").submit();
	});
}); 
</script>
</head>
<body>
	<c:if test="${empty member_id}">
	 	<jsp:include page="include/navigation.jsp" />
 	</c:if>
 	<c:if test="${!empty member_id}">
	 	<jsp:include page="include/navigation.jsp?member_id=${member_id}" />
 	</c:if>
	
	<h3 id="h3" style="text-align: center;" >글쓰기</h3>
	
	<hr>
	
<form action="write.do" method="post" id="frm" class="container">
	
	<div class="form-group row">
	<label for="colFormLabel" class=" col-form-label">게시판 종류</label>
	<select name="board_category" id="category" class="form-control" autofocus required>	
		<option value="free">자유 게시판</option>
	</select>
	</div>
	
	<!-- <input type="hidden" name="board_subcategory" value=""> -->
	
<%-- 	서브 카테고리
	<select name="board_subcategory">	
		<option value="default" >준비중입니다.</option>
	</select> --%>
	
	<div class="form-group row">
		<label for="colFormLabel" class=" col-form-label">글쓴이</label>
		<input type="text" class="form-control" value="${member_id}" disabled>
		<input type="hidden" name="board_id" value="${member_id}">
	</div>
	

	<div class="form-group row">
		<label for="colFormLabel" class=" col-form-label">글 제목</label>
		<input type="text" id="id" class="form-control" name="board_title" required >
	</div>
	
	<div class="form-group row">
		<label for="colFormLabel" class="col-form-label">내용</label>
		<textarea name="board_content" id="smartEditor" rows="10" cols="100" style="width:800px; height:500px;"></textarea>
	</div>
	
	<!-- 
	<div class="form-group row">
		<label for="colFormLabel" class="col-form-label">파일첨부</label>
		<input type="file" class="form-control" name="board_file" style="width: 700px" >		
	</div>	 -->
	
	<div style="text-align: center; margin-top: 50px; ">
		<input type="submit" class="btn btn-primary" id="savebutton" value="완료" style="width: 200px;">
	</div>
	</form>
	
	<jsp:include page="include/footer.jsp" />
</body>
</html>