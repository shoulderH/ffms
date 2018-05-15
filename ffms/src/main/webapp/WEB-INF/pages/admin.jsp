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
	//在页面中打开嵌套另一个页面
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
	//修改密码
	function openPasswordModifyDialog() {
		$("#dlg").dialog("open").dialog("setTitle", "修改密码");
		url = "${basePath}modifyPassword.do";
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
 	
	
	//退出系统
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
			<div title="管理员分配" data-options="selected:true,iconCls:'icon-yxgl'" style="padding: 10px">
				<a href="javascript:openTab('管理员信息','distributeManage.do','icon-yxjhgl')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-yxjhgl'" style="width: 150px;">管理员信息</a> 
			</div>
			<div title="地域财政" data-options="iconCls:'icon-chart'" style="padding: 10px">
				<a href="javascript:openTab('地域收支信息','regionalFinance.do','icon-khgxfx')" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-khgxfx'" style="width: 150px;">地域收支信息</a> 
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
	
</body>
</html>	