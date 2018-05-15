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
	var s_payer = '${c_username}';
	var s_starttime = $("#s_starttime").datetimebox("getValue");
	var s_endtime = $("#s_endtime").datetimebox("getValue");
	$.post("${basePath}producePayTime.do", 
			{payer:s_payer,starttime:s_starttime,endtime:s_endtime}, 
			function(result) {
		$('#containerLine').highcharts({
	        chart: {
	            type: 'spline'
	        },
	        colors: ['#FF33CC','#04BE02','#EF4F4F','#FF6600','#18B4ED'],
			title: {
	        	style:{
	            	fontFamily:'宋体',
	            },
	            text: '(时间——金额)支出曲线图', //设置一级标题 
	            x: -20 //center 
	        }, 
	        subtitle: { 
	            text: '', //设置二级标题 
	            x: -20 
	        },
	        credits:{enabled: false},
	        xAxis: {
	        	type:'category',
	        	title: {
					style:{
	            		fontFamily:'宋体',
	            	}, 
	                text: '时间' //设置X轴的标题 
	            },
	            gridLineColor:'#00B2EE',
				gridLineWidth:'1',
		        showFirstLabel:true,
	            showLastLable:true
	        },
	        yAxis: {
	            title: {
	                style:{
	                	fontFamily:'宋体',
	                }, 
	                text: '金额' //设置y轴的标题 
	            }, 
	            labels : {  
	            	formatter : function() {//设置纵坐标值的样式  
	                   return this.value + '元';
	                }
	            },
	            gridLineColor:'#00B2EE',
				gridLineWidth:'1',
	            plotLines: [{
	                value: 0,
	                width: 1,
	                color: '#808080'
	            }],
				min:0
	        },
	        tooltip: {
	            formatter: function() {
                    return '<b>'+ this.series.name + '</b><br/>金额：' + this.point.y + '元';
                },
	        },
	        legend: {
	        	layout: 'vertical',
	            align: 'right',
	            verticalAlign: 'middle',
	            x: 0, 
	            y: 0, 
	            borderWidth: 0,
	            style: {
                    textTransform: 'lowercase'
                }
	        },
	        exporting: {
	            enabled: true,
	        },
	        plotOptions: {
	            spline: {
	                dataLabels: {
	                    enabled: true //显示每条曲线每个节点的数据项的值 
	                }, 
	                enableMouseTracking: true,
	                marker:{
	                	enable:true,
	                }
	            },
		        area: {
                    fillColor: {
                        linearGradient: {
                            x1: 0,
                            y1: 0,
                            x2: 0,
                            y2: 1
                        },
                        stops: [
                            [0, Highcharts.getOptions().colors[0]],
                            [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                        ]
                    },
                    marker: {
                        radius: 2
                    },
                    lineWidth: 1,
                    states: {
                        hover: {
                            lineWidth: 1
                        }
                    },
                    threshold: null
                }
	        },
	        series: result
	    });
		var chart = new Highcharts.Chart({
	        chart: {
	            renderTo: 'containerColumn',
	            type: 'column',
	            options3d: {
	                enabled: true,
	                alpha: 15,
	                beta: 15,
	                depth: 50,
	                viewDistance: 25
	            }
	        },
	        title: {
	            text: '(时间——金额)支出柱状图'
	        },
	        plotOptions: {
	            column: {
	                depth: 25,
	                dataLabels: {
	                    enabled: true //显示每条曲线每个节点的数据项的值 
	                }
	            }
	        },
	        tooltip: {
	            pointFormat: '<b>{series.name}</b><br/>金额：<b>{point.y}元</b>'
	        },
	        xAxis: {
	        	type:'category',
	        	title: {
					style:{
	            		fontFamily:'宋体',
	            	}, 
	                text: '时间' //设置X轴的标题 
	            }
	        },
	        yAxis: {
	            title: {
	                style:{
	                	fontFamily:'宋体',
	                }, 
	                text: '金额' //设置y轴的标题 
	            },
	        },
	        series: result
	    });
		$('#sliders input').on('input change', function () {
	        chart.options.chart.options3d[this.id] = this.value;
	        $('#alpha-value').html(chart.options.chart.options3d.alpha);
		    $('#beta-value').html(chart.options.chart.options3d.beta);
		    $('#depth-value').html(chart.options.chart.options3d.depth);
	        chart.redraw(false);
	    });
		$('#alpha-value').html(chart.options.chart.options3d.alpha);
	    $('#beta-value').html(chart.options.chart.options3d.beta);
	    $('#depth-value').html(chart.options.chart.options3d.depth);
	    
	    for(var i=0;i<result.length;i++){
	    	$("#containerPie").append('<div id="containerPie'+i+'" style="min-width:400px;min-height:400px"></div>');
	    	$("#containerPie"+i).highcharts({
		        chart: {
		            type: 'pie',
		            options3d: {
		                enabled: true,
		                alpha: 45,
		                beta: 0
		            }
		        },
		        title: {
		            text: result[i].name+'：(时间——金额)支出饼状图'
		        },
		        tooltip: {
		            pointFormat: '<b>{series.name}</b><br/>金额：<b>{point.y}元</b>'
		        },
		        plotOptions: {
		            pie: {
		                allowPointSelect: true,
		                cursor: 'pointer',
		                depth: 35,
		                dataLabels: {
		                    enabled: true,
		                    format: '{point.name}'
		                },
		                showInLegend: true
		            }
		        },
		        series: [result[i]]
		    });
	    }
	}, "json");
};
	function searchLine(){
		var s_payer = $("#s_payer").val();
		var s_starttime = $("#s_starttime").datetimebox("getValue");
		var s_endtime = $("#s_endtime").datetimebox("getValue");
		if((s_starttime!="")&&(s_endtime!="")&&(s_starttime>s_endtime)){
			$.messager.alert("系统提示","起始时间不能大于截止时间！");
			return;
		}
		$.post("${basePath}producePayTime.do", 
				{payer:s_payer,starttime:s_starttime,endtime:s_endtime}, 
				function(result) {
			$('#containerLine').highcharts({
		        chart: {
		            type: 'spline'
		        },
		        colors: ['#FF33CC','#04BE02','#EF4F4F','#FF6600','#18B4ED'],
				title: {
		        	style:{
		            	fontFamily:'宋体',
		            },
		            text: '(时间——金额)支出曲线图', //设置一级标题 
		            x: -20 //center 
		        }, 
		        subtitle: { 
		            text: '', //设置二级标题 
		            x: -20 
		        },
		        credits:{enabled: false},
		        xAxis: {
		        	type:'category',
		        	title: {
						style:{
		            		fontFamily:'宋体',
		            	}, 
		                text: '时间' //设置X轴的标题 
		            },
		            gridLineColor:'#00B2EE',
					gridLineWidth:'1',
			        showFirstLabel:true,
		            showLastLable:true
		        },
		        yAxis: {
		            title: {
		                style:{
		                	fontFamily:'宋体',
		                }, 
		                text: '金额' //设置y轴的标题 
		            }, 
		            labels : {  
		            	formatter : function() {//设置纵坐标值的样式  
		                   return this.value + '元';
		                }
		            },
		            gridLineColor:'#00B2EE',
					gridLineWidth:'1',
		            plotLines: [{
		                value: 0,
		                width: 1,
		                color: '#808080'
		            }],
					min:0
		        },
		        tooltip: {
		            formatter: function() {
	                    return '<b>'+ this.series.name + '</b><br/>金额：' + this.point.y + '元';
	                },
		        },
		        legend: {
		        	layout: 'vertical',
		            align: 'right',
		            verticalAlign: 'middle',
		            x: 0, 
		            y: 0, 
		            borderWidth: 0,
		            style: {
	                    textTransform: 'lowercase'
	                }
		        },
		        exporting: {
		            enabled: true,
		        },
		        plotOptions: {
		            spline: {
		                dataLabels: {
		                    enabled: true //显示每条曲线每个节点的数据项的值 
		                }, 
		                enableMouseTracking: true,
		                marker:{
		                	enable:true,
		                }
		            },
			        area: {
	                    fillColor: {
	                        linearGradient: {
	                            x1: 0,
	                            y1: 0,
	                            x2: 0,
	                            y2: 1
	                        },
	                        stops: [
	                            [0, Highcharts.getOptions().colors[0]],
	                            [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
	                        ]
	                    },
	                    marker: {
	                        radius: 2
	                    },
	                    lineWidth: 1,
	                    states: {
	                        hover: {
	                            lineWidth: 1
	                        }
	                    },
	                    threshold: null
	                }
		        },
		        series: result
		    });
			var chart = new Highcharts.Chart({
		        chart: {
		            renderTo: 'containerColumn',
		            type: 'column',
		            options3d: {
		                enabled: true,
		                alpha: 15,
		                beta: 15,
		                depth: 50,
		                viewDistance: 25
		            }
		        },
		        title: {
		            text: '(时间——金额)支出柱状图'
		        },
		        plotOptions: {
		            column: {
		                depth: 25,
		                dataLabels: {
		                    enabled: true //显示每条曲线每个节点的数据项的值 
		                }
		            }
		        },
		        tooltip: {
		            pointFormat: '<b>{series.name}</b><br/>金额：<b>{point.y}元</b>'
		        },
		        xAxis: {
		        	type:'category',
		        	title: {
						style:{
		            		fontFamily:'宋体',
		            	}, 
		                text: '时间' //设置X轴的标题 
		            }
		        },
		        yAxis: {
		            title: {
		                style:{
		                	fontFamily:'宋体',
		                }, 
		                text: '金额' //设置y轴的标题 
		            },
		        },
		        series: result
		    });
			$('#sliders input').on('input change', function () {
		        chart.options.chart.options3d[this.id] = this.value;
		        $('#alpha-value').html(chart.options.chart.options3d.alpha);
			    $('#beta-value').html(chart.options.chart.options3d.beta);
			    $('#depth-value').html(chart.options.chart.options3d.depth);
		        chart.redraw(false);
		    });
			$('#alpha-value').html(chart.options.chart.options3d.alpha);
		    $('#beta-value').html(chart.options.chart.options3d.beta);
		    $('#depth-value').html(chart.options.chart.options3d.depth);
		    
		    for(var i=0;i<result.length;i++){
		    	$("#containerPie").append('<div id="containerPie'+i+'" style="min-width:400px;min-height:400px"></div>');
		    	$("#containerPie"+i).highcharts({
			        chart: {
			            type: 'pie',
			            options3d: {
			                enabled: true,
			                alpha: 45,
			                beta: 0
			            }
			        },
			        title: {
			            text: result[i].name+'：(时间——金额)支出饼状图'
			        },
			        tooltip: {
			            pointFormat: '<b>{series.name}</b><br/>金额：<b>{point.y}元</b>'
			        },
			        plotOptions: {
			            pie: {
			                allowPointSelect: true,
			                cursor: 'pointer',
			                depth: 35,
			                dataLabels: {
			                    enabled: true,
			                    format: '{point.name}'
			                },
			                showInLegend: true
			            }
			        },
			        series: [result[i]]
			    });
		    }
		}, "json");
	}
	
	function resetSearch() {
		$("#s_payer").val("");
		$("#s_starttime").datetimebox("setValue","");
		$("#s_endtime").datetimebox("setValue","");
	}
</script>
</head>
<body>
	<div style="padding:5px;">
		<c:if test="${currentUser.appellation=='管理员' }">
		&nbsp;支出用户：&nbsp;<input type="text" id="s_payer" size="15" onkeydown="if(event.keyCode==13) searchLine()" />
		</c:if>
		
		&nbsp;支出起止时间：&nbsp;<input type="text" id="s_starttime" class="easyui-datetimebox" size="18" onkeydown="if(event.keyCode==13) searchLine()"/>
		<span style="font-weight:bold;">&sim;</span>&nbsp;<input type="text" id="s_endtime" class="easyui-datetimebox" size="18" onkeydown="if(event.keyCode==13) searchLine()"/>
		<a href="javascript:searchLine()" class="easyui-linkbutton" iconCls="icon-search" plain="true">查询</a> 
		<a href="javascript:resetSearch()" class="easyui-linkbutton" iconCls="icon-reset" plain="true">清空</a>
	</div>
	<div class="easyui-tabs" style="min-width:400px;min-height:400px">
        <div title="折线图" style="padding:10px">
            <div id="containerLine" style="min-width:400px;min-height:400px"></div>
        </div>
        <div title="柱状图" style="padding:10px">
            <div id="containerColumn" style="min-width:400px;min-height:400px"></div>
            <div id="sliders">
			    <table>
			        <tr>
			            <td>α 角（内旋转角）</td>
			            <td><input id="alpha" type="range" min="0" max="45" value="15"/> <span id="alpha-value" class="value"></span></td>
			        </tr>
			        <tr>
			            <td>β 角（外旋转角）</td>
			            <td><input id="beta" type="range" min="-45" max="45" value="15"/> <span id="beta-value" class="value"></span></td>
			        </tr>
			        <tr>
			            <td>深度</td>
			            <td><input id="depth" type="range" min="20" max="100" value="50"/> <span id="depth-value" class="value"></span></td>
			        </tr>
			    </table>
			</div>
        </div>
         <div title="饼状图" style="padding:10px" id="containerPie"></div> 
    </div>
</body>
</html>
