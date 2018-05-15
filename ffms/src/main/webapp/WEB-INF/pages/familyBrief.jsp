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
  </head>
  
  <body>
   <table id="dg" title="家庭简况" class="easyui-datagrid" fitColumns="true"
		pagination="true" rownumbers="true" 
		url="${basePath}brieflist.do?manageid=${currentUser.manageid}"
		fit="true" toolbar="#tb" remoteSort="false" multiSort="true">
		<thead>
			<tr>
				<th field="cb" checkbox="true" align="center"></th>
				<th field="c_anystring" width="100" align="center" sortable="true">称谓</th>
				<th field="c_incomemoney" width="100" align="center" sortable="true">收入</th>
				<th field="c_paymoney" width="100" align="center" sortable="true">支出</th>
				<th field="c_totalmoney" width="100" align="center" sortable="true">金额</th>
			</tr>
		</thead>
	</table>
  </body>
</html>
