<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="/tags/loushang-web" prefix="l"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>
	    <meta charset="utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <meta name="viewport" content="width=device-width, initial-scale=1">

	    <!-- 需要引用的CSS -->
		<link rel="shortcut icon" href="<%=request.getContextPath()%>/jsp/public/images/favicon.ico" />
		<link rel="stylesheet" type="text/css" href="<l:asset path='css/bootstrap.css'/>" />
		<link rel="stylesheet" type="text/css" href="<l:asset path='css/font-awesome.css'/>" />
		<link rel="stylesheet" type="text/css" href="<l:asset path='css/ui.css'/>" />
		<link rel="stylesheet" type="text/css" href="<l:asset path='css/form.css'/>" />
        <link rel="stylesheet" type="text/css" href="<l:asset path='data/servicetest.css'/>"/>
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
	    <script type="text/javascript" src="<l:asset path='ui.js'/>"></script>
	</head>
<title>服务测试</title>
<body>
	<div class="content-body">
		<div class="test-left" style="height: auto;">
			<div class="left-title1" style="padding-top: 0px;"><strong>基本信息</strong></div>
			<div class="left-title2">
				<div class="test-clearfix">
					<div class="col-xs-2 col-md-2 control-label" style="font-weight: bold;">服务名称: </div>
					<div title="${serviceDef.name}">
						${serviceDef.name}
					</div>

				</div>
				<div class="test-clearfix">
					<div style="margin-right: 10px; font-weight: bold;" class="col-xs-2 col-md-2 control-label">服务地址:</div>
					<div title="${serviceDef.reqPath}">
						${serviceDef.reqPath}
					</div>
				</div>
				<%--<div class="test-clearfix">--%>
					<%--<div style="margin-right: 10px;" class="col-xs-2 col-md-2 control-label">服务版本:</div>--%>
					<%--<div style="font-weight: bold;">${serviceDef.version}</div>--%>
				<%--</div>--%>
			</div>
			<div class="left-title1"><strong>请求参数</strong></div>
			<div class="service-param left-title2">
				<div id="request-test" action="" style="margin-bottom:14px">
				</div>
			</div>
			<div>
				<div class="left-title1"><strong>App认证</strong></div>
				<div class="left-title2">
					<div class="test-clearfix">
						<div class="col-xs-2 col-md-2 control-label">AppName: </div>
						<div id="applistselect" >
						</div>
					</div>
					<div class="test-clearfix appsinfo">
						<div class="col-xs-2 col-md-2 control-label">AppKey: </div>
						<input style="font-weight: bold;"  id="appkey" value="${data.appKey}"  readonly>
						</input>
					</div>
					<div class="test-clearfix appsinfo">
						<div class="col-xs-2 col-md-2 control-label">AppSecret: </div>
						<input style="font-weight: bold;" type="password" id="appsecret"  value="${data.appSecret}" readonly>
						</input>
					</div>
				</div>
			</div>
			<div id="call-service" class="call-service">
				<input type="button" name="" value="发送请求" onclick="testService();">
			</div>
		</div>
		<div class="test-right">
			<div id="paramCon">
				<div class="returntitle">请求</div>
				<div class="param-textarea"></div>
			</div>
			<div id="returnCon">
				<div class="returntitle">返回内容</div>
				<div class="result-textarea" id="content-area"></div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
    var context = "<%=request.getContextPath()%>";
	getAppInfo("${data.appId}");
    $.ajax({
        type: "post",
        url: context + "/service/api/execute/getserviceinput/${serviceDef.id}",
        data:JSON.stringify({parentId:-1}),
        contentType:'application/json;charset=UTF-8',
        success: function(data) {
            var html = template("paramlist", data);
            $("#request-test").empty().append(html);
        }
    });
    function getAppInfo(appId){
        $.ajax({
            type: "post",
            url: context + "/service/api/execute/getAppList/${serviceDef.id}",
            data:JSON.stringify({parentId:-1}),
            contentType:'application/json;charset=UTF-8',
            success: function(data) {
                var html = template("applist", data);
                $("#applistselect").empty().append(html);
                if(appId != ''&&appId != null){
                    $("#appselect").val(appId);
                    $("#appselect").attr("disabled",true);
                }
            }
        });
	}
	function loadAppInfo(){
        var appId = $("#appselect option:selected").val();//获取api
        $("#appkey").val("");
        $("#appsecret").val("");
		$.ajax({
			type:"post",
			url: context+"/service/api/execute/getAppInfo/"+appId,
            data:JSON.stringify({parentId:-1}),
            contentType:'application/json;charset=UTF-8',
            success: function(data) {
			    $("#appkey").val(data.data.appKey);
                $("#appsecret").val(data.data.appSecret);
            }
		})
	}
	function testService(){
		var isFilled = true;
		var msg = "";
        var paramStr = "";
		//进行校验
        var i = 0;
        $("table>tbody>tr").each(function(){
            var onedata = {};
           /* if(i!=0){*/
                var name = $(this).find('td').eq(0).text();
                var require = $(this).find('td').eq(1).text().trim();
                var value = $(this).find('td').eq(3).find('input').val();
                if(require =="是"&&value==""){
                    isFilled = false;
                    msg = name +"&nbsp;:&nbsp;"+ "不能为空!";
                    sticky(msg, 'error', 'center');
				}
				paramStr = paramStr + name + ":" + value + "";
           /* }*/
            i = i+1;
        });

        $(".param-textarea").text(paramStr);
        var appId= $("#appselect option:selected").val();//获取api
		if(isFilled&&appId==""){
			isFilled = false;
			msg =  "请选择认证AppName";
			sticky(msg, 'error', 'center');
		}
		//save 数据获取提交的数据
        if(isFilled){
			var i = 0;
			var listdata={};
			$("table>tbody>tr").each(function(){
				var onedata = {};
				/*if(i!=0){*/
					listdata[$(this).find('td').eq(0).text()]=encodeURIComponent($(this).find('td').eq(3).find('input').val());
				/*}*/
				i = i+1;
			});
			var datass =  JSON.stringify(listdata);
			$.ajax({
				type : 'post',
				url : context + '/service/api/execute/apitest/${serviceDef.id}',
				/*contentType : "application/x-www-form-urlencoded; charset=UTF-8",*/
				data : {"paramlist":datass,"appId":appId},
				success : function(data){
                    var html = "";
                    debugger;
                    if(data.result==true){
                        html = "<p>header="+data.header+"</p><p>"+"result="+data.info+"</p>";
                    }else{
                        html = "<p>"+"body="+data.info+"</p>";
                    }
                    $("#content-area").html(html);
				},
				timeout:30000,
				error:function(){
				  console.log("调用超时，请稍后重试");
				}
			});
		}
	}

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
</script>
<script id="paramlist" type="text/html">
	<table>
		<thead>
			<tr>
				<th style="width: 18%;">字段名称</th>
				<%--<th style="width: 18%;">字段类型</th>--%>
				<th style="width: 18%">是否必填</th>
				<th style="width: 20%">字段描述</th>
				<th style="width: 26%">字段值</th>
			</tr>
		</thead>
	<tbody>
		{{each data as oneinfo}}
		{{ if oneinfo.fixedValue ==null||oneinfo.fixedValue =="" }}
		<tr>
			<td>{{oneinfo.name}}</td>
			<%--<td>{{oneinfo.type}}</td>--%>
			<td>
				{{ if oneinfo.required=="1"}} 是 {{ /if }}
				{{ if oneinfo.required=="0"}} 否 {{ /if }}

			</td>
			<td>{{oneinfo.description}}</td>
			<td><input type="text" class="description"  placeholder="请输入..."></td>
		</tr>
		{{ /if }}
		{{/each}}
	</tbody>
	</table>
</script>


<script id="applist" type="text/html">
	<select id="appselect" class="appselect" datatype="s"  onchange="loadAppInfo();" nullmsg="请选择App应用">
		<option value="">请选择App应用</option>
		{{each data as group}}
		<option value="{{group.appId}}">{{group.appName}}</option>
		{{/each}}
	</select>
</script>
