<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>理财管理系统登录</title>
	<link rel="stylesheet" type="text/css" href="${basePath}bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="${basePath}bootstrap/css/bootstrap-reset.css">
	<link rel="stylesheet" type="text/css" href="${basePath}bootstrap/css/jquery-ui-1.10.3.css">
	<link rel="stylesheet" type="text/css" href="${basePath}bootstrap/css/font-awesome.css">
	<link rel="stylesheet" type="text/css" href="${basePath}resource/css/style.css" />
	<style  type="text/css">
	.loginBlock {
	border: 1px #DDDEDF solid;
	padding-top: 5px;
	text-align: center;
	width: 120px;
	height: 30px;
	color: gray;
}

.on {
	background-color: #00C1DF !important;
	color: white;
}

.block-r {
	margin-top: -30px;
	float: right;
}
.input-t {
	margin-bottom: 10px;
}
.loginBorder{

}
</style>
<script type="text/javascript">
//选择性别后 的相关变化
function judgeSex(num) {
	var value;
	var sex = document.getElementById("sex");
	var list = document.getElementsByName("block");
	if (num == 0) { // 如果选择男的去除女的on样式（背景色），获取男的value
		list[num].setAttribute('class', 'block-l loginBlock on');
		list[num + 1].setAttribute('class', 'block-r loginBlock');
		value = document.getElementById("block-l").innerHTML;
	} else { // 如果选择女的去除男的on样式（背景色），获取女的value
		list[num - 1].setAttribute('class', 'block-l loginBlock');
		list[num].setAttribute('class', 'block-r loginBlock on');
		value = document.getElementById("block-r").innerHTML;
	}
	sex.value = value;

}
function createXMLHttpRequest() {
	try {
		return new XMLHttpRequest(); //主流浏览器
	} catch (e) {
		try {
			return ActiveXObject("Msxml2.XMLHTTP"); //IE6.0
		} catch (e) {
			try {
				return ActiveXObject("Microsoft.XMLHTTP");
			} catch (e) {
				throw e;
			}
		}
	}
}
//点击省份下拉框变化
window.onload = function() {
	var xmlhttp = createXMLHttpRequest();
	xmlhttp.open("POST", "${basePath}province.do", true);
	xmlhttp.send(null);
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
			var info = xmlhttp.responseText;
			var arr = info.split(",");
			for (var i = 0; i < arr.length; i++) {
				var op = document.createElement("option");
				op.value = arr[i];
				var textNode = document.createTextNode(arr[i]);
				op.appendChild(textNode);
				document.getElementById("p").appendChild(op);
			}
		}
	}
}

//选择省之后城市变化
 function selectCity(){
     var xmlHttp = createXMLHttpRequest();
     xmlHttp.open("POST","${basePath}city.do",true);
     xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
     var pname = document.getElementById("p").value;
     xmlHttp.send("pname="+pname);
     xmlHttp.onreadystatechange = function() {
if(xmlHttp.readyState == 4 && xmlHttp.status == 200){
             var citySelect = document.getElementById("c");
             var optionEleList = citySelect.getElementsByTagName("option");
             while(optionEleList.length > 1){
                 citySelect.removeChild(optionEleList[1]);//总是删除第一个下标，因为删除1了下面的会顶上来
             }
             var doc = xmlHttp.responseXML;
             var cityElementList = doc.getElementsByTagName("city");
             for(var i=0;i<cityElementList.length;i++){
                 var cityElement = cityElementList[i];
                 var cityName;
             //    if(window.addEventListener) {
                  //   cityName = cityElement.textContent;//支持火狐等浏览器
                  cityName=cityElement.getAttribute("name");
              //   } else{
                   //  cityName = cityElement.text;//支持IE
           //      }

                 var option = document.createElement("option");
                 option.value = cityName;
                 var textNode = document.createTextNode(cityName);
                 option.appendChild(textNode);
                 //定义在之前：var citySelect = document.getElementById("c");
                 citySelect.appendChild(option);
             }
         }
     };
 }
 
 //选择城市之后县区变化
 function selectCounty(){
     var xmlHttp = createXMLHttpRequest();
     xmlHttp.open("POST","${basePath}county.do",true);
     xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
     var cname = document.getElementById("c").value;
     xmlHttp.send("cname="+cname);
     xmlHttp.onreadystatechange = function() {
if(xmlHttp.readyState == 4 && xmlHttp.status == 200){
             var countySelect = document.getElementById("cy");
             var optionEleList = countySelect.getElementsByTagName("option");
             while(optionEleList.length > 1){
                 countySelect.removeChild(optionEleList[1]);//总是删除第一个下标，因为删除1了下面的会顶上来
             }
             var doc = xmlHttp.responseXML;
             var countyElementList = doc.getElementsByTagName("region");
             for(var i=0;i<countyElementList.length;i++){
                 var countyElement = countyElementList[i];
                 var countyName;
             //    if(window.addEventListener) {
                  //   cityName = cityElement.textContent;//支持火狐等浏览器
                 countyName=countyElement.getAttribute("name");
              //   } else{
                   //  cityName = cityElement.text;//支持IE
           //      }

                 var option = document.createElement("option");
                 option.value = countyName;
                 var textNode = document.createTextNode(countyName);
                 option.appendChild(textNode);
                 //定义在之前：var citySelect = document.getElementById("c");
                 countySelect.appendChild(option);
             }
         }
     };
 }
