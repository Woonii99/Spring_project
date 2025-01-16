package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Board;
import com.sist.web.model.Comment;

@Repository("CommentDao")
public interface CommentDao 
{
	//댓글 리스트 조회
	public List<Comment> commentSelect(@Param("brdSeq") long brdSeq, @Param("boardType") int boardType);

	//댓글 삭제 조회
	public Comment comment1Select(@Param("brdSeq") long brdSeq, @Param("boardType") int boardType, @Param("commentNum") long commentNum);
	
	//댓글 등록
	public int commentInsert(Comment comment);
	
	//댓글 삭제
	public int commentDelete(Comment comment);
	
	//그룹 댓글 삭제
	public int commentDeleteGroup(Comment comment);
	
	//댓글 그룹내 순서 변경
	public int commentGroupOrderUpdate(Comment comment);
	
	//게시물 답글 등록
	public int commentReplyInsert(Comment comment);
}
