<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.inspur.bigdata.manage.open.service.data.ApiServiceMonitor" %>
<%@ page import="java.util.Iterator" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="/tags/loushang-web" prefix="l" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>API调用详情</title>
    <link rel="stylesheet" type="text/css" href="<l:asset path='css/bootstrap.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<l:asset path='css/font-awesome.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<l:asset path='css/form.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<l:asset path='css/ui.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<l:asset path='css/datatables.css'/>"/>
    <style type="text/css">
        .Validform_input {
            width: 85%;
        }

        .Validform_right {
            width: 10%;
        }

        .appDescription {
            width: 90%;
            overflow-x: hidden
        }

        .control-label {
            text-align: right;
        }

        .content {
            margin: 20px 14px 14px 14px;
            padding: 10px;
        }

        .console-panel-header {
            position: relative;
            background: #F4F5F9;
            border: 1px solid #E1E6EB;
            border-bottom: none;
            padding: 0 12px 0 16px;
            font-size: 14px;
            height: 40px;
            line-height: 38px;
        }

        table.console-panel-body {
            width: 100%;
            border: none;
        }

        .console-panel-body {
            border: 1px solid #E1E6EB;
            background: #FFF;
        }

        table {
            border-collapse: collapse;
            border-spacing: 0;
        }

        .console-panel-header-line {
            display: block;
            position: absolute;
            left: -1px;
            top: -1px;
            height: 41px;
            width: 3px;
            overflow: hidden;
            background: #778;
            font-size: 0;
            line-height: 0;
        }

        .console-float-left {
            float: left !important;
        }

        .console-float-right {
            float: right !important;
        }

        .console-button-wrap {
            display: inline-block;
            cursor: pointer;
        }

        table.console-panel-body tr td {
            background: #FFF;
            border: 1px solid #E1E6EB;
            padding: 16px;
            vertical-align: middle;
            line-height: 140%;
        }

        .console-grey {
            color: #999 !important;
        }

        .console-button-tiny {
            font-size: 12px;
            padding: 0px 8px;
            line-height: 18px;
            height: 20px;
        }

        .console-button:link, .console-button:visited {
            color: #333;
        }

        .console-button {
            width: 100%;
            text-align: center;
            display: inline-block;
            border: 1px solid #DDD;
            background: #F7F7F7;
            padding: 0px 16px;
            cursor: pointer;
            height: 32px;
            line-height: 30px;
            text-decoration: none;
            color: #333;
            font-size: 12px;
        }

        .console-button-tiny span, .console-button-tiny i {
            line-height: 18px;
        }

        table.dataTable thead > tr {
            background-color: #f6f6f6;
        }

        .table-bordered > tbody > tr > td, .table-bordered > thead > tr > th {
            text-align: center;
        }

        .console-button-wrap {
            display: inline-block;
            cursor: pointer;
        }

        #btn1 {
            height: 25px;
            line-height: 25px;
        }

        #pwd {
            border: none;
            outline: medium;
        }

        .div1 {
            margin-bottom: 14px;
            display: inline-block;
        }

        .div1 > span {
            margin-right: 5px;
            font-weight: bolder;
            color: blue;
        }

        .div2 {
            box-sizing: border-box;
            display: inline-block;
            border: 1px solid lightgrey;
            background-color: #F7F7F7;
            margin-left: 5px;
        }

        .modify {
            border: 1px solid lightgrey;
            background-color: #F7F7F7;
            padding: 5px;
        }

        .ue-tabs {
            margin-bottom: 8px;
            border-bottom: 0;
        }

        .ue-tabs > li > a {
            font-size: 12px;
            padding: 0 25px;
            line-height: 30px;
            border-radius: 0;
            border: 1px solid lightgray;
        }

        .ue-tabs > li.active > a, .ue-tabs > li.active > a:focus, .ue-tabs > li.active > a:hover {
            height: 32px;
            color: white;
            border: 1px solid #ddd;
            border-radius: 0;
            background-color: #3e99ff;
        }

        .console-bottom {
            margin-bottom: 16px;
        }

        .param {
            background-color: #F4F5F9;
        }

        .table tbody tr:hover {
            background-color: #F4F5F9;
        }

        table.dataTable thead > tr {
            background-color: #F4F5F9;
        }

        table.dataTable thead > tr > th {
            font-weight: normal;
        }

        table.param tbody td {
            border-left-width: 0;
            border-bottom-width: 1px;
        }

        .outparam .col-md-2 {
            width: 12.5%;
        }

    </style>

