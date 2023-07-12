--Show all of the patients grouped into weight groups.
--Show the total amount of patients in each weight group.
--Order the list by the weight group decending.

--For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

SELECT COUNT(*) as patient_in_group
	  ,FLOOR(weight / 10) * 10 as weight_group
FROM patients
group by FLOOR(weight / 10) * 10
order by weight_group desc

--Show patient_id, weight, height, isObese from the patients table.

--Display isObese as a boolean 0 or 1.

--Obese is defined as weight(kg)/(height(m)2) >= 30.

--weight is in units kg.

--height is in units cm.

select patient_id
	  ,weight
      ,height
      ,CASE 
       WHEN weight/POWER(height/100.0,2) >= 30 then 1
       ELSE 0
       END AS 
       isObese
FROM patients

--Show patient_id, first_name, last_name, and attending doctor's specialty.
--Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'

select a.patient_id
	  ,a.first_name
      ,a.last_name
      ,b.specialty
FROM patients as a 
JOIN admissions as c
on a.patient_id = c.patient_id
JOIN doctors as b 
ON c.attending_doctor_id = b.doctor_id
WHERE c.diagnosis = 'Epilepsy' AND b.first_name = 'Lisa'

--All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.

--The password must be the following, in order:
--1. patient_id
--2. the numerical length of patient's last_name
--3. year of patient's birth_date

select DISTINCT(b.patient_id)
      ,CONCAT(b.patient_id, LEN(a.last_name), YEAR(a.birth_date))
      as temp_password
FROM patients as a 
JOIN admissions as b 
ON a.patient_id = b.patient_id
group by b.patient_id

--Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.

--Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.

SELECT CASE 
	   WHEN patient_id % 2 = 0 THEN 'Yes'
       ELSE 'No'
       END AS has_insurance
      ,SUM(CASE
          WHEN patient_id % 2 = 0 THEN 10
          WHEN patient_id % 2 = 1 THEN 50
          ELSE patient_id
          END) as cost_after_insurance
FROM admissions
group by CASE 
	   WHEN patient_id % 2 = 0 THEN 'Yes'
       ELSE 'No'
       END

--Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name

select a.province_name
FROm province_names as a
join patients as b 
ON a.province_id = b.province_id
group by a.province_name
HAVING 
	COUNT(CASE WHEN b.gender = 'M' THEN 1 END) > 
    COUNT(case WHEN b.gender = 'F' THEN 1 END)

-- We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
-- First_name contains an 'r' after the first two letters.
-- Identifies their gender as 'F'
-- Born in February, May, or December
-- Their weight would be between 60kg and 80kg
-- Their patient_id is an odd number
-- They are from the city 'Kingston'

SELECT *
FROM patients
WHERE first_name LIKE '__r%'
	  AND gender = 'F'
      AND month(birth_date) IN(2, 5, 12)
      AND weight between 60 and 80
      AND patient_id % 2 = 1
      AND city = 'Kingston'

--Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.
SELECT CONCAT(
    ROUND(
      (
        SELECT COUNT(*)
        FROM patients
        WHERE gender = 'M'
      ) / CAST(COUNT(*) as float),
      4
    ) * 100,
    '%'
  ) as percent_of_male_patients
FROM patients;

-- For each day display the total amount of admissions on that day. Display the amount changed from the previous date.

select admission_date
	  ,COUNT(*) as admission_day
      ,COUNT(*) - LAG(COUNT(*),1) OVER (
		ORDER BY admission_date
	) as admission_count_change
FROM admissions
group by admission_date
order by admission_date ASC

-- Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.

SELECT province_name
FROM province_names
Where province_name = 'Ontario'


UNION ALL 

select province_name
from province_names
WHERE province_name != 'Ontario'

-- We need a breakdown for the total amount of admissions each doctor has started each year. Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.

SELECT a.doctor_id
	  ,concat(a.first_name, ' ', a.last_name) as doctor_full_name
      ,a.specialty
      ,YEAR(b.admission_date) as year
      ,count(admission_date) as total_admissions
FROM doctors as a 
JOIN admissions as b 
ON a.doctor_id = b.attending_doctor_id
group by doctor_full_name, year
order by doctor_full_name desc
