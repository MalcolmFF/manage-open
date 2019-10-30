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
	<title>API授权</title>

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

	<style type="text/css">
		.btn {
			color: #3e99ff;
			padding: 4px 12px;
			background-color: #fff;
			border-color: #ddd;
			border-radius: 0;
			position: relative;
			float: right;
		}
		.btn:hover{
			color: #fff;
			background-color:#3e99ff;
		}

	</style>
	<script type="text/javascript">
        var context = "<l:assetcontext/>";
        $(document).ready(function() {
            var options = {
                info: true,
                ordering: false
            };

            var url = context + "/service/open/apply/list";
            grid = new L.FlexGrid("myauthList",url);
            grid.setParameter("authStatus", "0");
            grid.init(options); //初始化datatable
        });

        // function forPass(applyId) {
        //     $.dialog({
        //         type: 'confirm',
        //         content: '确认同意api申请?',
        //         autofocus: true,
        //         ok: function() {
        //             $.ajax({
        //                 url : context + "/service/open/apply/pass/" + applyId,
        //                 success: function(resp){
        //                     console.log(resp);
        //                     if(resp.result == true) {
        //                         $.dialog({
        //                             autofocus: true,
        //                             type: "alert",
        //                             content: "成功!"
        //                         });
        //                         reloadAuthList();
        //                     } else {
        //                         $.dialog({
        //                             autofocus: true,
        //                             type: "alert",
        //                             content:"失败!"+resp.message
        //                         });
        //                     }
        //                 }
        //             });
        //         },
        //         cancel: function(){}
        //     });
        // }
		function eachPass(applyId) {
					$.ajax({
						url : context + "/service/open/apply/pass/" + applyId,
						success: function(resp){
							console.log(resp);
							if(resp.result == true) {
								reloadAuthList();
							} else {
								sticky("失败!"+resp.message);
							}
						}
					});
		}
        // function forReject(applyId) {
        //     $.dialog({
        //         type: 'confirm',
        //         content: '确认驳回申请?',
        //         autofocus: true,
        //         ok: function() {
        //             $.ajax({
        //                 url : context + "/service/open/apply/reject/" + applyId,
        //                 success: function(resp){
        //                     console.log(resp);
        //                     if(resp.result == true) {
        //                         $.dialog({
        //                             autofocus: true,
        //                             type: "alert",
        //                             content: "成功!"
        //                         });
        //                         reloadAuthList();
        //                     } else {
        //                         $.dialog({
        //                             autofocus: true,
        //                             type: "alert",
        //                             content:"失败!"+resp.message
        //                         });
        //                     }
        //                 }
        //             });
        //         },
        //         cancel: function(){}
        //     });
        // }
		function eachReject(applyId) {
					$.ajax({
						url : context + "/service/open/apply/reject/" + applyId,
						success: function(resp){
							console.log(resp);
							if(resp.result == true) {
								reloadAuthList();
							} else {
								sticky("失败!"+resp.message);
							}
						}
					});
				}
        function forView(openDataId) {
            window.location.href = context + "/service/open/data/get/" + openDataId;
        }

        function forQuery() {
            var serviceName = $("#serviceName").val();
            grid.setParameter("authStatus", "0");
            grid.setParameter("serviceName", serviceName);
            reloadAuthList();
        }


        function reloadAuthList() {
            // 重新请求数据
            $("#myauthList").DataTable().ajax.reload();
        }

        function renderId(data, type, full, meta) {
            var rowId = meta.settings._iDisplayStart + meta.row + 1;
            return rowId;
        }

        function renderAuthStatus(data, type, full) {
            var html = '';
            if(data == '0') {
                html += '<span class="fa fa-clock-o text-info">&nbsp;待授权&emsp;</span>';
            } else if(data == '1') {
                html += '<span class="fa fa-check-circle text-success">&nbsp;同意授权</span>';
            } else if(data == '2') {
                html += '<span class="fa fa-times-circle text-danger">&nbsp;拒绝授权</span>';
            }
            return html;
        }

        function renderOptions(data, type, full) {
            var html = '';
            if(full.authStatus == '1') {
                html += '<div>';
                html += '    <a onclick="forView(\''+full.dtDataId+'\')">查看</a>';
                html += '</div>';
            } else if(full.authStatus == '2') {
                html += '<div>';
                html += '    <a onclick="forView(\''+full.dtDataId+'\')">查看</a>';
                html += '</div>';
            } else {
                html += '<div>';
				html += '    <a onclick="passAll(\''+data+'\')" class="btnSingle">同意</a>&nbsp;&nbsp;';
				// html += '    <a onclick="forPass(\''+data+'\')">同意</a>&nbsp;&nbsp;';
                html += '    <a class="del" onclick="rejectAll(\''+ data +'\')" class="btnSingle">驳回</a>';
                html += '</div>';
            }
            return html;
        }
        function renderName(data, type, full) {
            var html = '';
            html += '<a onclick="forView(\''+ full.dtDataId +'\')">'+ data + '</a>&emsp;';
            return html;
        }
		function renderCheckBox(data, type, full){
			return '<input type="checkbox" value="' + data + '" name="id">';
		}
		function passAll(id) {
			var cs = $("input[type='checkBox']:checked").serialize()
			var ids = cs.split("&");//获取所选的id数组
			if (cs.length>0){
				var flag = window.confirm("确认同意所选的申请吗？");
				if(!flag){return}
				for (var i=0;i<ids.length;i++){
					var a = ids[i].split("=");
					eachPass(a[1]);
				}
			}
			else if(id.length>0){
				var flag = window.confirm("确认同意该申请吗？");
				if(!flag){return}
				eachPass(id);
			}
			else{
				sticky("请选择至少一个申请");
			}

		}
		function rejectAll(id) {
			var cs = $("input[type='checkBox']:checked").serialize()
			var ids = cs.split("&");//获取所选的id数组
			if (cs.length>0){
				var flag = window.confirm("确认驳回所选的申请吗？");
				if(!flag){return}
				for (var i=0;i<ids.length;i++){
					var a = ids[i].split("=");
					console.log(a);
					eachReject(a[1]);
				}
			}
			else if(id.length>0){
				var flag = window.confirm("确认驳回该申请吗？");
				if(!flag){return}
				eachReject(id);
			}
			else{
				sticky("请选择至少一个申请");
			}
		}
		/**更新弹窗提示*/
		function sticky(msg, style, position) {
			var type = style ? style : 'success';
			var place = position ? position : 'top';
			$.sticky(
					msg,
					{
						autoclose : 2000,
						position : place,
						style : type
					}
			);
		}
	</script>
