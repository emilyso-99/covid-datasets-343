drop schema if exists Covid19 cascade;
create schema Covid19;
set search_path to Covid19;

-- create domain Grade as smallint
--         default null
--         check (value>=0 and value <=100);

-- create domain CGPA as numeric(10,2)
--         default 0
--         check (value>=0 and value <=4.0);

-- create domain Campus as varchar(4)
--         not null
--         check (value in ('StG', 'UTM', 'UTSC'));

-- create domain Department as varchar(20)
--         default null
--         check (value in ('ANT', 'EEB', 'CSC', 'ENG', 'ENV', 'HIS'));

create table GovernmentPolicies(
        record_id varchar(20) primary key,
        policy integer not null,
        country varchar(40) not null,
        description varchar(40),
        date_started varchar(20) not null,
        type varchar(20),
        compliance varchar(40),
        enforcer varchar(40));

create table CovidEffects(
        date varchar(20) not null,                   -- E.g., 343
        country varchar(40) not null,      -- E.g., 'Introduction to Databases'
        total_cases integer not null,                -- E.g., 'CSC'
        new_cases integer not null,
        total_deaths integer not null,
        new_deaths integer not null,
        primary key (date,country));

create table CountryInfo(
        country varchar(20) primary key,
        population integer not null,
        population_density float not null,
        median_age float not null,
        aged_65_older real,
        aged_70_older real, 
        gdp_per_capita real not null,
        life_expectancy real);

create table FinancialAid(
		financial_id varchar(10) primary key, 
		country varchar(20) not null,
		approval_date varchar(10),
		grant_amount real,
		grant_purpose varchar(20),
		income_type varchar(30));

create table AirlineRestrictions(
		country varchar(20) primary key,
		abbreviation_code varchar(10) not null,
		x_coordinate real not null,
		y_coordinate real not null,
		publication_date varchar(20),
		info_source varchar(255),
		airline varchar(50),
		details varchar(255));

create table PoliticalUnrest(
	event_date varchar(20), 
	year integer,
	event_type varchar(40) not null, 
	event_subtype varchar(40),
	participants varchar(50),
	region varchar(40),
	country varchar(40) primary key,
	city varchar(40),
	latitude real not null,
	longitude real not null,
	data_source varchar(50),
	source_scale varchar(20),
	fatalities integer);