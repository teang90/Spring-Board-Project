package com.ict.controller;


import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.web.bind.annotation.Mapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.ModelAndView;

import com.ict.mybatis.Answer;
import com.ict.mybatis.Board;
import com.ict.mybatis.DAO;
import com.ict.mybatis.Member;
import com.ict.mybatis.Page;

@org.springframework.stereotype.Controller
public class Controller {
	@Autowired
	DAO dao;
	
	@Autowired
	Page pg;
	
	@RequestMapping("/")
	public ModelAndView getHome() {
		ModelAndView mv = new ModelAndView();
		List<Board> board_list = dao.getPopularList();
		
		mv.addObject("board_list", board_list);
		mv.setViewName("home");
		return mv;
	}
	
	// 아이디 있는 경우 다시 로그인 된 상태로 홈으로 이동
	@RequestMapping("reloadHome.do")
	public ModelAndView reloadHome(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView("home");
		mv.addObject("member_id", request.getParameter("member_id"));
		mv.setViewName("home");
		return mv;
	} 
	
	// 기상 게시판 이동
	@RequestMapping("weather.do")
	public ModelAndView movetoWeather() {
		ModelAndView mv = new ModelAndView("weather");
		List<Board> board_list = dao.getBoard_list("weather");
		mv.addObject("board_list", board_list);
		return mv;
	}
	
	// 음악 게시판 이동
	@RequestMapping("music.do")
	public String movetoMusic() {
		return "music";
	}
	
	// 자유 게시판 이동
	@RequestMapping("freedom.do")
	public String movetoFreedom() {
		return "freedom";
	}
	
	//로그인 페이지 이동
	@RequestMapping("login.do")
	public String loginPage() {
		return "login";
	}
	
	//로그인 동작 로직
	@RequestMapping(value="login_member.do", method=RequestMethod.POST)
	public ModelAndView getLogin(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		String member_id = request.getParameter("member_id");
		String member_pwd = request.getParameter("member_pwd");
		Member member = dao.getLogin(member_id, member_pwd);
		if (member != null) {
			mv.addObject("member_id", member.getMember_id());
			mv.setViewName("home");
		}else {
			mv.addObject("msg", "아이디와 비밀번호가 틀렸습니다.");
			mv.setViewName("redirect:/login.do");
		}
		return mv;
	}
	
	//로그아웃
	@RequestMapping("logout.do")
	public ModelAndView logOut(HttpSession session) {
		ModelAndView mv = new ModelAndView();
		session.invalidate();
		mv.setViewName("redirect:/");
		return mv;
	}
	
	//회원가입
	@RequestMapping("signin.do")
	public String signin() {
		return "signin";
	}
	
	//회원가입 디비 처리
	@RequestMapping(value="signin_member.do", method=RequestMethod.POST)
	public ModelAndView getSignin(Member member) {
		ModelAndView mv = new ModelAndView();
		int res = dao.getSignin(member);
		if (res > 0) {
			mv.setViewName("home");
			mv.addObject("member_id", member.getMember_id());
		}else {
			mv.addObject("msg", "회원가입에 실패했습니다. 재가입 부탁드립니다.");
			mv.setViewName("signin");
		}
		return mv;
	}
	
	// 답글 수정
	
	
	
	
	// 답글 삭제
	
	
	
	// 아이디 찾기
	
	
	
	// 비밀번호 찾기
	
	

	//게시글 상세보기
	@RequestMapping("oneBoard.do")
	public ModelAndView oneboard(String board_pk) {
		ModelAndView mv = new ModelAndView();
		Board board = dao.getOneboard(board_pk);
		dao.getHitUp(board.getBoard_hit(), board_pk);
		List<Answer> answer_list = dao.getAnswerList(board_pk);
		mv.addObject("board", board);
		mv.addObject("answer_list", answer_list);
		mv.setViewName("oneBoard");
		return mv;
	}
	
	//게시글 수정 페이지 이동하기
	@RequestMapping("modify.do")
	public String modify() {
		return "oneBoard_modify";
	}

	//게시글에 답글 달기
	@RequestMapping(value="makeAnswer.do", method=RequestMethod.POST)
	public ModelAndView makeAnswer(HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
		Answer answer = new Answer();
		String answer_bd_pk = request.getParameter("answer_bd_pk");
		answer.setAnswer_content(request.getParameter("answer_content"));
		answer.setAnswer_id(request.getParameter("answer_id"));
		answer.setAnswer_bd_pk(Integer.parseInt(answer_bd_pk));
		int res = dao.getMakeAnswer(answer);
		mv.setViewName("redirect:/oneBoard.do?board_pk="+answer_bd_pk);		
		return mv;
	}
	
