-- 1. a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
--    b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

SELECT npi, SUM(total_claim_count) as stcc
FROM prescription as p
GROUP BY npi
ORDER BY stcc DESC
limit 10;

-- ANSWER - 1881634483	99707

SELECT p.npi, SUM(total_claim_count) as stcc, nppes_provider_first_name as npf, nppes_provider_last_org_name as np, specialty_description as sd
FROM prescription as p
LEFT JOIN prescriber as pr
ON p.npi = pr.npi
GROUP BY p.npi, npf, np, sd
ORDER BY stcc DESC
LIMIT 5;

-- ANSWER - 1881634483	99707	"BRUCE"	"PENDLEY"	"Family Practice"

-- 2. a. Which specialty had the most total number of claims (totaled over all drugs)?

SELECT p1.specialty_description as sd, SUM(p2.total_claim_count) as tcc
FROM prescriber as p1
INNER JOIN prescription as p2
ON p1.npi = p2.npi
GROUP BY sd
ORDER BY tcc DESC
LIMIT 1;

-- ANSWER - "Family Practice"	9752347

--  b. Which specialty had the most total number of claims for opioids?

SELECT p1.specialty_description as sd, (COUNT(d1.opioid_drug_flag) + COUNT(d1.long_acting_opioid_drug_flag)) as tcc
FROM prescriber as p1
INNER JOIN prescription as p2
ON p1.npi = p2.npi
INNER JOIN drug as d1
ON p2.drug_name = d1.drug_name
GROUP BY 1
ORDER BY 2 DESC;

-- ANSWER - "Nurse Practitioner"	351468

--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

-- 3. a. Which drug (generic_name) had the highest total drug cost?
-- ANSWER CHECK
SELECT SUM(total_drug_cost) as tdc, generic_name as gn
FROM prescription as p
INNER JOIN drug as d
ON p.drug_name = d.drug_name
GROUP BY 2
ORDER BY 1 DESC
limit 10;

-- ANSWER - 104264066.3 "INSULIN GLARGINE,HUM.REC.ANLOG"

--    b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.

SELECT generic_name AS gn, SUM(ROUND((total_drug_cost / total_day_supply), 2)) AS Cost_per_day
FROM prescription as p
INNER JOIN drug as d
ON p.drug_name = d.drug_name
GROUP BY 1
ORDER BY 2 DESC
limit 10;


-- ANSWER - "LEDIPASVIR/SOFOSBUVIR"	88270.88

-- 4. a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

SELECT p1.drug_name as dn,
(CASE WHEN d1.opioid_drug_flag = 'Y' THEN 'Opioid'
WHEN d1.antibiotic_drug_flag = 'Y' THEN 'Antibiotics'
WHEN d1.opioid_drug_flag = 'N' AND d1.antibiotic_drug_flag = 'N' THEN 'Neither' END) AS drug_type
FROM prescription as p1
INNER JOIN drug as d1
ON p1.drug_name = d1.drug_name
GROUP BY 1, 2
ORDER BY 1;

--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

SELECT p1.drug_name as dn,SUM(total_drug_cost),
(CASE WHEN d1.opioid_drug_flag = 'Y' THEN 'Opioid'
WHEN d1.antibiotic_drug_flag = 'Y' THEN 'Antibiotics'
WHEN d1.opioid_drug_flag = 'N' AND d1.antibiotic_drug_flag = 'N' THEN 'Neither' END) AS drug_type
FROM prescription as p1
INNER JOIN drug as d1
ON p1.drug_name = d1.drug_name
GROUP BY 1,3
ORDER BY 2 DESC;

SELECT p1.drug_name as dn,
(CASE WHEN d1.opioid_drug_flag = 'Y' THEN 'Opioid'
WHEN d1.antibiotic_drug_flag = 'Y' THEN 'Antibiotics'
WHEN d1.opioid_drug_flag = 'N' AND d1.antibiotic_drug_flag = 'N' THEN 'Neither' END) AS drug_type
WHERE drug_type = 'Opioid' (SELECT SUM(total_drug_cost,)
                           FROM prescriptions
                           AS omoney);
FROM prescription as p1
INNER JOIN drug as d1
ON p1.drug_name = d1.drug_name
GROUP BY 1, 2
ORDER BY 1;





-- 5. a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management') in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
    
--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.