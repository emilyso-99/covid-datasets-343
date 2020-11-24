

-- Q1 queries:

-- 1 a) find all countries, the government policy and political unrest that occurred on the same day
CREATE VIEW SameDayEvents AS
SELECT gp.country, event_type, compliance, fatalities, record_id, unrest_id
FROM GovernmentPolicies as gp, PoliticalUnrest as pu
WHERE gp.date_started = pu.event_date and gp.country = pu.country;

-- 1 b) find all countries whose government policy & political unrest were on the same day, AND there were fatalities
CREATE VIEW FatalEvents AS
SELECT *
FROM SameDayEvents
WHERE fatalities > 0
ORDER BY fatalities DESC;

-- 1 c) find the different amount of fatalities for events where the government policy was mandatory
CREATE VIEW UnrestAfterMandatoryPolicies AS
SELECT distinct fatalities
FROM FatalEvents
WHERE compliance LIKE '%Mandatory%';

-- 1 d) find the different amount of fatalities for events where the government policy was voluntary
CREATE VIEW UnrestAfterVoluntaryPolicies AS
SELECT distinct fatalities
FROM FatalEvents
WHERE compliance LIKE '%Voluntary%';

-- 1 e) find other political unrest a week before and after the government policies
CREATE VIEW BeforeOrAfterEvents AS
SELECT gp.country, event_type, compliance, fatalities, record_id, unrest_id
FROM GovernmentPolicies as gp, PoliticalUnrest as pu
WHERE pu.event_date < (gp.date_started + interval '7' day)::date AND pu.event_date > (gp.date_started - interval '7' day)::date
AND NOT EXISTS (
	SELECT *
	FROM SameDayEvents as sde
	WHERE sde.unrest_id = pu.unrest_id);

-- 1 f) find all countries whose government policy & political unrest were +/- 7 days AND there were fatalities
CREATE VIEW FatalEventsDiffDates AS
SELECT *
FROM BeforeOrAfterEvents
WHERE fatalities > 0
ORDER BY fatalities DESC;

-- 1 g) find the different amount of fatalities for events where the government policy (+/- 7 days) was mandatory
CREATE VIEW UnrestAfterMandatoryPoliciesDiffDates AS
SELECT distinct fatalities
FROM FatalEventsDiffDates
WHERE compliance LIKE '%Mandatory%';

-- 1 h) find the different amount of fatalities for events where the government policy (+/- 7 days) was voluntary
CREATE VIEW UnrestAfterVoluntaryPoliciesDiffDates AS
SELECT distinct fatalities
FROM FatalEventsDiffDates
WHERE compliance LIKE '%Voluntary%';

-- 1. i) countries who had no political unrest at times near / when government policies were put into place
CREATE VIEW PeacefulCountries AS
SELECT distinct country
FROM CountryInfo
WHERE country NOT IN (
	SELECT country
	FROM BeforeOrAfterEvents
) AND
	country NOT IN (
	SELECT country
	FROM SameDayEvents
);

-- Q2 queries: Did countries with certain country specifics create airline restrictions earlier?

-- 2 a) Find out the countries who had airline restrictions and order them by population density
CREATE VIEW AirlineRestrictionByPopDensity AS
SELECT ar.country, population_density, publication_date
FROM AirlineRestrictions as ar, CountryInfo as ci
WHERE ar.country = ci.country
ORDER BY population_density DESC;

-- 2 b) Find out the countries who had airline restrictions and order them by life expectancy
CREATE VIEW AirlineRestrictionByLifeExpectancy AS
SELECT ar.country, life_expectancy, publication_date
FROM AirlineRestrictions as ar, CountryInfo as ci
WHERE ar.country = ci.country
ORDER BY life_expectancy DESC;

-- 2 c) Find out the countries who had airline restrictions and order them by population size
CREATE VIEW AirlineRestrictionByPopulation AS
SELECT ar.country, population, publication_date
FROM AirlineRestrictions as ar, CountryInfo as ci
WHERE ar.country = ci.country
ORDER BY population DESC;

-- 2 d) Find out the countries who had airline restrictions and order them by gdp per capita
CREATE VIEW AirlineRestrictionByGDP AS
SELECT ar.country, gdp_per_capita, publication_date
FROM AirlineRestrictions as ar, CountryInfo as ci
WHERE ar.country = ci.country
ORDER BY gdp_per_capita DESC;

-- 2 e) Find out the countries who had airline restrictions and order them by median age
CREATE VIEW AirlineRestrictionByMediumAge AS
SELECT ar.country, median_age, publication_date
FROM AirlineRestrictions as ar, CountryInfo as ci
WHERE ar.country = ci.country
ORDER BY median_age DESC;

-- Q3 queries: 

-- 3 a) find latest date for each country
CREATE VIEW LatestCovidDate AS
SELECT country, max(date) as last_day
FROM CovidEffects
GROUP BY country;

-- 3 b) find amount of covid cases at the last day
CREATE VIEW LatestCovidCases AS
SELECT ce.country, last_day, total_cases
FROM CovidEffects as ce, LatestCovidDate as lcd
WHERE ce.date=lcd.last_day and ce.country=lcd.country;

-- 3 c) figure out how many financial aids each country got
CREATE VIEW NumFinancialAids AS
SELECT count(flow_code) as num_aids, country
FROM FinancialAid
GROUP BY country;

-- 3 d) combine the amount of covid cases & number of financial aids for each country, sort by greatest covid cases
CREATE VIEW CovidCasesAndAids AS
SELECT lcc.country, total_cases, num_aids
FROM LatestCovidCases as lcc, NumFinancialAids as nfa
WHERE lcc.country = nfa.country
ORDER BY total_cases DESC;










