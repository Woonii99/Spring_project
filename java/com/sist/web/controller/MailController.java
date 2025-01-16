package com.sist.web.controller;

import java.io.PrintWriter;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.MailService;
import com.sist.web.service.UserService;
import com.sist.web.util.EmailCodeUtil;



@Controller
@EnableAsync		//비동기로 동작하게 하는 어노테이션
public class MailController {
		
	@Autowired
	private MailService mailService;
	
	@Autowired
	private UserService userService;
	
	//회원가입 이메일전송
	@RequestMapping(value = "/sendMail.do", method= RequestMethod.POST)
	@ResponseBody
	public Response<Object> sendSimpleMail(HttpServletRequest request,HttpServletResponse response) throws Exception
	{
		Response<Object> res = new Response<Object>();
		
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		String to = request.getParameter("userEmail");
		String subject = "인증번호 발송";
		String body = "";
		
		mailService.sendMail(to, subject, body);
		
		return res;
	}
	
	//인증코드 체크
	@RequestMapping(value = "/sendMailCode.do", method= RequestMethod.POST)
	@ResponseBody
	public Response<Object> sendMailCode(HttpServletRequest request) throws Exception
	{
		Response<Object> res = new Response<Object>();
		
		String to = request.getParameter("userEmail");
	    String inputCode = request.getParameter("authNum");
	    
	    String storedCode = EmailCodeUtil.getCode(to);
	    
	    if (storedCode != null && storedCode.equals(inputCode)) {
	        res.setMsg("인증 성공!");
	        EmailCodeUtil.clearCode(to); 
	    } else {
	        res.setMsg("인증 실패. 올바른 인증번호를 입력하세요.");
	    }
	    
	    return res;
	}
	
	//임시비밀번호 이메일전송
	@RequestMapping(value = "/sendPwdCodeMail.do", method= RequestMethod.POST)
	@ResponseBody
	public Response<Object> sendPwdCodeMail(HttpServletRequest request,HttpServletResponse response) throws Exception
	{
		Response<Object> res = new Response<Object>();
		
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		String to = request.getParameter("userEmail");
		String userId = request.getParameter("userId");
		String subject = "임시비밀번호 발송";
		String body = "";
		String pwdStatus = "N";
		
		
		String code = 	mailService.sendPwdMail(to, subject, body);
		
		User user = new User();
		
		user.setUserId(userId);
		user.setUserEmail(to);
		user.setUserPwd(code);
		user.setFakePwdStatus(pwdStatus);
		
		userService.updatePwd(user);
		
		return res;
	}
}
