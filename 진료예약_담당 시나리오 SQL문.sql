
###### 담당 시나리오 부분 SQL

# '이건희' 사용자 로그인
# 사용자 계정 '건희123'과 패스워드 'QWE3324'를 입력했을때 조회되는 정보
select *
from `user` u 
where u.user_acc LIKE '건희123'
and u.password LIKE 'QWE3324';

# 로그인 상태 변경 (비로그인 -> 로그인)
update `user` 
set user_login = 'Y'
where u.user_acc LIKE '건희123';


# 진료 과목 보여주기 
# 병원이지만에서 운영하는 진료 과목 전체 리스트(진료과목고유번호, 진료과목명) 보여주기
select D.DEPARTMENT_ID ,D.DEPARTMENT_NAME 
from department d ;

# 진료 과목 선택 
# 진료과목고유번호 5번(정신과)로 사용자가 잘못 예약한 스토리
select DEPARTMENT_NAME 
from department d 
where DEPARTMENT_ID = 5;


# 예약 날짜 선택
# 사용자가 2024-01-12로 날짜를 픽스하기 원함
select *
from reservation r 
where RESERVE_DATE = to_char('2024-01-12','yyyy-mm-dd');



# 사용자가 원하는 2024-01-12에 예약이 가능한 시간대/의사 조회
# 이건희 환자가 2024-01-12 , 9-10시, 예약 가능 의사 ID = 3 (Dr.동혁)으로 선택
select  t.TIMETABLE_NAME as "예약 가능 시간", m.MASTER_ID as "예약 가능 의사ID"
from timetable t , master m , reservation r 
where r.TIMETABLE_ID = t.TIMETABLE_ID 
and m.MASTER_ID = r.MASTER_ID 
and r.RESERVE_DATE = '2024-01-12';



# 선택 가능한 시간대/의사 조회 후 원하는 의사의 예약날짜의 시간대의 예약 가능 상태 'N'으로 변경
# 이건희 환자가 2024-01-12 , 9-10시, 예약 가능 의사 ID = 3 (Dr.동혁)으로 선택
update timetable t ,reservation r
set t.TIMETABLE_STATUS = 'N',
r.master_id = 3,
r.timetable_id = 1
where t.TIMETABLE_ID = r.timetable_id
and r.RESERVE_DATE = to_char('2024-01-12','yyyy-mm-dd');








# 예약 번호 확인 
select r.RESERVE_ID, u.user_name 
from reservation r ,`user` u 
where r.USER_ID = u.USER_ID 
and u.user_name like '이건희';


# 사용자(이건희)님의 예약 정보 조회
# 예약 번호 6번, 담당의 3번, 사용자 고유번호 24번, 예약날짜 2024-01-12, 예약시간 1번(9-10시), 등
select *
from reservation r ,`user` u 
where r.USER_ID = u.user_id 
and u.user_name like '이건희';



# 담당의가 정신과 의사인걸 알게 됨
select * 
from master m ,department d 
where m.DEPARTMENT_ID = d.DEPARTMENT_ID 
and m.MASTER_ID  = 3;



# 예약정보조회에 진료과목까지 조회 
# 예약 번호 6번, 사용자(환자)이름, 예약 진료 과목, 예약한 담당의 조회
select r.RESERVE_ID ,u.user_name ,d.DEPARTMENT_NAME ,m.MASTER_ACC , m.MASTER_ID 
from reservation r ,`user` u ,department d ,master m 
where u.user_name like '이건희'
and r.USER_ID = u.user_id 
and d.DEPARTMENT_ID = m.DEPARTMENT_ID 
and r.MASTER_ID = m.MASTER_ID ;


##################### 정신과 -> 내과로 예약 재변경 과정 ######################

############# reservation에 내과 진료 가능한 데이터가 없어서 추가함
Insert into reservation(master_id,user_id,reserve_date,timetable_id)
values(21,24,'2024-01-12',1);
######################################################################

# 동일 날짜에 예약 가능 시간대 / 내과 의사 확인
select r.RESERVE_DATE , t.TIMETABLE_NAME 
from reservation r ,department d , timetable t 
where d.DEPARTMENT_NAME like '내과'
and t.TIMETABLE_STATUS like 'y'
and to_char(r.RESERVE_DATE,'yyyy-mm-dd') = '2024-01-12';


# 예약 변경  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# 바로 전 쿼리에서 조회한 결과에 따라 1개 선택해서 
# 시간, 진료 과목 예약 변경
# 예약 변경 후 , 예약 가능 상태 변경
# 바꿀 시간대, 

# 2024-01-12 예약 가능한 내과 진료의 조회
select m.MASTER_ID ,m.DEPARTMENT_ID ,m.MASTER_ACC , t.TIMETABLE_NAME , t.TIMETABLE_STATUS 
from reservation r ,master m , department d ,timetable t 
where d.DEPARTMENT_NAME like '내과'
and to_char(r.RESERVE_DATE,'yyyy-mm-dd') like '2024-01-12'
and r.MASTER_ID = m.MASTER_ID 
and m.DEPARTMENT_ID = d.DEPARTMENT_ID 
and r.TIMETABLE_ID = t.TIMETABLE_ID 
and t.TIMETABLE_STATUS like 'y';


# 진료과목 변경(정신과 -> 내과)
update reservation r , `user` u
set r.MASTER_ID  = 21  # 21번 담당의의 진료과목이 내과라서 21번 선택
where u.user_id = 24
and r.USER_ID = u.user_id
and to_char(r.RESERVE_DATE,'yyyy-mm-dd') = '2024-01-12'; 


# 시간대 변경 (사용자 고유번호 24번인 이건희씨가 2024-01-12, 16~17시로 예약 시간 변경 후 예약가능상태 'N'으로 변경)
update timetable t , reservation r
set r.TIMETABLE_NAME = '16~17',r.timetable_id = 7, t.TIMETABLE_STATUS like 'N'
where to_char(r.RESERVE_DATE,'yyyy-mm-dd') = '2024-01-12'
and t.TIMETABLE_ID = r.timetable_id
and r.user_id = 24
and r.master_id = 21;


# 예약 변경 완료 후, 로그아웃(비로그인으로 상태 변경)  
update `user` 
set user_login = 'N'
where user_id = 24;





# 승환님 담당 재고 개수 변경 SQL문 같이 고민해본것


# A) 모든 처방에 따른 재고 개수 변경(여러 처방을 바탕으로 한번에 여러 재고의 개수를 변경하는 것)
update stock_management s, treatment t
set s.stock_remnants = (s.stock_remnants - 1)
where t.stock_id = s.stock_id;

# B) 사용자(환자) 이건희 처방에 따른 해당하는 재고 개수만 변경 (stock_id = 6인것만 차감)
update stock_management s, treatment t, user u
set s.stock_remnants = (s.stock_remnants - 1)
where s.stock_id = t.stock_id
and u.user_id = 24
and t.user_id = u.user_id;



