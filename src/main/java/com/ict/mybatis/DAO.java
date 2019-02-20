package com.ict.mybatis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.util.SystemPropertyUtils;

@Repository("dao")
public class DAO {
	
	@Autowired
	SqlSessionTemplate template ;

	// 회원가입
	public int getSignin(Member member) {
		return template.insert("member_add", member);
	}

	public Member getLogin(String member_id, String member_pwd) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("member_id", member_id);
		map.put("member_pwd", member_pwd);
		return template.selectOne("member_login", map);
	}
	
	public int getWrite(Board board) {
		return template.insert("board_insert", board);
	}
	
	// 게시글 목록 불러오기
	public List<Board> getBoard_list(int begin, int end, String board_category) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("begin", String.valueOf(begin));
		map.put("end", String.valueOf(end));
		map.put("board_category", board_category);
		return template.selectList("board_list", map);
	}
	
	// 게시글 상세보기(기본키로 게시글 객체 반환)
	public Board getOneboard(String board_pk) {
		return template.selectOne("oneboard", board_pk);
	}
	
	// 답글 달기
	public int getMakeAnswer(Answer answer) {
		return template.insert("answer_insert", answer);
	}

	//조회수 증가
	public int getHitUp(int board_hit, String board_pk) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put("board_hit", board_hit);
		map.put("board_pk", Integer.parseInt(board_pk));
		return template.update("oneboard_hitup", map);
	}

	public List<Answer> getAnswerList(String board_pk) {
		return template.selectList("answer_list", board_pk);
	}
	
	//답글의 답글 달기
	public int getMakeAnswers_answer(Answer answer) {
		return template.insert("answer_insert_insert", answer);
	}
	
	//답글 추천
	public void getRecommendation_Up(Answer answer) {
		template.update("answer_recUp", answer);
	}

	//답글 반대
	public void getRecommendation_Down(Answer answer) {
		template.update("answer_recDown", answer);
	}

	//아이디 중복체크
	public int getIdCheck(String member_id) {
		List<Member> member_list = template.selectList("idcheck", member_id);
		return member_list.size();
	}
	
	// 기본 키로 그에 해당하는 답글 객체 반환
	public Answer getReturnAnswer(String answer_pk) {
		return template.selectOne("returnAnswer", answer_pk);
	}
	
	// 게시글의 기본키로 그에 해당하는 답글 리스트 출력
	public List<Answer> getReturnAnswerList(int answer_bd_pk) {
		return template.selectList("returnAnswerList", answer_bd_pk);
	}

		
	//답글 내용 수정하기
	public int getAnswerModify(Answer answer) {
		return template.update("answer_content_modify", answer) ;
	}
	
	//게시글 내용 수정
	public int getBoardModify(Board board) {
		return template.update("board_modify", board);
	}
	
	// 게시글 삭제
	public int getDeleteBoard(String board_pk) {
		return template.delete("board_delete", board_pk);
	}
	
	// 특정 게시판의 게시글 호출
	public int getCountRecord(String category) {
		return template.selectOne("board_totalRecord", category);
	}

	public List<Board> getBoardSearch(String keyword, String legend) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("legend", legend);
		map.put("keyword", keyword);
		return template.selectList("SearchForBoard", map);
	}

	// 게시글 추천 수 +1(or -1)
	public int getBoardRecommendUp(Board board, int recommendation_standard, String member_id) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("board_pk", String.valueOf(board.getBoard_pk()));
		map.put("board_recommendation", String.valueOf(board.getBoard_recommendation()));
		map.put("recommendation_standard", String.valueOf(recommendation_standard));
		map.put("member_id", member_id);
		int res1 = -1 ;
		int res2 = 0 ;
		if (recommendation_standard > 0) {
			res1 = template.update("board_recUp", map);
			res2 = template.update("Recommendation_standard_modify", map);
		}else if (recommendation_standard < 0) {
			res1 = template.update("board_recDown", map);
			res2 = template.update("Recommendation_standard_modify", map);
		}
		return res1;
	}

	// 추천 객체가 없다면 추천 객체 생성
	public void getInsertBoard_recommend(Board_recommendation b_recommend) {
		template.insert("InsertboardRec", b_recommend);
	}

	// 본 글 추천위한 객체 추천객체 조회
	public Board_recommendation getReturnBoard_recommend(String board_pk, String member_id){
		Map<String, String> map = new HashMap<String, String>();
		map.put("board_pk", board_pk);
		map.put("member_id", member_id);
		return template.selectOne("findBoard_recommend", map);
	}
	
	// 답글 기본키와 멤버 아이디를 통해서 답글 추천 객체 조회
	public Answer_recommendation getReturnAnswerObj(String answer_pk, String member_id) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("answer_pk", answer_pk);
		map.put("member_id", member_id);
		return template.selectOne("findAnser_recommend", map);
	}
	
	// 답글 추천 객체 생성
	public int getMakeAnswer_recommendation(Answer_recommendation answer_rec2){
		return template.insert("answer_recObj", answer_rec2);
	}
	
	// answer 객체 추천 수 UP
	public int getAnswer_Recommendation_Up(Answer answer) {
		return template.update("answer_rec_up", answer);
	}

	// answer 객체 추천 수 DOWN
	public int getAnswer_Recommendation_Down(Answer answer) {
		return template.update("answer_rec_down", answer);
	}
	
	public int getRecommendation_standardModify(String answer_pk, String member_id, String recommendation_standard) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("answer_pk", answer_pk);
		map.put("member_id", member_id);
		map.put("recommendation_standard", recommendation_standard);
		return template.update("Answer_recommendation_standardUpDown", map);
	}
	
	public Answer_recommendation getReturnAnswer_recommendation_standard(String member_id, String answer_pk) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("member_id", member_id);
		map.put("answer_pk", answer_pk);
		return template.selectOne("returnAnswer_Recommendation_standard", map);
	}

	// 회원 기본키로 가입한 회원인지 찾기
	public Member getReturnMember(String member_pk) {
		return template.selectOne("findMemberObjWithPrimaryKey", member_pk);
	}

	
	// 게시글의 댓글 삭제하기
	public int getDeleteAnswer(String answer_pk) {
		return template.delete("delete_answer", answer_pk);
	}


	
	
	
	
}
