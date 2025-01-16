package com.sist.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;
import com.sist.web.model.BoardLike;
import com.sist.web.model.Comment;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.BoardService;
import com.sist.web.service.CommentService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("boardController")
public class BoardController 
{
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);

	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private CommentService commentService;
	
	@Autowired
	private BoardService BoardService;
	
	private static final int LIST_COUNT = 8;		//한 페이지의 게시물 수
	private static final int PAGE_COUNT = 3;		//페이징 수
	
    // 게시물 종류 별 타이틀
   public String brdTitle(int boardType) 
   {
      if (boardType == 1)
         return "공지사항";
      else if (boardType == 2)
         return "자유게시판";
      else if (boardType == 3)
         return "전시게시판";
      else if (boardType == 4)
         return "문의사항";
      else
         return "그외";
   }
	
	// ========================================================================================================================================================================================================
	// 게시글 목록 화면
	@RequestMapping(value = "/board/list")
	public String list(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		long brdSeq = HttpUtil.get(request,  "brdSeq", (long)0);
		String searchType = HttpUtil.get(request,  "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		//총 게시물 수
		long totalCount = 0;
		//게시물 리스트
		List<Board> list = null;
		//조회 객체
		Board search = new Board();
		//페이징 객체
		Paging paging = null;
		
		if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
		{
			search.setSearchType(searchType);
			search.setSearchValue(searchValue);
		}
		search.setBoardType(boardType);
		totalCount = BoardService.boardListCount(search);
		
		if(totalCount > 0)
		{
			paging = new Paging("/board/list", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
		
			list = BoardService.boardList(search);
			
			for(int i = 0; i < list.size(); i++)
			{
				BoardFile boardFile = BoardService.boardFileSelect(list.get(i).getBrdSeq(), boardType);
				list.get(i).setBoardFile(boardFile);
			}
		}
		
		model.addAttribute("boardTitle", brdTitle(boardType));
		model.addAttribute("boardType", boardType);
		
		model.addAttribute("list", list);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);

		return "/board/list";
	}
	
	//게시판 등록 화면
	@RequestMapping(value="/board/writeForm")
	public String WriteForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String searchType = HttpUtil.get(request, "searchType");
		String searchValue = HttpUtil.get(request, "searchValue");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		User user = userService.userSelect(cookieUserId);
		
		model.addAttribute("user", user);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		model.addAttribute("boardTitle", brdTitle(boardType));
		model.addAttribute("boardType", boardType);

		return "/board/writeForm";
	}
	
	//게시물 등록(ajax통신)
	@RequestMapping(value="/board/writeProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String brdTitle = HttpUtil.get(request, "brdTitle", "");
		String brdContent = HttpUtil.get(request, "brdContent", "");
		FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		logger.debug(brdTitle + "-------------------------" + brdContent + "+=====" + boardType);
		
		if(!StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent))
		{
			Board Board = new Board();
			
			Board.setUserId(cookieUserId);
			Board.setBrdTitle(brdTitle);
			Board.setBrdContent(brdContent);
			Board.setBoardType(boardType);

			
			if(fileData != null && fileData.getFileSize() >0)
			{
				BoardFile BoardFile = new BoardFile();
				
				BoardFile.setFileName(fileData.getFileName());
				BoardFile.setFileOrgName(fileData.getFileOrgName());
				BoardFile.setFileExt(fileData.getFileExt());
				BoardFile.setFileSize(fileData.getFileSize());
				BoardFile.setBoardType(boardType);
				
				Board.setBoardFile(BoardFile);
			}
			
			
			try
			{
				if(BoardService.boardInsert(Board) > 0)
				{
					ajaxResponse.setResponse(0, "success", boardType);	
				}
				else
				{
					ajaxResponse.setResponse(500, "internal server error");
				}
			}
			catch(Exception e)
			{
				logger.error("[BoardController] writeProc Exception", e);
				ajaxResponse.setResponse(500, "internal server error2");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "bad request");
		}
		
		return ajaxResponse;
	}
	
	//게시물 상세 조회
	@RequestMapping(value="/board/view")
	public String view(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		String boardMe = "N";
		
		Board board = null;
		
		int boardLikeCount = BoardService.selectLikeCount(brdSeq, boardType); 
		
		if(brdSeq > 0)
		{
			board = BoardService.boardView(brdSeq, boardType);

			
			if(board != null && StringUtil.equals(board.getUserId(), cookieUserId))
			{
				boardMe = "Y";
			}
		}
		
		Board search = new Board();
		search.setBoardType(boardType);
		search.setBrdSeq(brdSeq);
		List<Board> list = BoardService.boardList(search);
		List<Comment> comment = commentService.commentSelect(brdSeq, boardType);
		
		for(int i = 0; i < list.size(); i++)
		{
			BoardFile boardFile = BoardService.boardFileSelect(list.get(i).getBrdSeq(), boardType);
			list.get(i).setBoardFile(boardFile);
		}
		
		model.addAttribute("brdSeq", brdSeq);
		model.addAttribute("board", board);
		model.addAttribute("boardMe", boardMe);		
		model.addAttribute("searchType", searchType);		
		model.addAttribute("searchValue", searchValue);		
		model.addAttribute("curPage", curPage);
		model.addAttribute("boardTitle", brdTitle(boardType));
		model.addAttribute("boardType", boardType);
		model.addAttribute("boardLikeCount", boardLikeCount);
		model.addAttribute("list", list);
		model.addAttribute("comment", comment);
		model.addAttribute("cookieUserId", cookieUserId);
		
		logger.debug("=zzzzzzzz==============================");
		logger.debug("comment :" + comment);
		logger.debug("===============================");
		
		return "/board/view";
	}
			
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//게시물 답변 화면
	@RequestMapping(value="/board/replyForm", method=RequestMethod.POST)
	public String replyForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		Board board = null;
		User user = null;
		
		if(brdSeq > 0)
		{
			board = BoardService.boardSelect(brdSeq, boardType);
			
			if(board != null)
			{
				user = userService.userSelect(cookieUserId);
			}
		}
		
		model.addAttribute("board", board);
		model.addAttribute("user", user);		
		model.addAttribute("searchType", searchType);		
		model.addAttribute("searchValue", searchValue);		
		model.addAttribute("curPage", curPage);
		model.addAttribute("brdSeq", brdSeq);
		model.addAttribute("boardTitle", brdTitle(boardType));
		model.addAttribute("boardType", boardType);
		
		return "/board/replyForm";
	}
	
	//게시물 답변
	@RequestMapping(value="/board/replyProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> replyProc(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		String brdTitle = HttpUtil.get(request, "brdTitle", "");
		String brdContent = HttpUtil.get(request, "brdContent", "");
		FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		if(brdSeq > 0 && !StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent))
		{
			Board parentBoard = BoardService.boardSelect(brdSeq, boardType);
			
			if(parentBoard != null)
			{
				Board board = new Board();
				
				board.setUserId(cookieUserId);
				board.setBrdTitle(brdTitle);
				board.setBrdContent(brdContent);
				board.setBrdGroup(parentBoard.getBrdGroup());
				board.setBrdOrder(parentBoard.getBrdOrder() + 1);
				board.setBrdIndent(parentBoard.getBrdIndent() +1);
				board.setBrdParent(brdSeq);
				board.setBoardType(boardType);
				
				if(fileData != null && fileData.getFileSize() > 0)
				{
					BoardFile boardFile = new BoardFile();
					
					boardFile.setFileName(fileData.getFileName());
					boardFile.setFileOrgName(fileData.getFileOrgName());
					boardFile.setFileExt(fileData.getFileExt());
					boardFile.setFileSize(fileData.getFileSize());
					
					board.setBoardFile(boardFile);
				}
				
				try
				{
					if(BoardService.boardReplyInsert(board) > 0)
					{
						ajaxResponse.setResponse(0, "success");
					}
					else
					{
						ajaxResponse.setResponse(500, "internal server error2");
					}
				}
				catch(Exception e)
				{
					logger.error("[BoardController] replyProc Exception", e);
					ajaxResponse.setResponse(500, "internal server error");
				}
				
			}
			else
			{
				//부모글이 없을 경우
				ajaxResponse.setResponse(404, "not found");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "bad request");
		}
		
		return ajaxResponse;
	}
	
	//게시물 삭제
	@RequestMapping(value="/board/delete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete(HttpServletRequest request, HttpServletResponse response)
	{
		logger.debug("=-=-=-=-=-=-");
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		if(brdSeq > 0)
		{
			Board board = BoardService.boardSelect(brdSeq, boardType);
			logger.debug(board.getBrdSeq() + board.getBoardType() +"");
			if(board != null)
			{
				if(StringUtil.equals(cookieUserId, board.getUserId()))
				{
					if(boardType == 2)
					{
						//답글 존재 확인
						if(BoardService.boardAnswersCount(brdSeq, boardType) > 0)
						{
						//답글이 있을경우 삭제 불가능하도록 처리
						ajaxResponse.setResponse(-999, "answers exist and annot be deleted");
						}
					}
					if(BoardService.boardAnswersCount(brdSeq, boardType) <= 0)
					{
						try
						{
							if(BoardService.boardDelete(brdSeq, boardType) > 0)
							{
								ajaxResponse.setResponse(0, "success");
							}
							else
							{
								ajaxResponse.setResponse(500, "service error2");
							}
						}
						catch(Exception e)
						{
							logger.error("[BoardController] delete Exception", e);
							ajaxResponse.setResponse(500, "service error1");
						}
					}
				}
				else
				{
					//내 글이 아닐때
					ajaxResponse.setResponse(403, "service error");
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "not found");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "bad request");
		}
		
		return ajaxResponse;
	}
	
	//게시물 수정 화면
	@RequestMapping(value="/board/updateForm")
	public String updateForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		Board board = null;
		
		if(brdSeq > 0)
		{
			board = BoardService.boardViewUpdate(brdSeq, boardType);
			
			if(board != null)
			{
				if(!StringUtil.equals(board.getUserId(), cookieUserId))
				{
					//내글이 아닌 경우 수정 불가능하도록 처리
					board = null;
				}
			}
		}
		
		model.addAttribute("searchType", searchType);
		model.addAttribute("brdSeq", brdSeq);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("Board", board);
		model.addAttribute("boardTitle", brdTitle(boardType));
		model.addAttribute("boardType", boardType);
		
		return "/board/updateForm";
	}
	
	//게시물 수정
	@RequestMapping(value="/board/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		String brdTitle = HttpUtil.get(request, "brdTitle", "");
		String brdContent = HttpUtil.get(request, "brdContent", "");
		FileData fileData = HttpUtil.getFile(request, "boardFile", UPLOAD_SAVE_DIR);
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		if(brdSeq > 0 && !StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent))
		{
			Board board = BoardService.boardSelect(brdSeq, boardType);
			
			if(board != null)
			{
				if(StringUtil.equals(board.getUserId(), cookieUserId))
				{
					board.setBrdTitle(brdTitle);
					board.setBrdContent(brdContent);
					board.setBoardType(boardType);
					board.setBrdSeq(brdSeq);
					
					if(fileData != null && fileData.getFileSize() > 0)
					{
						BoardFile boardFile = new BoardFile();
						
						boardFile.setFileName(fileData.getFileName());
						boardFile.setFileOrgName(fileData.getFileOrgName());
						boardFile.setFileExt(fileData.getFileExt());
						boardFile.setFileSize(fileData.getFileSize());
						
						board.setBoardFile(boardFile);
					}
					
					try
					{
						if(BoardService.boardUpdate(board) > 0)
						{
							ajaxResponse.setResponse(0, "success");
						}
						else
						{
							ajaxResponse.setResponse(500, "internal server error2");
						}
					}
					catch(Exception e)
					{
						logger.error("[BoardController] updateProc Exception", e);
						ajaxResponse.setResponse(500, "internal server error");
					}
				}
				else
				{
					ajaxResponse.setResponse(403, "server error");
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "not found");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "bad request");
		}
		
		
		return ajaxResponse;
	}
	
	 // 좋아요 처리
    @RequestMapping(value = "/board/like", method = RequestMethod.POST)
    @ResponseBody
    public Response<Object> like(HttpServletRequest request, HttpServletResponse response) {
    	Response<Object> ajaxResponse = new Response<Object>();
    	
    	BoardLike boardLike = new BoardLike();
    	
        String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
        
        long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
        int boardType = HttpUtil.get(request, "boardType", 0);
        
        logger.debug(brdSeq + "|||||" + boardType);

        if (brdSeq > 0 && boardType > 0) 
        {
            try 
            {
                boardLike = BoardService.selectLike(brdSeq, cookieUserId, boardType);
                
                
                if (boardLike != null) 
                {
                    BoardService.deleteLike(brdSeq, cookieUserId, boardType);
                    int boardLikeCount = BoardService.selectLikeCount(brdSeq, boardType);
                    ajaxResponse.setResponse(201, "succes(-)", boardLikeCount); 

                } 
                else 
                {
                	BoardService.insertLike(brdSeq, cookieUserId, boardType);
                    int boardLikeCount = BoardService.selectLikeCount(brdSeq, boardType);
                	ajaxResponse.setResponse(200, "succes(+)", boardLikeCount);
                }
            } 
            catch (Exception e) 
            {
                logger.error("[BoardController] like Exception", e);
            }
        } 
        else 
        {
        	ajaxResponse.setResponse(500, "bad request");
        }

        return ajaxResponse;
    }
    
    
}

