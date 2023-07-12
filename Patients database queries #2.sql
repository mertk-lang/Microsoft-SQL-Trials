--Show patient_id and first_name from patients where their 
--first_name start and ends with 's' and is at least 6 characters long.

SELECT patient_id
	  ,first_name
FROM patients
WHERE first_name LIKE 's____%s' AND LEN(first_name) >= 6

--Show patient_id, first_name, last_name from patients 
--whos diagnosis is 'Dementia'.

SELECT a.patient_id
	  ,a.first_name
	  ,a.last_name
	  ,b.diagnosis
FROM patients as a
JOIN admissions as b
ON a.patient_id = b.patient_id
WHERE b.diagnosis = 'Dementia'

--Display every patient's first_name.
--Order the list by the length of each name and 
--then by alphbetically

SELECT first_name
FROM patients
ORDER BY LEN(first_name)
		,first_name
	 
--Show the total amount of male patients and the total 
--amount of female patients in the patients table.
--Display the two results in the same row.

SELECT
	SUM(CASE WHEN gender = 'M' THEN 1 END) as Male_count
	SUM(CASE WHEN gender = 'F' THEN 1 END) as Female_count
FROM patients

--Show first and last name, allergies from patients which have allergies 
--to either 'Penicillin' or 'Morphine'. Show results ordered 
--ascending by allergies then by first_name then by last_name.

SELECT first_name
	  ,last_name
	  ,allergies
FROM patients
WHERE allergies = 'Penicillin' OR 'Morphine'
ORDER BY allergies, first_name, last_name

--Show patient_id, diagnosis from admissions. 
--Find patients admitted multiple times for the same diagnosis.

SELECT patient_id
	  ,diagnosis
FROM Patients
GROUP BY patient_id
		,diagnosis
HAVING COUNT(*) > 1;

--Show the city and the total number of patients in the city.
--Order from most to least patients and then by city name ascending.

SELECT city 
	  ,COUNT(*) as patients
FROM patients
GROUP BY city
ORDER BY patients desc, city asc

--Show first name, last name and role of every person that is either patient or doctor.
--The roles are either "Patient" or "Doctor"

SELECT first_name
	  ,last_name
	  ,'Patient' as role
FROM patients

UNION ALL

SELECT first_name
	  ,last_name
	  ,'Doctor' as role
FROM doctors

--Show all allergies ordered by popularity. Remove NULL values from query.

SELECT allergies
	  ,COUNT(*) as total_diagnosis
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis

--Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. 
--Sort the list starting from the earliest birth_date.

SELECT first_name
	  ,last_name
      ,birth_date
FROM patients
WHERE birth_date LIKE '197%'
order by birth_date asc

--We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. 
--Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
--EX: SMITH,jane

SELECT concat(upper(last_name), ',', LOWER(first_name)) as new_name_format
FROM patients
order by first_name desc

--Show the province_id(s), sum of height;
--where the total sum of its patient's height is greater than or equal to 7,000.
SELECT province_id
	  ,SUM(height) as TotalHeight
FROM patients
group by province_id
HAVING TotalHeight >= 7000

--Show the difference between the largest weight and smallest
--weight for patients with the last name 'Maroni'

SELECT MAX(weight) - MIN(weight) as weight_delta
FROM patients
WHERE last_name = 'Maroni'

--Show all of the days of the month (1-31) and how many admission_dates occurred on that day.
--Sort by the day with most admissions to least admissions

SELECT day(admission_date) as day_number
	  ,COUNT(*) as number_of_admissions
FROM admissions
group by day(admission_date)
order by number_of_admissions desc

--Show all columns for patient_id 542's most recent admission_date.

SELECT *
FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING
  admission_date = MAX(admission_date);

--Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
--1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
--2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

SELECT patient_id
	  ,attending_doctor_id
      ,diagnosis
FROM admissions
WHERE (patient_id%2 = 1 AND attending_doctor_id IN(1, 5, 19))
OR (attending_doctor_id LIKE '%2%' AND len(patient_id) = 3)

--Show first_name, last_name, and the total number of admissions attended for each doctor.

--Every admission has been attended by a doctor.

SELECT a.first_name
	  ,a.last_name
      ,COUNT(b.admission_date) as admissions_total
FROM doctors as a 
JOIN admissions as b  
on a.doctor_id = b.attending_doctor_id
group by a.first_name, a.last_name

--For each doctor, display their id, full name, and the first and last admission date they attended.

SELECT a.doctor_id
	  ,concat(a.first_name, ' ', a.last_name) as full_name
      ,MIN(b.admission_date) as first_admission_date
      ,MAX(b.admission_date) as last_admission_date
FROM doctors as a 
JOIN admissions as b 
ON a.doctor_id = b.attending_doctor_id
group by a.doctor_id, concat(a.first_name, ' ', a.last_name)

--Display the total amount of patients for each province. Order by descending.

select b.province_name
	  ,COUNT(a.first_name) as patient_count
FROM patients as a 
JOIN province_names as b 
ON a.province_id = b.province_id
group by b.province_name
ORDER BY patient_count desc

--For every admission, display the patient's full name, 
--their admission diagnosis, and their doctor's 
--full name who diagnosed their problem.

SELECT concat(a.first_name, ' ', a.last_name) as patient_name
	  ,b.diagnosis
      ,concat(c.first_name, ' ', c.last_name) as doctor_name
FROM patients as a 
JOIN admissions as b 
ON a.patient_id = b.patient_id
JOIN doctors as c 
ON b.attending_doctor_id = c.doctor_id
order by patient_name

--display the number of duplicate patients based on their first_name and last_name.

SELECT first_name
	  ,last_name
      ,COUNT(*)
FROM patients
group by first_name, last_name
having count(*) > 1

--Display patient's full name,
--height in the units feet rounded to 1 decimal,
--weight in the unit pounds rounded to 0 decimals,
--birth_date,
--gender non abbreviated.

--Convert CM to feet by dividing by 30.48.
--Convert KG to pounds by multiplying by 2.205.

SELECT concat(first_name, ' ', last_name) as patient_name
	  ,round(height / 30.48, 1)
      ,round(weight * 2.205, 0)
      ,birth_date
      ,CASE 
       WHEN gender = 'M' then 'Male'
       WHEN gender = 'F' THEN 'Female'
       ELSE 'gender'
       END AS gender
FROM patients