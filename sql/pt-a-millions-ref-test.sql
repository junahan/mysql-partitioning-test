
-- 百万级别的表 - 用于做性能参照
-- 复制表
-- create table pt_a_millions_ref as (select * from pt_ten_millions_original limit 1000000);

-- 添加索引
-- ALTER TABLE pt_a_millions_ref
--       ADD INDEX pt_amr_id (id),
-- 			ADD INDEX pt_amr_goods_id (goods_id),
-- 			ADD INDEX pt_amr_in_date (in_date);

-- 统计 in_date 范围
select max(in_date), min(in_date) from pt_a_millions_ref;

-- 统计数据年度分布
select YEAR(in_date), count(1) pt_a_millions_ref group by YEAR(in_date);

-- 统计数据月度分布
select MONTH(in_date), count(1) from pt_a_millions_ref where YEAR(in_date) = '2017' group by MONTH(in_date);

-- 全表扫描
explain select count(goods_name) from pt_a_millions_ref;

select count(goods_name) from pt_a_millions_ref;

-- Left Join
explain select count(t1.goods_name) from pt_a_millions_ref as t1
	left join pt_base_goods as base
	on t1.goods_id = base.goods_id

select count(t1.goods_name) from pt_a_millions_ref as t1
	left join pt_base_goods as base
	on t1.goods_id = base.goods_id
