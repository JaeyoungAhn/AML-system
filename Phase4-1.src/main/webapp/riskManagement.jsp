<%@ page language="java" contentType="text/html; charset=EUC-KR"
         pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="EUC-KR">
    <title>AML SYSTEM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
</head>
<body>


<div class="transaction" width="500px" id="transaction">
    <!-- <iframe src="transactions.jsp" name='transaction'></iframe>  -->
<%@ include file="dbconn.jsp"%>
<%
    int cnt;
    ResultSet rs;
%>
    <%
        String state="";
        String query="";
        String[] filter = request.getParameterValues("filter");

        PreparedStatement pstmt = null;

        if(filter[0].equals("1")){
            out.println("<h2 class='bg-warning'>위험 인물 거래 조회</h2>");
            out.println("<h3>거래 중 상대방이 위험 인물 리스트에 포함된 경우를 확인합니다.</h3>");
            query = "SELECT * FROM TRANSACTION WHERE EXISTS ( SELECT * FROM DNG_PERS WHERE NAME=CNTR_NAME )";
            pstmt = conn.prepareStatement(query);
        }else if(filter[0].equals("2")){
            out.println("<h2 class='bg-warning'>위험 계좌 거래 조회</h2>");
            out.println("<h3>거래 중 상대방의 계좌번호가 위험 계좌 리스트에 포함된 경우를 확인합니다.</h3>");
            query = "SELECT * FROM TRANSACTION WHERE (CNTR_ACC_NO) IN (SELECT ACCT_NO FROM DNG_ACCT)";
            pstmt = conn.prepareStatement(query);
        }else if(filter[0].equals("3") || filter[0].equals("5")) {
            out.println("<h2 class='bg-warning'>기간별 개인정보를 제외한 거래 정보 조회</h2>");
            out.println("<h3>&nbsp;시작일 종료일 사이에 일어난 거래들의 거래액과 상대방의 국가를 조회합니다.</h3>");
            if(filter[0].equals("3")) {
                out.println("<form name='permission' method='post'>");
                out.println("<hr><p><h4>&nbsp;&nbsp;시작일을 yyyy-mm-dd 형태로 입력해주세요: <input type='text' name='start_date'></h4></p>");
                out.println("<p><h4>&nbsp;&nbsp;종료일을 yyyy-mm-dd 형태로 입력해주세요: <input type='text' name='end_date'></h4></p><hr>");
                out.println("&nbsp;&nbsp;&nbsp;<button class='btn btn-warning' name='filter' onclick='javascript: form.action='riskManagement.jsp';' value=5><h4>조회</h4></button></form>");
            } else {
                String startDate = request.getParameter("start_date");
                String endDate = request.getParameter("end_date");
                query = "SELECT T.TXN_DATE, T.AMOUNT, CNTR_CTRY FROM TRANSACTION T WHERE T.TXN_DATE BETWEEN ? AND ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setDate(1, Date.valueOf(startDate));
                pstmt.setDate(2, Date.valueOf(endDate));
            }
        }
        else if(filter[0].equals("4") || filter[0].equals("6")) {
            out.println("<h2 class='bg-warning'>특정 금액 이상 거래 고객 정보 조회</h2>");
            out.println("<h3>거래 중 특정 금액 이상이 입금되거나 송금하는 경우를 확인합니다.</h3>");
            if(filter[0].equals("4")) {
                out.println("<form name='permission' method='post'>");
                out.println("<hr><p><h4>&nbsp;&nbsp;거래 금액을 입력하세요: <input type='text' name='amount'></h4></p><hr>");
                out.println("&nbsp;&nbsp;&nbsp;<button class='btn btn-warning' name='filter' onclick='javascript: form.action='riskManagement.jsp';' value=6><h4>조회</h4></button></form>");
            } else {
                String amnt = request.getParameter("amount");
                query = "SELECT H.H_ID, H.Name, T.TXN_DATE, T.AMOUNT FROM INITIATION I, HOLDER H, TRANSACTION T WHERE I.H_ID=H.H_id AND I.TXN_ID=T.TXN_ID AND T.AMOUNT >= ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, Integer.parseInt(amnt));
            }
        }

        if(filter[0].equals("1") || filter[0].equals("2") || filter[0].equals("5") || filter[0].equals("6")) {
            /*----------connect----------*/
            rs = pstmt.executeQuery();
            out.println("<table style='background-color: rgba(255,255,255,0.3);' class='table' border='2'>");
            ResultSetMetaData rsmd = rs.getMetaData();
            cnt = rsmd.getColumnCount();
            for(int i =1;i<=cnt;i++){
                out.println("<th>"+rsmd.getColumnName(i)+"</th>");
            }
            while(rs.next()){
                out.println("<tr>");

                if(filter[0].equals("1") || filter[0].equals("2")) {
                    out.println("<td>"+rs.getString(1)+"</td>");
                    out.println("<td>"+rs.getDate(2)+"</td>");
                    out.println("<td>"+rs.getString(3)+"</td>");
                    switch(rs.getString(4)){
                        case "0" : state = "입금";
                            break;
                        case "1": state = "송금";
                            break;
                    }
                    out.println("<td>"+state+"</td>");
                    out.println("<td>"+rs.getInt(5)+"</td>");
                    out.println("<td>"+rs.getString(6)+"</td>");
                    out.println("<td>"+rs.getString(7)+"</td>");
                    out.println("<td>"+rs.getString(8)+"</td>");
                    out.println("<td>"+rs.getString(9)+"</td>");
                    out.println("</tr>");
                } else if(filter[0].equals("5")) {
                    out.println("<td>"+rs.getDate(1)+"</td>");
                    out.println("<td>"+rs.getInt(2)+"</td>");
                    out.println("<td>"+rs.getString(3)+"</td>");
                    out.println("</tr>");

                } else if(filter[0].equals("6")) {
                    out.println("<td>"+rs.getInt(1)+"</td>");
                    out.println("<td>"+rs.getString(2)+"</td>");
                    out.println("<td>"+rs.getDate(3)+"</td>");
                    out.println("<td>"+rs.getInt(4)+"</td>");
                    out.println("</tr>");
                }
            }
            out.println("</table>");
            rs.close();
            pstmt.close();
            conn.close();
        }


        if(filter[0].equals("3") || filter[0].equals("4") ) {
            out.print("<style>" +
                    "html{" +
                    "background-image: linear-gradient(rgba(239,239,239,0.5), rgba(239,239,239,0.5)), url('https://immigrantinvest.com/wp-content/uploads/2022/03/best-banks-2021-40543452.jpg');" +
                    "background-repeat: no-repeat;" +
                    "background-size: cover;" +
                    "background-position: center center;" +
                    "min-width: 100%;" +
                    "  min-height: 100%;" +
                    "}" +
                    "button {" +
                    "margin: 15px;" +
                    "}" +
                    "body {" +
                    " background-color: rgba(255,255,255,0.6);" +
                    "}" +
                    "* {" +
                    "text-align:center;" +
                    "}" +
                    "</style>");
        }

        if(filter[0].equals("1") || filter[0].equals("2") || filter[0].equals("5") || filter[0].equals("6") ) {
            out.print("<style>" +
                    "html{" +
                    "background-image: linear-gradient(rgba(239,239,239,0.5), rgba(239,239,239,0.5)), url('https://immigrantinvest.com/wp-content/uploads/2022/03/best-banks-2021-40543452.jpg');" +
                    "background-repeat: no-repeat;" +
                    "background-size: cover;" +
                    "background-position: center center;" +
                    "min-width: 100%;" +
                    "  min-height: 100%;" +
                    "}" +
                    "button {" +
                    "margin: 15px;" +
                    "}" +
                    "body {" +
                    " background-color: rgba(255,255,255,0.3);" +
                    "}" +
                    "* {" +
                    "text-align:center;" +
                    "}" +
                    "</style>");
        }
    %>
</div>

<div class="work">

    <form name="permission" method="post">
        &nbsp;&nbsp;
        <button class="btn btn-warning" name="button" onclick="javascript: form.action='SecondMenu.html';" value=1><h4>이전 단계</h4></button>
    </form>

    <div></div>
</div>

</body>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous">

    reloadDivArea(); //함수 실행

    function reloadDivArea() {
        $('#transaction').load(location.href+' #transaction');
    }

</script>
</html>