<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<link rel="stylesheet" href="/resources/css/userPage.css" type="text/css">
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/memberAddr.js"></script>
<script>
	
	var idCheck = 'N';
	var emailCheck = 'N';
	var emailPinCheck = 'N';

	$(function(){
		//로그인 화면으로 이동
		$("#signUpBtn").on("click", function(){
			$(".container").addClass("right-panel-active");
		});

		//회원가입 화면으로 이동
		$("#signInBtn").on("click", function(){
			$(".container").removeClass("right-panel-active");
		});
		
		//======================
		
		//아이디 입력 후 엔터
		$("#userIdLogin").on("keypress", function(e){
		   if(e.which == 13)
		      fn_loginCheck();
		});
		
		//비밀번호 입력 후 엔터
		$("#userPwdLogin").on("keypress", function(e){
		   if(e.which == 13)
		      fn_loginCheck();
		});      
		
		//아이디 중복 체크(엔터)
		$("#userId").on("keypress", function(e){
		   if (e.which == 13)
		      fn_idCheck();
		});
		
		//아이디 중복 체크(버튼)
		$("#idBtn").on("click", function(){
		   fn_idCheck();
		});
		
		//인증번호 전송(엔터)
		$("#userEmail").on("keypress", function(e){
		   if (e.which == 13)
		      fn_emailCheck();
		});
		
		//인증번호 전송(버튼)
		$("#emailBtn").on("click", function(){
		   fn_emailCheck();
		});
		
		//인증번호 체크(엔터)
		$("#authNum").on("keypress", function(e){
		   if (e.which == 13)
		      fn_emailPinCheck();
		});
		
		//인증번호 체크(버튼)
		$("#authBtn").on("click", function(){
		   fn_emailPinCheck();
		});
		//========
		
		//로그인 버튼 클릭 시
		$("#realSignInBtn").on("click", function(){
		   fn_loginCheck();
		});
		
		//회원가입 버튼 클릭 시
		$("#realSignUpBtn").on("click", function(){
		   fn_joinCheck();
		});

	});
	
	//로그인
	function fn_loginCheck()
	{
		//공백 체크
		var emptCheck = /\s/g;
		
		fn_displayNone();
		
		if ($.trim($("#userIdLogin").val()).length <= 0) 
		{
		   $("#userIdLoginMsg").text("사용자 아이디를 입력하세요.");
		   $("#userIdLoginMsg").css("display", "inline");
		   $("#userIdLogin").val("");
		   $("#userIdLogin").focus();
		   return;
		}
		
		if (emptCheck.test($("#userIdLogin").val())) 
		{
		   $("#userIdLoginMsg").text("사용자 아이디는 공백을 포함할 수 없습니다.");
		   $("#userIdLoginMsg").css("display", "inline");
		   $("#userIdLogin").val("");
		   $("#userIdLogin").focus();
		   return;
		}
		
		if($.trim($("#userPwdLogin").val()).length <= 0) 
		{
		   $("#userPwdLoginMsg").text("비밀번호를 입력하세요.");
		   $("#userPwdLoginMsg").css("display", "inline");
		   $("#userPwdLogin").val("");
		   $("#userPwdLogin").focus();
		   return;
		}
		
		if (emptCheck.test($("#userPwdLogin").val())) 
		{
		   $("#userPwdLoginMsg").text("사용자 비밀번호는 공백을 포함할 수 없습니다.");
		   $("#userPwdLoginMsg").css("display", "inline");
		   $("#userPwdLogin").val("");
		   $("#userPwdLogin").focus();
		   return;
		}
		
		$("#userId").val($("#userIdLogin").val());
		$("#userPwd").val($("#userPwdLogin").val());
		
		//로그인 ajax
		$.ajax({
			type:"POST",
			url:"/user/login",
			data:{
				userId:$("#userId").val(),
				userPwd:$("#userPwd").val()
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				if(!icia.common.isEmpty(response))
				{
					icia.common.log(response);
					
					var code = icia.common.objectValue(response, "code", -500);
					
					if(code === 0)
					{
						Swal.fire({
							   title: '로그인 성공',
							   icon: 'success',
							   
							   showCancelButton: false,
							   showconfirmButton: true,
							   confirmButtonColor: '#3085d6',  
							   confirmButtonText: '확인',
							}).then(result => {
								location.href = "/index";
							});
					}
					else if(code === -2)
					{
						Swal.fire({
							   title: '로그인 성공',
							   icon: 'success',
							   
							   showCancelButton: false,
							   showconfirmButton: true,
							   confirmButtonColor: '#3085d6',  
							   confirmButtonText: '확인',
							}).then(result => {
								location.href = "/user/updateForm";
							});
					}
					else
					{
						if(code == -1)
						{
							Swal.fire({
							   title: '비밀번호가 올바르지 않습니다.',
							   icon: 'warning',
							   
							   showCancelButton: false,
							   showconfirmButton: true,
							   confirmButtonColor: '#3085d6',  
							   confirmButtonText: '확인',
							});
							$("#userPwd").focus();
						}
						else if(code == -999)
						{
							Swal.fire({
							   title: '정지된 사용자 입니다.',
							   icon: 'warning',
							   
							   showCancelButton: false,
							   showconfirmButton: true,
							   confirmButtonColor: '#3085d6',  
							   confirmButtonText: '확인',
							});
							$("#userPwd").focus();
							$("#userId").focus();
						}
						else if(code == -99)
						{
							Swal.fire({
							   title: '탈퇴한 사용자 입니다.',
							   icon: 'warning',
							   
							   showCancelButton: false,
							   showconfirmButton: true,
							   confirmButtonColor: '#3085d6',  
							   confirmButtonText: '확인',
							});
							$("#userPwd").focus();
							$("#userId").focus();
						}
						else if(code == 404)
						{
							Swal.fire({
							   title: '아이디와 일치하는 사용자 정보가 없습니다.',
							   icon: 'warning',
							   
							   showCancelButton: false,
							   showconfirmButton: true,
							   confirmButtonColor: '#3085d6',  
							   confirmButtonText: '확인',
							});
							$("#userId").focus();
						}
						else if(code == 400)
						{
							Swal.fire({
							   title: '파라미터 값이 올바르지 않습니다.',
							   icon: 'warning',
							   
							   showCancelButton: false,
							   showconfirmButton: true,
							   confirmButtonColor: '#3085d6',  
							   confirmButtonText: '확인',
							});
							$("#userId").focus();
						}
						else
						{
							Swal.fire({
							   title: '오류가 발생하였습니다.(1)',
							   icon: 'warning',
							   
							   showCancelButton: false,
							   showconfirmButton: true,
							   confirmButtonColor: '#3085d6',  
							   confirmButtonText: '확인',
							});
							$("#userId").focus();
						}
					}
				}
				else
				{
					Swal.fire({
							   title: '오류가 발생하였습니다.',
							   icon: 'warning',
							   
							   showCancelButton: false,
							   showconfirmButton: true,
							   confirmButtonColor: '#3085d6',  
							   confirmButtonText: '확인',
							});
							$("#userId").focus();
					$("#userId").focus();
				}
			},
			complete:function(data)
			{
				icia.common.log(data);
			},
			error:function(xhr, status, error)
			{
				icia.common.error(error);
			}
		});
	   
	}
	
	//임시비밀번호 로그인시 상태변경
	function fn_updateFakeStatus()
	{
		$.ajax({
			type:"POST",
			url:"/user/updateFakeStatus",
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response)
			{
			},
			error:function(xhr, status, error)
			{
				icia.common.error(error);
			}
		});
	}
	
	//이메일 인증번호 클릭시
	function fn_emailCheck()
	{
		//이메일 정규식
		var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
		
		if($.trim($("#userEmail").val()).length <= 0)
		{
			$("#userEmailMsg").text("사용자 이메일을 입력하세요.");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}	
		
		if(!emailReg.test($("#userEmail").val())) 
		{
			$("#userEmailMsg").text("정확한 이메일을 입력하세요.");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/user/emailCheck",
			data:{
				userEmail:$("#userEmail").val()
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
					$("#userEmailMsg").text("중복이메일 아님. 사용 가능합니다.").css('color', 'blue');
					$("#userEmailMsg").css("display", "inline");
					emailCheck = 'Y';
					fn_emailCodeCheck();
				}
				else if(response.code == 100)
				{
					$("#userEmailMsg").text("중복이메일 입니다.");
					$("#userEmailMsg").css("display", "inline");
					$("#userEmail").focus();
				}
				else if(response.code == 400)
				{
					$("#userEmailMsg").text("이메일을 입력하세요.");
					$("#userEmailMsg").css("display", "inline");
					$("#userEmail").focus();
				}
				else
				{
					$("#userEmailMsg").text("알맞은 이메일 형식이 아닙니다.");
					$("#userEmailMsg").css("display", "inline");
					$("#userEmail").focus();
				}
			},
			error:function(xhr, status, error)
			{
				icia.common.error(error);
			}
		});
	}
	
	//이메일 인증코드 전송
	function fn_emailCodeCheck()
	{
		$.ajax({
			type:"POST",
			url:"/sendMail.do",
			data:{
				userEmail:$("#userEmail").val()
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
				   icon: 'info',
				   
				   showCancelButton: false,
				   showconfirmButton: true,
				   confirmButtonColor: '#3085d6',  
				   confirmButtonText: '확인',
				});
			},
			error:function(xhr, status, error)
			{
				icia.common.error(error);
			}
		});
	}
	
	//이메인 인증코드 체크
	function fn_emailPinCheck()
	{
		$.ajax({
			type:"POST",
			url:"/sendMailCode.do",
			data:{
				userEmail:$("#userEmail").val(),
				authNum:$("#authNum").val()
			},
			datatype:"JSON",
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response)
			{
				if(response.msg == "인증 성공!")
				{
					$("#authNumMsg").text("인증 성공! 다음단계를 진행하세요.");
					$("#authNumMsg").css("display", "inline");
					emailPinCheck = 'Y';
				}
				else
				{
					$("#authNumMsg").text("인증 실패. 올바른 인증번호를 입력하세요.");
					$("#authNumMsg").css("display", "inline");
					$("#authNum").val("");
					$("#authNum").focus();
				}
			},
			error:function(xhr, status, error)
			{
				icia.common.error(error);
			}
		});
	}
	
	//회원가입
	function fn_joinCheck()
	{
		//공백체크 정규식
		var emptCheck = /\s/g;
		// 영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
		var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
		
		if(idCheck == 'Y')
		{
			if(emailCheck == 'Y')
			{
				if(emailPinCheck == 'Y')
				{
					if($.trim($("#userName").val()).length <= 0)
					{
						$("#userNameMsg").text("사용자 이름을 입력하세요.");
						$("#userNameMsg").css("display", "inline");
						$("#userName").val("");
						$("#userName").focus();
						return;
					}
					
					if($.trim($("#userPwd1").val()).length <= 0)
					{
						$("#userPwd1Msg").text("비밀번호를 입력하세요.");
						$("#userPwd1Msg").css("display", "inline");
						$("#userPwd1").val("");
						$("#userPwd1").focus();
						return;
					}
					
					if(emptCheck.test($("#userPwd1").val())) 
					{
						$("#userPwd1Msg").text("비밀번호는 공백을 포함할수 없습니다.");
						$("#userPwd1Msg").css("display", "inline");
						$("#userPwd1").val("");
						$("#userPwd1").focus();
						return;
					}
					
					if(!idPwCheck.test($("#userPwd1").val())) 
					{
						$("#userPwd1Msg").text("비밀번호는 영문 대소문자와 숫자로 4~12자리로 입력가능합니다.");
						$("#userPwd1Msg").css("display", "inline");
						$("#userPwd1").val("");
						$("#userPwd1").focus();
						return;
					}
					
					if($.trim($("#userPwd2").val()).length <= 0)
					{
						$("#userPwd2Msg").text("비밀번호확인를 입력하세요.");
						$("#userPwd2Msg").css("display", "inline");
						$("#userPwd2").val("");
						$("#userPwd2").focus();
						return;
					}
					
					if($("#userPwd1").val() != $("#userPwd2").val()) 
					{
						$("#userPwd2Msg").text("비밀번호가 일치하지 않습니다.");
						$("#userPwd2Msg").css("display", "inline");
						$("#userPwd2").focus();
						return;
					}
					
					$("#userPwd").val($("#userPwd1").val());
					
					$.ajax({
						type:"POST",
						url:"/user/regProc",
						data:{
							userId:$("#userId").val(),
							userPwd:$("#userPwd").val(),
							userName:$("#userName").val(),
							userEmail:$("#userEmail").val(),
							addrCode:$("#addrCode").val(),
							addrBase:$("#addrBase").val(),
							addrDetail:$("#addrDetail").val(),
							rating:$("#rating").val()
						},
						dataType:"JSON",
						beforeSend:function(xhr)
						{
							xhr.setRequestHeader("AJAX", "true");
						},
						success:function(response)
						{
							if(response.code == 0)
							{
								Swal.fire({
									   title: '회원가입이 되었습니다.',
									   icon: 'success',
									   
									   showCancelButton: false,
									   showconfirmButton: true,
									   confirmButtonColor: '#3085d6',  
									   confirmButtonText: '확인',
									}).then(result => {
										location.href = "/";
									});
							}
							else if(response.code == 100)
							{
								Swal.fire({
									   title: '회원 아이디가 중복 되었습니다.',
									   icon: 'warning',
									   
									   showCancelButton: false,
									   showconfirmButton: true,
									   confirmButtonColor: '#3085d6',  
									   confirmButtonText: '확인',
									});
								$("#userId").focus();
							}
							else if(response.code == 400)
							{
								Swal.fire({
									   title: '우편번호를 입력해주세요.',
									   icon: 'warning',
									   
									   showCancelButton: false,
									   showconfirmButton: true,
									   confirmButtonColor: '#3085d6',  
									   confirmButtonText: '확인',
									});
								$("#userId").focus();	
							}
							else if(response.code == 500)
							{
								Swal.fire({
									   title: '회원 가입 중 알수없는 오류가 발생하였습니다.',
									   icon: 'warning',
									   
									   showCancelButton: false,
									   showconfirmButton: true,
									   confirmButtonColor: '#3085d6',  
									   confirmButtonText: '확인',
									});
								$("#userId").focus();
							}
						},
						error:function(xhr, status, error)
						{
							icia.common.error(error);
						}
					});
				}
				else
				{
					Swal.fire({
					   title: '이메일인증 후 진행가능합니다.',
					   icon: 'warning',
					   
					   showCancelButton: false,
					   showconfirmButton: true,
					   confirmButtonColor: '#3085d6',  
					   confirmButtonText: '확인',
					});
				}
			}
			else
			{
				Swal.fire({
					   title: '이메일체크검사 후 진행가능합니다.',
					   icon: 'warning',
					   
					   showCancelButton: false,
					   showconfirmButton: true,
					   confirmButtonColor: '#3085d6',  
					   confirmButtonText: '확인',
					});
			}
		}
		else
		{
			Swal.fire({
				   title: '아이디 중복체크검사 후 진행가능합니다.',
				   icon: 'warning',
				   
				   showCancelButton: false,
				   showconfirmButton: true,
				   confirmButtonColor: '#3085d6',  
				   confirmButtonText: '확인',
				});
		}
	}
	
	//아이디 중복체크
	function fn_idCheck()
	{
		$.ajax({
			type:"POST",
			url:"/user/idCheck",
			data:{
				userId:$("#userId").val()
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
					$("#userIdMsg").text("중복아이디 아님. 회원가입 가능합니다.").css('color', 'blue');
					$("#userIdMsg").css("display", "inline");
					idCheck = 'Y';
				}
				else if(response.code == 100)
				{
					$("#userIdMsg").text("중복아이디 입니다.");
					$("#userIdMsg").css("display", "inline");
					$("#userId").focus();
				}
				else if(response.code == 400)
				{
					$("#userIdMsg").text("아이디를 입력하세요.");
					$("#userIdMsg").css("display", "inline");
					$("#userId").focus();
				}
				else
				{
					$("#userIdMsg").text("알맞은 아이디 형식이 아닙니다.");
					$("#userIdMsg").css("display", "inline");
					$("#userId").focus();
				}
			},
			error:function(xhr, status, error)
			{
				icia.common.error(error);
			}
		});
	}
	
	//input 하단의 안내 메세지 모두 숨김
	function fn_displayNone() 
	{
	   $("#userIdMsg").css("display", "none");
	   $("#userIdLoginMsg").css("display", "none");
	   $("#userEmailMsg").css("display", "none");
	   $("#userNameMsg").css("display", "none");
	   $("#authNumMsg").css("display", "none");
	   $("#userPwd1Msg").css("display", "none");
	   $("#userPwd2Msg").css("display", "none");
	   $("#userPwdLoginMsg").css("display", "none");
	   
	}
