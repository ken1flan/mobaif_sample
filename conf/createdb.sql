grant all privileges on *.* to mobalog_w@"%";
grant all privileges on *.* to mobalog_w@"localhost";
grant select         on *.* to mobalog_r@"%";
grant select         on *.* to mobalog_r@"localhost";

#---------------------------------------------------------------------
# user db

drop   database if exists mobalog_user;
create database           mobalog_user;
use                       mobalog_user;

create table user_data (
  user_id       int         unsigned not null, # �桼��ID
  reg_date      int         unsigned not null, # ��������
  user_st       tinyint              not null, # �桼�����ơ�����
  serv_st       tinyint              not null, # �����ӥ����ơ�����

  carrier       char(1)              not null, # ����ꥢ ( D | A | V )
  model_name    varchar(20)          not null, # ���ߤε���̾
  subscr_id     varchar(40)                  , # ���֥����饤��ID
  serial_id     varchar(30)                    # SIM������ / ü��ID

) engine=InnoDB;

alter table user_data
 add primary key     (user_id),
 add unique index i1 (subscr_id),
 add unique index i2 (serial_id);

#---------------------------------------------------------------------
# sequence db

drop   database if exists mobalog_seq;
create database           mobalog_seq;
use                       mobalog_seq;

create table seq_user (id int unsigned not null) engine=MyISAM;
insert into  seq_user values (10000);

