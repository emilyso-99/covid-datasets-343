drop schema if exists Covid19 cascade;
create schema Covid19;
set search_path to Covid19;

create table CountryInfo(
	country varchar(255) primary key,
	population bigint not null,
	population_density real,
	median_age real,
	aged_65_older real,
	aged_70_older real, 
	gdp_per_capita real,
	life_expectancy real);

create table CovidEffects(
	country varchar(255) not null,
	date varchar(20) not null,
	year integer,
	total_cases integer,
	new_cases integer not null,
	total_deaths integer,
	new_deaths integer not null,
	primary key (date,country),
	foreign key (country) references CountryInfo);

create table GovernmentPolicies(
	record_id varchar(255) primary key,
	policy varchar(255) not null,
	country varchar(255) not null,
	description text,
	date_started varchar(20) not null,
	type varchar(255) not null,
	compliance varchar(255) not null,
	enforcer varchar(255) not null,
	foreign key (country) references CountryInfo);

create table FinancialAid(
	flow_code varchar(25) not null, 
	country varchar(255) not null,
	approval_date varchar(20),
	approval_year integer,
	grant_amount real not null,
	grant_purpose varchar(255) not null,
	income_type varchar(255) not null,
	primary key (flow_code,country),
	foreign key (country) references CountryInfo);

create table AirlineRestrictions(
	country varchar(255) not null primary key,
	abbreviation_code varchar(255) not null,
	x_coordinate real not null,
	y_coordinate real not null,
	publication_date varchar(20) not null,
	publication_year integer,
	info_source varchar(255),
	airline varchar(255) not null default 'all',
	foreign key (country) references CountryInfo);

create table PoliticalUnrest(
	unrest_id varchar(255) primary key,
	event_date varchar(20) not null,
	year integer not null,
	event_type varchar(255) not null, 
	event_subtype varchar(255) not null,
	participants varchar(255) not null,
	region varchar(255) not null,
	country varchar(255) not null,
	city varchar(255) not null,
	latitude real not null,
	longitude real not null,
	source_scale varchar(255),
	fatalities integer not null default 0,
	foreign key (country) references CountryInfo);

-- check if date in GovernmentPolicies is during COVID by comparing it to earliest & latest dates in CovidEffects

create function government_policies_date_check()
	returns trigger
	as $$
		begin
			if new.date_started <= (select max(date) from CovidEffects) and new.date_started >= (select min(date) from CovidEffects) then
				return new;
			end if;
			return null;
		end;
	$$ language plpgsql;

create trigger government_policies_date_check
	before insert on GovernmentPolicies
	for each row execute procedure government_policies_date_check();

-- check if date in FinancialAid is during COVID by comparing it to the year range in CovidEffects

create function financial_aid_date_check()
	returns trigger
	as $$
		begin
			if new.approval_year <= (select max(year) from CovidEffects) and new.approval_year >= (select min(year) from CovidEffects) then
				return new;
			end if;
			return null;
		end;
	$$ language plpgsql;

create trigger financial_aid_date_check
	before insert on FinancialAid
	for each row execute procedure financial_aid_date_check();

-- check if date in AirlineRestrictions is during COVID by comparing it to the year range in CovidEffects

create function airline_restrictions_date_check()
	returns trigger
	as $$
		begin
			if new.publication_year <= (select max(year) from CovidEffects) and new.publication_year >= (select min(year) from CovidEffects) then
				return new;
			end if;
			return null;
		end;
	$$ language plpgsql;

create trigger airline_restrictions_date_check
	before insert on AirlineRestrictions
	for each row execute procedure airline_restrictions_date_check();

-- check if date in PoliticalUnrest is during COVID by comparing it to the year range iin CovidEffects

create function political_unrest_date_check()
	returns trigger
	as $$
		begin
			if new.year <= (select max(year) from CovidEffects) and new.year >= (select min(year) from CovidEffects) then
				return new;
			end if;
			return null;
		end;
	$$ language plpgsql;

create trigger political_unrest_date_check
	before insert on PoliticalUnrest
	for each row execute procedure political_unrest_date_check();
