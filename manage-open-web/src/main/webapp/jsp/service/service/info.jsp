<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="/tags/loushang-web" prefix="l"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>服务详情</title>
    
    <!-- 需要引用的CSS -->
	<link rel="shortcut icon" href="<%=request.getContextPath()%>/jsp/public/images/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="<l:asset path='css/bootstrap.css'/>" />
	<link rel="stylesheet" type="text/css" href="<l:asset path='css/font-awesome.css'/>" />
	<link rel="stylesheet" type="text/css" href="<l:asset path='css/ui.css'/>" />
	<link rel="stylesheet" type="text/css" href="<l:asset path='css/form.css'/>" />
       <link rel="stylesheet" type="text/css" href="<l:asset path='css/datatables.css'/>"/>
       <link rel="stylesheet" type="text/css" href="<l:asset path='css/ztree.css'/>" />
       <link rel="stylesheet" type="text/css" href="<l:asset path='data/datadev.css'/>" />
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="<l:asset path='html5shiv.js'/>"></script>
      <script src="<l:asset path='respond.js'/>"></script>
    <![endif]-->
    <script type="text/javascript" src="<l:asset path='jquery.js'/>" ></script>
    <script type="text/javascript" src="<l:asset path='bootstrap.js'/>" ></script>
	<script type="text/javascript" src="<l:asset path='form.js'/>" ></script>
	<script type="text/javascript" src="<l:asset path='arttemplate.js'/>" ></script>	
	<script type="text/javascript" src="<l:asset path='datatables.js'/>"></script>
    <script type="text/javascript" src="<l:asset path='loushang-framework.js'/>"></script>
    <script type="text/javascript" src="<l:asset path='ui.js'/>"></script>
    <script type="text/javascript" src="<l:asset path='ztree.js'/>"></script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据详情</title>
</head>
<body>
	<div class="container" style="width: 98%; padding-top:10px;">
	  <div class="row">  
		 <img style="float: left; margin: 0px 10px 10px 0px;" src="<%=request.getContextPath() %>/skins/skin/data/datalist/img/default-64.png"/>
		 <div class="title-text">
		 	 <div style="font-size: 20px;">${serviceInfo.name }</div>
		 	 <div>发布时间: ${serviceInfo.onlineTime }</div>
		 	 <div>状态:<c:if test="${serviceInfo.auditStatus eq 'online' }">发布上线</c:if>
		 	     <c:if test="${serviceInfo.auditStatus eq 'audit' }">待审核</c:if>
		 	     <c:if test="${serviceInfo.auditStatus eq 'reject' }">拒绝上线</c:if>
		 	     <span class="offset10" style="margin-left:20px"><a onclick="history.back();" style="color: blue">返回</a></span>
		 	 </div>
		 </div>
	  </div>
	  <div class="row">
	 	<div class="service_info_title">基本信息</div>
	 	<div>
	 		<label>数据描述：</label>
			<label>${serviceInfo.description }</label>										
	 	</div>
	 	<div>
	 		<label >调用方式：</label>
			<label>${serviceInfo.callType}</label>
	 	</div>
	 	<div>
	 		<label >数据价格：</label>
			<label>${serviceInfo.price}</label>					
	 	</div>
	 	<div>
	 		<label >是否需要用户授权：</label>
			<label>
			<c:choose>
				<c:when test="${serviceInfo.needUserAuth==1}">
					是
				</c:when>
				<c:otherwise>
				    否
				</c:otherwise>
			</c:choose>
			</label>					
	 	</div>
	 	<div>
	 		<label >更新时间：</label>
			<label>${serviceInfo.updateTime}</label>
	 	</div>
	 	<div>
	 		<label >申请次数：</label>
			<label id="apply_num">${serviceInfo.buyNumbers}</label>
	 	</div>
	  </div>
<%--	  <div class="row">
	  	<div class="service_info_title">数据字段</div>
	  	<ul class="list-group">
	  		<li class="list-group-item">
	  			<div class="col-md-2">字段名称</div>
	  			<div class="col-md-2">是否必填</div>
	  			<div class="col-md-2">字段类型</div>
	  			<div class="col-md-2">字段描述</div>
	  			<div class="clearfix"></div>
	  		</li>
	  		<c:if test="${not empty serviceInfo.columnList }">
				<c:forEach items="${serviceInfo.columnList }" var="item">
					<li class="list-group-item">
						<div class="col-md-2">${item.columnName }</div>
						<div class="col-md-2">
							<c:if test="${item.isNull eq '0' }">否</c:if>
							<c:if test="${item.isNull eq '1' }">是</c:if>
						</div>
						<div class="col-md-2">
							<c:choose>
								<c:when test="${item.columnType eq 'number'}">数值型</c:when>
								<c:otherwise>字符型</c:otherwise>
							</c:choose>
						</div>
						<div class="col-md-2">${item.description }</div>
						<div class="clearfix"></div>
					</li>
				</c:forEach>
			</c:if>
			<c:if test="${empty serviceInfo.columnList }">
				<li class="list-group-item">
					<div>无数据字段</div>
				</li>
			</c:if>
	  	</ul>
	  </div>
	  <div class="row">  
	  	<div class="service_info_title">数据示例</div>
	  	<ul class="list-group">
			<li class="list-group-item">${serviceInfo.dataExample }</li>
	  	</ul>
	  </div>--%>
		<c:if test="${apply}">
			<div class="row">
				<div style="text-align:center">
					<button class="btn ue-btn" style="margin-top:8px" onclick="applyDataDef('${serviceInfo.id}')">申请</button>
				</div>
			</div>
		</c:if>
	  <script type="text/javascript">
	  var context = "<l:assetcontext/>";
      var openDataDefId = '${serviceInfo.id}';
	  	 $(function() {
//	  	   loadServiceApplyCount(openServiceId);
	  	 });
	  	 
	  	 function loadServiceApplyCount(openServiceId) {
	  	   $.ajax({
	  	     type: "get",
	  	     url: context + "/service/scdev/myapply/count/" + openServiceId,
	  	     success: function(count) {
	  	       if(IsNumeric(count)) {
	  	         $("#apply_num").html(count + "&nbsp;次");
	  	       } else {
	  	         $("#apply_num").html("0&nbsp;次");
	  	       }
	  	     }
	  	   })
	  	 }
	  	 
	  	 // 判断返回值是否为整数
	  	 function IsNumeric(input){
	  	     return (input - 0) == input && (''+input).trim().length > 0;
	  	 }

	  	 function applyDataDef(id){
             $.ajax({
                 type: "get",
                 url: context + "/service/open/data/apply/" + id,
                 success: function(resp) {
                     if(resp.result==true) {
                         $.dialog({
                             autofocus: true,
                             type: "alert",
                             content: "成功!"
                          });
                         // TODO 跳转到我的申请页面
                         window.location.href = context + "/service/data/apply/getPage";
                     } else {
                         $.dialog({
                             autofocus: true,
                             type: "alert",
                             content:"失败!"+resp.message
                         });
                     }
                 }
             })
		 }
	  </script>
  </div>
</body>
</html>