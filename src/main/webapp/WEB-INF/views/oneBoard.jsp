<%@page import="com.ict.mybatis.DAO"%>
<%@page import="com.ict.mybatis.Answer_recommendation"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
body {
	background-color: #eee;
}
form {
	margin-bottom: 5%;
}
#h3 {
	margin-top: 100px;
	margin-bottom: 25px;
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

#boardRecommendation{
	border-radius:50%;
	background-color: #dedede;
	width: 40px;
	height: 40px; 
} 
#innerShape{
	margin-left: 13px;
	margin-top: 4px;
	font-size: 20px;
	font-weight: bold;
	color: red;
}
</style>
<script type="text/javascript">

	// 에이작스에서 recommendation_standard만 받아오는 함수 만들기
	// var answer_result = 0 ;
	var result = 0;
	var answer_result = function(answer_pk){
		$.ajax({
			url: "returnAnswer_rec_strd.do",
			data:{
				"member_id" : '${member_id}',
				"answer_pk" : answer_pk
			},
			type: "post",
			async: false,
			success: function(Answer_Recommendation_standard) {
				result = Answer_Recommendation_standard;		
			},
			error : function(error) {
				alert("추천/반대 실패 : "+error);
			}
		});
		return result;
	}; 
			
			
	// 왜 댓글 작성한 이후 최초의 추천 혹은 반대를 클리하면 success로 떨어지지 않고 error로 떨어질까?
	// 그리고 DAO랑 mapper에서 answer_recommendation 객체의 recommendation_standard 수정하기 안만들었음...
	function recommendationUp(oneanswer) {
		
		var answer_pk = oneanswer.answer_pk.value;
		var recommendation_standard = 1 ;
		if ('${member_id}' == null || '${member_id}'=="" ) {
			alert("로그인이 필요합니다.");
			return ;
		}
		if (answer_result(answer_pk) == '1') {
			alert("이미 추천하신 댓글입니다.");
			return;
		}
		recommendationUpNDown_ajax(recommendation_standard, answer_pk);
	}
	
	function recommendationDown(oneanswer) {
		var answer_pk = oneanswer.answer_pk.value;
		var recommendation_standard = -1 ;
		if ('${member_id}' == null || '${member_id}'=="" ) {
			alert("로그인이 필요합니다.");
			return ;
		}
		if (answer_result(answer_pk) == '-1') {
			alert("이미 반대하신 댓글입니다.");
			return ;
		}
		recommendationUpNDown_ajax(recommendation_standard, answer_pk);
	}
	
	function recommendationUpNDown_ajax(recommendation_standard, answer_pk) {
		console.log("recommendation_standard = "+recommendation_standard+" / answer_pk = "+answer_pk);
		
		$.ajax({
			url:"AnswerRecommendUpDown.do",
			data: {   
				"member_id":'${member_id}',
				"answer_pk": answer_pk,
				"board_pk" :'${board.board_pk}',
				"recommendation_standard":recommendation_standard
			},
			dataType: "json",
			async: false,  // 성공으로 안와서 동기식으로...
			type: "post",
			success: function(data) { //왜 성공으로 안오지?
				alert();
				// $(".answer_recommend")[index-2].text(data["answer_recommendation"]);
				// $(".answer_recommend")[index-2].text(data);
			},
			error: function(request, status, error) {
			}
		});
	}
	
	//댓글 달기
	function addOneAnswer(oneanswer) {
		oneanswer.action="addAnswer.do?cPage=${cPage}";
		oneanswer.submit();		
	}
	
	// 대댓 달기
	function addOne_s_Answer(oneanswer) {
		//form 안에 under_answer라는 class선택자를 가진 div태그를 호출하는게 안되서 엄청 비효율적인 코드를 만들었음... 수정필
		var answer_textarea = document.getElementsByClassName("under_answer");
		
		var index = $("form").index(oneanswer); // 전체 form태그 내에서 클릭한 해당 태그의 인덱스
		
		var answer_group = oneanswer.answer_group.value;
		// var answer_group = $("input[name='answer_group']").eq(index-2).attr("value"); 
		// ===>>> 대댓글의 input태그 내의 hidden태그의 대댓글 정보 때문에  이 정보가(input hidden의 순서가 달라짐) 달라짐
		
		answer_textarea[index-2].innerHTML =
		"<br><div class='control innerdiv'><form method='post' name='oneanswer' class='oneanswer'>"
		+"<input type='text' name='answer_id' value='${member_id}' class='form-control' readonly>"
		+"<textarea rows='4' cols='70' name='answer_content' style='resize: none' class='form-control'></textarea>"
		+"<input type='hidden' name='answer_bd_pk' value='${board.board_pk}'>"
		+"<input type='hidden' name='answer_group' value=" + answer_group + ">"
		+"<input type='button' class='btn btn-primary btn-sm' value='등록' onclick='addOneAnswer(this.form)' >"+"&nbsp;"
		+"<input type='button' class='btn btn-primary btn-sm' value='취소' onclick='javascript:goback()'>"
		+"</form></div>";
	}
	
	// 새로고침
	function goback() {
		history.go(0);
	}
	
	// 답글 수정 기능구현
	function modifyOneAnswer(oneanswer) {
		var index = $("form").index(oneanswer);
		var answer_content = $(".answer_content");
		
		answer_content[index-2].innerHTML = 
		"<br><form method='post' class='oneanswer' name='oneanswer'>"
		+"<textarea rows='4' cols='70' name='answer_content' style='resize: none' class='form-control'>"
		+ answer_content[index-2].innerHTML +"</textarea>"
		+"<input type='button' value='완료' onclick='modifyAjax(this.form)' class='btn btn-primary btn-sm'>"+"&nbsp;"
		+"<input type='button' class='btn btn-primary btn-sm' value='취소' onclick='javascript:goback()'>"
		+"</form>"; // 답글 수정 누르면ajax로 
	}	
	
	//답글 수정 정보 컨트롤러로 전송 및 처리(DB처리)
	function modifyAjax(oneanswer) {
		var index =  $("form").index(oneanswer);
		var answer_bd_pk_mod = document.getElementsByName("answer_bd_pk");
 
	 	$.ajax({
			url: "answerModify.do",
			data : {
				"answer_pk" : oneanswer.answer_pk.value,
				"answer_bd_pk" : answer_bd_pk_mod[index-2].value,
				"answer_content" : oneanswer.answer_content.value
			},
			dataType: "json",
			type: "post",
			success: function(data) {
				alert("댓글이 수정되었습니다.");
				$(".answer_content").eq(index-2).text(oneanswer.answer_content.value);
			},
			error: function() {
				alert("오류");
			}
		});  
	}
	
	// 답글 삭제
	function deleteOneAnswer(f) {
		// 답글 작성자만 삭제할 수 있게 만들어야함 삭제하면 [삭제된 댓글입니다.]로 메시지 수정
		var remove_answer = confirm("정말 삭제하시겠습니까?");
		if (!remove_answer) return;
		var index = $("form").index(f);
		// console.log("answer_pk (document.getElement...)= "+answer_pk[index-2].value); input태그 hidden값을 추가해서 순서바뀌어서 다른 값 뜸
		console.log("answer_pk f method= "+f.answer_pk.value);

		// ajax로 db로 넘기기
		delete_answer(f.answer_pk.value);
	}
	
	//답글 삭제 에이잭스
	function delete_answer(answer_pk_value){
		$.ajax({
			url: "answerDelete.do",
			data : {
				"answer_pk" : answer_pk_value
			},
			dataType: "json",
			type: "post",
			success: function(data) {
				alert("댓글 내용이 삭제되었습니다.");
				goback();
			},
			error: function(error) {
				//alert("오류"+error);
			}
		}); 
	}
	
	// 대댓 수정, 삭제, 추천, 반대 부분
	$(document).ready(function() {
		
		$(document).on("click", "button[name='answerOfanswerSave']", function() {
			console.log("현재 택스트 에어리어 = "+$("textarea[name='answerofans_content']").val());
			
			/* 			
			console.log("index1 = "+ $(this).text()); //택스트 에어리어의 완료버튼
			console.log("index3 = "+ $(this).parent().index()); //  5
			console.log("index4 = "+ $(this).parent().parent().text().trim()); // 부모 글 내용 가져오기 중요
			console.log("div.innerdiv1 = "+ $("div.innerdiv > div.innerdiv").index()); // 5
			console.log("div.innerdiv4 = "+ $("div.innerdiv").parent().index()); // 2
			*/			 
			// console.log("answer_pk = "+$(this).parent().next().val()); //  답글의 기본키 \ 186 (textarea 위치에서 다음것 노드 번호 4와5사이에 택스트에어리어 있음)
 			//console.log($(this).parent().siblings()); 
			
			$.ajax({
				url: "answerModify.do",
				data : {
					"answer_pk" : $(this).parent().next().val(),
					"answer_bd_pk":$(this).parent().next().next().val(),
					"answer_content" : $("textarea[name='answerofans_content']").val()
				},
				dataType: "json",
				type: "post",
				success: function(data) {
					alert("댓글이 수정되었습니다.");
					goback(); 
					// div.innerdiv div.innerdiv 위치를 못 찾아서 결국 페이지 새로고침의 방식...
					// $("div.innerdiv div.innerdiv").eq(index_site).html($("textarea[name='answerofans_content']").val());
					// $("textarea[name='answerofans_content']").val($("textarea[name='answerofans_content']").val());
				},
				error: function() {
					alert("오류");
				}
			});  
		} );
		
		// 대댓 수정
		$(document).on("click","button[name='Modfanswerofanswer']", function() {
			var answer_content = $(this).next().next().next().next().next().html();
			//console.log($(this).siblings());
	
			answer_content = $(this).next().next().next().next().next().html(
					"<textarea rows='4' cols='70' name='answerofans_content' style='resize: none' class='form-control'>"
					+ answer_content +"</textarea>"
					+"<button class='btn btn-primary btn-sm' name='answerOfanswerSave'>완료</button>"
					+"<button class='btn btn-primary btn-sm' onclick='javascript:goback()'>취소</button>");
			//console.log("댓글 수정 내용"+ answer_content );
		} );
		
		// 대댓 삭제
		$(document).on("click","button[name='Deleteanswerofanswer']", function() {
			var answer_pk = $(this).next().next().next().next().next().val();
			console.log("answer_pk = "+answer_pk);
			delete_answer(answer_pk);
		});
		
		// 대댓 추천
		$(document).on("click", "button[name='recUp_AnswerOfAns']", function() {
			var answer_pk = $(this).next().next().next().next().val();
			var recommendation_standard = 1;
			if (answer_result(answer_pk) == '1') {
				alert("이미 추천하신 댓글입니다.");
				return;
			}
			recommendationUpNDown_ajax(recommendation_standard, answer_pk);
		});
		
		// 대댓 반대
		$(document).on("click", "button[name='recDown_AnswerOfAns']", function() {
			var answer_pk = $(this).next().next().next().val();
			var recommendation_standard = -1;
			if (answer_result(answer_pk) == '-1') {
				alert("이미 반대하신 댓글입니다.");
				return;
			}
			recommendationUpNDown_ajax(recommendation_standard, answer_pk);
		});
		
	});
	
	//본글 삭제
	function deleteBoard(f) {
		var check_confirm = confirm("본 게시글을 삭제하시겠습니까?");
		if (check_confirm) {
			f.action="deleteBoard.do";
			f.submit();
		}
		return ;
	}
	
	
	function notiAlert() {
		alert("작성자만 가능합니다.");
	}
	
	function mustLogin() {
			var cfrm_login = confirm("로그인이 필요합니다. \n로그인하시겠습니까?");
			if (cfrm_login) location.href="login.do";
	}
	
	// 추천/반대하기 전에 현재 회원이 이전에 본글을 추천한 이력을 알아보가 위해서 
	// 추천 전에 에이작스로 Board의 Recommendation_standard 받음
	var getBoard_recommendation_standard = function() {
		
		$.ajax({
			url:"returnBoardRecommendation.do",
			type: "post",
			dataType:"json",
			data: {
				"board_pk" : '${board.board_pk}',
				"member_id" : '${member_id}'
			},
			async: false,
			success: function(board_recommendation_standard) {
				result = board_recommendation_standard;
			},
			error: function(error) {
				alert("실패");
			}
		});
		return result ;
	}
	
	
 	// 본 글 추천
	function boardRecommendUp(f) {
		var confirm_recommend = confirm("해당 게시글을 추천하시겠습니까?");
		if (confirm_recommend) {
			
			if (getBoard_recommendation_standard() == '1') {
				alert("이미 추천하신 게시글입니다.");
				return ;
			}
			
			// 실제 DB에서 추천 기준 수를 비교하여 추천하는 역할파트
			$.ajax({
				url: "BoardRecommendationUpDown.do",
				data: {
					"recommendation_standard" : 1,
					"board_recommendation" : '${board.board_recommendation}',
					"board_pk" : '${board.board_pk}',
					"member_id" : '${member_id}'
				},
				type: "post",
				dataType: "json",
				async: false,
				success: function(data){
					alert("해당 글을 추천하셨습니다.");
					$("#innerShape").text(data["board_recommendation"]);
				},
				error: function() {
					goback();
				}
			});
				return ;
			}
	}
			
	
	// 본 글 반대
	function boardRecommendDown(f){
		var confirm_recommend = confirm("해당 게시글을 반대하시겠습니까?");
		if (confirm_recommend) {

			if (getBoard_recommendation_standard() == '-1') {
				alert("이미 반대하신 게시글입니다.");
				return ;
			}
			
			// 실제 DB에서 추천 기준 수를 비교하여 추천하는 역할파트
			$.ajax({
				url: "BoardRecommendationUpDown.do",
				data: {
					"recommendation_standard" : -1,
					"board_recommendation" : '${board.board_recommendation}',
					"board_pk" : '${board.board_pk}',
					"member_id" : '${member_id}'
				},
				type: "post",
				dataType: "json",
				async: false,
				success: function(data) { //성공으로 안옴...
					$("#innerShape").text(data["board_recommendation"]);
					alert("해당 글을 반대하셨습니다.");
				},
				error: function(error) {
					goback(); //성공으로 안가고 실패(디비에는 저장됐지만)로 올경우... 대비
					//$("#innerShape").text('${board.board_recommendation}');
				}
			});
		return ;
		}
	}
	
	// 목록버튼 클릭시 전체 게시물로 이동
	function moveBoard(f) {
		// alert('${cPage}');
		f.action="free.do";
		f.submit();
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

	<h3 id="h3" style="text-align: center;">당신의 의견을 말해주세요</h3>
	<form action="modify.do" method="post" id="frm" class="container"> 
		<hr>
		[${board.board_category}]&nbsp;&nbsp;<b>${board.board_title}</b>(${board.board_hit})<br>
		<br>${board.board_id}&nbsp;&nbsp;|&nbsp;&nbsp;${board.board_date}

		<hr>
		<div id="board_content">
		${board.board_content}
		</div>
		<hr>

		<div class="form-group row container">
			<c:if test="${board.board_id == member_id}">
				<input type="button" class="btn btn-outline-secondary" value="목록" onclick="moveBoard(this.form)"> &nbsp;&nbsp;&nbsp;
				<input type="submit" class="btn btn-success" value="수정" > &nbsp;&nbsp;&nbsp;
				<input type="button" class="btn btn-danger" value="삭제" onclick="deleteBoard(this.form)">&nbsp;&nbsp;&nbsp;
				<input type="button" class="btn btn-outline-primary" value="추천" onclick="boardRecommendUp(this.form)">   &nbsp;&nbsp;&nbsp;
				<input type="button" class="btn btn-outline-danger" value="반대" onclick="boardRecommendDown(this.form)"> &nbsp;&nbsp;&nbsp; 
				
				<input type="hidden" name="board_pk" value="${board.board_pk}">
				<input type="hidden" name="member_id" value="${member_id}" id="member_id">
			</c:if>
			<c:if test="${board.board_id != member_id && !empty member_id}">
				<input type="button" class="btn btn-outline-secondary" value="목록" onclick="moveBoard(this.form)"> &nbsp;&nbsp;&nbsp;
				<input type="button" class="btn btn-success" value="수정" onclick="notiAlert()"> &nbsp;&nbsp;&nbsp;
				<input type="button" class="btn btn-danger" value="삭제" onclick="notiAlert()" > &nbsp;&nbsp;&nbsp;
				<input type="button" class="btn btn-outline-primary" value="추천" onclick="boardRecommendUp(this.form)">  &nbsp;&nbsp;&nbsp;
				<input type="button" class="btn btn-outline-danger" value="반대" onclick="boardRecommendDown(this.form)">&nbsp;&nbsp;&nbsp; 
			
				<input type="hidden" name="board_pk" value="${board.board_pk}">
				<input type="hidden" name="member_id" value="${member_id}">
			</c:if>
			<c:if test="${empty member_id}">
				<input type="button" class="btn btn-outline-secondary" value="목록" onclick="moveBoard(this.form)"> &nbsp;&nbsp;&nbsp;
				<input type="button" class="btn btn-primary" value="수정" onclick="mustLogin()"> 
				<input type="button" class="btn btn-primary" value="삭제" onclick="mustLogin()">
			</c:if>
			
			<input type="hidden" name="cPage" value="${cPage}">
			<div id="boardRecommendation"><div id="innerShape">${board.board_recommendation}</div></div>&nbsp;&nbsp;&nbsp;
		</div>
	</form>
	
	
	<%-- //////////////////////////게시글에 답글 달기/////////////////////////// --%>
	<form action="makeAnswer.do" method="post">
		<div class="container">
		<c:if test="${empty member_id}">
			<input type="text" class="form-control" placeholder="답글을 달려면 로그인해주세요" readonly="readonly">
		</c:if>
		<c:if test="${!empty member_id}">
			<input type="text" name="answer_id" value="${member_id}" class="form-control" readonly="readonly">
			<textarea rows="4" cols="70" name="answer_content" style="resize: none" class="form-control"></textarea>
			<input type="hidden" name="answer_bd_pk" value="${board.board_pk}">
			<input type="hidden" name="cPage" value="${cPage}">
			<input type="submit" value="등록" class="btn btn-primary">
		</c:if>
		</div>
	</form>


	<div class="container">
		댓글 (${answer_list.size()}개)
	<hr class="line_answer">
	</div>

	<%-- //////////////////////////답글에 답글 달기/////////////////////////// --%>
	<div class="container">
	<c:forEach var="k" items="${answer_list}">
	<%-- <c:if test="${k.answer_lev == 0}"> --%>
	<%-- <c:choose test="">
	 --%>
	<c:if test="${k.answer_lev == 0}">
	
			<form method="post" name="oneanswer" class="oneanswer"> <!-- action="addAnswer.do" -->
				
				<div>${k.answer_id}(${k.answer_date})&nbsp;&nbsp;&nbsp;
				<input type="button" class="btn btn-primary btn-sm" value="답글달기" onclick="addOne_s_Answer(this.form)">
				<c:if test="${k.answer_id == member_id}">
					<input type="button" class="btn btn-success btn-sm" name="input_mdfy" value="수정" onclick="modifyOneAnswer(this.form)">
					<input type="button" class="btn btn-danger btn-sm" value="삭제" onclick="deleteOneAnswer(this.form)">
				</c:if>
				
				<!-- 추천, 반대 -->
				<button class="btn btn-outline-success btn-sm" name="recUp" onclick="recommendationUp(this.form)">추천</button>	
				<button class="btn btn-outline-danger btn-sm" name="recDown" onclick="recommendationDown(this.form)">반대</button>
				<span class="answer_recommend">(${k.answer_recommendation})</span>
				</div>
				
				<div class="answer_content">${k.answer_content}</div>
				
				<!-- 이거는 에이작스로 만들기, 버튼 클릭하면 에이작스로 내용띄우는 텍스트에어리어 뜨게만들기 -->
				<input type="hidden" name="answer_pk" value="${k.answer_pk}"> <!--  추천할 때 필요1  -->
				<input type="hidden" name="answer_group" class="answer_group" value="${k.answer_group}">
				<input type="hidden" name="answer_lev" value="${k.answer_lev}">
				<%-- <input type="hidden" name="answer_step" value="${k.answer_step}"> --%>
				<input type="hidden" name="answer_recommendation" value="${k.answer_recommendation}"> <!--  추천할 때 필요2  -->
				<input type="hidden" name="answer_bd_pk" value="${board.board_pk}">
			</form>
			
			<!-- 댓글의 댓글 작성 칸 -->
			<div class="under_answer"> </div>
			
			<!-- 댓글의 댓글 리스트 -->
			<c:forEach var="t" items="${answer_list}">
			<c:if test="${k.answer_group == t.answer_group && t.answer_lev > 0 }">
				
				<!-- form 태그 대체: 차피 댓글 보여주는 역할에 수정이나 삭제 누르면 위에서 textarea tag등으로 진행... -->
				<div class="oneanswer">
				
				<!-- for문 두번 돌려서 group이 같은 것들은 form태그 form태그 순으로 정렬할 수 있게 만들자 -->
				<div class="innerdiv">[Re] ${t.answer_id}&nbsp;&nbsp;(${t.answer_date})&nbsp;&nbsp;
					<c:if test="${t.answer_id == member_id}">
						<button class="btn btn-success btn-sm" name="Modfanswerofanswer">수정</button>
						<button  class="btn btn-danger btn-sm" name="Deleteanswerofanswer">삭제</button>&nbsp;
					</c:if>
					<button class="btn btn-outline-success btn-sm" name="recUp_AnswerOfAns">추천</button>	
					<button class="btn btn-outline-danger btn-sm" name="recDown_AnswerOfAns">반대</button>
					<span class="answer_recommend">(${t.answer_recommendation})</span>
					<div class="innerdiv">${t.answer_content}</div>
				<!-- 댓글의 댓글 리스트 추천 및 수정 등 필요한 요소 -->
				<input type="hidden" name="answer_pk" value="${t.answer_pk}"> <!--  추천할 때 필요1  -->
				<input type="hidden" name="answer_bd_pk" value="${board.board_pk}">
				<input type="hidden" name="answer_recommendation" value="${t.answer_recommendation}"> <!--  추천할 때 필요2  -->
				<input type="hidden" name="answer_group" value="${t.answer_group}">
				<input type="hidden" name="answer_lev" value="${t.answer_lev}">
				</div>
				</div>
			</c:if>
			
			</c:forEach>
	<hr class="each_line_answer">
	</c:if>
			
	</c:forEach>
	</div>

	<jsp:include page="include/footer.jsp" />
</body>
</html>