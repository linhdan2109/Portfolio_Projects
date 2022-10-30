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

## 4. Analyze <a name="Analyze"></a>
Click here to see the code of SQL in this analyze step.


[4.1. BMI](#BMI)


[4.2. Sleeptime](#Sleeptime)


[4.3. Active minutes](#Activeminutes)


[4.4. Calories](#Calories)


[4.5. Total Steps](#TotalSteps)


[4.6. Relationship](#Relationship)


### 4.1. BMI <a name="BMI"></a>
- [BMI by UserID](#BMIbyUser)
#### BMI by UserID <a name="BMIbyUser"></a>


As we discuss earlier, there are only 8 users in the WeightLogInfor table.


This is the table showing the latest BMI of those 8 users. There are 3 users with normal BMI, 4 users falls within the overweight range and 1 within the obesity range. 


![image](https://user-images.githubusercontent.com/85982220/198353291-cd27f54e-4d73-42ba-8aa6-1fbe06371da9.png)


According to [Centers for Disease Control and Prevention](https://www.cdc.gov/obesity/basics/adult-defining.html#:~:text=If%20your%20BMI%20is%20less,falls%20within%20the%20obesity%20range.):
- If your BMI is less than 18.5, it falls within the underweight range.
- If your BMI is 18.5 to <25, it falls within the healthy weight range.
- If your BMI is 25.0 to <30, it falls within the overweight range.
- If your BMI is 30.0 or higher, it falls within the obesity range.


&rarr; Based on BMI, we can divide customers into 4 groups: underweight, healthy weight, overweight and obesity. We develop the membership program with personalized guidance on nutrition, activity, and sleep that match their BMI.


&rarr; Of course, the amount of data above is too small to analyze. We should retest this section with a larger amount of data. We need to investigate the Weight Status of most customers based on their BMI, then develop a marketing strategy appropriately and have a marketing strategy suitable for each group.
### 4.2. Sleeptime <a name="Sleeptime"></a>
- [%Sleeptime In Bed by UserID](#SleeptimebyUserID)
- [%Sleeptime In Bed by Weekday](#SleeptimebyWeekday)

From the data, I find that our users spend about 91% of time in bed to sleep at night.
#### %Sleeptime In Bed by UserID <a name="SleeptimebyUserID"></a>
Now lets take a look at each user's Sleeptime. There are 24 users in the SleepDay table.


![image](https://user-images.githubusercontent.com/85982220/198359866-6cf70e53-9b17-4fe0-a2f1-3260ae80418f.png)


We find that the majority of users have good sleep quality. But there are 2 users who have problems with their sleep (they only sleep about 60% the time they in bed)


&rarr; For the Bellabeat membership product, we should research and construct a program that offer solutions to help them improve their sleep. This program not only help people with sleep problems but also help normal people to have a deeper and better sleep. 
#### %Sleeptime In bed by Weekday <a name="SleeptimebyWeekday"></a>


On sunday users tend to sleep less when they are in bed. 


![image](https://user-images.githubusercontent.com/85982220/198363878-d7db7373-f4c0-4af8-82f4-71e41851e01e.png)


But %SleeptimeInbed is only a relative percentage, not an exact number of hours of sleep. The following table shows exact number of the average sleep hours of a user over the days of the week. 


![image](https://user-images.githubusercontent.com/85982220/198838437-118257ff-fc0b-4a43-8024-6f53afce90f7.png)


From the table we find that actually on Sundays users tend to spend more time in bed, not less time for sleep. In addition, on Sunday they sleep more than workdays.


And on Thursday they spend the the least amount of time for sleeping. 


But keep in mind we have 2 users with very poor sleep quality (UserID: 1844505072 and 3977333714). I assume these are the outlines and remove it. After remove the outliners, we have the average sleep hours of a user over the weekdays in the following table:


![image](https://user-images.githubusercontent.com/85982220/198839665-fd309591-3a5a-435d-a5ac-4c37bae95427.png)


Indeed, Friday is the day when normal users spend the least time in bed and sleep the least. Sunday is still the day normal users sleep the most.


&rarr; The [American Academy of Pediatrics](https://publications.aap.org/aapnews/news/6630?autologincheck=redirected?nfToken=00000000-0000-0000-0000-000000000000) and the [Centers for Disease Control and Prevention](https://www.cdc.gov/sleep/about_sleep/how_much_sleep.html) offer the sleep time for an aldults is 7 to 9 hours per day. We can help our users figure out what time to go to bed based on their wake up time and their percentage %Sleeptime In bed. We also send notifications reminding them to go to bed on time.
### 4.3. Active minutes <a name="Activeminutes"></a>
- [%Active Minutes by Weekday](#ActiveMinutesbyWeekday)
- [%Intensity by hour in a day](#ActiveMinutesbyHour)

There are 4 states of physical activity: Very active, Fairly active, Lightly active and Sedentary.


From the table, we can see that users spent most of their time (81.3% of their daily activity) in sedentary minutes, 15.8% in lightly active minutes and only 1.74% in very active minutes.


![image](https://user-images.githubusercontent.com/85982220/198829312-084361cc-c4fb-454a-b948-0a334f98c133.png)


&rarr; The time users spend in a day on 4 states of physical activity is:
- Sedentary minutes: 19.5 hours 
- Lightly active: 4 hours
- Fairly active: 15 minutes 
- Very active: 30 minutes


&rarr; Users should reduce the sedentary minutes and increase time in lightly active


&rarr; we can add small tasks in the Bellabeat membership program to encourage users to reduce the sedentary minutes, increase time in lightly active like:
-  Stretch their shoulder 5 minutes after 1 hour of sitting continuously.
-  Do a light exercise for 15 minutes after wake up and befor go to sleep.
-  Clean the room for every week.
-  Take a walk for about 30 minutes at weekend.


&rarr; For the marketing stragegy, We can give them coupon codes for the Bellabeat products or reduce the price of bellabeat Membership Program or a small gift if they complete enough tasks.
#### %Active Minutes by Weekday <a name="ActiveMinutesbyWeekday"></a>


There is a slightly different in %Active Minutes between days of the week.


![image](https://user-images.githubusercontent.com/85982220/198829870-a9fb6d12-cd90-4d7d-a12e-151763bf6caf.png)


Look at the bar graph below, we see that on Friday and Saturday users spent less minutes in sedentary (%SedentaryMinutes decreases about 1% to 2%) and take more minutes in lightly active minutes. It shows that after the end of a working week, users are motivated to become more active.


![image](https://user-images.githubusercontent.com/85982220/198831833-15ef1fc5-79be-4afe-8485-da8ab67602a6.png)


But that motivation usually doesn't last long. On Sundays users tend to be more sedentary than working day.


![image](https://user-images.githubusercontent.com/85982220/198832305-a979e4d9-0502-41ab-8956-f166d0696b31.png)


&rarr; Every Saturday night and Sunday morning, we can create post on social media about the benefits of being active, motivating users to be more active on Sunday, encouraging them to use the Bellabeat Membership Program.
#### %Intensity by hour in a day <a name="ActiveMinutesbyHour"></a>


The table shows the average intensity of a user in a day between hours. Activity intensity tends to be high (>10) from 8 am to 10 pm. It is understandable because this is the time that the average person is active during a day.


![image](https://user-images.githubusercontent.com/85982220/198863226-07e4d1ec-313b-44a9-9fc5-ea16696c5be3.png)


Now look at the line chart to to have a clearer view of the users' intensity trend:


![image](https://user-images.githubusercontent.com/85982220/198863292-d0971327-a959-4a09-bd5f-91271b6c99c4.png)
- Intensity tends to increase sharply from 4 am to 8 am. This is the time to start a new day, people change their state quickly from relaxed to active, so we can see such a rapid change.
- Then the intensity continued to increase slowly until 11 am. 
- Intensity tends to decrease slightly from 12pm to 3pm. This is the time when they take a light break from an active morning
- Then the intensity increases again and peaks between 5pm and 7pm. The chart shows that users are most active in the time frame from 5pm to 7pm during the day.
- Finanly, the intensity tends to decrease sharply (from 19 to 4) in the time frame from 8 pm to 4 am. 
This is the user's time to rest after a day.


&rarr; I find that users are highly active between 5 pm and 7 pm, we should send email and notification to remind users to use Bellabeat Membership Product to watch the exercise instructions in product between 5pm to 7pm.
### 4.4. Calories <a name="Calories"></a>
- [Calories by userId](#CaloriesbyUserId)
- [Calories by weekday](#CaloriesbyWeekday)
- [Calories by hour in a day](#CaloriesbyHour)
#### Calories by userId <a name="CaloriesbyUserId"></a>
There are variation in calories burning among users. The burning calories among users range from 1500 cal to 3500 cal.


![image](https://user-images.githubusercontent.com/85982220/198862590-91797fdc-0677-4c42-a200-33620d78039e.png)


&rarr; The number of calories that need to burn each day is different for each user. It depends on many factors such as weight, BMI, ,lifestyle, fitness goals,... 


&rarr; We should collect all of that information of our users and give them the most suitable calorie level. From that, the Bellabeat Membership Product can suggest the diet and exercise guide to achieve that calorie level.


#### Calories by weekday <a name="CaloriesbyWeekday"></a>
The table below shows the the average burning calories in a day per user across the days of the week. The table is sorted in descending order of calories:


![image](https://user-images.githubusercontent.com/85982220/198862798-71e19b73-6ce7-48dd-b11c-5aa735efbe6b.png)


We see that Tuesday is the day when the highest number of calories are burned. Then followed by Saturday and Friday which are the 2nd and 3rd highest calories burned.


The days with the least calories burned are Sunday and Thursday.
#### Calories by hour in a day <a name="CaloriesbyHour"></a>
Trend shows the burning calories between hours in a day is showed in the table and line chart below:


![image](https://user-images.githubusercontent.com/85982220/198863008-74faf8d3-44be-49af-af30-b1db538481bc.png)


![image](https://user-images.githubusercontent.com/85982220/198863373-4bc327c4-7551-47f7-a437-d0c7d9bd73b2.png)


I found that the trend of average calories burned was similar to the trend of user's average intensity. This is also understandable because the higher the intensity of activity, the more calories burned. 
### 4.5. Total Steps <a name="TotalSteps"></a>
- [Total Steps by userId](#TotalStepsbyUserId)
- [Total Steps by weekday](#TotalStepsbyWeekday)
- [Total Steps by hour in a day](#TotalStepsbyHour)
#### Total Steps by userId <a name="TotalStepsbyUserId"></a>
As well as the number of calories burned, the total number of steps also varies between individuals. This is the table shows the average total steps in a day per user


![image](https://user-images.githubusercontent.com/85982220/198863575-f9564a24-fb92-41cc-a0ac-22a86703615c.png)
#### Total Steps by weekday <a name="TotalStepsbyWeekday"></a>
The table below shows the the average total steps in a day per user across the days of the week. The table is sorted in descending order of total steps:


![image](https://user-images.githubusercontent.com/85982220/198863664-b02439ab-4b67-4698-89ca-f7e99d7b7208.png)


We see that Tuesday is the day when the highest number of total steps. Then followed by Wednesday and Thursday which are the 2nd and 3rd highest total steps.


The days with the least calories burned are Sunday and Monday.
#### Total Steps by hour in a day <a name="TotalStepsbyHour"></a>
Trend shows the total steps between hours in a day is showed in the table and line chart below:


![image](https://user-images.githubusercontent.com/85982220/198863963-2874d3fc-09f3-4daa-af6b-258c77a01046.png)


![image](https://user-images.githubusercontent.com/85982220/198864052-3e1983e4-d9a4-4b4c-93ef-2f28671e1764.png)


I found that the trend of average total steps was similar to the trend of user's average intensity and the trend of average calories burned. 
## 5. Share <a name="Share"></a>
## 6. Act <a name="Act"></a>

