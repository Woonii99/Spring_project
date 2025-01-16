package com.sist.web.model;

import java.io.Serializable;

public class Comment implements Serializable
{
	private static final long serialVersionUID = 1L;

	private long commentNum;     	// 댓글 번호
    private long brdSeq;        	// 게시물 번호
    private String content;    	 	// 댓글 내용
    private String userId;      	// 댓글 작성자 ID
    private String regDate;     	// 댓글 작성일
    private long parentNum;      	// 부모 댓글 ID (댓글의 댓글일 경우 해당 댓글 ID)
    private long GroupNum;			// 그룹번호
	private int OrderNum;			// 그룹순서
	private int IndentNum;			// 들여쓰기
	private int BoardType;			// 게시판 타입
	
	
	public Comment()
	{
		commentNum = 0;
	    brdSeq = 0;
	    content = "";
	    userId = "";
	    regDate = "";
	    parentNum = 0;
	    GroupNum = 0;
	    OrderNum = 0;
		IndentNum = 0;
		BoardType = 0;
	}


	public long getCommentNum() {
		return commentNum;
	}


	public void setCommentNum(long commentNum) {
		this.commentNum = commentNum;
	}


	public long getBrdSeq() {
		return brdSeq;
	}


	public void setBrdSeq(long brdSeq) {
		this.brdSeq = brdSeq;
	}


	public String getContent() {
		return content;
	}


	public void setContent(String content) {
		this.content = content;
	}


	public String getUserId() {
		return userId;
	}


	public void setUserId(String userId) {
		this.userId = userId;
	}


	public String getRegDate() {
		return regDate;
	}


	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}


	public long getParentNum() {
		return parentNum;
	}


	public void setParentNum(long parentNum) {
		this.parentNum = parentNum;
	}


	public long getGroupNum() {
		return GroupNum;
	}


	public void setGroupNum(long groupNum) {
		GroupNum = groupNum;
	}


	public int getOrderNum() {
		return OrderNum;
	}


	public void setOrderNum(int orderNum) {
		OrderNum = orderNum;
	}


	public int getIndentNum() {
		return IndentNum;
	}


	public void setIndentNum(int indentNum) {
		IndentNum = indentNum;
	}


	public int getBoardType() {
		return BoardType;
	}


	public void setBoardType(int boardType) {
		BoardType = boardType;
	}

	
	
	
}
