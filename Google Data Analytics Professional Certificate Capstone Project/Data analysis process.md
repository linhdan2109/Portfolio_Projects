# The Six Data Analysis Phases

## Table of contents
[1. Ask](#Ask)


[2. Prepare](#Prepare)


[3. Process](#Process)


[4. Analyze](#Analyze)


[5. Share](#Share)


[6. Act](#Act)

## 1. Ask <a name="Ask"></a>
### Identify the business task:
- Focus on a Bellabeat product: "Bellabeat membership" and analyze smart device usage data in order to gain insight into how people are already using their smart devices. 
- Then, using this information, make high-level recommendations for how these trends can inform Bellabeat marketing strategy for the "Bellabeat membership" 
product. 

### Questions to Analyze:
1. What are some trends in smart device usage?
2. How could these trends apply to Bellabeat customers?
3. How could these trends help influence Bellabeat marketing strategy?

## 2. Prepare <a name="Prepare"></a>
### Data Source:
Use public data that explores smart device users’ daily habits: [FitBit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit). 
The data has been made available by [Mobius](https://www.kaggle.com/arashnic)
### Data organization:
- File naming convention: [time unit][measurement item][data format]__merged
- Content: Each file contains 3 main parts: Id, ActivityTime, measurement results.
### The credibility of the data
This Kaggle data set contains personal fitness tracker from thirty fitbit users. Thirty eligible Fitbit users consented to the submission of
personal tracker data, including minute-level output for physical activity, heart rate, and sleep monitoring. It includes
information about daily activity, steps, and heart rate that can be used to explore users’ habits

## 3. Process <a name="Process"></a>
I have used Microsoft Excel and SQL for data validation and cleaning.
- [Microsoft Excel](#Excel)
- [SQL](#SQL)
### Microsoft Excel <a name="Excel"></a>
- By scanning through data in Excel worksheet, the general outline and basic information can be found which enable me to get familiarize with the dataset
- Use Filter in Excel to check if there are any invalid/ incorrect / unusable data data in every columns. I don't seen any invalid data.
- Use Conditional Formatting to check if there are any NULL values. 
![image](https://user-images.githubusercontent.com/85982220/196919581-d7d24531-86db-414b-ae53-4a76d70c5a3a.png)
- Use Soft in Excelt to soft the data by Id and ActivityTime to make it easier to read and easier to understand the data.
- Use Remove Duplicates in Power Query in Excel to check duplicates and remove it. I don't see any duplicate.
![image](https://user-images.githubusercontent.com/85982220/196922975-5e6e3284-c8bf-4f59-a75d-44a92540c10d.png)
![image](https://user-images.githubusercontent.com/85982220/196923014-a1ffa533-93dc-4f87-9399-d0cbd52bb482.png)
### SQL <a name="SQL"></a>
- [Click here](https://github.com/linhdan2109/Portfolio_Projects/blob/main/Google%20Data%20Analytics%20Professional%20Certificate%20Capstone%20Project/SQL_ProcessPharse.sql) to see the code of SQL in this process step.
- Load some tables that will be used for the Analysis pharse into SSMS. There are 6 tables that will be used, and they are stored in the database name 'Bellabeat'.

  ![image](https://user-images.githubusercontent.com/85982220/196999858-993f1995-a939-436f-94ee-6e5782edaa1a.png)

- View table schema of 6 tables: We can see the data type of every columns and the table doesn't have any NULL values
![image](https://user-images.githubusercontent.com/85982220/197016878-c4610588-c52c-4b58-b84d-d69720c0ba20.png)

- View a number of rows in the dailyActivity_merged table
![image](https://user-images.githubusercontent.com/85982220/197001812-ecbf2a14-e48b-42df-91cd-577cfca2d7f2.png)
- Size of the tables. The dailyActivity_merged table have 940 records, The hourlyCalories have 22099 records,...


   ![image](https://user-images.githubusercontent.com/85982220/197015373-ef7c024d-bcb1-44fa-8e40-412f594ee362.png)
- As the author says, the data is collected from 3/12/2016 - 5/12/2016. So I will check if the date in the dateset fit their meaning.
The result shows that there are no data points that are outside the range from 3/12/2016 to 5/12/2016.


   ![image](https://user-images.githubusercontent.com/85982220/197007439-6a897606-6d4f-4c9f-a08f-61fedebe2e33.png)
-  As the author says, the data is collected from 30 users. Check to see if we have 30 users. The dataset has 33 user data from daily activity, 24 from sleep and only 8 from weight. The result shows the dataset is inconsistent as we expect 30 unique Id on all tables.


   ![image](https://user-images.githubusercontent.com/85982220/197012238-dcced94a-3549-44f1-9d68-8b61d3ebce1a.png)

- Records which are dubplicate. The result shows that there are no duplicate


   ![image](https://user-images.githubusercontent.com/85982220/197008764-83b8dd02-b0b4-4352-a638-a74b17a7a60f.png)
- Add a column for day of the week


   ![image](https://user-images.githubusercontent.com/85982220/197024916-ebd482dc-4c89-4a6e-ac51-2964ce7a7a22.png)
- Add a column to calculate total minutes using smart device per day in the DailyActivity table. Total minutes is calculated by adding 4 column: VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes


![image](https://user-images.githubusercontent.com/85982220/198982457-6187c8b7-f2d0-4486-9f73-abef8f5ae5ec.png)


## 4. Analyze <a name="Analyze"></a>
[Click here](https://github.com/linhdan2109/Portfolio_Projects/blob/main/Google%20Data%20Analytics%20Professional%20Certificate%20Capstone%20Project/SQL_AnalyzePharse.sql) to see the code of SQL in this analyze step.


[4.1. BMI](#BMI)


[4.2. Sleeptime](#Sleeptime)


[4.3. Active minutes](#Activeminutes)


[4.4. Calories](#Calories)


[4.5. Total Steps](#TotalSteps)


[4.6. Frequency of smart device use](#Frequency)


### 4.1. BMI <a name="BMI"></a>
- [BMI by UserID](#BMIbyUser)
#### BMI by UserID <a name="BMIbyUser"></a>
According to [Centers for Disease Control and Prevention](https://www.cdc.gov/obesity/basics/adult-defining.html#:~:text=If%20your%20BMI%20is%20less,falls%20within%20the%20obesity%20range.):
- If your BMI is less than 18.5, it falls within the underweight range.
- If your BMI is 18.5 to <25, it falls within the healthy weight range.
- If your BMI is 25.0 to <30, it falls within the overweight range.
- If your BMI is 30.0 or higher, it falls within the obesity range.


As we discuss earlier, there are only 8 users in the WeightLogInfor table.


This is the donut chart showing the latest BMI of those 8 users. There are 3 users with normal BMI, 4 users falls within the overweight range and 1 within the obesity range. 


![image](https://user-images.githubusercontent.com/85982220/198885214-70f915c9-0f9b-405a-ab27-f33ffbece38e.png)


**Recommendation:**


&rarr; Based on BMI, we can divide customers into 4 groups: underweight, healthy weight, overweight and obesity. Then, we develop the membership program with personalized guidance on nutrition, activity, and sleep that match their BMI. For example:
  - For users fall within the underweight range: We should advertise and suggest them The Membership program that help them gain weight.
  - For users fall within the healthy weight range: We can recommend programs that fit their fitness goals and provide instructions that prevent them from unwanted weight gain from excess body fat.
  - For users fall within the overweight range: We should advertise the ability to help them lose weight.
  - For users fall within the obesity range: Provide Obesity Treatment based on their specific condition. We need a detailed personalized guidance on their diet, exercise and mental health for them.
  
  
  &rarr; We need to investigate the Weight Status of most customers to know which group of our customers mainly belong to. Then develop marketing campaigns suitable for that key customer group.


&rarr; Of course, the amount of data above is too small to analyze. We should retest this section with a larger amount of data.


### 4.2. Sleeptime <a name="Sleeptime"></a>
- [%Sleeptime In Bed by UserID](#SleeptimebyUserID)
- [%Sleeptime In Bed by Weekday](#SleeptimebyWeekday)

From the data, I find that our users spend about 91% of time in bed to sleep at night.
#### %Sleeptime In Bed by UserID <a name="SleeptimebyUserID"></a>
Now lets take a look at each user's Sleeptime. There are 24 users in the SleepDay table.


I calculate the ratio of the time users actually sleep compared to their time in bed to find %Sleeptime In Bed of each User. Then take the average of the %Sleeptime In Bed ratio for each user. 
- User have **good sleep quality** when the average of the %Sleeptime In Bed ratio is higher than 85%
- User have **poor sleep quality** when the average of the %Sleeptime In Bed ratio is lower than 85%


This donut chart showing percentage of users with good sleep quality vs users poor sleep quality


![image](https://user-images.githubusercontent.com/85982220/198886531-88cc5bed-598f-4e43-aa03-f641830dbc32.png)


We find that the majority of users have good sleep quality (most users sleep above 90% the time they in bed). But there are 2 users who have problems with their sleep (they only sleep about 60% the time they in bed)


**Recommendation:**

&rarr; For the Bellabeat membership product, we should research and construct a program that offer solutions to help them improve their sleep. This program not only help people with sleep problems but also help normal people to have a deeper and better sleep. 
#### %Sleeptime In bed by Weekday <a name="SleeptimebyWeekday"></a>
The following table shows exact number of the average sleep hours of a user over the days of the week. 


![image](https://user-images.githubusercontent.com/85982220/198838437-118257ff-fc0b-4a43-8024-6f53afce90f7.png)


From the table we find that on Sunday users tend to spend more time in bed and users tend to sleep more on Sunday than other days.


And on Thursday they spend the the least amount of time for sleeping. 


But keep in mind we have 2 users with very poor sleep quality (UserID: 1844505072 and 3977333714). I assume these are the outlines and remove it. After remove the outliners, we have the average sleep hours of a user over the weekdays in the following table:


![image](https://user-images.githubusercontent.com/85982220/198839665-fd309591-3a5a-435d-a5ac-4c37bae95427.png)


Indeed, Friday is the day when normal users spend the least time in bed and sleep the least. Sunday is still the day normal users sleep the most.


But these are exact number of hours of sleep. We see that the number of hours in bed is quite varied between the days of the week. To know more about sleep quality, again, I use the average of the %Sleeptime In Bed ratio for each weekday. The results is in the table below


![image](https://user-images.githubusercontent.com/85982220/198888135-0635e48c-0744-4d81-9624-524d8eb76cdf.png)


From the table, we see that there was not much difference in the sleep quality of the users between the days of the week


**Recommendation:**


&rarr; The [American Academy of Pediatrics](https://publications.aap.org/aapnews/news/6630?autologincheck=redirected?nfToken=00000000-0000-0000-0000-000000000000) and the [Centers for Disease Control and Prevention](https://www.cdc.gov/sleep/about_sleep/how_much_sleep.html) offer the sleep time for an aldults is 7 to 9 hours per day. 


&rarr; We can help our users figure out what time to go to bed based on their wake up time and their percentage %Sleeptime In bed. We also send notifications reminding them to go to bed on time.
### 4.3. Active minutes <a name="Activeminutes"></a>
- [%Active Minutes by Weekday](#ActiveMinutesbyWeekday)
- [%Intensity by hour in a day](#ActiveMinutesbyHour)
- [Total Minutes as sleep vs Sedentary Minutes](#TotalMinutesassleepvsSedentaryMinutes)

There are 4 states of physical activity: Very active, Fairly active, Lightly active and Sedentary.


From the table, we can see that users spent most of their time (81.3% of their daily activity) in sedentary minutes, 15.8% in lightly active minutes and only 1.74% in very active minutes.


![image](https://user-images.githubusercontent.com/85982220/198888752-e84c96a0-a889-4f49-b99a-bfb37653b5c0.png)


The time users spend in a day on 4 states of physical activity is:
- Sedentary minutes: 19.5 hours 
- Lightly active: 4 hours
- Fairly active: 15 minutes 
- Very active: 30 minutes


**Recommendation:**


&rarr; Users should reduce the sedentary minutes and increase time in lightly active


&rarr; I recommend adding small tasks in the Bellabeat membership program to encourage users to reduce the sedentary minutes, increase time in lightly active like:
-  Stretch their shoulder 5 minutes after 1 hour of sitting continuously.
-  Do a light exercise for 15 minutes after wake up and befor go to sleep.
-  Clean the room for every week.
-  Take a walk for about 30 minutes at weekend.


&rarr; For the marketing stragegy, We can give them coupon codes for the Bellabeat products or reduce the price of bellabeat Membership Program or a small gift if they complete enough tasks.
#### %Active Minutes by Weekday <a name="ActiveMinutesbyWeekday"></a>


There is a slightly different in %Active Minutes between days of the week.


![image](https://user-images.githubusercontent.com/85982220/198888690-19d87e42-cb87-4a05-8710-552d5fff3712.png)


Look at the bar graph below, we see that on Friday and Saturday users spent less minutes in sedentary (%SedentaryMinutes decreases about 1% to 2%) and take more minutes in lightly active minutes. It shows that after the end of a working week, users are motivated to become more active.


![image](https://user-images.githubusercontent.com/85982220/198888411-e3d3701b-68f7-4843-8610-f0d338befca5.png)


But that motivation usually doesn't last long. On Sundays users tend to be more sedentary than working day.


![image](https://user-images.githubusercontent.com/85982220/198888419-59405d89-5a60-462e-946a-4f8985557cc9.png)


**Recommendation:**


&rarr; Every Saturday night and Sunday morning, I recommend creating post on social media about the benefits of being active, motivating users to be more active on Sunday, encouraging them to use the Bellabeat Membership Program.


&rarr; I also recommend creating challenges on every Sunday with hashtag on social media (Ex: #ActiveOnSundayWithBellabeat). Every week is a different challenge, different exercise to create excitement for users.
#### %Intensity by hour in a day <a name="ActiveMinutesbyHour"></a>
Total Intensity by hour is the value calculated by adding all the minute-level intensity values that occurred within the hour.


Intensity value for the given minute is calculated by:
- 0 = Sedentary
- 1 = Light
- 2 = Moderate 
- 3 = Very Active


Now look at the line chart to to have a clearer view of the users' intensity trend. The line chart shows the change in the average intensity of a user over hours in a day. 


![image](https://user-images.githubusercontent.com/85982220/198888468-0943f254-0e1f-4b71-8507-d55118bf31fa.png)
- Intensity tends to increase sharply from 4 am to 8 am. This is the time to start a new day, people change their state quickly from relaxed to active, so we can see such a rapid change.
- Then the intensity continued to increase slowly until 11 am. 
- Intensity tends to decrease slightly from 12pm to 3pm. This is the time when they take a light break from an active morning
- Then the intensity increases again and peaks between 5pm and 7pm. The chart shows that users are most active in the time frame from 5pm to 7pm during the day.
- Finanly, the intensity tends to decrease sharply (from 19 to 4) in the time frame from 8 pm to 4 am. 
This is the user's time to rest after a day.


**Recommendation:**

&rarr; I find that users are highly active between 5 pm and 7 pm, we should send email and notification to remind users to use Bellabeat Membership Product to watch the exercise instructions in product between 5pm to 7pm.


#### Total Minutes as sleep vs Sedentary Minutes <a name="TotalMinutesassleepvsSedentaryMinutes"></a>
Following is the correlogram of Total minutes as sleep compare with total minutes in sedentary activity:


![image](https://user-images.githubusercontent.com/85982220/198999614-e3434253-fc23-4288-8a28-a425c9738e17.png)


The correlogram shows that users who spend much time in sedentary minutes tend to sleep less. 


**Recommendation:**

&rarr; With the group of users who have a sedentary lifestyle, Bellabeat can focus the advertisement on how sedentary behavior can affect sleep. We should email them studies have shown that exercise improves sleep quality, and sugest them some Membership program with light exercise.


### 4.4. Calories <a name="Calories"></a>
- [Calories by userId](#CaloriesbyUserId)
- [Calories by weekday](#CaloriesbyWeekday)
- [Calories by hour in a day](#CaloriesbyHour)
#### Calories by userId <a name="CaloriesbyUserId"></a>
There are variation in calories burning among users. The following chart is a histogram showing the distribution of the burning calorie among users by day


![image](https://user-images.githubusercontent.com/85982220/198889852-4ba367bb-0e64-4fa6-83c7-5818d2c7a234.png)


**Recommendation:**


&rarr; The number of calories that need to burn each day is different for each user. It depends on many factors such as weight, BMI, ,lifestyle, fitness goals,... 


&rarr; We should collect all of that information of our users and give them the most suitable calorie level. From that, the Bellabeat Membership Product can suggest the diet and exercise guide to achieve that calorie level.


#### Calories by weekday <a name="CaloriesbyWeekday"></a>
The chart below shows the the average burning calories in a day per user across the days of the week.
We see that Tuesday is the day when the highest number of calories are burned. Then followed by Saturday and Friday which are the 2nd and 3rd highest calories burned.


![image](https://user-images.githubusercontent.com/85982220/198890534-6d9a2660-9d18-402e-9d4d-0faf3a67a521.png)


The days with the least calories burned are Sunday and Thursday.


![image](https://user-images.githubusercontent.com/85982220/198890551-dd355409-b6e7-4e86-8ae0-1d2bf05564af.png)


#### Calories by hour in a day <a name="CaloriesbyHour"></a>
Trend shows the burning calories between hours in a day is showed in the line chart below


![image](https://user-images.githubusercontent.com/85982220/198890723-44438506-be86-4ccf-aacc-242cf6ecfffb.png)


I found that the trend of average calories burned was similar to the trend of user's average intensity. This is also understandable because the higher the intensity of activity, the more calories burned. 


### 4.5. Total Steps <a name="TotalSteps"></a>
- [Total Steps by userId](#TotalStepsbyUserId)
- [Total Steps by weekday](#TotalStepsbyWeekday)
- [Total Steps by hour in a day](#TotalStepsbyHour)
#### Total Steps by userId <a name="TotalStepsbyUserId"></a>
As well as the number of calories burned, the total number of steps also varies between individuals. 
This is the histogram showing the distribution of total steps in a day per user


![image](https://user-images.githubusercontent.com/85982220/198891271-8a7c8317-ad2a-4b70-8032-9904097e07ef.png)


Most users have a daily total steps of 5000 - 10000 steps and the frequency of users walking less than 5,000 steps a day is still quite high.

**Recommendation:**


&rarr; Share this information with users, shows that they are lacking in exercise and remind them that lack of exercise is a major cause of health problem. 


&rarr; Create fitness challenges to encourage users to walk more and there will be a reward for them after reaching the required number of kilometers.
#### Total Steps by weekday <a name="TotalStepsbyWeekday"></a>
The chart below shows the the average total steps in a day per user across the days of the week
We see that Saturday is the day when the highest number of total steps. Then followed by Tuesday which are the 2nd total steps.


![image](https://user-images.githubusercontent.com/85982220/198960480-2aaaf5b7-a884-4f2c-ad1e-0068d3f2d2a7.png)


The day with the least calories burned is Sunday.


![image](https://user-images.githubusercontent.com/85982220/198960532-f6e4f79e-59e3-4bd6-a6d9-3c43e64244fc.png)


#### Total Steps by hour in a day <a name="TotalStepsbyHour"></a>
Trend shows the total steps between hours in a day is showed in the line chart below:


![image](https://user-images.githubusercontent.com/85982220/198891456-6c8fa18a-a464-4eb0-ad49-7b1063054fb8.png)


I found that the trend of average total steps was similar to the trend of user's average intensity and the trend of average calories burned. 


### 4.6. Frequency of smart device use <a name="Frequency"></a>
Following is the histogram showing the Frequency of smart device use. 


The x-axis describes the number of hours a user uses the smart device in a day:
- 0h - 6h means that user used the device between 0 hours and 6 hours in that day.
- 6h - 12h means that user used the device between 6 hours and 12 hours in that day.
- 12h - 18h means that user used the device between 12 hours and 18 hours in that day.
- 18h - 24h means that user used the device between 18 hours and 24 hours in that day.
- Full day means that user used the device all day in that day.


The y-axis is the frequency of occurrence for each case on the x-axis


![image](https://user-images.githubusercontent.com/85982220/199003591-8496c479-b91c-4951-8424-95939c212fcc.png)


We see that there are still many cases where the user does not wear the smart device for full day. 


**Recommendation:**


&rarr; Send notification to remind the user to wear the device when they don't wear the smart device in an hour.


&rarr; Maybe for some personal reasons, the users need to remove the device for a while and they need an alarm clock that reminds them to put the device back on. So from that, Bellabeat can also provide the alarm for users to set that will ring to remind users to wear their smart device.


&rarr; With the current data set, it is not possible to check what time of day user usually not wear the device. With a more complete data set, we should analyze in what time users are not often wearing the device. From there, we will find out causes and appropriate solutions to help users not take off the device. 


## 5. Share <a name="Share"></a>
## 6. Act <a name="Act"></a>

