# 按天分组，查询某些列的汇总数据
select day(action_time), sum(money)
from order_record
group by day(action_time);

# 按月分组，查询某些列的汇总数据 
select month(action_time), sum(money)
from order_record
group by month(action_time);

# 按年分组，查询某些列的汇总数据
select year(action_time), sum(money)
from order_record
group by year(action_time);

# 上面的按天分组，是建立在统计一个自然月之内的数据的情况下适用。如果要跨越多个月，就用同时按照（月，日）分组，如果表内的数据是括月多年的，还要按照（年，月，日）分组。
select year(action_time), month(action_time), day(action_time), sum(money)
from order_record
group by year(action_time), month(action_time), day(action_time);

# 上面的sql多次调用year()，month()，day()函数，重复计算，十分浪费。事实上（年，月，日）三元组本身可以用date函数来获得，上面的sql可以简写为
select date(action_time), sum(money)
from order_record
group by date(action_time);

# 查询本年度的数据
select * 
from order_record
where year(action_time) = year(now());

# 查询本季度的数据
select * 
from order_record
where year(action_time) = year(now()) and quarter(action_time) = quarter(now());

# 查询本月份的数据
select * 
from order_record
where year(action_time) = year(now()) and month(action_time) = month(now());

# 查询本周的数据，week函数返回的是指定时间在当年的第几周，所以不需要指定月份
select * 
from order_record
where year(action_time) = year(now()) and week(action_time) = week(now());

# 查询今天的数据
select * 
from order_record
where date(action_time) = date(now());

# 查出今天之前200天内的订单
select * 
from order_1 
where to_days(now()) - to_days(create_time) < 200; 

# 查出指定某天前后2天内的订单，注意，因为是‘前后’，所以相减得到的数可能是正数，也可能是负数，和2比较时，要用abs函数，否则-10，-100之类的数都会因小于2而进入结果集中
select * 
from order_1 
where abs(to_days("2015-09-02 00:00:00") - to_days(create_time)) <= 2;

# 查出过去一周内的订单。这个过去一周，精确到7天0小时0分钟前之后，比起to_days函数，多了时分秒的精确度
select * 
from order_1 
where create_time > date_sub(now(), interval 7 day);

# 查询过去1个月内的订单
select * 
from order_1 
where create_time > date_sub(now(), interval 1 month);

# 查询每年的9月1日至9月3日的订单
select * 
from order_1 
where date_format(create_time, "%m-%d") between "09-01" and "09-03";

# 查询每年的双11订单总交易额，按照年份分组
select year(create_time), sum(money) 
from order_1 
where date_format(create_time, "%m-%d") = "11-11" 
group by year(create_time); 

# 查询每年的9月2日的订单总额，按照年份分组
select year(create_time), sum(pay_realmoney) 
from order_1 
where date_format(create_time, "%m-%d") ="09-02" 
group by year(create_time); 

# 查询每个月2日的订单总金额，按照年月日分组
select date_format(create_time, "%Y-%m-%d"), sum(pay_realmoney) 
from order_1 
where date_format(create_time, "%d") = "02" 
group by date_format(create_time, "%Y-%m") ; 

# 根据一个数字分组，连续的若干个被分为一组
select floor((date_format(create_time, "%d") + 6) / 7), sum(pay_realmoney) 
from order_1 
group by floor((date_format(create_time, "%d") + 6) / 7); 

# 这里有一个技巧，加入要对列num分组，连续的7个分为1组，即1-7分为1组，8-14分为1组，要写成
select * 
from table
group by floor((num + 6) / 7)

