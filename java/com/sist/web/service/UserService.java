package com.sist.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.UserDao;
import com.sist.web.model.User;

@Service("userService")
public class UserService 
{
private static Logger logger = LoggerFactory.getLogger(User.class);
	
	@Autowired
	private UserDao userDao;
	
	//사용자 조회
	public User userSelect(String userId)
	{
		User user = null;
		
		try
		{
			user = userDao.userSelect(userId);
			logger.debug("----------------------------" + user.getFakePwdStatus());
			logger.debug("----------------------------" + user.getUserPwd());
		}
		catch(Exception e)
		{
			logger.error("[UserSercice]userSelect Exception", e);
		}
		return user;
	}
	
	//이메일 조회
	public User emailSelect(String userEmail)
	{
		User user = null;
		
		try
		{
			user = userDao.emailSelect(userEmail);
		}
		catch(Exception e)
		{
			logger.error("[UserSercice]emailSelect Exception", e);
		}
		return user;
	}
	
	//사용자 등록
	public int userInsert(User user)
	{
		int count = 0;
		
		try
		{
			count = userDao.userInsert(user);
		}
		catch(Exception e)
		{
			logger.error("[UserSercice]userInsert Exception", e);
		}
		
		return count;
	}
	
	//회원정보 수정
	public int userUpdate(User user)
	{
		int count = 0;
		
		try
		{
			count = userDao.userUpdate(user);
		}
		catch(Exception e)
		{
			logger.error("[UserSercice]userUpdate Exception", e);
		}
		
		return count;
	}
	
	//아이디 찾기
	public String findUserId(User user)
	{
		String result = "";
		
		try
		{
			result = userDao.findUserId(user);
		}
		catch(Exception e)
		{
			logger.error("[UserSercice]findUserId Exception", e);
		}
		
		return result;
	}
	
	//비밀번호 찾기
	public String findUserPwd(User user)
	{
		String result = "";
		
		try
		{
			result = userDao.findUserPwd(user);
		}
		catch(Exception e)
		{
			logger.error("[UserSercice]findUserPwd Exception", e);
		}
		
		return result;
	}
	
	//임시비밀번호 변경
	public int updatePwd(User user)
	{
		int count = 0;
		
		try
		{
			count = userDao.updatePwd(user);
		}
		catch(Exception e)
		{
			logger.error("[UserSercice]updatePwd Exception", e);
		}
		
		return count;
	}
	
	//사용자 상태 수정
	public int updateUser(User user)
	{
		int count = 0;
		
		try
		{
			count = userDao.updateUser(user);
		}
		catch(Exception e)
		{
			logger.error("[UserSercice]updateUser Exception", e);
		}
		
		return count;
	}
	
	//임시비밀번호 로그인시 상태 변경
	public int updateFakeStatus(User user)
	{
		int count = 0;
		
		try
		{
			count = userDao.updateFakeStatus(user);
		}
		catch(Exception e)
		{
			logger.error("[UserSercice]updateFakeStatus Exception", e);
		}
		
		return count;
	}
}
