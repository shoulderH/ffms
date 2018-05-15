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
<script type="text/javascript" src="${basePath}Highcharts-5.0.12/code/highcharts.js"></script>
<script type="text/javascript" src="${basePath}Highcharts-5.0.12/code/highcharts-3d.js"></script>
<script type="text/javascript" src="${basePath}Highcharts-5.0.12/code/modules/exporting.js"></script>
<script type="text/javascript" src="${basePath}Highcharts-5.0.12/code/highcharts-zh_CN.js"></script>
<script type="text/javascript" src="${basePath}Highcharts-5.0.12/code/themes/dark-unica.js"></script>
<script>
window.onload=function(){
	var s_user ='${c_username}';
	var s_starttime = $("#s_starttime").datetimebox("getValue");
	var s_endtime = $("#s_endtime").datetimebox("getValue");
	if((s_starttime!="")&&(s_endtime!="")&&(s_starttime>s_endtime)){
		$.messager.alert("系统提示","起始时间不能大于截止时间！");
		return;
	}
	$.post("${basePath}produceIncomeType.do", {incomer : s_user,starttime:s_starttime,endtime:s_endtime}, function(result) {
		$('#containerIncomePie').highcharts({
	        chart: {
	            type: 'pie',
	            options3d: {
	                enabled: true,
	                alpha: 45,
	                beta: 0
	            }
	        },
	        title: {
	            text: '(类型——金额)收入饼状图'
	        },
	        tooltip: {
	            pointFormat: '金额：<b>{point.y}元</b>'
	        },
	        plotOptions: {
	            pie: {
	                allowPointSelect: true,
	                cursor: 'pointer',
	                depth: 35,
	                dataLabels: {
	                    enabled: true,
	                    format: '{point.name}'
	                }
	            }
	        },
	        series: [result]
	    });
	}, "json");
	$.post("${basePath}producePayType.do", {payer : s_user,starttime:s_starttime,endtime:s_endtime}, function(result) {
		$('#containerPayPie').highcharts({
	        chart: {
	            type: 'pie',
	            options3d: {
	                enabled: true,
	                alpha: 45,
	                beta: 0
	            }
	        },
	        title: {
	            text: '(类型——金额)支出饼状图'
	        },
	        tooltip: {
	            pointFormat: '金额：<b>{point.y}元</b>'
	        },
	        plotOptions: {
	            pie: {
	                allowPointSelect: true,
	                cursor: 'pointer',
	                depth: 35,
	                dataLabels: {
	                    enabled: true,
	                    format: '{point.name}'
	                }
	            }
	        },
	        series: [result]
	    });
	}, "json");
};
	function searchLine(){
		var s_user = $("#s_user").val();
		var s_starttime = $("#s_starttime").datetimebox("getValue");
		var s_endtime = $("#s_endtime").datetimebox("getValue");
		if((s_starttime!="")&&(s_endtime!="")&&(s_starttime>s_endtime)){
			$.messager.alert("系统提示","起始时间不能大于截止时间！");
			return;
		}
		$.post("${basePath}produceIncomeType.do", {incomer : s_user,starttime:s_starttime,endtime:s_endtime}, function(result) {
			$('#containerIncomePie').highcharts({
		        chart: {
		            type: 'pie',
		            options3d: {
		                enabled: true,
		                alpha: 45,
		                beta: 0
		            }
		        },
		        title: {
		            text: '(类型——金额)收入饼状图'
		        },
		        tooltip: {
		            pointFormat: '金额：<b>{point.y}元</b>'
		        },
		        plotOptions: {
		            pie: {
		                allowPointSelect: true,
		                cursor: 'pointer',
		                depth: 35,
		                dataLabels: {
		                    enabled: true,
		                    format: '{point.name}'
		                }
		            }
		        },
		        series: [result]
		    });
		}, "json");
		$.post("${basePath}producePayType.do", {payer : s_user,starttime:s_starttime,endtime:s_endtime}, function(result) {
			$('#containerPayPie').highcharts({
		        chart: {
		            type: 'pie',
		            options3d: {
		                enabled: true,
		                alpha: 45,
		                beta: 0
		            }
		        },
		        title: {
		            text: '(类型——金额)支出饼状图'
		        },
		        tooltip: {
		            pointFormat: '金额：<b>{point.y}元</b>'
		        },
		        plotOptions: {
		            pie: {
		                allowPointSelect: true,
		                cursor: 'pointer',
		                depth: 35,
		                dataLabels: {
		                    enabled: true,
		                    format: '{point.name}'
		                }
		            }
		        },
		        series: [result]
		    });
		}, "json");
	}
	
	function resetSearch() {
		$("#s_user").val("");
		$("#s_starttime").datetimebox("setValue","");
		$("#s_endtime").datetimebox("setValue","");
	}
    
</script>
</head>
<body>
	<div style="padding:5px;">
		&nbsp;查询用户：&nbsp;<input type="text" id="s_user" size="15" onkeydown="if(event.keyCode==13) searchLine()" />
		&nbsp;收入或支出起止时间：&nbsp;<input type="text" id="s_starttime" class="easyui-datetimebox" size="18" onkeydown="if(event.keyCode==13) searchLine()"/>
		<span style="font-weight:bold;">&sim;</span>&nbsp;<input type="text" id="s_endtime" class="easyui-datetimebox" size="18" onkeydown="if(event.keyCode==13) searchLine()"/>
		<a href="javascript:searchLine()" class="easyui-linkbutton" iconCls="icon-search" plain="true">查询</a>
		<a href="javascript:resetSearch()" class="easyui-linkbutton" iconCls="icon-reset" plain="true">清空</a>
	</div>
	<div class="easyui-tabs" style="min-width:400px;min-height:400px">
		<div title="(类型——金额)收入饼状图" style="padding:10px">
			<div id="containerIncomePie" style="width:100%;min-width:400px;min-height:400px"></div>
		</div>
    	<div title="(类型——金额)支出饼状图" style="padding:10px">
        	<div id="containerPayPie" style="width:100%;min-width:400px;min-height:400px"></div>
        </div>
    </div>
</body>
</html>
