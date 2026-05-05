use banking;

-- ** Customer Insights **
-- How many active vs inactive customers are there?
select Status,count(*) as tot_customers
from dimcustomer 
group by Status

-- Which region has the most customers?
select Region,count(*) as tot_customers
from dimcustomer
group by Region
order by tot_customers desc
limit 1

-- Which gender has more customers?
select Gender,count(*) as tot_customers
from dimcustomer
group by Gender

-- Which age group opens the most accounts?
select age,count(AccountID) as total_users
from
(select c.CustomerId,a.AccountID,
case
	when TIMESTAMPDIFF(year,STR_TO_DATE(DOB,'%d/%m/%Y'),CURDATE())<25 then 'under 25'
    when TIMESTAMPDIFF(year,STR_TO_DATE(DOB,'%d/%m/%Y'),CURDATE()) between 25 and 40 then '25-40'
    when TIMESTAMPDIFF(year,STR_TO_DATE(DOB,'%d/%m/%Y'),CURDATE()) between 41 and 60 then '41-60'
    else '60+'
end as age
from dimcustomer c
join dimaccount a
on c.CustomerId=a.CustomerId
where a.Status='Open') t
group by age

-- Which customers have multiple accounts?
select a.CustomerId,c.FullName,count(a.AccountId) as total_accounts
from dimcustomer c
join dimaccount a
on c.CustomerId=a.CustomerId
group by a.CustomerId,c.FullName
having total_accounts>1
order by total_accounts desc

-- Which customers closed all their accounts?
select c.FullName,c.CustomerId
from dimcustomer c
join dimaccount a
on c.CustomerId=a.CustomerId
group by c.CustomerId,c.FullName
having count(*) = sum(case when a.Status='Closed' then 1 else 0 end)

-- Which customers have the highest balances?
select a.CustomerId,c.FullName,round(sum(a.balance),2) as balance
from dimcustomer c
join dimaccount a
on c.CustomerId=a.CustomerId 
group by a.CustomerId,c.FullName
having balance>0
order by balance desc

-- Which inactive customers still have open accounts?
select a.CustomerId,c.FullName
from dimcustomer c
join dimaccount a 
on c.CustomerId=a.CustomerId
where c.Status='Inactive' and a.Status='Open'
group by a.CustomerId,c.FullName