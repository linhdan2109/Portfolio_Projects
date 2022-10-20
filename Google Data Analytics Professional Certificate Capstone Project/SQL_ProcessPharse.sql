
--Show table schema
SELECT 
	COLUMN_NAME,
	DATA_TYPE,
	IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dailyActivity_merged'
		OR TABLE_NAME = 'hourlyCalories_merged'
		OR TABLE_NAME = 'hourlyIntensities_merged'
		OR TABLE_NAME = 'hourlySteps_merged'
		OR TABLE_NAME = 'sleepDay_merged'
		OR TABLE_NAME = 'weightLogInfo_merged'

-- Show a number of rows
SELECT TOP (1000) *
FROM [Bellabeat].[dbo].[dailyActivity_merged]

-- Size of the table
SELECT COUNT(*) AS dailyActivity
FROM [Bellabeat].[dbo].[dailyActivity_merged]

SELECT COUNT(*) AS hourlyCalories
FROM [Bellabeat].[dbo].[hourlyCalories_merged]

SELECT COUNT(*) AS hourlyIntensities
FROM [Bellabeat].[dbo].[hourlyIntensities_merged]

SELECT COUNT(*) AS hourlySteps
FROM [Bellabeat].[dbo].[hourlySteps_merged]

SELECT COUNT(*) AS sleepDay
FROM [Bellabeat].[dbo].[sleepDay_merged]

SELECT COUNT(*) AS weightLogInfo
FROM [Bellabeat].[dbo].[weightLogInfo_merged]

-- Check if the date in the dateset fit in the range 3/12/2016 - 5/12/2016
SELECT DISTINCT ActivityDate 
FROM [Bellabeat].[dbo].[dailyActivity_merged]
WHERE NOT(ActivityDate BETWEEN '2016-03-12' AND '2016-05-12')

SELECT DISTINCT SleepDay
FROM [Bellabeat].[dbo].[sleepDay_merged]
WHERE NOT(SleepDay BETWEEN '2016-03-12' AND '2016-05-12')

SELECT DISTINCT Date 
FROM [Bellabeat].[dbo].[weightLogInfo_merged]
WHERE NOT(Date BETWEEN '2016-03-12' AND '2016-05-12')

-- Check to see if we have 30 users
SELECT COUNT(DISTINCT Id) AS dailyActivity
FROM [Bellabeat].[dbo].[dailyActivity_merged]

SELECT COUNT(DISTINCT Id) AS sleepDay
FROM [Bellabeat].[dbo].[sleepDay_merged]

SELECT COUNT(DISTINCT Id) AS weightLogInfo
FROM [Bellabeat].[dbo].[weightLogInfo_merged]


-- Show records which are suplicate
SELECT 
	Id,
	ActivityDate, 
	COUNT (*) AS Num_record
FROM [Bellabeat].[dbo].[dailyActivity_merged]
GROUP BY Id, ActivityDate
HAVING COUNT(*) >= 2