</head>
<body>
<div class="topdist"></div>
<div class="container" style="width: 98%; padding-top:10px;">
	<div class="row">
		<form class="form-inline" onsubmit="return false;">
			<div class="input-group">
				<input class="form-control ue-form" type="text" id="serviceName" placeholder="请输入服务名称"/>
				<div class="input-group-addon ue-form-btn" onclick="forQuery()">
					<span class="fa fa-search"></span>
				</div>
			</div>
			<input class="btn"type="button" value="驳回所选申请" onclick="rejectAll()">
			<input class="btn" type="button" value="同意所选申请" onclick="passAll()">

		</form>

	</div>

	<div class="row">
		<table id="myauthList" class="table table-bordered table-hover">
			<thead>
			<tr>
				<th width="30px" data-field="id" data-render="renderCheckBox" >
					<input type="checkbox" id="selectAll"/>
				</th>
<%--				<th width="5%" data-field="id" data-render="renderId">序号</th>--%>
				<th width="25%" data-field="app_name">应用名称</th>
				<th width="25%" data-field="api_service_name">服务名称</th>
				<th width="15%" data-field="applicant">申请人</th>
				<th width="13%" data-field="apply_time">申请时间</th>
				<th width="10%" data-field="auth_status" data-render="renderAuthStatus">授权状态</th>
				<th width="10%" data-field="id" data-render="renderOptions">操作</th>
			</tr>
			</thead>
		</table>
	</div>
</div>
</body>
</html>