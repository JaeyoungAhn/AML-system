<%@ page import="java.sql.*"%>
<%
  String serverIP = "localhost";
  String strSID = "orcl";
  String portNum = "1521";
  String user = "db8";
  String pass = "db8";
  String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;
  System.out.println(url);
  Connection conn = null;
  Class.forName("oracle.jdbc.driver.OracleDriver");
  conn = DriverManager.getConnection(url,user,pass);
%>