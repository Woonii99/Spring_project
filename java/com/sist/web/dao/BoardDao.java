package com.sist.web.dao;


import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;
import com.sist.web.model.BoardLike;


@Repository("boardDao")
public interface BoardDao
{
	//게시물 등록
	public int boardInsert(Board board);
	
	//게시물 첨부파일 등록
	public int boardFileInsert(BoardFile boardFile);
	
	//게시물 리스트
	public List<Board> boardList(Board board);
	
	//게시물 총수
	public long boardListCount(Board board);
	
	//게시물 보기
	public Board boardSelect(@Param("brdSeq") long brdSeq, @Param("boardType") int boardType);
	
	//첨부파일 조회
	public BoardFile boardFileSelect(@Param("brdSeq") long brdSeq, @Param("boardType") int boardType);
	
	//조회수 증가
	public int boardReadCntPlus(@Param("brdSeq") long brdSeq, @Param("boardType") int boardType);

	//게시물 그룹내 순서 변경
	public int boardGroupOrderUpdate(Board board);
	
	//게시물 답글 등록
	public int boardReplyInsert(Board board);
	
	//게시물 삭제시 답변글수 조회
	public int boardAnswersCount(@Param("brdParent") long brdParent, @Param("boardType") int boardType);
	
	//게시물 삭제
	public int boardDelete(@Param("brdSeq") long brdSeq, @Param("boardType") int boardType);
	
	//게시물 첨부파일 삭제
	public int boardFileDelete(@Param("brdSeq") long brdSeq, @Param("boardType") int boardType);
	
	//게시물 수정
	public int boardUpdate(Board board);
	
	// 좋아요 조회
    public BoardLike selectLike(@Param("brdSeq") long brdSeq, @Param("userId") String userId, @Param("boardType") int boardType);
    
    // 좋아요 추가
    public int insertLike(@Param("brdSeq") long brdSeq, @Param("userId") String userId, @Param("boardType") int boardType);
    
    // 좋아요 삭제
    public int deleteLike(@Param("brdSeq") long brdSeq, @Param("userId") String userId, @Param("boardType") int boardType);
    
    //좋아요 수 조회
    public int selectLikeCount(@Param("brdSeq") long brdSeq, @Param("boardType") int boardType);
   

	
}
