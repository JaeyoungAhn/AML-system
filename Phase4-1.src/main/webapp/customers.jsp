
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>AML SYSTEM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
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
        body{
            background-color: rgba(255,255,255,0.6);
        }
        * {
            text-align: center;
        }
        .title-text {
            padding: 10px 0;
        }
    </style>
</head>
<body>
    <h2 class="bg-warning title-text">고객 정보 수정</h2>
    <%@ include file="dbconn.jsp" %>
    <%
        Statement stmt = null;
        ResultSet rs;
    %>
    <div>
        <table class="table table-hover border='1'">
            <thead>
            <tr>
                <th scope="col">ID</th>
                <th scope="col">이름</th>
                <th scope="col">성별</th>
                <th scope="col">주소</th>
                <th scope="col">국적</th>
                <th scope="col">연락처</th>
                <th scope="col">계좌번호</th>
                <th scope="col">고객 정보 수정</th>
            </tr>
            </thead>
            <tbody>
            <%
                try {
                    stmt = conn.createStatement();
                } catch (SQLException e1) {
                    e1.printStackTrace();
                }

                String sql = "SELECT H_ID, NAME, SEX, ADDRESS, NATIONALITY, PHONE_NUMBER, ACCOUNT_NUMBER FROM HOLDER NATURAL JOIN ACCOUNT";
                rs = stmt.executeQuery(sql);
                while (rs.next()) {
                    int holderId = rs.getInt(1);
                    String name = rs.getString(2);
                    String gender = rs.getString(3);
                    String address = rs.getString(4);
                    String nationality = rs.getString(5);
                    String contact = rs.getString(6);
                    String accountNumber = rs.getString(7);

                    out.println("<tr>");
                    out.println("<td>" + holderId + "</td>");
                    out.println("<td>" + name + "</td>");
                    out.println("<td>" + gender + "</td>");
                    out.println("<td>" + address + "</td>");
                    out.println("<td>" + nationality + "</td>");
                    out.println("<td>" + contact + "</td>");
                    out.println("<td>" + accountNumber + "</td>");
                    out.println("<td><a class='btn btn-warning' href='formUpsertCustomer.jsp?id=" + holderId + "'>수정하기</a><br/></td>");
                    out.println("</tr>");
                }
            %>
            </tbody>
        </table>
    </div>
</body>
</html>
