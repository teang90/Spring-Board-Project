package com.ict.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.SecureRandom;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.ModelAndView;

import com.ict.mybatis.Answer;
import com.ict.mybatis.Answer_recommendation;
import com.ict.mybatis.Board;
import com.ict.mybatis.Board_recommendation;
import com.ict.mybatis.DAO;
import com.ict.service.FunctionCollection;
import com.ict.mybatis.Member;

//@RequestMapping("/ajax") 
@RestController
public class AjaxController {
	@Autowired
	DAO dao;
	
	@Autowired
	FunctionCollection funcCollection ;
	
	// 아이디 중복체크
	@ResponseBody
	@RequestMapping(value="idcheck.do", method=RequestMethod.POST)
	public int idCheck(@RequestBody String member_id) {
		return dao.getIdCheck(member_id);
	}
	
	@Transactional
	@ResponseBody
	@RequestMapping(value="answerModify.do", method=RequestMethod.POST)
	public int answerContentModify(
			@RequestParam("answer_content") String answer_content,
			@RequestParam("answer_bd_pk") String answer_bd_pk,
			@RequestParam("answer_pk") String answer_pk ) {
		Answer answer = dao.getReturnAnswer(answer_pk);
		answer.setAnswer_content(answer_content);

		//answer에 수정된 내용, 
		int res = dao.getAnswerModify(answer);
		return res;
	}
	
	//검색기능
	@ResponseBody
	@RequestMapping(value="searchKeyword.do", method=RequestMethod.POST)
	public List<Board> search(
			@RequestParam("board_keyword") String keyword,
			@RequestParam("board_legend") String legend
			) {
		List<Board> b_list = dao.getBoardSearch(keyword, legend);
		return b_list ;
	}

	/* 기상정보 가져오기
	@ResponseBody
	@RequestMapping(value="weatherInfo.do", produces="html/xml; charset=utf-8") //produces 설정해줘서 한글처리 된듯
	public String weatherInfo() {
		StringBuffer sb = new StringBuffer();
		InputStream in = null;
		BufferedReader br = null;
		try {
			String msg = "";
			URL url = new URL("http://www.kma.go.kr/XML/weather/sfc_web_map.xml");
			// URL url = new URL("http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=1159068000");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			//conn.setRequestProperty("CONTENT-TYPE", "text/xml"); // 한글처리하는데 있어서 이건 영향을 안준듯
			in = conn.getInputStream();
			br = new BufferedReader(new InputStreamReader(in, "UTF-8"));
			while ((msg = br.readLine()) != null) {
				sb.append(msg);
			}
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e2) {
			e2.printStackTrace();
		} finally {
			try {
				in.close();
				br.close();
			} catch (Exception e3) {
				e3.printStackTrace();
			}
		}
		return sb.toString();
	}*/
	
	// 게시글 추천
	@RequestMapping(value="BoardRecommendationUpDown.do", method=RequestMethod.POST)
	@ResponseBody
	@Transactional
	public Board_recommendation boardRecommendUp(
			@RequestParam("recommendation_standard") String recommendation_standard,
			@RequestParam("board_recommendation") String board_recommendation,
			@RequestParam("board_pk") String board_pk,
			@RequestParam("member_id") String member_id,
			HttpServletRequest request
			){
		Board_recommendation board_rec = dao.getReturnBoard_recommend(board_pk, member_id);
		Board board = dao.getOneboard(board_pk);
	
		if (board_rec == null) { // b_recommend가 null이면 생성, 아니면 + 1

			Board_recommendation b_recommend = new Board_recommendation();

			b_recommend.setBoard_id(board.getBoard_id());
			b_recommend.setBoard_pk(board_pk);
			b_recommend.setMember_id(member_id);
			b_recommend.setBoard_recommendation(Integer.parseInt(board_recommendation));
			
			b_recommend.setRecommendation_standard(Integer.parseInt(recommendation_standard));

			dao.getInsertBoard_recommend(b_recommend); //추천 객체에 생성
			dao.getBoardRecommendUp(board, Integer.parseInt(recommendation_standard), member_id); // 게시글의 추천 수 업

		}else {

			dao.getBoardRecommendUp(board, Integer.parseInt(recommendation_standard), member_id); // 게시글의 추천 수 변경
			/*	보드 레커맨드 클래스를 수정할 떄 맴버 값이 같이 안들어가서 에이작스 컨트롤러에서 DAO로 보낼 떄 같이 보내야함*/
		}
		
		return board_rec;
			
	}
	
	
	@RequestMapping(value="returnBoardRecommendation.do", method=RequestMethod.POST)
	@ResponseBody
	public int returnBoardRecommendation(
			@RequestParam("board_pk") String board_pk,
			@RequestParam("member_id") String member_id
			){
		Board_recommendation board_rec = dao.getReturnBoard_recommend(board_pk, member_id);
		if (board_rec == null) {
			return 0;
		}
		return board_rec.getRecommendation_standard();
	}
	
	
	//답글 추천 및 반대
	@Transactional
	@RequestMapping(value="AnswerRecommendUpDown.do", method=RequestMethod.POST, produces="html/json; charset=utf-8")
	@ResponseBody
	public int answer_RecommendationUpDown(
			@RequestParam("member_id") String member_id,
			@RequestParam("answer_pk") String answer_pk,
			@RequestParam("board_pk") String board_pk,
			@RequestParam("recommendation_standard") String recommendation_standard
			){
		int res = 0 ;
		 
		//답글의 기본키와 회원아이디로 추천객체를 통하여 이전에 추천한 이력 조회
		Answer_recommendation answer_rec = dao.getReturnAnswerObj(answer_pk, member_id);
		Answer answer = dao.getReturnAnswer(answer_pk);
		
		if (answer_rec == null) {
			// null이면 해당 댓글의 추천 객체 생성하고
			Answer_recommendation answer_rec2 = new Answer_recommendation();
			
			answer_rec2.setAnswer_pk(Integer.parseInt(answer_pk));
			answer_rec2.setBoard_pk(Integer.parseInt(board_pk));
			answer_rec2.setMember_id(member_id);
			answer_rec2.setRecommendation_standard(Integer.parseInt(recommendation_standard));
			
			// 답글 추천 객체 이력 정보 디비에 저장 
			res = dao.getMakeAnswer_recommendation(answer_rec2);
			
			// 답글 객체의 추천수 증감(추천 기준 수 1 => 추천 / -1 => 반대)
			if (Integer.parseInt(recommendation_standard) > 0) {
				res = dao.getAnswer_Recommendation_Up(answer);
			}else if (Integer.parseInt(recommendation_standard) < 0) {
				res = dao.getAnswer_Recommendation_Down(answer);
			}
			dao.getRecommendation_standardModify(answer_pk, member_id, recommendation_standard);
			return dao.getReturnAnswer(answer_pk).getAnswer_recommendation();

		}else{
			// 답글 추천객체가 갖고 있는 기준 값이 요청 들어온 추천 기준 값과 다른 경우
			// 답글 객체의 추천수 증감(추천 기준 수 1 => 추천 / -1 => 반대)
			if (Integer.parseInt(recommendation_standard) > 0) {
				res = dao.getAnswer_Recommendation_Up(answer);
			}else if (Integer.parseInt(recommendation_standard) < 0) {
				res = dao.getAnswer_Recommendation_Down(answer);
			}
			dao.getRecommendation_standardModify(answer_pk, member_id, recommendation_standard);
			return answer.getAnswer_recommendation();
		}
	}
	
