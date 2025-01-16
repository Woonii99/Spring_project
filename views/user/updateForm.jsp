<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/userPage.css" type="text/css">
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/memberAddr.js"></script>
<script>
   $(function() {
      //회원정보 수정 버튼 클릭 시
      $("#updateBtn").on("click", function() {
         fn_updateUser();
      });

      //회원탈퇴 버튼 클릭 시
      $("#withdrawalBtn").on("click", function() {
    	 var confirmation = confirm("정말로 탈퇴하시겠습니까?");
    	 if (confirmation) {
    	 		fn_deleteUser(); 
    	 }
      });
   });
   
   function fn_updateUser()
   {
	 	//공백체크 정규식
		var emptCheck = /\s/g;
		// 영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
		var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
	   if($.trim($("#userName").val()).length <= 0)
		{
			$("#userNameMsg").text("사용자 이름을 입력하세요.");
			$("#userNameMsg").css("display", "inline");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}
		
		if($.trim($("#userPwd").val()).length <= 0)
		{
			$("#userPwdMsg").text("비밀번호를 입력하세요.");
			$("#userPwdMsg").css("display", "inline");
			$("#userPwd").val("");
			$("#userPwd").focus();
			return;
		}
		
		if(emptCheck.test($("#userPwd").val())) 
		{
			$("#userPwdMsg").text("비밀번호는 공백을 포함할수 없습니다.");
			$("#userPwdMsg").css("display", "inline");
			$("#userPwd").val("");
			$("#userPwd").focus();
			return;
		}
		
		if(!idPwCheck.test($("#userPwd").val())) 
		{
			$("#userPwdMsg").text("비밀번호는 영문 대소문자와 숫자로 4~12자리로 입력가능합니다.");
			$("#userPwdMsg").css("display", "inline");
			$("#userPwd").val("");
			$("#userPwd").focus();
			return;
		}
		
		if($.trim($("#userPwd").val()).length <= 0)
		{
			$("#userPwdMsg").text("비밀번호를 입력하세요.");
			$("#userPwdMsg").css("display", "inline");
			$("#userPwd").val("");
			$("#userPwd").focus();
			return;
		}
		
		if($.trim($("#userPwd").val()).length <= 0)
		{
			$("#userPwdMsg").text("비밀번호를 입력하세요.");
			$("#userPwdMsg").css("display", "inline");
			$("#userPwd").val("");
			$("#userPwd").focus();
			return;
		}
		
		if($.trim($("#userPwd").val()).length <= 0)
		{
			$("#userPwdMsg").text("비밀번호를 입력하세요.");
			$("#userPwdMsg").css("display", "inline");
			$("#userPwd").val("");
			$("#userPwd").focus();
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/user/updateProc",
			data:{
				userId:$("#userId").val(),
				userEmail:$("#userEmail").val(),
				userName:$("#userName").val(),
				userPwd:$("#userPwd").val(),
				addrCode:$("#addrCode").val(),
				addrBase:$("#addrBase").val(),
				addrDetail:$("#addrDetail").val()
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
						   title: '회원 정보가 수정되었습니다.',
						   icon: 'success',
						   
						   showCancelButton: false,
						   showconfirmButton: true,
						   confirmButtonColor: '#3085d6',  
						   confirmButtonText: '확인',
						}).then(result => {
							location.href = "/";
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
						   confirmButtonText: '확인'
						});
					
					$("#userPwd1").focus();
				}
				else if(response.code == 404)
				{
					Swal.fire({
						   title: '회원 정보가 존재하지 않습니다.',
						   icon: 'success',
						   
						   showCancelButton: false,
						   showconfirmButton: true,
						   confirmButtonColor: '#3085d6',  
						   confirmButtonText: '확인',
						}).then(result => {
							location.href = "/";
						});
					location.href = "/";
				}
				else if(response.code == 410)
				{
					Swal.fire({
						   title: '로그인을 먼저 하세요.',
						   icon: 'success',
						   
						   showCancelButton: false,
						   showconfirmButton: true,
						   confirmButtonColor: '#3085d6',  
						   confirmButtonText: '확인',
						}).then(result => {
							location.href = "/user/userForm";
						});
				}
				else if(response.code == 430)
				{
					Swal.fire({
						   title: '아이디 정보가 다릅니다.',
						   icon: 'success',
						   
						   showCancelButton: false,
						   showconfirmButton: true,
						   confirmButtonColor: '#3085d6',  
						   confirmButtonText: '확인',
						}).then(result => {
							location.href = "/";
						});
				}
				else if(response.code == 500)
				{
					Swal.fire({
						   title: '회원정보 수정 중 오류가 발생하였습니다.',
						   icon: 'warning',
						   
						   showCancelButton: false,
						   showconfirmButton: true,
						   confirmButtonColor: '#3085d6',  
						   confirmButtonText: '확인'
						});
					
					$("#userPwd").focus();
				}
				else
				{
					Swal.fire({
					   title: '회원정보 수정 중 오류발생',
					   icon: 'warning',
					   
					   showCancelButton: false,
					   showconfirmButton: true,
					   confirmButtonColor: '#3085d6',  
					   confirmButtonText: '확인'
					});
					
					$("#userPwd").focus();
				}
			},
			error:function(xhr, status, error)
			{
				icia.common.error(error);
			}
		});
   }
   
   function fn_deleteUser()
   {
		$.ajax({
			type:"POST",
			url:"/user/updateUser",
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX", "true");
			},
			data:{
				status:"N"
			},
			datatype:"JSON",
			success:function(response)
			{
				if(response.code == 0)
				{
					Swal.fire({
					   title: '탈퇴되었습니다.',
					   icon: 'success',
					   
					   showCancelButton: false,
					   showconfirmButton: true,
					   confirmButtonColor: '#3085d6',  
					   confirmButtonText: '확인',
					}).then(result => {
						location.href = "/";
					});
				}
				else if(response.code == 400)
				{
					Swal.fire({
						   title: '로그인 후 이용가능합니다.',
						   icon: 'warning',
						   
						   showCancelButton: false,
						   showconfirmButton: true,
						   confirmButtonColor: '#3085d6',  
						   confirmButtonText: '확인'
						});
				}
			},
			error:function(xhr, status, error)
			{
				icia.common.error(error);
			}
		});
		
   }
	
