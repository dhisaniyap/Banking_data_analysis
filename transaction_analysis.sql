use banking;

-- ** Transaction Analysis **
-- Which customers make most transactions?
select c.customerid,c.fullname,count(f.transactionid) as total_transaction
from dimaccount a
join facttransaction f
on a.accountid=f.accountid
join dimcustomer c
on c.customerid=a.customerid
group by c.customerid,c.fullname

-- Which region has highest transaction volume?
select c.region,count(f.transactionid) as total_transactions
from dimaccount a
join facttransaction f
on a.accountid=f.accountid
join dimcustomer c
on c.customerid=a.customerid
group by c.region
order by total_transactions desc

-- What is average transaction amount?
select round(avg(transactionamount),2) as avg_transaction
from facttransaction

-- Which transaction type is most common?
select transactiontype,count(transactionid) as tot
from facttransaction
group by transactiontype
order by tot desc

-- What is the total number of transactions and total transaction amount?
select count(*) as no_of_transactions,round(sum(abs(transactionamount)),2) as total_transaction_amount
from facttransaction

-- What is the distribution of debit vs credit transactions?
select
case
	when transactionamount>0 then 'credit'
    else 'debit'
end as transaction_flow,
count(*) as total
from facttransaction
group by transaction_flow

-- Which transaction channel is used the most?
select transactionchannel,count(*) as total
from facttransaction
group by transactionchannel
order by total desc

-- How many transactions are successful vs failed?
select status,count(*) as total
from facttransaction
group by status
order by total desc

-- Which accounts have the highest total transaction amount?
select a.accountid,round(sum(abs(f.transactionamount)),2) as transaction_amount
from facttransaction f
join dimaccount a
on f.accountid=a.accountid
group by a.accountid
order by transaction_amount desc
limit 10

-- Which accounts have the highest number of transactions?
select a.accountid,count(transactionid) as no_of_transaction
from facttransaction f
join dimaccount a
on f.accountid=a.accountid
group by a.accountid
order by no_of_transaction desc
limit 10

-- What is the average transaction amount by channel?
select transactionchannel, round(avg(abs(transactionamount)),2) as avg_transaction
from facttransaction
group by transactionchannel

-- Which transactions are unusually high compared to average?
select transactionid, transactionamount
from facttransaction
where abs(transactionamount)>
		(select avg(abs(transactionamount)) from facttransaction)

-- Which region has the highest total transaction amount?
select c.region,round(sum(abs(f.transactionamount)),2) as high_transaction
from dimaccount a
join facttransaction f on a.accountid=f.accountid
join dimcustomer c on a.customerid=c.customerid
group by c.region
order by high_transaction desc

-- Very large withdrawals?
select transactionid,transactionamount
from facttransaction 
where transactionamount<0 and
	  abs(transactionamount)>(select avg(abs(transactionamount))
						 from facttransaction
						 where transactionamount<0)
order by transactionamount asc
