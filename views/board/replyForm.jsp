<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>


<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>

<link rel="stylesheet" href="/resources/css/navigation.css" type="text/css">
<link rel="stylesheet" href="/resources/css/footer.css" type="text/css">
<link rel="stylesheet" href="/resources/css/board.css" type="text/css">
<script>
$(document).ready(function() {
    $("#brdContent").summernote({
        lang: 'ko-KR',
        height: 500,
        toolbar: [
            ["fontname", ["fontname"]],
            ["fontsize", ["fontsize"]],
            ["color", ["color"]],
            ["style", ["style"]],
            ["font", ["strikethrough", "superscript", "subscript"]],
            ["table", ["table"]],
            ["para", ["ul", "ol", "paragraph"]],
            ["height", ["height"]],
        ],
        fontNames: ['GmarketSans', 'Nanum Gothic', 'Noto Sans KR', 'Spoqa Han Sans'],
        fontNamesIgnoreCheck: ['GmarketSans', 'Nanum Gothic', 'Noto Sans KR', 'Spoqa Han Sans'], 
    });
});
</script>
<script type="text/javascript">
$(document).ready(function() {
	
	// 햄버거 버튼 클릭 이벤트
    $('nav ul li a img[alt="햄버거버튼"]').on('click', function(event) {
       event.preventDefault();
       $("#test").toggle();
    });
	
	//목록 버튼 클릭 시
      $("#listBtn1").on("click", function() {
    	  document.bbsForm.boardType.value = ${boardType};
          document.bbsForm.action = "/board/list";
          document.bbsForm.submit();
      });
	
    // 메뉴 외부를 클릭했을 때 드롭다운 메뉴 숨기기
    $(document).on('click', function(event) {
       if (!$(event.target).closest('nav').length) {
          $("#test").hide();
       }

    });
<c:choose>
	<c:when test="${empty board}">
		alert("답변할 게시물이 존재하지 않습니다.");
		location.href = "/board/list";
	</c:when>
	
	<c:otherwise>
	   $("#brdTitle").focus();
	   
	   $("#replyBtn").on("click", function() {
	      
	      $("#replyBtn").prop("disabled", true); 
		  
	      if($.trim($("#brdTitle").val()).length <= 0)
	      {
	    	  alert("제목을 입력하세요.");
	    	  $("#replyBtn").prop("disabled", false);	
	    	  $('#brdTitle').val("");
	    	  $('#brdTitle').focus();
	    	  return;
	      }
	      if($.trim($("#brdContent").val()).length <= 0)
	      {
	    	  alert("내용을 입력하세요.");
	    	  $("#replyBtn").prop("disabled", false);
	    	  $('#brdContent').val("");
	    	  $('#brdContent').focus();
	    	  return;
	      }
	      
	      var form = $("#replyForm")[0];
	      var formData = new FormData(form);
	      formData.append("brdSeq", "${board.brdSeq}");
	  	  formData.append("boardType", "${boardType}");
	      
	      $.ajax({
	    	 type:"POST",
	    	 enctype:"multipart/form-data",
	    	 url:"/board/replyProc",
	    	 data:formData,
	    	 processData:false,
	    	 contentType:false,
	    	 cache:false,
	    	 beforeSend:function(xhr)
	    	 {
	    		 xhr.setRequestHeader("AJAX", "ture");
	    	 },
	    	 success:function(response)
	    	 {
	    		 if(response.code == 0)
	    		 {
	    			 Swal.fire({
						   title: '답변이 완료되었습니다.',
						   icon: 'warning',
						   
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
	    			 $("#replyBtn").prop("disabled", false);
	    			 $('#brdTitle').focus();
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
	    		 else
	    		 {
	    			 
	    			 Swal.fire({
						   title: '게시물 답변 중 오류가 발생하였습니다.',
						   icon: 'warning',
						   
						   showCancelButton: false,
						   showconfirmButton: true,
						   confirmButtonColor: '#3085d6',  
						   confirmButtonText: '확인',
						});
	    			 $("#replyBtn").prop("disabled", false);
	    			 $('#brdTitle').focus();
	    		 }
	    	 },
	    	 error:function(error)
	    	 {
	    		 icia.common.error(error);
	    		 Swal.fire({
					   title: '게시물 답변 중 오류가 발생하였습니다.',
					   icon: 'warning',
					   
					   showCancelButton: false,
					   showconfirmButton: true,
					   confirmButtonColor: '#3085d6',  
					   confirmButtonText: '확인',
					});
	    		 $("#replyBtn").prop("disabled", false);
	    	 }
	      });
	   });
	   
	   $("#btnList").on("click", function() {
		   document.bbsForm.action = "/board/list";
		   document.bbsForm.submit();
	   });
	</c:otherwise>
</c:choose>   
});
</script>
</head>
<body>
<c:if test="${!empty board}">
   <!-- 헤더 영역 -->
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>

   <!-- 배너 사진 -->
   <div class="banner-container">
      <img alt="" src="/resources/images/list_banner.jpg">
   </div>

   <!-- 메인 컨테이너 -->
   <div class="main-container write-main-cont">
      <div class="title-container">
         <h1>${boardTitle}</h1>
      </div>

      <div class="list-container">
         <div class="write-title-container">
            <span>답변쓰기</span>
         </div>
         <form name="replyForm" id="replyForm" method="post" enctype="multipart/form-data">
         <div class="write-container">
            <input type="text" id="userName" name="userName" class="write-input" value="${user.userName }" readonly>
            <input type="text" id="userEmail" name="userEmail" class="write-input" value="${user.userEmail }" readonly>
            <input type="text" id="brdTitle" name="brdTitle" class="write-input" placeholder="제목을 입력하세요">
            <div class="write-input file-input">
               <label for="brdFile" class="fileLabel"><img alt="" src="/resources/images/file.png" style="height: 20px;"> 첨부파일 업로드</label>
            </div>
            <input type="file" id="brdFile" name="brdFile" class="write-input" placeholder="파일을 선택하세요." required />
            <textarea id="brdContent" name="brdContent" class="write-input" placeholder="내용을 입력하세요"></textarea>
         </div>
         <div class="write-btn-container">
            <button type="button" id="replyBtn" class="writeBtn">답변</button>
            <button type="button" id="listBtn1" class="writeBtn">목록</button>
         </div>
         <input type="hidden" name="boardType" value="${boardType }">
         </form>
      </div>
   </div>

   <!-- 푸터 영역 -->
   <%@ include file="/WEB-INF/views/include/footer.jsp"%>

   <form id="bbsForm" name=bbsForm method="post">
      <input type="hidden" name="boardType" value="${boardType }">
      <input type="hidden" name="brdSeq" value="${board.brdSeq }">
      <input type="hidden" name="searchType" value="${searchType }">
      <input type="hidden" name="searchValue" value="${searchValue }">
      <input type="hidden" name="curPage" value="${curPage }">
   </form>
</c:if>
</body>
</html>