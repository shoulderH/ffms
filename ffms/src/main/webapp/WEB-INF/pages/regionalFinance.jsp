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
<script type="text/javascript" src="${basePath}resource/js/echarts.min.js"></script>
<script type="text/javascript" src="${basePath}resource/js/echarts-gl.min.js"></script>
<script type="text/javascript" src="${basePath}resource/js/ecStat.min.js"></script>
<script type="text/javascript" src="${basePath}resource/js/bmap.min.js"></script>
<script type="text/javascript" src="${basePath}resource/js/simplex.js"></script>
<script type="text/javascript" src="${basePath}resource/js/china.js"></script>

  </head>
  
   <body style="height:500px;margin: 0">
   <div id="container" style="height: 100%"></div>


<script type="text/javascript">
var dom = document.getElementById("container");
var myChart = echarts.init(dom);
$(function() {
	getFinance();
});
function getFinance(){
	myChart.setOption({
	    title: {
	        text: '地域财政状况',
	        left: 'center'
	    },
	    tooltip: {
	        trigger: 'item'
	    },
	    legend: {
	        orient: 'vertical',
	        left: 'left',
	        data:['收入','支出']
	    },
	    visualMap: {
	        min: -300000,
	        max: 200000,
	        left: 'left',
	        top: 'bottom',
	        text: ['高','低'],           // 文本，默认为数值文本
	        calculable: true
	    },
	    toolbox: {
	        show: true,
	        orient: 'vertical',
	        left: 'right',
	        top: 'center',
	        feature: {
	            dataView: {readOnly: false},
	            restore: {},
	            saveAsImage: {}
	        }
	    },
	    series: [
	        {
	            name: '收入',
	            type: 'map',
	            mapType: 'china',
	            roam: false,
	            label: {
	                normal: {
	                    show: true
	                },
	                emphasis: {
	                    show: true
	                }
	            },
	            data:[]
	        },
	        {
	            name: '支出',
	            type: 'map',
	            mapType: 'china',
	            label: {
	                normal: {
	                    show: true
	                },
	                emphasis: {
	                    show: true
	                }
	            },
	            data:[]
	        }
	    ] 
	});
	getData();
}
function getData(){
/*	var names = [];    //类别数组（实际用来盛放X轴坐标值）
	var nums1 = [];    //销量数组（实际用来盛放Y坐标值）
	var nums2 = [];*/
var datas1 = [];
var datas2 = [];
	$.ajax({
	    type: 'get',
	    url: '${basePath}getFinanceData.do',//请求数据的地址
	    dataType: "json",        //返回数据形式为json
	    success: function (result) {
	        //请求成功时执行该函数内容，result即为服务器返回的json对象
	        $.each(result, function (index, item) {
	           // names.push(item.c_anystring);    //省份                  
	         //  nums1.push(item.c_incomemoney);    //收入
	          //  nums2.push(item.c_paymoney);
	         datas1.push({
	        	 name : item.c_anystring,
	        	 value : item.c_incomemoney 
	         });
	         datas2.push({
	        	 name : item.c_anystring,
	        	 value : item.c_paymoney
	         });
	        });


	        myChart.setOption({        //加载数据图表
	            series: [{
	                data: datas1
	            },{
	            	data: datas2
	            }]
	        });
	    },
	    error: function (errorMsg) {
	        //请求失败时执行该函数
	        alert("图表请求数据失败!");
	    }
	});
}
</script>
  </body>
</html>
