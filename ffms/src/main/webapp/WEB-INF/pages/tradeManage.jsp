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
<script type="text/javascript">
	var url;
	function searchTrade() {
		var s_starttime = $("#s_starttime").datetimebox("getValue");
		var s_endtime = $("#s_endtime").datetimebox("getValue");
		if((s_starttime!="")&&(s_endtime!="")&&(s_starttime>s_endtime)){
			$.messager.alert("系统提示","起始时间不能大于截止时间！");
			return;
		}
		$("#dg").datagrid('load',{
			"securitynumber": $("#s_securitynumber").val(),
			"source" : $("#s_source").val(),
			"starttime":s_starttime,
			"endtime":s_endtime
		});
	}

	function resetSearch() {
		$("#s_securitynumber").val("");
		$("#s_source").val("");
		$("#s_starttime").datetimebox("setValue","");
		$("#s_endtime").datetimebox("setValue","");
		
	}
	
	function deleteTrade() {
		var selectedRows = $("#dg").datagrid('getSelections');
		if (selectedRows.length == 0) {
			$.messager.alert("系统提示", "请选择要删除的数据！");
			return;
		}
		var strIds = [];
		for (var i = 0; i < selectedRows.length; i++) {
			strIds.push(selectedRows[i].tradeid);
		}
		var tradeids = strIds.join(",");
		$.messager.confirm("系统提示", "您确认要删除这<font color=red>"
				+ selectedRows.length + "</font>条数据吗？", function(r) {
			if (r) {
				$.post("${basePath}/tradedelete.do", {
					tradeids : tradeids
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
	function openTradeAddDialog() {
		document.getElementById("securitynumber").readOnly=false;
		$("#dlg").dialog("open").dialog("setTitle", "添加流水账信息");
		alert("前台输出："+$("#securitynumber").val());
		url = "${basePath}tradesave.do?s_username=${s_username}&s_securitynumber="+$("#securitynumber").val();
	}

	function openTradeModifyDialog() {
		var selectedRows = $("#dg").datagrid('getSelections');
		if (selectedRows.length != 1) {
			$.messager.alert("系统提示", "请选择一条要编辑的数据！");
			return;
		}
		var row = selectedRows[0];
		$("#dlg").dialog("open").dialog("setTitle", "编辑流水账信息");
		$('#fm').form('load', row);
		url = "${basePath}tradeupdate.do?id="+row.tradeid;
	}

	function saveTrade() {
		$("#fm").form("submit",{
			url : url,
			onSubmit : function() { 
				if ($("#source").combobox("getValue") == "" || $("#source").combobox("getValue") == null) {
					$.messager.alert("系统提示", "请选择交易类型！");
					return false;
				}
				return $(this).form("validate");
			},
			success : function(result) {
				var results = eval('(' + result + ')');
				if (results.errres) {
					$.messager.alert("系统提示", results.errmsg);
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
		$("#tradeid").combobox("setValue", "");
		$("#securitynumber").combobox("setValue", "");
		$("#source").combobox("setValue", "");
		$("#price").numberbox("setValue", "");
		$("#number").numberbox("setValue", "");
		$("#money").val("");
		$("#tradetime").datetimebox("setValue", "");
	}

	function closeTradeDialog() {
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
	<table id="dg" title="流水账管理" class="easyui-datagrid" fitColumns="true"
		pagination="true" rownumbers="true" url="${basePath}tradelist.do?name=${s_username}"
		fit="true" toolbar="#tb" remoteSort="false" multiSort="true">
		<thead>
			<tr>
		    <input  field="tradeid" type="text"  style="display:none">  
				<th field="cb" checkbox="true" align="center"></th>
			<!-- 	 <th field="tradeid" width="100" align="center" sortable="true">流水号</th> -->
			    <th field="securitynumber" width="100" align="center" sortable="true">证券号</th>
				<th field="price" width="100" align="center" sortable="true">单价</th>
				<th field="number" width="100" align="center" sortable="true">数量</th>
				<th field="money" width="100" align="center" sortable="true">金额</th>
				<th field="source" width="100" align="center" sortable="true">交易类型</th>
				<th field="tradetime" width="100" align="center" sortable="true">交易时间</th>
			</tr>
		</thead>
	</table>
	<div id="tb">
		<div>
			<a href="javascript:openTradeAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a> 
			<a href="javascript:openTradeModifyDialog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a> 
			<a href="javascript:deleteTrade()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
		</div>
	  <div>
	 		 &nbsp;证券号：&nbsp;<input type="text" id="s_securitynumber" size="18" onkeydown="if(event.keyCode==13) searchTrade()"/>
			&nbsp;交易类型：&nbsp;<select class="easyui-combobox" id="s_source" editable="false" style="width: 100px;">
				<option value="">请选择...</option>
					<option value="买入">买入</option>
					<option value="卖出">卖出</option>
			</select>&nbsp;
			&nbsp;交易起止时间：&nbsp;<input type="text" id="s_starttime" class="easyui-datetimebox" size="18" onkeydown="if(event.keyCode==13) searchTrade()"/>
			<span style="font-weight:bold;">&sim;</span>&nbsp;<input type="text" id="s_endtime" class="easyui-datetimebox" size="18" onkeydown="if(event.keyCode==13) searchTrade()"/>
			<a href="javascript:searchTrade()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a> 
			<a href="javascript:resetSearch()" class="easyui-linkbutton" iconCls="icon-reset" plain="true">清空</a>
		</div>
	</div>
	<div id="dlg" class="easyui-dialog" style="width: 670px; height: 300px; padding: 10px 20px" closed="true" buttons="#dlg-buttons">
		<form id="fm" method="post">
			<table cellspacing="8px">
				<tr>
					<td>证券号：</td>
					<td><input type="text" id="securitynumber" name="securitynumber" readonly="readonly" class="easyui-validatebox easyui-textbox" required="true" />&nbsp;<font color="red">*</font></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>交易类型：</td>
					<td><select class="easyui-combobox" id="source" name="source" editable="false" style="width: 175px;">
							<option value="">请选择...</option>
					            <option value="买入">买入</option>
					            <option value="卖出">卖出</option>
					</select>&nbsp;<font color="red">*</font></td>
				</tr>
				<tr>
					<td>单价：</td>
					<td><input type="text" id="price" name="price" class="easyui-validatebox easyui-numberbox" required="true" />&nbsp;<font color="red">*</font></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>数量：</td>
					<td><input type="text" id="number" name="number" class="easyui-validatebox easyui-numberbox" required="true" />&nbsp;<font color="red">*</font></td>
				</tr>
				<tr>
					<td>金额</td>
					<td><input type="text" id="money" name="money" class="easyui-validatebox easyui-numberbox" required="true" />&nbsp;<font color="red">*</font></td></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>交易时间</td>
					<td><input id="tradetime" name="tradetime" class="easyui-datetimebox" required="true" style="width:140px">&nbsp;<font
						color="red">*</font></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:saveTrade()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeTradeDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
</body>
</html>