package com.ict.mybatis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("dao")
public class DAO {
	
	@Autowired
	SqlSessionTemplate template ;

	public List<Board> getPopularList() {
		return template.selectList("popular_list");
	}

	public int getSignin(Member mem) {
		return template.insert("member_add", mem);
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
	public List<Board> getBoard_list(String board_category) {
		return template.selectList("board_list", board_category);
	}
	
	// 게시글 상세보기
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
	
	
	
	
	
	
}