	//답글의 답글 달기
	@RequestMapping(value="addAnswer.do", method=RequestMethod.POST)
	public ModelAndView addAnswer(Answer answer, HttpServletRequest request) {
		ModelAndView mv= new ModelAndView();
		/*
		Answer answer = new Answer();
		answer.setAnswer_content(request.getParameter("answer_content"));
		answer.setAnswer_bd_pk(Integer.parseInt(request.getParameter("answer_pk")));
		*/
		answer.setAnswer_recommendation(0);
		int res = dao.getMakeAnswers_answer(answer);
		mv.setViewName("redirect:/oneBoard.do?board_pk="+answer.getAnswer_bd_pk());
		
		// 추가적으로 answer의 모든 자료 받아서 엔서에 넣기 
		return mv;
	}
	//글쓰기 게시판으로 이동
	@RequestMapping("go_makingBoard.do")
	public String go_makingBoard(){
		return "makeBoard";
	}
	
	@RequestMapping("write.do")
	public ModelAndView write(Board board) {
		ModelAndView mv = new ModelAndView();
		int res = dao.getWrite(board);
		// 들어온 카테고리 정보로 분류하여 이프문으로 글 작성 후 기상, 자유, 음악 게시판으로 보내야함
		if (res > 0) {
			if (board.getBoard_category().equals("weather")) {
				mv.setViewName("redirect:/weather.do");
			}else if (board.getBoard_category().equals("music")) {
				mv.setViewName("redirect:/music.do");
			}else if (board.getBoard_category().equals("freedom")) {
				mv.setViewName("redirect:/freedom.do");
			}
		}else {
			mv.setViewName("makeBoard");
		}
		return mv;
	}
	
	@RequestMapping("recommendationUp.do")
	public String recommendationUp(Answer answer) {/*, String recommendHistory*/
		/*if (Integer.parseInt(recommendHistory) > 0) {
			return "redirect:/oneBoard.do?board_pk="+answer.getAnswer_bd_pk();
		}*/
		dao.getRecommendation_Up(answer);
		return "redirect:/oneBoard.do?board_pk="+answer.getAnswer_bd_pk();
	}

	@RequestMapping("recommendationDown.do")
	public String recommendationDown(Answer answer) {/* String recommendHistory*/
		/*if (Integer.parseInt(recommendHistory) < 0) {
			return "redirect:/oneBoard.do?board_pk="+answer.getAnswer_bd_pk();
		}*/
		dao.getRecommendation_Down(answer);
		return "redirect:/oneBoard.do?board_pk="+answer.getAnswer_bd_pk();
	}
	
	/*
	http://hellogk.tistory.com/108
	사진 안뜸... 글구 clob이랑 뭐 암튼... 스트링이랑 clob 좀 찝찝함... 
 	http://hellogk.tistory.com/108 [IT Code Storage] */
	
	@RequestMapping("/multipartPhotoUpload")
	public void fileMultiUpload(HttpServletRequest request, HttpServletResponse response) {
		try {
			// 파일정보
			String sFileInfo = "";
			// 파일명을 받는다 - 일반 원본파일명
			String filename = request.getHeader("file-name");
			// 파일 확장자
			String filename_ext = filename.substring(filename.lastIndexOf(".") + 1);
			// 확장자를소문자로 변경
			filename_ext = filename_ext.toLowerCase();
			// 파일 기본경로
			String dftFilePath = request.getSession().getServletContext().getRealPath("/");
			// 파일 기본경로 _ 상세경로, 페이지에 붙이기 전에 파일경로라고 생각하면.. 될듯...
			String filePath = dftFilePath +"resources/smarteditor2-2.8.2.3"+ File.separator + "upload" + File.separator;			
			File file = new File(filePath);
			if (!file.exists()) {
				file.mkdirs();
			}
			String realFileNm = "";
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			String today = formatter.format(new java.util.Date());
			realFileNm = today + UUID.randomUUID().toString() + filename.substring(filename.lastIndexOf("."));
			String rlFileNm = filePath + realFileNm;
			///////////////// 서버에 파일쓰기 /////////////////
			InputStream is = request.getInputStream();
			OutputStream os = new FileOutputStream(rlFileNm);
			int numRead;
			byte b[] = new byte[Integer.parseInt(request.getHeader("file-size"))];
			while ((numRead = is.read(b, 0, b.length)) != -1) {
				os.write(b, 0, numRead);
			}
			if (is != null) {
				is.close();
			}
			os.flush();
			os.close();
			///////////////// 서버에 파일쓰기 /////////////////
			// 정보 출력
			sFileInfo += "&bNewLine=true";
			// img 태그의 title 속성을 원본파일명으로 적용시켜주기 위함
			sFileInfo += "&sFileName=" + filename;
			sFileInfo += "&sFileURL=" + "../../resources/smarteditor2-2.8.2.3/upload/"+realFileNm; //페이지에 이미지 붙이는 진짜 붙는 src주소
			PrintWriter print = response.getWriter();
			print.print(sFileInfo);
			print.flush();
			print.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	
}
