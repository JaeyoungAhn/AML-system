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
<%@ include file="dbconn.jsp"%>
<%
	PreparedStatement pstmt;
	int cnt;
	ResultSet rs;
%>
<%
	int txn_id = Integer.parseInt(request.getParameter("txn_id"));

	// DNG_TXN UPDATE
	String query = "UPDATE DNG_TXN SET STATUS=3 WHERE TXN_ID=?";
	pstmt = conn.prepareStatement(query);
	
	pstmt.setInt(1, txn_id);

    int feedback = pstmt.executeUpdate();
    if(feedback==0) out.println("No Updated.");
    else out.println("<h4>거래ID: "+txn_id+"에 대해 정상적으로 보고 되었습니다.</h4>");
	
 // TRANSACTION UPDATE
    query = "UPDATE TRANSACTION SET STATUS='2' WHERE TXN_ID=?";
	pstmt = conn.prepareStatement(query);
	
	pstmt.setInt(1, txn_id);

    feedback = pstmt.executeUpdate();
    if(feedback==0) out.println("No Updated.");
    
	pstmt.close();
	conn.close();
%>
<form action="FirstMenu.jsp">
	&nbsp;<button class="btn btn-warning"><h4>이전 단계로 돌아가기</h4></button>
</form>
<div></div>
<style>
	.result-text {
		margin-bottom: 20px;
		text-align: center;
	}
	.result-box {
		width: 50%;
		margin: 0 auto;
		padding-top: 30px;
		max-width: 500px;
		min-width: 300px;
	}
	html{
		background-image: linear-gradient(rgba(239,239,239,0.5), rgba(239,239,239,0.5)), url('https://immigrantinvest.com/wp-content/uploads/2022/03/best-banks-2021-40543452.jpg');
		background-repeat: no-repeat;
		background-size: cover;
		background-position: center center;
		min-width: 100%;
		min-height: 100%;
	}
	#all{
		padding: 30px;
	}
	body{
		background-color: rgba(255,255,255,0.6);
		margin-bottom: 0;
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
