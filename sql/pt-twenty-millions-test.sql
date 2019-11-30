-- 2，000 万规模
-- 显示表结构
show create table pt_twenty_millions_original\G;

-- 添加索引
-- ALTER TABLE pt_twenty_millions_original
--       ADD INDEX pt_twmo_id (id),
-- 			ADD INDEX pt_twmo_goods_id(goods_id),
-- 			ADD INDEX pt_twmo_in_date (in_date);

-- 查找 in_date 范围
select max(in_date), min(in_date) from pt_twenty_millions_original;

-- 统计数据年度分布
select YEAR(in_date), count(1) from pt_twenty_millions_original group by YEAR(in_date);

-- 统计数据月度分布
select MONTH(in_date), count(1) from pt_twenty_millions_original where YEAR(in_date) = '2017' group by MONTH(in_date);

-- 复制表
create table pt_twenty_millions_partitioning_test as (select * from pt_twenty_millions_original);
show create table pt_twenty_millions_partitioning_test;

-- 根据数据分布情况创建分区
ALTER TABLE pt_twenty_millions_partitioning_test PARTITION BY RANGE COLUMNS (in_date)
(PARTITION p20161201 VALUES LESS THAN ('2016-12-01') ENGINE = InnoDB,
 PARTITION p20170101 VALUES LESS THAN ('2017-01-01') ENGINE = InnoDB,
 PARTITION p20170104 VALUES LESS THAN ('2017-01-04') ENGINE = InnoDB,
 PARTITION p20170107 VALUES LESS THAN ('2017-01-07') ENGINE = InnoDB,
 PARTITION p20170110 VALUES LESS THAN ('2017-01-10') ENGINE = InnoDB,
 PARTITION p20170113 VALUES LESS THAN ('2017-01-13') ENGINE = InnoDB,
 PARTITION p20170116 VALUES LESS THAN ('2017-01-16') ENGINE = InnoDB,
 PARTITION p20170119 VALUES LESS THAN ('2017-01-19') ENGINE = InnoDB,
 PARTITION p20170122 VALUES LESS THAN ('2017-01-22') ENGINE = InnoDB,
 PARTITION p20170125 VALUES LESS THAN ('2017-01-25') ENGINE = InnoDB,
 PARTITION p20170128 VALUES LESS THAN ('2017-01-28') ENGINE = InnoDB,
 PARTITION p20170201 VALUES LESS THAN ('2017-02-01') ENGINE = InnoDB,
 PARTITION p20170215 VALUES LESS THAN ('2017-02-15') ENGINE = InnoDB,
 PARTITION p20170301 VALUES LESS THAN ('2017-03-01') ENGINE = InnoDB,
 PARTITION p20170315 VALUES LESS THAN ('2017-03-15') ENGINE = InnoDB,
 PARTITION p20170401 VALUES LESS THAN ('2017-04-01') ENGINE = InnoDB,
 PARTITION p20170415 VALUES LESS THAN ('2017-04-15') ENGINE = InnoDB,
 PARTITION p20170501 VALUES LESS THAN ('2017-05-01') ENGINE = InnoDB,
 PARTITION p20170515 VALUES LESS THAN ('2017-05-15') ENGINE = InnoDB,
 PARTITION p20170601 VALUES LESS THAN ('2017-06-01') ENGINE = InnoDB,
 PARTITION p20170615 VALUES LESS THAN ('2017-06-15') ENGINE = InnoDB,
 PARTITION p20170701 VALUES LESS THAN ('2017-07-01') ENGINE = InnoDB,
 PARTITION p20170715 VALUES LESS THAN ('2017-07-15') ENGINE = InnoDB,
 PARTITION p20170801 VALUES LESS THAN ('2017-08-01') ENGINE = InnoDB,
 PARTITION p20170815 VALUES LESS THAN ('2017-08-15') ENGINE = InnoDB,
 PARTITION p20170901 VALUES LESS THAN ('2017-09-01') ENGINE = InnoDB,
 PARTITION p20170915 VALUES LESS THAN ('2017-09-15') ENGINE = InnoDB,
 PARTITION p20171001 VALUES LESS THAN ('2017-10-01') ENGINE = InnoDB,
 PARTITION p20171101 VALUES LESS THAN ('2017-11-01') ENGINE = InnoDB,
 PARTITION p20171201 VALUES LESS THAN ('2017-12-01') ENGINE = InnoDB,
 PARTITION p20180101 VALUES LESS THAN ('2018-01-01') ENGINE = InnoDB,
 PARTITION p20999999 VALUES LESS THAN MAXVALUE ENGINE = InnoDB);

-- 添加索引
ALTER TABLE pt_twenty_millions_partitioning_test
  ADD INDEX pt_twmpt_id (id),
	ADD INDEX pt_twmo_goods_id(goods_id),
	ADD INDEX pt_twmpt_in_date (in_date);

