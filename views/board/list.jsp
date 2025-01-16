<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/navigation.css" type="text/css">
<link rel="stylesheet" href="/resources/css/footer.css" type="text/css">
<link rel="stylesheet" href="/resources/css/board.css" type="text/css">

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

		//글쓰기 버튼 클릭 시
		$("#wrtieBtn").on("click", function() {
			document.bbsForm.boardType.value = ${boardType};
			document.bbsForm.action = "/board/writeForm";
			document.bbsForm.submit();
		});
		
		//검색 버튼 클릭 시
		$("#btnSearch").on("click", function(){
			document.bbsForm.boardType.value = ${boardType};
			document.bbsForm.brdSeq.value = "";
			document.bbsForm.searchType.value = $("#_searchType").val();
			document.bbsForm.searchValue.value = $("#_searchValue").val();
			document.bbsForm.curPage.value = "1";
			document.bbsForm.action = "/board/list";
			document.bbsForm.submit();
		});

		 var mousePos = {};

		 function getRandomInt(min, max) {
		   return Math.round(Math.random() * (max - min + 1)) + min;
		 }
		  
		  $(window).mousemove(function(e) {
		    mousePos.x = e.pageX;
		    mousePos.y = e.pageY;
		  });
		  
		  $(window).mouseleave(function(e) {
		    mousePos.x = -1;
		    mousePos.y = -1;
		  });
		  
		  var draw = setInterval(function(){
		    if(mousePos.x > 0 && mousePos.y > 0){
		      
		      var range = 15;
		      
		      var color = "background: rgb("+getRandomInt(0,255)+","+getRandomInt(0,255)+","+getRandomInt(0,255)+");";
		      
		      var sizeInt = getRandomInt(10, 30);
		      size = "height: " + sizeInt + "px; width: " + sizeInt + "px;";
		      
		      var left = "left: " + getRandomInt(mousePos.x-range-sizeInt, mousePos.x+range) + "px;";
		      
		      var top = "top: " + getRandomInt(mousePos.y-range-sizeInt, mousePos.y+range) + "px;"; 

		      var style = left+top+color+size;
		      $("<div class='ball' style='" + style + "'></div>").appendTo('#wrap').one("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", function(){$(this).remove();}); 
		    }
		  }, 40);

	
	
	
	
	
	});

	function fn_list(boardType) {
		document.bbsForm.boardType.value = boardType;
		document.bbsForm.action = "/board/list";
		document.bbsForm.brdSeq.value = "";
		document.bbsForm.searchType.value = "";
		document.bbsForm.searchValue.value = "";
		document.bbsForm.curPage.value = "1";
		document.bbsForm.submit();
	}
	
	function fn_page(curPage) {
		document.bbsForm.boardType.value = ${boardType};
		document.bbsForm.brdSeq.value = "";
		document.bbsForm.curPage.value = curPage;
		document.bbsForm.action = "/board/list";
		document.bbsForm.submit();
	}
	
	function fn_view(brdSeq, boardType)
	{
		document.bbsForm.boardType.value = ${boardType};
		document.bbsForm.brdSeq.value = brdSeq;
		document.bbsForm.curPage.value = ${curPage};
		document.bbsForm.action = "/board/view";
		document.bbsForm.submit();
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
	
	<div id="wrap"></div>
	<!-- 메인 컨테이너 -->
	<div class="main-container">

		<div class="title-container">
			<h1>${boardTitle }</h1>
		</div>

		<div class="list-container">
			<div class="menu-container">
				<ul>
					<li><a href=# class="${boardType == 1 ? 'active' : ''}" onclick="fn_list(1)">공지사항</a></li>
					<li><a href=# class="${boardType == 2 ? 'active' : ''}" onclick="fn_list(2)">자유 게시판</a></li>
					<li><a href=# class="${boardType == 3 ? 'active' : ''}" onclick="fn_list(3)">전시 게시판</a></li>
					<li><a href=# class="${boardType == 4 ? 'active' : ''}" onclick="fn_list(4)">문의사항</a></li>
				</ul>
			</div>

			<div class="board-container">
			<c:if test="${boardType ne 3}">
				<table>
					<thead>
						<tr>
							<th style="width: 10%">NO</th>
							<th style="width: 55%">제목</th>
							<th style="width: 10%">작성자</th>
							<th style="width: 15%">날짜</th>
							<th style="width: 10%">조회수</th>
						</tr>
					</thead>
			<tbody>
			
      			<c:if test="${!empty list}">
      		<c:forEach var="Board" items="${list}" varStatus="status">
		      <tr>
		      	<c:choose>	
		      		<c:when test="${Board.brdIndent eq 0}">
		      
				         <td class="text-center">${Board.brdSeq}</td>
				         
				    </c:when>
				    <c:otherwise>
				         
						 <td class="text-center">&nbsp;</td>
						 
				 	</c:otherwise>
				</c:choose>
				 
		         <td>
		            <a href="javascript:void(0)" onclick="fn_view(${Board.brdSeq})">
		   <c:if test="${Board.brdIndent > 0}">
		            <img src="/resources/images/icon_reply.gif" style="margin-left:${Board.brdIndent}em" />   
		   </c:if>
		               <c:out value="${Board.brdTitle}" />
		            </a>
		         </td>
		         <td class="text-center">${Board.userName}</td>
		         <td class="text-center">${Board.regDate}</td>
		         <td class="text-center"><fmt:formatNumber type="number" maxFractionDigits="3" groupingUsed="true" value="${Board.brdReadCnt}" /></td>
		      </tr>
			</c:forEach>
		</c:if>      
		
			</tbody>
				</table>
				</c:if>
				<c:if test="${boardType eq 3 }">
               <c:if test="${!empty list }">
                  <div class="exhibi-container">
                     <c:forEach var="Board" items="${list}" varStatus="status">
                        <div class="exhibi-item-box" onclick="fn_view(${Board.brdSeq})">
                           <div class="exhibi-img">
                              <img alt="" src='/resources/upload/${Board.boardFile.fileName}' onerror="this.src='/resources/images/default-img.jpg';">
                           </div>
                           <div class="exhibi-title">
                              <div><span>${Board.brdTitle }</span></div>
                           </div>
                        </div>
                     </c:forEach>
                  </div>
               </c:if>
            </c:if>
			</div>

			<div class="writeBtn-container">
				<c:if test="${boardType ne 1}">
					<button type="button" id="wrtieBtn" class="writeBtn">글쓰기</button>
				</c:if>
			</div>

			<nav>
				<ul class="pagination">
		<c:if test="${!empty paging}">
			<c:if test="${paging.prevBlockPage gt 0}">
							<li class="page-item"><a class="page-link" href="#" onclick="fn_page(${paging.prevBlockPage})"> <img alt="" src="/resources/images/prev.png" style="margin-left: -4px;"></a></li>
			</c:if>
			<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
				<c:choose>
					<c:when test="${i ne curPage}">
							<li class="page-item"><a class="page-link" href="#" onclick="fn_page(${i})">${i}</a></li>
					</c:when>
					<c:otherwise>
		
							<li class="page-item active"><a class="page-link" href="#" style="background-color:#FFCC80; color:#FF8888;cursor: default;">${i}</a></li>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<c:if test="${paging.nextBlockPage gt 0}">
							<li class="page-item"><a class="page-link" href="#" onclick="fn_page(${paging.nextBlockPage})"> <img alt="" src="/resources/images/next.png" style="margin-right: -6px;"></a></li>
			</c:if>
		</c:if>	

				</ul>
			</nav>

			<div class="searchBar">
				<select name="_searchType" id="_searchType" class="custom-box" style="width: auto;">
					<option value="">조회 항목</option>
					<option value="1">작성자</option>
					<option value="2">제목</option>
					<option value="3">내용</option>
				</select>
				<input type="text" name="_searchValue" id="_searchValue" class="custom-box" maxlength="20" style="ime-mode: active;" value="${searchValue }" size="40" placeholder="조회값을 입력하세요." />
				<button type="button" id="btnSearch" class="custom-box">
					<img alt="검색 버튼" src="/resources/images/search.png" style="height: 18px;">
				</button>
			</div>
		</div>
	</div>

	<!-- 푸터 영역 -->
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>


	<form id="bbsForm" name=bbsForm method="post">
		<input type="hidden" name="brdSeq" value="" />
		<input type="hidden" name="boardType" value="${boardType }">
		<input type="hidden" name="searchType" value="${searchType }">
		<input type="hidden" name="searchValue" value="${searchValue }">
		<input type="hidden" name="curPage" value="${usrPage }">
	</form>

</body>
</html>