<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
	<title>AML SYSTEM</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
</head>

<body>
<h2 class="bg-warning" style="text-align:center">AML 업무수행</h2>
<h3>&nbsp;금융당국에 보고하기</h3>
<div class="transaction">
<%@ include file="dbconn.jsp"%>
	<%
		PreparedStatement pstmt;
		int cnt;
		ResultSet rs;
	%>
<form action="result.jsp" method="post">
<%
	int txn_id = Integer.parseInt(request.getParameter("txn_id"));
	out.println("<input type='hidden' name='txn_id' value="+txn_id+">");
	
	String query = "SELECT * FROM DNG_TXN WHERE TXN_ID=?";
	pstmt = conn.prepareStatement(query);
	pstmt.setInt(1,txn_id);
	
	rs = pstmt.executeQuery();
	out.println("<table border=\"2\">");
	ResultSetMetaData rsmd = rs.getMetaData();
	cnt = rsmd.getColumnCount();
	for(int i =1;i<=cnt;i++){
		out.println("<th>"+rsmd.getColumnName(i)+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>");
	}
	while(rs.next()){
		out.println("<tr>");
		out.println("<td>"+rs.getString(1)+"</td>");
		out.println("<td>"+rs.getString(2)+"</td>");
		out.println("<td>"+rs.getString(3)+"</td>");
		out.println("<td>"+rs.getString(4)+"</td>");
		out.println("</tr>");		
	}
	out.println("</table>");

%>
<%

	rs.close();
	pstmt.close();
	conn.close();
%>
</div>
	<br>
	<label><h4>&nbsp;보고사유</h4></label>
		<textarea name="" id="" cols="200" rows="10"></textarea>
		<br><br>
	<input class="btn btn-warning" type="submit" value="Report">

</form>

	<div></div>
</div>
<style>
	html{
		background-image: linear-gradient(rgba(239,239,239,0.5), rgba(239,239,239,0.5)), url('https://immigrantinvest.com/wp-content/uploads/2022/03/best-banks-2021-40543452.jpg');
		background-repeat: no-repeat;
		background-size: cover;
		background-position: center center;
		min-width: 100%;
		min-height: 100%;
	}
	button {
		margin: 15px;
	}
	#all{
		padding: 30px;
	}
	body{
		background-color: rgba(255,255,255,0.6);
	}
	#contents{
		display:block;
	}
	.text-box{
		font-size: 6em;
		text-align: center;
		color: #F1C164;
		text-shadow: 5px 5px #16345A, 8px 8px #284D8E, 11px 11px #4D8CBF, 14px 14px #5FA9D9;
		margin: 0;
	}
</style>
</body>
</html>
