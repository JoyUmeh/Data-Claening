SELECT*
FROM CovidDeaths

--looking at totalcases vs totaldeaths (likelihood of dying)

SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS deathpercentage
FROM CovidDeaths

--likelihood of dying in a particular place eg Nigeria

SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS deathpercentage
FROM CovidDeaths
WHERE location like 'Nigeria'

-- looking at total cases vs population

SELECT Location, date, total_cases, population, (total_cases/population)*100 AS population_infected
FROM CovidDeaths

-- country with highest infection rate

SELECT location, population, MAX(total_cases) AS Highestinfectioncount, MAX((total_cases/population))*100 AS Percentpopulationinfected
FROM CovidDeaths
GROUP BY location,population
ORDER BY Percentpopulationinfected desc

-- country with highest death per population

SELECT Location, population, MAX(total_deaths) AS Totaldeathcount, MAX((total_deaths/population))*100 AS Percentdeathcount
FROM CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY Percentdeathcount desc

-- Continent with highest deathcount

SELECT location, population, MAX(Total_deaths) AS Deathcount, Max((total_deaths/population))*100 AS Cdeathcount
FROM CovidDeaths
WHERE continent is null
GROUP BY location, population
ORDER BY Cdeathcount desc

-- global numbers

SELECT Date, SUM(New_cases) AS Totalcases, SUM(CAST(New_deaths as int)) AS Totaldeaths, SUM(cast(New_deaths as int))/SUM(New_cases)*100 AS Deathpercentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY Date
ORDER BY 1,2

-- JOINS

SELECT*
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location= vac.location
and dea.date= vac.date

-- total population vs vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations )) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS Rollingpeoplevaccination
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location= vac.location
and dea.date= vac.date
WHERE dea.continent is not null
 
 -- % of vaccination per populatiom
 -- using CTE

 WITH POPVSVAC (continent, location, date, population, new_vaccination, Rollingpeoplevaccination)
 AS (
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations )) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS Rollingpeoplevaccination
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT*, (Rollingpeoplevaccination/population)*100 AS Percentage_vaccinated
FROM POPVSVAC

--% of vaccination per populatiom
 -- using temp tables

 DROP TABLE if exists #Populationvsvaccination
 CREATE Table #Populationvsvaccination
 (
 Continent nvarchar (255),
 location nvarchar (255),
 Date datetime,
 population numeric,
 New_vaccinations numeric,
 Rollingpeoplevaccination numeric
 )

 INSERT INTO #Populationvsvaccination
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations )) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS Rollingpeoplevaccination
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
SELECT*, (Rollingpeoplevaccination/population)*100 AS Percentage_vaccinated
FROM #Populationvsvaccination

-- creating views to store data for later visualization

CREATE VIEW totalcasesvstotaldeaths AS
SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS deathpercentage
FROM CovidDeaths

CREATE VIEW totalcasevspopulation AS
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS population_infected
FROM CovidDeaths

CREATE VIEW countrywithhighestinfection AS
SELECT location, population, MAX(total_cases) AS Highestinfectioncount, MAX((total_cases/population))*100 AS Percentpopulationinfected
FROM CovidDeaths
GROUP BY location,population