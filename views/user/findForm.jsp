<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="/resources/css/userPage.css" type="text/css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/memberAddr.js"></script>
<script>
   $(function() {
      //비밀번호 찾기 화면으로 이동
      $("#findPwdBtn").on("click", function() {
         $(".container").addClass("right-panel-active");
      });

      //아이디 찾기 화면으로 이동
      $("#findIdBtn").on("click", function() {
         $(".container").removeClass("right-panel-active");
      });
      
      //--------------
	  
      //아이디 찾기 버튼 클릭 시
	  $("#realFindIdBtn").on("click", function(){
	     fn_findUserId();
	  });
      
      //비밀번호 찾기 버튼 클릭 시
	  $("#realFindPwdBtn").on("click", function(){
	     fn_findUserPwd();
	  });
   });

   function fn_validateEmail(value) {
      var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

      return emailReg.test(value);
   }
   
   //아이디찾기
   function fn_findUserId()
   {
	 //이메일 정규식
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	
	if($.trim($("#userNameId").val()).length <= 0)
	{
		$("#userNameIdMsg").text("사용자 이름을 입력하세요.");
		$("#userNameIdMsg").css("display", "inline");
		$("#userNameId").val("");
		$("#userNameId").focus();
		return;
	}	 
	 
	if($.trim($("#userEmailId").val()).length <= 0)
	{
		$("#userEmailIdMsg").text("사용자 이메일을 입력하세요.");
		$("#userEmailIdMsg").css("display", "inline");
		$("#userEmailId").val("");
		$("#userEmailId").focus();
		return;
	}	
	
	if(!emailReg.test($("#userEmailId").val())) 
	{
		$("#userEmailIdMsg").text("정확한 이메일을 입력하세요.");
		$("#userEmailIdMsg").css("display", "inline");
		$("#userEmailId").val("");
		$("#userEmailId").focus();
		return;
	}
	
   $.ajax({
		type:"POST",
		url:"/user/findUserId",
		data:{
			userName:$("#userNameId").val(),
			userEmail:$("#userEmailId").val()
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
				   title: '아이디 : ' + response.msg ,
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
				   title: '정확한 정보를 입력하세요.',
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
				   title: '찾으시는 정보가 없습니다.',
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
   
   //비밀번호 초기화 메일전송
   function fn_findUserPwd()
   {
	   //이메일 정규식
		var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
		
		if($.trim($("#userIdPwd").val()).length <= 0)
		{
			$("#userIdPwdMsg").text("사용자 아이디을 입력하세요.");
			$("#userIdPwdMsg").css("display", "inline");
			$("#userIdPwd").val("");
			$("#userIdPwd").focus();
			return;
		}	 
		 
		if($.trim($("#userEmailPwd").val()).length <= 0)
		{
			$("#userEmailPwdMsg").text("사용자 이메일을 입력하세요.");
			$("#userEmailPwdMsg").css("display", "inline");
			$("#userEmailPwd").val("");
			$("#userEmailPwd").focus();
			return;
		}	
		
		if(!emailReg.test($("#userEmailPwd").val())) 
		{
			$("#userEmailPwdMsg").text("정확한 이메일을 입력하세요.");
			$("#userEmailPwdMsg").css("display", "inline");
			$("#userEmailPwd").val("");
			$("#userEmailPwd").focus();
			return;
		}
		
	   $.ajax({
			type:"POST",
			url:"/user/findUserPwd",
			data:{
				userId:$("#userIdPwd").val(),
				userEmail:$("#userEmailPwd").val()
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
					fn_fakePwdCodeCheck()
				}
				else if(response.code == 400)
				{
					Swal.fire({
					   title: '정확한 정보를 입력하세요.',
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
					   title: '찾으시는 정보가 없습니다.',
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
   
 	//이메일 임시비밀번호 전송 및 업데이트
	function fn_fakePwdCodeCheck()
	{
		$.ajax({
			type:"POST",
			url:"/sendPwdCodeMail.do",
			data:{
				userId:$("#userIdPwd").val(),
				userEmail:$("#userEmailPwd").val()
			},
			datatype:"JSON",
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response)
			{
				Swal.fire({
				   title: '인증번호를 전송하였습니다.',
				   icon: 'success',
				   
				   showCancelButton: false,
				   showconfirmButton: true,
				   confirmButtonColor: '#3085d6',  
				   confirmButtonText: '확인',
				}).then(result => {
					location.href = "/";
				});
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
   <div class="wrapper findWrap">
      <div class="container">
         <div class="sign-up-container">
            <form>
               <a href="/index"><img alt="" src="/resources/images/logo4.png" style="margin-bottom: 20px; opacity: 0.8;"></a>
               <h1>Create a temporary password</h1>
               <input type="text" id="userIdPwd" name="userIdPwd" placeholder="Id" >
               <div class="msgBox"><span id="userIdPwdMsg" class="msgText" style="margin: 30px 0px;"></span></div>

               <input type="email" id="userEmailPwd" name="userEmailPwd" placeholder="Email">
               <div class="msgBox"><span id="userEmailPwdMsg" class="msgText"></span></div>

               <button type="button" id="realFindPwdBtn" class="form_btn">Creating</button>
            </form>
         </div>
         <div class="sign-in-container">
            <form>
               <a href="/index"><img alt="" src="/resources/images/logo4.png" style="margin-bottom: 20px; opacity: 0.8;"></a>
               <h1>Find your ID</h1>
               <input type="text" id="userNameId" name="userNameId" placeholder="Name" >
               <div class="msgBox"><span id="userNameIdMsg" class="msgText" style="margin: 30px 0px;"></span></div>

               <input type="email" id="userEmailId" name="userEmailId" placeholder="Email">
               <div class="msgBox"><span id="userEmailIdMsg" class="msgText"></span></div>

               <div class="find-link">
                  <span><a href="/user/userForm">Are you sure you want to Sign In?</a></span>
               </div>

               <button type="button" id="realFindIdBtn" class="form_btn">Find</button>
            </form>
         </div>
         <div class="overlay-container">
            <div class="overlay-left">
               <h1>Forgot your ID?</h1>
               <p>Finding Account Information</p>
               <button id="findIdBtn" class="overlay_btn">Find ID</button>
            </div>
            <div class="overlay-right">
               <h1>Forgot your Password?</h1>
               <p>Create a temporary password</p>
               <button id="findPwdBtn" class="overlay_btn">Creating PWD</button>
            </div>
         </div>
      </div>
   </div>
   
   <form id="userForm" name="userForm" method="post">
      <input type="hidden" name="userEmailInput" value="" >
   </form>
</body>
</html>