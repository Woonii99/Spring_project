<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/navigation.css" type="text/css">
<link rel="stylesheet" href="/resources/css/footer.css" type="text/css">
<link rel="stylesheet" href="/resources/css/board.css" type="text/css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script type="text/javascript">
   $(document).ready(function() {
      // 햄버거 버튼 클릭 이벤트
      $('nav ul li a img[alt="햄버거버튼"]').on('click', function(event) {
         event.preventDefault();
         $("#test").toggle();
      });

      // 메뉴 외부를 클릭했을 때 드롭다운 메뉴 숨기기
      $(document).on('click', function(event) {
         if (!$(event.target).closest('nav').length) {
            $("#test").hide();
         }
      });

      //좋아요 버튼 클릭 시
      $("#recomBtn").on("click", function() {
    		
          $.ajax({
              url: "/board/like",
              type: "POST",
              data: {
                  brdSeq: $("#brdSeq").val(),
                  boardType: $("#boardType").val()
              },
              datatype:"JSON",
              success: function(response) 
              {
              	  if(response.code === 201)
              	  {
              		  alert("좋아요가 감소했습니다.");
              		  document.getElementById("recomBtn").innerHTML = "좋아요 :" + response.data;
              	  }
            	  else if (response.code === 200) 
                  {
                      alert("좋아요가 증가했습니다.");
                      document.getElementById("recomBtn").innerHTML = "좋아요 :" + response.data;
                  } 
                  else if (response.code === 404) 
                  {
                      alert("찾으시는 게시물이 없습니다.");
                  } 
                  else 
                  {
                	  alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.(500)");
                  }
              },
              error: function(xhr, status, error) 
              {
                  alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
              }
          });
      });
      
      //답글 버튼 클릭 시
      $("#writeBtn").on("click", function() {
    	  document.bbsForm.action = "/board/replyForm";
  		document.bbsForm.submit();
      });
      
<c:if test="${boardMe eq 'Y'}">
   
      //수정 버튼 클릭 시
      $("#updateBtn").on("click", function() {
    	document.bbsForm.boardType.value = ${boardType};
    	document.bbsForm.brdSeq.value = ${brdSeq};
		document.bbsForm.curPage.value = ${curPage};
    	document.bbsForm.action = "/board/updateForm";
  		document.bbsForm.submit();
      });

      //삭제 버튼 클릭 시
      $("#deleteBtn").on("click", function() {
    	  if(confirm("해당 게시물을 삭제 하시겠습니까?") == true)
  		{
  			$.ajax({
  				type:"POST",
  				url:"/board/delete",
  				data:{
  					brdSeq:<c:out value="${brdSeq}" />,
  					boardType:<c:out value="${boardType}" />
  				},
  				datatype:"JSON",
  				beforeSend:function(xhr)
  				{
  					xhr.setRequestHeader("AJAX", "true");
  				},
  				success:function(response)
  				{
  					if(response.code == 0)
  					{
  						Swal.fire({
  						   title: '게시물이 삭제 되었습니다.',
  						   icon: 'success',
  						   
  						   showCancelButton: false,
  						   showconfirmButton: true,
  						   confirmButtonColor: '#3085d6',  
  						   confirmButtonText: '확인',
  						}).then(result => {
  						location.href = "/board/list";
  						});
  					}
  					else if(response.code == 400)
  					{
  						Swal.fire({
  						   title: '파라미터 값이 올바르지 않습니다.',
  						   icon: 'warning',
  						   
  						   showCancelButton: false,
  						   showconfirmButton: true,
  						   confirmButtonColor: '#3085d6',  
  						   confirmButtonText: '확인',
  						});
  					}
  					else if(response.code == 403)
  					{
  						Swal.fire({
  						   title: '본인글만 수정 가능합니다.',
  						   icon: 'warning',
  						   
  						   showCancelButton: false,
  						   showconfirmButton: true,
  						   confirmButtonColor: '#3085d6',  
  						   confirmButtonText: '확인',
  						});
  					}
  					else if(response.code == 404)
  					{
  						Swal.fire({
  						   title: '해당 게시물을 찾을수 없습니다.',
  						   icon: 'warning',
  						   
  						   showCancelButton: false,
  						   showconfirmButton: true,
  						   confirmButtonColor: '#3085d6',  
  						   confirmButtonText: '확인',
  						}).then(result => {
  								location.href = "/board/list";
  						});
  					}
  					else if(response.code == -999)
  					{
  						Swal.fire({
  						   title: '답변 게시물이 존재하여 삭제할수 없습니다.',
  						   icon: 'warning',
  						   
  						   showCancelButton: false,
  						   showconfirmButton: true,
  						   confirmButtonColor: '#3085d6',  
  						   confirmButtonText: '확인',
  						});
  					}
  					else
  					{
  						Swal.fire({
  						   title: '게시물 삭제시 오류가 발생하였습니다.',
  						   icon: 'warning',
  						   
  						   showCancelButton: false,
  						   showconfirmButton: true,
  						   confirmButtonColor: '#3085d6',  
  						   confirmButtonText: '확인',
  						});
  					}
  				},
  				error:function(xhr, status, error)
  				{
  					icia.common.error(error);
  				}
  			});
  		}
    	document.bbsForm.boardType.value = boardType;  
  		document.bbsForm.action = "/board/list";
  		document.bbsForm.submit();
     });
      
</c:if>

      //목록 버튼 클릭 시
      $("#listBtn").on("click", function() {
    	  document.bbsForm.boardType.value = ${boardType};
          document.bbsForm.action = "/board/list";
          document.bbsForm.submit();
      });
      
      //댓글 작성 버튼 클릭 시
      $("#comBtn").on("click", function() {
    	
    	  if ($.trim($("#commentT").val()).length <= 0)
  		{
  		   
    		  Swal.fire({
				   title: '내용을 입력하세요.',
				   icon: 'warning',
				   
				   showCancelButton: false,
				   showconfirmButton: true,
				   confirmButtonColor: '#3085d6',  
				   confirmButtonText: '확인',
				});
  		   $("#commentT").val("");
  		   $("#commentT").focus();
  		   return;
  		} 
    	  
    	  $.ajax({
  			type:"POST",
  			url:"/writeProc/comment",
  			data:{
  				brdSeq:$("#brdSeq").val(),
  				boardType:$("#boardType").val(),
  				content:$("#commentT").val()
  			},
  			datatype:"JSON",
  			beforeSend:function(xhr){
  				xhr.setRequestHeader("AJAX", "true");
  			},
  			success:function(response){
  				if(response.code === 0)
				{
					Swal.fire({
						   title: '댓글등록이 완료되었습니다.',
						   icon: 'success',
						   
						   showCancelButton: false,
						   showconfirmButton: true,
						   confirmButtonColor: '#3085d6',  
						   confirmButtonText: '확인',
						});
					
					$("#commentT").val("").focus();
	                
	                var newCommentsHTML = '';
	                
	                for (var i = 0; i < response.data.length; i++) 
					{
	                	var comment = response.data[i];
		                	newCommentsHTML += 
	                        '<div class="com-item-container" style="clear:both;">' +
	                           '<div class="com-info">';
	                    if (comment.IndentNum > 0)
	       		        {
	                    	newCommentsHTML += 
	                    	'<img src="/resources/images/icon_reply.gif" style="margin-left:' + comment.IndentNum + 'em" />';  
	       		        }
	                           newCommentsHTML +=    
	                    		'<span class="com-user">' + comment.userId + '</span> | <span class="com-date">' + comment.regDate + '</span>' +
	                           '</div>' +
	                           '<div class="com-content">' +
	                              '<pre style="margin-left:' + comment.IndentNum + 'em">' + comment.content + '</pre>' +
	                           '</div>' +
	                           '<div class="com-reply-add">' +
	                              '<span onClick=fn_comcom(' + comment.commentNum + ')>답글 달기</span><span class="com-delt" onClick=fn_comDel(' + comment.commentNum + ')> | 삭제 </span>' +
	                           '</div>' +
	                           '<div class="com-reply" id="comcomWrite' + comment.commentNum + '" style="clear:both;">' +
	                              '<input type="text" id="comContent' + comment.commentNum + '" class="com-reply-input" placeholder="내용을 입력하세요">' +
	                              '<input type="button" onClick=fn_comWBtn(' + comment.commentNum +') class="com-reply-btn" value="답글 작성" style="background: #604f47;">' +
	                           '</div>' +
	                           '<input type="hidden" id="commentNum"  value="' + comment.commentNum + '">' +
	                        '</div>';
					}
	                
	                document.getElementById("commentRe").innerHTML = newCommentsHTML;
	             	/*
	                // 새 댓글 추가
	                var newComment = 
	                   '<div class="com-item-container" style="clear:both;">' +
	                      '<div class="com-info">' +
	                         '<span class="com-user">' + response.data.userId + '</span> ' +
	                         '<span class="com-date">' + response.data.regDate +'</span>' +
	                      '</div><div class="com-content">' +
	                         '<pre>' + response.data.content + '</pre>' +
	                      '</div></div>'
	                ;
	                // 댓글 리스트에 새 댓글 추가
	                $(".comment-list-container").prepend(newComment);
					*/
				}

  				if(response.code === 500)
				{
					Swal.fire({
						   title: '댓글등록중 오류가 발생하였습니다.',
						   icon: 'warning',
						   
						   showCancelButton: false,
						   showconfirmButton: true,
						   confirmButtonColor: '#3085d6',  
						   confirmButtonText: '확인',
						});
				}
  				if(response.code === 400)
				{
					Swal.fire({
						   title: '로그인 후 이용가능합니다.',
						   icon: 'warning',
						   
						   showCancelButton: false,
						   showconfirmButton: true,
						   confirmButtonColor: '#3085d6',  
						   confirmButtonText: '확인',
						});
				}
  			},
  			error:function(xhr, status, error)
  			{
  				icia.common.error(error);
  			}
  			});
   		});

   });
   
   	//대댓글 작성 버튼 클릭 시
   	function fn_comWBtn(comcomSeq)
   	{
     		if ($.trim($("#comContent" + comcomSeq).val()).length <= 0)
   		{
   		   
     		  Swal.fire({
 				   title: '내용을 입력하세요.',
 				   icon: 'warning',
 				   
 				   showCancelButton: false,
 				   showconfirmButton: true,
 				   confirmButtonColor: '#3085d6',  
 				   confirmButtonText: '확인',
 				});
   		   $("#comContent" + comcomSeq).val("");
   		   $("#comContent" + comcomSeq).focus();
   		   return;
   		}
     		
     		$.ajax({
     			type:"POST",
     			url:"/replyProc/comment",
     			data:{
     				brdSeq:$("#brdSeq").val(),
     				boardType:$("#boardType").val(),
     				content:$("#comContent" + comcomSeq).val(),
     				commentNum:comcomSeq
     			},
     			datatype:"JSON",
     			beforeSend:function(xhr){
     				xhr.setRequestHeader("AJAX", "true");
     			},
     			success:function(response)
     			{
     				if(response.code === 0)
   				{
     					Swal.fire({
   						   title: '대댓글이 작성되었습니다.',
   						   icon: 'success',
   						   
   						   showCancelButton: false,
   						   showconfirmButton: true,
   						   confirmButtonColor: '#3085d6',  
   						   confirmButtonText: '확인',
   						});
     					
     					$("#commentT").val("").focus();
   	                
   	                var newCommentsHTML = '';
   	                
   	                for (var i = 0; i < response.data.length; i++) 
   					{
   	                	var comment = response.data[i];
   		                	newCommentsHTML += 
   	                        '<div class="com-item-container" style="clear:both;">' +
   	                           '<div class="com-info">';
   	                        if (comment.IndentNum > 0)
   		       		        {
   		                    	newCommentsHTML += 
   		                    	'<img src="/resources/images/icon_reply.gif" style="margin-left:' + comment.IndentNum + 'em" />';  
   		       		        }
   	                       		 newCommentsHTML += 
   	                              '<span class="com-user">' + comment.userId + '</span> | <span class="com-date">' + comment.regDate + '</span>' +
   	                           '</div>' +
   	                           '<div class="com-content">' +
   	                              '<pre style="margin-left:' + comment.IndentNum + 'em">' + comment.content + '</pre>' +
   	                           '</div>' +
   	                           '<div class="com-reply-add">' +
   	                              '<span onClick=fn_comcom(' + comment.commentNum + ')>답글 달기</span><span class="com-delt" onClick=fn_comDel(' + comment.commentNum + ')> | 삭제 </span>' +
   	                           '</div>' +
   	                           '<div class="com-reply" id="comcomWrite' + comment.commentNum + '" style="clear:both;">' +
   	                              '<input type="text" id="comContent' + comment.commentNum + '" class="com-reply-input" placeholder="내용을 입력하세요">' +
   	                              '<input type="button" onClick=fn_comWBtn(' + comment.commentNum +') class="com-reply-btn" value="답글 작성" style="background: #604f47;">' +
   	                           '</div>' +
   	                           '<input type="hidden" id="commentNum"  value="' + comment.commentNum + '">' +
   	                        '</div>';
   					}
   	                
   	                document.getElementById("commentRe").innerHTML = newCommentsHTML;
   				}
     				if(response.code === 500)
   				{
   					Swal.fire({
   						   title: '대댓글등록중 오류가 발생하였습니다.',
   						   icon: 'warning',
   						   
   						   showCancelButton: false,
   						   showconfirmButton: true,
   						   confirmButtonColor: '#3085d6',  
   						   confirmButtonText: '확인',
   						});
   				}
     				
     				if(response.code === 404)
   				{
   					Swal.fire({
   						   title: '원글이 없습니다.',
   						   icon: 'warning',
   						   
   						   showCancelButton: false,
   						   showconfirmButton: true,
   						   confirmButtonColor: '#3085d6',  
   						   confirmButtonText: '확인',
   						});
   				}
     				
     				if(response.code === 400)
   				{
   					Swal.fire({
   						   title: '게시글이 없습니다.',
   						   icon: 'warning',
   						   
   						   showCancelButton: false,
   						   showconfirmButton: true,
   						   confirmButtonColor: '#3085d6',  
   						   confirmButtonText: '확인',
   						});
   				}
     			},
     			error:function(xhr, status, error)
     			{
     				icia.common.error(error);
     			}
     			});
 
  		}

   function fn_list(boardType) 
   {
      document.bbsForm.boardType.value = boardType;
		document.bbsForm.action = "/board/list";
		document.bbsForm.brdSeq.value = "";
		document.bbsForm.searchType.value = "";
		document.bbsForm.searchValue.value = "";
		document.bbsForm.curPage.value = "1";
		document.bbsForm.submit();
   }
   
   function fn_comDel(comSeq)
   {
	   $.ajax({
			type:"POST",
			url:"/delete/comment",
			data:{
				brdSeq:$("#brdSeq").val(),
				boardType:$("#boardType").val(),
				commentNum:comSeq
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				if(response.code === 0)
				{
					Swal.fire({
						   title: '댓글삭제가 완료되었습니다.',
						   icon: 'success',
						   
						   showCancelButton: false,
						   showconfirmButton: true,
						   confirmButtonColor: '#3085d6',  
						   confirmButtonText: '확인',
						});
					
					$("#commentT").val("").focus();

					 var newCommentsHTML = '';
					 
                for (var i = 0; i < response.data.length; i++) 
				{
                	var comment = response.data[i];
	                	newCommentsHTML += 
                        '<div class="com-item-container" style="clear:both;">' +
                           '<div class="com-info">';
                        if (comment.IndentNum > 0)
   	       		        {
   	                    	newCommentsHTML += 
   	                    	'<img src="/resources/images/icon_reply.gif" style="margin-left:' + comment.IndentNum + 'em" />';  
   	       		        }
                           newCommentsHTML += 
                              '<span class="com-user">' + comment.userId + '</span> | <span class="com-date">' + comment.regDate + '</span>' +
                           '</div>' +
                           '<div class="com-content">' +
                              '<pre style="margin-left:' + comment.IndentNum + 'em">' + comment.content + '</pre>' +
                           '</div>' +
                           '<div class="com-reply-add">' +
                              '<span onClick=fn_comcom(' + comment.commentNum + ')>답글 달기</span>';
                    if(comment.userId === "${cookieUserId}")
                    {
                    	newCommentsHTML += '<span class="com-delt" onClick=fn_comDel(' + comment.commentNum + ')> | 삭제 </span>';
                    }
                        newCommentsHTML +=      
                           '</div>' +
                           '<div class="com-reply" id="comcomWrite' + comment.commentNum + '" style="clear:both;">' +
                              '<input type="text" id="comContent' + comment.commentNum + '" class="com-reply-input" placeholder="내용을 입력하세요">' +
                              '<input type="button" onClick=fn_comWBtn(' + comment.commentNum +') class="com-reply-btn" value="답글 작성" style="background: #604f47;">' +
                           '</div>' +
                          '<input type="hidden" id="commentNum"  value="' + comment.commentNum + '">' +
                        '</div>';
				}
                
                document.getElementById("commentRe").innerHTML = newCommentsHTML;
				}
 				if(response.code === 500)
				{
					Swal.fire({
						   title: '댓글삭제중 오류가 발생하였습니다.',
						   icon: 'warning',
						   
						   showCancelButton: false,
						   showconfirmButton: true,
						   confirmButtonColor: '#3085d6',  
						   confirmButtonText: '확인',
						});
				}
 				
 			},
 			error:function(xhr, status, error)
 			{
 				icia.common.error(error);
 			}
 			});
   }
  
   function fn_comcom(comSeq)
   {
	   if($("#comcomWrite" + comSeq).css('display') == 'none') 
	   {
           $("#comcomWrite" + comSeq).css('display', 'block');
           $("#comcomWrite" + comSeq).css('height', '100px');
       } 
	   else
	   {
           $("#comcomWrite" + comSeq).css('display', 'none');
           $("#comcomWrite" + comSeq).css('height', '0px');
       }
   }
   
   
