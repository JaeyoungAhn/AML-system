<%@ page language="java" contentType="text/html; charset=EUC-KR"
         pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>고객 및 계좌 생성</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
</head>
<body>
<%@ include file="dbconn.jsp"%>
<%
    ResultSet rs = null;
    Statement stmt = null;
    String sql = "";
%>
<%
    boolean isUpdating = true;
    String holderId = request.getParameter("id");
    if (holderId == null) {
        isUpdating = false;
    }

    String name = "";
    String gender = "";
    String address = "";
    String nationality = "";
    String contact = "";

    if (isUpdating) {
        sql = "select H.NAME, H.SEX, H.ADDRESS, H.NATIONALITY, H.PHONE_NUMBER FROM HOLDER H WHERE H.H_ID=" + holderId;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);

        while (rs.next()) {
            name = rs.getString(1);
            gender = rs.getString(2);
            address = rs.getString(3);
            nationality = rs.getString(4);
            contact = rs.getString(5);
        }

        rs.close();
        stmt.close();
    }
%>
<%
    String actionFile = isUpdating ? "updateCustomerAndAccount.jsp?id=" + holderId  : "createCustomerAndAccount.jsp";
%>
<div class="customer-info">
    <form action="<%=actionFile%>" method="post">
        <div class="mb-3">
            <h4>
                <label for="customer-name" class="form-label">고객 이름</label>
            </h4>
            <input type="text" class="form-control" id="customer-name" name="customer-name"  value="<%=name%>" required>
        </div>
        <div class="mb-3">
            <h4>
               성별
            </h4>
                <%
                    if (gender == "Female") {
                        out.println("<div class='form-check'>");
                        out.println("<input class='form-check-input' type='radio' name='customer-gender' id='male' value='Male'>");
                        out.println("<label class='form-check-label' for='male'>남성</label>");
                        out.println("</div>");
                        out.println("<div class='form-check'>");
                        out.println("<input class='form-check-input' type='radio' name='customer-gender' id='female' value='Female' checked>");
                        out.println("<label class='form-check-label' for='female'>여성</label>");
                        out.println("</div>");
                    } else if (gender == "Male") {
                        out.println("<div class='form-check'>");
                        out.println("<input class='form-check-input' type='radio' name='customer-gender' id='male' value='Male' checked>");
                        out.println("<label class='form-check-label' for='male'>남성</label>");
                        out.println("</div>");
                        out.println("<div class='form-check'>");
                        out.println("<input class='form-check-input' type='radio' name='customer-gender' id='female' value='Female'>");
                        out.println("<label class='form-check-label' for='female'>여성</label>");
                        out.println("</div>");
                    } else {
                        out.println("<div class='form-check'>");
                        out.println("<input class='form-check-input' type='radio' name='customer-gender' id='male' value='Male'>");
                        out.println("<label class='form-check-label' for='male'>남성</label>");
                        out.println("</div>");
                        out.println("<div class='form-check'>");
                        out.println("<input class='form-check-input' type='radio' name='customer-gender' id='female' value='Female'>");
                        out.println("<label class='form-check-label' for='female'>여성</label>");
                        out.println("</div>");
                    }
                %>
        </div>
        <div class="mb-3">
            <h4>
                <label for="customer-address" class="form-label">주소</label>
            </h4>
            <input type="text" class="form-control" id="customer-address" name="customer-address" value="<%=address%>" required>
        </div>
        <div class="mb-3">
            <h4>
                <label for="customer-nationality" class="form-label">국적</label>
            </h4>
            <select id="customer-nationality" class="form-select" name="customer-nationality">
                <%
                    if (nationality == "") {
                        out.println("<option selected disabled>아래 국가 중 하나를 선택하세요.</option>");
                    } else {
                        out.println("<option disabled>아래 국가 중 하나를 선택하세요.</option>");
                    }
                %>
                <%
                    stmt = conn.createStatement();
                    sql = "SELECT NAME FROM COUNTRY_CREDIT";
                    rs = stmt.executeQuery(sql);

                    while(rs.next()) {
                        String countryName = rs.getString(1);
                        if (countryName == nationality) {
                            out.println("<option selected value='" + countryName + "'>" + countryName + "</option>");
                        } else {
                            out.println("<option value='" + countryName + "'>" + countryName + "</option>");
                        }
                    }
                    rs.close();
                    stmt.close();
                %>
            </select>
        </div>
        <div class="mb-3">
            <h4>
                <label for="customer-contact" class="form-label">연락처 ('-' 포함하여 입력해주세요.)</label>
            </h4>
            <input type="text" name="customer-contact" class="form-control" id="customer-contact" value="<%=contact%>" required>
        </div>
        <div class="mb-3">
            <h4>
                <label for="customer-account-password" class="form-label">신규 계좌 비밀번호</label>
            </h4>
            <input type="password" value="" class="form-control" id="customer-account-password" name="customer-account-password" required>
        </div>
        <div class="mb-3">
            <h4>
                <label for="customer-account-password2" class="form-label">계좌 비밀번호 확인</label>
            </h4>
            <input type="password" value="" class="form-control" id="customer-account-password2" name="customer-account-password2" required>
        </div>
        <button type="submit" class="btn btn-warning"><%= isUpdating ? "고객 정보 수정" : "고객 정보 생성" %></button>
    </form>
</div>
</body>
<style>
    .customer-info {
        /*display: flex;*/
        /*align-items: center;*/
        /*justify-content: center;*/
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
</html>