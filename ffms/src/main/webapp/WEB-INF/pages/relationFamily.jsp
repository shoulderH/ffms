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
<link rel="stylesheet" type="text/css" href="${basePath}topo/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="${basePath}topo/css/topology.css">
<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.min.js"></script>
<script type="text/javascript" src="${basePath}topo/jquery.min.js"></script>
<script type="text/javascript" src="${basePath}topo/js/jtopo-min-new.js"></script>
<script type="text/javascript" src="${basePath}topo/js/jtopo-0.4.8-min.js"></script>
<script type="text/javascript" src="http://www.jtopo.com/demo/js/toolbar.js"></script>
<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${basePath}jquery-easyui-1.3.3/jquery.cookie.js"></script>
<script type="text/javascript">
    var ctx = '<%=path%>';
</script>
<script type="text/javascript">
window.onload=function(){
	var canvas = document.getElementById('canvas'); 
	 var stage = new JTopo.Stage(canvas); // 创建一个舞台对象
     var scene = new JTopo.Scene(stage); // 创建一个场景对象
     
     var node = new JTopo.Node("Hello");    // 创建一个节点
     node.setLocation(300,200);    // 设置节点坐标                  
     node.setImage('${basePath}resource/images/people.png'); // 设置图片
     scene.add(node);
};
function changeRelation(){
	
}
</script>
<style type="text/css">
.relation_content{
	width:100%;
	height:450px;
	border:1px red solid;
	margin-top:10px;
}
</style>
  </head>
  
  <body>
    <div>
    	<div class="relation_head">
    		<label>管理员：</label>
    		<select class="easyui-combobox" id="username" name="username" editable="false" style="width: 175px;" onchange="changeRelation()">
							<c:forEach items="${manageLists }" var="managelist">
								<option value="${managelist.username }">${managelist.username }</option>
							</c:forEach>
					</select>
    	</div>
    	<div class="relation_content">
    		<canvas id="canvas" style="width:100%;height:100%"></canvas>
    	</div>
    </div>
   
  </body>
</html>
