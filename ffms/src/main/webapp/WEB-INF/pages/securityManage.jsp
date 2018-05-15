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

	function searchSecurity() {
		$("#dg").datagrid('load',{
			"securitynumber" : $("#s_securitynumber").val(),
		});
	}

	function resetSearch() {
		$("#s_securitynumber").val("");
	}
	
	function deleteSecurity() {
		var selectedRows = $("#dg").datagrid('getSelections');
		if (selectedRows.length == 0) {
			$.messager.alert("系统提示", "请选择要删除的数据！");
			return;
		}
		var strSecuritynumbers = [];
		var strSecuritynumberpasswords=[];
		var strUsernames=[];
		for (var i = 0; i < selectedRows.length; i++) {
			strSecuritynumbers.push(selectedRows[i].securitynumber);
			strSecuritynumberpasswords.push(selectedRows[i].securitypassword);
			strUsernames.push(selectedRows[i].username);
		}
		var securitynumbers = strSecuritynumbers.join(",");
		var securitypasswords = strSecuritynumberpasswords.join(",");
		var usernames = strUsernames.join(",");
		$.messager.confirm("系统提示", "您确认要删除这<font color=red>"
				+ selectedRows.length + "</font>条数据吗？", function(r) {
			if (r) {
				$.post("${basePath}/securitydelete.do", {
					securitynumbers : securitynumbers,securitypasswords:securitypasswords,usernames:usernames
				}, function(result) {
					if (result.errres) {
						$.messager.alert("系统提示", result.errmsg);
						$("#dg").datagrid("reload");
					} else {
						$.messager.alert("系统提示", "数据删除失败！");
					}
				}, "json");
			}
		});
	}

	function openSecurityAddDialog() {
		$("#username").val("${s_username}");
		$("#securitynumber").val("");
 		$("#securitypassword").val("");
		$("#dlg").dialog("open").dialog("setTitle", "添加证券信息");
		url = "${basePath}securitysave.do?mark=1";
	}

	function openSecurityModifyDialog() {
		var selectedRows = $("#dg").datagrid('getSelections');
		if (selectedRows.length != 1) {
			$.messager.alert("系统提示", "请选择一条要编辑的数据！");
			return;
		}
		var row = selectedRows[0];
		$("#dlg").dialog("open").dialog("setTitle", "编辑证券信息");
		$('#fm').form('load', row);
		url = "${basePath}securitysave.do?mark=0";
	}

	function saveSecurity() {
		$("#fm").form("submit",{
			url : url,
			onSubmit : function() {			
				return $(this).form("validate");
			},
			success : function(result) {
				var results = eval('(' + result + ')');
				if (results.errres) {
					$.messager.alert("系统提示", results.errmsg);
					resetValue();
					$("#dlg").dialog("close");
					$("#dg").datagrid("reload");
				} else {
					$.messager.alert("系统提示", results.errmsg);
					return;
				}
			}
		});
	}
	
	function resetValue() {
		$("#securitynumber").val("");
		$("#securitypassword").val("");
		$("#username").val("");
	}

	function closeSecurityDialog() {
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
<body style="margin: 1px;">
	<table id="dg" title="证券管理" class="easyui-datagrid" fitColumns="true"
		pagination="true" rownumbers="true" url="${basePath}securitylist.do?username=${s_username }"
		fit="true" toolbar="#tb" remoteSort="false" multiSort="true">
		<thead>
			<tr>
				<th field="cb" checkbox="true" align="center"></th>
			<!-- 	<th field="id" width="50" align="center" sortable="true">编号</th> -->
				<th field="username" width="100" align="center" sortable="true">持有人</th>
				<th field="securitynumber" width="100" align="center" sortable="true">证券账号</th>
				<th field="securitypassword" width="100" align="center"  sortable="true">证券密码</th>
			</tr>
		</thead>
	</table>
	<div id="tb">
		<div>
			<a href="javascript:openSecurityAddDialog()" class="easyui-linkbutton"
				iconCls="icon-add" plain="true">添加</a> <a
				href="javascript:openSecurityModifyDialog()" class="easyui-linkbutton"
				iconCls="icon-edit" plain="true">修改</a> <a
				href="javascript:deleteSecurity()" class="easyui-linkbutton"
				iconCls="icon-remove" plain="true">删除</a>
		</div>
		<div style="float:right">
	<!-- 		&nbsp;持有人：&nbsp;<input type="text" id="s_username" size="12" onkeydown="if(event.keyCode==13) searchSecurity()" /> -->
			&nbsp;证券账号：&nbsp;<input type="text" id="s_securitynumber" size="12" onkeydown="if(event.keyCode==13) searchSecurity()" />
			<a href="javascript:searchSecurity()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a> 
			<a href="javascript:resetSearch()" class="easyui-linkbutton" iconCls="icon-reset" plain="true">清空</a>
		</div>
	</div>

	<div id="dlg" class="easyui-dialog" style="width: 730px; height: 250px; padding: 10px 20px" closed="true" buttons="#dlg-buttons">
		<form id="fm" method="post">
			<table cellspacing="8px">
				<tr>
					<td>持有人：</td>
					<td><input type="text" id="username" name="username"
						class="easyui-validatebox easyui-textbox" required="true" />&nbsp;<font
						color="red">*</font>
					</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td>证券账号：</td>
					<td><input type="text" id="securitynumber" name="securitynumber"
						class="easyui-validatebox easyui-textbox" required="true" />&nbsp;<font
						color="red">*</font></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>证券密码：</td>
					<td><input type="text" id="securitypassword" name="securitypassword"
						class="easyui-validatebox easyui-textbox" required="true" />&nbsp;<font
						color="red">*</font></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:saveSecurity()" class="easyui-linkbutton" iconCls="icon-ok">保存</a> 
		<a href="javascript:closeSecurityDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
</body>
</html>