package com.sist.web.model;

import java.io.Serializable;

public class Board implements Serializable
{
	private static final long serialVersionUID = 1L;

	private long brdSeq;				//게시물 번호
	private String userId;				//아이디
	private long brdGroup;				//그룹번호
	private int brdOrder;				//그룹순서
	private int brdIndent;				//들여쓰기
	private String brdTitle;			//게시물 제목
	private String brdContent;			//게시물 내용
	private int brdReadCnt;				//게시물 조회수
	private String regDate;				//게시물 등록일
	private long brdParent;				//부모게시물 번호
	private String modDate;				//수정일
	
	private String userName;			//사용자명
	private String userEmail;			//사용자 이메일
	
	private String searchType;			//검색타입 (1:이름, 2:제목, 3:내용)
	private String searchValue;			//검샏 값
	
	private long startRow;				//시작페이지 rownum
	private long endRow;				//끝페이지 rownum
	
	private BoardFile BoardFile;		//첨부파일
	private BoardLike BoardLike;		//좋아요	
	private int BoardType;				//게시판 타입
	
	public Board()
	{
		brdSeq = 0;
		userId = "";
		brdGroup = 0;
		brdOrder = 0;
		brdIndent = 0;
		brdTitle = "";
		brdContent = "";
		brdReadCnt = 0;
		regDate = "";
		brdParent = 0;
		modDate = "";
		
		userName = "";
		userEmail = "";
		
		searchType = "";
		searchValue = "";
		
		startRow = 0;
		endRow = 0;
		
		BoardFile = null;
		BoardType = 0;
	}

	public long getBrdSeq() {
		return brdSeq;
	}

	public void setBrdSeq(long brdSeq) {
		this.brdSeq = brdSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getBrdGroup() {
		return brdGroup;
	}

	public void setBrdGroup(long brdGroup) {
		this.brdGroup = brdGroup;
	}

	public int getBrdOrder() {
		return brdOrder;
	}

	public void setBrdOrder(int brdOrder) {
		this.brdOrder = brdOrder;
	}

	public int getBrdIndent() {
		return brdIndent;
	}

	public void setBrdIndent(int brdIndent) {
		this.brdIndent = brdIndent;
	}

	public String getBrdTitle() {
		return brdTitle;
	}

	public void setBrdTitle(String brdTitle) {
		this.brdTitle = brdTitle;
	}

	public String getBrdContent() {
		return brdContent;
	}

	public void setBrdContent(String brdContent) {
		this.brdContent = brdContent;
	}

	public int getBrdReadCnt() {
		return brdReadCnt;
	}

	public void setBrdReadCnt(int brdReadCnt) {
		this.brdReadCnt = brdReadCnt;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public long getBrdParent() {
		return brdParent;
	}

	public void setBrdParent(long brdParent) {
		this.brdParent = brdParent;
	}

	public String getModDate() {
		return modDate;
	}

	public void setModDate(String modDate) {
		this.modDate = modDate;
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

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}

	public BoardFile getBoardFile() {
		return BoardFile;
	}

	public void setBoardFile(BoardFile boardFile) {
		BoardFile = boardFile;
	}

	public int getBoardType() {
		return BoardType;
	}

	public void setBoardType(int boardType) {
		BoardType = boardType;
	}

	public BoardLike getBoardLike() {
		return BoardLike;
	}

	public void setBoardLike(BoardLike boardLike) {
		BoardLike = boardLike;
	}
	
	
}
