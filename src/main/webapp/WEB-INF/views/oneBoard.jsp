<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Insert title here</title>
<link href="${pageContext.request.contextPath}/resources/bootstraps/template/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/smarteditor2-2.8.2.3/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-3.3.1.js"></script>
<style type="text/css">
body {
	background-color: #eee;
}

form {
	margin-bottom: 5%;
}

#h3 {
	margin-top: 5%;
	margin-bottom: 3%;
}

#savebutton {
	text-align: center;
}

.form-control, #smartEditor {
	background-color: #fff !important;
}

#title {
	font: 20px bolder;
}

.line_answer {
	border: 2px solid #007bff;
	margin-bottom: 20px;
}

.each_line_answer {
	border: 1px solid #f5f5f5;
}
.innerdiv{
	margin-left: 3%;
}
.innerHR{
	border: 1px solid #f5f5f5; 
}

</style>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-3.3.1.js"></script>
<script type="text/javascript">

	var recommendHistory ; //세션이나 쿠키에 저장해야하나?
	function recommendationUp(f) {
		if (recommendHistory >= 1) {
		alert("이미 추천하신 댓글입니다.");
			return ;
		}
		recommendHistory = 1;
		alert("해당 댓글을 추천하셨습니다.");
		f.action="recommendationUp.do";
		f.submit();
	}
	
	function recommendationDown(f) {
		if (recommendHistory <= -1) {
			alert("이미 반대하신 댓글입니다.");
			return ;
		}
		recommendHistory = -1 ;
		alert("해당 댓글에 반대하셨습니다.");
		f.action="recommendationDown.do";
		f.submit();		
	}

	function addOneAnswer(oneanswer) {
		//form 안에 under_answer라는 class선택자를 가진 div태그를 호출하는게 안되서 엄청 비효율적인 코드를 만들었음... 수정필
		
		var answer_textarea = document.getElementsByClassName("under_answer");
		var index = $("form").index(oneanswer); // 전체 form태그 내에서 클릭한 해당 태그의 인덱스
		
		// 왜 버튼 클릭한 위치의 인덱스보다 +2되어서 처리되는 거지?...일단 궁여지책으로 -2해줌... 맘에 안듬, 
		//  이유를 찾았음, 인덱스는 form안의 div의 인덱스라서 이미 인덱스가 내가 클릭한 index 즉 여기서 요소에 인덱스를 넣으면 +2하는거(찾은거에 또 +2된 값을 넣은효과)
		answer_textarea[index -2].innerHTML =
		"<br><div class='control innerdiv'><input type='text' name='answer_id' value='${member_id}' class='form-control' readonly>"
		+"<textarea rows='4' cols='70' name='answer_content' style='resize: none' class='form-control'></textarea>"
		+"<input type='hidden' name='answer_bd_pk' value='${board.board_pk}'>"
		+"<input type='submit' class='btn btn-primary' value='등록' onclick='addOneAnswer(this.form)'></div>";
	}
	
	
	// 답글 수정
	function modifyOneAnswer(oneanswer) {
		oneanswer.action="";
		oneanswer.submit();
	}
	
	
	// 답글 삭제
	function deleteOneAnswer() {
		oneanswer.action="";
		oneanswer.submit();
	}

	

	$(function() {
		var editor_object = [];
		nhn.husky.EZCreator
				.createInIFrame({
					oAppRef : editor_object,
					elPlaceHolder : "smartEditor",
					sSkinURI : "${pageContext.request.contextPath}/resources/smarteditor2-2.8.2.3/SmartEditor2Skin.html",
					htParams : {
						//툴바 사용 여부(true: 사용 / false: 사용X)
						bUseToolbar : true,
						//입력창 크기 조절바 사용 여부(true: 사용 / false: 사용X)
						bUseVerticalResizer : false,
						//모드 탭(Editor | HTML | TEXT => true: 사용 / false: 사용X)
						bUseModeChanger : false,
					}
				});
		//전송버튼 클릭 이벤트
		$("#savebutton").click(
				function() {
					if (document.getElementById("category").value == "") {
						alert("작성하려는 글의 게시판을 선택하십시오");
						return;
					} else if (document.getElementById("id").value == "") {
						alert("작성하시는 글의 제목을 입력해주십시오");
						return;
					}
					//id가 smarteditor인 textarea에 에디터에서 대입
					editor_object.getById["smartEditor"].exec(
							"UPDATE_CONTENTS_FIELD", []);
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

	<h3 id="h3" style="text-align: center;">당신의 의견을 말해주세요</h3>

	<form action="modify.do" method="post" id="frm" class="container">
		<hr>

		[${board.board_category}]&nbsp;&nbsp;<b>${board.board_title}</b>(${board.board_hit})
		<br>
		<br> ${member_id}&nbsp;&nbsp;|&nbsp;&nbsp;${board.board_date}

		<div class="form-group row">
			<label for="colFormLabel" class="col-form-label"></label>
		</div>

		<hr>
		${board.board_content}
		<hr>

		<div class="form-group row">
			<%-- 글쓴이만 수정할 수 있게만들자  --%>
			<c:if test="${board.board_id == member_id}">
				<input type="submit" class="btn btn-primary" value="수정" onclick="modify()">
				<input type="button" class="btn btn-primary" value="삭제" onclick="bd_delete()">
				<input type="hidden">
			</c:if>
		</div>
	</form>

	<%-- //////////////////////////게시글에 답글 달기/////////////////////////// --%>
	<form action="makeAnswer.do" method="post">
		<div class="container">
			<input type="text" name="answer_id" value="${member_id}" class="form-control" readonly="readonly">
			<textarea rows="4" cols="70" name="answer_content" style="resize: none" class="form-control"></textarea>
			<input type="hidden" name="answer_bd_pk" value="${board.board_pk}">
			<input type="submit" value="등록" class="btn btn-primary">
		</div>
	</form>

	<div class="container">
		댓글(${answer_list.size()}개)
	<hr class="line_answer">
	</div>

	<%-- //////////////////////////답글에 답글 달기/////////////////////////// --%>
	<div class="container">
	<c:forEach var="k" items="${answer_list}">
	<c:if test="${k.answer_lev == 0}">
			<form action="addAnswer.do" method="post" name="oneanswer" class="oneanswer">
				<div>${k.answer_id}(${k.answer_date})&nbsp;&nbsp;&nbsp;
				<input type="button" class="btn btn-primary btn-sm" value="답글달기" onclick="addOneAnswer(this.form)">
				<c:if test="${k.answer_id == member_id}">
					<input type="button" class="btn btn-success btn-sm" value="수정" onclick="modifyOneAnswer(this.form)">
					<input type="button" class="btn btn-danger btn-sm" value="삭제" onclick="deleteOneAnswer(this.form)">
				</c:if>
				<button class="btn btn-outline-success btn-sm" onclick="recommendationUp(this.form)">추천</button>	
				<button class="btn btn-outline-danger btn-sm" onclick="recommendationDown(this.form)">반대</button>
				(${k.answer_recommendation})	
				</div>
				<div>${k.answer_content}</div>
				<!-- 이거는 에이작스로 만들기, 버튼 클릭하면 에이작스로 내용띄우는 텍스트에어리어 뜨게만들기 -->
				<input type="hidden" name="answer_pk" value="${k.answer_pk}">
				<input type="hidden" name="answer_group" value="${k.answer_group}">
				<input type="hidden" name="answer_lev" value="${k.answer_lev}">
				<input type="hidden" name="answer_step" value="${k.answer_step}">
				<input type="hidden" name="answer_recommendation" value="${k.answer_recommendation}">
				<input type="hidden" name="answer_bd_pk" value="${board.board_pk}">
					<c:forEach var="t" items="${answer_list}">
						<c:if test="${t.answer_group == k.answer_group && t.answer_lev > 0}">
							<hr class="innerHR">	
							<div class="innerdiv">[Re] ${t.answer_id}(${t.answer_date})
								<input type="button" class="btn btn-primary btn-sm" value="답글달기" onclick="addOneAnswer(this.form)">
							</div>
							<div class="innerdiv">${t.answer_content}</div>
						</c:if>
					</c:forEach>
				<div class="under_answer"></div>
			</form>
			<hr class="each_line_answer">
	</c:if>
	</c:forEach>
	</div>

	<jsp:include page="include/footer.jsp" />
</body>
</html>