</script>
</head>
<body>
   <!-- 헤더 영역 -->
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>

   <!-- 배너 사진 -->
   <div class="banner-container">
      <img alt="" src="/resources/images/list_banner.jpg">
   </div>

   <!-- 메인 컨테이너 -->
   <div class="main-container write-main-cont">
      <div class="title-container">
         <h1 onclick="fn_list(${boardType})">${boardTitle}</h1>
      </div>

      <div class="list-container">
         <div class="write-title-container">
            <span>상세보기</span>
         </div>
         <form name="viewForm" id="viewForm" method="post" enctype="multipart/form-data">
            <div class="write-container">
               <div class="view-header">
                  <div class="view-title">
                     <h3>${board.brdTitle}</h3>
                  </div>
                  <div class="view-info">작성자 : ${board.userName}&nbsp;&nbsp;|&nbsp;&nbsp;작성일 : ${board.regDate}&nbsp;&nbsp;|&nbsp;&nbsp;조회수 : ${board.brdReadCnt}</div>
               </div>
               
               <div class="view-content">
<c:if test="${!empty board.boardFile}">
               <img src="/resources/upload/${board.boardFile.fileName}" onerror="this.src='/resources/images/default-img.jpg';" alt="첨부 이미지" style="max-width: 80%; height: auto;">
