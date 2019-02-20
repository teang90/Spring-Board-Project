package com.ict.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ict.mybatis.DAO;
import com.ict.mybatis.Member;

@Repository("funcCollection")
public class FunctionCollection {

	@Autowired
	DAO dao;
	
	// 카카오, 네이버(oAuth token 사용)로 부터 API 받아서 회원 정보 이용하여 디비에 회원 가입 및 검색 함수
	public String functionSignFromApi(String member_pk, String member_name, String member_email) {
		Member member = dao.getReturnMember(member_pk); //id가 기본키 역할 할거임
		
		//만약 카카오로 회원가입 안 한 회원인데, 이미 해당 아이디가 있는 경우... 이메일을 아이디로 사용
		if (member == null) { 
			Member member2 = new Member();
			member2.setMember_pk(Integer.parseInt(member_pk));
			member2.setMember_name(member_name);
			member2.setMember_email(member_email);
			if (dao.getIdCheck(member_email.substring(0, member_email.indexOf('@'))) == 0) {
				// 카카오톡에서 온 자료의 이메일 아이디를 사용할 수 있는 경우
				member2.setMember_id(member_email.substring(0, member_email.indexOf('@')));
			}else{
				//이메일 아이디를 사용할 수 없는 경우 => 이메일을 통째로 아이디로 저장
				member2.setMember_id(member_email);
			}
			dao.getSignin(member2);
			return member2.getMember_id();
		}
		return member.getMember_id();
	}
	
	
	//네이버 계정을 이용한 회원의 기본정보(아이디, 이메일...)
	public String getProfileInformation(StringBuffer res) {
		  String result = new String(res);
	      JSONParser j_parser= new JSONParser();
	      String str = null;
	    
	   try {
		   
	    	JSONObject j_obj = (JSONObject)j_parser.parse(result);
	    	String token = (String)j_obj.get("access_token");
	    	
	    	String header = "Bearer " + token ;
	    	URL url;
	    	HttpURLConnection con ;
			url = new URL("https://openapi.naver.com/v1/nid/me?Autorization=");
			con = (HttpURLConnection) url.openConnection();
			
			con.setRequestMethod("GET");
			con.setRequestProperty("Authorization", header);
			int responseCode = con.getResponseCode();
			BufferedReader br;
			if (responseCode == 200) { // 정상 호출
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else { // 에러 발생
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}
			String inputLine;
			StringBuffer response = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				response.append(inputLine);
			}
			br.close();
			String userInfo = new String(response);
			// 네이버에서 받은 고객 정보로 메일, 기본키, 이름으로 회원 가입 시켜야 함
		    j_obj = (JSONObject)j_parser.parse(userInfo);
		    String resultcode = (String)j_obj.get("resultcode");
		    JSONObject user = (JSONObject)j_obj.get("response");
		    
		    if ( resultcode.equals("00") ) {
		    	str = (String)user.get("id");
		    	str += "&"+(String)user.get("email");
		    	str += "&"+(String)user.get("name");
			}
		
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e2) {
			e2.printStackTrace();
		} catch (ParseException e3) {
			e3.printStackTrace();
		}
		return str;
	}
	
	
	// callback.html 역할(접근 토큰 받기)
	//@RequestMapping("returnNaverAccess_token.do")
	public StringBuffer returnNaverAccess_token(HttpServletRequest request) {
			
			String clientId = "NUjBHsvxCTjUTS1ileL9";//애플리케이션 클라이언트 아이디값";
		    String clientSecret = "JTfj_oe28K";//애플리케이션 클라이언트 시크릿값";
		    String code = request.getParameter("code");
		    String state = request.getParameter("state");
		    String redirectURI;
		    StringBuffer res = new StringBuffer();
		    
		    String apiURL;
		    try {
		    redirectURI = URLEncoder.encode("http://localhost:8090/", "UTF-8");
		    apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&";
		    apiURL += "client_id=" + clientId;
		    apiURL += "&client_secret=" + clientSecret;
		    apiURL += "&redirect_uri=" + redirectURI;
		    apiURL += "&code=" + code;
		    apiURL += "&state=" + state;
		    // String access_token = "";
		    // String refresh_token = "";
		      URL url = new URL(apiURL);
		      HttpURLConnection con = (HttpURLConnection)url.openConnection();
		      con.setRequestMethod("GET");
		      int responseCode = con.getResponseCode();
		      BufferedReader br;
		      if(responseCode==200) { // 정상 호출
		        // 보낸 요청으로 부터 JSON 형태로 토큰 값들 받기 
		    	br = new BufferedReader(new InputStreamReader(con.getInputStream()));
		      } else {  // 에러 발생
		        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
		      }
		      String inputLine;
		      while ((inputLine = br.readLine()) != null) {
		        res.append(inputLine);
		      }
		      br.close();
		      // if(responseCode==200) { System.out.println(res.toString()); }
		    }catch (Exception e) {
		    	e.printStackTrace();
		    }
			return res ;
		}
	
		// 네이버 스마트 에디터 처리
		public String smartEditor_method(HttpServletRequest request) {
			String sFileInfo = ""; // 파일정보
			String filename  ;
			try {
				// 파일명을 받는다 - 일반 원본파일명
				filename = request.getHeader("file-name");
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
			} catch (Exception e) {
				e.printStackTrace();
			}
			return sFileInfo;
		}

	
	
}