</script>
</head>
<body>
   <div class="wrapper updateWrap">
      <div class="container">
         <div class="sign-in-container">
            <form>
               <a href="/index" style="margin-bottom: 20px; opacity: 0.8;"><img alt="" src="/resources/images/logo4.png"></a>
               <h1 style="margin-bottom: 30px;">Modifying Personal info</h1>

               <input type="text" id="userId" name="userId" value="${user.userId}" readonly>


               <input type="email" id="userEmail" name="userEmail" value="${user.userEmail}" readonly>

               <input type="text" id="userName" name="userName" placeholder="Name" value="${user.userName}">
               <div class="msgBox">
                  <span id="userNameMsg" class="msgText"></span>
               </div>

               <input type="password" id="userPwd" name="userPwd" placeholder="Password" value="${user.userPwd}">
               <div class="msgBox">
                  <span id="userPwdMsg" class="msgText"></span>
               </div>

               <!-- <input type="password" id="userPwd1" name="userPwd1" placeholder="New Password">
               <div class="msgBox">
                  <span id="userPwd1Msg" class="msgText"></span>
               </div>

               <input type="password" id="userPwd2" name="userPwd2" placeholder="New Password Check">
               <div class="msgBox">
                  <span id="userPwd2Msg" class="msgText"></span>
               </div> -->

               <div class="inputBtn-container">
                  <input type="text" id="addrCode" name="addrCode" class="leftBox" placeholder="Postal Code" value="${user.addrCode}" maxlength="5">
                  <button type="button" id="addrBtn" class="form_btn emailBtn rightBtn" onclick="checkPost()">
                     <span>우편번호 검색</span>
                  </button>
               </div>
               <input type="text" id="addrBase" name="addrBase" placeholder="Address" value="${user.addrBase}">
               <input type="text" id="addrDetail" name="addrDetail" placeholder="Detailed Address" value="${user.addrDetail}">

               <input type="hidden" id="userPwd" name="userPwd" value="">

               <button type="button" id="updateBtn" class="form_btn">Update</button>
            </form>
         </div>
         <div class="overlay-container">
            <div class="overlay-right">
               <h1>
                  Would you like to<br>leave the membership?
               </h1>
               <p>You can sign up again later!</p>
               <button id="withdrawalBtn" class="overlay_btn">Withdrawal</button>
            </div>
         </div>
      </div>
   </div>
</body>
</html>