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
  user_id       int         unsigned not null, # ユーザID
  reg_date      int         unsigned not null, # 入会日時
  user_st       tinyint              not null, # ユーザステータス
  serv_st       tinyint              not null, # サービスステータス

  carrier       char(1)              not null, # キャリア ( D | A | V )
  model_name    varchar(20)          not null, # 現在の機種名
  subscr_id     varchar(40)                  , # サブスクライバID
  serial_id     varchar(30)                    # SIMカード / 端末ID

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

create table seq_user (id int unsigned not null) type=MyISAM;
insert into  seq_user values (10000);

