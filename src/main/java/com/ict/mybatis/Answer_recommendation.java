package com.ict.mybatis;

public class Answer_recommendation {
	private String member_id ;
	
	private int answer_rec_pk, board_pk, answer_pk, recommendation_standard;
	
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public int getAnswer_rec_pk() {
		return answer_rec_pk;
	}
	public void setAnswer_rec_pk(int answer_rec_pk) {
		this.answer_rec_pk = answer_rec_pk;
	}
	public int getBoard_pk() {
		return board_pk;
	}
	public void setBoard_pk(int board_pk) {
		this.board_pk = board_pk;
	}
	public int getAnswer_pk() {
		return answer_pk;
	}
	public void setAnswer_pk(int answer_pk) {
		this.answer_pk = answer_pk;
	}
	public int getRecommendation_standard() {
		return recommendation_standard;
	}
	public void setRecommendation_standard(int recommendation_standard) {
		this.recommendation_standard = recommendation_standard;
	}
	
	
}
