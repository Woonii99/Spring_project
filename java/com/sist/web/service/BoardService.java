package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.common.util.FileUtil;
import com.sist.web.dao.BoardDao;
import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;
import com.sist.web.model.BoardLike;



@Service("boardService")
public class BoardService 
{
private static Logger logger = LoggerFactory.getLogger(BoardService.class);
	
	@Autowired
	private BoardDao BoardDao;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	//게시물 등록
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardInsert(Board board) throws Exception
	{	
		int count = 0;

		count = BoardDao.boardInsert(board);

		if(count > 0 && board.getBoardFile() != null)
		{
			BoardFile boardFile = board.getBoardFile();
			
			boardFile.setBrdSeq(board.getBrdSeq());
			boardFile.setFileSeq((short)1);
			
			BoardDao.boardFileInsert(boardFile);
		}
		
		return count;
	}
	
	//게시물 리스트
	public List<Board> boardList(Board board)
	{
		List<Board> list = null;
		
		try
		{
			list = BoardDao.boardList(board);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] boardList Exception", e);
		}
		
		return list;
	}
	
	//총 게시물 수
	public long boardListCount(Board board)
	{
		long count = 0;
		
		try
		{
			count = BoardDao.boardListCount(board);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] boardListCount Exception", e);
		}
		
		
		
		return count;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//게시물 보기(첨부파일 포함, 조회수 증가 포함)
	public Board boardView(long brdSeq, int boardType)
	{
		Board board = null;
		
		try
		{
			board = BoardDao.boardSelect(brdSeq, boardType);
			
			if(board != null)
			{
				//조회수 증사
				BoardDao.boardReadCntPlus(brdSeq, boardType);
				
				BoardFile boardFile = BoardDao.boardFileSelect(brdSeq, boardType);
				
				if(boardFile != null)
				{
					board.setBoardFile(boardFile);
				}
			}
		}
		catch(Exception e)
		{
			logger.error("[BoardService] boardView Exception", e);
		}
		
		return board;
	}
	
	//게시물 조회
	public Board boardSelect(long brdSeq, int boardType)
	{
		Board board = null;
		
		try
		{
			board = BoardDao.boardSelect(brdSeq, boardType);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] boardSelect Exception", e);
		}
		
		return board;
	}
	
	//게시물 답글 등록
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardReplyInsert(Board board) throws Exception
	{
		int count = 0;
		
		BoardDao.boardGroupOrderUpdate(board);
		
		count = BoardDao.boardReplyInsert(board);
		
		//게시물 답글 정상등록이 되고나면 첨부파일 존재시 첨부파일도 등록
		if(count > 0 && board.getBoardFile() != null)
		{
			BoardFile boardFile = board.getBoardFile();
			boardFile.setBrdSeq(board.getBrdSeq());
			boardFile.setFileSeq((short)1);
			boardFile.setBoardType(board.getBoardType());
			
			BoardDao.boardFileInsert(boardFile);
		}
		
		return count;
	}
	
	//게시물 삭제시 답변글수 조회
	public int boardAnswersCount(long brdSeq, int boardType)
	{
		int count = 0;
	
		try
		{
			count = BoardDao.boardAnswersCount(brdSeq, boardType);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] boardAnswerCount Exception", e);
		}
		
		return count;
	}
	
	//게시물 수정폼 조회(첨부파일 포함)
	public Board boardViewUpdate(long brdSeq, int boardType)
	{
		Board board = null;
		
		try
		{
			board = BoardDao.boardSelect(brdSeq, boardType);
			
			if(board != null)
			{
				BoardFile boardFile = BoardDao.boardFileSelect(brdSeq, boardType);
				
				if(boardFile != null)
				{
					board.setBoardFile(boardFile);
				}
			}
		}
		catch(Exception e)
		{
			logger.error("[BoardService] boardViewUpdate Exception", e);
		}
		
		return board;
	}
	
	//게시물 첨부파일 조회
	public BoardFile boardFileSelect(long brdSeq, int boardType)
	{
		BoardFile boardFile = null;
		
		try
		{
			boardFile = BoardDao.boardFileSelect(brdSeq, boardType);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] boardFileSelect Exception", e);
		}
		
		return boardFile;
	}
	
	//게시물 삭제(첨부파일이 있으면 함께 삭제)
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardDelete(long brdSeq, int boardType) throws Exception
	{
		int count = 0;
		
		Board board = boardViewUpdate(brdSeq, boardType);
		
		if(board != null)
		{
				if(board.getBoardFile() != null)
				{
					if(BoardDao.boardFileDelete(brdSeq, boardType) > 0)
					{
						//첨부파일도 함께 삭제
						FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator()
						+ board.getBoardFile().getFileName());
					}
				}
			
			count = BoardDao.boardDelete(brdSeq, boardType);
		}
		
		return count;
	}
	
	//게시물 수정
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardUpdate(Board board) throws Exception
	{
		int count = 0;
		
		count = BoardDao.boardUpdate(board);
		
		if(count > 0 && board.getBoardFile() != null)
		{
			BoardFile delBoardFile = BoardDao.boardFileSelect(board.getBrdSeq(), board.getBoardType());
			
			//기존 파일이 있으면 삭제
			if(delBoardFile != null)
			{
				FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + delBoardFile.getFileName());
				BoardDao.boardFileDelete(board.getBrdSeq(), board.getBoardType());
			}
			
			BoardFile boardFile = board.getBoardFile();
			boardFile.setBrdSeq(board.getBrdSeq());
			boardFile.setFileSeq((short)1);
			
			BoardDao.boardFileInsert(board.getBoardFile());
		}
		
		return count;
	}
	
	//좋아요 조회
	public BoardLike selectLike(long brdSeq, String userId, int boardType)
	{
		BoardLike boardLike = null;
		
		try
		{
			boardLike = BoardDao.selectLike(brdSeq, userId, boardType);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] selectLike Exception", e);
		}
		
		return boardLike;
	}
	
	//좋아요 증가
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int insertLike(long brdSeq, String userId, int boardType) throws Exception
	{
		int count = 0;
        
        try {
            count = BoardDao.insertLike(brdSeq, userId, boardType);
        } 
        catch (Exception e) 
        {
            logger.error("[BoardService] insertLike Exception", e);
        }
        
        return count;
	}
	
	//좋아요 감소
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int deleteLike(long brdSeq, String userId, int boardType) throws Exception
	{
		int count = 0;
		
		try 
		{
            count = BoardDao.deleteLike(brdSeq, userId, boardType);
        } 
		catch (Exception e) 
		{
            logger.error("[BoardService] deleteLike Exception", e);
        }

		
		return count;
	}
	
	//좋아요 수 조회
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int selectLikeCount(long brdSeq, int boardType)
	{
		int count = 0;
		
		try
		{
			count = BoardDao.selectLikeCount(brdSeq, boardType);
		}
		catch (Exception e) 
		{
            logger.error("[BoardService] selectLikeCount Exception", e);
        }

		return count;
	}
	
}
