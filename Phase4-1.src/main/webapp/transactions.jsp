<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>AML SYSTEM</title>
</head>
<body>
<%@ include file="dbconn.jsp"%>
<%
	PreparedStatement pstmt;
	int cnt;
	ResultSet rs;
%>
<%
	String state="";
	String[] filter = null;
	if(request.getParameterValues("filter") != null) filter = request.getParameterValues("filter");
	
	if(filter == null){
		String query = "SELECT * FROM DNG_TXN";
		pstmt = conn.prepareStatement(query);
		rs = pstmt.executeQuery();
		
		out.println("<table class='table' border=\"1\">");
		ResultSetMetaData rsmd = rs.getMetaData();
		cnt = rsmd.getColumnCount();
		for(int i =1;i<=cnt;i++){
			out.println("<thead class='table-light'>"+rsmd.getColumnName(i)+"</thead>");
		}
		while(rs.next()){
			out.println("<tr>");
			out.println("<td>"+rs.getString(1)+"</td>");
			out.println("<td>"+rs.getString(2)+"</td>");
			out.println("<td>"+rs.getString(3)+"</td>");
			switch(rs.getString(4)){
				case "0" : state = "심사 필요";
				break;
				case "1": state = "거래 허용";
				break;
				case "2": state = "거래 거부";
				break;
				case "3": state = "금융당국에 보고됨";
				break;
			}
			out.println("<td>"+state+"</td>");
			out.println("</tr>");		
		}
		out.println("</table>");

		rs.close();
		pstmt.close();
		conn.close();
	}else if(filter.length == 2){
		String query = "SELECT * FROM DNG_TXN WHERE STATE = 0 ORDER BY SCORE DESC";
		pstmt = conn.prepareStatement(query);
		rs = pstmt.executeQuery();
		
		out.println("<table class='table' border=\"1\">");
		ResultSetMetaData rsmd = rs.getMetaData();
		cnt = rsmd.getColumnCount();
		for(int i =1;i<=cnt;i++){
			out.println("<thead class='table-light'>"+rsmd.getColumnName(i)+"</thead>");
		}
		while(rs.next()){
			out.println("<tr>");
			out.println("<td>"+rs.getString(1)+"</td>");
			out.println("<td>"+rs.getString(2)+"</td>");
			out.println("<td>"+rs.getString(3)+"</td>");
			switch(rs.getString(4)){
				case "0" : state = "심사 필요";
				break;
				case "1": state = "거래 허용";
				break;
				case "2": state = "거래 거부";
				break;
				case "3": state = "금융당국에 보고됨";
				break;
			}
			out.println("<td>"+state+"</td>");
			out.println("</tr>");		
		}
		out.println("</table>");

		rs.close();
		pstmt.close();
		conn.close();
	}
	else if(filter.length == 1){
		if(filter[0].equals("2")){
			String query = "SELECT * FROM DNG_TXN WHERE STATE = 0";
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			out.println("<table class='table' border=\"1\">");
			ResultSetMetaData rsmd = rs.getMetaData();
			cnt = rsmd.getColumnCount();
			for(int i =1;i<=cnt;i++){
				out.println("<thead class='table-light'>"+rsmd.getColumnName(i)+"</thead>");
			}
			while(rs.next()){
				out.println("<tr>");
				out.println("<td>"+rs.getString(1)+"</td>");
				out.println("<td>"+rs.getString(2)+"</td>");
				out.println("<td>"+rs.getString(3)+"</td>");
				switch(rs.getString(4)){
					case "0" : state = "심사 필요";
					break;
					case "1": state = "거래 허용";
					break;
					case "2": state = "거래 거부";
					break;
					case "3": state = "금융당국에 보고됨";
					break;
				}
				out.println("<td>"+state+"</td>");
				out.println("</tr>");		
			}
			out.println("</table>");

			rs.close();
			pstmt.close();
			conn.close();
		}else if(filter[0].equals("3")){
			String query = "SELECT * FROM DNG_TXN ORDER BY SCORE DESC";
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			out.println("<table class='table' border=\"1\">");
			ResultSetMetaData rsmd = rs.getMetaData();
			cnt = rsmd.getColumnCount();
			for(int i =1;i<=cnt;i++){
				out.println("<thead class='table-light'>"+rsmd.getColumnName(i)+"</thead>");
			}
			while(rs.next()){
				out.println("<tr>");
				out.println("<td>"+rs.getString(1)+"</td>");
				out.println("<td>"+rs.getString(2)+"</td>");
				out.println("<td>"+rs.getString(3)+"</td>");
				switch(rs.getString(4)){
					case "0" : state = "심사 필요";
					break;
					case "1": state = "거래 허용";
					break;
					case "2": state = "거래 거부";
					break;
					case "3": state = "금융당국에 보고됨";
					break;
				}
				out.println("<td>"+state+"</td>");
				out.println("</tr>");		
			}
			out.println("</table>");

			rs.close();
			pstmt.close();
			conn.close();
		}
	}
%>
</body>
</html>