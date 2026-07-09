--Point the script to the right database
USE AutoCareDB
GO;

--Create a view from the Cleandata
CREATE OR ALTER VIEW vw_AdmissionData AS
--Creating a CTE(temp table) called "Cleandata", to extract non-duplicate data
WITH CleanData as
(
--Selecting all the data to identify duplicate using "Dup_No" colm using window func
SELECT *,
ROW_NUMBER() OVER(PARTITION BY MRD_No, D_O_A, D_O_D ORDER BY MRD_No) Dup_No
FROM [AutoCareDB].dbo.[HDHI Admission data]
)
--Selecting non-duplicate data
SELECT *
FROM CleanData
WHERE Dup_No = 1 AND MRD_No IS NOT NULL
--ORDER BY MRD_No

