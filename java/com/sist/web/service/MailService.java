package com.sist.web.service;


import java.security.SecureRandom;
import java.util.Random;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.sist.web.util.EmailCodeUtil;

@Service("mailService")
public class MailService {

	@Autowired
	private JavaMailSender mailSender;
	/*
	 * @Autowired private SimpleMailMessage preConfiguredMessage;
	 */
	// 6자리 난수 생성
	public String randomCode() 
	{
    Random random = new Random();
    return String.format("%06d", random.nextInt(999999)); 
	}
	
	// 6자리 숫자 + 대문자영어 난수 생성
	public String randomCode2() 
	{
	    // 사용할 문자 집합 정의 (숫자 + 대문자)
	    String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	    SecureRandom random = new SecureRandom();
	    StringBuilder code = new StringBuilder(6);

	    for (int i = 0; i < 6; i++) {
	        int index = random.nextInt(characters.length());
	        code.append(characters.charAt(index));
	    }

	    return code.toString();
	}
	
	//회원가입
	@Async
	public void sendMail(String to , String subject, String body)
	{
		String code = randomCode();
		MimeMessage message = mailSender.createMimeMessage();
		try 
		{
			MimeMessageHelper messageHelper = new MimeMessageHelper(message,true,"UTF-8"); 
			
			//메일 수신 시 표시될 이름 설정
			messageHelper.setFrom("mixtestcode@gmail.com","아르센 뤼팽");
			messageHelper.setSubject(subject);
			
			String emailContent = "<html>" +
	                "<body style='font-family: Arial, sans-serif; margin: 20px; background-color: #e0f7fa;'>" + 
	                "<div style='text-align: center; background-color: #ffffff; padding: 30px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);'>" + 
	                "<h1 style='color: #FF6F61;'>🎨 전시회 인증코드 안내 🎨</h1>" +
	                "<p style='font-size: 18px;'>안녕하세요! 전시회에 오신 것을 환영합니다.</p>" +
	                "<p>아래의 인증번호를 입력하여 등록을 완료해 주세요:</p>" +
	                "<h2 style='font-weight: bold; font-size: 32px; color: #4CAF50; margin: 20px 0;'>" + code + "</h2>" +
	                "<p style='font-size: 16px;'>이 인증번호는 5분 동안 유효합니다.</p>" +
	                "<p style='margin-top: 20px;'>감사합니다! 즐거운 관람 되세요.</p>" +
	                "<footer style='margin-top: 30px;'>" +
	                "<p style='font-size: 12px; color: #888;'>이 이메일은 자동 발송됩니다. 문의사항이 있으면 전시회 운영팀에 연락해 주세요.</p>" +
	                "</footer>" +
	                "</div>" + 
	                "</body>" +
	                "</html>";
			
			messageHelper.setTo(to);
			messageHelper.setText(emailContent, true);
			mailSender.send(message);
			
			EmailCodeUtil.storeCode(to, code);
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
	}
		//임시비밀번호
		@Async
		public String sendPwdMail(String to , String subject, String body)
		{
			String code = randomCode2();
			MimeMessage message = mailSender.createMimeMessage();
			try 
			{
				MimeMessageHelper messageHelper = new MimeMessageHelper(message,true,"UTF-8"); 
				
				//메일 수신 시 표시될 이름 설정
				messageHelper.setFrom("mixtestcode@gmail.com","아르센 뤼팽");
				messageHelper.setSubject(subject);
				
				String emailContent = "<html>" +
		                "<body style='font-family: Arial, sans-serif; margin: 20px; background-color: #e0f7fa;'>" + 
		                "<div style='text-align: center; background-color: #ffffff; padding: 30px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);'>" + 
		                "<h1 style='color: #FF6F61;'>🎨 전시회 임시비밀번호 안내 🎨</h1>" +
		                "<p style='font-size: 18px;'>안녕하세요! 전시회에 오신 것을 환영합니다.</p>" +
		                "<p>아래의 비밀번호를 이용하여 로그인해 주세요:</p>" +
		                "<h2 style='font-weight: bold; font-size: 32px; color: #4CAF50; margin: 20px 0;'>" + code + "</h2>" +
		                "<p style='font-size: 16px;'>회원정보수정을 추천드립니다.</p>" +
		                "<p style='margin-top: 20px;'>감사합니다! 즐거운 관람 되세요.</p>" +
		                "<footer style='margin-top: 30px;'>" +
		                "<p style='font-size: 12px; color: #888;'>이 이메일은 자동 발송됩니다. 문의사항이 있으면 전시회 운영팀에 연락해 주세요.</p>" +
		                "</footer>" +
		                "</div>" + 
		                "</body>" +
		                "</html>";
				
				messageHelper.setTo(to);
				messageHelper.setText(emailContent, true);
				mailSender.send(message);
				
				EmailCodeUtil.storeCode(to, code);
			} 
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			return code;
		}
	
}
