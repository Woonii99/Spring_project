<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/navigation.css" type="text/css">
<link rel="stylesheet" href="/resources/css/footer.css" type="text/css">
<link rel="stylesheet" href="/resources/css/index.css" type="text/css">
<script type="text/javascript">
	$(document).ready(function() {
		// 햄버거 버튼 클릭 이벤트
		$('nav ul li a img[alt="햄버거버튼"]').on('click', function(event) {
			event.preventDefault();
			$('.dropdown-menu').toggle();
		});

		// 메뉴 외부를 클릭했을 때 드롭다운 메뉴 숨기기
		$(document).on('click', function(event) {
			if (!$(event.target).closest('nav').length) {
				$('.dropdown-menu').hide();
			}
		});
		
		const children = document.querySelectorAll('.placeholder');
    const children2 = document.querySelectorAll('.caption2 div');
    var index = 0;
    setInterval(function(){
       children[index].style.opacity = '0';
       children2[index].style.opacity = '0';
       index = (index + 1) % children.length;
       children[index].style.opacity = '1';
       children2[index].style.opacity = '1';
    }, 4000);
    setInterval(function(){
        const slides = document.querySelectorAll('.work-item');
        document.querySelector('.work-grid').append(slides[0]);
     }, 1500);
	});

	function fn_list(boardType) {
		document.bbsForm.boardType.value = boardType;
		document.bbsForm.action = "/board/list";
		document.bbsForm.submit();
	}
	
	
	

</script>

</head>
<body>
	<form class="form-signin">
		<!-- 헤더 영역 -->
		<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

		<!-- 메인 배너 영역 -->
		<section class="hero">
			<div class="overlay"></div>
			<h1>쌍용교육센터</h1>
			<div class="search-bar">
				<input type="text" placeholder="검색어를 입력하세요">
				<button>검색</button>
			</div>
		</section>

		<!-- 이미지 설명 영역 -->
		      <section class="image-description">
         <div class="image-container">
            <div class="image-container1" onclick="fn_href()">
               <div class="placeholder">
                  <img alt="" src="/resources/images/index_1.jpeg">
               </div>
               <div class="placeholder">
                  <img alt="" src="/resources/images/index_2.jpeg">
               </div>
               <div class="placeholder">
                  <img alt="" src="/resources/images/index_3.jpeg">
               </div>
            </div>
            <div class="caption">
            <div class="caption2">
            <div >
               <h3>What an art!</h3>
               <p>
                  여러 아티스트의 작품을 감상할 수 있는
               </p>
            </div>
            <div>
               <h3>Life becomes art, Art becomes life</h3>
               <p>
                  특별한 공간 쌍용미니프로젝트 전시회에
               </p>
            </div>
            <div>
               <h3>This is art!</h3>
               <p>
                   여러분들을 초대합니다.
               </p>
            </div>
            </div>
            </div>
         </div>
      </section>

		<!-- 베스트 작업물 영역 -->
		<section class="best-work">
			<h2>BEST WORK</h2>
			<div class="work-grid">
			<c:forEach var="Board" items="${list}" varStatus="status">
			
				<div class="work-item">
					<div class="placeholder1">
						<img alt="" src="/resources/upload/${Board.boardFile.fileName}">
					</div>
					<p>${Board.brdTitle }</p>
				</div>
				</c:forEach>
			</div>
		</section>

		<!-- 푸터 영역 -->
		<%@ include file="/WEB-INF/views/include/footer.jsp"%>

	</form>

	<form id="bbsForm" name=bbsForm method="post">
		<input type="hidden" name="boardType" value="">
	</form>
</body>

</html>
