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
import com.sist.web.model.Comment;
import com.sist.web.model.Response;
import com.sist.web.service.CommentService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("CommentController")
public class CommentController 
{
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Autowired
	private CommentService commentService;
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	
	//댓글 등록
	@RequestMapping(value="/writeProc/comment", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProcComment(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		String content = HttpUtil.get(request, "content", "");
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			Comment comment = new Comment();
			
			comment.setUserId(cookieUserId);
			comment.setContent(content);
			comment.setBoardType(boardType);
			comment.setBrdSeq(brdSeq);

			try
			{
				if(commentService.commentInsert(comment) > 0)
				{
					List<Comment> searchCmt = commentService.commentSelect(brdSeq, boardType);
					ajaxResponse.setResponse(0, "success", searchCmt);
				}
				else
				{
					ajaxResponse.setResponse(500, "internal server error");
				}
			}
			catch(Exception e)
			{
				logger.error("[CommentController] writeProcComment Exception", e);
				ajaxResponse.setResponse(500, "internal server error2");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "bad request");
		}
		
		return ajaxResponse;
	}
	
	//댓글 삭제
	@RequestMapping(value="/delete/comment", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		long commentNum = HttpUtil.get(request, "commentNum", (long)0);
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		logger.debug("----------------------------------");
		logger.debug(brdSeq + "zzz" + commentNum + "zzz" + boardType);
		logger.debug("----------------------------------");
		
		if(brdSeq > 0)
		{
			Comment comment = commentService.comment1Select(brdSeq, boardType, commentNum);
			
			if(comment != null)
			{
				if(StringUtil.equals(cookieUserId, comment.getUserId()))
				{
					Comment delete = new Comment();
					
					delete.setBoardType(boardType);
					delete.setBrdSeq(brdSeq);
					delete.setCommentNum(commentNum);
					delete.setGroupNum(comment.getGroupNum());
					
					if(comment.getParentNum() == 0)
					{
						try
						{
							if(commentService.commentDeleteGroup(delete) > 0)
							{
								List<Comment> searchCmt = commentService.commentSelect(brdSeq, boardType);
								ajaxResponse.setResponse(0, "success", searchCmt);
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
					else
					{
						try
						{
							if(commentService.commentDelete(delete) > 0)
							{
								List<Comment> searchCmt = commentService.commentSelect(brdSeq, boardType);
								ajaxResponse.setResponse(0, "success", searchCmt);
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
			}	
		}
		return ajaxResponse;
	}
	
	//댓글에 대댓글
	@RequestMapping(value="/replyProc/comment", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> replyProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long)0);
		long commentNum = HttpUtil.get(request, "commentNum", (long)0);
		String content = HttpUtil.get(request, "content", "");
		int boardType = HttpUtil.get(request, "boardType", 1);
		
		if(brdSeq > 0 && !StringUtil.isEmpty(commentNum) && !StringUtil.isEmpty(content))
		{
			List<Comment> searchComment = commentService.commentSelect(brdSeq, boardType);
			
			Comment parent = new Comment();
			
			for(int i = 0; i <= searchComment.size(); i++)
			{
				if(commentNum == searchComment.get(i).getCommentNum())
				{
					parent = searchComment.get(i);
					break;
				}
			}
			
			if(parent != null)
			{
				Comment comment = new Comment();
				
				comment.setUserId(cookieUserId);
				comment.setContent(content);
				comment.setGroupNum(parent.getGroupNum());
				comment.setOrderNum(parent.getOrderNum() + 1);
				comment.setIndentNum(parent.getIndentNum() +1);
				comment.setParentNum(commentNum);
				comment.setBrdSeq(brdSeq);
				comment.setBoardType(boardType);
				try
				{
					if(commentService.commentReplyInsert(comment) > 0)
					{
						List<Comment> searchCmt = commentService.commentSelect(brdSeq, boardType);
						ajaxResponse.setResponse(0, "success", searchCmt);
					}
					else
					{
						ajaxResponse.setResponse(500, "internal server error2");
					}
				}
				catch(Exception e)
				{
					logger.error("[CommentController] replyProc Exception", e);
					ajaxResponse.setResponse(500, "internal server error");
				}
				
			}
			else
			{
				//부모댓글이 없을 경우
				ajaxResponse.setResponse(404, "not found");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "bad request");
		}
		
		return ajaxResponse;
	}
		
		
}
