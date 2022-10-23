select * from Project1.dbo.Data1;
select * from Project1.dbo.Sheet1;
--count sum of rows
select count(*) from Project1..data1
select count(*) from Project1..Sheet1
--display data of state Jharkand and bihar
select * from Project1..Data1 where state in ('Jharkhand' ,'Bihar')
select sum(population) as Population from Project1..Sheet1
--average growth
select AVG(Growth) as average from Project1..Data1

select state,avg(growth)*100 as avgerage_growth from Project1..Data1 group by state;

select state,round(avg(sex_ratio),0) as average from Project1..Data1 group by state;
--avg ratio
select state,round(avg(literacy),0) avg_literacy_ratio from Project1..Data1 
group by state having round(avg(literacy),0)>90 order by avg_literacy_ratio desc ;

--TOP 3 STATE WITH HIHG GROWTH RATE

select State,AVG(Growth)*100 as avg_growth from Project1..Data1
group by state order by avg_growth desc limit 3;

--bottom 3 state showing lowest sex ratio
select top 3 state,round(avg(sex_ratio),0) avg_sex_ratio from Project1..Data1 group by state order by avg_sex_ratio asc;

-- top and bottom 3 states in literacy state

drop table if exists #topstates;
create table #topstates
( state nvarchar(255),
  topstate float

  )

insert into #topstates
select state,round(avg(literacy),0) avg_literacy_ratio from Project1..Data1
group by state order by avg_literacy_ratio desc;


drop table if exists #bottomstates;
create table bottomstates
( state nvarchar(255),
  bottomstate float

  )

  insert into bottomstates
select state,round(avg(literacy),0) avg_literacy_ratio from Project1..Data1 
group by state order by avg_literacy_ratio desc;

-- joining both table

--total males and females

select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from Project1..Data1 a inner join Project1..Sheet1 b on a.district=b.district ) c) d
group by d.state;

-- total literacy rate


select c.state,sum(literate_people) total_literate_pop,sum(illiterate_people) total_lliterate_pop from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from Project1..Data1 a 
inner join Project1..Sheet1 b on a.district=b.district) d) c
group by c.state

-- population in previous census


select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from Project1..Data1 a inner join Project1..Sheet1 b on a.district=b.district) d) e
group by e.state)m


