package com.ict.service;

import org.springframework.stereotype.Service;

@Service("pg")
public class Page {
	
	private int cPage ; //현재 페이지
	private int numPerPage ; // 페에지당 담을 게시물의 수
	private int pagePerBlock ; // 블럭당 담을 페이지의 수
	private int totalRecord ; // 전체 게시물
	private int totalPage ; // 총 페이지 개수
	private int beginPage ; // 시작 페이지
	private int endPage ;   // 끝 페이지

	public int getcPage() {
		return cPage;
	}
	public void setcPage(int cPage) {
		this.cPage = cPage;
	}
	public int getNumPerPage() {
		return numPerPage;
	}
	public void setNumPerPage(int numPerPage) {
		this.numPerPage = numPerPage;
	}

	public int getPagePerBlock() {
		return pagePerBlock;
	}
	public void setPagePerBlock(int pagePerBlock) {
		this.pagePerBlock = pagePerBlock;
	}
	public int getTotalRecord() {
		return totalRecord;
	}
	public void setTotalRecord(int totalRecord) {
		this.totalRecord = totalRecord;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getBeginPage() {
		return beginPage;
	}
	public void setBeginPage(int beginPage) {
		this.beginPage = beginPage;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
	
}
