Select *
From PortfolioProject..CovidDeaths
order by 3,4

-- Likelihood of dying if you contract covid in your country

Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location Like '%africa%'
Order by 1,2

-- Percentage of Covid cases

Select location,date,total_cases,population, (total_cases/population)*100 as CovidPercentage
From PortfolioProject..CovidDeaths
Where location Like '%africa%'
Order by 1,2

--Countries with Highest infection rate compared to population

Select location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by location,population
Order by PercentPopulationInfected desc

--Countries with Highest death count per population

Select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount desc

--Continents with Highest death count per population

Select continent, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global Numbers on Death Percentage per day

Select date,SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, ISNULL(SUM(new_deaths)/ NULLIF(SUM(new_cases),0),0) *100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
Order by 1,2

--Global Numbers on Death Percentage

Select SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, ISNULL(SUM(new_deaths)/ NULLIF(SUM(new_cases),0),0) *100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2

--Looking at Total Population vs Vaccination

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as float)) Over (Partition by dea.location Order by dea.date) as RollingPeopleVaccinated,
(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
ON dea.location = vac.location
AND dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--Using CTEs

With PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated) 
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as float)) Over (Partition by dea.location Order by dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
ON dea.location = vac.location
AND dea.date = vac.date
Where dea.continent is not null
)
Select *,(RollingPeopleVaccinated/population)*100
From PopvsVac