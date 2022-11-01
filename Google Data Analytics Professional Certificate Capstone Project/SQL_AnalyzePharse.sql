-- 1. BMI 
-- (1.1) BMI by userId
SELECT 
	Id,
	BMI
FROM
	(SELECT 
		Id,
		Date,
		BMI,
		ROW_NUMBER () OVER (PARTITION BY Id ORDER BY Date DESC) AS FindNewstDay
	 FROM [Bellabeat].[dbo].[weightLogInfo_merged]
	) temp
WHERE temp.FindNewstDay = 1

-- 2. Sleeptime
--(2.1) %SleepTimeInBed
SELECT 
	SUM(TotalMinutesAsleep)*100/SUM(TotalTimeInBed) AS Percent_SleepTimeInBed
FROM [Bellabeat].[dbo].[sleepDay_merged]

-- (2.2) %SleepTimeInBed by userId
SELECT 
	Id, 
	AVG(Percent_SleepTimeInBed) AS Avg_Percent_SleepTimeInBed
FROM
(	SELECT 
		Id,
		TotalMinutesAsleep,
		TotalTimeInBed,
		TotalMinutesAsleep*100/TotalTimeInBed AS Percent_SleepTimeInBed
	FROM [Bellabeat].[dbo].[sleepDay_merged]
) temp
GROUP BY Id

-- (2.3) %SleepTimeInBed by weekday
SELECT 
	DATENAME(weekday, SleepDay) AS Weekday,
	SUM(TotalMinutesAsleep)*100/SUM(TotalTimeInBed) AS Percent_SleepTimeInBed
FROM [Bellabeat].[dbo].[sleepDay_merged]
GROUP BY DATENAME(weekday, SleepDay)
ORDER BY CASE WHEN DATENAME(weekday, SleepDay) = 'Monday' THEN 1
		      WHEN DATENAME(weekday, SleepDay) = 'Tuesday' THEN 2
			  WHEN DATENAME(weekday, SleepDay) = 'Wednesday' THEN 3
			  WHEN DATENAME(weekday, SleepDay) = 'Thursday' THEN 4
			  WHEN DATENAME(weekday, SleepDay) = 'Friday' THEN 5
			  WHEN DATENAME(weekday, SleepDay) = 'Saturday' THEN 6
			  WHEN DATENAME(weekday, SleepDay) = 'Sunday' THEN 7
		END

-- (2.4) Average sleep hours of a user
SELECT DATENAME(weekday, SleepDay) AS Weekday
      ,ROUND(CAST(AVG(TotalMinutesAsleep) AS float)/60, 2) AS Avg_HourAsleep
      , ROUND(CAST(AVG(TotalTimeInBed) AS float)/60, 2) AS Avg_HourInBed
  FROM [Bellabeat].[dbo].[sleepDay_merged]
  GROUP BY DATENAME(weekday, SleepDay)
  ORDER BY CASE WHEN DATENAME(weekday, SleepDay) = 'Monday' THEN 1
		      WHEN DATENAME(weekday, SleepDay) = 'Tuesday' THEN 2
			  WHEN DATENAME(weekday, SleepDay) = 'Wednesday' THEN 3
			  WHEN DATENAME(weekday, SleepDay) = 'Thursday' THEN 4
			  WHEN DATENAME(weekday, SleepDay) = 'Friday' THEN 5
			  WHEN DATENAME(weekday, SleepDay) = 'Saturday' THEN 6
			  WHEN DATENAME(weekday, SleepDay) = 'Sunday' THEN 7
		END

-- (2.5) Average sleep hours of a user when remove outliners
SELECT DATENAME(weekday, SleepDay) AS Weekday
      ,ROUND(CAST(AVG(TotalMinutesAsleep) AS float)/60, 2) AS Avg_HourAsleep
      , ROUND(CAST(AVG(TotalTimeInBed) AS float)/60, 2) AS Avg_HourInBed
  FROM [Bellabeat].[dbo].[sleepDay_merged]
  WHERE NOT Id IN (1844505072, 3977333714)
  GROUP BY DATENAME(weekday, SleepDay)
  ORDER BY CASE WHEN DATENAME(weekday, SleepDay) = 'Monday' THEN 1
		      WHEN DATENAME(weekday, SleepDay) = 'Tuesday' THEN 2
			  WHEN DATENAME(weekday, SleepDay) = 'Wednesday' THEN 3
			  WHEN DATENAME(weekday, SleepDay) = 'Thursday' THEN 4
			  WHEN DATENAME(weekday, SleepDay) = 'Friday' THEN 5
			  WHEN DATENAME(weekday, SleepDay) = 'Saturday' THEN 6
			  WHEN DATENAME(weekday, SleepDay) = 'Sunday' THEN 7
		END

-- 3. Active Minutes and Intensity
-- (3.1) %Active Minutes
SELECT 
	ROUND(VeryActiveMinutes*100/Total, 2) AS [Percent_VeryActiveMinutes],
	ROUND(FairlyActiveMinutes*100/Total, 2) AS [Percent_FairlyActiveMinutes],
	ROUND(LightlyActiveMinutes*100/Total, 2) AS [Percent_LightlyActiveMinutes],
	ROUND(SedentaryMinutes*100/Total, 2) AS [Percent_SedentaryMinutes]
