package com.ict.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.ict.mybatis.DAO;

//@RequestMapping("/ajax") //이거 때문인지는 모르겠는데 이거 빼고서 보내니까 됨
@RestController
public class AjaxController {
	@Autowired
	DAO dao;
	
	// 아이디 중복체크
	@ResponseBody
	@RequestMapping(value="idcheck.do", method=RequestMethod.POST)
	public int idCheck(@RequestBody String member_id) {
		return dao.getIdCheck(member_id);
	}
	
}
