//获取当前日期时间
function getCurrentDateTime(){
	 var date=new Date();
	 var year=date.getFullYear();
	 var month=date.getMonth()+1;
	 var day=date.getDate();
	 var hours=date.getHours();
	 var minutes=date.getMinutes();
	 var seconds=date.getSeconds();
	 return year+"-"+formatZero(month)+"-"+formatZero(day)+" "+formatZero(hours)+":"+formatZero(minutes)+":"+formatZero(seconds);
 }

//获取当前日期
function getCurrentDate(){
	 var date=new Date();
	 var year=date.getFullYear();
	 var month=date.getMonth()+1;
	 var day=date.getDate();
	 return year+"-"+formatZero(month)+"-"+formatZero(day);
}


 function formatZero(n){
	 if(n>=0&&n<=9){
		 return "0"+n;
	 }else{
		 return n;
	 }
 }
 /*
  * 获取指定树，指定选中节点下的所有子节点
  * 下面是具体的使用方法
  *    var childrenArray = new Array();
       var selNode=$('#tree').tree('getSelected');
       childrenArray=getChildNodeList($('#tree'),$('#tree').tree('getChildren',selNode.target));
  * 
  * */
 function getEasyUiTreeChildNodeList(tree, nodes) {  
      var childNodeList = [];  
      if (nodes && nodes.length>0) {             
          var node = null;  
          for (var i=0; i<nodes.length; i++) {  
              node = nodes[i];  
              childNodeList.push(node); 
               if (tree.tree('isLeaf',node.target)==false) { 	 	                 
                  var children = tree.tree("getChildren",node.target);  
                  childNodeList = childNodeList.concat(getEasyUiTreeChildNodeList(tree, children));  
              }  
          }  
      }  
      return childNodeList;  
  }