</script>
</head>
<body>
	<div class="wrapper">
		<div class="container">
			<div class="sign-up-container">
				<form>
					<a href="/index"><img alt="" src="/resources/images/logo4.png" style="margin-bottom: 20px; opacity: 0.8;"></a>
					<h1>Create Account</h1>
					<div class="social-links">
						<!-- <div>
							<a href="#"><i class="fa fa-google" aria-hidden="true"></i></a>
						</div> -->
					</div>

					<div class="inputBtn-container">
						<input type="text" id="userId" name="userId" class="leftBox" placeholder="ID">
						<button type="button" id="idBtn" class="form_btn idBtn rightBtn">
							<span class="idCheckMsg">아이디 중복 체크</span>
						</button>
					</div>
					<div class="msgBox">
						<span id="userIdMsg" class="msgText"></span>
					</div>

					<div class="inputBtn-container">
						<input type="email" id="userEmail" name="userEmail" class="leftBox" placeholder="Email">
						<button type="button" id="emailBtn" class="form_btn emailBtn rightBtn">
							<span class="authSendMsg">인증번호 전송</span>
						</button>
					</div>
					<div class="msgBox">
						<span id="userEmailMsg" class="msgText"></span>
					</div>

					<div class="inputBtn-container">
						<input type="text" id="authNum" name="authNum" class="emailInput leftBox" value="" placeholder="Authentication Number" maxlength="6">
						<button type="button" id="authBtn" class="form_btn authBtn rightBtn">
							<span class="authCheckMsg">인증번호 체크</span>
						</button>
					</div>
					<div class="msgBox">
						<span id="authNumMsg" class="msgText"></span>
					</div>

					<input type="text" id="userName" name="userName" placeholder="Name">
					<div class="msgBox">
						<span id="userNameMsg" class="msgText"></span>
					</div>

					<input type="password" id="userPwd1" name="userPwd1" placeholder="Password">
					<div class="msgBox">
						<span id="userPwd1Msg" class="msgText"></span>
					</div>

					<input type="password" id="userPwd2" name="userPwd2" placeholder="Password Check">
					<div class="msgBox">
						<span id="userPwd2Msg" class="msgText"></span>
					</div>

					<div class="inputBtn-container">
						<input type="text" id="addrCode" name="addrCode" class="leftBox" placeholder="Postal Code" maxlength="5">
						<button type="button" id="addrBtn" class="form_btn emailBtn rightBtn" onclick="checkPost()">
							<span>우편번호 검색</span>
						</button>
					</div>
					<input type="text" id="addrBase" name="addrBase" placeholder="Address">
					<input type="text" id="addrDetail" name="addrDetail" placeholder="Detailed Address">

					<input type="hidden" id="userPwd" name="userPwd" value="">

					<button type="button" id="realSignUpBtn" class="form_btn">Sign Up</button>
				</form>
			</div>
			<div class="sign-in-container">
				<form>
					<a href="/index"><img alt="" src="/resources/images/logo4.png" style="margin-bottom: 20px; opacity: 0.8;"></a>
					<h1>Sign In</h1>
					<div class="social-links">
						<!-- 소셜 로그인을 하실 분은 아래의 div를 사용하시면 됩니다 -->
						<!-- <div onclick="fn_naverLogin()">
							<img alt="" src="/resources/images/naver.png">
						</div> -->
					</div>
					<input type="text" id="userIdLogin" name="userIdLogin" placeholder="ID">
					<div class="msgBox">
						<span id="userIdLoginMsg" class="msgText"></span>
					</div>

					<input type="password" id="userPwdLogin" name="userPwdLogin" placeholder="Password" style="margin-top: 30px;">
					<div class="msgBox">
						<span id="userPwdLoginMsg" class="msgText"></span>
					</div>

					<div class="find-link">
						<span><a href="/user/findForm">Forgot your Account?</a></span>
					</div>

					<button type="button" id="realSignInBtn" class="form_btn">Sign In</button>
				</form>
			</div>
			<div class="overlay-container">
				<div class="overlay-left">
					<h1>Welcome Back</h1>
					<p>To keep connected with us please login with your personal info</p>
					<button id="signInBtn" class="overlay_btn">Sign In</button>
				</div>
				<div class="overlay-right">
					<h1>Hello, Friend</h1>
					<p>Enter your personal details and start journey with us</p>
					<button id="signUpBtn" class="overlay_btn">Sign Up</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>