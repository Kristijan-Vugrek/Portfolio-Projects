﻿-- amount of each type with max power output

select zupanija, max(power) as max_power, count(type) as broj_punionica, type
from punionice
where power >0
group by zupanija, power, type
order by 2 desc

--amount of stations by county

select zupanija, sum(amount) as sum_amount
from punionice
group by zupanija
order by 2 desc


--amount of stations by county 2022

select zupanija, sum(amount) as sum_amount
from punionice
where ((created IS NOT NULL AND YEAR(CONVERT(date, created, 103)) < 2023)
      OR created IS NULL)
group by zupanija
order by 2 desc

--amount of registred EV 2022

select Zupanija_Naziv, [Električna energija] 
from popis_vozila
where Godina = 2022 
    and VrstaVozila = 'M1'
order by 1

--calculating percent of stations/registred EVs by county

select zupanija, round((([Električna energija]/(sum(dbo.punionice.amount)))*100),2) as 'EV/stations', dbo.popis_vozila.[Električna energija] as 'Registered EV', sum(dbo.punionice.amount) as 'total stations'
from Projects.dbo.punionice
join Projects.dbo.popis_vozila
on punionice.zupanija = popis_vozila.Zupanija_Naziv
where dbo.popis_vozila.Godina = 2022 
    and dbo.popis_vozila.VrstaVozila = 'M1'
	and ((dbo.punionice.created IS NOT NULL AND YEAR(CONVERT(date, dbo.punionice.created, 103)) < 2023)
      OR dbo.punionice.created IS NULL)
group by dbo.punionice.zupanija, dbo.popis_vozila.[Električna energija]
order by 2 desc

-- filtering Zagreb only for getting latitude and longitude

select MIN(name) as name, left(address, len(address) - 5) as address
from punionice
where zupanija = 'Grad Zagreb'
group by address
order by address

