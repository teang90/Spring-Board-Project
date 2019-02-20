package com.ict.controller;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.ict.mybatis.Answer;
import com.ict.mybatis.Board;
import com.ict.mybatis.DAO;
import com.ict.service.FunctionCollection;
import com.ict.mybatis.Member;
import com.ict.service.Page;

@org.springframework.stereotype.Controller
public class Controller {
	
	@Autowired
	DAO dao;
	
	@Autowired
	Page pg;
	
	@Autowired
	FunctionCollection funcCollection;
	
	@RequestMapping("/")
	public ModelAndView getHome() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("home");
		return mv;
	}
	
	@RequestMapping("getNaverToken.do")
	public ModelAndView getCallback(HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
			
		String tokenResult = funcCollection.getProfileInformation(funcCollection.returnNaverAccess_token(request));

		// 토큰에서 회원 정보 빼내기(네이버 API)
		if (tokenResult != null) {
			String member[] = tokenResult.split("&");
			mv.setViewName("redirect:/kaoGoHome.do?id="
					+ funcCollection.functionSignFromApi(member[0], member[2], member[1]));
		} else {
			mv.setViewName("login");
		}
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
	
	// ajax용 아이디 가지고 홈으로 들어가기 만들기...
	@RequestMapping("kaoGoHome.do")
	public ModelAndView goHome(@RequestParam("id") String member_id) {
		ModelAndView mv = new ModelAndView("home");
		mv.addObject("member_id", member_id);
		return mv;
	}
	
	
	// 게시판 이동
	@RequestMapping("free.do")
	public ModelAndView movetoBoard(String cPage) {
		
		pg.setTotalRecord(dao.getCountRecord("free"));
		pg.setNumPerPage(10); // 페이지당 담을 게시물 수
		pg.setPagePerBlock(3); // 블럭당 페이지 수 
		pg.setTotalPage(pg.getTotalRecord() / pg.getNumPerPage());
		if (pg.getTotalPage() % pg.getNumPerPage() > 0) {
			pg.setTotalPage(pg.getTotalPage() + 1);
		}
		
		// 위의 과정을 거쳤음에도 불구하고 페이지가 0이라면 1페이지 부터 시작하도록 
		// (EX : 게시물 2, numperPage 10개면 전체 페이지가 0이 되 버림)
		if (pg.getTotalPage() == 0) {
			pg.setTotalPage(1);
		}
		
		//현재 페이지 설정 : cPage가 널이면 디폴트인 0값으로
		if (cPage == null) {
			pg.setcPage(1);
		}else {
			pg.setcPage(Integer.parseInt(cPage));
		}
		
		// 현재 페이지 번호가 총 페이지 번호보다 큰 경우, 현재 페이지를 강제로 총 페이지 번호로 치환
		if (pg.getTotalPage() < pg.getcPage()) {
			pg.setcPage(pg.getTotalPage());
		}
		
		pg.setBeginPage( ((pg.getcPage()-1)/pg.getPagePerBlock())*pg.getPagePerBlock() + 1);
		pg.setEndPage(pg.getBeginPage()+pg.getPagePerBlock() - 1);
		
		if (pg.getEndPage() > pg.getTotalPage()) {
			pg.setEndPage(pg.getTotalPage());
		}
		
		List<Board> board_list = 
				dao.getBoard_list((pg.getcPage()-1)*pg.getNumPerPage()+1,
						pg.getcPage()*pg.getNumPerPage(), "free");
		
		List<List<Answer>> boardAnswer_list = new ArrayList<List<Answer>>();
		for (Board board : board_list) {
			List<Answer> answer_list = dao.getReturnAnswerList(board.getBoard_pk());
			boardAnswer_list.add(answer_list);
		}
		
		ModelAndView mv = new ModelAndView("free");
		mv.addObject("boardAnswer_list", boardAnswer_list);
		mv.addObject("board_list", board_list);
		mv.addObject("pg", pg);
		return mv;
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
	
	//회원가입 페이지 이동
	@RequestMapping("signin.do")
	public String signin() {
		return "signin";
	}
	
	//회원가입 디비 처리
	@Transactional
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
	
	//게시글 상세보기
	@Transactional
	@RequestMapping(value="oneBoard.do")
	public ModelAndView oneboard(String board_pk, @RequestParam("cPage") String cPage) {
		ModelAndView mv = new ModelAndView();
		Board board = dao.getOneboard(board_pk);
		dao.getHitUp(board.getBoard_hit(), board_pk);
		List<Answer> answer_list = dao.getAnswerList(board_pk);
		
		mv.addObject("board", board);
		mv.addObject("answer_list", answer_list);
		mv.addObject("cPage", cPage); // 목록버튼 클릭시 현재 페이지로 이동(3페이지까지 봤으면 1로 이동이 아니고 3으로 이동)
		mv.setViewName("oneBoard");
		return mv;
	}
	
	// 게시글 정보를 포함하여 수정 페이지 이동하기
	@RequestMapping("modify.do")
	public ModelAndView modify(
			String board_pk,
			@RequestParam("cPage") String cPage
			) {
		ModelAndView mv = new ModelAndView();
		Board board = dao.getOneboard(board_pk);
		mv.addObject("board", board);
		mv.addObject("cPage", cPage);
		mv.setViewName("oneBoard_modify");
		return mv ;
	}
	
	// 게시글 수정 완료 버튼 클릭시 db에 전달하여 처리 후 다시 해당 게시물로 이동
	@Transactional
	@RequestMapping("modifyDone.do")
	public ModelAndView modifyDone(
			@RequestParam("board_pk") String board_pk,
			@RequestParam("board_content") String board_content,
			@RequestParam("board_title") String board_title,
			@RequestParam("board_category") String board_category,
			@RequestParam("cPage") String cPage
			) {
		ModelAndView mv = new ModelAndView();
		Board board = dao.getOneboard(board_pk);
		board.setBoard_category(board_category);
		board.setBoard_content(board_content);
		board.setBoard_title(board_title);
		
		// 수정하기
		int res = dao.getBoardModify(board);
		mv.setViewName("redirect:/oneBoard.do?board_pk="+board_pk+"&cPage="+cPage);
		return mv;
	}
	
	// 게시글 삭제
	@Transactional
	@RequestMapping("deleteBoard.do")
	public String deleteBoard(@RequestParam("board_pk") String board_pk) {
		Board board = dao.getOneboard(board_pk);
		String str = "";
		if (board.getBoard_category().equals("free")) {
			str = "redirect:/free.do";
		}else if (board.getBoard_category().equals("music")) {
			str = "redirect:/music.do";
		}
		dao.getDeleteBoard(board_pk);
		return str; 
	}
	
	//게시글에 답글 달기
	@Transactional
	@RequestMapping(value="makeAnswer.do", method=RequestMethod.POST)
	public ModelAndView makeAnswer(HttpServletRequest request, @RequestParam("cPage") String cPage){
		ModelAndView mv = new ModelAndView();
		Answer answer = new Answer();
		String answer_bd_pk = request.getParameter("answer_bd_pk");
		answer.setAnswer_content(request.getParameter("answer_content"));
		answer.setAnswer_id(request.getParameter("answer_id"));
		answer.setAnswer_bd_pk(Integer.parseInt(answer_bd_pk));
		int res = dao.getMakeAnswer(answer);
		mv.setViewName("redirect:/oneBoard.do?board_pk="+answer_bd_pk+"&cPage="+cPage);		
		return mv;
	}
	
	//답글의 답글 달기
	@Transactional
	@RequestMapping(value="addAnswer.do", method=RequestMethod.POST)
	public ModelAndView addAnswer(Answer answer, @RequestParam("cPage") String cPage, HttpServletRequest request) {
		ModelAndView mv= new ModelAndView();
		answer.setAnswer_recommendation(0);
		int res = dao.getMakeAnswers_answer(answer);
		//System.out.println("cPage of 컨트롤러 = "+cPage);
		mv.setViewName("redirect:/oneBoard.do?board_pk="+answer.getAnswer_bd_pk()+"&cPage="+cPage);
		
		// 추가적으로 answer의 모든 자료 받아서 엔서에 넣기 
		return mv;
	}
	
	//글쓰기 게시판으로 이동
	@RequestMapping("go_makingBoard.do")
	public String go_makingBoard(){
		return "makeBoard";
	}
	
	// 글쓰기 DB처리
	@Transactional
	@RequestMapping(value="write.do", method=RequestMethod.POST)
	public ModelAndView write(
			Board board,
			HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
		int res = dao.getWrite(board);
			
		// 들어온 카테고리 정보로 분류하여 이프문으로 글 작성 후 기상, 자유, 음악 게시판으로 보내야함
		if (res > 0) {
			if (board.getBoard_category().equals("free")) {
				mv.setViewName("redirect:/free.do");
			}else if (board.getBoard_category().equals("music")) {
				mv.setViewName("redirect:/file_load.do");
			}else if (board.getBoard_category().equals("freedom")) {
				mv.setViewName("redirect:/freedom.do");
			}
		}else{
			// 글쓰기 실패
			mv.setViewName("makeBoard");
		}
		return mv;
	}
	
	// 네이버 스마트 에디터 처리
	@RequestMapping("/multipartPhotoUpload")
	public void fileMultiUpload(HttpServletRequest request, HttpServletResponse response) {
			PrintWriter print;
			try {
			print = response.getWriter();
			print.print(funcCollection.smartEditor_method(request));
			print.flush();
			print.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
	}
	
	
	
	
}