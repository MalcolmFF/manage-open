<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="/tags/loushang-web" prefix="l"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
	<title>API列表</title>

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

	<script type="text/javascript">
		var context = "<l:assetcontext/>";

		$(document).ready(function() {
			//if( $("#workspace-header",parent.document))
			//{
			//	$("#workspace-header",parent.document).html('API列表');
			//}

			var options = {
				info: true,
				ordering: false
			};

			var url = context + "/service/open/api/getApiList"
			grid = new L.FlexGrid("myauthList",url);
			grid.init(options); //初始化datatable
		});

		//弹窗提示样式
		function sticky(msg, style, position) {
			var type = style ? style : 'success';
			var place = position ? position : 'top';
			$.sticky(
					msg,
					{
						autoclose : 1000,
						position : place,
						style : type
					}
			);
		}
		//发布
		function apirelease(openServiceId,auditStatus) {
			if("0"==auditStatus) {
				$.dialog({
					type: "iframe",
					title: "api发布",
					url: context + '/jsp/service/service/release.jsp?openServiceId=' + openServiceId,
					width: 450,
					height: 250,
					onclose: function () {
						reloadApiList();
						if (this.returnValue) {
							sticky("api发布成功！");
						}
					}
				});
			}
		}

		//授权
		function apiauth(openServiceId) {
			var apply_Flag="1";
			$.dialog({
				type: "iframe",
				title: "应用列表",
				url: context + '/jsp/service/service/app_auth_list.jsp?openServiceId=' + openServiceId+"&applyFlag="+apply_Flag,
				width: 700,
				height: 400
			});
		}
		//删除
		function apidel(openServiceId,auditStatus) {
			$.dialog({
				type: 'confirm',
				content: '确认删除该记录?',
				autofocus: true,
				ok: function() {
					$.ajax({
						url : context + "/service/open/api/delete/" + openServiceId,
						success: function(msg){
							if(msg == true) {
								reloadApiList();
								sticky("删除成功！");
							} else {
								sticky("删除失败", 'error', 'center');
							}
						}
					});
				},
				cancel: function(){}
			});
		}
		//编辑
		function apiedit(openServiceId,auditStatus) {
			window.location.href = context + "/service/open/api/toUpdate/" + openServiceId;
		}
		//下线
		function apioffline(openServiceId,auditStatus) {
			if("2"==auditStatus)
			{
				$.dialog({
					type: 'confirm',
					content: '确认api下线请求?',
					autofocus: true,
					ok: function() {
						$.ajax({
							url : context + "/service/open/api/offline/" + openServiceId,
							success: function(msg){
								if(msg == true) {
									reloadApiList();
									sticky("下线成功！");
								} else {
									sticky("下线失败", 'error', 'center');
								}
							}
						});
					},
					cancel: function(){}
				});
			}

		}
		function forRegister() {
			window.location.href = context + "/service/open/api/create";

		}
		function forQuery() {
			var serviceName = $("#serviceName").val();
			grid.setParameter("name", serviceName);
			reloadApiList();
		}
		function forView(id) {
			window.location.href = context + "/service/open/api/getInfo/"+id;
		}
		function reloadApiList() {
			// 重新请求数据
			$("#myauthList").DataTable().ajax.reload();
		}
		function renderId(data, type, full, meta) {
			var rowId = meta.settings._iDisplayStart + meta.row + 1;
			return rowId;
		}

		function renderName(data, type, full) {
			var html = '';
			html += '<a onclick="forView(\''+ full.id +'\')">'+ data + '</a>&emsp;';
			return html;
		}
		function renderOptions(data, type, full) {
			var html = '';
			html += '<div>';
			html += '    <a onclick="apiauth(\''+data+'\')">授权</a>&emsp;';
			if("0"==full.auditStatus||"3"==full.auditStatus||"4"==full.auditStatus)
			{
				html += '    <a onclick="apidel(\'' + data + '\')">删除</a>&emsp;';
			}else
			{
				html += '    <a onclick="return false;" style="cursor: default;color:#CCCCCC">删除</a>&emsp;';
			}
			if("0"==full.auditStatus||"3"==full.auditStatus||"4"==full.auditStatus)
			{
				html += '    <a onclick="apiedit(\''+data+'\')">编辑</a>&emsp;';
			}else
			{
				html += '    <a onclick="return false;" style="cursor: default;color:#CCCCCC">编辑</a>&emsp;';
			}
			/*     if("2"==full.auditStatus)
                 {
                     html += '    <a class="del" onclick="apioffline(\''+ data +'\',\''+full.auditStatus+'\')">下线</a>';
                 }else
                 {
                     html += '    <a class="del" onclick="return false;" style="cursor: default;color:#CCCCCC">下线</a>';
                 }*/

			html += '</div>';
			return html;
		}
		function renderStatus(data,type,full){
			if("0"==full.auditStatus)
			{
				return "创建";
			}
			else if("1"==full.auditStatus)
			{
				return "待审核";
			}
			else if("2"==full.auditStatus)
			{
				return "已上线";
			}
			else if("3"==full.auditStatus)
			{
				return "已驳回";
			}
			else if("4"==full.auditStatus)
			{
				return "已下线";
			}
		}
	</script>
</head>
<body>
<div class="topdist"></div>
<div class="container" style="width: 98%; padding-top:10px;">
	<div class="row">
		<form class="form-inline" onsubmit="return false;">
			<div class="input-group">
				<input class="form-control ue-form" type="text" id="serviceName" placeholder="请输入api名称"/>
				<div class="input-group-addon ue-form-btn" onclick="forQuery()">
					<span class="fa fa-search"></span>
				</div>
			</div>
			<%--		<div class="btn-group pull-right">
                        <button id="add" type="button" class="btn ue-btn" onclick="forRegister()">
                            <span class="fa fa-plus"></span>创建API
                        </button>
                    </div>--%>
		</form>
	</div>
	<div class="row">
		<table id="myauthList" class="table table-bordered table-hover">
			<thead>
			<tr>
				<th width="5%" data-field="id" data-render="renderId">序号</th>
				<th width="25%" data-field="name" data-render="renderName">api名称</th>
				<th width="15%" data-field="auditStatus" data-render="renderStatus">状态</th>
				<th width="20%" data-field="description">描述</th>
				<th width="13%" data-field="createTime">创建时间</th>
				<th width="10%" data-field="id" data-render="renderOptions">操作</th>
			</tr>
			</thead>
		</table>
	</div>
</div>
</body>
</html>
