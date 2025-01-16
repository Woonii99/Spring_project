package com.sist.web.dao;

import org.springframework.stereotype.Repository;

import com.sist.web.model.User;

@Repository("UserDao")
public interface UserDao 
{
	//사용자 정보 조회
	public User userSelect(String userId);
	
	//이메일 조회
	public User emailSelect(String userEmail);
	
	//사용자 등록
	public int userInsert(User user);
	
	//사용자 정보 수정
	public int userUpdate(User user);
	
	//아이디 찾기
	public String findUserId(User user);
	
	//비밀번호 찾기
	public String findUserPwd(User user);
	
	//임시비밀번호 업데이트
	public int updatePwd(User user);
	
	//사용자 상태 변경
	public int updateUser(User user);
	
	//임시비밀번호 로그인시 상태 변경
	public int updateFakeStatus(User user);
}
