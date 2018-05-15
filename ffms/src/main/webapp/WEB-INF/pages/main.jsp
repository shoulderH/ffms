<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/common/Head.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>理财管理系统主页</title>
<link class="uiTheme" rel="stylesheet" type="text/css" href="${basePath}jquery-easyui-1.3.3/themes/<%=themeName %>/easyui.css">
<link rel="stylesheet" type="text/css" href="${basePath}jquery-easyui-1.3.3/themes/icon.css">
<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.min.js"></script>
<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.cookie.js"></script>
<script type="text/javascript">
	$(function(){
		$("#ith").combobox({
			panelHeight:200,
			onChange:function(newVal, oldVal){
				var oldHref = $('.uiTheme').attr('href');
				var newHref = oldHref.substring(0,oldHref.indexOf('themes')) + 'themes/' + newVal + '/easyui.css';
				//console.log(newHref);
				$('.uiTheme').attr('href', newHref);
				//设置cookie值，并设置7天有效时间
				$.cookie('themeName', newVal, {
					expires : 7
				});
			}
		});
		$.post("${basePath}moneyAnalysis.do", {}, function(result) {
			$.messager.show({
                title:'金额提醒',
                msg:'您目前的消费金额情况如下：<br/>总收入金额：'+result.totalIncomeMoney+"元。<br/>总支出金额："+result.totalPayMoney+"元。<br/>您的余额为："+result.totalLostMoney+"元。",
                //十分钟弹出一次
                timeout:10000,  
                showType:'show',
                height:'100%'
            });
		},"json");
		setMoneyTime();
		function setMoneyTime(){
			setTimeout(function(){
		        $.post("${basePath}moneyAnalysis.do", {}, function(result) {
		        	setMoneyTime();
		        	if(result.totalLostMoney<2000){
		        		$.messager.show({
		                     title:'金额提醒',
		                     msg:'您的余额已不足2000元。<br/>您目前的消费金额情况如下：<br/>总收入金额：'+result.totalIncomeMoney+"元。<br/>总支出金额："+result.totalPayMoney+"元。<br/>您的余额为："+result.totalLostMoney+"元。",
		                     timeout:10000,
		                     showType:'show',
		                     height:'100%'
		                });
		        	}
		    	},"json");
		    },10000);
		}
	});
	
	var url;

	function openTab(text, url, iconCls) {
		if ($("#tabs").tabs("exists", text)) {
			$("#tabs").tabs("select", text);
		} else {
			var content = "<iframe frameborder=0 scrolling='auto' style='width:100%;height:100%' src='${basePath}"
					+ url + "'></iframe>";
			$("#tabs").tabs("add", {
				title : text,
				iconCls : iconCls,
				closable : true,
				content : content
			});
		}
	}

	function openPasswordModifyDialog() {
		$("#dlg").dialog("open").dialog("setTitle", "修改密码");
		url = "${basePath}modifyPassword.do?";
	}

	function closePasswordModifyDialog() {
		$("#dlg").dialog("close");
		$("#oldPassword").val("");
		$("#newPassword").val("");
		$("#newPassword2").val("");
	}

	function modifyPassword() {
		$("#fm").form("submit", {
			url : url,
			onSubmit : function() {
				var oldPassword = $("#oldPassword").val();
				var newPassword = $("#newPassword").val();
				var newPassword2 = $("#newPassword2").val();
				/* if (!$(this).form("validate")) {
					return false;
				} */
				if (oldPassword != '${currentUser.password}') {
					$.messager.alert("系统提示", "用户原密码输入错误！");
					return false;
				}
				if (newPassword != newPassword2) {
					$.messager.alert("系统提示", "确认密码输入错误！");
					return false;
				}
				
				if(oldPassword == '${currentUser.password}'
						&&oldPassword==newPassword2
						&&oldPassword==newPassword) {
					$.messager.alert("系统提示", "密码未更改！");
					return false;
				}
				return true;
			},
			success : function(result) {
				var results = eval('(' + result + ')');
				if (results.success) {
					$.messager.alert("系统提示", "密码修改成功，下一次登录生效！");
					closePasswordModifyDialog();
				} else {
					$.messager.alert("系统提示", "密码修改失败");
					return;
				}
			}
		});
	}
 	
	function openMessageModifyDialog(){
		$("#mdlg").dialog("open").dialog("setTitle", "修改用户信息");
		url = "${basePath}usersave.do?";
	}
	
	function modifyMessage(){
		$("#mfm").form("submit",{
			url:url,
			onSubmit:function(){
				var province = $("#p").val();
				var city = $("#c").val();
				var county = $("#cy").val();
				if(province==""||city==""||county==""){
					$.messager.alert("系统提示","请选择住址！");
					return false;
				}
				if($("#sex").combobox("getValue")==""||$("#sex").combobox("getValue")==null){
					$.messager.alert("系统提示","请选择性别！");
					return false;
				}
				return $(this).form("validate");
			},
			success:function(result){
				var results=eval('('+result+')');
				if(results.errres){
					$.messager.alert("系统提示",results.errmsg);
					$("#mdlg").dialog("close");
				}else{
					$.messager.alert("系统提示",results.errmsg);
					return;
				}
			}
		});
	}
	
	function closeMessageModifyDialog(){
		$("#mdlg").dialog("close");
	} 

	function logout() {
		$.messager.confirm("系统提示", "您确定要退出系统吗", function(r) {
			if (r) {
				window.location.href = "${basePath}logout.do";
			}
		});
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
<body class="easyui-layout">
	<div region="north" style="height: 78px;">
		<table style="padding: 5px" width="100%">
			<tr>
				<td width="20%"><img
					src="${basePath}resource/images/bglogo.png" /></td>
				<td valign="bottom" align="right" width="80%">
					<font size="3">&nbsp;&nbsp;<strong>欢迎：</strong>${currentUser.username }&nbsp;&nbsp;&nbsp;&nbsp;</font>
					<a href="javascript:openPasswordModifyDialog()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-modifyPassword'" style="width: 80px;">修改密码</a>
					&nbsp;&nbsp;&nbsp;&nbsp;主题风格：
					<select id="ith" class="easyui-combobox" name="theme">
						<option value="default">default</option>
						<option value="black">black</option>
						<option value="gray">gray</option>
						<option value="bootstrap">bootstrap</option>
						<option value="metro">metro</option>
						<option value="metro-blue">metro-blue</option>
						<option value="metro-gray">metro-gray</option>
						<option value="metro-green">metro-green</option>
						<option value="metro-orange">metro-orange</option>
						<option value="metro-red">metro-red</option>
						<option value="ui-cupertino">ui-cupertino</option>
						<option value="ui-dark-hive">ui-dark-hive</option>
						<option value="ui-pepper-grinder">ui-pepper-grinder</option>
						<option value="ui-sunny">ui-sunny</option>
					</select>&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:logout()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-exit'" style="width: 80px;">安全退出</a>
				</td>
			</tr>
		</table>
	</div>
	<div region="center">
		<div class="easyui-tabs" fit="true" border="false" id="tabs">
			<div title="首页" data-options="iconCls:'icon-home'">
				<div align="center" style="padding-top: 100px">
					<font color="red" size="10">欢迎使用</font>
				</div>
			</div>
		</div>
	</div>

	<div region="west" style="width: 200px" title="导航菜单" split="true">
		<div class="easyui-accordion" data-options="fit:true,border:false">
			<div title="收支管理" data-options="selected:true,iconCls:'icon-yxgl'" style="padding: 10px">
				<a href="javascript:openTab('收入信息管理','incomeManage.do','icon-yxjhgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-yxjhgl'" style="width: 150px;">收入信息管理</a> 
				<a href="javascript:openTab('支出信息管理','payManage.do','icon-khkfjh')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khkfjh'" style="width: 150px;">支出信息管理</a>
				<a href="javascript:openTab('家庭简况','familyBrief.do','icon-khgcfx')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khgcfx'" style="width: 150px;">家庭简况</a>
			</div>
			<div title="证券管理" data-options="iconCls:'icon-khgl'" style="padding: 10px;">
				<a href="javascript:openTab('证券帐户管理','securityManage.do','icon-khxxgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khxxgl'" style="width: 150px;">证券帐户管理</a>
				<a href="javascript:openTab('证券流水管理','tradeManage.do','icon-khlsgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khlsgl'" style="width: 150px;">证券流水管理</a>
			</div>
			<div title="报表管理" data-options="iconCls:'icon-chart'" style="padding: 10px">
				<a href="javascript:openTab('收入信息报表','incomeTimeManage.do','icon-khgxfx')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khgxfx'" style="width: 150px;">收入信息报表</a> 
				<a href="javascript:openTab('支出信息报表','payTimeManage.do','icon-khgcfx')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khgcfx'" style="width: 150px;">支出信息报表</a>
			    <a href="javascript:openTab('按类型报表','typePieManage.do','icon-khgcfx')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khgcfx'" style="width: 150px;">按类型报表</a>
			    <c:if test="${currentUser.appellation=='管理员' }">
					 <a href="javascript:openTab('家庭分析报表','analysisMange.do','icon-khgcfx')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khgcfx'" style="width: 150px;">家庭分析报表</a>
				</c:if>
			</div>
			<div title="用户管理" data-options="iconCls:'icon-item'" style="padding: 10px">
				<c:if test="${currentUser.appellation=='管理员' }">
					 <a href="javascript:openTab('用户信息管理','userManage.do','icon-sjzdgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-sjzdgl'" style="width: 150px;">用户信息管理</a>
				</c:if>
				<a href="javascript:openMessageModifyDialog()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khxxgl'" style="width: 150px;">修改用户信息</a> 
				<a href="javascript:openPasswordModifyDialog()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-modifyPassword'" style="width: 150px;">修改密码</a> 
				<a href="javascript:logout()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-exit'" style="width: 150px;">安全退出</a>
			</div>
		</div>
	</div>


	<div id="dlg" class="easyui-dialog" style="width: 400px; height: 250px; padding: 10px 20px" closed="true" buttons="#dlg-buttons">
		<form id="fm" method="post">
			<table cellspacing="8px">
				<tr>
					<td>用户名：</td>
					<td><input type="text" id="username" name="username" value="${currentUser.username }" readonly="readonly" style="width: 200px" /></td>
				</tr>
				<tr>
					<td>原密码：</td>
					<td><input type="password" id="oldPassword" class="easyui-validatebox" required="true" style="width: 200px" /></td>
				</tr>
				<tr>
					<td>新密码：</td>
					<td><input type="password" id="newPassword" name="password" class="easyui-validatebox" required="true" style="width: 200px" /></td>
				</tr>
				<tr>
					<td>确认新密码：</td>
					<td><input type="password" id="newPassword2" class="easyui-validatebox" required="true" style="width: 200px" /></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:modifyPassword()" class="easyui-linkbutton" iconCls="icon-ok">保存</a> 
		<a href="javascript:closePasswordModifyDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
	
	
	<div id="mdlg" class="easyui-dialog" style="width: 670px;height:300px;padding: 10px 20px" closed="true" buttons="#mdlg-buttons">
	 	<form id="mfm" method="post">
	 		<table cellspacing="8px">
	 			<tr>
	 				<td>用户名：</td>
	 				<td><input type="text" id="m_username" name="username" class="easyui-validatebox easyui-textbox" readonly="readonly" value="${usermessage.username }"/></td>
	 				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	 				<td>真实姓名：</td>
	 				<td><input type="text" id="truename" name="truename" class="easyui-combobox" required="true" value="${usermessage.truename }"/>&nbsp;<font color="red">*</font></td>
	 			</tr>
	 			<tr>
	 				<td>性别：</td>
	 				<td>
	 					<select class="easyui-combobox" id="sex" name="sex" editable="false" style="width:175px;">
	 						<option value="">请选择...</option>
	 						<option value="男" <c:if test="${usermessage.sex=='男' }"> selected="selected" </c:if>>男</option>
	 						<option value="女" <c:if test="${usermessage.sex=='女' }"> selected="selected" </c:if>>女</option>
	 					</select>&nbsp;<font color="red">*</font></td>
	 				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	 				<td>邮箱：</td>
	 				<td><input type="text" id="email" name="email" class="easyui-validatebox easyui-textbox" validType="email" required="true" value="${usermessage.email }"/>&nbsp;<font color="red">*</font></td>
	 			</tr>
	 			<tr>
	 				<td>住址：</td>
	 				<td> 
	 					   <select  name="province" id="p" onchange="selectCity()">
	 					        <option value="${usermessage.province }">${usermessage.province }</option> 
	 					 <!--    <option value="">=省份=</option> -->
                           </select>
                           <select name="city" id="c" onchange="selectCounty()">
                       	          <option value="${usermessage.city }">${usermessage.city }</option> 
                    <!--    	  <option value="">=城市=</option> -->
                           </select>
                           <select name="county" id="cy" onchange="selectInfo()">
                    	 	        <option value="${usermessage.county }">${usermessage.county }</option> 
                    	<!--  <option value="">=区县=</option> -->
                           </select>
                           &nbsp;<font color="red">*</font>
                    </td>
	 				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	 				<input type="text" id="password" name="password" value="${usermessage.password }" style="display:none">
	 			</tr>
	 		</table>
	 	</form>
	</div> 
	<div id="mdlg-buttons">
		<a href="javascript:modifyMessage()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeMessageModifyDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
</body>
</html>