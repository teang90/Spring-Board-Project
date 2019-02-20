package com.ict.mybatis;

public class Board_recommendation {
	
	private String board_id, board_pk, member_id ;
	
	private int recommendation_pk, recommendation_standard, board_recommendation;

	public String getBoard_id() {
		return board_id;
	}

	public void setBoard_id(String board_id) {
		this.board_id = board_id;
	}

	public String getBoard_pk() {
		return board_pk;
	}

	public void setBoard_pk(String board_pk) {
		this.board_pk = board_pk;
	}

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public int getRecommendation_pk() {
		return recommendation_pk;
	}

	public void setRecommendation_pk(int recommendation_pk) {
		this.recommendation_pk = recommendation_pk;
	}

	public int getRecommendation_standard() {
		return recommendation_standard;
	}

	public void setRecommendation_standard(int recommendation_standard) {
		this.recommendation_standard = recommendation_standard;
	}

	public int getBoard_recommendation() {
		return board_recommendation;
	}

	public void setBoard_recommendation(int board_recommendation) {
		this.board_recommendation = board_recommendation;
	}

	
}
