use banking;
describe dimaccount;

-- ** Account Analysis **
-- Which account type is most common?
select AccountType,count(AccountId) as most_common
from dimaccount
group by AccountType
order by most_common desc

-- Which account type has highest average balance?
select AccountType,round(avg(balance),2) as avg_balance
from dimaccount
group by AccountType
having avg_balance>0
order by avg_balance desc

-- How many open vs closed accounts?
select status,count(accountid) as total_accounts
from dimaccount
group by Status

-- Which region has most closed accounts?
select c.region,count(a.accountid) as tot
from dimaccount a
join dimcustomer c
on a.customerid=c.customerid
where a.status='Closed'
group by c.region
order by tot desc
limit 1

-- Which account type gets closed the most?
select accounttype,count(accountid) as tot
from dimaccount
where status='Closed'
group by accounttype
order by tot desc

-- Which accounts have negative balances?
select customerid,accounttype,balance
from dimaccount
where balance<0

-- Which customers have both savings and credit accounts?
select a.customerid,c.fullname
from dimaccount a
join dimcustomer c
on a.customerid=c.customerid
where a.accounttype in ('Savings','Credit')
group by a.customerid,c.fullname
having count(distinct a.accounttype)=2

-- Average balance by account type
select accounttype,avg(balance) as avg_balance
from dimaccount
group by accounttype