</script>
</head>
<body class="login-body">
    <div class="container">
		<form class="form-signin">
		    <div class="form-signin-heading text-center">
		        <h1 class="sign-title">注册</h1>
		        <h2 style="color:#008CBA;">理财管理系统</h2>
		    </div>
		    <div class="login-wrap">
		        <input type="text" name="username" id="inputUsername" class="form-control" placeholder="请输入用户名" autofocus>
		        <div class="input-t">
                       		 <div class="block-l loginBlock on" id="block-l" name="block"  onclick="judgeSex(0)">男</div>
                       		 <div class="block-r loginBlock" id="block-r" name="block"  onclick="judgeSex(1)">女</div>
                       		 <input id="sex" name="sex" type=text style="display:none" value="男">
                       </div>
           		<input type="password" name="password" id="inputPassword" class="form-control" placeholder="请输入密码">
		        <input type="password" id="surePassword" class="form-control" placeholder="请再次输入密码">
 					<div class="form-group loginBorder">
                       <!--  <label class="control-label"></label> -->
                  
                           <select  name="province" id="p" onchange="selectCity()">
                           		<option value="">=省份=</option>
                           </select>
                           <select name="city" id="c" onchange="selectCounty()">
                           		<option value="">=城市=</option>
                           </select>
                           <select name="county" id="cy" onchange="selectInfo()">
                           		<option  value="">=区县=</option>
                           </select>
                    </div>
		        <button id="submitbtn" class="btn btn-lg btn-login btn-block" type="button">
		             <span style="font-size:25px;">注册</span>
		        </button>
		        <h4 style="text-align:center;line-height:40px;">已有账号？<a href="${basePath}index.do">返回登录</a></h4>
		    </div>
		</form>
	</div>
		
	<!-- Modal -->
        <div aria-hidden="true" aria-labelledby="myModalLabel" role="dialog" tabindex="-1" id="myModal" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">提示您</h4>
                    </div>
                    <div class="modal-body">
                        <h4 id="messageshow"></h4>
                    </div>
                    <div class="modal-footer">
                        <button data-dismiss="modal" class="btn btn-success" type="button">确定</button>
                    </div>
                </div>
            </div>
        </div>
    <!-- modal -->
		
	<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.min.js"></script>
	<script src="${basePath}bootstrap/js/bootstrap.min.js"></script>
	<script src="${basePath}bootstrap/js/modernizr.min.js"></script>
		<script>
			$(function(){
				$("#submitbtn").click(function(){
		    		var inputUsername = $("#inputUsername").val();
		    		var inputPassword = $("#inputPassword").val();
		    		var surePassword = $("#surePassword").val();
		    		var sex = $("#sex").val();
		    		var province = $("#p").val();
		    		var city = $("#c").val();
		    		var county = $("#cy").val();
					if(inputUsername==null||inputUsername==""){
		    			$("#messageshow").html("请输入用户名！");
		    			$("#myModal").modal("show");
						$("#myModal").on("hidden.bs.modal", function (e) {
						  	$("#inputUsername").focus();
						});
						return false;
		    		}else if(inputPassword==null||inputPassword==""){
		    			$("#messageshow").html("请输入密码！");
		    			$("#myModal").modal("show");
						$('#myModal').on("hidden.bs.modal", function (e) {
						  	$("#inputPassword").focus();
						});
						return false;
		    		}else if(surePassword!=inputPassword){
		    			$("#messageshow").html("两次密码输入不一致！");
		    			$("#myModal").modal("show");
						$('#myModal').on("hidden.bs.modal", function (e) {
						  	$("#surePassword").focus();
						});
						return false;
		    		}else if(province==""||city==""||county==""){
		    			$("#messageshow").html("请输入地址！");
		    			$("#myModal").modal("show");
						$('#myModal').on("hidden.bs.modal", function (e) {
						  	if(province==""){
						  		$("#p").focus();
						  	}else{
						  		if(city==""){
						  			$("#c").focus();
						  		}else{
						  			$("#cy").focus();
						  		}
						  	}
						});
						return false;
		    		}else{
		    			$.ajax({
							url:"${basePath}gosign.do",
							type:"post",
							dataType:"text",
							data:{"username":inputUsername,"password":inputPassword,"sex":sex,
								"province":province,"city":city,"county":county},
							success:function(data){
								var result=eval('('+data+')');
								if(result.errres){
									$("#messageshow").html(result.errmsg);
					    			$("#myModal").modal("show");
					    			$("#myModal").on("hidden.bs.modal", function (e) {
					    				window.location.href="${basePath}index.do";
									});
								}else{
				            		$("#messageshow").html(result.errmsg);
					    			$("#myModal").modal("show");
					    			$("#myModal").on("hidden.bs.modal", function (e) {
									  	$("#"+result.inputfocus).focus();
									});
								}
							}
		    			});
				    }
		    	});
		    	
				$(document).keydown(function(event){ 
					if(event.keyCode == 13){
						event.preventDefault();
						$("#submitbtn").click();
					}
				});
			});
	    </script>
</body>
</html>