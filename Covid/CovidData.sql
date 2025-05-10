#select * from covidDeaths order by 3,4 ;

#select * from CovidVaccinations order by 3,4;

select location, date , total_cases, new_cases, total_deaths,population
from coviddeaths
where continent is not null
order by 1,2;

-- Looking at Total cases vs Total Deaths
-- shows likelihood of dying if you contract covid in your country

select Location, date , total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location like '%Ind%' and continent is not null
order by 1,2;

-- Looking at total cases vs population
-- Shows what percentage of population got covid

select Location, date , total_cases, Population, (total_deaths/population)*100 as DeathPercentage
from CovidDeaths
where location like '%Ind%' and continent is not null
order by 1,2;

-- looking at countries with highest infection rate compared to population

Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from covidDeaths
where continent is not null
group by Location,Population
order by PercentPopulationInfected desc;


-- Showing the countries with highest death count oer population

Select Location, Max(Cast(Total_deaths as signed)) as Total_DeathCount
from CovidDeaths
where continent is not null
group by location
order by Total_DeathCount desc;

-- Lets break things by continent
-- showing continets with highest death count

Select continent, Max(Cast(Total_deaths as signed)) as Total_DeathCount
from CovidDeaths
where continent is not null
group by continent
order by Total_DeathCount desc;

-- Global Numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as signed)) as total_deaths, (sum(cast(new_deaths as signed))/sum(new_cases))*100 as DeathPercentage
from CovidDeaths
where Continent is not null
group by date
order by 1,2;

-- Joining the two tables


select * 
from covidvaccinations dae
join coviddeaths vac
on dae.location = vac.location
and dae.date = vac.date;


-- looking at total population vs vaccinations

Select dae.population, dae.location, dae.date, dae.continent, vac.total_vaccinations
,sum(cast(vac.total_vaccinations as signed)) over (partition by dae.location order by dae.location and dae.date) as runnning_total_vaccinations
from coviddeaths dae
join covidvaccinations vac
on dae.location = vac.location
and dae.date = vac.date
where dae.continent is not null
order by 1, 2,3 ;


-- Use CTE


with PopvsVac (Population, Location,Date,Continent,New_Vaccinations,RollingPeopleVaccinated)
as
(Select dae.population, dae.location, dae.date, dae.continent, vac.total_vaccinations
,sum(cast(vac.total_vaccinations as signed)) over (partition by dae.location order by dae.location and dae.date) as runnning_total_vaccinations
from coviddeaths dae
join covidvaccinations vac
on dae.location = vac.location
and dae.date = vac.date
where dae.continent is not null
-- order by 1, 2,3 ;)
)
select * ,(rollingPeopleVaccinated/Population)*100 as RollingVac
from PopvsVac;