</head>
<body>
<div class="content">

    <div class="div1">
        <span>|</span>API调用详情
    </div>

    <div class="div2 " id="back"><span class="fa fa-reply"></span><a onclick="history.back(-1);">返回</a></div>

    <c:if test="${empty isSuccess }">
        <div class="console-panel console-bottom">
            <div class="console-panel-header">
                <span class="console-panel-header-line"></span>
                <div class="console-float-left ng-binding">调用信息</div>
            </div>
            <table class="console-panel-body">
                <tbody>
                <tr>
                    <td class="ng-binding"><span class="console-grey ng-binding">
                        <c:if test="${empty error}">暂无详情信息或ID不正确</c:if>
                        <c:if test="${not empty error}">${error}</c:if>
                    </span></td>
                </tr>
                </tbody>
            </table>
        </div>
    </c:if>
    <c:if test="${not empty isSuccess }">

        <div class="console-panel console-bottom">
            <div class="console-panel-header">
                <span class="console-panel-header-line"></span>
                <div class="console-float-left ng-binding">调用信息</div>
            </div>
            <table id="table1_id" class="console-panel-body">
                <tbody>
                <tr>
                    <td width="25%" class="ng-binding"><span class="console-grey ng-binding">调用者ID：</span>
                        <c:if test="${not empty callerUserId }">${callerUserId}</c:if>
                        <c:if test="${empty callerUserId }">-</c:if>
                    </td>
                    <td width="25%" class="ng-binding"><span class="console-grey ng-binding">调用者IP：</span>
                        <c:if test="${not empty callerIp }">${callerIp}</c:if>
                        <c:if test="${empty callerIp }">-</c:if>
                    </td>

                    <td width="25%" class="ng-binding"><span class="console-grey ng-binding">调用时间：</span>
                        <c:if test="${not empty requestTime }">${requestTime}</c:if>
                        <c:if test="${empty requestTime }">-</c:if>
                    </td>
                    <td width="25%" class="ng-binding"><span class="console-grey ng-binding">响应时间：</span>
                        <c:if test="${not empty responseTime }">${responseTime}</c:if>
                        <c:if test="${empty responseTime }">-</c:if>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="console-panel console-bottom">
            <div class="console-panel-header">
                <span class="console-panel-header-line"></span>
                <div class="console-float-left ng-binding">响应信息</div>
            </div>
            <table id="table2_id" class="console-panel-body">
                <tbody>
                <tr>
                    <td class="ng-binding"><span class="console-grey ng-binding">查询的授权人员总数：</span><span>
                    <c:if test="${not empty totalNumber }">${totalNumber} 人</c:if>
                    <c:if test="${empty totalNumber }">-</c:if>
                </span></td>
                    <td class="ng-binding"><span class="console-grey ng-binding">阳性数据人数：</span><span>
                    <c:if test="${not empty totalPositivePopulation }">${totalPositivePopulation} 人</c:if>
                    <c:if test="${empty totalPositivePopulation }">-</c:if>
                </span></td>
                    <td class="ng-binding"><span class="console-grey ng-binding">阳性数据就诊记录条数：</span><span>
                    <c:if test="${not empty totalPositiveRecord }">${totalPositiveRecord} 条</c:if>
                    <c:if test="${empty totalPositiveRecord }">-</c:if>
                </span></td>
                </tr>
                <tr>
                    <td colspan="3" class="ng-binding"><span class="console-grey ng-binding">上传文件查看：</span><span>
                    <c:if test="${not empty uploadFile }">
                        <%
                            String fileAPi = "/manage-open/service/api/execute/do/92fcd23169094b209dc6ab07b8a15036/downloadZipFile?xCaKey=517479&xCaSignature=e0a08fb968942e3fcdbb67417dc26b82&fileName=";
                            String fileUrl = (String) request.getAttribute("uploadFile");
                            String[] names = fileUrl.split("/");
                            if (names != null && names.length > 0) {
                                out.print("<a href=\"" + fileAPi + names[names.length - 1] + "\" target=\"上传文件下载\" title=\"上传文件下载\">点击下载</a>");
                            } else {
                                out.print("暂无文件下载");
                            }
                        %>
                    </c:if>
                    <c:if test="${empty uploadFile }">暂无文件下载</c:if>
                </span></td>
                </tr>
                <tr>
                    <td colspan="3" class="ng-binding"><span class="console-grey ng-binding">返回结果查看：</span><span>
                    <c:if test="${not empty resultFile }">
                        <%
                            String excleAPi = "/manage-open/service/api/execute/do/92fcd23169094b209dc6ab07b8a15036/hbExportExcelNew?xCaKey=517479&xCaSignature=e0a08fb968942e3fcdbb67417dc26b82&content=";
                            String content = (String) request.getAttribute("resultFile");
                            if (content != null && content.length() > 0) {
                                out.print("<a href='" + excleAPi + content + "' target=\"返回结果下载\" title=\"返回结果下载\">点击下载</a>");
                            } else {
                                out.print("暂无文件下载");
                            }
                        %>
                    </c:if>
                    <c:if test="${empty resultFile }">暂无文件下载</c:if>
                </span></td>
                </tr>


                </tbody>
            </table>
        </div>

    </c:if>
</div>
</body>

<!--[if lt IE 9]>
<script src="<l:asset path='html5shiv.js'/>"></script>
<script src="<l:asset path='respond.js'/>"></script>
<![endif]-->

<script type="text/javascript" src="<l:asset path='jquery.js'/>"></script>
<script type="text/javascript" src="<l:asset path='bootstrap.js'/>"></script>
<script type="text/javascript" src="<l:asset path='form.js'/>"></script>
<script type="text/javascript" src="<l:asset path='datatables.js'/>"></script>
<script type="text/javascript" src="<l:asset path='loushang-framework.js'/>"></script>
<script type="text/javascript" src="<l:asset path='jquery.form.js'/>"></script>
<script type="text/javascript" src="<l:asset path='ui.js'/>"></script>

<script type="text/javascript">
    var context = "<l:assetcontext/>";
    var id = '${apiServiceMonitor.id}';
    $(function () {
    });


    function renderid(data, type, full, meta) {
        var rowId = meta.settings._iDisplayStart + meta.row + 1;
        return rowId;
    }


</script>
</html>
