package com.sist.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;

@Controller("userController")
public class UserController 
{
	private static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private UserService userService;
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	//회원가입 페이지
	@RequestMapping(value = "/user/userForm", method=RequestMethod.GET)
	public String userForm(HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		   
		   if(!StringUtil.isEmpty(cookieUserId))
		   {
		     CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);

		     return "redirect:/";
		   }
		   else
		   {
		     return "/user/userForm"; 
		   }
	}
	
	//아이디 중복 체크
	@RequestMapping(value="/user/idCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		
		if(!StringUtil.isEmpty(userId))
		{
			if(userService.userSelect(userId) == null)
			{
				ajaxResponse.setResponse(0, "success");
			}
			else
			{
				ajaxResponse.setResponse(100, "deplicate id");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "bad request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/idCheck response \n" +	JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//이메일 중복 체크
	@RequestMapping(value="/user/emailCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> emailCheck(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userEmail = HttpUtil.get(request, "userEmail");
		
		if(!StringUtil.isEmpty(userEmail))
		{
			if(userService.emailSelect(userEmail) == null)
			{
				ajaxResponse.setResponse(0, "success");
			}
			else
			{
				ajaxResponse.setResponse(100, "deplicate email");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "bad request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/emailCheck response \n" +	JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//로그인
	@RequestMapping(value="/user/login", method=RequestMethod.POST)	
	@ResponseBody
	public Response<Object> login(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxaResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		
		logger.debug(userId + "+++" + userPwd);
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd))
		{
			User user = userService.userSelect(userId);
			logger.debug("++++++++++++++++++++++++++" + user.getFakePwdStatus());
			
			if(user != null)
			{
				if(StringUtil.equals(user.getUserPwd(), userPwd))
				{
					if(StringUtil.equals(user.getStatus(), "Y"))
					{
						
						logger.debug("==================================================");
						logger.debug(user.getFakePwdStatus());
						logger.debug("==================================================");
						
						
						if(StringUtil.equals(user.getFakePwdStatus(), "Y"))
						{
							CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));	
							ajaxaResponse.setResponse(0, "success");
						}
						if(StringUtil.equals(user.getFakePwdStatus(), "N"))
						{
							CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
							user.setFakePwdStatus("Y");
							
							userService.updateFakeStatus(user);
							ajaxaResponse.setResponse(-2, "succes(1)");
						}
					}
					else if(StringUtil.equals(user.getStatus(), "H"))
					{
						ajaxaResponse.setResponse(-999, "status error(1)");
					}
					else
					{
						ajaxaResponse.setResponse(-99, "status error");
					}
					
				}
				else
				{
					ajaxaResponse.setResponse(-1, "password mismatch");
				}
			}
			else
			{
				ajaxaResponse.setResponse(404, "not found");
			}
		}
		else
		{
			ajaxaResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/login response \n" +
											JsonUtil.toJsonPretty(ajaxaResponse));
		}
		
		return ajaxaResponse;
	}
	
	/*
	// 로그인 메서드에서 로그인 실패 시도 횟수 카운트 추가
	@RequestMapping(value="/user/userForm", method=RequestMethod.POST)	
	@ResponseBody
	public Response<Object> login(HttpServletRequest request, HttpServletResponse response) {
	    Response<Object> ajaxResponse = new Response<Object>();

	    // 로그인 시도 횟수 저장을 위한 세션 추가
	    Integer loginAttempts = (Integer) request.getSession().getAttribute("loginAttempts");
	    if (loginAttempts == null) {
	        loginAttempts = 0;
	    }

	    String userId = HttpUtil.get(request, "userId");
	    String userPwd = HttpUtil.get(request, "userPwd");

	    if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)) {
	        User user = userService.userSelect(userId);

	        if (user != null) {
	            if (StringUtil.equals(user.getUserPwd(), userPwd)) {
	                if (StringUtil.equals(user.getStatus(), "Y")) {
	                    CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));	
	                    ajaxResponse.setResponse(0, "success");
	                    request.getSession().removeAttribute("loginAttempts"); // 로그인 성공 시 세션에서 제거
	                } else {
	                    ajaxResponse.setResponse(-99, "status error");
	                }
	            } else {
	                loginAttempts++;
	                request.getSession().setAttribute("loginAttempts", loginAttempts); // 세션에 로그인 시도 횟수 저장
	                ajaxResponse.setResponse(-1, "password mismatch");
	            }
	        } else {
	            ajaxResponse.setResponse(404, "not found");
	        }
	    } else {
	        ajaxResponse.setResponse(400, "Bad Request");
	    }

	    // 로그인 시도 횟수가 5회 이상이면 임시적으로 로그인을 차단
	    if (loginAttempts >= 5) {
	        ajaxResponse.setResponse(403, "too many login attempts");
	    }

	    if (logger.isDebugEnabled()) {
	        logger.debug("[UserController] /user/login response \n" + JsonUtil.toJsonPretty(ajaxResponse));
	    }

	    return ajaxResponse;
	}
	*/
	
	//로그아웃
	@RequestMapping(value="/user/loginOut", method=RequestMethod.GET)
	public String loginOut(HttpServletRequest request, HttpServletResponse response)
	{
		if(CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null)
		{
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
		}
		
		return "redirect:/";
	}
	
	//회원 등록
	@RequestMapping(value="/user/regProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> regProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userEmail = HttpUtil.get(request, "userEmail");
		String addrCode = HttpUtil.get(request, "addrCode");
		String addrBase = HttpUtil.get(request, "addrBase");
		String addrDetail = HttpUtil.get(request, "addrDetail");
//		String rating = HttpUtil.get(request, "rating");
		String rating = "1";
		
		logger.debug(userId + "+++++" + userPwd + "+++++" + userName + "+++++" + userEmail
				+ "+++++" + addrCode + "+++++" + addrBase + "+++++" + addrDetail + rating);
		
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) &&
				!StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail) &&
				!StringUtil.isEmpty(addrCode) && !StringUtil.isEmpty(addrBase) &&
				!StringUtil.isEmpty(addrDetail)) //&& !StringUtil.isEmpty(rating))
		{
			if(userService.userSelect(userId) == null)
			{
				//중복아이디가 없을 경우 정상 등록
				User user = new User();
				
				user.setUserId(userId);
				user.setUserPwd(userPwd);
				user.setUserName(userName);
				user.setUserEmail(userEmail);
				user.setStatus("Y");
				user.setAddrCode(addrCode);
				user.setAddrBase(addrBase);
				user.setAddrDetail(addrDetail);
				user.setRating(rating);
				
				if(userService.userInsert(user) > 0)
				{
					ajaxResponse.setResponse(0, "success");
				}
				else
				{
					ajaxResponse.setResponse(500, "internal server error");
				}
				
			}
			else
			{
				ajaxResponse.setResponse(100, "duplicate id");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "bad request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/regProc response \n" +
											JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//회원정보 수정 화면
	@RequestMapping(value="/user/updateForm", method=RequestMethod.GET)
	public String updateForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
    {
	    String cokieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
	   
	    User user = userService.userSelect(cokieUserId);
	   
	    model.addAttribute("user", user);
	    return "/user/updateForm";
    }
	
	//회원정보 수정 (ajax통신용)
	@RequestMapping(value="/user/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userEmail = HttpUtil.get(request, "userEmail");
		String userName = HttpUtil.get(request, "userName");
		String userPwd = HttpUtil.get(request, "userPwd");
		String addrCode = HttpUtil.get(request, "addrCode");
		String addrBase = HttpUtil.get(request, "addrBase");
		String addrDetail = HttpUtil.get(request, "addrDetail");
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			if(StringUtil.equals(userId, cookieUserId))
			{
				User user = userService.userSelect(cookieUserId);
				
				if(user != null)
				{
					if(!StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userName) &&
							!StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(addrCode) &&
							!StringUtil.isEmpty(addrBase) && !StringUtil.isEmpty(addrDetail))
					{
						user.setUserEmail(userEmail);
						user.setUserName(userName);
						user.setUserPwd(userPwd);
						user.setAddrCode(addrCode);
						user.setAddrBase(addrBase);
						user.setAddrDetail(addrDetail);
						
						if(userService.userUpdate(user) > 0)
						{
							ajaxResponse.setResponse(0, "success");
						}
						else
						{
							ajaxResponse.setResponse(500, "internal server error");
						}
					}
					else
					{
						//파라미터 값이 올바르지 않을 경우
						ajaxResponse.setResponse(400, "bad request");
					}
				}
				else
				{
					//사용자 정보가 없을 경우
					CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
					ajaxResponse.setResponse(404, "not found");
				}
			}
			else
			{
				//쿠키정보와 넘어온 userId가 다른경우
				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
				ajaxResponse.setResponse(430, "id information is different");
			}
		}
		else
		{
			ajaxResponse.setResponse(410, "loing failed");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/updateProc response \n" +
											JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//아이디, 비밀번호 찾기 화면
	@RequestMapping(value="/user/findForm", method=RequestMethod.GET)
	public String findForm(HttpServletRequest request, HttpServletResponse response)
    {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		   
	   if(!StringUtil.isEmpty(cookieUserId))
	   {
	     CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);

	     return "redirect:/";
	   }
	   else
	   {
	     return "/user/findForm";
	   }
    }
	
	//아이디 찾기
	@RequestMapping(value="/user/findUserId", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> findUserId(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> res = new Response<Object>();
		
		String userName = HttpUtil.get(request, "userName");
		String userEmail = HttpUtil.get(request, "userEmail");
		
		User user = new User();
		String result = "";
		
		if(!StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail))
		{
			user.setUserName(userName);
			user.setUserEmail(userEmail);
			result = userService.findUserId(user);
		}
		else
		{
			res.setResponse(400, "bad request");
		}
		
		if(!StringUtil.isEmpty(result))
		{
			res.setResponse(0, result);
		}
		else
		{
			res.setResponse(404, "not found");
		}
		
		return res;
	}
	
	//비밀번호 찾기
	@RequestMapping(value="/user/findUserPwd", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> findUserPwd(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> res = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		String userEmail = HttpUtil.get(request, "userEmail");
		
		User user = new User();
		String result = "";
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userEmail))
		{
			user.setUserId(userId);
			user.setUserEmail(userEmail);
			result = userService.findUserPwd(user);
		}
		else
		{
			res.setResponse(400, "bad request");
		}
		
		if(!StringUtil.isEmpty(result))
		{
			res.setResponse(0, result);
		}
		else
		{
			res.setResponse(404, "not found");
		}
		
		return res;
	}
	
	//사용자 상태 수정
	@RequestMapping(value="/user/updateUser", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateUser(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> res = new Response<Object>();
		
		String userId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String status = HttpUtil.get(request, "status");
		
		User user = new User();
		int count = 0;
		
		if(!StringUtil.isEmpty(userId))
		{
			user.setUserId(userId);
			user.setStatus(status);
			count = userService.updateUser(user);
						
			CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
			
			res.setResponse(0, "success");
		}
		else
		{
			res.setResponse(400, "bad request");
		}
		
		return res;
	}
}
