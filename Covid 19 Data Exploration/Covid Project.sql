/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select *
	From covid_deaths
	Where continent is not null 
	order by 3,4

-- Select Data that we are going to be starting with

Select location, date, total_cases, new_cases, total_deaths, population
	From covid_deaths
	Where continent is not null 
	order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in South Africa
-- First death case was recorded on 2020-03-29	
-- At that time total cases recorded were at 1187

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
	From covid_deaths
	Where location = 'South Africa'
	and continent is not null 
	and total_deaths is not null
	order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid in Sout Africa
-- The first covid case recorded was on 2020-03-08, with two cases recorded
-- Since then there has been a total of 4072677 recorded cases
-- With only 7% of the population contracting covid
	
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
	From covid_deaths
	Where location = 'South Africa'
	and total_cases is not null
	order by 1,2

-- Countries with Highest Infection Rate compared to Population
-- Cyrus has the highest infection rate compared to their population
-- This country has a population of 896007	
-- The second country is Brunei, then San marino
	
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
	From covid_deaths
	Where total_cases is not null
	and continent is not null
	Group by Location, Population
	order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
	From covid_deaths
	Where continent is not null
	and total_deaths is not null
	Group by 1
	order by  MAX(cast(Total_deaths as int)) desc 

-- Daily Case Fatality Rate in South Africa
	
select date, new_cases, new_deaths,
	(CASE WHEN new_cases > 0 THEN (new_deaths * 100.0) / new_cases ELSE 0 END) AS CaseFatalityRate
	FROM covid_deaths
	Where location = 'South Africa'
	and continent IS NOT NULL
	ORDER BY date;

	
-- BREAKING THINGS DOWN BY CONTINENT

-- Showing continents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
	From covid_deaths
	Where continent is not null 
	Group by continent
	order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
	From covid_deaths
	where continent is not null 
	order by 1,2

-- 7-Day Moving Average of Cases and Deaths(for South Africa)

SELECT date,
	AVG(new_cases) OVER (ORDER BY date ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING) AS AvgNewCases,
	AVG(new_deaths) OVER (ORDER BY date ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING) AS AvgNewDeaths
	FROM covid_deaths
	Where location = 'South Africa'
	and continent IS NOT NULL
	ORDER BY date

-- Growth Rate of Cases and Deaths

SELECT date, new_cases,
	LAG(new_cases, 1) OVER (ORDER BY date) AS PreviousDayCases, new_deaths,
	LAG(new_deaths, 1) OVER (ORDER BY date) AS PreviousDayDeaths,
	(CASE WHEN LAG(new_cases, 1) OVER (ORDER BY date) > 0 THEN (new_cases - LAG(new_cases, 1) OVER (ORDER BY date)) / LAG(new_cases, 1) OVER (ORDER BY date) ELSE 0 END) AS GrowthRateCases,
	(CASE WHEN LAG(new_deaths, 1) OVER (ORDER BY date) > 0 THEN (new_deaths - LAG(new_deaths, 1) OVER (ORDER BY date)) / LAG(new_deaths, 1) OVER (ORDER BY date) ELSE 0 END) AS GrowthRateDeaths
	FROM covid_deaths
	WHERE continent IS NOT NULL
	ORDER BY date

-- Cumulative Cases and Deaths

SELECT date,
	SUM(new_cases) OVER (ORDER BY date) AS CumulativeCases,
	SUM(new_deaths) OVER (ORDER BY date) AS CumulativeDeaths
	FROM covid_deaths
	WHERE continent IS NOT NULL
	ORDER BY date;

-- Comparison of Cases and Deaths Between Continents

SELECT continent,
	SUM(new_cases) AS TotalCases,
	SUM(new_deaths) AS TotalDeaths
	FROM covid_deaths
	WHERE continent is not null
	GROUP BY continent
	ORDER BY TotalCases DESC

-- Total Population vs Vaccinations
-- Using CTE, shows Percentage of Population that has recieved at least one Covid Vaccine in South Africa

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_deaths dea
Join covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.location = 'South Africa'
and dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Total Booster Doses Administered

select sum(total_boosters) as TotalBoosterDoses
	from covid_vaccinations
where continent is not null

-- Booster Doses Administered Over Time

select date, sum(total_boosters) as DailyBoosterDoses
	from covid_vaccinations
	where continent is not null
	and total_boosters is not null
	group by date
	order by date

-- Booster Doses by Location

select location, sum(total_boosters) as TotalBoosterDoses
	from covid_vaccinations
	where continent is not null
	and total_boosters is not null
	group by location
	order by TotalBoosterDoses DESC
	

-- Booster Doses Compared to Initial Vaccinations

SELECT location, date, total_vaccinations, people_fully_vaccinated, total_boosters, (total_boosters / people_fully_vaccinated) * 100 AS BoosterRate
From covid_vaccinations
WHERE continent IS NOT NULL
AND people_fully_vaccinated > 0
ORDER BY location, date

-- Economic Impact and Vaccination Rates

SELECT dea.location, dea.date, vac.gdp_per_capita, vac.total_vaccinations, (vac.total_vaccinations / dea.population) * 100 AS VaccinationRate
From covid_deaths dea
Join covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.location = 'South Africa' 
and dea.continent IS NOT NULL
ORDER BY location, date

-- Vaccination Progress and Stringency of Measures

SELECT location, date, stringency_index, total_vaccinations, people_fully_vaccinated
FROM covid_vaccinations
WHERE location = 'South Africa' 
and continent IS NOT NULL
ORDER BY location, date

-- Correlation Between GDP and Vaccination Coverage

SELECT dea.location, 
AVG(vac.gdp_per_capita) AS AvgGDPPerCapita, 
AVG((vac.people_fully_vaccinated / dea.population) * 100) AS AvgFullVaccinationCoverage
From covid_deaths dea
Join covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
GROUP BY dea.location
ORDER BY AvgFullVaccinationCoverage DESC


-- Impact of Stringency on Vaccination Rates

SELECT dea.location, dea.date,
       vac.stringency_index,
       (vac.people_fully_vaccinated / dea.population) * 100 AS FullVaccinationRate
From covid_deaths dea
Join covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;

-- GDP and Stringency Index Over Time

SELECT dea.location, dea.date,
       vac.gdp_per_capita,
       vac.stringency_index
FROM covid_deaths dea
JOIN covid_vaccinations vac ON dea.iso_code = vac.iso_code AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_deaths dea
Join covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 