FROM(SELECT CAST(SUM(VeryActiveMinutes) AS float) AS VeryActiveMinutes,
			CAST(SUM(FairlyActiveMinutes) AS float) AS FairlyActiveMinutes,
			CAST(SUM(LightlyActiveMinutes) AS float) AS LightlyActiveMinutes,
			CAST(SUM(SedentaryMinutes) AS float) AS SedentaryMinutes,
			CAST(SUM(VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes) AS float) AS Total
	 FROM [Bellabeat].[dbo].[dailyActivity_merged]
	 ) temp

-- (3.2) %Active Minutes by weekday
SELECT 
	Weekday,
	ROUND(VeryActiveMinutes*100/Total, 2) AS [Percent_VeryActiveMinutes],
	ROUND(FairlyActiveMinutes*100/Total, 2) AS [Percent_FairlyActiveMinutes],
	ROUND(LightlyActiveMinutes*100/Total, 2) AS [Percent_LightlyActiveMinutes],
	ROUND(SedentaryMinutes*100/Total, 2) AS [Percent_SedentaryMinutes]
FROM(SELECT 
		DATENAME(weekday, ActivityDate) AS Weekday,
		CAST(SUM(VeryActiveMinutes) AS float) AS VeryActiveMinutes,
		CAST(SUM(FairlyActiveMinutes) AS float) AS FairlyActiveMinutes,
		CAST(SUM(LightlyActiveMinutes) AS float) AS LightlyActiveMinutes,
		CAST(SUM(SedentaryMinutes) AS float) AS SedentaryMinutes,
		CAST(SUM(VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes) AS float) AS Total
	FROM [Bellabeat].[dbo].[dailyActivity_merged]
	GROUP BY DATENAME(weekday, ActivityDate)
	 ) temp
ORDER BY CASE WHEN Weekday = 'Monday' THEN 1
		      WHEN Weekday = 'Tuesday' THEN 2
			  WHEN Weekday = 'Wednesday' THEN 3
			  WHEN Weekday = 'Thursday' THEN 4
			  WHEN Weekday = 'Friday' THEN 5
			  WHEN Weekday = 'Saturday' THEN 6
			  WHEN Weekday = 'Sunday' THEN 7
		END

-- (3.3) %Intensity by hour in a day
SELECT DATEPART(hh, [ActivityHour]) AS [Hour],
	   AVG(TotalIntensity) AS Avg_Intensity
FROM [Bellabeat].[dbo].[hourlyIntensities_merged]
GROUP BY DATEPART(hh, [ActivityHour])
ORDER BY DATEPART(hh,	[ActivityHour])

-- 4. Calories
-- (4.1) Calories by user
SELECT 
	Id,
	AVG(calories) AS Avg_Calories
FROM [Bellabeat].[dbo].[dailyActivity_merged]
GROUP BY Id

-- (4.2) Calories by weekday
SELECT 
	DATENAME(weekday, ActivityDate) AS Weekday,
	AVG(Calories) AS Calories
FROM [Bellabeat].[dbo].[dailyActivity_merged]
GROUP BY DATENAME(weekday, ActivityDate)
ORDER BY CASE WHEN DATENAME(weekday, ActivityDate) = 'Monday' THEN 1
		      WHEN DATENAME(weekday, ActivityDate) = 'Tuesday' THEN 2
			  WHEN DATENAME(weekday, ActivityDate) = 'Wednesday' THEN 3
			  WHEN DATENAME(weekday, ActivityDate) = 'Thursday' THEN 4
			  WHEN DATENAME(weekday, ActivityDate) = 'Friday' THEN 5
			  WHEN DATENAME(weekday, ActivityDate) = 'Saturday' THEN 6
			  WHEN DATENAME(weekday, ActivityDate) = 'Sunday' THEN 7
		END

-- (4.3) Calories by hour in a day
SELECT DATEPART(hh, [ActivityHour]) AS [Hour],
	   AVG(Calories) AS Avg_Calories
FROM [Bellabeat].[dbo].[hourlyCalories_merged]
GROUP BY DATEPART(hh, [ActivityHour])
ORDER BY DATEPART(hh, [ActivityHour])


-- 5. Total Steps
-- (5.1) TotalSteps by user
SELECT 
	Id,
	AVG(TotalSteps) AS Avg_TotalSteps
FROM [Bellabeat].[dbo].[dailyActivity_merged]
GROUP BY Id

-- (5.2) TotalSteps by weekday
SELECT 
	DATENAME(weekday, ActivityDate) AS Weekday,
	AVG(TotalSteps) AS Avg_TotalSteps
FROM [Bellabeat].[dbo].[dailyActivity_merged]
GROUP BY DATENAME(weekday, ActivityDate)
ORDER BY CASE WHEN DATENAME(weekday, ActivityDate) = 'Monday' THEN 1
		      WHEN DATENAME(weekday, ActivityDate) = 'Tuesday' THEN 2
			  WHEN DATENAME(weekday, ActivityDate) = 'Wednesday' THEN 3
			  WHEN DATENAME(weekday, ActivityDate) = 'Thursday' THEN 4
			  WHEN DATENAME(weekday, ActivityDate) = 'Friday' THEN 5
			  WHEN DATENAME(weekday, ActivityDate) = 'Saturday' THEN 6
			  WHEN DATENAME(weekday, ActivityDate) = 'Sunday' THEN 7
		END

-- (5.3) TotalSteps by hour in a day
SELECT DATEPART(hh, [ActivityHour]) AS [Hour],
	   AVG(StepTotal) AS Avg_TotalSteps
FROM [Bellabeat].[dbo].[hourlySteps_merged]
GROUP BY DATEPART(hh, [ActivityHour])
ORDER BY DATEPART(hh, [ActivityHour])