# AML-system
![Uploading image.jpg...](/Presentation/1.png)
![Uploading image.jpg...](/Presentation/2.png)
![Uploading image.jpg...](/Presentation/3.png)
![Uploading image.jpg...](/Presentation/4.png)
![Uploading image.jpg...](/Presentation/5.png)
![Uploading image.jpg...](/Presentation/6.png)
![Uploading image.jpg...](/Presentation/7.png)
![Uploading image.jpg...](/Presentation/8.png)
![Uploading image.jpg...](/Presentation/9.png)
![Uploading image.jpg...](/Presentation/10.png)
![Uploading image.jpg...](/Presentation/11.png)
![Uploading image.jpg...](/Presentation/12.png)

## (1) 웹서비스 시작 전, Trigger 실행  

  trigger.sql 파일을 SQL PLUS 또는 SQL Developer에서 컴파일합니다.(프로시저 2개와 트리거 1개, 총 3개가 컴파일 됨.)  
  
  다음 구문을 실행합니다.  
  ALTER TRIGGER TXN_ALERT ENABLE;   
  SET SERVEROUTPUT ON;  
    
  **트리거 관련 주의사항  
    
  Trigger를 개발하는 과정에서, TRANSACTION TABLE에 추가 컬럼이 필요하여 생성하였습니다. 관련 사항은 아래에서 기술하겠습니다.  
  웹사이트에서 거래를 추가하는 부분은 구현되어있지 않아 트리거를 테스트하고 싶다면 번거롭지만 다음과 같은 작업을 진행해야 합니다.  
    
  TRANSACTION TABLE에 DATA를 INSERT 하기 전, DNG_TXN 테이블의 FOREIGN KEY CONSTRAINT 비활성화(ALTER TABLE DNG_TXN DISABLE CONSTRAINT SYS_C007781;)를 해야합니다.   INSERT 이후 다시 활성화(ALTER TABLE DNG_TXN ENABLE CONSTRAINT SYS_C007781;)하면 됩니다.   
   

## (2) 실행 방법
  Phase2-1.Schema (DDL), Phase2-2.Insert (INSERT문)  
  두 개의 파일을 SQL Developer에서 각각 열어 순차적으로 스크립트를 실행합니다.  
    
  실행 주의 사항:  
  DNG_TXN 테이블에 INSERT를 진행하기전  
  반드시 SET DEFINE OFF; 문장을 먼저 실행하여야 합니다.  
  (데이터 내 &기호를 변수가 아닌 데이터로 사용하기 위함)  
    
  eclipse 상에서 ojdbc8.jar를 라이브러리로 추가해 드라이버를 불러와야합니다.  
  
  phase4-1.src 프로젝트 전체를 eclipse 상에서 프로젝트 열기를 합니다.  
  eclipse 상에서 oracle DB와 tomcat 환경 셋업을 합니다.  
  oracle DB을 작동시킨 상태에서 tomcat 서버 가동을 합니다.  
  
  클라이언트는 http://서버ip:포트번호/webapp/main.html를 통해 웹서비스에 접속합니다.  
  
## (3) 실행 주의 사항
  기존 Phase 2의 스키마와 데이터가 DB상에 추가되어있어야합니다.  
  oracle DB 환경을 셋업할 때 eclipse 상에서 ojdbc8.jar를 라이브러리로 추가해 드라이버를 불러와야합니다.  
  
  서버 가동시 src/main/webapp/dbconn.jsp 파일안에 아래 내용을 실행하는 시스템의 DB 환경에 맞게 바꿔주어야 합니다.  
  String serverIP = "localhost";  
  String strSID = "xe"; // orcl 또는 xe  
  String portNum = "1152"; // DB 포트 번호   
  String user = "db8"; // DB 유저명  
  String pass = "db8"; // DB 패스워드  
  

## (4) 유즈 케이스
  클라이언트는 AML(Anti-money laundering, 자금 세탁 방지), 위험 관리, 고객 정보 추가 및 수정 등에 관련된 기능들을 수행할 수 있습니다.  
   
  초기화면으로 간단한 인사 문구와 함께 AML 업무 수행, 위험 관리, 고객 정보 추가 및 수정을 위한 상세 페이지에 접근하기 위한 버튼이 있습니다.  
  각각 상세 페이지에는 이전 단계로 되돌아 갈 수 있는 버튼이 있습니다.  
    
