
# 1. 로그인
select *
from `user` u 
where u.user_acc LIKE '건희123'
and u.password LIKE 'QWE3324';


# 2. 로그인 상태 변경
update `user` 
set user_login = 'Y'
where user_acc LIKE '건희123';


#3. 예약 진행
# 3-1 병원 내 진료과목 조회
select d.department_id, d.DEPARTMENT_NAME 
from department d ;


# 3-2 예약 날짜 선택
select *
from reservation r 
where RESERVE_DATE = to_char('2024-01-12','yyyy-mm-dd');

# 3-3 예약 가능한 시간/의사선택
select  t.TIMETABLE_NAME as "예약 가능 시간", m.MASTER_ID as "예약 가능 의사ID"
from timetable t , master m , reservation r 
where r.TIMETABLE_ID = t.TIMETABLE_ID 
and m.MASTER_ID = r.MASTER_ID 
and r.RESERVE_DATE = '2024-01-12';



# 3-4 정신과에 예약된 모든 환자 리스트 조회
select u.user_id , u.user_name , d.DEPARTMENT_ID, d.DEPARTMENT_NAME , r.RESERVE_DATE 
from reservation r, master m, timetable t , department d , `user` u 
where r.TIMETABLE_ID = t.TIMETABLE_ID 
and m.MASTER_ID = r.MASTER_ID 
and m.DEPARTMENT_ID = d.DEPARTMENT_ID 
and u.user_id = r.USER_ID ;


# 3-5 이건희 환자의 진료 2024-01-12 예약 조회(정신과)
select u.user_id , u.user_name , d.DEPARTMENT_ID, d.DEPARTMENT_NAME , r.RESERVE_DATE 
from reservation r, master m, timetable t , department d , `user` u 
where r.TIMETABLE_ID = t.TIMETABLE_ID 
and m.MASTER_ID = r.MASTER_ID 
and m.DEPARTMENT_ID = d.DEPARTMENT_ID 
and u.user_id = r.USER_ID 
and u.user_id = 24;

# 3-5 예약한 시간대의 예약 가능 상태 변경 (Y→N)
# 2024-01-12의 timetable_id = 1의 예약 가능 상태로 변경

update timetable 
set TIMETABLE_STATUS = 'N'
where TIMETABLE_ID = 1;


# 4-1 예약 확인( 이건희 환자의 예약 조회)
select r.RESERVE_ID , u.user_id , u.user_name ,r.RESERVE_DATE ,d.DEPARTMENT_NAME 
from `user` u ,master m ,reservation r ,department d 
where r.MASTER_ID =m.MASTER_ID 
and r.MASTER_ID =d.DEPARTMENT_ID 
and r.USER_ID =u.user_id 
and u.user_id  = 24;

# 이건희 환자가 실수로 정신과에 예약한 걸 알게됨
# 5 . 예약 변경
# 5-1. 예약 가능한 내과의 시간대와 의사 조회
select r.RESERVE_DATE ,t.TIMETABLE_NAME 
from reservation r ,department d ,timetable t 
where d.DEPARTMENT_NAME  like '내과'
and t.TIMETABLE_STATUS  like 'y'
and to_char(r.RESERVE_DATE,'yyyy-mm-dd') = '2024-01-12';


# 5-2 원하는 시간대로 진료 과목 예약 변경(정신과 -> 내과)
update reservation 
set MASTER_ID = 21 , RESERVE_DATE ='2024-01-12' 
where RESERVE_ID = 7;



# 5-3. 예약 시간 변경
update reservation r 
set timetable_id = 7 
where reserve_id = 7;


#5-4. 예약 상태 변경
update timetable 
set TIMETABLE_STATUS = 'N'
where TIMETABLE_ID = 1;

# 5-5. 변경 완료한 사용자의 예약 내역 조회
select r.RESERVE_ID , u.user_id , u.user_name , u.gender, r.RESERVE_DATE 
from reservation r , `user` u 
where r.USER_ID = u.user_id 
and u.user_id = 24;

# 6. 처방
# 6-1. 이건희 환자의 진단 내역 조회
select u.user_name , d.DIA_HISTORY , d.DIA_DATE 
from `user` u , treatment t , diagnosis d 
where u.user_id = d.USER_ID 
and t.TREATMENT_ID  = d.TREATMENT_ID 
and u.user_id = 24;

# 6-2 갑상선약 재고 수 확인
select sm.STOCK_REMNANTS ,sm.STOCK_NAME 
from stock_management sm 
where STOCK_ID = 6;

# 7. 결제
# 7-1 이건희 환자의 전체 진료 수납 내역 및 총 수납액 조회
select u.user_name , sum(p.PAYMENT_BALANCE)  as '총 수납액',
count(p.PAYMENT_ID) as '수납 내역'
from `user` u , payment p , diagnosis d 
where u.user_id = p.USER_ID
and d.TREATMENT_ID = p.TREATMENT_ID 
and u.user_id = 24
group by u.user_name;

# 8 재고 관리
# 8-1 이건희 환자에게 제공한 갑상선약 차감
update stock_management s, treatment t , user u
set s.STOCK_REMNANTS = (s.stock_remnants - 1)
where s.stock_id = t.stock_id
and t.user_id = u.user_id
and u.user_id = 24;


select r.RESERVE_ID , u.user_id , u.user_name ,r.RESERVE_DATE ,d.DEPARTMENT_NAME 
from `user` u ,master m ,reservation r ,department d 
where r.MASTER_ID =m.MASTER_ID 
and r.MASTER_ID =d.DEPARTMENT_ID 
and r.USER_ID =u.user_id 
and u.user_id  = 24