-- CASE - insert test.
-- 从 2017-01-01 开始随机增加天数.
-- select DATE_ADD('2017-01-01', INTERVAL FLOOR(1 + (RAND() * 99)) DAY);

-- 创建存储过程 - original
DELIMITER ;;
DROP PROCEDURE  IF EXISTS insert_pt_twenty_millions_original;
CREATE PROCEDURE insert_pt_twenty_millions_original ()
BEGIN
DECLARE i INT DEFAULT 1;

WHILE i<100
DO
insert into pt_twenty_millions_original values (UNIX_TIMESTAMP(), UNIX_TIMESTAMP(),'test', DATE_ADD('2017-01-01', INTERVAL FLOOR(1 + (RAND() * 99)) DAY));
SET i=i+1;
END WHILE;

commit;
END;;

-- 调用存储过程 - original
call insert_pt_twenty_millions_original;

-- 创建存储过程 - partition table
DELIMITER ;;
DROP PROCEDURE  IF EXISTS insert_pt_twenty_millions_partition;
CREATE PROCEDURE insert_pt_twenty_millions_partition ()
BEGIN
DECLARE i INT DEFAULT 1;

WHILE i<100
DO
insert into pt_twenty_millions_partitioning_test values (UNIX_TIMESTAMP(), UNIX_TIMESTAMP(),'test', DATE_ADD('2017-01-01', INTERVAL FLOOR(1 + (RAND() * 99)) DAY));
SET i=i+1;
END WHILE;

commit;
END;;

-- 调用存储过程 - partition table
call insert_pt_twenty_millions_partition;

-- CASE - 选择约 100 万数据
-- 原始表
explain select count(goods_name) from pt_twenty_millions_original where in_date > '2017-02-01' and in_date < '2017-02-25';

select count(goods_name) from pt_twenty_millions_original where in_date > '2017-02-01' and in_date < '2017-02-25';

-- 分区表
explain select count(goods_name) from pt_twenty_millions_partitioning_test 	where in_date > '2017-02-01' and in_date < '2017-02-25';

select count(goods_name) from pt_twenty_millions_partitioning_test 	where in_date > '2017-02-01' and in_date < '2017-02-25';

-- CASE - 选择约 200 万数据
-- 原始表
explain select count(goods_name) from pt_twenty_millions_original where in_date > '2017-02-01' and in_date < '2017-03-10';

select count(goods_name) from pt_twenty_millions_original where in_date > '2017-02-01' and in_date < '2017-03-10';

-- 分区表
explain select count(goods_name) from pt_twenty_millions_partitioning_test where in_date > '2017-02-01' and in_date < '2017-03-10';

select count(goods_name) from pt_twenty_millions_partitioning_test where in_date > '2017-02-01' and in_date < '2017-03-10';

-- CASE - 选择约 500 万数据
-- 原始表
explain select count(goods_name) from pt_twenty_millions_original where in_date > '2017-02-01' and in_date < '2017-5-01';

select count(goods_name) from pt_twenty_millions_original where in_date > '2017-02-01' and in_date < '2017-5-01';

-- 分区表
explain select count(goods_name) from pt_twenty_millions_partitioning_test where in_date > '2017-02-01' and in_date < '2017-05-01';

select count(goods_name) from pt_twenty_millions_partitioning_test where in_date > '2017-02-01' and in_date < '2017-05-01';

-- CASE - 带 where 子句的 join 查询 + 扫描 100 万数据
-- 原始表
explain select count(t1.goods_name) from pt_twenty_millions_original as t1
	left join pt_base_goods as base
	on t1.goods_id = base.goods_id
	where in_date > '2017-02-01' and in_date < '2017-02-25';

select count(t1.goods_name) from pt_twenty_millions_original as t1
	left join pt_base_goods as base
	on t1.goods_id = base.goods_id
	where in_date > '2017-02-01' and in_date < '2017-02-25';

-- 分区表
explain select count(t1.goods_name) from pt_twenty_millions_partitioning_test as t1
	left join pt_base_goods as base
	on t1.goods_id = base.goods_id
	where in_date > '2017-02-01' and in_date < '2017-02-25';

select count(t1.goods_name) from pt_twenty_millions_partitioning_test as t1
	left join pt_base_goods as base
	on t1.goods_id = base.goods_id
	where in_date > '2017-02-01' and in_date < '2017-02-25';

-- CASE - 全表扫描对比
-- 原始表
explain select count(goods_name) from pt_twenty_millions_original;

select count(goods_name) from pt_twenty_millions_original;

-- 分区表
explain select count(goods_name) from pt_twenty_millions_partitioning_test;

select count(goods_name) from pt_twenty_millions_partitioning_test;
