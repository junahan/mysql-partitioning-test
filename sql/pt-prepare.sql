-- 检查版本号 require > 5.7.0
select @@version;


-- 显示查询缓存设置
show variables like 'query_cache%';

-- 关闭查询缓存
set GLOBAL query_cache_size = 0;
set query_cache_type = off;

show variables like 'query_cache%';
