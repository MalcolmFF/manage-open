<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="/tags/loushang-web" prefix="l"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>数据列表</title>
    
    <!-- 需要引用的CSS -->
	<link rel="shortcut icon" href="<%=request.getContextPath()%>/jsp/public/images/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="<l:asset path='css/bootstrap.css'/>" />
	<link rel="stylesheet" type="text/css" href="<l:asset path='css/font-awesome.css'/>" />
	<link rel="stylesheet" type="text/css" href="<l:asset path='css/ui.css'/>" />
	<link rel="stylesheet" type="text/css" href="<l:asset path='css/form.css'/>" />
    <link rel="stylesheet" type="text/css" href="<l:asset path='css/datatables.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<l:asset path='css/ztree.css'/>" />
    <link rel="stylesheet" type="text/css" href="<l:asset path='data/datadev.css'/>" />
    
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
  //全局变量
  var serviceGrid;
  $(document).ready(function() {
	// 初始化表格
	initTable();
    //查询框回车键
    $("#serviceName").bind('keypress',function(event) {
  		if (event.keyCode == "13") {
  			forQuery();
  		 }
  	});
  });
  
  function initTable(){
	  var options = {
	      ordering: false
	  };
	  var url = context + "/service/open/data/getList"
	  serviceGrid = new L.FlexGrid("myServiceList", url);
	  serviceGrid.init(options); //初始化datatable
  }
  
  function forEdit(id) {
    window.location.href = context + "/service/open/data/toUpdate/" + id;
  }
  
  function forView(id) {
    window.location.href = context + "/service/open/data/get/" + id;
  }
  
  function forRegister() {
      window.location.href = context + "/service/open/data/release";

  }
  
  function forQuery() {
    var serviceName = $("#serviceName").val();
    var auditStatus = $("#auditStatus").val();
    serviceGrid.setParameter("name", serviceName);
    serviceGrid.setParameter("auditStatus", auditStatus);
    reloadMyServiceList();
  }

  function forDel(id) {
    $.dialog({
      type: 'confirm',
      content: '确认删除该数据?',
      autofocus: true,
      ok: function() {
        $.ajax({
          url: context + "/service/open/data/delete/" + id,
          success: function(msg) {
            if (msg) {
              reloadMyServiceList();
              sticky("删除成功！", 'success', 'center');
            } else {
              sticky("删除失败", 'error', 'center');
            }
          }
        });
      },
      cancel: function() {
      }
    });
  }

  function reloadMyServiceList() {
    // 重新请求数据
    $("#myServiceList").DataTable().ajax.reload();
  }

  //弹窗提示样式
  function sticky(msg, style, position) {
    var type = style ? style : 'success';
    var place = position ? position : 'top';
    $.sticky(msg, {
      autoclose: 1000,
      position: place,
      style: type
    });
  }

  function renderId(data, type, full, meta) {
    var rowId = meta.settings._iDisplayStart + meta.row + 1;
    return rowId;
  }

  function renderAuditStatus(data, type, full) {
    var html = '';
    if(data == '0') {
      html += '<span class="fa fa-plus-circle text-info">&nbsp;初始创建</span>';
    } else if(data == '1') {
      html += '<span class="fa fa-clock-o text-primary">&nbsp;待审核</span>';
    } else if(data == '2') {
      html += '<span class="fa fa-check-circle text-success">&nbsp;发布上线</span>';
    } else if(data == '3') {
      html += '<span class="fa fa-times-circle text-danger">&nbsp;拒绝上线</span>';
    } else if(data == '4') {
        html += '<span class="fa fa-minus-circle text-danger">&nbsp;强制下线</span>';
    }
    return html;
  }

  function renderOptions(data, type, full) {
	    var html = "<div>";
	    if(full.auditStatus == '2') {
	      html += '<a onclick="forView(\'' + data + '\')">查看</a>';
	    } else if(full.auditStatus == '1'){
	      html += '<a onclick="forView(\'' + data + '\')">查看</a>&nbsp;';
	      html += '<a onclick="forDel(\'' + data + '\')">删除</a>';
	    } else if(full.auditStatus == '3'){
	        html += '<a onclick="forView(\'' + data + '\')">查看</a>&nbsp;';
	        html += '<a onclick="forEdit(\'' + data + '\')">编辑</a>';
	     }else {
			html += '<a onclick="forEdit(\'' + data + '\')">编辑</a>&nbsp;';
	    	html += '<a onclick="forDel(\'' + data + '\')">删除</a>';   	
	    }
	    html += '</div>';
	    return html;
	  }
  function renderName(data, type, full) {
      var html = '';
      html += '<a onclick="forView(\''+ full.id +'\')">'+ data + '</a>&emsp;';
      return html;
  }
</script>
</head>
<body>
	<div class="topdist"></div>
	<div class="container" style="width: 98%; padding-top:10px;">
		<div class="row">
			<form class="form-inline" onsubmit="return false;">
			    <select id="auditStatus" class="form-control ue-form" onchange="forQuery()">
			    	<option value="">全部</option>
			    	<option value="0">初始创建</option>
			    	<option value="1">待审核</option>
			    	<option value="2">发布上线</option>
			    	<option value="3">被驳回</option>
			    	<option value="4">强制下线</option>
			    </select>
				<div class="input-group">
			        <input class="form-control ue-form" type="text" id="serviceName" placeholder="请输入服务名称"/>
			        <div class="input-group-addon ue-form-btn" onclick="forQuery()">
			        	<span class="fa fa-search"></span>
			        </div>
		        </div>
				<div class="btn-group pull-right">
					<button id="add" type="button" class="btn ue-btn" onclick="forRegister()">
						<span class="fa fa-plus"></span>发布服务
					</button>
				</div>
			</form>
		</div>
		<div class="row">
			<table id="myServiceList" class="table table-bordered table-hover">
				<thead>
					<tr>
						<th width="5%" data-field="id" data-render="renderId">序号</th>
						<th width="20%" data-field="name"  data-render="renderName">数据名称</th>
						<th width="20%" data-field="tableName">表名称</th>
						<th width="30%" data-field="description">数据描述</th>
						<th width="15%" data-field="createTime">创建时间</th>
						<th width="10%" data-field="auditStatus" data-render="renderAuditStatus">审核状态</th>
						<th width="12%" data-field="id" data-render="renderOptions">操作</th>
					</tr>
				</thead>
			</table>
		</div>
	</div>
</body>
</html>