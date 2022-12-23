<%@ page language="java" contentType="text/html; charset=EUC-KR"
         pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.util.*,java.sql.*,java.security.* " %>
<html>
<head>
    <title>처리 완료되었습니다.</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
</head>
<body>
<%
    int holderId = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("customer-name");
    String gender = request.getParameter("customer-gender");
    String address = request.getParameter("customer-address");
    String nationality = request.getParameter("customer-nationality");
    String contact = request.getParameter("customer-contact");
    String accountPassword = request.getParameter("customer-account-password");
    String accountPassword2 = request.getParameter("customer-account-password2");
    String resultText = null;
    boolean success = false;

    System.out.println(name);
    System.out.println(gender);
    System.out.println(address);
    System.out.println(nationality);
    System.out.println(contact);
    System.out.println(accountPassword);
    System.out.println(accountPassword2);
%>
<%@ include file="dbconn.jsp"%>
<%@ include file="SHA256.jsp"%>
<%
    PreparedStatement pstmt = null;
    Statement stmt = null;
    int cnt;
    ResultSet rs;

%>
<%
    try {
        String contactRegex = "[0-9]{3}-[0-9]{3}-[0-9]{4}";
        if (!contact.matches(contactRegex)) {
            resultText = "연락처를 XXX-XXX-XXXX 형태로 입력해주세요.";
            throw new Exception("contact not matching regular expression.");
        }

        if (!accountPassword.equals(accountPassword2)) {
            resultText = "입력한 두 비밀번호가 맞지 않습니다.";
            throw new Exception("contact not matching regular expression.");
        }
        String sql = "UPDATE HOLDER SET NAME=?, SEX=?, ADDRESS=?, NATIONALITY=?, PHONE_NUMBER=? WHERE H_ID=?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, gender);
        pstmt.setString(3, address);
        pstmt.setString(4, nationality);
        pstmt.setString(5, contact);
        pstmt.setInt(6, holderId);

        int res1;
        res1 = pstmt.executeUpdate();


        String encryptedPassword = "";

        SHA256 sha = new SHA256();
        encryptedPassword = sha.encrypt(accountPassword);

        sql = "UPDATE ACCOUNT SET PASSWORD=? WHERE H_ID=?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, encryptedPassword);
        pstmt.setInt(2, holderId);

        int res2 = pstmt.executeUpdate();


        if (res1 != 1 || res2 != 1) {
            throw new Exception("can't resovle.");
        }
        sql = "select H_ID, NAME, SEX, ADDRESS, NATIONALITY, PHONE_NUMBER " +
                "FROM HOLDER NATURAL JOIN ACCOUNT WHERE H_ID = " + holderId;

        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);

        success = true;

        resultText = "성공적으로 고객 정보와 계좌 비밀번호를 업데이트하였습니다.";
        while(rs.next()) {
            holderId = rs.getInt(1);
            name = rs.getString(2);
            gender = rs.getString(3);
            address = rs.getString(4);
            nationality = rs.getString(5);
            contact = rs.getString(6);
        }
        stmt.close();
        conn.close();
    } catch(SQLException e) {
        resultText = "고객 정보와 계좌를 만드는데 실패하였습니다. 다시 시도해주세요.";
        success = false;
        e.printStackTrace();
    } catch (Exception e) {
        success = false;
        if (stmt != null) {
            stmt.cancel();
        }
        if (pstmt != null) {
            pstmt.cancel();
        }
        e.printStackTrace();
    }
%>
<h1 class="result-text"><%=resultText%></h1>
<%
    if (success) {
%>
<div class="result-box">
    <h2>고객 db ID: <%=holderId%></h2>
    <h2>고객 이름: <%=name%></h2>
    <h2>고객 성별: <%=gender%></h2>
    <h2>고객 주소: <%=address%></h2>
    <h2>고객 국적: <%=nationality%></h2>
    <h2>고객 연락처: <%=contact%></h2>
    <%
        }
    %>
</div>
<div class="m-4">
    <div class="col mb-3" name="title">
        <a class="btn btn-warning" href="ThirdMenu.html"><h5>이전 단계로 돌아가기</h5></a>
    </div>
    <div class="col" name="title">
        <a class="btn btn-warning" href="customers.jsp"><h5>추가 고객 수정하기</h5></a>
    </div>
</div>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
</body>
</html>
