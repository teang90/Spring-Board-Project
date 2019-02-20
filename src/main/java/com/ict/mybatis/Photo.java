package com.ict.mybatis;

import org.springframework.web.multipart.MultipartFile;

public class Photo {
	
	//photo_uploader.html페이지의 form태그내에 존재하는 file 태그의 name명과 일치시켜줌
	private MultipartFile filedate ;

	 //callback URL
	private String callback;
	
	//콜백함수
	private String callback_func;

	public MultipartFile getFiledate() {
		return filedate;
	}

	public void setFiledate(MultipartFile filedate) {
		this.filedate = filedate;
	}

	public String getCallback() {
		return callback;
	}

	public void setCallback(String callback) {
		this.callback = callback;
	}

	public String getCallback_func() {
		return callback_func;
	}

	public void setCallback_func(String callback_func) {
		this.callback_func = callback_func;
	}
	
	
}
