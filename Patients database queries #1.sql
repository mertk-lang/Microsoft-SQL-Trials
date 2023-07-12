-- Show first name, last name of the patients where gender is 'M' 
select concat(first_name, last_name) as [Patient], gender
from patients
WHERE gender = 'M'

-- Show first name and last name of patients who does not have allergies. (null)
SELECT concat(first_name, last_name)
from patients
where allergies is null

--Show first name of patients that start with the letter 'C'
SELECT first_name
from patients
where first_name like 'c%'

--Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
SELECT first_name, last_name
from patients
where weight between 100 and 120

--Update the patients table for the allergies column. If the patients allergies is null
-- then replace it with 'NKA'

Update Patients
SET allergies = 'NKA'
WHERE allergies is null

--Show first name and last name concatinated into one column to show their full name.

SELECT concat(first_name, ' ', last_name) as fullname
from patients

--Show first name, last name, and the full province name of each patient.

SELECT a.first_name
      ,a.last_name
	  ,b.province_name
FROM patients as a
JOIN province_names as b
ON a.province_id = b.province_id


--Show how many patients have a birth_date with 2010 as the birth year.

SELECT COUNT(*) as PatientCount
      ,birth_date
FROM patients
WHERE YEAR(birth_date) = 2010

--Show the first_name, last_name, and height of the patient with the greatest height.
DECLARE @MaxHeight int = (SELECT MAX(height) FROM patients)

SELECT CONCAT(first_name, ' ', last_name) as patient
	  ,height
FROM patients
WHERE height = MaxHeight

--Show unique birth years from patients and order them by ascending.
SELECT DISTINCT(year(birth_date)) as BirthYear
FROM patients
ORDER BY BirthYear asc

--Show unique first names from the patients table which only occurs once in the list.

SELECT first_names
FROM patients
GROUP BY first_names
HAVING COUNT(first_names) > 1 

--Show all columns for patients who have one of the following patient_ids:
--1,45,534,879,1000

SELECT first_name, last_name, patient_id
FROM patients
WHERE patient_id IN(1, 45, 534, 879, 1000)


--Show the total number of admissions

SELECT COUNT(*) as total_admissions
from admissions 

--Show all the columns from admissions where the patient was admitted 
--and discharged on the same day.

SELECT patient_id
	  ,admission_date
	  ,discharge_date
	  ,diagnosis
	  ,attending_doctor_id
FROM admissions
WHERE admission_date = discharge_date

--Show the patient id and the total number of admissions for patient_id 579.

SELECT patient_id
	  ,COUNT(*) as total admissions
FROM admissions
WHERE patient_id = 579

--Based on the cities that our patients live in, 
--show unique cities that are in province_id 'NS'?

SELECT DISTINCT(city) as province
	  ,province_id
FROM patients
WHERE province_id = 'NS'

--Write a query to find the first_name, last name and birth date of patients 
--who has height greater than 160 and weight greater than 70

SELECT first_name
	  ,last_name
	  ,birth_date
FROM patients 
WHERE height > 160 AND weight > 70

--Write a query to find list of patients first_name, last_name, and 
--allergies from Hamilton where allergies are not null

Select first_name
	  ,last_name
	  ,allergies
	  ,city
FROM patients
WHERE city = 'Hamilton'


--Based on cities where our patient lives in, write a query to display the list of 
--unique city starting with a vowel (a, e, i, o, u). Show the result order in ascending by city.

SELECT DISTINCT(city)
FROM patients 
WHERE city LIKE 'a%'
  OR  city LIKE 'e%'
  OR  city LIKE 'i%'
  OR  city LIKE 'o%'
  OR  city LIKE 'u%'
ORDER BY city asc