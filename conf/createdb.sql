----------------------------------------------------------------------
-- user

drop user if exists "mobalog_w"@"%";
drop user if exists "mobalog_w"@"localhost";
drop user if exists "mobalog_r"@"%";
drop user if exists "mobalog_r"@"localhost";
create user "mobalog_w"@"%" identified by "password";
create user "mobalog_w"@"localhost" identified by "password";
create user "mobalog_r"@"%" identified by "password";
create user "mobalog_r"@"localhost" identified by "password";
grant all privileges on *.* to mobalog_w@"%";
grant all privileges on *.* to mobalog_w@"localhost";
grant select         on *.* to mobalog_r@"%";
grant select         on *.* to mobalog_r@"localhost";

----------------------------------------------------------------------
-- user db

drop   database if exists mobalog_user;
create database           mobalog_user;
use                       mobalog_user;

create table user_data (
  user_id       int         unsigned not null auto_increment, # �桼��ID
  reg_date      int         unsigned not null, # ��������
  user_st       tinyint              not null, # �桼�����ơ�����
  serv_st       tinyint              not null, # �����ӥ����ơ�����

  carrier       char(1)              not null, # ����ꥢ ( D | A | V )
  model_name    varchar(20)          not null, # ���ߤε���̾
  subscr_id     varchar(40)                  , # ���֥����饤��ID
  serial_id     varchar(30)                  , # SIM������ / ü��ID

  email         varchar(256)         not null, # �᡼�륢�ɥ쥹
  nickname      varchar(20)          not null, # �˥å��͡���
  introduction  varchar(256)                 , # ���ʾҲ�

  primary key(user_id)
) engine=InnoDB;

alter table user_data
 add unique index i1 (subscr_id),
 add unique index i2 (serial_id);