	@RequestMapping(value="returnAnswer_rec_strd.do", method=RequestMethod.POST)
	@ResponseBody
	public int getAnswerRecommendation_standard(
			@RequestParam("member_id") String member_id,
			@RequestParam("answer_pk") String answer_pk
			){
		
		Answer_recommendation answer_rec = dao.getReturnAnswer_recommendation_standard(member_id, answer_pk);
		if (answer_rec == null) {
			// 추천 이력 없는 애들은 추천 객체 만들어야함
			return 0;
		}else {
			// 이미 있는 애들은 recommendation 값 갖고서 반환 ㄱㄱ
			return answer_rec.getRecommendation_standard();
		}
	}
	
	//카카오 로그인
	@RequestMapping("kakaoLogin.do")
	@ResponseBody
	public String kakaoLogin(
			@RequestParam("id") String member_pk,
			@RequestParam("name") String member_name,
			@RequestParam("email") String member_email
			){
		return funcCollection.functionSignFromApi(member_pk, member_name, member_email);
	}
	
	//에이잭스에서 로그아웃...
	@Transactional
	@RequestMapping("ajaxlogout.do")
	@ResponseBody
	public ModelAndView logOut(HttpSession session) {
		ModelAndView mv = new ModelAndView();
		session.invalidate();
		mv.setViewName("redirect:/");
		return mv;
	}
	
	// 댓글 삭제
	@Transactional
	@RequestMapping("answerDelete.do")
	@ResponseBody
	public int getDeleteAnswer(
			@RequestParam("answer_pk") String answer_pk
			) {
		int res = dao.getDeleteAnswer(answer_pk);
		return res ;
	}
	
	// callback.html 역할(접근 토큰 받기)
	// spring 프로젝트 페이지에서 네로아 로그아웃
	@RequestMapping("returnNaverAccess_token.do")
	@ResponseBody
	public String returnNaverAccess_token(HttpServletRequest request) {
		String clientId = "NUjBHsvxCTjUTS1ileL9";// 애플리케이션 클라이언트 아이디값";
		String clientSecret = "JTfj_oe28K";// 애플리케이션 클라이언트 시크릿값";
		String code = request.getParameter("code");
		String state = request.getParameter("state");
		String redirectURI;
		StringBuffer res = new StringBuffer();
		String apiURL;
		JSONObject Jobj = null;
		
		try {
			redirectURI = URLEncoder.encode("http://localhost:8090/", "UTF-8");
			apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=delete&";
			apiURL += "client_id=" + clientId;
			apiURL += "&client_secret=" + clientSecret;
			apiURL += "&redirect_uri=" + redirectURI;
			apiURL += "&code=" + code;
			apiURL += "&state=" + state;
			// String access_token = "";
			// String refresh_token = "";
			URL url = new URL(apiURL);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			int responseCode = con.getResponseCode();
			BufferedReader br;
			if (responseCode == 200) { // 정상 호출
				// 보낸 요청으로 부터 JSON 형태로 토큰 값들 받기
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else { // 에러 발생
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}
			String inputLine;
			while ((inputLine = br.readLine()) != null) {
				res.append(inputLine);
			}
			br.close();

			String token = new String(res);
			JSONParser Jps = new JSONParser();
			Jobj = (JSONObject)Jps.parse(token);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return (String)Jobj.get("error");
	}

	
	
	
	
	
	
	
}
