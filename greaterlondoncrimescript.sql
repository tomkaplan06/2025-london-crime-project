SELECT Month, COUNT(*) AS crimes_per_month
FROM all_crime
GROUP BY Month
ORDER BY crimes_per_month DESC;

SELECT 
  TRIM(SUBSTRING_INDEX(LSOA_Name, ' ', LENGTH(LSOA_Name) - LENGTH(REPLACE(LSOA_Name, ' ', '')))) AS clean_lsoa_name,
  COUNT(*) AS crime_count,
  ROUND((COUNT(*) * 100.0) / (
    SELECT COUNT(*) FROM all_crime
  ), 2) AS percentage_of_all_crime
FROM all_crime
WHERE LSOA_Name REGEXP 'Camden|City of London|Hackney|Lambeth|Croydon|Southwark|Westminster|Kensington|Brent|Ealing|Lewisham|Wandsworth|Hounslow|Tower Hamlets|Newham|Islington|Barking|Dagenham|Barnet|Bexley|Bromley|Enfield|Greenwich|Hammersmith|Harrow|Havering|Hillingdon|Haringey|Kingston|Merton|Redbridge|Richmond|Sutton|Waltham'
AND LSOA_Name NOT LIKE '%Kingston upon Hull%' 
AND LSOA_Name NOT LIKE '%Brentwood%' 
GROUP BY clean_lsoa_name
ORDER BY crime_count DESC; -- only includes the 32 boroughs of Greater London

SELECT COUNT(*) AS total_amount_of_crime
FROM all_crime;

SELECT crime_type, COUNT(*) AS count_of_crime_type,
ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM all_crime), 2) AS percentage_of_all_crime
FROM all_crime
GROUP BY crime_type
ORDER BY count_of_crime_type DESC;

SELECT last_outcome_category, COUNT(*) AS count_of_last_outcome,
ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM all_crime), 2) AS percentage_of_last_outcome_count_of_all_crime
FROM all_crime
GROUP BY last_outcome_category
ORDER BY count_of_last_outcome DESC;

SELECT 
  ROUND(Latitude, 2) AS rounded_lat,
  ROUND(Longitude, 2) AS rounded_lng,
  COUNT(*) AS crime_count,
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM all_crime), 2) AS percentage_of_lat_rounded
FROM all_crime
GROUP BY rounded_lat, rounded_lng
ORDER BY crime_count DESC;

DROP TABLE IF EXISTS london_borough_population;

CREATE TABLE london_borough_population (
  id INT PRIMARY KEY AUTO_INCREMENT,
  borough VARCHAR(50) NOT NULL,
  population_2021 INT NOT NULL
);

INSERT INTO london_borough_population (borough, population_2021) VALUES
('Barking and Dagenham', 218869),
('Barnet', 395007),
('Bexley', 250853),
('Brent', 344521),
('Bromley', 329991),
('Camden', 210390),
('Westminster', 211365),          -- renamed here
('Croydon', 397741),
('Ealing', 375340),
('Enfield', 327224),
('Greenwich', 289254),
('Hackney', 259956),
('Hammersmith', 183295),          -- renamed here
('Haringey', 261811),
('Harrow', 263448),
('Havering', 264703),
('Hillingdon', 310681),
('Hounslow', 290488),
('Islington', 216767),
('Kensington and Chelsea', 143940),
('Kingston upon Thames', 168302),
('Lambeth', 316812),
('Lewisham', 299810),
('Merton', 210709),
('Newham', 351036),
('Redbridge', 310260),
('Richmond upon Thames', 194894),
('Southwark', 306374),
('Sutton', 209602),
('Tower Hamlets', 312273),
('Waltham Forest', 278425),
('Wandsworth', 328367);

SELECT 
  borough_crime.borough,
  borough_crime.crime_count,
  pop.population_2021,
  ROUND(borough_crime.crime_count / pop.population_2021 * 1000, 2) AS crimes_per_1000_people
FROM (
  SELECT 
    CASE
      WHEN LSOA_Name LIKE '%Barking%' THEN 'Barking and Dagenham'
      WHEN LSOA_Name LIKE '%Dagenham%' THEN 'Barking and Dagenham'
      WHEN LSOA_Name LIKE '%Barnet%' THEN 'Barnet'
      WHEN LSOA_Name LIKE '%Bexley%' THEN 'Bexley'
      WHEN LSOA_Name LIKE '%Brent%' THEN 'Brent'
      WHEN LSOA_Name LIKE '%Bromley%' THEN 'Bromley'
      WHEN LSOA_Name LIKE '%Camden%' THEN 'Camden'
      WHEN LSOA_Name LIKE '%City of London%' THEN 'City of London'
      WHEN LSOA_Name LIKE '%Westminster%' THEN 'Westminster'
      WHEN LSOA_Name LIKE '%Croydon%' THEN 'Croydon'
      WHEN LSOA_Name LIKE '%Ealing%' THEN 'Ealing'
      WHEN LSOA_Name LIKE '%Enfield%' THEN 'Enfield'
      WHEN LSOA_Name LIKE '%Greenwich%' THEN 'Greenwich'
      WHEN LSOA_Name LIKE '%Hackney%' THEN 'Hackney'
      WHEN LSOA_Name LIKE '%Hammersmith%' OR LSOA_Name LIKE '%Fulham%' THEN 'Hammersmith'
      WHEN LSOA_Name LIKE '%Haringey%' THEN 'Haringey'
      WHEN LSOA_Name LIKE '%Harrow%' THEN 'Harrow'
      WHEN LSOA_Name LIKE '%Havering%' THEN 'Havering'
      WHEN LSOA_Name LIKE '%Hillingdon%' THEN 'Hillingdon'
      WHEN LSOA_Name LIKE '%Hounslow%' THEN 'Hounslow'
      WHEN LSOA_Name LIKE '%Islington%' THEN 'Islington'
      WHEN LSOA_Name LIKE '%Kensington%' THEN 'Kensington and Chelsea'
      WHEN LSOA_Name LIKE '%Kingston%' THEN 'Kingston upon Thames'
      WHEN LSOA_Name LIKE '%Lambeth%' THEN 'Lambeth'
      WHEN LSOA_Name LIKE '%Lewisham%' THEN 'Lewisham'
      WHEN LSOA_Name LIKE '%Merton%' THEN 'Merton'
      WHEN LSOA_Name LIKE '%Newham%' THEN 'Newham'
      WHEN LSOA_Name LIKE '%Redbridge%' THEN 'Redbridge'
      WHEN LSOA_Name LIKE '%Richmond%' THEN 'Richmond upon Thames'
      WHEN LSOA_Name LIKE '%Southwark%' THEN 'Southwark'
      WHEN LSOA_Name LIKE '%Sutton%' THEN 'Sutton'
      WHEN LSOA_Name LIKE '%Tower Hamlets%' THEN 'Tower Hamlets'
      WHEN LSOA_Name LIKE '%Waltham Forest%' THEN 'Waltham Forest'
      WHEN LSOA_Name LIKE '%Wandsworth%' THEN 'Wandsworth'
      ELSE 'Unknown'
    END AS borough,
    COUNT(*) AS crime_count
  FROM all_crime
  GROUP BY borough
) AS borough_crime
JOIN london_borough_population pop ON borough_crime.borough = pop.borough
WHERE borough_crime.borough != 'Unknown'
ORDER BY crimes_per_1000_people DESC;


