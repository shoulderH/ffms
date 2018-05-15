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
<script type="text/javascript" src="${basePath}resource/js/echarts_v3.js"></script>
<style type="text/css">
#containerLine{
background-color:#2F2F30 !important;
}
</style>
<script type="text/javascript">
var lineChart;
$(function() {
	getAnalysisLine();
});
function getAnalysisLine(){
	lineChart = echarts.init(document.getElementById('containerLine'));
	lineChart.setOption({
		title : {
			text : ''
		},
	/* 	grid : {
			left : '50px',
			right : '10px',
			top : '50px',
		}, */
		tooltip : {},
		legend : { // 设置图标的样式
			textStyle : {
				color : '#FFF',
				fontSize : '16',
			},
		/* 	right : '20px', // 图标离右边的距离 */
			data : [ '家庭平均', '标准值' ],
		},
		xAxis : {
			axisLine : {
				lineStyle : {
					type : 'solid',
					color : '#3579CC',// 左边线的颜色
					width : '2'// 坐标线的宽度
				}
			},
			axisLabel : {
				// interval:0,

				textStyle : {
					color : '#FFFFFF',// 坐标值得具体的颜色
					fontSize : '16',

				}
			},
			axisTick : { // 去掉刻度线
				show : false
			},
			data : []
		},
		yAxis : [ {
			min : -400, // 设置y轴的最小值
			max : 2000, // 设置y轴的最大值
			// splitNumber : 2, //设置Y轴的间隔，间隔几个显示
			interval : 200, // 设置间隔
			type : 'value',
			axisLine : {
				lineStyle : {
					type : 'solid',
					color : '#3579CC',
					width : '2'

				}
			},

			axisLabel : {
				formatter : function(value) { // 在y轴刻度值上加上单位
					// Function formatter
					return value + '元';
				},
				textStyle : {
					color : '#00a2e2',
					fontSize : '16',
				}
			},
			axisTick : {
				length : 8
			// 刻度线的长度，默认为5
			},
			splitLine : {
				show : false
			},// 去除网格线
			 splitArea : {show : true},//保留网格区域
			name : ''

		} ],
		series : [ {
			// 折线一
			name : '家庭平均',
			type : 'line',
			symbolSize : 8, // 转折点的大小
			itemStyle : { // 转折点样式设置
				normal : {
					color : '#EC82B1', // 转折点的颜色
					label : {
						show : false, // 设置转折点上的文字，是否显示
					/*
					 * position: 'top', textStyle: { color: '#FFFFFF' }
					 */
					}
				}
			},
			lineStyle : { // 更改线条的样式
				normal : {
					color : '#EC82B1',
					label : {
						show : true,
						position : 'top',
						textStyle : {
							color : '#FFFFFF'
						}
					}
				}
			},
			data : []
		}, {
			// 折线二
			name : '标准值',
			type : 'line',
			symbolSize : 8, // 转折点的大小
			itemStyle : { // 转折点样式设置
				normal : {
					color : '#03B9F5', // 转折点的颜色
					label : {
						show : false, // 设置转折点上的文字，是否显示
					/*
					 * position: 'top', textStyle: { color: '#FFFFFF' }
					 */
					}
				}
			},
			lineStyle : { // 更改线条的样式
				normal : {
					color : '#03B9F5',
					label : {
						show : true,
						position : 'top',
						textStyle : {
							color : '#FFFFFF'
						}
					}
				}
			},
			data : []
		} ]
	});
	ajaxAnalysisLine();
}
function ajaxAnalysisLine(){
	var names = []; // （实际用来盛放X轴坐标值）
	var nums = []; // （实际用来盛放Y坐标值）
	var nums2 = [];
	$.ajax({

		type : 'post',
		url : "${basePath}getAnalysisData.do?manageid=${currentUser.manageid}",// 请求数据的地址
		dataType : "json", // 返回数据形式为json
		success : function(result) {
			// 请求成功时执行该函数内容，result即为服务器返回的json对象
			$.each(result, function(index, item) {
				names.push(item.linetime);
				nums.push(item.personmoney);
				nums2.push(item.avgmoney);
			});
			lineChart.setOption({ // 加载数据图表
				xAxis : {
					data : names
				},
				series : [ {
					name : '家庭平均', // 显示在上部的标题
					data : nums
				}, {
					name : '标准值', // 显示在上部的标题
					data : nums2
				} ]
			});
		},
		error : function(errorMsg) {
			// 请求失败时执行该函数
			alert("图表请求数据失败!");
		}

	});
}
</script>
</head>
  
  <body>
    <div class="easyui-tabs" style="min-width:400px;min-height:400px">
        <div title="折线图" style="padding:10px">
            <div id="containerLine" style="min-width:400px;min-height:400px"></div>
        </div>
    </div>
  </body>
</html>
