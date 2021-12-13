SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM `portfolioproject-334318.Covid.CovidDeaths` 
ORDER BY 1,2


--Total Cases vs Total Deaths--

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM `portfolioproject-334318.Covid.CovidDeaths` 
WHERE location like 'New Zealand'
ORDER BY 1,2 desc

--Total Cases vs Population--

SELECT Location, date, total_cases, population, (total_cases/population) * 100 as PercentPopulationInfected
FROM `portfolioproject-334318.Covid.CovidDeaths` 
WHERE location like 'New Zealand'
ORDER BY 1,2 desc

-- Countries with Highest Infection Rate compared to Population --

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 as PercentPopulationInfected
FROM `portfolioproject-334318.Covid.CovidDeaths` 
GROUP BY Location, population
ORDER BY PercentPopulationInfected desc

-- Countries with Highest Death count --

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM `portfolioproject-334318.Covid.CovidDeaths` 
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc

-- Global number by date --

SELECT date, SUM(new_cases) as TotalNewCases,SUM(cast(new_deaths as int)) as TotalDeathCount, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
FROM `portfolioproject-334318.Covid.CovidDeaths` 
WHERE continent is not null
GROUP BY date
ORDER BY 1,2


-- Total Population vs Vaccinations --

SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccination
FROM `portfolioproject-334318.Covid.CovidDeaths` dea
JOIN `portfolioproject-334318.Covid.CovidVaccination` vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3