</c:if>
                  <pre>${board.brdContent}</pre>
               </div>
            </div>
            <div class="write-btn-container" style="padding-bottom: 120px;">
               <!-- 좋아요 버튼 하실 분 사용하세요 -->
               <div class="view-left" style="float: left;">
                  <button type="button" id="recomBtn" class="writeBtn">좋아요 : ${boardLikeCount}</button>
<c:if test="${boardType eq 2 }">
                  <button type="button" id="writeBtn" class="writeBtn">답글</button>
</c:if>
               </div>
               <div class="view-right" style="float: right;">
<c:if test="${boardMe eq 'Y'}">
                  <button type="button" id="updateBtn" class="writeBtn">수정</button>
                  <button type="button" id="deleteBtn" class="writeBtn">삭제</button>
</c:if>
                  <button type="button" id="listBtn" class="writeBtn">목록</button>
               </div>
            </div>
         </form>

         <!-- 댓글창 -->
         <div class="comment-container">
            <input type="text" id="commentT" class="com-input" placeholder="내용을 입력하세요">
            <input type="button" id="comBtn" class="com-btn" value="댓글 작성">
         </div>
         
      <div class="comment-list-container" id="commentRe">
<c:if test="${boardType eq 3 || boardType eq 4}">
	<c:if test="${!empty comment}">      
      	<c:forEach var="comment" items="${comment}" varStatus="status">
            <div class="com-item-container" style="clear:both;">
               <div class="com-info">
               <c:if test="${comment.indentNum > 0}">
		            <img src="/resources/images/icon_reply.gif" style="margin-left:${comment.indentNum}em" />   
		   		</c:if>
		   		
                  <span class="com-user">${comment.userId}</span> | <span class="com-date">${comment.regDate}</span>
               </div>
               <div class="com-content">
                  <pre style="margin-left:${comment.indentNum}em">${comment.content}</pre>
               </div>
               
               <div class="com-reply-add">
                  <span onClick=fn_comcom('${comment.commentNum}')>답글 달기</span>
        <c:if test="${comment.userId == cookieUserId }">
                  <span class="com-delt" id="comdelt" onClick=fn_comDel('${comment.commentNum}')> | 삭제 </span>
        </c:if>
               </div>
               <!-- 대댓글 -->
               <div class="com-reply" id="comcomWrite${comment.commentNum}" style="clear:both; display:none;">
                  <input type="text" id="comContent${comment.commentNum}" class="com-reply-input" placeholder="내용을 입력하세요">
                  <input type="button" onClick=fn_comWBtn('${comment.commentNum}') class="com-reply-btn" value="대댓글 작성" style="background: #604f47;">
               </div>
               
               <input type="hidden" id="commentNum"  value="${comment.commentNum}">
            </div>
         </c:forEach>
        
    </c:if>
</c:if>
       </div>
 </div>
 </div>

   <!-- 푸터 영역 -->
   <%@ include file="/WEB-INF/views/include/footer.jsp"%>

   <form id="bbsForm" name=bbsForm method="post">
      <input type="hidden" name="boardType" id="boardType" value="${boardType }">
      <input type="hidden" name="brdSeq" id="brdSeq" value="${brdSeq }">
      <input type="hidden" name="searchType" value="${searchType }">
      <input type="hidden" name="searchValue" value="${searchValue }">
      <input type="hidden" name="curPage" value="${curPage }">
   </form>
</body>
</html>