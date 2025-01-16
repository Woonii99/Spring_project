package com.sist.web.model;

import java.io.Serializable;

public class User implements Serializable
{
	private static final long serialVersionUID = 1L;

	private String userId;			//아이디
	private String userPwd;			//비밀번호
	private String userName;		//이름
	private String userEmail;		//이메일
	private String status;			//상태(Y:정상 N:정지)
	private String regDate;			//가입일
	private String addrCode;		//우편번호
	private String addrBase;		//주소
	private String addrDetail;		//상세주소
	private String rating;			//등급
	private String fakePwdStatus;	//상태(Y:정상비밀번호 N:임시비밀번호)
	
	
	public User()
	{
		userId = "";
		userPwd = "";
		userName = "";
		userEmail = "";
		status = "";
		regDate = "N";
		addrCode = "";
		addrBase = "";
		addrDetail = "";
		rating = "";
		fakePwdStatus = "";
	}
	
	/*
	// 비밀번호 해시 기능 추가
	public void hashUserPwd(String userPwd) {
    // 비밀번호를 해시로 저장
    this.userPwd = hashPassword(userPwd);
	}

	// 비밀번호 해시 메서드 추가
	private String hashPassword(String password)
	{
	    try 
	    {
	        MessageDigest digest = MessageDigest.getInstance("SHA-256");
	        byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));	//해쉬반환
	        return Base64.getEncoder().encodeToString(hash);
	    }
	    catch(NoSuchAlgorithmException e)
	    {
	        throw new RuntimeException(e);
	    }
	}
	*/

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getAddrCode() {
		return addrCode;
	}

	public void setAddrCode(String addrCode) {
		this.addrCode = addrCode;
	}

	public String getAddrBase() {
		return addrBase;
	}

	public void setAddrBase(String addrBase) {
		this.addrBase = addrBase;
	}

	public String getAddrDetail() {
		return addrDetail;
	}

	public void setAddrDetail(String addrDetail) {
		this.addrDetail = addrDetail;
	}

	public String getRating() {
		return rating;
	}

	public void setRating(String rating) {
		this.rating = rating;
	}

	public String getFakePwdStatus() {
		return fakePwdStatus;
	}

	public void setFakePwdStatus(String fakePwdStatus) {
		this.fakePwdStatus = fakePwdStatus;
	}
	
	
}