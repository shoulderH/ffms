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

	function searchIncome() {
		var s_starttime = $("#s_starttime").datetimebox("getValue");
		var s_endtime = $("#s_endtime").datetimebox("getValue");
		if((s_starttime!="")&&(s_endtime!="")&&(s_starttime>s_endtime)){
			$.messager.alert("系统提示","起始时间不能大于截止时间！");
			return;
		}
		$("#dg").datagrid('load',{
			"incomer": $("#s_incomer").val(),
			"source" : $("#s_source").val(),
			"starttime":s_starttime,
			"endtime":s_endtime
		});
	}

	function resetSearch() {
		$("#s_incomer").val("");
		$("#s_source").val("");
		$("#s_starttime").datetimebox("setValue","");
		$("#s_endtime").datetimebox("setValue","");
	}
	
	function deleteIncome() {
		var selectedRows = $("#dg").datagrid('getSelections');
		if (selectedRows.length == 0) {
			$.messager.alert("系统提示", "请选择要删除的数据！");
			return;
		}
		var strIncomers = [];
		var strIncometimes=[];
		for (var i = 0; i < selectedRows.length; i++) {
			strIncomers.push(selectedRows[i].incomer);
			strIncometimes.push(selectedRows[i].incometime);
		}
		var incomers = strIncomers.join(",");
		var incometimes = strIncometimes.join(",");
		$.messager.confirm("系统提示", "您确认要删除这<font color=red>"
				+ selectedRows.length + "</font>条数据吗？", function(r) {
			if (r) {
				$.post("${basePath}/incomedelete.do", {
					incomers : incomers,incometimes:incometimes
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

	function openIncomeAddDialog() {
		$("#incomer").val("${s_username}");
		$("#source").val("");
 		$("#money").val("");
 		$("#incometime").datetimebox("setValue", "");
		$("#dlg").dialog("open").dialog("setTitle", "添加收入信息");
		url = "${basePath}incomesave.do?mark=1";
	}

	function openIncomeModifyDialog() {
		var selectedRows = $("#dg").datagrid('getSelections');
		document.getElementById("incometime").readOnly=true;
		if (selectedRows.length != 1) {
			$.messager.alert("系统提示", "请选择一条要编辑的数据！");
			return;
		}
		var row = selectedRows[0];
		$("#dlg").dialog("open").dialog("setTitle", "编辑收入信息");
		$('#fm').form('load', row);
		url = "${basePath}incomesave.do?mark=0";
	}

	function saveIncome() {
		$("#fm").form("submit",{
			url : url,
			onSubmit : function() { 
		/* 		if ($("#incomer").combobox("getValue") == "" || $("#incomer").combobox("getValue") == null) {
					$.messager.alert("系统提示", "请选择收入人！");
					return false;
				} */
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
		$("#incomer").val("");
		$("#source").val("");
		$("#money").val("");
		$("#incometime").datetimebox("setValue", "");
		
	}

	function closeIncomeDialog() {
		$("#dlg").dialog("close");
		resetValue();
	}
	function openIncomeFindDialog(){
		var selectedRows=$("#dg").datagrid('getSelections');
		if(selectedRows.length!=1){
			$.messager.alert("系统提示","请选择一条要查看的数据！");
			return;
		}
		var row=selectedRows[0];
		$("#finddlg").dialog("open").dialog("setTitle","查看收入信息");
		$("#fincomer").text(row.incomer);
		$("#fsource").text(row.source);
		$("#fmoney").text(row.money);
		$("#fincometime").text(row.incometime);
	}
	
	function closeFindDialog(){
		$('#finddlg').dialog('close');
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
	.spanwidth{
/* 	width:200px!important;
	height:20px;
	border:1px red solid; */
	}
</style>
</head>
<body style="margin: 1px;">
	<table id="dg" title="收入管理" class="easyui-datagrid" fitColumns="true"
		pagination="true" rownumbers="true" 
		url="${basePath}incomelist.do?manageid=${currentUser.manageid}&appellation=${currentUser.appellation}"
		fit="true" toolbar="#tb" remoteSort="false" multiSort="true">
		<thead>
			<tr>
				<th field="cb" checkbox="true" align="center"></th>
				<th field="incomer" width="100" align="center" sortable="true">收入人</th>
				<th field="source" width="100" align="center" sortable="true">收入来源</th>
				<th field="money" width="100" align="center" sortable="true">金额</th>
				<th field="incometime" width="100" align="center" sortable="true">收入时间</th>
			</tr>
		</thead>
	</table>
	<div id="tb">
		<div>
			<a href="javascript:openIncomeAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a> 
			<a href="javascript:openIncomeModifyDialog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a> 
			<a href="javascript:deleteIncome()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
			<a href="javascript:openIncomeFindDialog()" class="easyui-linkbutton" iconCls="icon-lsdd" plain="true">查看详细</a>
		</div>
		
		<div>
			&nbsp;收入人：&nbsp;<input type="text" id="s_incomer" size="15" onkeydown="if(event.keyCode==13) searchIncome()" />
			&nbsp;收入来源：&nbsp;<input type="text" id="s_source" size="15" onkeydown="if(event.keyCode==13) searchIncome()" />
			&nbsp;收入起止时间：&nbsp;<input type="text" id="s_starttime" class="easyui-datetimebox" size="18" onkeydown="if(event.keyCode==13) searchIncome()"/>
			<span style="font-weight:bold;">&sim;</span>&nbsp;<input type="text" id="s_endtime" class="easyui-datetimebox" size="18" onkeydown="if(event.keyCode==13) searchIncome()"/>
			<span class="spanwidth"></span>
			<a href="javascript:searchIncome()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a> 
			<a href="javascript:resetSearch()" class="easyui-linkbutton" iconCls="icon-reset" plain="true">清空</a>
		</div>
	</div>

	<div id="dlg" class="easyui-dialog" style="width: 670px; height: 300px; padding: 10px 20px" closed="true" buttons="#dlg-buttons">
		<form id="fm" method="post">
			<table cellspacing="8px">
				<tr>
					<td>收入人：</td>
					<td><input type="text" id="incomer" name="incomer"  readonly="readonly" class="easyui-validatebox easyui-textbox" required="true" />&nbsp;<font color="red">*</font></td>
					</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>收入来源：</td>
					<td><input type="text" id="source" name="source" class="easyui-validatebox easyui-textbox" required="true" />&nbsp;<font color="red">*</font></td>
				</tr>
				<tr>
					<td>金额：</td>
					<td><input type="text" id="money" name="money" class="easyui-validatebox easyui-numberbox" required="true" />&nbsp;<font color="red">*</font></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>收入时间</td>
					<td><input id="incometime" name="incometime"  class="easyui-datetimebox" required="true" style="width:140px">&nbsp;<font
						color="red">*</font></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:saveIncome()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeIncomeDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
	<div id="finddlg" class="easyui-dialog" style="width: 670px;height:300px;padding: 60px 20px" closed="true" buttons="#finddlg-buttons">
	 	<table cellspacing="8px" class="findtable" width="100%">
	 		<tr>
	 			<td>收入人：</td>
	 			<td><span id="fincomer"></span></td>
	 			<td>收入来源：</td>
	 			<td><span id="fsource"></span></td>
	 		</tr>
	 		<tr>
	 			<td>金额：</td>
	 			<td><span id="fmoney"></span></td>
	 			<td>收入时间：</td>
	 			<td><span id="fincometime"></span></td>
	 		</tr>
	 	</table>
	</div>
	<div id="finddlg-buttons">
		<a href="javascript:closeFindDialog()" class="easyui-linkbutton" iconCls="icon-ok">确定</a>
	</div>
</body>
</html>