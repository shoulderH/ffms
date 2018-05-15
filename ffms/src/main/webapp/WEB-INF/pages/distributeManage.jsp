<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/common/Head.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link class="uiTheme" rel="stylesheet" type="text/css" href="${basePath}jquery-easyui-1.3.3/themes/<%=themeName %>/easyui.css">
<link rel="stylesheet" type="text/css" href="${basePath}jquery-easyui-1.3.3/themes/icon.css">
<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.min.js"></script>
<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.cookie.js"></script>
<script type="text/javascript">

	var url;
	
	function searchManage(){
		$("#dg").datagrid('load',{
			"username":$("#s_username").val(),
			"truename":$("#s_truename").val(),
			"sex":$("#s_sex").combobox("getValue"),
		});
	}
	
	function resetSearch(){
		$("#s_username").val("");
		$("#s_truename").val("");
		$("#s_sex").combobox("setValue","");
	}
	
	function deleteManage(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length==0){
			$.messager.alert("系统提示","请选择要删除的数据！","info");
			return;
		}
		var strUsernames=[];
		for(var i=0;i<selectedRows.length;i++){
			strUsernames.push(selectedRows[i].username);
		}
		var usernames=strUsernames.join(",");
		$.messager.confirm("系统提示","您确认要删除这<font color=red>"+selectedRows.length+"</font>条数据吗？",function(r){
			if(r){
				$.post("${basePath}userdelete.do",{usernames:usernames},function(result){
					if(result.errres){
						$.messager.alert("系统提示",result.errmsg,"info");
						$("#dg").datagrid("reload");
					}else{
						$.messager.alert("系统提示","数据删除失败！","error");
					}
				},"json");
			}
		});
	}
	
	
	function openManageAddDialog(){
		resetValue();
		document.getElementById("username").readOnly=false;
		$("#dlg").dialog("open").dialog("setTitle","添加管理员信息");
		url="${basePath}addmanage.do";
	}
	
	function openManageModifyDialog(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length!=1){
			$.messager.alert("系统提示","请选择一条要编辑的数据！","info");
			return;
		}
		var row=selectedRows[0];
		$("#dlg").dialog("open").dialog("setTitle","编辑管理员信息");
		$('#fm').form('load',row);
		url="${basePath}usersave.do";
	}
	
	function saveManage(){
		$("#fm").form("submit",{
			url:url,
			onSubmit:function(){
				if($("#sex").combobox("getValue")==""||$("#sex").combobox("getValue")==null){
					$.messager.alert("系统提示","请选择性别！","error");
					return false;
				}
				return $(this).form("validate");
			},
			success:function(result){
				var results=eval('('+result+')');
				if(results.errres){
					$.messager.alert("系统提示",results.errmsg,"info");
					resetValue();
					$("#dlg").dialog("close");
					$("#dg").datagrid("reload");
				}else{
					$.messager.alert("系统提示",results.errmsg,"error");
					return;
				}
			}
		});
	}
	
	function resetValue(){
		$("#username").val("");
		$("#truename").val("");
		$("#password").val("");
		$("#email").val("");
		$("#sex").combobox("setValue","");
	}
	
	function closeManageDialog(){
		$("#dlg").dialog("close");
		resetValue();
	}
	
	
</script>
<style>
	.findtable{
		border-width: 1px;
		border-color: #666666;
		border-collapse: collapse;
	}
	.findtable td{
		border-width: 1px;
		padding: 8px;
		border-style: solid;
		border-color: #666666;
		background-color: #ffffff;
	}
</style>
</head>
<body style="margin:1px;">
	<table id="dg" title="用户管理" class="easyui-datagrid"
	 fitColumns="true" pagination="true" rownumbers="true"
	 url="${basePath}managelist.do" fit="true" toolbar="#tb" remoteSort="false" multiSort="true">
	 <thead>
	 	<tr>
	 		<th field="cb" checkbox="true" align="center"></th>
	 		<th field="username" width="100" align="center" sortable="true">用户名</th>
	 		<th field="password" width="100" align="center" sortable="true">密码</th>
	 		<th field="truename" width="100" align="center" sortable="true">真实姓名</th>
	 		<th field="sex" width="100" align="center"  sortable="true">性别</th>
	 		<th field="email" width="100" align="center" sortable="true">邮箱</th>
	 	<!--  	<th field="address" width="100" align="center" sortable="true">住址</th>  -->
	 	</tr>
	 </thead>
	</table>
	<div id="tb">
		<div>
			<a href="javascript:openManageAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a>
			<a href="javascript:openManageModifyDialog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
			<a href="javascript:deleteManage()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
		</div>
		<div >
			&nbsp;管理员：&nbsp;<input type="text" id="s_username" size="15" onkeydown="if(event.keyCode==13) searchManage()"/>
			&nbsp;真实姓名：&nbsp;<input type="text" id="s_truename" size="15" onkeydown="if(event.keyCode==13) searchManage()"/>
			&nbsp;性别：&nbsp;<select class="easyui-combobox" id="s_sex"  editable="false" style="width:140px;">
					<option value="">请选择...</option>
					<option value="男">男</option>
					<option value="女">女</option>
				</select>&nbsp;
			<a href="javascript:searchManage()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
			<a href="javascript:resetSearch()" class="easyui-linkbutton" iconCls="icon-reset" plain="true">清空</a>
		</div>
	</div>
	
	<div id="dlg" class="easyui-dialog" style="width: 670px;height:300px;padding: 10px 20px" closed="true" buttons="#dlg-buttons">
	 	<form id="fm" method="post">
	 		<table cellspacing="8px">
	 			<tr>
	 				<td>用户名：</td>
	 				<td><input type="text" id="username" name="username" class="easyui-validatebox easyui-textbox" readonly="readonly" required="true"/>&nbsp;<font color="red">*</font></td>
	 				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	 				<td>密码：</td>
	 				<td><input type="text" id="password" name="password" class="easyui-validatebox easyui-textbox" required="true"/>&nbsp;<font color="red">*</font></td>
	 			</tr>
	 			<tr>
	 				<td>性别：</td>
	 				<td>
	 					<select class="easyui-combobox" id="sex" name="sex" editable="false" style="width:175px;">
	 						<option value="" selected>请选择...</option>
	 						<option value="男">男</option>
	 						<option value="女">女</option>
	 					</select>&nbsp;<font color="red">*</font></td>
	 				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	 				<td>真实姓名：</td>
	 				<td><input type="text" id="truename" name="truename" class="easyui-validatebox easyui-textbox" required="true"/>&nbsp;<font color="red">*</font></td>
	 			</tr>
	 			<tr>
	 				<td>邮箱：</td>
	 				<td><input type="text" id="email" name="email" class="easyui-validatebox easyui-textbox" validType="email" required="true"/>&nbsp;<font color="red">*</font></td>
	 			</tr>
<!-- 	 			<tr>
	 				<td>住址：</td>
	 				<td><input type="text" id="address" name="address" class="easyui-validatebox easyui-textbox" required="true"/>&nbsp;<font color="red">*</font></td>
	 			</tr> -->
	 		</table>
	 	</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:saveManage()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeManageDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
	
</body>
</html>