### AML 업무  

    페이지에 들어가면 제일 먼저 위험 의심 거래 목록들을 보여줍니다.
    담당자는 위험 의심 거래들을 살펴보고 원하는 경우 심사가 필요한 거래 또는 위험도 점수 순으로 정렬하여 목록을 확인할 수도 있습니다.
    거래 중 처리하고자 하는 거래번호를 입력하고 다음으로 진행할 작업을 선택합니다.
    모든 위험 의심 거래들은 거부될 수도 있고, 허용 될 수도 있고, 금융 당국에 보고 될 수도 있습니다.
    위험 거래를 금융 당국에 보고하는 경우, 입력 창에 해당 거래에 대해 보고 사유를 작성하고 제출합니다.
      
### 위험 관리  

    위험 인물 거래 조회, 위험 계좌 거래 조회, 기간별 개인정보를 제외한 거래 정보 조회, 특정 금액 이상 거래 고객 조회, 총 네 가지 기능이 있습니다.
    위험 인물 거래 또는 위험 계좌 거래 조회 버튼을 클릭한 경우, 각각 거래 상대방 또는 상대방 계좌가 위험 인물 리스트나 위험 계좌 리스트에 있는 경우에 대해 조회합니다.
    기간별 개인정보를 제외한 거래 정보 조회를 선택한 경우에는 시작일과 종료일 날짜를 입력하여 해당 기간 사이에 일어난 거래의 정보를 조회합니다.
    특정 금액 이상 거래 고객 조회를 원하는 경우, 금액을 입력할 수 있는 입력창이 나오고 금액을 입력하고 버튼을 누르면 특정 금액 이상의 거래에 대해서만 조회합니다.
    
### 고객 정보 추가 및 수정  

    고객 및 계좌 등록, 고객 정보 수정 총 두가지 기능이 있습니다.  
    고객 및 계좌 등록을 선택한 경우 한 페이지에서 신규 고객에 대한 정보와 계좌 비밀번호를 입력할 수 있고 생성 버튼을 눌러 고객과 계좌를 생성합니다. 신규 계좌 번호는 시스템에서 자동으로 생성합니다.
    고객 정보 수정을 클릭한 경우, 모든 고객 정보를 조회할 수 있는 페이지로 이동합니다. 수정하기 버튼을 통해 변경하고싶은 고객을 선택한 후 입력창에 변경할 고객의 새로운 정보를 입력하여 최종 수정합니다.
  
## (5) 파일별 
### main.html: 홈페이지로 AML, 위험 관리, 고객 정보 추가 및 수정에 관련된 버튼이 있습니다.  
### dbconn.jsp: 데이터베이스 연결 관련 코드입니다.  
### SHA256.jsp: 계좌 비밀번호 암호화 관련 코드입니다.  
---
### FirstMenu.jsp: 위험 거래를 보여주고, 특정 거래에 대해 허용, 거부, 금융당국에 보고를 위한 버튼이 있습니다.  
#### permission.jsp: 특정 거래를 허용 또는 거부하고 나서의 결과 페이지입니다.  
#### Report.jsp: 금융당국에 보고하기 위해 사유를 입력하는 창입니다.  
###### result.jsp: 금융당국에 보고한 후 처리를 위한 페이지입니다.  
---
### SecondMenu.html: 위험 인물 거래 조회, 위험 계좌 거래 조회, 기간별 거래 조회, 특정 금액 이상 거래 조회를 위한 버튼이 있습니다.   
#### riskManagement.jsp: 위험 인물 거래 조회, 위험 계좌 거래 조회, 기간별 거래 조회, 특정 금액 이상 거래 조회 기능 네가지를 한번에 처리합니다.  
---
### ThirdMenu.html: 고객 및 계좌 등록, 고객 정보 수정을 위한 페이지입니다.  
#### formUpsertCustomer.jsp: 신규 고객 및 계좌 등록 또는 고객 정보 수정을 위한 페이지입니다.  
#### createCustomerAndAccount.jsp: formUpsertCustomer.jsp에서 새로 데이터를 생성한 후 보여주는 결과 페이지입니다.  
#### updateCustomerAndAccount.jsp: formUpsertCustomer.jsp에서 정보를 수정하고 보여주는 결과 페이지입니다.  
#### customers.jsp: 고객 정보 수정을 위해 고객 정보를 보여주는 페이지입니다.  
---
  
## (6) Application 제작 환경
  IntelliJ 버전: 2022.2.3 빌드: 222.4345.14  
  Eclipse IDE for Enterprise Java and Web Developers 버전: 2021-09 (4.21.0)  
  Arm64 MacBook 21.6.0 Darwin Kernel Version 21.6.0  
  colima version 0.4.6  
  Docker version 20.10.17  
  gvenzl/oracle-xe  
  Oracle Database 21c Express Edition Release 21.0.0.0.0 - Production  
  Version 21.3.0.0.0  
  ORACLE SQL Developer 22.2.1  
