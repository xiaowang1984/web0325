<%--
  Created by IntelliJ IDEA.
  User: wangyu
  Date: 2019/3/27
  Time: 15:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/common/head.jsp"%>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <form action="${basepath}/user/add" method="post" enctype="multipart/form-data">
        <input type="file" name="img" />
        <button type="submit">上传</button>
    </form>
</body>
</html>
