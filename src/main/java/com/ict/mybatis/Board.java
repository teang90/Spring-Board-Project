package com.ict.mybatis;

public class Board {

	private String board_category, board_id, board_title, board_content, board_date;
	private int board_pk, board_hit, board_recommendation ; //3
	
	public String getBoard_category() {
		return board_category;
	}
	public void setBoard_category(String board_category) {
		this.board_category = board_category;
	}
	
	public String getBoard_id() {
		return board_id;
	}
	public void setBoard_id(String board_id) {
		this.board_id = board_id;
	}
	public String getBoard_title() {
		return board_title;
	}
	public void setBoard_title(String board_title) {
		this.board_title = board_title;
	}
	public String getBoard_content() {
		return board_content;
	}
	public void setBoard_content(String board_content) {
		this.board_content = board_content;
	}
	public String getBoard_date() {
		return board_date;
	}
	public void setBoard_date(String board_date) {
		this.board_date = board_date;
	}
	public int getBoard_pk() {
		return board_pk;
	}
	public void setBoard_pk(int board_pk) {
		this.board_pk = board_pk;
	}
	public int getBoard_hit() {
		return board_hit;
	}
	public void setBoard_hit(int board_hit) {
		this.board_hit = board_hit;
	}
	public int getBoard_recommendation() {
		return board_recommendation;
	}
	public void setBoard_recommendation(int board_recommendation) {
		this.board_recommendation = board_recommendation;
	}
	
}
