SELECT *
FROM vw_AdmissionData

--Q1 Total Discharges
SELECT COUNT(*) AS Total_Discharges
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'

--Q2 Avg Daily Dischagre Rate
--It is total discharges divided by the total length of stay
SELECT 
(SELECT COUNT(*) AS Total_Discharges
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE') / (SELECT SUM(DURATION_OF_STAY) AS Total_length_of_stay
FROM vw_AdmissionData)

--casting this
SELECT
	CAST(
		CAST((SELECT COUNT(*) AS Total_Discharges
		FROM vw_AdmissionData
		WHERE OUTCOME = 'DISCHARGE') AS FLOAT)/
		CAST((SELECT SUM(DURATION_OF_STAY) AS Total_length_of_stay
		FROM vw_AdmissionData) AS FLOAT)
	AS decimal(10,2)) * 100 AS Avg_Daily_DischargeRate


-- Avoiding Subqueries
SELECT
	ROUND(SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END)/
	SUM(DURATION_OF_STAY),2) * 100 AS Avg_Daily_DischargeRate
FROM vw_AdmissionData


-- Q3 Avg Length of Stay 
-- It is total length of stay divided by total Discharges 
-- Reverse of Q2
SELECT
	ROUND(SUM(DURATION_OF_STAY)/SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END),0) AS Avg_length_of_stay
FROM vw_AdmissionData

-- Q4 Distribution of Discharges by age group
-- <16 Paediatric
-- 16 < 65 Adult
-- >= 65 Senior Citizen
SELECT CASE
			WHEN AGE < 16 THEN 'Paediatric'
			WHEN AGE < 65 THEN 'Adult'
			WHEN AGE >=65 THEN 'Senior Citizen'
			ELSE 'UNKNOWN'
		END AS Age_Group, COUNT(*) AS Age_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY CASE
			WHEN AGE < 16 THEN 'Paediatric'
			WHEN AGE < 65 THEN 'Adult'
			WHEN AGE >=65 THEN 'Senior Citizen'
			ELSE 'UNKNOWN'
		END
ORDER BY 2 DESC

-- Q5 Distribution By Gender
SELECT GENDER, COUNT(*) AS Gender_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY GENDER 
ORDER BY COUNT(*) DESC

-- Q6 Distribution of discharge by day of the week
SELECT DATEPART(Weekday, D_O_D) AS Day_of_week, COUNT(*) AS Day_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY DATEPART(Weekday, D_O_D)
ORDER BY Day_Distribution DESC

-- Get the day name
SELECT FORMAT(D_O_D, 'dddd') AS Day_of_week, COUNT(*) AS Day_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE' AND D_O_D IS NOT NULL
GROUP BY FORMAT(D_O_D, 'dddd')
ORDER BY Day_Distribution DESC;